#!/usr/bin/env python3
"""Patch generated native app labels; no code-signing material is stored here."""
from pathlib import Path
import plistlib

manifest = Path("android/app/src/main/AndroidManifest.xml")
if manifest.exists():
    text = manifest.read_text()
    text = text.replace('android:label="vicecodes"', 'android:label="Vice Codes"')
    manifest.write_text(text)

plist = Path("ios/Runner/Info.plist")
if plist.exists():
    with plist.open("rb") as inp:
        info = plistlib.load(inp)
    info["CFBundleDisplayName"] = "Vice Codes"
    with plist.open("wb") as output:
        plistlib.dump(info, output, sort_keys=False)
