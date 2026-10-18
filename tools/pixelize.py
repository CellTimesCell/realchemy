"""Turn a generated image into a game-ready pixel asset (docs/ART_PIPELINE.md §3, step 2).

Pipeline: remove key-colour background -> crop to target aspect -> downscale with
Nearest -> snap alpha to 0/255 -> map colours to the project palette (no dithering).

Usage:
    python tools/pixelize.py SRC --size 32x32 [--out DIR] [--palette FILE]
                             [--keep-bg] [--key "#FF00FF"] [--tolerance 60]

Palette: .png (every opaque pixel colour is an entry) or .gpl (GIMP/Aseprite).
Default palette is game/assets/palette.png; if it does not exist yet, the palette
step is skipped with a warning. Output goes to game/assets/_incoming/<name>.png.
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_OUT = ROOT / "game" / "assets" / "_incoming"
DEFAULT_PALETTE = ROOT / "game" / "assets" / "palette.png"
MAX_SPRITE_COLORS = 16
ALPHA_THRESHOLD = 128

Color = tuple[int, int, int]


def parse_size(text: str) -> tuple[int, int]:
    try:
        w, h = (int(v) for v in text.lower().split("x"))
    except ValueError:
        raise argparse.ArgumentTypeError(f"size must look like 32x32, got '{text}'")
    if w <= 0 or h <= 0:
        raise argparse.ArgumentTypeError("size must be positive")
    return w, h


def parse_hex(text: str) -> Color:
    value = text.lstrip("#")
    if len(value) != 6:
        raise argparse.ArgumentTypeError(f"colour must be #RRGGBB, got '{text}'")
    return int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16)


def load_palette(path: Path) -> list[Color]:
    if path.suffix.lower() == ".gpl":
        colors: list[Color] = []
        for line in path.read_text(encoding="utf-8").splitlines():
            parts = line.split()
            if len(parts) >= 3 and all(p.isdigit() for p in parts[:3]):
                colors.append((int(parts[0]), int(parts[1]), int(parts[2])))
    else:
        img = Image.open(path).convert("RGBA")
        colors = []
        seen: set[Color] = set()
        for r, g, b, a in img.get_flattened_data():
            if a >= ALPHA_THRESHOLD and (r, g, b) not in seen:
                seen.add((r, g, b))
                colors.append((r, g, b))
    if not colors:
        raise ValueError(f"palette {path} has no colours")
    if len(colors) > 256:
        raise ValueError(f"palette {path} has {len(colors)} colours, max 256")
    return colors


def remove_key(img: Image.Image, key: Color, tolerance: int) -> Image.Image:
    """Make pixels within `tolerance` (Euclidean RGB) of `key` transparent."""
    tol2 = tolerance * tolerance
    out = img.copy()
    out.putdata([
        (r, g, b, 0) if (r - key[0]) ** 2 + (g - key[1]) ** 2 + (b - key[2]) ** 2 <= tol2 else (r, g, b, a)
        for r, g, b, a in img.get_flattened_data()
    ])
    return out


def crop_to_aspect(img: Image.Image, size: tuple[int, int]) -> Image.Image:
    """Center-crop so the image has the target aspect ratio (no stretching)."""
    w, h = img.size
    tw, th = size
    if w * th > h * tw:
        new_w = round(h * tw / th)
        left = (w - new_w) // 2
        return img.crop((left, 0, left + new_w, h))
    new_h = round(w * th / tw)
    top = (h - new_h) // 2
    return img.crop((0, top, w, top + new_h))


def snap_alpha(img: Image.Image) -> Image.Image:
    alpha = img.getchannel("A").point(lambda a: 255 if a >= ALPHA_THRESHOLD else 0)
    img.putalpha(alpha)
    return img


def apply_palette(img: Image.Image, colors: list[Color]) -> Image.Image:
    pal_img = Image.new("P", (1, 1))
    flat = [c for color in colors for c in color]
    # Pad with repeats of real entries: zero padding would add black as a target colour.
    while len(flat) < 768:
        flat.extend(flat[: 768 - len(flat)])
    pal_img.putpalette(flat)
    rgb = img.convert("RGB").quantize(palette=pal_img, dither=Image.Dither.NONE).convert("RGB")
    rgb.putalpha(img.getchannel("A"))
    return rgb


def count_colors(img: Image.Image) -> int:
    return len({(r, g, b) for r, g, b, a in img.get_flattened_data() if a})


def pixelize(src: Image.Image, size: tuple[int, int], palette: list[Color] | None,
             key: Color | None, tolerance: int) -> Image.Image:
    img = src.convert("RGBA")
    if key is not None:
        img = remove_key(img, key, tolerance)
    img = crop_to_aspect(img, size).resize(size, Image.Resampling.NEAREST)
    img = snap_alpha(img)
    if palette is not None:
        img = apply_palette(img, palette)
    return img


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("src", type=Path)
    parser.add_argument("--size", type=parse_size, required=True, help="target size, e.g. 32x32 or 480x270")
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT, help="output directory")
    parser.add_argument("--name", help="output file name without extension (default: source name)")
    parser.add_argument("--palette", type=Path, help="palette .png or .gpl (default: game/assets/palette.png)")
    parser.add_argument("--keep-bg", action="store_true", help="do not remove the key colour (backgrounds)")
    parser.add_argument("--key", type=parse_hex, default=(255, 0, 255), help="background key colour")
    parser.add_argument("--tolerance", type=int, default=60, help="key colour tolerance (RGB distance)")
    args = parser.parse_args(argv)

    palette_path = args.palette or DEFAULT_PALETTE
    palette = None
    if palette_path.exists():
        palette = load_palette(palette_path)
    elif args.palette:
        print(f"ERROR palette not found: {palette_path}")
        return 1
    else:
        print(f"WARN  {palette_path.name} not found, palette step skipped")

    with Image.open(args.src) as src:
        result = pixelize(src, args.size, palette, None if args.keep_bg else args.key, args.tolerance)

    args.out.mkdir(parents=True, exist_ok=True)
    out_path = args.out / f"{args.name or args.src.stem}.png"
    result.save(out_path)
    colors = count_colors(result)
    print(f"{out_path} {result.width}x{result.height}, {colors} colours")
    if not args.keep_bg and colors > MAX_SPRITE_COLORS:
        print(f"WARN  sprite has {colors} colours, style limit is {MAX_SPRITE_COLORS}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
