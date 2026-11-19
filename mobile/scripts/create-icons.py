#!/usr/bin/env python3
"""Generate original Vice Codes launcher icons with Python stdlib only.

This avoids copying GTA/Rockstar logos or art into published binaries.
"""
from pathlib import Path
import math
import struct
import zlib

def _line_distance(x, y, ax, ay, bx, by):
    dx, dy = bx-ax, by-ay
    u = max(0.0, min(1.0, ((x-ax)*dx + (y-ay)*dy)/(dx*dx + dy*dy + 1e-9)))
    return math.hypot(x-(ax+u*dx), y-(ay+u*dy))

def _png(size):
    # All geometry uses normalized 0..1 canvas units.
    stem = [(0.34, 0.88, 0.355, 0.70), (0.355, 0.70, 0.395, 0.52), (0.395, 0.52, 0.43, 0.35)]
    fronds = [
        (0.43,0.35,0.15,0.25), (0.43,0.35,0.22,0.13),
        (0.43,0.35,0.43,0.09), (0.43,0.35,0.63,0.13),
        (0.43,0.35,0.79,0.29), (0.43,0.35,0.77,0.47),
        (0.43,0.35,0.20,0.47),
    ]
    segments = [(a,b,c,d,0.018) for a,b,c,d in stem] + [(a,b,c,d,0.013) for a,b,c,d in fronds]
    scanlines = []
    for y in range(size):
        v = (y+.5)/size
        line = bytearray([0])
        for x in range(size):
            u = (x+.5)/size
            # Deep violet-to-coral gradient with sunset disc.
            r = int(30 + 102*v + 25*u)
            g = int(17 + 24*v + 10*u)
            b = int(46 + 38*(1-v) + 18*u)
            if (u-.68)**2 + (v-.35)**2 < .26**2:
                r = int(252 - 35*v)
                g = int(155 + 32*v)
                b = int(151 + 20*v)
            if v > .86:
                r, g, b = 23, 15, 33
            for ax,ay,bx,by,width in segments:
                if _line_distance(u,v,ax,ay,bx,by) < width:
                    r, g, b = 32, 17, 37
                    break
            line.extend((min(255,r),min(255,g),min(255,b)))
        scanlines.append(bytes(line))
    raw = b''.join(scanlines)
    def chunk(tag, data):
        return struct.pack('>I',len(data))+tag+data+struct.pack('>I',zlib.crc32(tag+data)&0xffffffff)
    return b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',size,size,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(raw,6))+chunk(b'IEND',b'')

def _current_size(path):
    with path.open('rb') as inp:
        header = inp.read(24)
    if len(header)<24 or header[:8]!=b'\x89PNG\r\n\x1a\n':
        raise SystemExit('Unexpected icon format: '+str(path))
    w,h=struct.unpack('>II',header[16:24])
    if w!=h:
        raise SystemExit('Non-square icon: '+str(path))
    return w

def main():
    store = Path('store')
    store.mkdir(exist_ok=True)
    (store/'icon-1024.png').write_bytes(_png(1024))
    folders = [Path('android/app/src/main/res'), Path('ios/Runner/Assets.xcassets/AppIcon.appiconset')]
    images = []
    for folder in folders:
        if folder.exists():
            for icon in folder.rglob('*.png'):
                if folder.name=='res' and icon.name!='ic_launcher.png':
                    continue
                images.append(icon)
    cache = {}
    for icon in images:
        size=_current_size(icon)
        if size not in cache:
            cache[size]=_png(size)
        icon.write_bytes(cache[size])
    print('Generated original store icon and',len(images),'native launcher icons')

if __name__=='__main__':
    main()
