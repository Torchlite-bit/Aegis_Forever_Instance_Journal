"""
Builds the testers' package: one zip holding the addon folder as the game loads it, the
testers' guide as a page to open in a browser, and a short README.

    python Tools/package.py

The zip lands in the reference folder's Releases folder, named with the TOC's version. The
addon goes in without Tools/ (as the install copies it). Every file the TOC lists must be
there, or nothing is written.

    python Tools/package.py --public dist

instead writes the public release GitHub publishes on every push to main
(.github/workflows/release.yml): the addon folder alone in a zip, and its notes from the
CHANGELOG.
"""

import os
import re
import sys
import textwrap
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ADDON = "Aegis_Forever_Instance_Journal"
TOC = os.path.join(ROOT, ADDON + ".toc")
GUIDE = os.path.join(ROOT, "Tools", "tester_guide.html")
RELEASES = os.path.join(os.path.expanduser("~"), "OneDrive", "Pictures", "Forever Instance Journal", "Releases")
# Kept in the repository, not in the addon: the tools, the README's pictures, and built releases.
LEFT_OUT = {"Tools", "docs", "dist"}

README = """Aegis Instance Journal {version}, tester build
==============================================

Thank you for helping collect data for the journal.

INSTALL
1. Copy the Aegis_Forever_Instance_Journal folder from this zip into
   World of Warcraft\\_classic_beta_\\Interface\\AddOns
   Only that folder goes there; this file and the guide can stay anywhere.
   Updating? Delete the old Aegis_Forever_Instance_Journal folder first.
   Your recordings are kept: they live in the WTF folder, not the addon's.
2. Close the game completely and start it again, then tick
   Aegis Instance Journal in the AddOns list at character select.
3. In game, press Shift+J or type /aegis.

WHAT TO DO
Open "Tester Guide.html" in your browser. It covers recording dungeon runs,
marking boats, trams and portals, and sending what you recorded: press Copy
on the Record tab and paste it in our Discord, https://discord.gg/Hr66t25vE7

CREDITS
{alex}
- Atlas de Azeroth: Forever, by Santiago Reyes: the maps of The Hall of
  Thanes, Ruins of Lordaeron, Excavation Site: Wetlands and City of Dalaran.
  They are his own reinterpretations, not official World of Warcraft art,
  and he is not affiliated with Blizzard. If you show them in a video or a
  stream, please credit him in its description, and never alter them or
  remove his watermark. Support his maps:
  patreon.com/c/SantiagoReyesMaps or ko-fi.com/sr433_20
- Lionel Schramm: the paintings of Onyxia's Lair and of the dungeons with no
  picture of their own, from Mysteries of Azeroth (Turtle WoW), used with his
  permission.
- Created with the help of Claude AI, Anthropic's assistant.
World of Warcraft, its art and its game data are Blizzard Entertainment's.
More in CREDITS.md, inside the addon folder.
"""


def toc_version_and_files():
    version, files = None, []
    with open(TOC, encoding="utf-8") as toc:
        for line in toc:
            line = line.strip()
            match = re.match(r"##\s*Version:\s*(\S+)", line)
            if match:
                version = match.group(1)
            elif line and not line.startswith("#"):
                files.append(line.replace("\\", "/"))
    return version, files


def contributors():
    """The Alex Atlas Loot contributors, as the TOC's notes name them."""
    with open(TOC, encoding="utf-8") as toc:
        notes = re.search(r"## Notes:.*?contributors (.+?), whose", toc.read())
    if not notes:
        sys.exit("The TOC's notes no longer name Alex Atlas Loot's contributors; the package needs them.")
    return notes.group(1)


def addon_files():
    """Every file of the addon as it is installed: relative paths, Tools left out."""
    found = []
    for folder, subfolders, names in os.walk(ROOT):
        relative = os.path.relpath(folder, ROOT)
        if relative == ".":
            subfolders[:] = [name for name in subfolders if name not in LEFT_OUT and not name.startswith(".")]
        for name in names:
            if name.startswith("."):
                continue
            path = os.path.normpath(os.path.join(relative, name)).replace("\\", "/")
            found.append(path)
    return sorted(found)


def guide_page():
    """The guide is written for publishing, which adds the document around it; here it gets its own."""
    with open(GUIDE, encoding="utf-8") as guide:
        fragment = guide.read()
    head, body = fragment.split("<main", 1)
    return ("<!doctype html>\n<html lang=\"en\">\n<head>\n<meta charset=\"utf-8\">\n"
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
            + head.strip() + "\n<style>body { margin: 0; }</style>\n</head>\n<body>\n<main" + body.rstrip()
            + "\n</body>\n</html>\n")


def changelog_section(version):
    """The CHANGELOG's entry for a version, without its heading, or "" when it has none."""
    path = os.path.join(ROOT, "CHANGELOG.md")
    if not os.path.exists(path):
        return ""
    with open(path, encoding="utf-8") as handle:
        text = handle.read()
    match = re.search(r"^## \[" + re.escape(version) + r"\][^\n]*\n(.*?)(?=^---$|^## \[|\Z)", text, re.M | re.S)
    return match.group(1).strip() if match else ""


def public_release(out, version, files):
    """The release GitHub publishes: the addon folder alone in the zip (what addon managers
    expect), and the release notes, from the CHANGELOG."""
    os.makedirs(out, exist_ok=True)
    target = os.path.join(out, "{}-v{}.zip".format(ADDON, version))
    with zipfile.ZipFile(target, "w", zipfile.ZIP_DEFLATED) as package:
        for path in files:
            package.write(os.path.join(ROOT, path), ADDON + "/" + path)
    notes = changelog_section(version) or "See the CHANGELOG."
    notes += ("\n\n### Install\nUnzip, put the `{0}` folder in `World of Warcraft/_classic_beta_/Interface/AddOns/`, "
              "then restart the game fully.\n\n[Full changelog](CHANGELOG.md) · [Discord](https://discord.gg/Hr66t25vE7)\n"
              ).format(ADDON)
    notes = notes.replace("](CHANGELOG.md)",
                          "](https://github.com/Torchlite-bit/Aegis_Forever_Instance_Journal/blob/main/CHANGELOG.md)")
    with open(os.path.join(out, "notes.md"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(notes)
    # For the release workflow (.github/workflows/release.yml): the version, as a step output.
    if os.environ.get("GITHUB_OUTPUT"):
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as handle:
            handle.write("version={}\n".format(version))
    print("Wrote {} ({} addon files, {:.1f} MB) and its notes".format(target, len(files), os.path.getsize(target) / 1024 / 1024))


def main():
    version, listed = toc_version_and_files()
    if not version:
        sys.exit("No ## Version in the TOC.")
    files = addon_files()
    missing = [path for path in listed if path not in files]
    if missing:
        sys.exit("The TOC lists files that are not there: " + ", ".join(missing))

    # python Tools/package.py --public <folder>: the public release instead of the testers' package.
    if "--public" in sys.argv:
        index = sys.argv.index("--public")
        public_release(sys.argv[index + 1] if len(sys.argv) > index + 1 else "dist", version, files)
        return

    os.makedirs(RELEASES, exist_ok=True)
    target = os.path.join(RELEASES, "{}_v{}_testers.zip".format(ADDON, version))
    alex = textwrap.fill("- Alex Atlas Loot, by Alex Brandson and its contributors: the inspiration for "
                         "the Record tab, the raids and the Forever marks, and the copy of WoW: Forever's "
                         "emblem the journal uses. Contributors: " + contributors() + ".", width=78, subsequent_indent="  ")
    readme = README.format(version=version, alex=alex).replace("\n", "\r\n")
    with zipfile.ZipFile(target, "w", zipfile.ZIP_DEFLATED) as package:
        for path in files:
            package.write(os.path.join(ROOT, path), ADDON + "/" + path)
        package.writestr("Tester Guide.html", guide_page())
        package.writestr("README.txt", readme)

    size = os.path.getsize(target)
    print("Wrote {} ({} addon files, {:.1f} MB)".format(target, len(files), size / 1024 / 1024))


if __name__ == "__main__":
    main()
