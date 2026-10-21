"""Web build for itch.io (docs/TOOLING.md §10).

    python tools/build_web.py            # export + zip
    python tools/build_web.py --fetch    # first time: install the web export templates

--fetch takes only templates/web_nothreads_{release,debug}.zip and version.txt
out of the official 1.2 GB export_templates.tpz with HTTP Range requests (about
20 MB) and puts them into %APPDATA%/Godot/export_templates/4.7.2.stable/.
The export uses the "Web" preset in game/export_presets.cfg (git-ignored; its
content is in TOOLING.md §10). Output: build/web/ and build/realchemy_web.zip
(index.html at the zip root, as itch.io wants).
"""
import io
import os
import subprocess
import sys
import urllib.request
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GODOT = os.path.join(ROOT, 'engine', 'Godot_v4.7.2-stable_win64_console.exe')
VERSION = '4.7.2.stable'
TPZ = 'https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz'
WANTED = ['templates/version.txt', 'templates/web_nothreads_release.zip', 'templates/web_nothreads_debug.zip']


class RangeFile(io.RawIOBase):
    """A read-only remote file: every read is an HTTP Range request (1 MB chunks)."""
    CHUNK = 1 << 20

    def __init__(self, url):
        with urllib.request.urlopen(urllib.request.Request(url, method='HEAD'), timeout=60) as r:
            self.url, self.size = r.geturl(), int(r.headers['Content-Length'])
        self.pos, self.cache = 0, {}

    def seekable(self):
        return True

    def readable(self):
        return True

    def tell(self):
        return self.pos

    def seek(self, off, whence=0):
        self.pos = off if whence == 0 else self.pos + off if whence == 1 else self.size + off
        return self.pos

    def _chunk(self, i):
        if i not in self.cache:
            start = i * self.CHUNK
            end = min(self.size, start + self.CHUNK) - 1
            req = urllib.request.Request(self.url, headers={'Range': 'bytes=%d-%d' % (start, end)})
            with urllib.request.urlopen(req, timeout=120) as r:
                self.cache[i] = r.read()
        return self.cache[i]

    def readinto(self, b):
        n, done = len(b), 0
        while done < n and self.pos < self.size:
            i, off = divmod(self.pos, self.CHUNK)
            data = self._chunk(i)[off:off + n - done]
            b[done:done + len(data)] = data
            done += len(data)
            self.pos += len(data)
        return done


def fetch_templates():
    target = os.path.join(os.environ['APPDATA'], 'Godot', 'export_templates', VERSION)
    os.makedirs(target, exist_ok=True)
    archive = zipfile.ZipFile(io.BufferedReader(RangeFile(TPZ), buffer_size=1 << 20))
    for name in WANTED:
        data = archive.read(name)
        open(os.path.join(target, os.path.basename(name)), 'wb').write(data)
        print('installed', name, len(data))


def export_and_zip():
    out_dir = os.path.join(ROOT, 'build', 'web')
    os.makedirs(out_dir, exist_ok=True)
    subprocess.run([GODOT, '--headless', '--path', os.path.join(ROOT, 'game'),
                    '--export-release', 'Web', os.path.join(out_dir, 'index.html')], check=True)
    zip_path = os.path.join(ROOT, 'build', 'realchemy_web.zip')
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as z:
        for name in sorted(os.listdir(out_dir)):
            z.write(os.path.join(out_dir, name), name)
    print('zip', zip_path, os.path.getsize(zip_path) // 1024, 'KB')


if __name__ == '__main__':
    if '--fetch' in sys.argv:
        fetch_templates()
    else:
        export_and_zip()
