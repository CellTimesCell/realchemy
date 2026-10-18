import sys
import tempfile
import unittest
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import pixelize  # noqa: E402

MAGENTA = (255, 0, 255)
RED = (200, 30, 30)


def sprite_on_magenta(scale: int = 8) -> Image.Image:
    """4x4 'pixel art' upscaled by `scale`: red 2x2 square in the middle of magenta."""
    img = Image.new("RGB", (4, 4), MAGENTA)
    for x in (1, 2):
        for y in (1, 2):
            img.putpixel((x, y), RED)
    return img.resize((4 * scale, 4 * scale), Image.Resampling.NEAREST)


class PixelizeTest(unittest.TestCase):
    def test_removes_key_and_downscales(self):
        out = pixelize.pixelize(sprite_on_magenta(), (4, 4), None, MAGENTA, 60)
        self.assertEqual(out.size, (4, 4))
        self.assertEqual(out.getpixel((0, 0))[3], 0)
        self.assertEqual(out.getpixel((1, 1)), RED + (255,))

    def test_key_tolerance_catches_noisy_magenta(self):
        img = Image.new("RGB", (2, 1), (250, 10, 245))
        img.putpixel((1, 0), RED)
        out = pixelize.pixelize(img, (2, 1), None, MAGENTA, 60)
        self.assertEqual(out.getpixel((0, 0))[3], 0)
        self.assertEqual(out.getpixel((1, 0))[3], 255)

    def test_keep_bg(self):
        out = pixelize.pixelize(sprite_on_magenta(), (4, 4), None, None, 60)
        self.assertEqual(out.getpixel((0, 0)), MAGENTA + (255,))

    def test_crop_to_aspect_keeps_center(self):
        img = Image.new("RGB", (300, 100), (0, 0, 0))
        img.paste((255, 255, 255), (100, 0, 200, 100))
        out = pixelize.pixelize(img, (10, 10), None, None, 60)
        self.assertEqual(out.size, (10, 10))
        self.assertEqual(out.getpixel((5, 5)), (255, 255, 255, 255))

    def test_background_size(self):
        img = Image.new("RGB", (1920, 1080), (10, 20, 30))
        self.assertEqual(pixelize.pixelize(img, (480, 270), None, None, 60).size, (480, 270))

    def test_palette_mapping_without_dither_and_no_black_padding(self):
        palette = [(220, 40, 40), (40, 40, 220)]
        img = Image.new("RGB", (2, 1), (190, 20, 20))
        img.putpixel((1, 0), (10, 10, 10))  # near black, but black is not in the palette
        out = pixelize.pixelize(img, (2, 1), palette, None, 60)
        self.assertEqual(out.getpixel((0, 0))[:3], (220, 40, 40))
        self.assertIn(out.getpixel((1, 0))[:3], palette)

    def test_palette_preserves_transparency(self):
        out = pixelize.pixelize(sprite_on_magenta(), (4, 4), [(220, 40, 40)], MAGENTA, 60)
        self.assertEqual(out.getpixel((0, 0))[3], 0)
        self.assertEqual(out.getpixel((1, 1)), (220, 40, 40, 255))

    def test_load_palette_png_and_gpl(self):
        with tempfile.TemporaryDirectory() as tmp:
            png = Path(tmp) / "p.png"
            img = Image.new("RGBA", (3, 1), (1, 2, 3, 255))
            img.putpixel((1, 0), (4, 5, 6, 255))
            img.putpixel((2, 0), (9, 9, 9, 0))
            img.save(png)
            self.assertEqual(pixelize.load_palette(png), [(1, 2, 3), (4, 5, 6)])
            gpl = Path(tmp) / "p.gpl"
            gpl.write_text("GIMP Palette\nName: test\nColumns: 4\n#\n  1   2   3\tDark\n255 0 255 Key\n",
                           encoding="utf-8")
            self.assertEqual(pixelize.load_palette(gpl), [(1, 2, 3), (255, 0, 255)])

    def test_cli_writes_to_out_dir(self):
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp) / "rock.png"
            sprite_on_magenta().save(src)
            out_dir = Path(tmp) / "incoming"
            code = pixelize.main([str(src), "--size", "4x4", "--out", str(out_dir),
                                  "--palette", str(src)])
            self.assertEqual(code, 0)
            with Image.open(out_dir / "rock.png") as res:
                self.assertEqual(res.size, (4, 4))
                self.assertEqual(res.mode, "RGBA")

    def test_cli_missing_explicit_palette_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            src = Path(tmp) / "rock.png"
            sprite_on_magenta().save(src)
            code = pixelize.main([str(src), "--size", "4x4", "--out", tmp, "--palette", str(Path(tmp) / "no.png")])
            self.assertEqual(code, 1)


if __name__ == "__main__":
    unittest.main()
