"""Small mechanical fixes for generated prop sprites (never draws new art).

  clean <in.png> <out.png> [min_px]
      Drop detached specks: connected pieces smaller than min_px (default 12)
      that are not the main body, e.g. a pebble generated next to a pot.
  bars <in.png> <out.png> x0 y0 x1 y1 [min_luma]
      Front bars of a cage: keep only the bright (bar-coloured) pixels of the
      sprite inside the rect, so a bird drawn between the cage and this layer
      sits behind the bars.

Usage: python -I tools/prop_tools.py <command> ...
"""
import sys
from PIL import Image


def components(im):
    w, h = im.size
    px = im.load()
    seen = set()
    comps = []
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0 or (x, y) in seen:
                continue
            stack, comp = [(x, y)], []
            seen.add((x, y))
            while stack:
                cx, cy = stack.pop()
                comp.append((cx, cy))
                for nx in (cx - 1, cx, cx + 1):
                    for ny in (cy - 1, cy, cy + 1):
                        if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in seen and px[nx, ny][3]:
                            seen.add((nx, ny))
                            stack.append((nx, ny))
            comps.append(comp)
    return comps


def clean(src, dst, min_px=12):
    im = Image.open(src).convert('RGBA')
    comps = sorted(components(im), key=len, reverse=True)
    px = im.load()
    dropped = 0
    for comp in comps[1:]:
        if len(comp) < min_px:
            for p in comp:
                px[p] = (0, 0, 0, 0)
            dropped += len(comp)
    im.save(dst)
    print(dst, 'dropped', dropped, 'px')


def bars(src, dst, x0, y0, x1, y1, min_luma=120):
    im = Image.open(src).convert('RGBA')
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    sp, dp = im.load(), out.load()
    kept = 0
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = sp[x, y]
            if a and 0.299 * r + 0.587 * g + 0.114 * b >= min_luma:
                dp[x, y] = (r, g, b, a)
                kept += 1
    out.save(dst)
    print(dst, 'kept', kept, 'px')


def main():
    cmd, args = sys.argv[1], sys.argv[2:]
    if cmd == 'clean':
        clean(args[0], args[1], int(args[2]) if len(args) > 2 else 12)
    elif cmd == 'bars':
        bars(args[0], args[1], *map(int, args[2:6]), *(map(int, args[6:7])))
    else:
        raise SystemExit(__doc__)


main()
