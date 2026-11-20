#!/usr/bin/env python3
"""Capture real Vice Codes Flutter UI in a headless browser at phone resolution.

The Flutter app itself is compiled for web for this test-only capture, and the
same Dart widget tree is used in the signed Android and iOS applications.
No painting/mockups/screenshots from unrelated games are used.
"""
import http.server
import socketserver
import threading
import sys
from pathlib import Path
from PIL import Image, ImageStat
from playwright.sync_api import sync_playwright

TAB_NAMES={"0":"01-cheat-datenbank","2":"02-anleitung","3":"03-ueber-die-app"}
tab=sys.argv[1]
if tab not in TAB_NAMES:
    raise SystemExit("Invalid screenshot tab")
web=Path("build/web")
if not (web/"index.html").is_file():
    raise SystemExit("Flutter web build is missing")
class Quiet(http.server.SimpleHTTPRequestHandler):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,directory=str(web),**kwargs)
    def log_message(self,*args): pass

with socketserver.TCPServer(("127.0.0.1",0),Quiet) as httpd:
    port=httpd.server_address[1]
    server=threading.Thread(target=httpd.serve_forever,daemon=True)
    server.start()
    try:
        with sync_playwright() as pw:
            browser=pw.chromium.launch(headless=True,args=["--no-sandbox","--disable-dev-shm-usage"])
            page=browser.new_page(
                viewport={"width":360,"height":800},
                device_scale_factor=3,
                is_mobile=True,
                has_touch=True,
            )
            page.goto(f"http://127.0.0.1:{port}/",wait_until="domcontentloaded",timeout=60000)
            page.wait_for_timeout(8000)
            path=Path("store/screenshots/android")/(TAB_NAMES[tab]+".png")
            path.parent.mkdir(parents=True,exist_ok=True)
            page.screenshot(path=str(path),full_page=False,animations="disabled")
            browser.close()
            with Image.open(path) as img:
                if img.size!=(1080,2400):
                    raise SystemExit(f"Incorrect store screenshot size: {img.size}")
                stat=ImageStat.Stat(img.convert("RGB"))
                if max(stat.stddev)<14:
                    raise SystemExit("Flutter page did not paint useful UI")
                unique_colors=len(img.convert("RGB").resize((60,120)).getcolors(7201) or [])
                if unique_colors<35:
                    raise SystemExit("Flutter screenshot has insufficient real UI content")
            print(f"Saved real Flutter app UI, tab={tab}, screenshot={path}, bytes={path.stat().st_size}")
    finally:
        httpd.shutdown()
