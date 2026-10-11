"""Writes the boss button highlight mask: opaque over the button, clear over the portrait ring
and everything left of the ring's centre, with a soft edge. make_highlight_mask.py [out.tga]

The mask is stretched over the 325 x 55 button. The ring is centred 46 units from the left, on
the button's middle, and is 77 x 73 units; the hole is a little inside its rim, so the glow
meets the rim (which glows itself) without a gap."""
import math
import os
import sys

from PIL import Image

WIDTH, HEIGHT = 512, 128
BUTTON_W, BUTTON_H = 325.0, 55.0
CENTER_X = 46.0
HOLE_RX, HOLE_RY = 34.0, 32.0
FEATHER = 1.5  # units

image = Image.new("RGBA", (WIDTH, HEIGHT))
pixels = image.load()
for py in range(HEIGHT):
    uy = (py + 0.5) / HEIGHT * BUTTON_H - BUTTON_H / 2
    for px in range(WIDTH):
        ux = (px + 0.5) / WIDTH * BUTTON_W
        # Clear left of the ring's centre; right of it, by the distance (in units) outside the hole.
        if ux < CENTER_X:
            alpha = 0.0
        else:
            d = math.sqrt(((ux - CENTER_X) / HOLE_RX) ** 2 + (uy / HOLE_RY) ** 2)
            outside = (d - 1.0) * min(HOLE_RX, HOLE_RY)
            alpha = max(0.0, min(1.0, outside / FEATHER))
        pixels[px, py] = (255, 255, 255, int(round(alpha * 255)))
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "Media", "BossButtonHighlightMask.tga")
image.save(out)
print("wrote", os.path.normpath(out))
