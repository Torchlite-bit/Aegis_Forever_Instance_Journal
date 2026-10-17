"""Lists every English word the content translation looks up, from the data as it loads now.

    python Tools/locale_keys.py [out.json]

Runs the addon in Lua (as Tools/smoke_test.py does) with Tools/locale_keys.lua, and writes the
words a translation's Locales/<code>_content.lua has to cover, as JSON: bossNames, abilityNames,
strings (free text), instanceNames, factionNames, subMapNames and the area names the journal
matches the client's against. With a file name it writes there and prints how many of each;
without one it prints the JSON.
"""

import io
import json
import os
import sys

import smoke_test

TOOLS = os.path.dirname(os.path.abspath(__file__))


def keys():
    buf, real = io.StringIO(), sys.stdout
    sys.stdout = buf
    try:
        failed = smoke_test.run_pass(os.path.join(TOOLS, "locale_keys.lua"))
    finally:
        sys.stdout = real
    text = buf.getvalue()
    if failed:
        raise SystemExit(text)
    return json.loads(text[text.index("{"):text.rindex("}") + 1])


def main():
    data = keys()
    if len(sys.argv) > 1:
        with open(sys.argv[1], "w", encoding="utf-8") as handle:
            json.dump(data, handle, ensure_ascii=False, indent=1)
        for name, value in data.items():
            print("%-14s %d" % (name, len(value)))
    else:
        sys.stdout.reconfigure(encoding="utf-8")
        print(json.dumps(data, ensure_ascii=False, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
