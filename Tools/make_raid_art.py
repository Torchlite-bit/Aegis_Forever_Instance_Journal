"""Makes the journal's own pictures (512 x 256 TGA) from the pictures in the reference folder's
Art: the raids' (Media/Raids) and the one shown for a dungeon with no picture of its own
(Media/DungeonPlaceholder). Each is cut to 2:1, around its middle unless a part is given. Also
the square icons (64 x 64, with their transparency), such as WoW: Forever's emblem.

    python Tools/make_raid_art.py

Needs Pillow."""

import os
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ART = os.path.join(os.path.expanduser("~"), "OneDrive", "Pictures", "Forever Instance Journal", "Art")
MEDIA = os.path.join(ROOT, "Media")
SIZE = (512, 256)

# Source picture (under Art), the part of it to keep (left, top, right, bottom; 2:1, or None
# for the middle), and the file made (under Media).
PICTURES = [
    (os.path.join("Raids", "Barrow Deeps.png"), None, os.path.join("Raids", "BarrowDeeps")),
    (os.path.join("Raids", "Hyjal Summit.png"), None, os.path.join("Raids", "HyjalSummit")),
    # Onyxia's head on the left: the square icon (Data/Instances/Raids.lua) is cut around it.
    (os.path.join("Raids", "Onyxia's Lair.webp"), (0, 410, 1320, 1070), os.path.join("Raids", "OnyxiasLair")),
    # The keep at the middle, the moon and the burning statue either side.
    ("Dungeon placeholder.webp", (0, 50, 2000, 1050), "DungeonPlaceholder"),
]

# Square icons, kept whole with their transparency: source (under Art), file made (under Media).
ICONS = [
    # WoW: Forever's emblem, on what Forever added (UI/ForeverMark.lua).
    ("Forever icon.png", "ForeverIcon"),
]
ICON_SIZE = (64, 64)


def two_to_one(image):
    width, height = image.size
    if width > height * 2:
        cut = (width - height * 2) // 2
        return image.crop((cut, 0, cut + height * 2, height))
    keep = width // 2
    cut = (height - keep) // 2
    return image.crop((0, cut, width, cut + keep))


def main():
    for source, part, name in PICTURES:
        image = Image.open(os.path.join(ART, source)).convert("RGB")
        if part:
            image = image.crop(part)
        image = two_to_one(image).resize(SIZE, Image.LANCZOS)
        path = os.path.join(MEDIA, name + ".tga")
        os.makedirs(os.path.dirname(path), exist_ok=True)
        image.save(path, compression="tga_rle")
        print("wrote", path)
    for source, name in ICONS:
        image = Image.open(os.path.join(ART, source)).convert("RGBA").resize(ICON_SIZE, Image.LANCZOS)
        path = os.path.join(MEDIA, name + ".tga")
        image.save(path, compression="tga_rle")
        print("wrote", path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
