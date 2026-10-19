"""Placeholder sound effects (synthesized, to be replaced by jsfxr/real sounds).

  canary_chirp.wav   two quick rising whistles
  harp_note_{0..3}.wav  plucked string (Karplus-Strong), C5 E5 G5 C6

Usage: python -I tools/placeholder_sfx.py <out_dir>
"""
import math
import os
import random
import struct
import sys
import wave

RATE = 22050


def save(path, samples):
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b''.join(struct.pack('<h', int(max(-1, min(1, s)) * 30000)) for s in samples))


def chirp():
    out = []
    for start, length in ((0.0, 0.07), (0.1, 0.09)):
        while len(out) < int(start * RATE):
            out.append(0.0)
        n = int(length * RATE)
        phase = 0.0
        for i in range(n):
            t = i / n
            freq = 3200 + 1800 * t + 300 * math.sin(t * 40)
            phase += 2 * math.pi * freq / RATE
            env = math.sin(math.pi * t) ** 2
            out.append(0.5 * env * math.sin(phase))
    return out


def pluck(freq, seconds=1.2):
    random.seed(int(freq))
    period = int(RATE / freq)
    buf = [random.uniform(-1, 1) for _ in range(period)]
    out = []
    for i in range(int(seconds * RATE)):
        s = buf[i % period]
        nxt = buf[(i + 1) % period]
        buf[i % period] = 0.996 * 0.5 * (s + nxt)
        out.append(0.6 * s)
    return out


def main():
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    save(os.path.join(out, 'canary_chirp.wav'), chirp())
    for i, f in enumerate((523.25, 659.25, 783.99, 1046.5)):
        save(os.path.join(out, f'harp_note_{i}.wav'), pluck(f))
    print('ok')


main()
