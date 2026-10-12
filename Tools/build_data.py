"""
Builds the journal's generated data from its own data files and the player's recordings.

    python Tools/build_data.py

The dungeons, their abilities, factions and transports are the journal's own files
(Data/Instances, Data/Authored, Data/Reputation, Data/Travel), edited by hand. This tool writes:
  Data/Generated/Abilities.lua    what the combat logs of recorded runs saw: encounter ids,
                                  damage, timings, spells the written abilities lack, and the
                                  adds that cast in each fight; pasted recordings add encounter ids,
                                  and the spells the Log Reader page read from a tester's log
  Data/Generated/Unconfirmed.lua  items an /aegis items scan found the server knows nothing of
  Data/Reputation/Captured.lua    the reputation quartermasters captured in game

Reads (never modifies): the journal's Data/Instances and Data/Authored files, for the bosses;
the game's combat logs and the ones testers send (Recordings/); the saved files (the player's
and the testers'); recordings pasted in Discord and saved as text (Recordings/**/*.txt).

Needs the luaparser package (pip install luaparser).
"""

import glob
import os
import re
import sys

from luaparser import ast

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GAME = os.environ.get("AEGIS_GAME", r"C:\Program Files (x86)\World of Warcraft\_classic_beta_")
# The reference folder: the testers' recordings and the reference addons' zip.
REFERENCE = os.environ.get("AEGIS_REFERENCE",
                           os.path.join(os.path.expanduser("~"), "OneDrive", "Pictures", "Forever Instance Journal"))

# The journal's own saved files (every account on this computer), and the testers' copies of
# theirs and their logs (Recordings/<name>/).
AEGIS_SAVED = os.path.join(GAME, "WTF", "Account", "*", "SavedVariables", "Aegis_Forever_Instance_Journal.lua")
RECORDINGS = os.path.join(REFERENCE, "Recordings")
INSTANCES = os.path.join(ROOT, "Data", "Instances")
AUTHORED = os.path.join(ROOT, "Data", "Authored")
OUT = os.path.join(ROOT, "Data", "Generated")


# ---------------------------------------------------------------------------------------
# Reading Lua
# ---------------------------------------------------------------------------------------

def read(path):
    with open(path, encoding="utf-8") as handle:
        return handle.read()


def to_python(node):
    kind = type(node).__name__
    if kind == "Table":
        array, mapping = [], {}
        for field in node.fields:
            if field.key is None:
                array.append(to_python(field.value))
                continue
            key = field.key
            if type(key).__name__ == "Name" and not field.between_brackets:
                key = key.id
            else:
                key = to_python(key)
            mapping[key] = to_python(field.value)
        if array and not mapping:
            return array
        for index, value in enumerate(array, 1):
            mapping[index] = value
        return mapping
    if kind == "String":
        return node.s.decode("utf-8") if isinstance(node.s, bytes) else node.s
    if kind == "Number":
        return node.n
    if kind == "UMinusOp":
        return -to_python(node.operand)
    if kind == "TrueExpr":
        return True
    if kind == "FalseExpr":
        return False
    if kind == "Concat":
        return "%s%s" % (to_python(node.left), to_python(node.right))
    if kind in ("FloatDivOp", "MultOp", "AddOp", "SubOp"):
        left, right = to_python(node.left), to_python(node.right)
        if not isinstance(left, (int, float)) or not isinstance(right, (int, float)):
            return None
        return {"FloatDivOp": lambda: left / right, "MultOp": lambda: left * right,
                "AddOp": lambda: left + right, "SubOp": lambda: left - right}[kind]()
    # A name (a file's local constant) or a call: not plain data, so left out.
    return None


def table_from_block(path, start_marker, after=None, start=0):
    """Parses one `X = { ... }` block out of a large file without parsing the rest: the first
    after the `after` marker (or the `start` offset), when one is given."""
    source = read(path)
    begin = source.index(start_marker, source.index(after) if after else start)
    brace = source.index("{", begin)
    depth, index, in_string = 0, brace, None
    while index < len(source):
        char = source[index]
        if in_string:
            if char == "\\":
                index += 1
            elif char == in_string:
                in_string = None
        elif char in "\"'":
            in_string = char
        elif char == "-" and source.startswith("--", index):
            index = source.index("\n", index)
            continue
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                break
        index += 1
    block = "x = " + source[brace:index + 1]
    tree = ast.parse(block)
    return to_python(tree.body.body[0].values[0])


def as_list(value):
    if isinstance(value, list):
        return value
    if isinstance(value, dict):
        return [value[k] for k in sorted(k for k in value if isinstance(k, int))]
    return []


# ---------------------------------------------------------------------------------------
# The journal's bosses
# ---------------------------------------------------------------------------------------

def load_instances():
    """Each dungeon in Data/Instances, as {key, instanceID, bosses}, with the bosses the files
    in Data/Authored add (addBosses)."""
    instances = {}
    # Each instance table in a file: ns.AddInstance({ ... }), or a file's own helper (Raid({ ... })).
    opening = re.compile(r"\b(?:ns\.AddInstance|Raid)\(\{")
    for path in sorted(glob.glob(os.path.join(INSTANCES, "*.lua"))):
        for match in opening.finditer(read(path)):
            data = table_from_block(path, match.group(0), start=match.start())
            instances[data["key"]] = {"key": data["key"], "instanceID": data.get("instanceID"),
                                      "bosses": [dict(boss) for boss in as_list(data.get("bosses"))]}
    amend = re.compile(r'ns\.AmendInstance\("(\w+)", \{')
    for path in sorted(glob.glob(os.path.join(AUTHORED, "*.lua"))):
        source = read(path)
        for match in amend.finditer(source):
            if match.group(1) not in instances:
                continue
            patch = table_from_block(path, "ns.AmendInstance(", start=match.start())
            known = {boss["name"] for boss in instances[match.group(1)]["bosses"]}
            for boss in as_list(patch.get("addBosses")):
                if boss.get("name") and boss["name"] not in known:
                    instances[match.group(1)]["bosses"].append(dict(boss))
    return instances


# ---------------------------------------------------------------------------------------
# Recorded runs: the game's own combat logs, read by Tools/read_combat_log.py
# ---------------------------------------------------------------------------------------

def merge_spell(into, spell):
    """Two sightings of one spell: the widest ranges, the earliest first cast."""
    for key in ("hit", "tick", "every"):
        if key in spell:
            if key in into:
                low, high = min(into[key][0], spell[key][0]), max(into[key][1], spell[key][1])
                into[key] = [low, high] + ([round((into[key][2] + spell[key][2]) / 2)] if key == "hit" else [])
            else:
                into[key] = list(spell[key])
    if "firstCast" in spell:
        into["firstCast"] = min(into.get("firstCast", spell["firstCast"]), spell["firstCast"])
    if spell.get("onSelf"):
        into["onSelf"] = True


def recorded_spells(spells):
    """A creature's spells as the journal keeps them (no cast counts)."""
    return [{k: v for k, v in spell.items() if k != "casts"} for spell in spells]


def load_recordings():
    """Every boss encounter in the player's combat logs and the testers', by instance id."""
    try:
        import read_combat_log
    except ImportError:
        return {}
    paths = sorted(glob.glob(read_combat_log.LOGS))
    paths += sorted(glob.glob(os.path.join(RECORDINGS, "**", "WoWCombatLog*.txt"), recursive=True))
    by_instance = {}
    for path in paths:
        for encounter in read_combat_log.read_log(path):
            creatures = {}
            for npc, name in encounter.creatures.items():
                spells = [read_combat_log.summarise(s) for (owner, _), s in encounter.spells.items() if owner == npc]
                creatures[npc] = {"name": name, "spells": [s for s in spells if s["name"] != "Melee"]}
            by_instance.setdefault(encounter.instance_id, []).append(
                {"id": encounter.id, "name": encounter.name, "creatures": creatures, "unfinished": encounter.ended is None})
    # Pasted recordings: their ENCOUNTER lines name each fight and its id; the FIGHT and SPELL lines
    # the Log Reader page adds (docs/log-reader) carry what the tester's combat log saw cast in it.
    # ENCOUNTER;encounterID;name;instanceID;kills;wipes;seconds;area
    # FIGHT;encounterID;name;instanceID;seconds;result
    # SPELL;encounterID;npcID;creature;spellID;spell;school;casts;hitMin;hitMax;hitAvg;tickMin;tickMax;
    #       firstCast;everyMin;everyMax;onSelf
    for lines in pasted_recordings():
        fights = {}
        for fields in (line.split(";") for line in lines):
            if fields[0] in ("ENCOUNTER", "FIGHT") and len(fields) >= 4 and fields[2]:
                encounter_id, instance_id = number(fields[1]), number(fields[3])
                if not (isinstance(encounter_id, int) and isinstance(instance_id, int)):
                    continue
                known = by_instance.setdefault(instance_id, [])
                if fields[0] == "FIGHT":
                    # Each pull is its own fight; its SPELL lines follow it. No result: it never ended.
                    fights[encounter_id] = {"id": encounter_id, "name": fields[2], "creatures": {},
                                            "unfinished": len(fields) < 6 or not fields[5]}
                    known.append(fights[encounter_id])
                elif not any(e["id"] == encounter_id for e in known):
                    known.append({"id": encounter_id, "name": fields[2], "creatures": {}})
            elif fields[0] == "SPELL" and len(fields) >= 17 and number(fields[1]) in fights:
                npc, spell = number(fields[2]), pasted_spell(fields)
                if isinstance(npc, int) and spell:
                    creature = fights[number(fields[1])]["creatures"].setdefault(npc, {"name": fields[3], "spells": []})
                    creature["spells"].append(spell)
    return by_instance


def pasted_spell(fields):
    """A Log Reader SPELL line as read_combat_log.summarise gives the spell (Melee left out)."""
    spell_id, school, casts = number(fields[4]), number(fields[6]), number(fields[7])
    if not isinstance(spell_id, int) or not fields[5] or fields[5] == "Melee":
        return None
    spell = {"spellID": spell_id, "name": fields[5], "school": school if isinstance(school, int) else 0}
    for key, values in (("hit", fields[8:11]), ("tick", fields[11:13]), ("every", fields[14:16])):
        values = [number(v) for v in values]
        if all(isinstance(v, int) for v in values):
            spell[key] = values
    if isinstance(number(fields[13]), int):
        spell["firstCast"] = number(fields[13])
    if isinstance(casts, int) and casts > 0:
        spell["casts"] = casts
    if fields[16] == "1":
        spell["onSelf"] = True
    return spell


def apply_recordings(bosses, encounters):
    """Encounter ids, the spells the logs saw that the journal lacks, and each fight's adds: the
    other creatures that cast spells in it (trash only caught in it casts nothing). A fight the
    game never ended (Lorgus Jett's) ran on through the trash after it: only the boss's own
    spells count there. A creature that only buffed itself is not an add."""
    for boss in bosses:
        names = set([boss["name"]] + (as_list(boss.get("aliases")) or []))
        mine = [e for e in encounters if boss.get("npcID") in e["creatures"] or e["name"] in names]
        if not mine:
            continue
        boss["encounterID"] = mine[0]["id"]
        known = {a["spellID"]: a for a in boss.get("abilities") or []}
        adds = {}
        for encounter in mine:
            for npc, creature in encounter["creatures"].items():
                if npc == boss.get("npcID"):
                    # Only what it cast or hit with: an effect a cast leaves (the fear of a shout)
                    # is part of that cast.
                    acted = [s for s in creature["spells"] if s.get("casts") or "hit" in s or "tick" in s]
                    for spell in recorded_spells(acted):
                        if spell["spellID"] in known:
                            # A spell the sources name: the recording adds its numbers.
                            merge_spell(known[spell["spellID"]], spell)
                        else:
                            known[spell["spellID"]] = spell
                            boss.setdefault("abilities", []).append(spell)
                    continue
                if encounter.get("unfinished"):
                    continue
                cast = [s for s in creature["spells"]
                        if s.get("casts") and not (s.get("onSelf") and "hit" not in s and "tick" not in s)]
                if not cast:
                    continue
                add = adds.setdefault(npc, {"name": creature["name"], "npcID": npc, "abilities": {}})
                for spell in recorded_spells(cast):
                    if spell["spellID"] in add["abilities"]:
                        merge_spell(add["abilities"][spell["spellID"]], spell)
                    else:
                        add["abilities"][spell["spellID"]] = spell
        if adds:
            boss["adds"] = [{"name": a["name"], "npcID": a["npcID"],
                             "abilities": sorted(a["abilities"].values(), key=lambda s: s.get("firstCast", 9999))}
                            for a in adds.values()]


# ---------------------------------------------------------------------------------------
# /aegis items scans
# ---------------------------------------------------------------------------------------

def load_unconfirmed():
    """Items an /aegis items scan found the server knows nothing of, from the player's saved file
    and the testers' (Recordings/<name>/), less any a recorded run saw drop: the journal hides
    them until confirmed. Returns ({itemID: where}, scans read)."""
    files = sorted(glob.glob(AEGIS_SAVED)) + glob.glob(os.path.join(RECORDINGS, "**", "Aegis_Forever_Instance_Journal.lua"), recursive=True)
    missing, seen, scans = {}, set(), 0
    for path in files:
        if not os.path.exists(path):
            continue
        text = read(path)
        if '["missingItems"] = {' in text:
            items = table_from_block(path, '["missingItems"] = {').get("items") or {}
            missing.update({item_id: where for item_id, where in items.items() if isinstance(item_id, int)})
            scans += 1
        record = '["record"] = {'
        if record in text and '["loot"] = {' in text[text.index(record):]:
            # The Record tab's loot: instance -> source -> item id.
            loot = table_from_block(path, '["loot"] = {', after=record)
            for sources in loot.values() if isinstance(loot, dict) else []:
                for items in sources.values() if isinstance(sources, dict) else []:
                    seen.update(i for i in (items if isinstance(items, dict) else {}) if isinstance(i, int))
    return {item_id: where for item_id, where in missing.items() if item_id not in seen}, scans


# ---------------------------------------------------------------------------------------
# Captured quartermasters
# ---------------------------------------------------------------------------------------

def number(text):
    try:
        return float(text) if "." in text else int(text)
    except ValueError:
        return None


def pasted_recordings():
    """The lines of each recording pasted in Discord and saved as text (Recordings/**/*.txt, any
    file holding an "AEGIS RECORDING;" header; combat logs are skipped)."""
    for path in sorted(glob.glob(os.path.join(RECORDINGS, "**", "*.txt"), recursive=True)):
        if os.path.basename(path).startswith("WoWCombatLog"):
            continue
        with open(path, encoding="utf-8", errors="replace") as handle:
            lines = handle.read().splitlines()
        if any(line.startswith("AEGIS RECORDING;") for line in lines):
            yield lines


def load_vendors():
    """Reputation quartermasters captured in game (the Reputation tab's Capture button, or a
    recording): from the saved files (the player's and Recordings/<name>/) and from recordings
    pasted in Discord and saved as text (Recordings/**/*.txt, the "VENDOR;" lines). Only the wares
    that need a standing are kept. Returns ([vendor, ...] by npc id, sources read)."""
    vendors, sources = {}, 0

    def vendor_for(npc_id, name, map_id, x, y):
        vendor = vendors.setdefault(npc_id, {"npcID": npc_id, "wares": {}})
        vendor.update({k: v for k, v in (("name", name), ("mapID", map_id), ("x", x), ("y", y)) if v is not None})
        return vendor

    def add_ware(vendor, item_id, price, cost, faction, reaction):
        # No faction with a standing: the tooltip said "this faction", the vendor's own, which the
        # journal works out at load (Registry ns.WareFaction).
        if isinstance(item_id, int) and isinstance(reaction, int):
            vendor["wares"][item_id] = {"itemID": item_id, "price": price or None, "cost": cost or None,
                                        "faction": faction or None, "reaction": reaction}

    saved = sorted(glob.glob(AEGIS_SAVED)) + glob.glob(os.path.join(RECORDINGS, "**", "Aegis_Forever_Instance_Journal.lua"), recursive=True)
    for path in saved:
        text = read(path)
        record = '["record"] = {'
        if record not in text or '["vendors"] = {' not in text[text.index(record):]:
            continue
        sources += 1
        table = table_from_block(path, '["vendors"] = {', after=record)
        for npc_id, entry in (table.items() if isinstance(table, dict) else []):
            if not isinstance(npc_id, int) or not isinstance(entry, dict):
                continue
            place = entry.get("place") or {}
            vendor = vendor_for(npc_id, entry.get("name"), place.get("mapID"), place.get("x"), place.get("y"))
            for item_id, ware in (entry.get("items") or {}).items():
                if isinstance(ware, dict):
                    add_ware(vendor, item_id, ware.get("price"), ware.get("cost"), ware.get("faction"), ware.get("reaction"))

    # VENDOR;npcID;vendor;mapID;x;y;itemID;item;price;faction;reaction;cost
    for lines in pasted_recordings():
        sources += 1
        for line in lines:
            fields = line.split(";")
            if fields[0] != "VENDOR" or len(fields) < 11:
                continue
            fields += [""] * (12 - len(fields))
            npc_id = number(fields[1])
            if not isinstance(npc_id, int):
                continue
            vendor = vendor_for(npc_id, fields[2] or None, number(fields[3]), number(fields[4]), number(fields[5]))
            add_ware(vendor, number(fields[6]), number(fields[8]), fields[11], fields[9], number(fields[10]))

    found = []
    for npc_id in sorted(vendors):
        vendor = vendors[npc_id]
        if vendor["wares"]:
            vendor["wares"] = [vendor["wares"][i] for i in sorted(vendor["wares"])]
            found.append(vendor)
    return found, sources


# ---------------------------------------------------------------------------------------
# Writing Lua
# ---------------------------------------------------------------------------------------

IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def lua_string(text):
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def lua(value, indent=1):
    pad, inner = "\t" * (indent - 1), "\t" * indent
    if value is None:
        return "nil"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, (int, float)):
        return repr(round(value, 4)) if isinstance(value, float) else str(value)
    if isinstance(value, str):
        return lua_string(value)
    if isinstance(value, list):
        if not value:
            return "{}"
        if all(not isinstance(v, (dict, list)) for v in value):
            inline = "{ " + ", ".join(lua(v) for v in value) + " }"
            # Short lists on one line; long ones (sentences) one item to a line.
            if len(inline) <= 100:
                return inline
            return "{\n" + "".join(inner + lua(v) + ",\n" for v in value) + pad + "}"
        return "{\n" + "".join(inner + lua(v, indent + 1) + ",\n" for v in value) + pad + "}"
    if isinstance(value, dict):
        items = [(k, v) for k, v in value.items() if v is not None]
        if not items:
            return "{}"
        lines = []
        for key, entry in items:
            name = key if isinstance(key, str) and IDENTIFIER.match(key) else "[" + lua(key) + "]"
            lines.append(inner + name + " = " + lua(entry, indent + 1) + ",\n")
        return "{\n" + "".join(lines) + pad + "}"
    raise TypeError(type(value))


def write(name, text, folder=OUT):
    os.makedirs(folder, exist_ok=True)
    with open(os.path.join(folder, name), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(text)


def main():
    instances, recordings = load_instances(), load_recordings()
    abilities, report = {}, []
    for key, instance in sorted(instances.items()):
        bosses = [b for b in instance["bosses"] if not b.get("trash")]
        for boss in bosses:
            # Only what the recordings saw: the boss's spells themselves are Data/Authored/Abilities.lua.
            boss["abilities"] = []
        apply_recordings(bosses, recordings.get(instance["instanceID"], []))
        found = {}
        for boss in bosses:
            entry = {"abilities": boss.get("abilities") or None, "adds": boss.get("adds"),
                     "encounterID": boss.get("encounterID")}
            if any(v is not None for v in entry.values()):
                found[boss["name"]] = entry
        if found:
            abilities[key] = found
        report.append("%-26s %d of %d bosses with abilities, %d recorded"
                      % (key, sum(1 for e in found.values() if e["abilities"]), len(bosses),
                         sum(1 for e in found.values() if e["encounterID"])))
    write("Abilities.lua",
          "-- Generated by Tools/build_data.py from recorded runs (the game's own combat logs, the\n"
          "-- player's and the testers'): each boss's encounter id, the damage and timings of its spells,\n"
          "-- the spells it cast that Data/Authored/Abilities.lua lacks, and the adds that fought beside it.\n"
          "-- Do not edit by hand: rerun the tool. The numbers join the written abilities by spell id.\n\n"
          "local _, ns = ...\n\nns.SetAbilities(%s)\n" % lua(abilities))
    unconfirmed, scans = load_unconfirmed()
    write("Unconfirmed.lua",
          "-- Generated by Tools/build_data.py from %d /aegis items scan(s): the items the server knew\n"
          "-- nothing of, by where the journal lists them, less any a recorded run saw drop. The journal\n"
          "-- hides them until confirmed (Core/Items.lua). Do not edit by hand.\n\n"
          "local _, ns = ...\n\nns.Items:AddUnconfirmed(%s)\n" % (scans, lua(dict(sorted(unconfirmed.items())))))
    report.append("%-26s %d items from %d scan(s)" % ("Unconfirmed", len(unconfirmed), scans))
    vendors, vendor_sources = load_vendors()
    write("Captured.lua",
          "-- Generated by Tools/build_data.py from %d recording(s) and saved file(s). Do not edit by hand.\n"
          "-- Reputation rewards captured in game: each vendor, where they stand, and their wares that\n"
          "-- need a standing (price in copper, any other cost, the faction and standing).\n\n"
          "local _, ns = ...\n\nns.AddCapturedVendors(%s)\n" % (vendor_sources, lua(vendors)),
          folder=os.path.join(ROOT, "Data", "Reputation"))
    report.append("%-26s %d quartermaster(s), %d wares" % ("Captured", len(vendors), sum(len(v["wares"]) for v in vendors)))
    print("\n".join(report))


if __name__ == "__main__":
    sys.exit(main())
