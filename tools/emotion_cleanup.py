"""Cleanup for PixelLab emotion (reaction) animations.

Unlike tools/anim_cleanup.py (idle/walk), the face is NOT locked here: in an
emotion the face has to change. Per frame this script only
  * re-centres the canvas so the reference frame (0) sits exactly where the
    character's south rotation sits (feet stay put between idle and reaction);
  * removes junk: tiny detached clusters (<= JUNK_PX) and small detached red
    "anger marks" the model sometimes draws itself (the emote icon does that);
  * re-attaches detached hands: a mid-size cluster that floats 1-3 px away from
    the body is moved by the smallest shift that makes it touch the body; one
    that is farther away is debris (a pebble the model drew) and is removed;
  * optionally checks the hero's slippers against hero_v7_a and remaps any
    foreign colour in the slipper rows to the nearest approved slipper colour.

Usage:
    python -I tools/emotion_cleanup.py <raw_root> <out_root> <south_rotation.png> [slipper_ref.png]

<raw_root> holds one folder per animation with 0.png, 1.png, ... (any square
canvas). Output keeps the canvas size; a report is printed per frame.
"""
import colorsys
import os
import sys
from PIL import Image

JUNK_PX = 8          # clusters this small are always removed
HAND_MAX_PX = 60     # bigger detached clusters are left alone (reported)
REATTACH_RADIUS = 3
SLIPPER_ROWS = 6     # bottom rows of the figure that hold the slippers


def components(im):
    w, h = im.size
    px = im.load()
    seen = set()
    comps = []
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0 or (x, y) in seen:
                continue
            stack = [(x, y)]
            seen.add((x, y))
            comp = []
            while stack:
                cx, cy = stack.pop()
                comp.append((cx, cy))
                for nx in (cx - 1, cx, cx + 1):
                    for ny in (cy - 1, cy, cy + 1):
                        if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in seen and px[nx, ny][3]:
                            seen.add((nx, ny))
                            stack.append((nx, ny))
            comps.append(comp)
    comps.sort(key=len, reverse=True)
    return comps


def is_red_mark(im, comp):
    px = im.load()
    red = 0
    for p in comp:
        r, g, b, _ = px[p]
        h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
        if (h < 0.03 or h > 0.95) and s > 0.6 and v > 0.5:
            red += 1
    return red * 2 >= len(comp)


def clean(im):
    """Return (image, removed_px, reattached, left_alone)."""
    comps = components(im)
    if not comps:
        return im, 0, 0, 0
    body = set(comps[0])
    px = im.load()
    removed = reattached = left = 0
    for comp in comps[1:]:
        if len(comp) <= JUNK_PX or (len(comp) <= HAND_MAX_PX and is_red_mark(im, comp)):
            for p in comp:
                px[p] = (0, 0, 0, 0)
            removed += len(comp)
            continue
        if len(comp) > HAND_MAX_PX:
            left += 1
            continue
        shift = best_shift(comp, body, im.size)
        if shift is None:
            # Too far from the body to be its hand: debris the model drew
            # (e.g. a pebble on the floor for "notice").
            for p in comp:
                px[p] = (0, 0, 0, 0)
            removed += len(comp)
            continue
        colors = {p: px[p] for p in comp}
        for p in comp:
            px[p] = (0, 0, 0, 0)
        for (x, y), c in colors.items():
            px[x + shift[0], y + shift[1]] = c
        body.update((x + shift[0], y + shift[1]) for x, y in comp)
        reattached += 1
    return im, removed, reattached, left


def best_shift(comp, body, size):
    w, h = size
    options = sorted(((dx, dy) for dx in range(-REATTACH_RADIUS, REATTACH_RADIUS + 1)
                      for dy in range(-REATTACH_RADIUS, REATTACH_RADIUS + 1)),
                     key=lambda d: abs(d[0]) + abs(d[1]))
    for dx, dy in options:
        moved = [(x + dx, y + dy) for x, y in comp]
        if any(not (0 <= x < w and 0 <= y < h) or (x, y) in body for x, y in moved):
            continue
        if any((x + ax, y + ay) in body for x, y in moved for ax in (-1, 0, 1) for ay in (-1, 0, 1)):
            return (dx, dy)
    return None


def find_offset(frame, ref):
    """Top-left position of the 64x64 reference inside the bigger frame."""
    fw, fh = frame.size
    rw, rh = ref.size
    rp = ref.load()
    fp = frame.load()
    pts = [(x, y) for y in range(rh) for x in range(rw) if rp[x, y][3]][::3]
    best = None
    for oy in range(fh - rh + 1):
        for ox in range(fw - rw + 1):
            score = sum(1 for x, y in pts if fp[x + ox, y + oy][3])
            if best is None or score > best[0]:
                best = (score, ox, oy)
    return best[1], best[2]


def shift_canvas(im, dx, dy):
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    out.paste(im, (dx, dy), im)
    return out


def slipper_palette(ref):
    bbox = ref.getbbox()
    px = ref.load()
    return {px[x, y] for y in range(bbox[3] - SLIPPER_ROWS, bbox[3]) for x in range(ref.width)
            if px[x, y][3] and px[x, y][2] > px[x, y][0] + 10}


def fix_slippers(im, palette):
    """Blue pixels in the slipper rows must use approved slipper colours."""
    bbox = im.getbbox()
    px = im.load()
    fixed = 0
    for y in range(bbox[3] - SLIPPER_ROWS, bbox[3]):
        for x in range(im.width):
            c = px[x, y]
            if c[3] and c[2] > c[0] + 10 and c not in palette:
                px[x, y] = min(palette, key=lambda p: sum((a - b) ** 2 for a, b in zip(p[:3], c[:3])))
                fixed += 1
    return fixed


def main():
    raw_root, out_root, ref_path = sys.argv[1:4]
    slipper_ref = sys.argv[4] if len(sys.argv) > 4 else None
    ref = Image.open(ref_path).convert('RGBA')
    palette = slipper_palette(Image.open(slipper_ref).convert('RGBA')) if slipper_ref else None
    for name in sorted(os.listdir(raw_root)):
        folder = os.path.join(raw_root, name)
        if not os.path.isdir(folder):
            continue
        files = sorted((f for f in os.listdir(folder) if f.endswith('.png')), key=lambda f: int(f[:-4]))
        frames = [Image.open(os.path.join(folder, f)).convert('RGBA') for f in files]
        ox, oy = find_offset(frames[0], ref)
        cx, cy = (frames[0].width - ref.width) // 2, (frames[0].height - ref.height) // 2
        os.makedirs(os.path.join(out_root, name), exist_ok=True)
        log = []
        for f, fr in zip(files, frames):
            fr = shift_canvas(fr, cx - ox, cy - oy)
            fr, removed, reattached, left = clean(fr)
            slip = fix_slippers(fr, palette) if palette else 0
            fr.save(os.path.join(out_root, name, f))
            log.append(f'{f[:-4]}:-{removed}px/+{reattached}h/{left}?/{slip}s')
        print(name, f'shift ({cx - ox},{cy - oy})', ' '.join(log))


main()
