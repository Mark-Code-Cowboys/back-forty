#!/usr/bin/env python3
"""Regenerates assets/icon/*.png — the Back Forty placeholder mark:
a gambrel-roof barn with a wrench field line on soil brown #6B4F2A.
Run from the repo root, then `dart run flutter_launcher_icons`."""
from PIL import Image, ImageDraw

BROWN = (107, 79, 42, 255)
WHITE = (255, 255, 255, 255)
CREAM = (240, 233, 221, 255)

def draw_glyph(d, s, ox=0, oy=0):
    def P(pts, fill):
        d.polygon([(ox + x * s, oy + y * s) for x, y in pts], fill=fill)
    # Gambrel roof: the barn silhouette everyone knows.
    P([(0.50, 0.14), (0.68, 0.22), (0.76, 0.34), (0.24, 0.34),
       (0.32, 0.22)], WHITE)
    # Body.
    d.rectangle([ox + 0.26 * s, oy + 0.34 * s, ox + 0.74 * s, oy + 0.66 * s],
                fill=WHITE)
    # Door.
    d.rectangle([ox + 0.42 * s, oy + 0.44 * s, ox + 0.58 * s, oy + 0.66 * s],
                fill=BROWN)
    # Door cross-brace.
    d.line([ox + 0.42 * s, oy + 0.44 * s, ox + 0.58 * s, oy + 0.66 * s],
           fill=WHITE, width=max(1, int(0.02 * s)))
    d.line([ox + 0.58 * s, oy + 0.44 * s, ox + 0.42 * s, oy + 0.66 * s],
           fill=WHITE, width=max(1, int(0.02 * s)))
    # The field line: a long wrench lying at the fence line.
    d.rounded_rectangle([ox + 0.22 * s, oy + 0.76 * s, ox + 0.66 * s,
                         oy + 0.81 * s], radius=0.02 * s, fill=CREAM)
    d.ellipse([ox + 0.62 * s, oy + 0.72 * s, ox + 0.78 * s, oy + 0.85 * s],
              fill=CREAM)
    d.ellipse([ox + 0.665 * s, oy + 0.755 * s, ox + 0.735 * s, oy + 0.815 * s],
              fill=BROWN)

img = Image.new('RGBA', (1024, 1024), BROWN)
draw_glyph(ImageDraw.Draw(img), 1024)
img.save('assets/icon/icon.png')

fg = Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))
draw_glyph(ImageDraw.Draw(fg), 640, ox=192, oy=192)
fg.save('assets/icon/icon_foreground.png')
print('icons written')
