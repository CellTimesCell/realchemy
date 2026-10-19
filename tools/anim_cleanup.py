"""Animation cleanup for PixelLab character animations.

PixelLab redraws every frame, so faces "swim" (eyes and features change from
frame to frame). This script picks one best frame per direction, fixes its
head (stray orange pixels in the hair, ear removal on front/side views), then
transplants that head into every frame of the direction at the frame's own
bob offset, and drops tiny detached pixel clusters.

Usage:
    python -I tools/anim_cleanup.py <frames_root> [out_dir]

<frames_root> holds one folder per animation with 0.png, 1.png, ... (64x64).
Folder names, frame counts and the best frame per direction are configured in
SETS below (currently the hero's v34 animations); the ear/hand coordinates in
fix_head() and main() are tuned for the hero sprite.
"""
import colorsys
import os
import sys
from PIL import Image

ROOT = sys.argv[1]
OUT = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, 'clean')
HEAD_ROWS = 17               # head height from the top of the hair

SETS = {  # name: (folder, frame count, best frame)
    'idle_south': ('idle_south', 4, 0),
    'walk_south': ('walk_south_v3', 6, 2),
    'walk_north': ('walk_north_v3', 6, 0),
    'walk_east': ('walk_east', 6, 0),
}


def kind(c):
    r, g, b, a = c
    if a == 0:
        return '.'
    if r + g + b < 120:
        return '#'
    h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
    if b > r + 10:
        return 'b'
    if h < 0.12 and s > 0.35 and v > 0.75:
        return 's'
    if h < 0.12:
        return 'h'
    return '?'


def top_of(im):
    return im.getbbox()[1]


def hair_color(im, top):
    counts = {}
    for y in range(top, top + 8):
        for x in range(64):
            c = im.getpixel((x, y))
            if kind(c) == 'h':
                counts[c] = counts.get(c, 0) + 1
    return max(counts, key=counts.get)


def outline_color(im, top):
    counts = {}
    for y in range(top, top + HEAD_ROWS):
        for x in range(64):
            c = im.getpixel((x, y))
            if kind(c) == '#':
                counts[c] = counts.get(c, 0) + 1
    return max(counts, key=counts.get)


def fix_head(im, name):
    """Stray orange pixels in the left hair; tidy the ear on front views."""
    top = top_of(im)
    hair = hair_color(im, top)
    line = outline_color(im, top)
    px = im.load()
    # face left edge = first skin pixel on the eye row
    eye_row = top + 11
    skin_x = [x for x in range(64) if kind(px[x, eye_row]) == 's']
    face_left = min(skin_x) if skin_x else 0
    fixed = 0
    for y in range(top, top + 10):
        for x in range(0, face_left - 1):
            r, g, b, a = px[x, y]
            if not a:
                continue
            h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            if h < 0.12 and ((s > 0.45 and v > 0.55) or (s > 0.15 and v > 0.85)):
                px[x, y] = hair
                fixed += 1
    if name in ('idle_south', 'walk_south'):
        # Remove the ear entirely: everything right of the face outline
        # (x = 32) in the ear rows goes, and the outline column is closed.
        for y in range(top + 9, top + 14):
            for x in range(33, 42):
                if px[x, y][3]:
                    px[x, y] = (0, 0, 0, 0)
                    fixed += 1
            if kind(px[32, y]) != '#':
                px[32, y] = line
    if name == 'walk_east':
        # Profile: the pale ear patch behind the face becomes dark hair.
        for y in range(top + 9, top + 12):
            for x in range(29, 33):
                if kind(px[x, y]) in 's?h' and px[x, y][0] > 150:
                    px[x, y] = line
                    fixed += 1
    return fixed


def head_region(im):
    top = top_of(im)
    rows = range(top, top + HEAD_ROWS)
    xs = [x for y in rows for x in range(64) if im.getpixel((x, y))[3]]
    return top, min(xs), max(xs) + 1


def best_offset(src, dst):
    """(dx, dy) that best overlaps the source head silhouette onto dst."""
    stop, sx0, sx1 = head_region(src)
    best = None
    for dy in range(-3, 4):
        for dx in range(-3, 4):
            score = 0
            for y in range(stop, stop + HEAD_ROWS - 3):
                for x in range(sx0, sx1):
                    ty, tx = y + dy, x + dx
                    if not (0 <= ty < 64 and 0 <= tx < 64):
                        continue
                    a = src.getpixel((x, y))[3] > 0
                    b = dst.getpixel((tx, ty))[3] > 0
                    score += 1 if a == b else -1
            if best is None or score > best[0]:
                best = (score, dx, dy)
    return best[1], best[2]


def transplant(src, dst):
    dx, dy = best_offset(src, dst)
    stop, sx0, sx1 = head_region(src)
    out = dst.copy()
    op = out.load()
    # clear the destination head area (rows above the collar)
    for y in range(stop + dy, stop + dy + HEAD_ROWS - 1):
        for x in range(sx0 + dx - 2, sx1 + dx + 2):
            if 0 <= x < 64 and 0 <= y < 64:
                op[x, y] = (0, 0, 0, 0)
    for y in range(stop, stop + HEAD_ROWS - 1):
        for x in range(sx0, sx1):
            c = src.getpixel((x, y))
            if c[3] and 0 <= x + dx < 64 and 0 <= y + dy < 64:
                op[x + dx, y + dy] = c
    return out, (dx, dy)


def drop_islands(im, max_size=4):
    """Remove tiny detached pixel clusters (e.g. a floating hand)."""
    px = im.load()
    seen = set()
    removed = 0
    for y in range(64):
        for x in range(64):
            if px[x, y][3] == 0 or (x, y) in seen:
                continue
            stack = [(x, y)]
            comp = []
            seen.add((x, y))
            while stack:
                cx, cy = stack.pop()
                comp.append((cx, cy))
                for nx in (cx - 1, cx, cx + 1):
                    for ny in (cy - 1, cy, cy + 1):
                        if 0 <= nx < 64 and 0 <= ny < 64 and (nx, ny) not in seen and px[nx, ny][3]:
                            seen.add((nx, ny))
                            stack.append((nx, ny))
            if len(comp) <= max_size:
                for p in comp:
                    px[p] = (0, 0, 0, 0)
                removed += len(comp)
    return removed


def main():
    os.makedirs(OUT, exist_ok=True)
    for name, (folder, count, best) in SETS.items():
        frames = [Image.open(os.path.join(ROOT, folder, f'{i}.png')).convert('RGBA') for i in range(count)]
        head = frames[best].copy()
        fixed = fix_head(head, name)
        os.makedirs(os.path.join(OUT, name), exist_ok=True)
        log = []
        for i, fr in enumerate(frames):
            new, off = transplant(head, fr)
            islands = drop_islands(new)
            new.save(os.path.join(OUT, name, f'{i}.png'))
            log.append(f'{i}:{off}/-{islands}')
        print(name, 'best', best, 'head fixes', fixed, ' '.join(log))
    # detached fist in front of the body in the side walk (frames 1 and 4)
    for i, (y0, y1) in ((1, (36, 42)), (4, (30, 36))):
        path = os.path.join(OUT, 'walk_east', f'{i}.png')
        im = Image.open(path).convert('RGBA')
        px = im.load()
        for y in range(y0, y1):
            for x in range(38, 64):
                px[x, y] = (0, 0, 0, 0)
        im.save(path)


main()
