"""Placeholder sound effects (synthesized, to be replaced by jsfxr/real sounds).

  canary_chirp.wav   two quick rising whistles
  harp_note_{0..3}.wav  plucked string (Karplus-Strong), C5 E5 G5 C6
  open.wav / close.wav  soft wooden knock up / down
  locked.wav         two dull rattles
  pickup.wav         short rising blip
  creak.wav          slow wobbling squeak (old hinge)

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


def tone(seconds, freq_fn, env_fn, noise=0.0, seed=1):
    random.seed(seed)
    out, phase = [], 0.0
    n = int(seconds * RATE)
    for i in range(n):
        t = i / n
        phase += 2 * math.pi * freq_fn(t) / RATE
        s = math.sin(phase) + noise * random.uniform(-1, 1)
        out.append(0.45 * env_fn(t) * s)
    return out


def knock(seconds, f0, f1, seed):
    return tone(seconds, lambda t: f0 + (f1 - f0) * t, lambda t: (1 - t) ** 3, 0.6, seed)


def main():
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    save(os.path.join(out, 'canary_chirp.wav'), chirp())
    for i, f in enumerate((523.25, 659.25, 783.99, 1046.5)):
        save(os.path.join(out, f'harp_note_{i}.wav'), pluck(f))
    save(os.path.join(out, 'open.wav'), knock(0.18, 180, 260, 2))
    save(os.path.join(out, 'close.wav'), knock(0.16, 220, 120, 3))
    save(os.path.join(out, 'locked.wav'), knock(0.09, 140, 120, 4) + [0.0] * 1200 + knock(0.09, 150, 120, 5))
    save(os.path.join(out, 'pickup.wav'), tone(0.14, lambda t: 700 + 900 * t, lambda t: math.sin(math.pi * t)))
    save(os.path.join(out, 'creak.wav'), tone(0.6, lambda t: 420 + 90 * math.sin(t * 25) + 80 * t, lambda t: math.sin(math.pi * t) * 0.6, 0.15, 6))
    print('ok')


main()
