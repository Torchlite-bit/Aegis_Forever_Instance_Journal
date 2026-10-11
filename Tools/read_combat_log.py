"""
Reads the game's combat logs (Logs/WoWCombatLog-*.txt, written while the Record tab runs inside
dungeons) and reports, for each boss encounter, the creatures that fought and what they cast:
how hard each spell hit, how often, and how soon after the pull.

    python Tools/read_combat_log.py                 report every log
    python Tools/read_combat_log.py --json out.json the same, as data for build_data.py

The journal's own reader: nothing here comes from another addon.
"""

import csv
import glob
import json
import os
import re
import sys
from datetime import datetime

GAME = r"C:\Program Files (x86)\World of Warcraft\_classic_beta_"
LOGS = os.path.join(GAME, "Logs", "WoWCombatLog*.txt")

LINE = re.compile(r"^(\d+)/(\d+)/(\d+) (\d+):(\d+):(\d+)\.(\d+)(?:[-+]\d+)?\s\s(.*)$")
# The events whose source casts or deals a spell, and where the amount sits after the spell's
# three fields (id, name, school).
SPELL_EVENTS = {"SPELL_CAST_START", "SPELL_CAST_SUCCESS", "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE",
                "SPELL_AURA_APPLIED", "SPELL_SUMMON", "SPELL_HEAL", "SPELL_MISSED"}
CAST_EVENTS = {"SPELL_CAST_START", "SPELL_CAST_SUCCESS"}
HOSTILE = 0x40  # COMBATLOG_OBJECT_REACTION_HOSTILE
# Forever writes the target's state (guid, owner, health, power, position, facing, level...)
# after the spell on damage lines whether or not advanced logging is on: 19 fields before the
# amount (combat log version 22).
ADVANCED_FIELDS = 19


def amount(row):
    index = 12
    if len(row) > 12 and ("-" in row[12] or row[12] == "0000000000000000"):
        index += ADVANCED_FIELDS
    return int(row[index]) if len(row) > index else None


def parse_time(match):
    month, day, year, hour, minute, second, millis = (int(x) for x in match.groups()[:7])
    return datetime(year, month, day, hour, minute, second, millis * 1000)


def fields(text):
    return next(csv.reader([text]))


def npc_id(guid):
    parts = guid.split("-")
    if parts[0] in ("Creature", "Vehicle") and len(parts) > 5:
        return int(parts[5])
    return None


class Encounter:
    def __init__(self, encounter_id, name, instance_id, started):
        self.id, self.name, self.instance_id, self.started = encounter_id, name, instance_id, started
        self.ended, self.success = None, None
        self.creatures = {}  # npcID -> name
        self.spells = {}     # (npcID, spellID) -> stats

    def spell(self, npc, spell_id, name, school):
        key = (npc, spell_id)
        if key not in self.spells:
            self.spells[key] = {"spellID": spell_id, "name": name, "school": school, "casts": [], "hits": [],
                                "ticks": [], "auraOn": set()}
        return self.spells[key]


def read_log(path):
    encounters, current = [], None
    with open(path, encoding="utf-8", errors="replace") as handle:
        for raw in handle:
            match = LINE.match(raw.rstrip("\n"))
            if not match:
                continue
            when = parse_time(match)
            row = fields(match.group(8))
            event = row[0]
            if event == "ENCOUNTER_START":
                current = Encounter(int(row[1]), row[2], int(row[5]), when)
                encounters.append(current)
                continue
            if event == "ENCOUNTER_END":
                if current and current.id == int(row[1]):
                    current.ended, current.success = when, row[5] == "1"
                current = None
                continue
            if not current or event not in SPELL_EVENTS or len(row) < 12:
                continue
            source_guid, source_name, source_flags = row[1], row[2], int(row[3], 16)
            npc = npc_id(source_guid)
            if npc is None or not source_flags & HOSTILE:
                continue
            current.creatures[npc] = source_name
            spell_id, spell_name, school = int(row[9]), row[10], int(row[11], 16)
            stats = current.spell(npc, spell_id, spell_name, school)
            seconds = (when - current.started).total_seconds()
            if event in CAST_EVENTS:
                # A cast that starts and then succeeds is one cast: keep the start.
                if not stats["casts"] or seconds - stats["casts"][-1] > 1.0 or event == "SPELL_CAST_START":
                    if not (event == "SPELL_CAST_SUCCESS" and stats["casts"] and seconds - stats["casts"][-1] <= 5.0
                            and stats.get("lastStart") == stats["casts"][-1]):
                        stats["casts"].append(seconds)
                        if event == "SPELL_CAST_START":
                            stats["lastStart"] = seconds
            elif event == "SPELL_DAMAGE" and amount(row) is not None:
                stats["hits"].append(amount(row))
            elif event == "SPELL_PERIODIC_DAMAGE" and amount(row) is not None:
                stats["ticks"].append(amount(row))
            elif event == "SPELL_AURA_APPLIED":
                stats["auraOn"].add(row[5] == source_guid)
    return encounters


def summarise(stats):
    out = {"spellID": stats["spellID"], "name": stats["name"], "school": stats["school"]}
    if stats["hits"]:
        hits = stats["hits"]
        out["hit"] = [min(hits), max(hits), round(sum(hits) / len(hits))]
    if stats["ticks"]:
        ticks = stats["ticks"]
        out["tick"] = [min(ticks), max(ticks)]
    casts = stats["casts"]
    if casts:
        out["firstCast"] = round(casts[0])
        gaps = [b - a for a, b in zip(casts, casts[1:])]
        if gaps:
            out["every"] = [round(min(gaps)), round(max(gaps))]
        out["casts"] = len(casts)
    if stats["auraOn"] == {True}:
        out["onSelf"] = True
    return out


def main():
    paths = sorted(glob.glob(LOGS))
    report = []
    for path in paths:
        for encounter in read_log(path):
            entry = {"log": os.path.basename(path), "encounterID": encounter.id, "name": encounter.name,
                     "instanceID": encounter.instance_id, "started": encounter.started.isoformat(sep=" "),
                     "seconds": round((encounter.ended - encounter.started).total_seconds()) if encounter.ended else None,
                     "killed": encounter.success, "creatures": {}}
            for npc, name in encounter.creatures.items():
                spells = [summarise(s) for (owner, _), s in encounter.spells.items() if owner == npc]
                spells = [s for s in spells if s["name"] != "Melee"]
                entry["creatures"][npc] = {"name": name, "spells": sorted(spells, key=lambda s: s.get("firstCast", 9999))}
            report.append(entry)
    if "--json" in sys.argv:
        with open(sys.argv[sys.argv.index("--json") + 1], "w", encoding="utf-8") as handle:
            json.dump(report, handle, indent=1)
        return 0
    for entry in report:
        print("== %s (encounter %d, instance %d) %s, %ss, %s" % (entry["name"], entry["encounterID"], entry["instanceID"],
              entry["started"], entry["seconds"], "kill" if entry["killed"] else "wipe/unfinished"))
        for npc, creature in entry["creatures"].items():
            print("   %s (npc %d)" % (creature["name"], npc))
            for spell in creature["spells"]:
                print("      %-28s %6d  %s" % (spell["name"], spell["spellID"],
                      ", ".join("%s=%s" % (k, spell[k]) for k in ("hit", "tick", "firstCast", "every", "casts", "onSelf") if k in spell)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
