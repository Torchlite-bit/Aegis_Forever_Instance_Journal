"""
Loads the addon the way the client would (files in TOC order, sharing one namespace)
against Tools/wow_mock.lua, then runs Tools/smoke_scenario.lua, which clicks through the
journal and checks what it shows. Then it loads it again as a Russian client and runs
Tools/locale_scenario.lua, which checks the translation against the English.

    python Tools/smoke_test.py

Needs the lupa package (pip install lupa), which bundles Lua 5.1, WoW's Lua version.
It catches mistakes in the addon's own logic. It does not show what the window looks
like; only the game does that.
"""

import os
import re
import sys
from xml.etree import ElementTree

import lupa.lua51 as lupa

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TOOLS = os.path.join(ROOT, "Tools")
ADDON = "Aegis_Forever_Instance_Journal"


def toc_files():
    with open(os.path.join(ROOT, ADDON + ".toc"), encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if line and not line.startswith("#"):
                yield line.replace("\\", os.sep)


def read(path):
    with open(path, encoding="utf-8") as handle:
        return handle.read()


def run_pass(scenario, locale="enUS", saved=None):
    # As the game: Lua's string.lower and the like know ASCII letters only. Python sets the C
    # library to the system's code page, which would lower UTF-8 bytes of accented letters.
    import locale as c_locale
    c_locale.setlocale(c_locale.LC_CTYPE, "C")
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute("date = os.date; debugstack = function() return debug.traceback() end")
    lua.execute("WOWMOCK_LOCALE = '%s'" % locale)
    lua.execute(read(os.path.join(TOOLS, "wow_mock.lua")))
    # Saved variables the client reads before the files (the TOC's LoadSavedVariablesFirst).
    if saved:
        lua.execute(saved)
    # The English strings as enUS.lua leaves them, before another language is laid over them.
    keep_english = lua.eval("""function(ns)
        local copy = {}
        for key, value in pairs(ns.L or {}) do copy[key] = value end
        WOWMOCK.english = copy
    end""")

    load = lua.eval("""function(source, name, addon, ns)
        local chunk, err = loadstring(source, "@" .. name)
        if not chunk then error(err) end
        local ok, runErr = xpcall(function() return chunk(addon, ns) end, debug.traceback)
        if not ok then error(runErr) end
    end""")
    register = lua.eval("""function(name, frameType, mixin)
        WOWMOCK.xmlTemplates[name] = { type = frameType, mixin = mixin }
    end""")
    memory = lua.eval('function() collectgarbage("collect") return collectgarbage("count") end')
    before = memory()
    ns = lua.table()
    for relative in toc_files():
        if relative.lower().endswith(".xml"):
            # The client reads these; here they are checked for well-formedness and their
            # virtual templates registered, so CreateFrame applies each one's mixin.
            tree = ElementTree.parse(os.path.join(ROOT, relative))
            for element in tree.getroot().iter():
                if element.get("virtual") == "true" and element.get("name"):
                    register(element.get("name"), element.tag.split("}")[-1], element.get("mixin"))
            continue
        load(read(os.path.join(ROOT, relative)), relative, ADDON, ns)
        if relative.replace(os.sep, "/") == "Locales/enUS.lua":
            keep_english(ns)
    loaded = memory() - before
    print("Loaded %d files from the TOC (%s)." % (len(list(toc_files())), locale))

    run = lua.eval("""function(source, name, ns, loaded)
        local chunk = assert(loadstring(source, "@" .. name))
        return xpcall(function() return chunk(ns, loaded) end, debug.traceback)
    end""")
    ok, result = run(read(os.path.join(TOOLS, scenario)), scenario, ns, loaded)
    if not ok:
        print("FAILED:\n" + str(result))
        return 1
    print(result)
    return 0


def main():
    # A failed check may quote any language's text: print it whatever the console's code page.
    sys.stdout.reconfigure(errors="backslashreplace")
    # --perf times the heavy operations instead of checking behaviour (Tools/perf_scenario.lua).
    if "--perf" in sys.argv[1:]:
        return run_pass("perf_scenario.lua")
    # Then each language the TOC lists a translation for.
    locales = [name[len("Locales/"):-len(".lua")] for name in (f.replace(os.sep, "/") for f in toc_files())
               if name.startswith("Locales/") and len(name) == len("Locales/xxXX.lua") and not name.endswith("enUS.lua")]
    return (run_pass("smoke_scenario.lua") or next((1 for code in locales if run_pass("locale_scenario.lua", code)), 0)
            # /aegis lang: German previewed on an English client.
            or run_pass("preview_scenario.lua", "enUS", "AegisJournalDB = { previewLocale = 'deDE' }"))


if __name__ == "__main__":
    sys.exit(main())
