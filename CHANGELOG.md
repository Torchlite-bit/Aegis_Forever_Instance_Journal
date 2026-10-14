# Changelog

All notable changes to **Aegis: Forever Instance Journal**.

Format loosely follows [Keep a Changelog](https://keepachangelog.com/).
The version here matches `## Version` in `Aegis_Forever_Instance_Journal.toc`
and the version shown in the AddOns list. Quote it in bug reports.

> ⚠️ Releases marked **restart** add a new file (a `.lua` file or a texture).
> The client reads those only at startup, so `/reload` won't pick them up: close
> the game fully and start it again. Everything else is `/reload`-safe.

---

## [0.27.0] (restart)

### Added
- **Zone level ranges on the world map.** Hover a zone on a continent map and its level
  range shows after its name, coloured for your level as quests are: red when it's above
  you, yellow while you're within it, green and grey below. Where the client knows a zone's
  range itself, its own shows instead.
- **Show unexplored areas.** A new tick box at the end of the world map's filter menu (the
  magnifying glass) draws the parts of a zone you haven't explored yet, a little darker
  than the parts you have. It is remembered across sessions and characters.

New files: close the game fully and start it again; `/reload` won't load them.

---

## [0.26.8]

### Changed
- **A new logo**: the Aegis shield and wings round an open journal, in a ring of runes. It is
  the journal's icon in the AddOns list and heads the README. The client may keep showing the
  old icon until the game is restarted.

---

## [0.26.7]

### Changed
- **Boss portraits are full circles** at the start of each plate, ringed in shaded gold like
  the faction cards' crests. The plate now starts behind the circle, so nothing of it shows
  to the portrait's left. Bosses without a known model and faction standings use the same circle.
- The boss list scrolls below the dungeon's icon, so a portrait never shows round it.

---

## [0.26.6]

### Changed
- The gold band round each boss portrait is twice as thick, closer to retail's rim.

---

## [0.26.5]

### Changed
- **Boss portraits sit in the plate's own cap**, as retail's boss pictures do, instead
  of a separate gold ring beside it. They fill the cap, cut flat by the plate's bottom
  edge, with a gold band that thickens the cap's thin rim to retail's, and the hover glow
  traces the cap without the old workaround.
- Recorded timings read as one number when they never varied ("then every 12s", not
  "12-12s").
- A boss's buff on itself that the written abilities don't list is left out (Kam
  Deepfury's Defensive Stance).

### Added
- **The Stockade from a recorded run**: encounter IDs, the bosses' recorded numbers,
  the Defias Insurgents that fight beside three of them, the ringleaders' heads and
  Dextren Ward's hand, the Red Wool Bandanas for The Color of Blood, and the entrance
  where the run walked in.

### Fixed
- **The Color of Blood** is marked where Nikova Raskol stands (73.3, 55.4).
- A quest the game already marks on the map (a "?" in your log) no longer gets a
  second mark from the journal on top of it.

---

## [0.26.4]

### Added
- **A Type filter on loot and reward pages**, in place of the slot filter: Equipment
  (by slot), Recipes (by profession: Alchemy, Blacksmithing, Enchanting…),
  Consumables, Mounts, Pets, Toys, Bags, Trade Goods and Quest Items. Only the kinds a
  page has are offered. A slot you had chosen carries over as Equipment.

### Fixed
- Recipes and other items that aren't worn showed ", Alchemy" where the slot goes; they
  now read "Recipe, Alchemy", "Mount", "Toy" and so on.

---

## [0.26.3]

### Fixed
- **Capture vendor** now keeps wares whose tooltip says only "Requires Friendly with
  this faction." Many quartermasters' wares, like the Azeroth Commerce Authority's
  craftsmen, never name their faction. The journal works it out from the wares that do:
  another ware of the same vendor, then the currency they cost (whatever Merchant's
  Favor buys belongs to the Authority), then a vendor standing beside them. Until one
  names it, the Capture line says the faction isn't named yet, and the wares wait.

### Added
- The **Azeroth Commerce Authority**'s rewards, captured from its nine vendors in
  Redridge: 183 wares bought with Merchant's Favor, from the craftsmen's recipes,
  plans, patterns, schematics and formulas (83 at Friendly, 97 at Honored) to the
  Packmule Treat (Revered), the Tabard and the Reins of the Pack Kodo (Exalted).

---

## [0.26.2]

### Added
- **Subtilizer** is the journal's first contributor, on the Record tab, for the
  Blackfathom Deeps run.
- **Sword of the Fallen** is back on the Ruins of Lordaeron's trash loot, dropped by
  Tattered Ghouls. The site's dungeon page leaves it out, so it had been dropped.

### Changed
- **Old Serra'kis only melees**: Leech Pulse, which his combat log showed, is no longer
  listed as an ability.

---

## [0.26.1]

From the first combat log sent through the Log Reader (Blackfathom Deeps).

### Added
- **Blackfathom Deeps' boss abilities now have numbers**: how hard each one hit, when it
  first came and how often, for all seven bosses with a fight. Old Serra'kis gains
  **Leech Pulse**.

### Fixed
- **A fight the game never ends** (Lorgus Jett's) no longer runs on through the trash
  after it. The Log Reader now ends it when he dies, and the journal takes only the
  boss's own spells from a fight with no end.
- A creature that only buffed itself near a boss is no longer listed as one of its adds.

### Changed
- Credits: Alex Atlas Loot is named again as the inspiration for the Record and
  Reputation tabs.
- The field guide no longer asks for travel marks: every route is in the journal.
- No more testers' zip: everyone gets the release from GitHub or CurseForge, and
  `Tools/package.py` builds only that.

---

## [0.26.0]

### Added
- **The Log Reader**, a web page that adds the bosses' spells from your combat log
  to your recording: https://torchlite-bit.github.io/Aegis_Forever_Instance_Journal/log-reader/
  Addons can't see what enemies cast inside Forever's dungeons, but the game's log
  file can. Paste your recording, drop in the log, and send the one text it gives
  back. The log is read in your browser and never uploaded. Only the enemies' spells
  from boss fights are kept, with no player names.
- The Record tab notes the log file it starts (Recent says `Combat log on:
  Logs\WoWCombatLog-….txt`). When a recording wrote one, **Copy** names the file
  and links the Log Reader.

### Changed
- The build tool reads the Log Reader's lines like a combat log file.

---

## [0.25.2]

From the first recorded Blackfathom Deeps run.

### Added
- **Blackfathom Deeps' encounter IDs** for all seven bosses that have a fight, so each
  fight is tied to its boss by ID, not by name (the game calls Gelihast's "Geilhast").
- Recordings pasted in Discord now give the journal their encounter IDs when the data
  is rebuilt.
- **Head of Kelris** on Twilight Lord Kelris's loot, for Blackfathom Villainy.

### Fixed
- The first pool is **The Pool of Ask'ar**, as the game names it. The Drowned Sacellum
  joins the list of the dungeon's areas.

---

## [0.25.1] (restart)

### Added
- **The Aegis Instance Journal logo**: the journal's icon in the AddOns list, and at
  the top of the README.

### Changed
- The README's screenshots are JPGs, so they show on CurseForge too.

---

## [0.25.0] (restart)

### Added
- **Capture vendor**, on the Reputation tab. Walk up to a quartermaster, open their
  shop, press the button: everything they sell is kept with its price, any other
  cost and the standing it needs. Their faction's rewards fill in at once, and the
  capture comes along with Copy on the Record tab. No need to be recording.
- **A placeholder for every faction nobody has captured yet**, saying how to
  capture it, with the Discord link. Forever's own factions say *Coming soon*.
- **Abilities for every boss of the 16 dungeons foreverchanges.pro describes**: what
  each ability does in the fight, its role alerts, the mechanics with no spell, and
  how the fight begins where it is unusual (Sneed's Shredder, the Fires of Aku'mai,
  Lyn the Ignored's summoning...). Lyn's raised skeletons no longer read
  "Retrieving data".
- **14 quests the journal lacked**, most of them the Horde's: in Maraudon, Uldaman,
  Dire Maul, Blackrock Spire, Gnomeregan, the Scarlet Monastery, the Excavation Site
  and the Drowned City.
- **WoW: Forever's emblem** marks Forever's dungeons and raids, with a tooltip.

### Changed
- **The Reputation tab's rewards come only from captured quartermasters.** The
  rewards lists from another addon are gone; every faction starts as a placeholder.
- **Loot matches the site again**: Forever's new leather helms and patterns where
  players have seen them, and the recipes seen on Kresh, Skum, Lady Anacondra,
  Rhahk'Zor and Captain Greenskin.
- **Mr. Smite's stages** are at 66% and 33% health, with the weapons he takes up.
- **The levels quests open at**, where the site differs, and the right giver for
  Destruction in Deadmines.
- **The README** has screenshots, and says the journal is a work in progress.

### Removed
- **The "New in Forever" label** on dungeon buttons (now the emblem) and on faction
  cards.

---

## [0.24.2]

### Added
- **Group loot is recorded.** The Record tab used to see only your own loot
  window. It now also notes what your group members loot (from the loot chat,
  under *Looted by your group*) and the drops the group rolls on, filed under
  the boss they came from. Players' names are never kept.
- **Auto loot is caught.** Items are read as soon as the loot is ready, before
  the window shows.

### Changed
- **Start Recording is the standard button again**, like Copy and Clear. It
  still can't be clicked for 5 seconds after starting, so a double click doesn't
  stop the recording it just began.

---

## [0.24.1]

### Fixed
- **The Record page was hard to read.** Its lighter and smaller lines (the
  dungeon facts, *Off …*, *Recent*, the contributors note) are now in the page's
  full ink at body size, and item colours are darkened for the parchment. The
  contributors note moved out of the page's shaded corner.

---

## [0.24.0] (restart)

### Added
- **New pictures.** Onyxia's Lair has a painting of the broodmother, and the
  dungeons with no picture of their own have a moonlit keep instead of a
  question mark.

### Changed
- **The Record tab is a page of the journal.** On the left, the **Recorder**:
  status, Start / Copy / Clear, the two switches, our Discord, *Credit me as*
  and the contributors. On the right, **What you caught**: each dungeon's
  entrance, kills and the drops the journal doesn't have yet, then quests,
  quartermasters, travel marks and the latest entries.
- **Copy turns the right page into text**, picked out for Ctrl+C. **Back** or
  Esc turns it back. Left empty, *Credit me as* is your character's name.
- **Clear asks first**, and is greyed out when there's nothing to clear.
- Each copied loot line says whether the journal lists the drop already.

### Fixed
- **The Record tab's status overlapped its title.**
- **"New in WoW: Forever" sank into the parchment.** It's now a deep blue.

---

## [0.23.0] (restart)

### Added
- **14 dungeons are back**: Razorfen Downs, Uldaman, Zul'Farrak, Maraudon, the
  Temple of Atal'Hakkar, Blackrock Depths, Lower and Upper Blackrock Spire, Dire
  Maul East, North and West, Scholomance, and Stratholme's Main Gate and Service
  Gate. Each comes with its maps, bosses, loot and quests.
- **The raids**: Barrow Deeps, Hyjal Summit and Onyxia's Lair, as *Coming soon*
  pages.
- **Forever's announced dungeons are listed**, each with a *Coming soon* box and
  the Discord link.
- **New in Forever**: a small label on what Forever added, on dungeon buttons
  and faction cards, and a line on the dungeon's overview.
- **The Record tab**: records by itself in dungeons, counts what you've caught,
  **Copy** turns it into text for our Discord, and a contributors list.
- **Reputation quartermasters**: open one while recording and the wares each
  standing unlocks join the Reputation tab.

### Changed
- **The boss button's hover glow** now traces the portrait's ring.
- **All of the journal's data now lives in its own files**, one per dungeon.

---

## [0.22.0] to [0.22.2]

- **Loot tables** match what is confirmed in game, quest items kept.
- **Bosses with several possible spots** get small, faded pins; hovering one
  lights up all of its spots.

## [0.20.0] to [0.21.1]

- **Every classic dungeon checked** again: levels, fight notes, boss spots, loot
  and quests. New maps for the classic dungeons, without the old painted skulls.
- **Scarlet Monastery's Armory and Cathedral** added.
- **Item names** filled in for every drop, even ones the server doesn't describe
  yet.

## [0.17.0] to [0.19.0]

- **Quest marks on the maps**: **!** and **?** that follow your quest log, on the
  world map and inside dungeons.
- **Excavation Site** gets its newer map and its fourth boss, the Highland Horror;
  **Ruins of Lordaeron** gets its boss spots fixed.

## [0.15.0] to [0.16.3]

- **The Model tab**: each boss in 3D.
- **City of Dalaran** gets its map, every drop and its quests' order.

## [0.12.0] to [0.14.5]

- **First tester build**, with the tester guide.
- **Unknown items are hidden** until confirmed; `/aegis items` finds them.
- **Wings that share a door** share one map icon with a menu.
- **Boats and zeppelins** labelled by where they go.

## [0.9.0] to [0.11.3]

- **Dungeon doors on the world map**, retail style: left-click opens the
  journal, right-click sets a waypoint.
- **Search.**
- **Old Ironforge, the Defias Hideout and the Deeprun Tram** get maps of their own.
- **The map legend** and the map's Quests tab come back; flight masters on zone
  maps; `/aegis travel` to mark boats, zeppelins and portals.
- **The Record tab**, first version.

## [0.5.0] to [0.8.0]

- **The journal itself**: the dungeon grid, the book, boss pages with Overview,
  Loot and Abilities, then the Quests tab, the Reputation tab and the dungeon
  maps.
