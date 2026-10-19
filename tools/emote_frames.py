"""Animate generated emote icons (manpu) into 2-4 frames by moving their pixels.

The icons themselves are PixelLab generations (24x24). This script only moves,
hides or rotates the generated pixels, it never draws new art:
  dots     - the dots appear one by one (the first dot is the template)
  exclaim  - bounce (whole-pixel offsets)         double - same
  question - sway left/right                      anger  - pulse (bright flash + 1px rise)
  sweat    - slides down                          gloom  - rows wave sideways
  sparkle  - stars twinkle (one hidden per frame) swirl  - turns in 90-degree steps

Usage:
    python -I tools/emote_frames.py <icons_dir> <out_dir>
"""
import math
import os
import sys
from PIL import Image, ImageEnhance

SIZE = 24


def components(im):
    px = im.load()
    seen = set()
    comps = []
    for y in range(SIZE):
        for x in range(SIZE):
            if px[x, y][3] == 0 or (x, y) in seen:
                continue
            stack, comp = [(x, y)], []
            seen.add((x, y))
            while stack:
                cx, cy = stack.pop()
                comp.append((cx, cy))
                for nx in (cx - 1, cx, cx + 1):
                    for ny in (cy - 1, cy, cy + 1):
                        if 0 <= nx < SIZE and 0 <= ny < SIZE and (nx, ny) not in seen and px[nx, ny][3]:
                            seen.add((nx, ny))
                            stack.append((nx, ny))
            comps.append(comp)
    return comps


def offset(im, dx, dy):
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    out.paste(im, (dx, dy), im)
    return out


def keep(im, pixels):
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    src, dst = im.load(), out.load()
    for p in pixels:
        dst[p] = src[p]
    return out


def dots(im):
    comps = sorted((c for c in components(im) if len(c) > 4), key=lambda c: min(p[0] for p in c))
    dot = comps[0]
    colors = {p: im.getpixel(p) for p in dot}
    x0 = min(p[0] for p in dot)
    width = max(p[0] for p in dot) - x0 + 1
    step = width + 2
    start = (SIZE - (3 * width + 4)) // 2
    placed = []
    for i in range(3):
        dx = start + i * step - x0
        placed.append([(x + dx, y, colors[(x, y)]) for x, y in dot])
    frames = []
    for n in (1, 2, 3, 3):
        fr = Image.new('RGBA', im.size, (0, 0, 0, 0))
        for d in placed[:n]:
            for x, y, c in d:
                fr.putpixel((x, y), c)
        frames.append(fr)
    return frames


def wave(im):
    frames = []
    for k in range(4):
        fr = Image.new('RGBA', im.size, (0, 0, 0, 0))
        for y in range(SIZE):
            dx = round(math.sin(y / 3.0 + k * math.pi / 2))
            row = im.crop((0, y, SIZE, y + 1))
            fr.paste(row, (dx, y), row)
        frames.append(fr)
    return frames


def twinkle(im):
    # The big star stays; the small ones blink in turn.
    stars = sorted(components(im), key=len, reverse=True)
    small = stars[1:3] or stars[:1]
    frames = []
    for hide in (None, small[0], None, small[-1]):
        frames.append(keep(im, [p for s in stars if s is not hide for p in s]))
    return frames


def pulse(im):
    bright = ImageEnhance.Brightness(im).enhance(1.35)
    return [im, offset(bright, 0, -1)]


RULES = {
    'dots': dots,
    'exclaim': lambda im: [offset(im, 0, dy) for dy in (0, -2, -1, 0)],
    'double': lambda im: [offset(im, 0, dy) for dy in (0, -2, -1, 0)],
    'question': lambda im: [offset(im, dx, 0) for dx in (0, 1, 0, -1)],
    'anger': pulse,
    'sweat': lambda im: [offset(im, 0, dy) for dy in (0, 1, 2, 3)],
    'gloom': wave,
    'sparkle': twinkle,
    'swirl': lambda im: [im.rotate(-90 * k) for k in range(4)],
}


def main():
    src, out = sys.argv[1], sys.argv[2]
    for name, rule in RULES.items():
        path = os.path.join(src, name + '.png')
        if not os.path.exists(path):
            print('missing', name)
            continue
        frames = rule(Image.open(path).convert('RGBA'))
        os.makedirs(os.path.join(out, name), exist_ok=True)
        for i, fr in enumerate(frames):
            fr.save(os.path.join(out, name, f'{i}.png'))
        print(name, len(frames), 'frames')


main()
