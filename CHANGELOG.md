# Changelog

All notable changes to **Aegis: Forever Instance Journal**.

Format loosely follows [Keep a Changelog](https://keepachangelog.com/).
The version here matches `## Version` in `Aegis_Forever_Instance_Journal.toc`
and the version shown in the AddOns list. Quote it in bug reports.

> ⚠️ Releases marked **restart** add a new file (a `.lua` file or a texture).
> The client reads those only at startup, so `/reload` won't pick them up: close
> the game fully and start it again. Everything else is `/reload`-safe.

---

## [0.34.0]

### Added
- **Trash** in every dungeon's boss list, after its bosses: what the dungeon's other creatures drop
  that is worth knowing about, rare and epic gear, recipes and quest items. The greens and whites
  any creature there may drop are left out of the dungeon's loot, search and the Gear Finder too.
- **Before you go**, at the top of a dungeon's overview: its key and the quests to it, and any
  hidden boss to prepare for, each a note under a header like the Abilities tab's, opened and
  closed with a click. A key's header shows the "!" of the quest you're on and how many of its
  quests are done; beneath its text, its quests are listed as on the Quests tab, and a click
  opens one there. City of Dalaran first: the Dalaran Sewer Key for each side, and how to make
  and use the Tome of Dalaran that summons Lyn the Ignored. More dungeons will follow, one at a
  time.
- **The Quests tab's key**: a dungeon's key heads its quest list too, holding the quests to it
  (for City of Dalaran, the Horde's five and the Alliance's two), open until you have it.
- **Switches in the world map's legend**: click an entry to hide that kind of marker, click again
  to show it. The journal's own (dungeon and raid doors, flight points, caves, boats, zeppelins,
  trams and portals) are kept for your account; the game's quest markers use the game's own map
  filters, the same ones as the map's filter menu. The same switches are in the map's filter
  menu too, under Instance Journal, beside Show unexplored areas.
- **Ratchet and Booty Bay rewards confirmed**: their quartermasters, Winklespark and Gezzy
  Gunkgear, captured by Genesys Firstborn, with prices and the standing each needs (six rewards
  each). Thank you!

### Changed
- **The Quests tab's list** now uses the same headers as the Abilities tab: each quest's "!", "?"
  or check, its level and name, and for a quest with a chain, a "+" and how many of the chain's
  quests are done. A click chooses a quest and opens or folds its chain; the chosen one is lit.
- **City of Dalaran** is no longer marked "Not yet tested".
- **Merchant's Favor costs** on the Azeroth Commerce Authority's and Durotar Supply and
  Logistics' rewards now show as the merchant shows them: the amount and the currency's icon.
- **Dungeon quest marks** on the maps now show only quests you can take now (the quests before
  them done, your level reached) and that aren't grey for your level. The Quests tab still lists
  them all.
- **Pointing at a dungeon quest mark** lights the legend's Quest entry (and Turn In, for a "?"),
  and pointing at those entries lights the marks up, as the game's own marks do.
- **Show Start and Show End** on a quest now set the game's own waypoint there, on the map, the
  minimap and in the world.

### Fixed
- **Lyn the Ignored** is a he: his notes and abilities said "she", in every language.
- **On a dungeon's map**, the quest log's button in the map's corner could not be clicked once the
  log was closed: the map's own buttons now stay above the dungeon map.

## [0.33.0]

> ⚠️ **About the new languages.** The German, French and Chinese (Simplified and Traditional)
> translations were drafted with AI (Claude) and have **not yet been checked by native
> speakers**. Expect some awkward or wrong words, names that differ from Blizzard's own, and a
> few lines still in English. If you play in one of these languages, corrections are very
> welcome: open an issue or a pull request on GitHub, or tell us on Discord. The Russian
> translation is Staree4ok's own work and is not affected.

### Added
- **German, French, Simplified Chinese and Traditional Chinese**: the journal follows a game
  client set to any of them, its interface and its content (dungeons, bosses, abilities, quests
  and places), drafted as the note above says. A few of the newest lines (the minimap button,
  working with Pawn, the options) are still in English.
- **`/aegis lang`** to see a translation on any client: `/aegis lang de`, `fr`, `ru`, `cn` or `tw`
  shows the journal's own words in that language from your next `/reload` (the game's names stay
  your client's), and `/aegis lang off` goes back.
- **Dungeon rooms and areas in your language**: "you are here", recorded areas and zone levels
  match the client's own area names in every language, not English ones only.

### Changed
- **Russian**: the rooms inside dungeons and the `/aegis areas` messages are translated too.

## [0.32.0]

### Added
- **The journal's stat weights in Pawn**: with Pawn installed, the journal adds a scale of its
  own to Pawn for each of your specs ("Journal: Holy" and so on), holding the weights the Gear
  Finder uses. Choose the journal's weights and Pawn shows the one for the spec the Gear Finder
  scores for, and hides its own scales on that character, so Pawn's tooltips and upgrade arrows
  weigh items just as the Gear Finder does. A weight you change in the journal reaches Pawn at
  once, and a new spec's scale takes over when you change spec. Untick **Show stat weights in
  tooltips** and the journal's scale leaves Pawn's tooltips too (and with it Pawn's arrows for it,
  as Pawn marks upgrades only for the scales it shows). Choose Pawn's weights (in the journal's
  options) and Pawn's own scales come back. Baganator keeps Pawn's answer for each item until
  your gear changes, so where it draws Pawn's arrows the journal offers a reload after such a
  change, for the arrows to follow.

### Changed
- **The question asked when Pawn is installed** now offers the journal's weights first, for Pawn
  and the Gear Finder both. A scale you show again in Pawn yourself stays shown. If you ever
  remove the journal, show Pawn's own scales again in Pawn.

## [0.31.1]

### Added
- **73 dungeon quests** the journal lacked, after checking every dungeon's quests against
  foreverchanges.pro's lists: chain steps given far from the dungeon (Gnomeregan, Uldaman,
  Blackrock Depths and Spire), Forever's new ones in Wailing Caverns, Blackrock Depths and the
  Ruins of Lordaeron, Dire Maul's librams, the Sunken Temple's class quests and more.
- **Excavation Site: Wetlands, from a recorded run**: each boss's spells (the Relic Guardian's
  Knock Away is his threat drop; Shadetooth's roar fears up to three players), their areas and
  the entrance. Thank you, Genesys Firstborn.
- **What can be dispelled on the way**, on the boss each pack leads to: the Marsh Skulkers'
  Muculent Rot, the Thicket Hunters' Infected Wound, the Dragonmaw Thaumaturgists' Curse of
  Weakness and the spider trail's poison and Highland Venom, with the classes that can take each
  off; and the Highland Horror's roots, which Blessing of Freedom breaks.
- **"You will also receive"** on a quest's page, for the items that come with the choice, and
  how many of each item you get.
- **The Gear Finder's stat weights on every item's tooltip**: in your bags, on the character
  sheet, in loot, at merchants, in chat links and in the Gear Finder, a short line for each of
  your specs with what the item is worth to it, and a green arrow with what it adds to your gear
  when it beats what you wear (with the level, for gear a few levels ahead).
- **Show stat weights in tooltips**, a box under the stat weights: untick it and items'
  tooltips, the Gear Finder's too, leave out what each item is worth and adds to your gear.
- **Green arrows on upgrades**: in your bags (Baganator's too, in its top right corner), in the
  loot window and on loot rolls, an item that is an upgrade for your spec has the bags' green arrow
  at its corner, so you can tell at a glance what to keep, take or roll on.
- **Working alongside Pawn**: with Pawn installed and enabled, its item tooltips and upgrade arrows
  are the ones shown, and the journal asks once whether the Gear Finder should score with Pawn's
  stat weights or the journal's own. With Pawn's, it takes your own Pawn scale for the class (a
  copied one for its spec) before Pawn's starter scales. Change it any time in the options;
  without Pawn, the journal shows its own.
- **Boss levels on the boss list**: each boss's level on its portrait, in the target frame's
  badge, coloured from grey to red by how hard the boss is for you.
- **The journal's options**, in the game's Options under AddOns (or `/aegis options`): boss
  levels, stat weights in tooltips and the green arrows can each be turned off.
- **`/ij`** opens the journal too, as `/aegis` does.
- **A minimap button**, with the journal's new icon, the Ashbringer. Click it to open the
  journal, right-click it for the options, drag it round the minimap's edge; the options can hide
  it.
- **The Gear Finder and its stat weights in Russian**, with every spec's name and unit, by
  Staree4ok. The new top 3 picker is still in English for now.

### Changed
- **18 quests' levels or side**, to Forever's: mostly the level they open at.
- **Excavation Site's quests**, checked one by one against foreverchanges.pro: where each is
  given and handed in, the right experience, Heartwoven's four of each potion, and no quests
  needed first that only lead the way there (Seeking Caitlin, Young Crocolisk Skins, Rethiel's
  Wetlands quests).
- The Log Reader page keeps a boss's spells when the game calls him neutral (the Relic Guardian).
- The Gear Finder no longer suggests a unique ring or trinket you already wear in the other slot.
- **The Gear Finder's tooltips are plainer**: the item, what it is worth to each spec, where it
  drops and a short hint, without the slot's other upgrades or the long lines.
- **The Gear Finder's slots no longer carry the green arrow**: everything it shows is an upgrade;
  the arrow now marks upgrades in your bags, the loot window and rolls instead.
- **The journal's own icon**: its window's round portrait, top left, is now the Ashbringer, as on
  its minimap button, in place of the game's journal book.

### Fixed
- The loot's class filter was missing the Druid.

## [0.31.0]

### Added
- **Pick from a slot's top 3**, as in Aegis: Pathfinder: click a slot in the Gear Finder and its
  three biggest upgrades open beside it, each with what it adds and where it drops. Click one to
  show it in the slot; the suggested dungeon follows your picks. A pick is starred, kept for each
  character, and forgotten once you wear it; **Clear my pick** brings the biggest back.

### Changed
- **Right-click** a Gear Finder slot to open its item's loot in the journal (a plain click now
  opens the top 3).

## [0.30.1]

### Changed
- **The character panel's Gear Finder tab** works like the panel's own tabs: from any page it
  turns the panel to your character, with your stat weights where its stats are. Clicked again,
  the weights stay; the Character tab or any other gives the stats back. Only the tab you're on is
  marked. With the right pane folded away, they show over the panel's edge; its arrow unfolds
  it.

## [0.30.0] (restart)

### Added
- **Gear Finder**, a new tab: the best upgrade waiting for each slot in the dungeons that
  start no more than three levels above you, laid out like your character sheet. Each shows
  what it adds to all the gear you wear and where it drops; one you can wear in a few levels
  shows that level in red. A click opens its loot. The dungeon holding the most upgrades is
  suggested, and the others are a click apart.
- **Scored for your spec**: the one your talents say, or one you pick, with Aegis: Pathfinder's
  stat weights (one set while levelling, another at 60).
- **Stat weights you can change**, kept for each character and spec: click a weight and type a
  new one; yours show in green, and **Reset** brings the journal's back. Or bring in a scale
  from **Pawn**: paste what its Export gives.
- **A tab on the character panel** opens your stat weights over the panel's stats, with a button
  to the Gear Finder. It takes the first place under the panel's own tabs; another addon's tab
  found there moves down under it.
- `/aegis gear` and `/aegis weights`. `/aegis gearscan` saves what the Gear Finder reads from
  your gear, so its scoring can be checked against Forever's own words.

### Changed
- **Record is now the last tab**, after Gear Finder. The journal still reopens on the tab you
  last had open.

## [0.29.1]

### Changed
- **Staree4ok heads the contributors** on the Record tab, for the journal's Russian translation.

## [0.29.0] (restart)

### Added
- **The journal in Russian**, translated by Staree4ok. On a game client set to Russian, the
  window, its tabs, menus and messages are in Russian, and so are the dungeons', raids' and
  factions' names, their bosses and abilities, quests and places. Item and spell names are the
  game's own, as before. A client in any other language is unchanged.

## [0.28.0] (restart)

### Added
- **Faction rewards are back, unconfirmed.** Every faction nobody has captured yet lists the
  rewards the game's item data gives it, by standing: 458 rewards across 21 factions, leaving
  out the game's test items. They show without prices, the faction's tooltip says they're
  unconfirmed, and its page asks for a capture. Capturing a quartermaster confirms each
  reward it finds, with its price and cost, and moves it if it needs a different standing.
- **Durotar Supply and Logistics captured**: the Horde's Merchant's Favor quartermasters at the
  Crossroads, 9 vendors and 183 rewards with their costs, from Genesys Firstborn's recording.
- Both captured factions, the Azeroth Commerce Authority and Durotar Supply and Logistics, keep
  only their captured rewards, not the game's shorter lists.

### Changed
- **Faction cards**: no reward count in the corner any more. The factions WoW: Forever added
  wear its emblem there instead, as its dungeons and raids do.

New file: close the game fully and start it again; `/reload` won't load it.

---

## [0.27.1]

### Fixed
- Forever's own zones show their level ranges on the world map too: Riverglades 36-44,
  Mount Hyjal 60 and Shen'dralas 35-45.

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
