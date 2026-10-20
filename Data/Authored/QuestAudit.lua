local _, ns = ...

--[[
	The quest audit (2026-10-20). Every dungeon quest's prerequisites, givers and takers, their
	places, levels and sides, and the items or objects that start them, checked against QuestieDB's
	Forever database (an October 10 snapshot of the live game, read with our own decoder), the
	Forever Dungeon Journal's hand-checked chains, foreverchanges.pro and Alex Atlas Loot; then each
	change checked again against the sources by a second reviewer. Facts only, in our own words.

	Laid over the generated and hand-written data (this file loads after them), per dungeon:
	  add      quests the dungeon's data lacked
	  patches  fields corrected on a quest; false clears one (a start spot that was wrong)
	  remove   quests that are not the dungeon's on Forever: duplicates the game never offers, and
	           another wing's quests
	Prerequisites list every quest a player must have done first, oldest first: optional
	breadcrumbs, and steps any one of several will do, are left out. Each change names its sources.
	The quests still open after the audit wait for a check on Wowhead (Dev/docs).
]]

local function Audit(key, spec)
	if not ns.GetInstance(key) then return end
	if spec.add then ns.AmendInstance(key, { addQuests = spec.add }) end
	if spec.patches then ns.AmendInstance(key, { questPatches = spec.patches }) end
	if spec.remove then ns.AmendInstance(key, { removeQuests = spec.remove }) end
end

Audit("RagefireChasm", {
	patches = {
		-- Searching for the Lost Satchel: startMap (Questie, FDJ, foreverchanges, AAL)
		[5722] = {
			startMap = { mapID = 1456, x = 0.701, y = 0.295, label = "Rahauro" },
		},
		-- Testing an Enemy's Strength: startMap (Questie, FDJ, foreverchanges, AAL)
		[5723] = {
			startMap = { mapID = 1456, x = 0.701, y = 0.295, label = "Rahauro" },
		},
		-- Returning the Lost Satchel: prerequisites (Questie, FDJ, foreverchanges)
		[5724] = {
			prerequisites = { { questID = 5722, name = "Searching for the Lost Satchel" } },
		},
		-- Hidden Enemies: prerequisites (Questie, FDJ, foreverchanges)
		[5730] = {
			prerequisites = {
				{ questID = 5726, name = "Hidden Enemies" },
				{ questID = 5727, name = "Hidden Enemies" },
				{ questID = 5728, name = "Hidden Enemies" },
				{ questID = 5729, name = "Hidden Enemies" },
			},
		},
	},
})

Audit("RuinsOfLordaeron", {
	add = {
		-- Unending Torment (Questie, foreverchanges)
		{
			questID = 97290, name = "Unending Torment", level = 21, requiredLevel = 16, faction = "Horde",
			pickup = "Unfinished Abomination, Undercity",
			turnin = "Master Apothecary Faranell, Undercity",
			startMap = { mapID = 1458, x = 0.460, y = 0.620 }, endMap = { mapID = 1458, x = 0.488, y = 0.693 },
			objective = "Report back to Master Apothecary Faranell in the Undercity.",
			note = "New in Forever: part 3, in the Undercity.",
			prerequisites = { { questID = 97288, name = "Unending Torment" }, { questID = 97289, name = "Unending Torment" } },
		},
	},
	patches = {
		-- Remember That I Love You: endMap (Questie, foreverchanges)
		[92415] = {
			endMap = { mapID = 1453, x = 0.563, y = 0.54, label = "Orphan Matron Nightingale — Cathedral Square" },
		},
		-- Bloodied Insignia: endMap (Questie, foreverchanges)
		[95195] = {
			endMap = { mapID = 1453, x = 0.692, y = 0.827, label = "General Marcus Jonathan — Valley of Heroes" },
		},
		-- Unending Torment: pickup, startMap, turnin, endMap (Questie, foreverchanges)
		[97289] = {
			pickup = "Master Apothecary Faranell, Undercity",
			startMap = { mapID = 1458, x = 0.488, y = 0.693, label = "Master Apothecary Faranell — Apothecarium" },
			turnin = "Unfinished Abomination, Undercity",
			endMap = { mapID = 1458, x = 0.46, y = 0.62, label = "Unfinished Abomination — Undercity" },
		},
		-- Unending Torment: pickup, startMap, turnin (Questie, foreverchanges)
		[97291] = {
			pickup = "Master Apothecary Faranell, Undercity",
			startMap = { mapID = 1458, x = 0.488, y = 0.693, label = "Master Apothecary Faranell — Apothecarium" },
			turnin = "Master Apothecary Faranell, Undercity",
		},
		-- Unending Torment: pickup, startMap, turnin (Questie, foreverchanges)
		[97292] = {
			pickup = "Master Apothecary Faranell, Undercity",
			startMap = { mapID = 1458, x = 0.488, y = 0.693, label = "Master Apothecary Faranell — Apothecarium" },
			turnin = "Master Apothecary Faranell, Undercity",
		},
	},
})

Audit("TheDeadmines", {
	add = {
		-- A Moon-Kissed Blade (Questie)
		{
			questID = 95036, name = "A Moon-Kissed Blade", level = 25, requiredLevel = 20, faction = "Horde", classOnly = "PALADIN",
			pickup = "Lumina Windsinger, the Sepulcher, Silverpine Forest",
			turnin = "Trevan Rol, the Sepulcher, Silverpine Forest",
			startMap = { mapID = 1421, x = 0.433, y = 0.410, label = "Lumina Windsinger" },
			endMap = { mapID = 1421, x = 0.433, y = 0.410, label = "Trevan Rol" },
			objective = "Bring Trevan Rol in the Sepulcher the Whitestone Oak Lumber and the Enchanted Silver Ingot he needs.",
			note = "A paladin quest for the Forsaken. Here: Whitestone Oak Lumber, which the Goblin Woodcarvers drop.",
		},
	},
	patches = {
		-- The Unsent Letter: endMap (Questie, FDJ, foreverchanges)
		[373] = {
			endMap = { mapID = 1453, x = 0.577, y = 0.479, label = "Baros Alexston" },
		},
		-- The Test of Righteousness: prerequisites (Questie, FDJ, foreverchanges)
		[1806] = {
			prerequisites = {
				{ questID = 1649, name = "The Tome of Valor" },
				{ questID = 1650, name = "The Tome of Valor" },
				{ questID = 1651, name = "The Tome of Valor" },
				{ questID = 1652, name = "The Tome of Valor" },
				{ questID = 1653, name = "The Test of Righteousness" },
				{ questID = 1654, name = "The Test of Righteousness" },
			},
		},
		-- Destruction in Deadmines: prerequisites (Questie, FDJ, foreverchanges)
		[92819] = {
			prerequisites = {
				{ questID = 92742, name = "Testing the Wells" },
				{ questID = 92744, name = "Murloc Gills" },
				{ questID = 92745, name = "The State of the Mines" },
				{ questID = 92747, name = "Moonbrook Espionage" },
				{ questID = 92748, name = "Explosive Consultation" },
				{ questID = 92749, name = "A Dynamite Plan" },
				{ questID = 92750, name = "Detonation at a Distance" },
				{ questID = 92751, name = "Detonation at a Distance" },
				{ questID = 92752, name = "Explosive Consultation" },
				{ questID = 92753, name = "Destruction in Deadmines" },
			},
		},
	},
})

Audit("WailingCaverns", {
	patches = {
		-- Leaders of the Fang: note (Questie, FDJ)
		[914] = {
			note = "Needs the Barrens oasis chain first: The Forgotten Pools, The Stagnant Oasis and Altered Beings, then Hamuul Runetotem and Nara Wildmane, before Leaders of the Fang opens.",
		},
		-- Hamuul Runetotem: prerequisites (Questie, FDJ, foreverchanges)
		[1489] = {
			prerequisites = {
				{ questID = 870, name = "The Forgotten Pools" },
				{ questID = 877, name = "The Stagnant Oasis" },
				{ questID = 880, name = "Altered Beings" },
			},
		},
		-- Nara Wildmane: prerequisites (Questie, FDJ, foreverchanges)
		[1490] = {
			prerequisites = {
				{ questID = 870, name = "The Forgotten Pools" },
				{ questID = 877, name = "The Stagnant Oasis" },
				{ questID = 880, name = "Altered Beings" },
				{ questID = 1489, name = "Hamuul Runetotem" },
			},
		},
		-- The Glowing Shard: startMap, turnin, endMap (Questie, FDJ, foreverchanges)
		[6981] = {
			startMap = false,
			turnin = "Falla Sagewind, The Barrens",
			endMap = { mapID = 1413, x = 0.482, y = 0.328, label = "Falla Sagewind" },
		},
	},
})

Audit("ShadowfangKeep", {
	patches = {
		-- The Test of Righteousness: prerequisites (Questie, FDJ, foreverchanges)
		[1806] = {
			prerequisites = {
				{ questID = 1649, name = "The Tome of Valor" },
				{ questID = 1650, name = "The Tome of Valor" },
				{ questID = 1651, name = "The Tome of Valor" },
				{ questID = 1652, name = "The Tome of Valor" },
				{ questID = 1653, name = "The Test of Righteousness" },
				{ questID = 1654, name = "The Test of Righteousness" },
			},
		},
	},
})

Audit("BlackfathomDeeps", {
	add = {
		-- The Orb of Soran'ruk (FDJ, Questie, foreverchanges)
		{ questID = 1740, name = "The Orb of Soran'ruk", level = 25, requiredLevel = 20, faction = "Both", classOnly = "WARLOCK", pickup = "Doan Karhan, The Barrens", turnin = "Doan Karhan, The Barrens", startMap = { mapID = 1413, x = 0.493, y = 0.572, label = "Doan Karhan" }, objective = "Find 3 Soran'ruk Fragments and 1 Large Soran'ruk Fragment and return them to Doan Karhan.", note = "A warlock quest. The 3 Soran'ruk Fragments drop from Twilight Acolytes here; the Large Soran'ruk Fragment comes from Shadowfang Darksouls in Shadowfang Keep.", rewards = { xp = 2550, choice = true, items = { { itemID = 6898, name = "Orb of Soran'ruk", quality = 3 }, { itemID = 15109, name = "Staff of Soran'ruk", quality = 3 } } } },
	},
	patches = {
		-- Researching the Corruption: note, prerequisites (Questie, FDJ)
		[1275] = {
			note = "Optional breadcrumb: The Corruption Abroad, from Argos Nightwhisper in Stormwind, leads here.",
			prerequisites = {},
		},
		-- Blackfathom Villainy: endMap (Questie, foreverchanges, AAL)
		[6561] = {
			endMap = { mapID = 1456, x = 0.711, y = 0.342, label = "Bashana Runetotem" },
		},
		-- Trouble in the Deeps: endMap (Questie, foreverchanges)
		[6562] = {
			endMap = { mapID = 1440, x = 0.116, y = 0.343, label = "Je'neu Sancrea" },
		},
		-- The Essence of Aku'Mai: note (Questie, FDJ)
		[6563] = {
			note = "Trouble in the Deeps, from Tsunaman in Stonetalon Mountains, leads here but is not needed.",
		},
		-- Baron Aquanis: endMap (Questie, foreverchanges, AAL)
		[6922] = {
			endMap = { mapID = 1440, x = 0.116, y = 0.343, label = "Je'neu Sancrea" },
		},
	},
})

Audit("ExcavationSiteWetlands", {
	patches = {
		-- Horrors in the Highland: prerequisites (Questie, FDJ, AAL)
		[95646] = {
			prerequisites = {
				{ questID = 276, name = "Tramping Paws" },
				{ questID = 277, name = "Fire Taboo" },
				{ questID = 275, name = "Blisters on The Land" },
			},
		},
		-- Lost in the Thicket Things: turnin (Questie, FDJ, foreverchanges)
		[95647] = {
			turnin = "Ardin Grassman, inside Excavation Site: Wetlands",
		},
		-- Songblade Search: startMap (Questie, FDJ, foreverchanges, AAL)
		[95772] = {
			startMap = { mapID = 1433, x = 0.258, y = 0.464, label = "Dorin Songblade — Redridge Mountains" },
		},
		-- Fallen in the Fen: endMap, prerequisites (Questie, FDJ, foreverchanges, AAL)
		[95795] = {
			endMap = { mapID = 1433, x = 0.258, y = 0.464, label = "Dorin Songblade, Lakeshire" },
			prerequisites = {},
		},
		-- Highland Hides: prerequisites (Questie, FDJ)
		[98815] = {
			prerequisites = { { questID = 484, name = "Young Crocolisk Skins" } },
		},
	},
})

Audit("CityOfDalaran", {
	patches = {
		-- Starving Arcane: startMap (Questie, FDJ, foreverchanges)
		[92457] = {
			startMap = { mapID = 1421, x = 0.686, y = 0.452, label = "Image of Archmage Modera — Lordamere Lake near Dalaran" },
		},
		-- Heart of Disruption: startMap (Questie, foreverchanges)
		[92458] = {
			startMap = { mapID = 1421, x = 0.686, y = 0.452, label = "Image of Archmage Modera — Lordamere Lake" },
		},
		-- Heart of Disruption: startMap, endMap (Questie, FDJ, foreverchanges)
		[96984] = {
			startMap = { mapID = 1421, x = 0.686, y = 0.452, label = "Image of Archmage Modera — Lordamere Lake near Dalaran" },
			endMap = { mapID = 1424, x = 0.616, y = 0.208, label = "Magus Wordeen Voidglare — Tarren Mill" },
		},
	},
})

Audit("Gnomeregan", {
	patches = {
		-- Chief Engineer Scooty: endMap, note (Questie, FDJ, foreverchanges)
		[2842] = {
			endMap = { mapID = 1434, x = 0.276, y = 0.775, label = "Scooty" },
			note = "Accept Rig Wars from Nogg first; you need not finish it. If Nogg no longer offers Rig Wars, abandon this quest and Rig Wars comes back. Leads to Gnomer-gooooone!, the goblins' transporter to Gnomeregan.",
		},
		-- Gnomer-gooooone!: note, prerequisites (Questie, FDJ)
		[2843] = {
			note = "Needs Rig Wars accepted, not finished: take it from Nogg in Orgrimmar before Chief Engineer Scooty.",
			prerequisites = { { questID = 2842, name = "Chief Engineer Scooty" } },
		},
		-- Data Rescue: note, prerequisites (Questie, FDJ)
		[2930] = {
			note = "A White Punch Card drops from mobs outside the instance; run it through Matrix Punchograph 3005-A (Train Depot, outside), 3005-B (the Dormitory), 3005-C (Electrocutioner 6000's platform) and 3005-D (lower Engineering Labs) to get the Prismatic Punch Card.",
			prerequisites = {},
		},
		-- Grime-Encrusted Ring: requiredLevel, pickup, turnin (Questie, FDJ, foreverchanges)
		[2945] = {
			requiredLevel = 28,
			pickup = "Use the Grime-Encrusted Ring, dropped by Dark Iron Agents inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
		},
		-- Return of the Ring: pickup (Questie, FDJ, foreverchanges)
		[2947] = {
			pickup = "The Sparklematic 5200, inside Gnomeregan",
		},
		-- Return of the Ring: pickup (Questie, FDJ, foreverchanges)
		[2949] = {
			pickup = "The Sparklematic 5200, inside Gnomeregan",
		},
		-- More Sparklematic Action: note, prerequisites (Questie)
		[2953] = {
			note = "Repeatable. Each go costs 3 silver. Opens after your second Sparklematic 5200! quest, at any of the three machines.",
			prerequisites = {},
		},
		-- More Sparklematic Action: note, prerequisites (Questie)
		[4603] = {
			note = "Repeatable. Each go costs 3 silver. Opens after your second Sparklematic 5200! quest, at any of the three machines.",
			prerequisites = {},
		},
		-- More Sparklematic Action: note, prerequisites (Questie)
		[4604] = {
			note = "Repeatable. Each go costs 3 silver. Opens after your second Sparklematic 5200! quest, at any of the three machines.",
			prerequisites = {},
		},
		-- The Sparklematic 5200!: note, prerequisites (Questie)
		[4605] = {
			note = "Opens after your first Sparklematic 5200! quest, at any of the three machines.",
			prerequisites = {},
		},
		-- The Sparklematic 5200!: note, prerequisites (Questie)
		[4606] = {
			note = "Opens after your first Sparklematic 5200! quest, at any of the three machines.",
			prerequisites = {},
		},
	},
})

Audit("RazorfenKraul", {
	add = {
		-- Fire Hardened Mail (Questie)
		{
			questID = 1701, name = "Fire Hardened Mail", level = 28, requiredLevel = 20, faction = "Alliance", classOnly = "WARRIOR",
			pickup = "Furen Longbeard, Stormwind City", turnin = "Furen Longbeard, Stormwind City",
			startMap = { mapID = 1453, x = 0.646, y = 0.372, label = "Furen Longbeard" },
			objective = "Gather the materials Furen Longbeard requires, and bring them to him in Stormwind.",
			note = "Roogug drops the Vial of Phlogiston.",
			prerequisites = {
				{ questID = 1699, name = "The Rethban Gauntlet" },
				{ questID = 1702, name = "The Shieldsmith" },
			},
		},
		-- Brutal Armor (Questie)
		{
			questID = 1838, name = "Brutal Armor", level = 30, requiredLevel = 20, faction = "Horde", classOnly = "WARRIOR",
			pickup = "Thun'grim Firegaze, The Barrens", turnin = "Thun'grim Firegaze, The Barrens",
			startMap = { mapID = 1413, x = 0.572, y = 0.303, label = "Thun'grim Firegaze" },
			objective = "Bring to Thun'grim Firegaze 15 Smoky Iron Ingots, 10 Powdered Azurite, 10 Iron Bars and a Vial of Phlogiston.",
			note = "Roogug drops the Vial of Phlogiston.",
			prerequisites = {
				{ questID = 1824, name = "Trial at the Field of Giants" },
			},
		},
		-- An Unholy Alliance (FDJ, Questie, foreverchanges)
		{
			questID = 6522, name = "An Unholy Alliance", level = 36, requiredLevel = 28, faction = "Horde",
			pickup = "Item start: Small Scroll, dropped by Charlga Razorflank", turnin = "Varimathras, Royal Quarter, Undercity",
			startItem = { itemID = 17008, name = "Small Scroll", note = "Dropped by Charlga Razorflank." },
			endMap = { mapID = 1458, x = 0.563, y = 0.922, label = "Varimathras — Royal Quarter, Undercity" },
			objective = "Take the Small Scroll to Varimathras in the Undercity.",
			prerequisites = {},
		},
		-- Elemental Aid (Questie)
		{
			questID = 96264, name = "Elemental Aid", level = 33, requiredLevel = 30, faction = "Alliance", classOnly = "SHAMAN",
			pickup = "Veyric Thunderhame, Arathi Highlands", turnin = "Veyric Thunderhame, Arathi Highlands",
			startMap = { mapID = 1417, x = 0.598, y = 0.276, label = "Veyric Thunderhame" },
			objective = "Defeat Charlga Razorflank in Razorfen Kraul and collect information on the quilboar's plans.",
			note = "Charlga Razorflank drops the Tattered Note.",
			prerequisites = {},
		},
	},
	patches = {
		-- An Unholy Alliance: startMap, prerequisites (Questie, FDJ, foreverchanges, AAL)
		[6521] = {
			startMap = { mapID = 1458, x = 0.563, y = 0.922, label = "Varimathras — Royal Quarter, Undercity" },
			prerequisites = { { questID = 6522, name = "An Unholy Alliance" } },
		},
	},
})

Audit("ScarletMonasteryLibrary", {
	add = {
		-- Into The Scarlet Monastery (Questie, foreverchanges)
		{
			questID = 1048, name = "Into The Scarlet Monastery", level = 42, requiredLevel = 33, faction = "Horde",
			pickup = "Varimathras, Royal Quarter, Undercity", turnin = "Varimathras, Royal Quarter, Undercity",
			startMap = { mapID = 1458, x = 0.563, y = 0.922 },
			objective = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod and Houndmaster Loksey, then report to Varimathras in the Undercity.",
			rewards = { items = { { itemID = 6802 }, { itemID = 6803 }, { itemID = 10711 } }, choice = true },
		},
		-- In the Name of the Light (Questie, foreverchanges)
		{
			questID = 1053, name = "In the Name of the Light", level = 40, requiredLevel = 34, faction = "Alliance",
			pickup = "Raleigh the Devout, Southshore, Hillsbrad Foothills", turnin = "Raleigh the Devout, Southshore, Hillsbrad Foothills",
			startMap = { mapID = 1424, x = 0.515, y = 0.584 },
			objective = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod and Houndmaster Loksey, then report to Raleigh the Devout in Southshore.",
			prerequisites = { { questID = 261, name = "Down the Scarlet Path" }, { questID = 1052, name = "Down the Scarlet Path" } },
			rewards = { items = { { itemID = 6829 }, { itemID = 6830 }, { itemID = 6831 }, { itemID = 11262 } }, choice = true },
		},
	},
	patches = {
		-- Compendium of the Fallen: note (Questie, FDJ, foreverchanges)
		[1049] = {
			note = "Undead characters cannot take this quest.",
		},
		-- Test of Lore: prerequisites (Questie, FDJ, foreverchanges)
		[1160] = {
			prerequisites = {
				{ questID = 1149, name = "Test of Faith" },
				{ questID = 1150, name = "Test of Endurance" },
				{ questID = 1151, name = "Test of Strength" },
				{ questID = 1152, name = "Test of Lore" },
				{ questID = 1154, name = "Test of Lore" },
				{ questID = 6627, name = "Test of Lore" },
				{ questID = 1159, name = "Test of Lore" },
			},
		},
		-- Final Passage: prerequisites (Questie, FDJ, foreverchanges)
		[1394] = {
			prerequisites = {
				{ questID = 1149, name = "Test of Faith" },
				{ questID = 1150, name = "Test of Endurance" },
				{ questID = 1151, name = "Test of Strength" },
				{ questID = 1152, name = "Test of Lore" },
				{ questID = 1154, name = "Test of Lore" },
				{ questID = 6627, name = "Test of Lore" },
				{ questID = 1159, name = "Test of Lore" },
				{ questID = 1160, name = "Test of Lore" },
				{ questID = 6628, name = "Test of Lore" },
			},
		},
		-- Rituals of Power: turnin, endMap, objective, note, prerequisites (Questie, foreverchanges)
		[1951] = {
			turnin = "Tabetha, Dustwallow Marsh",
			endMap = { mapID = 1445, x = 0.461, y = 0.571, label = "Tabetha" },
			objective = "Bring the book Rituals of Power, from the Library, to Tabetha in Dustwallow Marsh.",
			note = "The book lies at the north end of the hallway to Arcanist Doan.",
			prerequisites = {
				{ questID = 1947, name = "Journey to the Marsh" },
				{ questID = 1949, name = "Hidden Secrets" },
				{ questID = 1950, name = "Get the Scoop" },
			},
		},
		-- Past Due: startMap (Questie, FDJ, foreverchanges)
		[96800] = {
			startMap = { mapID = 1416, x = 0.107, y = 0.641, label = "Magus Olvek — Dalaran" },
		},
	},
})

Audit("TheDrownedCity", {
	patches = {
		-- Ancient Gurubashi Idol: turnin, endMap (Questie, foreverchanges)
		[96774] = {
			turnin = "Mazu'kon, Mulgore",
			endMap = { mapID = 1412, x = 0.324, y = 0.206, label = "Mazu'kon" },
		},
	},
})

Audit("ScarletMonasteryArmory", {
	patches = {
		-- In the Name of the Light: prerequisites (Questie, foreverchanges)
		[1053] = {
			prerequisites = { { questID = 261, name = "Down the Scarlet Path" }, { questID = 1052, name = "Down the Scarlet Path" } },
		},
		-- Hearts of Zeal: prerequisites (Questie, FDJ, foreverchanges)
		[1113] = {
			prerequisites = { { questID = 1109, name = "Going, Going, Guano!" } },
		},
	},
})

Audit("RazorfenDowns", {
	patches = {
		-- Scourge of the Downs: pickup, turnin (Questie, foreverchanges)
		[3523] = {
			pickup = "Belnistrasz, inside Razorfen Downs",
			turnin = "Belnistrasz, inside Razorfen Downs",
		},
		-- Extinguishing the Idol: pickup, turnin (Questie, foreverchanges, AAL)
		[3525] = {
			pickup = "Belnistrasz, inside Razorfen Downs",
			turnin = "Belnistrasz's Brazier, inside Razorfen Downs",
		},
		-- An Unholy Alliance: pickup, startItem, prerequisites (Questie, FDJ, foreverchanges)
		[6522] = {
			pickup = "Small Scroll, dropped by Charlga Razorflank in Razorfen Kraul",
			startItem = { itemID = 17008, name = "Small Scroll", note = "Drops from Charlga Razorflank in Razorfen Kraul." },
			prerequisites = {},
		},
	},
})

Audit("ScarletMonasteryCathedral", {
	add = {
		-- Hearts of Zeal (FDJ, Questie, foreverchanges)
		{
			questID = 1113, name = "Hearts of Zeal", level = 33, requiredLevel = 30, faction = "Horde",
			pickup = "Master Apothecary Faranell, the Apothecarium, Undercity",
			turnin = "Master Apothecary Faranell, the Apothecarium, Undercity",
			startMap = { mapID = 1458, x = 0.488, y = 0.693, label = "Master Apothecary Faranell" },
			endMap = { mapID = 1458, x = 0.488, y = 0.693, label = "Master Apothecary Faranell" },
			objective = "Bring 20 Hearts of Zeal to Master Apothecary Faranell in the Undercity.",
			note = "The Scarlet Crusaders of every wing carry the hearts, and so do their leaders.",
			prerequisites = { { questID = 1109, name = "Going, Going, Guano!" } },
			rewards = { xp = 3300 },
		},
	},
	patches = {
		-- In the Name of the Light: prerequisites (Questie, foreverchanges)
		[1053] = {
			prerequisites = { { questID = 261, name = "Down the Scarlet Path" }, { questID = 1052, name = "Down the Scarlet Path" } },
		},
	},
})

Audit("Uldaman", {
	add = {
		-- Power in Uldaman (Questie)
		{
			questID = 1956, name = "Power in Uldaman", level = 40, requiredLevel = 35, faction = "Both", classOnly = "MAGE",
			pickup = "Tabetha, Dustwallow Marsh", turnin = "Tabetha, Dustwallow Marsh",
			startMap = { mapID = 1445, x = 0.461, y = 0.571, label = "Tabetha" },
			endMap = { mapID = 1445, x = 0.461, y = 0.571, label = "Tabetha" },
			objective = "Bring Tabetha in Dustwallow Marsh an Obsidian Power Source.",
			note = "A mage quest. The Obsidian Sentinel inside Uldaman carries the power source.",
			prerequisites = { { questID = 1954, name = "The Infernal Orb" }, { questID = 1955, name = "The Exorcism" } },
		},
	},
	patches = {
		-- Agmond's Fate: prerequisites (Questie, foreverchanges)
		[704] = {
			prerequisites = { { questID = 738, name = "Find Agmond" }, { questID = 739, name = "Murdaloc" } },
		},
		-- A Sign of Hope: turnin, endMap (Questie, foreverchanges)
		[721] = {
			turnin = "Hammertoe Grez, Badlands",
			endMap = { mapID = 1418, x = 0.379, y = 0.106, label = "Hammertoe Grez" },
		},
		-- Amulet of Secrets: pickup, startMap, turnin, endMap, prerequisites (Questie, foreverchanges)
		[722] = {
			pickup = "Hammertoe Grez, Badlands",
			startMap = { mapID = 1418, x = 0.379, y = 0.106, label = "Hammertoe Grez" },
			turnin = "Hammertoe Grez, Badlands",
			endMap = { mapID = 1418, x = 0.379, y = 0.106, label = "Hammertoe Grez" },
			prerequisites = { { questID = 720, name = "A Sign of Hope" }, { questID = 721, name = "A Sign of Hope" } },
		},
		-- The Lost Tablets of Will: pickup, startMap, turnin, endMap, prerequisites (Questie, foreverchanges, AAL)
		[1139] = {
			pickup = "Advisor Belgrum, Hall of Explorers, Ironforge",
			startMap = { mapID = 1455, x = 0.773, y = 0.097, label = "Advisor Belgrum" },
			turnin = "Advisor Belgrum, Hall of Explorers, Ironforge",
			endMap = { mapID = 1455, x = 0.773, y = 0.097, label = "Advisor Belgrum" },
			prerequisites = {
				{ questID = 720, name = "A Sign of Hope" },
				{ questID = 721, name = "A Sign of Hope" },
				{ questID = 722, name = "Amulet of Secrets" },
				{ questID = 723, name = "Prospect of Faith" },
				{ questID = 724, name = "Prospect of Faith" },
				{ questID = 725, name = "Passing Word of a Threat" },
				{ questID = 726, name = "Passing Word of a Threat" },
				{ questID = 762, name = "An Ambassador of Evil" },
			},
		},
		-- Reclaimed Treasures: pickup, startMap, turnin, endMap (Questie, foreverchanges)
		[1360] = {
			pickup = "Krom Stoutarm, Hall of Explorers, Ironforge",
			startMap = { mapID = 1455, x = 0.742, y = 0.094, label = "Krom Stoutarm" },
			turnin = "Krom Stoutarm, Hall of Explorers, Ironforge",
			endMap = { mapID = 1455, x = 0.742, y = 0.094, label = "Krom Stoutarm" },
		},
		-- The Shattered Necklace: pickup, turnin, endMap (Questie, FDJ, foreverchanges, AAL)
		[2198] = {
			pickup = "Item start: Shattered Necklace, dropped by the Shadowforge dwarves and Stonevault troggs around Uldaman",
			turnin = "Talvash del Kissel, Ironforge",
			endMap = { mapID = 1455, x = 0.357, y = 0.04, label = "Talvash del Kissel" },
		},
		-- Lore for a Price: pickup, startMap, turnin, endMap (Questie, FDJ, foreverchanges, AAL)
		[2199] = {
			pickup = "Talvash del Kissel, Ironforge",
			startMap = { mapID = 1455, x = 0.357, y = 0.04, label = "Talvash del Kissel" },
			turnin = "Talvash del Kissel, Ironforge",
			endMap = { mapID = 1455, x = 0.357, y = 0.04, label = "Talvash del Kissel" },
		},
		-- Back to Uldaman: prerequisites (Questie, foreverchanges)
		[2200] = {
			prerequisites = { { questID = 2198, name = "The Shattered Necklace" }, { questID = 2199, name = "Lore for a Price" } },
		},
		-- Find the Gems: pickup, prerequisites (Questie, foreverchanges, AAL)
		[2201] = {
			pickup = "Remains of a Paladin, inside Uldaman",
			prerequisites = {
				{ questID = 2198, name = "The Shattered Necklace" },
				{ questID = 2199, name = "Lore for a Price" },
				{ questID = 2200, name = "Back to Uldaman" },
			},
		},
		-- Uldaman Reagent Run: prerequisites (Questie, foreverchanges)
		[2202] = {
			prerequisites = { { questID = 2258, name = "Badlands Reagent Run" } },
		},
		-- Restoring the Necklace: pickup, turnin, endMap, prerequisites (Questie, FDJ, foreverchanges, AAL)
		[2204] = {
			pickup = "Talvash's Scrying Bowl, inside the dungeon",
			turnin = "Talvash del Kissel, Ironforge",
			endMap = { mapID = 1455, x = 0.357, y = 0.04, label = "Talvash del Kissel" },
			prerequisites = {
				{ questID = 2198, name = "The Shattered Necklace" },
				{ questID = 2199, name = "Lore for a Price" },
				{ questID = 2200, name = "Back to Uldaman" },
				{ questID = 2201, name = "Find the Gems" },
			},
		},
		-- The Hidden Chamber: pickup, turnin, endMap, prerequisites (Questie, foreverchanges, AAL)
		[2240] = {
			pickup = "Baelog, inside Uldaman",
			turnin = "Prospector Stormpike, Ironforge",
			endMap = { mapID = 1455, x = 0.746, y = 0.117, label = "Prospector Stormpike" },
			prerequisites = {},
		},
		-- The Platinum Discs: pickup, turnin, endMap, prerequisites (Questie, foreverchanges)
		[2279] = {
			pickup = "The Discs of Norgannon, inside Uldaman",
			turnin = "High Explorer Magellas, Hall of Explorers, Ironforge",
			endMap = { mapID = 1455, x = 0.696, y = 0.186, label = "High Explorer Magellas" },
			prerequisites = { { questID = 2278, name = "The Platinum Discs" } },
		},
		-- The Platinum Discs: pickup, prerequisites (Questie, foreverchanges)
		[2280] = {
			pickup = "The Discs of Norgannon, inside Uldaman",
			prerequisites = { { questID = 2278, name = "The Platinum Discs" } },
		},
		-- Translating the Journal: prerequisites (Questie, foreverchanges)
		[2318] = {
			prerequisites = { { questID = 2283, name = "Necklace Recovery" }, { questID = 2284, name = "Necklace Recovery, Take 2" } },
		},
		-- Translating the Journal: prerequisites (Questie, foreverchanges)
		[2338] = {
			prerequisites = {
				{ questID = 2283, name = "Necklace Recovery" },
				{ questID = 2284, name = "Necklace Recovery, Take 2" },
				{ questID = 2318, name = "Translating the Journal" },
			},
		},
		-- Find the Gems and Power Source: prerequisites (Questie, foreverchanges)
		[2339] = {
			prerequisites = {
				{ questID = 2283, name = "Necklace Recovery" },
				{ questID = 2284, name = "Necklace Recovery, Take 2" },
				{ questID = 2318, name = "Translating the Journal" },
				{ questID = 2338, name = "Translating the Journal" },
			},
		},
		-- Deliver the Gems: prerequisites (Questie, foreverchanges)
		[2340] = {
			prerequisites = {
				{ questID = 2283, name = "Necklace Recovery" },
				{ questID = 2284, name = "Necklace Recovery, Take 2" },
				{ questID = 2318, name = "Translating the Journal" },
				{ questID = 2338, name = "Translating the Journal" },
				{ questID = 2339, name = "Find the Gems and Power Source" },
			},
		},
		-- Necklace Recovery, Take 3: prerequisites (Questie, foreverchanges)
		[2341] = {
			prerequisites = {
				{ questID = 2283, name = "Necklace Recovery" },
				{ questID = 2284, name = "Necklace Recovery, Take 2" },
				{ questID = 2318, name = "Translating the Journal" },
				{ questID = 2338, name = "Translating the Journal" },
				{ questID = 2339, name = "Find the Gems and Power Source" },
				{ questID = 2340, name = "Deliver the Gems" },
			},
		},
		-- Restoring the Necklace: pickup, startMap, turnin, endMap, prerequisites (Questie, FDJ, foreverchanges, AAL)
		[2361] = {
			pickup = "Talvash del Kissel, Ironforge",
			startMap = { mapID = 1455, x = 0.357, y = 0.04, label = "Talvash del Kissel" },
			turnin = "Talvash del Kissel, Ironforge",
			endMap = { mapID = 1455, x = 0.357, y = 0.04, label = "Talvash del Kissel" },
			prerequisites = {
				{ questID = 2198, name = "The Shattered Necklace" },
				{ questID = 2199, name = "Lore for a Price" },
				{ questID = 2200, name = "Back to Uldaman" },
				{ questID = 2201, name = "Find the Gems" },
				{ questID = 2204, name = "Restoring the Necklace" },
			},
		},
		-- The Platinum Discs: pickup, startMap, turnin, endMap, prerequisites (Questie, foreverchanges)
		[2439] = {
			pickup = "High Explorer Magellas, Hall of Explorers, Ironforge",
			startMap = { mapID = 1455, x = 0.696, y = 0.186, label = "High Explorer Magellas" },
			turnin = "Dinita Stonemantle, the Vault, Ironforge",
			endMap = { mapID = 1455, x = 0.339, y = 0.592, label = "Dinita Stonemantle" },
			prerequisites = { { questID = 2278, name = "The Platinum Discs" }, { questID = 2279, name = "The Platinum Discs" } },
		},
		-- The Platinum Discs: prerequisites (Questie, foreverchanges)
		[2440] = {
			prerequisites = { { questID = 2278, name = "The Platinum Discs" }, { questID = 2280, name = "The Platinum Discs" } },
		},
		-- Replacement Phial: prerequisites (Questie, foreverchanges)
		[3375] = {
			prerequisites = {
				{ questID = 2198, name = "The Shattered Necklace" },
				{ questID = 2199, name = "Lore for a Price" },
				{ questID = 2200, name = "Back to Uldaman" },
				{ questID = 2201, name = "Find the Gems" },
			},
		},
	},
})

Audit("ZulFarrak", {
	patches = {
		-- Gahz'rilla: note, prerequisites (Questie, foreverchanges)
		[2770] = {
			note = "For the Alliance, The Brassbolts Brothers (Klockmort Spannerspan, Ironforge) leads here.",
			prerequisites = {},
		},
		-- Tiara of the Deep: prerequisites (Questie, foreverchanges)
		[2846] = {
			prerequisites = {},
		},
		-- Scarab Shells: prerequisites (Questie, foreverchanges)
		[2865] = {
			prerequisites = {},
		},
		-- The Spider God: prerequisites (Questie, foreverchanges)
		[2936] = {
			prerequisites = {
				{ questID = 2933, name = "Venom Bottles" },
				{ questID = 2934, name = "Undamaged Venom Sac" },
				{ questID = 2935, name = "Consult Master Gadrin" },
			},
		},
		-- Nekrum's Medallion: prerequisites (Questie, foreverchanges)
		[2991] = {
			prerequisites = {
				{ questID = 2988, name = "Witherbark Cages" },
				{ questID = 2989, name = "The Altar of Zul" },
				{ questID = 2990, name = "Thadius Grimshade" },
			},
		},
	},
})

Audit("Maraudon", {
	patches = {
		-- The Scepter of Celebras: pickup (Questie, foreverchanges, AAL)
		[7046] = {
			pickup = "Celebras the Redeemed, inside the dungeon",
		},
		-- Seed of Life: pickup (Questie, foreverchanges)
		[7066] = {
			pickup = "Zaetar's Spirit, inside the dungeon",
		},
	},
})

Audit("TempleOfAtalHakkar", {
	add = {
		-- The Sunken Temple (Questie, foreverchanges)
		{ questID = 3445, name = "The Sunken Temple", level = 51, requiredLevel = 46, faction = "Alliance", pickup = "Angelas Moonbreeze, Feathermoon Stronghold, Feralas", turnin = "Marvon Rivetseeker, Tanaris", startMap = { mapID = 1444, x = 0.318, y = 0.456, label = "Angelas Moonbreeze" }, endMap = { mapID = 1446, x = 0.527, y = 0.459, label = "Marvon Rivetseeker" }, objective = "Find Marvon Rivetseeker in Tanaris." },
		-- Haze of Evil (Questie)
		{ questID = 4143, name = "Haze of Evil", level = 52, requiredLevel = 47, faction = "Alliance", pickup = "Gregan Brewspewer, Feralas", turnin = "Muigin, Marshal's Refuge, Un'Goro Crater", startMap = { mapID = 1444, x = 0.451, y = 0.256, label = "Gregan Brewspewer" }, endMap = { mapID = 1449, x = 0.429, y = 0.096, label = "Muigin" }, objective = "Collect 5 samples of Atal'ai Haze from the Deep Lurkers, Murk Worms and Saturated Oozes of the Sunken Temple, then return to Muigin in Un'Goro Crater.", prerequisites = { { questID = 4141, name = "Muigin and Larion" }, { questID = 4142, name = "A Visit to Gregan" } } },
		-- A Better Ingredient (Questie)
		{ questID = 9053, name = "A Better Ingredient", level = 52, requiredLevel = 50, faction = "Both", classOnly = "DRUID", pickup = "Torwa Pathfinder, Un'Goro Crater", turnin = "Torwa Pathfinder, Un'Goro Crater", startMap = { mapID = 1449, x = 0.716, y = 0.760, label = "Torwa Pathfinder" }, endMap = { mapID = 1449, x = 0.716, y = 0.760, label = "Torwa Pathfinder" }, objective = "Bring Torwa Pathfinder a Putrid Vine from Atal'alarion, the guardian at the bottom of the Sunken Temple.", prerequisites = { { questID = 9052, name = "Bloodpetal Poison" }, { questID = 9051, name = "Toxic Test" } } },
	},
	patches = {
		-- The Temple of Atal'Hakkar: prerequisites (Questie, foreverchanges)
		[1445] = {
			prerequisites = {
				{ questID = 1424, name = "Pool of Tears" },
				{ questID = 1429, name = "The Atal'ai Exile" },
				{ questID = 1444, name = "Return to Fel'Zerul" },
			},
		},
		-- Into The Temple of Atal'Hakkar: prerequisites (Questie, foreverchanges)
		[1475] = {
			prerequisites = {
				{ questID = 1448, name = "In Search of The Temple" },
				{ questID = 1449, name = "To The Hinterlands" },
				{ questID = 1450, name = "Gryphon Master Talonaxe" },
				{ questID = 1451, name = "Rhapsody Shindigger" },
				{ questID = 1452, name = "Rhapsody's Kalimdor Kocktail" },
				{ questID = 1469, name = "Rhapsody's Tale" },
			},
		},
		-- The Essence of Eranikus: pickup, startItem, prerequisites (Questie, foreverchanges, AAL)
		[3373] = {
			pickup = "Use the Essence of Eranikus, dropped by the Shade of Eranikus inside the dungeon.",
			startItem = { itemID = 10454, name = "Essence of Eranikus", note = "Dropped by the Shade of Eranikus" },
			prerequisites = {},
		},
		-- The God Hakkar: prerequisites (Questie, foreverchanges)
		[3528] = {
			prerequisites = {
				{ questID = 3520, name = "Screecher Spirits" },
				{ questID = 3527, name = "The Prophecy of Mosh'aru" },
				{ questID = 4787, name = "The Ancient Egg" },
			},
		},
		-- Zapper Fuel: prerequisites (Questie, foreverchanges)
		[4146] = {
			prerequisites = { { questID = 4145, name = "Larion and Muigin" }, { questID = 4147, name = "Marvon's Workshop" } },
		},
		-- Bloodpetal Zapper: prerequisites (Questie, foreverchanges)
		[4148] = {
			prerequisites = {
				{ questID = 4145, name = "Larion and Muigin" },
				{ questID = 4147, name = "Marvon's Workshop" },
				{ questID = 4146, name = "Zapper Fuel" },
			},
		},
		-- The Green Drake: prerequisites (Questie, foreverchanges)
		[8232] = {
			prerequisites = {
				{ questID = 8151, name = "The Hunter's Charm" },
				{ questID = 8153, name = "Courser Antlers" },
				{ questID = 8231, name = "Wavethrashing" },
			},
		},
		-- The Azure Key: prerequisites (Questie, foreverchanges)
		[8236] = {
			prerequisites = { { questID = 8234, name = "Sealed Azure Bag" }, { questID = 8235, name = "Encoded Fragments" } },
		},
		-- Destroy Morphaz: prerequisites (Questie, foreverchanges)
		[8253] = {
			prerequisites = { { questID = 8251, name = "Magic Dust" }, { questID = 8252, name = "The Siren's Coral" } },
		},
		-- Blood of Morphaz: prerequisites (Questie, foreverchanges)
		[8257] = {
			prerequisites = {
				{ questID = 8254, name = "Cenarion Aid" },
				{ questID = 8255, name = "Of Coursers We Know" },
				{ questID = 8256, name = "The Ichor of Undeath" },
			},
		},
		-- Da Voodoo: note, prerequisites (Questie, foreverchanges)
		[8413] = {
			note = "Spirit Totem opens after Elemental Mastery (from a shaman trainer) or Mastering the Elements (from Bath'rah).",
			prerequisites = { { questID = 8412, name = "Spirit Totem" } },
		},
		-- Forging the Mightstone: prerequisites (Questie, foreverchanges)
		[8418] = {
			prerequisites = { { questID = 8414, name = "Dispelling Evil" }, { questID = 8416, name = "Inert Scourgestones" } },
		},
		-- Trolls of a Feather: note, prerequisites (Questie, foreverchanges)
		[8422] = {
			note = "The Wrong Stuff opens after An Imp's Request (from a warlock trainer) or Hot and Itchy (from Impsy).",
			prerequisites = { { questID = 8421, name = "The Wrong Stuff" } },
		},
		-- Voodoo Feathers: prerequisites (Questie, foreverchanges)
		[8425] = {
			prerequisites = { { questID = 8423, name = "Warrior Kinship" }, { questID = 8424, name = "War on the Shadowsworn" } },
		},
		-- Eranikus, Tyrant of the Dream: prerequisites (Questie, foreverchanges)
		[8733] = {
			prerequisites = {
				{ questID = 8286, name = "What Tomorrow Brings" },
				{ questID = 8288, name = "Only One May Rise" },
				{ questID = 8301, name = "The Path of the Righteous" },
				{ questID = 8303, name = "Anachronos" },
				{ questID = 8305, name = "Long Forgotten Memories" },
				{ questID = 8519, name = "A Pawn on the Eternal Board" },
				{ questID = 8555, name = "The Charge of the Dragonflights" },
			},
		},
	},
})

Audit("BlackrockDepths", {
	add = {
		-- Attunement to the Core (Questie)
		{
			questID = 7848, name = "Attunement to the Core", level = 60, requiredLevel = 55, faction = "Both",
			pickup = "Lothos Riftwaker, Blackrock Mountain",
			turnin = "Lothos Riftwaker, Blackrock Mountain",
			startMap = { mapID = 1427, x = 0.321, y = 0.947, label = "Lothos Riftwaker" },
			endMap = { mapID = 1427, x = 0.321, y = 0.947, label = "Lothos Riftwaker" },
			objective = "Recover a Core Fragment at the Molten Core entry portal inside Blackrock Depths, then go back to Lothos Riftwaker.",
		},
	},
	patches = {
		-- What Is Going On?: prerequisites (Questie, foreverchanges)
		[3982] = {
			prerequisites = { { questID = 3906, name = "Disharmony of Flame" }, { questID = 3981, name = "Commander Gor'shak" } },
		},
		-- What Is Going On?: prerequisites (Questie, foreverchanges)
		[4001] = {
			prerequisites = {
				{ questID = 3906, name = "Disharmony of Flame" },
				{ questID = 3981, name = "Commander Gor'shak" },
				{ questID = 3982, name = "What Is Going On?" },
			},
		},
		-- The Eastern Kingdoms: name, prerequisites (Questie, foreverchanges)
		[4002] = {
			name = "The Eastern Kingdom",
			prerequisites = {
				{ questID = 3906, name = "Disharmony of Flame" },
				{ questID = 3981, name = "Commander Gor'shak" },
				{ questID = 3982, name = "What Is Going On?" },
				{ questID = 4001, name = "What Is Going On?" },
			},
		},
		-- The Royal Rescue: faction, prerequisites (Questie, foreverchanges, AAL)
		[4003] = {
			faction = "Horde",
			prerequisites = {
				{ questID = 3906, name = "Disharmony of Flame" },
				{ questID = 3981, name = "Commander Gor'shak" },
				{ questID = 3982, name = "What Is Going On?" },
				{ questID = 4001, name = "What Is Going On?" },
				{ questID = 4002, name = "The Eastern Kingdom" },
			},
		},
		-- The Princess Saved?: faction, pickup, prerequisites (Questie, foreverchanges, AAL)
		[4004] = {
			faction = "Horde",
			pickup = "Princess Moira Bronzebeard, inside the dungeon",
			prerequisites = {
				{ questID = 3906, name = "Disharmony of Flame" },
				{ questID = 3981, name = "Commander Gor'shak" },
				{ questID = 3982, name = "What Is Going On?" },
				{ questID = 4001, name = "What Is Going On?" },
				{ questID = 4002, name = "The Eastern Kingdom" },
				{ questID = 4003, name = "The Royal Rescue" },
			},
		},
		-- The Rise of the Machines: prerequisites (Questie, foreverchanges)
		[4063] = {
			prerequisites = { { questID = 4061, name = "The Rise of the Machines" }, { questID = 4062, name = "The Rise of the Machines" } },
		},
		-- The Spectral Chalice: pickup, startObject (Questie, foreverchanges)
		[4083] = {
			pickup = "Spectral Chalice, inside the dungeon",
			startObject = { name = "Spectral Chalice", note = "Inside the dungeon; needs Mining 230." },
		},
		-- Precarious Predicament: prerequisites (Questie, foreverchanges)
		[4121] = {
			prerequisites = {
				{ questID = 4081, name = "KILL ON SIGHT: Dark Iron Dwarves" },
				{ questID = 4082, name = "KILL ON SIGHT: High Ranking Dark Iron Officials" },
				{ questID = 4122, name = "Grark Lorkrub" },
			},
		},
		-- Grark Lorkrub: prerequisites (Questie, foreverchanges)
		[4122] = {
			prerequisites = { { questID = 4081, name = "KILL ON SIGHT: Dark Iron Dwarves" }, { questID = 4082, name = "KILL ON SIGHT: High Ranking Dark Iron Officials" } },
		},
		-- Hurley Blackbreath: prerequisites (Questie, foreverchanges)
		[4126] = {
			prerequisites = {},
		},
		-- Operation: Death to Angerforge: prerequisites (Questie, foreverchanges)
		[4132] = {
			prerequisites = {
				{ questID = 4081, name = "KILL ON SIGHT: Dark Iron Dwarves" },
				{ questID = 4082, name = "KILL ON SIGHT: High Ranking Dark Iron Officials" },
				{ questID = 4122, name = "Grark Lorkrub" },
				{ questID = 4121, name = "Precarious Predicament" },
			},
		},
		-- Lost Thunderbrew Recipe: prerequisites (Questie, foreverchanges)
		[4134] = {
			prerequisites = {},
		},
		-- Ribbly Screwspigot: prerequisites (Questie, foreverchanges)
		[4136] = {
			prerequisites = {},
		},
		-- The Love Potion: pickup (Questie, foreverchanges, AAL)
		[4201] = {
			pickup = "Mistress Nagmara, inside the dungeon",
		},
		-- Marshal Windsor: prerequisites (Questie, foreverchanges)
		[4241] = {
			prerequisites = {
				{ questID = 4182, name = "Dragonkin Menace" },
				{ questID = 4183, name = "The True Masters" },
				{ questID = 4184, name = "The True Masters" },
				{ questID = 4185, name = "The True Masters" },
				{ questID = 4186, name = "The True Masters" },
				{ questID = 4223, name = "The True Masters" },
				{ questID = 4224, name = "The True Masters" },
			},
		},
		-- Abandoned Hope: pickup, prerequisites (Questie, foreverchanges, AAL)
		[4242] = {
			pickup = "Marshal Windsor, inside the dungeon",
			prerequisites = {
				{ questID = 4182, name = "Dragonkin Menace" },
				{ questID = 4183, name = "The True Masters" },
				{ questID = 4184, name = "The True Masters" },
				{ questID = 4185, name = "The True Masters" },
				{ questID = 4186, name = "The True Masters" },
				{ questID = 4223, name = "The True Masters" },
				{ questID = 4224, name = "The True Masters" },
				{ questID = 4241, name = "Marshal Windsor" },
			},
		},
		-- A Crumpled Up Note: pickup, startItem, prerequisites (Questie, foreverchanges)
		[4264] = {
			pickup = "A Crumpled Up Note, dropped by foes inside the dungeon",
			startItem = { itemID = 11446, name = "A Crumpled Up Note", note = "Drops from foes all over Blackrock Depths." },
			prerequisites = {
				{ questID = 4182, name = "Dragonkin Menace" },
				{ questID = 4183, name = "The True Masters" },
				{ questID = 4184, name = "The True Masters" },
				{ questID = 4185, name = "The True Masters" },
				{ questID = 4186, name = "The True Masters" },
				{ questID = 4223, name = "The True Masters" },
				{ questID = 4224, name = "The True Masters" },
				{ questID = 4241, name = "Marshal Windsor" },
				{ questID = 4242, name = "Abandoned Hope" },
			},
		},
		-- A Shred of Hope: pickup, prerequisites (Questie, foreverchanges, AAL)
		[4282] = {
			pickup = "Marshal Windsor, inside the dungeon",
			prerequisites = {
				{ questID = 4182, name = "Dragonkin Menace" },
				{ questID = 4183, name = "The True Masters" },
				{ questID = 4184, name = "The True Masters" },
				{ questID = 4185, name = "The True Masters" },
				{ questID = 4186, name = "The True Masters" },
				{ questID = 4223, name = "The True Masters" },
				{ questID = 4224, name = "The True Masters" },
				{ questID = 4241, name = "Marshal Windsor" },
				{ questID = 4242, name = "Abandoned Hope" },
				{ questID = 4264, name = "A Crumpled Up Note" },
			},
		},
		-- Jail Break!: pickup, prerequisites (Questie, foreverchanges, AAL)
		[4322] = {
			pickup = "Marshal Windsor, inside the dungeon",
			prerequisites = {
				{ questID = 4182, name = "Dragonkin Menace" },
				{ questID = 4183, name = "The True Masters" },
				{ questID = 4184, name = "The True Masters" },
				{ questID = 4185, name = "The True Masters" },
				{ questID = 4186, name = "The True Masters" },
				{ questID = 4223, name = "The True Masters" },
				{ questID = 4224, name = "The True Masters" },
				{ questID = 4241, name = "Marshal Windsor" },
				{ questID = 4242, name = "Abandoned Hope" },
				{ questID = 4264, name = "A Crumpled Up Note" },
				{ questID = 4282, name = "A Shred of Hope" },
			},
		},
		-- Kharan Mighthammer: prerequisites (Questie, foreverchanges)
		[4341] = {
			prerequisites = { { questID = 3702, name = "The Smoldering Ruins of Thaurissan" }, { questID = 3701, name = "The Smoldering Ruins of Thaurissan" } },
		},
		-- Kharan's Tale: prerequisites (Questie, foreverchanges)
		[4342] = {
			prerequisites = {
				{ questID = 3702, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 3701, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 4341, name = "Kharan Mighthammer" },
			},
		},
		-- The Bearer of Bad News: prerequisites (Questie, foreverchanges)
		[4361] = {
			prerequisites = {
				{ questID = 3702, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 3701, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 4341, name = "Kharan Mighthammer" },
				{ questID = 4342, name = "Kharan's Tale" },
			},
		},
		-- The Fate of the Kingdom: pickup, startMap, prerequisites (Questie, foreverchanges, AAL)
		[4362] = {
			pickup = "King Magni Bronzebeard, Ironforge",
			startMap = { mapID = 1455, x = 0.391, y = 0.562, label = "King Magni Bronzebeard" },
			prerequisites = {
				{ questID = 3702, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 3701, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 4341, name = "Kharan Mighthammer" },
				{ questID = 4342, name = "Kharan's Tale" },
				{ questID = 4361, name = "The Bearer of Bad News" },
			},
		},
		-- The Princess's Surprise: pickup, turnin, endMap, prerequisites (Questie, foreverchanges, AAL)
		[4363] = {
			pickup = "Princess Moira Bronzebeard, inside the dungeon",
			turnin = "King Magni Bronzebeard, Ironforge",
			endMap = { mapID = 1455, x = 0.391, y = 0.562, label = "King Magni Bronzebeard" },
			prerequisites = {
				{ questID = 3702, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 3701, name = "The Smoldering Ruins of Thaurissan" },
				{ questID = 4341, name = "Kharan Mighthammer" },
				{ questID = 4342, name = "Kharan's Tale" },
				{ questID = 4361, name = "The Bearer of Bad News" },
				{ questID = 4362, name = "The Fate of the Kingdom" },
			},
		},
		-- The Last Element: prerequisites (Questie, foreverchanges)
		[7201] = {
			prerequisites = { { questID = 3906, name = "Disharmony of Flame" } },
		},
		-- A Binding Contract: pickup, startItem (Questie, foreverchanges, AAL)
		[7604] = {
			pickup = "Thorium Brotherhood Contract, from Lokhtos Darkbargainer inside the dungeon",
			startItem = { itemID = 18628, name = "Thorium Brotherhood Contract", note = "Given by Lokhtos Darkbargainer, inside the dungeon." },
		},
		-- The Challenge: pickup, prerequisites (Questie, foreverchanges)
		[9015] = {
			pickup = "Falrin Treeshaper, the library, inside Dire Maul",
			prerequisites = {
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
			},
		},
	},
	remove = {
		3911, -- The Last Element: not on Forever: an old duplicate the game never offers
	},
})

Audit("DireMaulEast", {
	add = {
		-- The Prison's Bindings (Questie)
		{
			questID = 7581, name = "The Prison's Bindings", level = 60, requiredLevel = 60, faction = "Both", classOnly = "WARLOCK",
			pickup = "Daio the Decrepit, The Tainted Scar, Blasted Lands", turnin = "Daio the Decrepit, The Tainted Scar, Blasted Lands",
			startMap = { mapID = 1419, x = 0.341, y = 0.501, label = "Daio the Decrepit" },
			endMap = { mapID = 1419, x = 0.341, y = 0.501, label = "Daio the Decrepit" },
			objective = "Bring Daio 15 Satyr Blood from the Wildspawn satyrs of the Warpwood Quarter.",
			note = "Taken with The Prison's Casing; both lead to Suppression.",
		},
		-- Unfinished Gordok Business (Questie, foreverchanges)
		{
			questID = 7703, name = "Unfinished Gordok Business", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Captain Kromcrush, inside Dire Maul", turnin = "Captain Kromcrush, inside Dire Maul",
			objective = "Find the Gauntlet of Gordok Might and return it to Captain Kromcrush in Dire Maul.",
			note = "The gauntlet is in The Prince's Chest, in Prince Tortheldrin's wing.",
			rewards = {
				choice = true,
				items = {
					{ itemID = 18366, name = "Gordok's Handguards" },
					{ itemID = 18367, name = "Gordok's Gauntlets" },
					{ itemID = 18368, name = "Gordok's Gloves" },
					{ itemID = 18369, name = "Gordok's Handwraps" },
				},
			},
		},
	},
	patches = {
		-- The Gordok Taste Test: pickup, turnin (Questie, foreverchanges, AAL)
		[5528] = {
			pickup = "Stomper Kreeg, inside Dire Maul",
			turnin = "Stomper Kreeg, inside Dire Maul North",
		},
		-- Arcane Refreshment: classOnly, pickup (Questie, foreverchanges, AAL)
		[7463] = {
			classOnly = "MAGE",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
		},
		-- Elven Legends: objective (Questie)
		[7481] = {
			objective = "Look in Dire Maul for Telmius Dreamseeker and report back to Sage Korolusk.",
		},
		-- Elven Legends: objective (Questie)
		[7482] = {
			objective = "Look in Dire Maul for Telmius Dreamseeker and report back to Scholar Runethorn.",
		},
		-- Libram of Rapidity: note, prerequisites (Questie)
		[7483] = {
			note = "Repeatable. Lydros offers it after Elven Legends (Sage Korolusk's for the Horde, Scholar Runethorn's for the Alliance).",
			prerequisites = {},
		},
		-- Libram of Focus: note, prerequisites (Questie)
		[7484] = {
			note = "Repeatable. Lydros offers it after Elven Legends (Sage Korolusk's for the Horde, Scholar Runethorn's for the Alliance).",
			prerequisites = {},
		},
		-- Libram of Protection: note, prerequisites (Questie)
		[7485] = {
			note = "Repeatable. Lydros offers it after Elven Legends (Sage Korolusk's for the Horde, Scholar Runethorn's for the Alliance).",
			prerequisites = {},
		},
		-- Lethtendris's Web: prerequisites (Questie, foreverchanges)
		[7488] = {
			prerequisites = {},
		},
		-- Camp Mojache: startMap, note (Questie, foreverchanges)
		[7492] = {
			startMap = { mapID = 1454, x = 0.377, y = 0.752, label = "Warcaller Gorlach" },
			note = "Also from Harbinger Balthazad in Undercity and Bluff Runner Windstrider in Thunder Bluff.",
		},
		-- Garona: A Study on Stealth and Treachery: classOnly, startItem (Questie, foreverchanges, AAL)
		[7498] = {
			classOnly = "ROGUE",
			startItem = { itemID = 18356, name = "Garona: A Study on Stealth and Treachery", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- Codex of Defense: classOnly, startItem (Questie, foreverchanges, AAL)
		[7499] = {
			classOnly = "WARRIOR",
			startItem = { itemID = 18357, name = "Codex of Defense", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- The Arcanist's Cookbook: classOnly, startItem (Questie, foreverchanges, AAL)
		[7500] = {
			classOnly = "MAGE",
			startItem = { itemID = 18358, name = "The Arcanist's Cookbook", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- The Light and How To Swing It: classOnly, startItem (Questie, foreverchanges, AAL)
		[7501] = {
			classOnly = "PALADIN",
			startItem = { itemID = 18359, name = "The Light and How to Swing It", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- Harnessing Shadows: classOnly, startItem (Questie, foreverchanges, AAL)
		[7502] = {
			classOnly = "WARLOCK",
			startItem = { itemID = 18360, name = "Harnessing Shadows", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- The Greatest Race of Hunters: classOnly, startItem (Questie, foreverchanges, AAL)
		[7503] = {
			classOnly = "HUNTER",
			startItem = { itemID = 18361, name = "The Greatest Race of Hunters", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- Holy Bologna: What the Light Won't Tell You: classOnly, startItem (Questie, foreverchanges, AAL)
		[7504] = {
			classOnly = "PRIEST",
			startItem = { itemID = 18362, name = "Holy Bologna: What the Light Won't Tell You", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- Frost Shock and You: classOnly, startItem (Questie, foreverchanges, AAL)
		[7505] = {
			classOnly = "SHAMAN",
			startItem = { itemID = 18363, name = "Frost Shock and You", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- The Emerald Dream...: classOnly, startItem (Questie, foreverchanges, AAL)
		[7506] = {
			classOnly = "DRUID",
			startItem = { itemID = 18364, name = "The Emerald Dream", note = "From A Dusty Tome inside Dire Maul." },
		},
		-- Foror's Compendium: name, startItem, objective, note (Questie, foreverchanges)
		[7507] = {
			name = "Nostro's Compendium",
			startItem = { itemID = 18401, name = "Nostro's Compendium of Dragon Slaying", note = "From A Dusty Tome inside Dire Maul." },
			objective = "Return Nostro's Compendium of Dragon Slaying to the Athenaeum.",
			note = "For warriors and paladins.",
		},
		-- The Forging of Quel'Serrar: startItem, note, prerequisites (Questie, foreverchanges)
		[7508] = {
			startItem = { itemID = 18513, name = "A Dull and Flat Elven Blade" },
			note = "For warriors and paladins.",
			prerequisites = { { questID = 7507, name = "Nostro's Compendium" } },
		},
		-- The Forging of Quel'Serrar: pickup, note, prerequisites (Questie, foreverchanges)
		[7509] = {
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			note = "For warriors and paladins.",
			prerequisites = { { questID = 7507, name = "Nostro's Compendium" }, { questID = 7508, name = "The Forging of Quel'Serrar" } },
		},
		-- The Treasure of the Shen'dralar: faction, prerequisites (Questie, foreverchanges)
		[7877] = {
			faction = "Both",
			prerequisites = { { questID = 7461, name = "The Madness Within" } },
		},
		-- Anthion's Old Friend: prerequisites (Questie, foreverchanges)
		[8948] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
			},
		},
		-- Falrin's Vendetta: pickup, prerequisites (Questie, foreverchanges, AAL)
		[8949] = {
			pickup = "Falrin Treeshaper, inside Dire Maul",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
			},
		},
		-- The Instigator's Enchantment: pickup, prerequisites (Questie, foreverchanges, AAL)
		[8950] = {
			pickup = "Falrin Treeshaper, inside Dire Maul",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
			},
		},
		-- The Left Piece of Lord Valthalak's Amulet: prerequisites (Questie, foreverchanges)
		[8967] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
			},
		},
		-- The Right Piece of Lord Valthalak's Amulet: prerequisites (Questie, foreverchanges)
		[8990] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
			},
		},
	},
	remove = {
		1318, -- Unfinished Gordok Business: a duplicate of Unfinished Gordok Business (7703), not in the game
		7462, -- The Treasure of the Shen'dralar: a duplicate of The Treasure of the Shen'dralar (7877), which both sides take
	},
})

Audit("LowerBlackrockSpire", {
	add = {
		-- Final Preparations (Questie, foreverchanges)
		{
			questID = 8994, name = "Final Preparations", level = 60, requiredLevel = 58, faction = "Both",
			pickup = "Bodley, Burning Steppes",
			turnin = "Bodley, Burning Steppes",
			startMap = { mapID = 1428, x = 0.323, y = 0.258 }, endMap = { mapID = 1428, x = 0.323, y = 0.258 },
			objective = "Bring Bodley 40 Blackrock Bracers, taken from the orcs of Blackrock Spire, and a Flask of Supreme Power.",
			note = "Offered once one of the four Right Piece of Lord Valthalak's Amulet quests is done.",
			prerequisites = { { questID = 8921, name = "The Ectoplasmic Distiller" }, { questID = 8924, name = "Hunting for Ectoplasm" }, { questID = 8925, name = "A Portable Power Source" }, { questID = 8928, name = "A Shifty Merchant" }, { questID = 8945, name = "Dead Man's Plea" }, { questID = 8946, name = "Proof of Life" }, { questID = 8947, name = "Anthion's Strange Request" }, { questID = 8948, name = "Anthion's Old Friend" }, { questID = 8949, name = "Falrin's Vendetta" }, { questID = 8950, name = "The Instigator's Enchantment" }, { questID = 9015, name = "The Challenge" }, { questID = 8961, name = "Three Kings of Flame" }, { questID = 8970, name = "I See Alcaz Island In Your Future..." } },
		},
	},
	patches = {
		-- Seal of Ascension: pickup, prerequisites (Questie, foreverchanges)
		[4742] = {
			pickup = "Vaelan, inside the dungeon",
			prerequisites = {},
		},
		-- Seal of Ascension: pickup (Questie, foreverchanges)
		[4743] = {
			pickup = "Vaelan, inside the dungeon",
		},
		-- Doomrigger's Clasp: prerequisites (Questie, foreverchanges)
		[4764] = {
			prerequisites = {},
		},
		-- The Final Tablets: prerequisites (Questie, foreverchanges)
		[4788] = {
			prerequisites = {
				{ questID = 3520, name = "Screecher Spirits" },
				{ questID = 3527, name = "The Prophecy of Mosh'aru" },
				{ questID = 4787, name = "The Ancient Egg" },
				{ questID = 3528, name = "The God Hakkar" },
				{ questID = 5065, name = "The Lost Tablets of Mosh'aru" },
			},
		},
		-- Urok Doomhowl: pickup (Questie, foreverchanges)
		[4867] = {
			pickup = "Warosh, inside the dungeon",
		},
		-- Warlord's Command: pickup, startMap (Questie, foreverchanges, AAL)
		[4903] = {
			pickup = "Warlord Goretooth, Badlands",
			startMap = { mapID = 1418, x = 0.058, y = 0.475, label = "Warlord Goretooth" },
		},
		-- Bijou's Belongings: prerequisites (Questie, foreverchanges)
		[4982] = {
			prerequisites = { { questID = 4981, name = "Operative Bijou" } },
		},
		-- Bijou's Reconnaissance Report: pickup, prerequisites (Questie, foreverchanges)
		[4983] = {
			pickup = "Bijou, inside the dungeon",
			prerequisites = { { questID = 4981, name = "Operative Bijou" }, { questID = 4982, name = "Bijou's Belongings" } },
		},
		-- Bijou's Belongings: pickup (Questie, foreverchanges)
		[5001] = {
			pickup = "Bijou, inside the dungeon",
		},
		-- Message to Maxwell: pickup (Questie, foreverchanges)
		[5002] = {
			pickup = "Bijou, inside the dungeon",
		},
		-- Maxwell's Mission: prerequisites (Questie, foreverchanges)
		[5081] = {
			prerequisites = { { questID = 5001, name = "Bijou's Belongings" }, { questID = 5002, name = "Message to Maxwell" } },
		},
		-- General Drakkisath's Command: pickup, startItem (Questie, foreverchanges)
		[5089] = {
			pickup = "General Drakkisath's Command, dropped by Overlord Wyrmthalak inside Lower Blackrock Spire",
			startItem = { itemID = 12780, name = "General Drakkisath's Command", note = "Dropped by Overlord Wyrmthalak." },
		},
		-- The Matron Protectorate: pickup (Questie, foreverchanges)
		[5160] = {
			pickup = "Awbee, inside the dungeon",
		},
		-- Oculus Illusions: prerequisites (Questie, foreverchanges)
		[6569] = {
			prerequisites = {
				{ questID = 4903, name = "Warlord's Command" },
				{ questID = 4941, name = "Eitrigg's Wisdom" },
				{ questID = 4974, name = "For The Horde!" },
				{ questID = 6566, name = "What the Wind Carries" },
				{ questID = 6567, name = "The Champion of the Horde" },
				{ questID = 6568, name = "The Testament of Rexxar" },
			},
		},
		-- Confront Yeh'kinya: prerequisites (Questie, foreverchanges)
		[8181] = {
			prerequisites = {
				{ questID = 3520, name = "Screecher Spirits" },
				{ questID = 3527, name = "The Prophecy of Mosh'aru" },
				{ questID = 4787, name = "The Ancient Egg" },
				{ questID = 3528, name = "The God Hakkar" },
				{ questID = 5065, name = "The Lost Tablets of Mosh'aru" },
				{ questID = 4788, name = "The Final Tablets" },
			},
		},
		-- Mea Culpa, Lord Valthalak: prerequisites (Questie, foreverchanges)
		[8995] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
				{ questID = 8994, name = "Final Preparations" },
			},
		},
		-- Return to Bodley: pickup, prerequisites (Questie, foreverchanges)
		[8996] = {
			pickup = "Spirit of Lord Valthalak, inside the dungeon",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
				{ questID = 8994, name = "Final Preparations" },
				{ questID = 8995, name = "Mea Culpa, Lord Valthalak" },
			},
		},
	},
	remove = {
		4734, -- Egg Freezing: Upper Blackrock Spire's: the eggs are in its Rookery
		4735, -- Egg Collection: Upper Blackrock Spire's: the eggs are in its Rookery
		5047, -- Finkle Einhorn, At Your Service!: Upper Blackrock Spire's: it starts after The Beast
		5127, -- The Demon Forge: Upper Blackrock Spire's: Goraluk Anvilcrack is there
		7761, -- Blackhand's Command: Upper Blackrock Spire's: it ends at Drakkisath's Brand
	},
})

Audit("DireMaulWest", {
	add = {
		-- Dreadsteed of Xoroth (Questie)
		{
			questID = 7631, name = "Dreadsteed of Xoroth", level = 60, requiredLevel = 60, faction = "Both", classOnly = "WARLOCK",
			pickup = "Mor'zul Bloodbringer, Burning Steppes", turnin = "Dreadsteed Spirit, inside the dungeon",
			startMap = { mapID = 1428, x = 0.127, y = 0.316, label = "Mor'zul Bloodbringer" },
			objective = "Read Mor'zul's Instructions. Summon a Xorothian Dreadsteed, defeat it, then bind its spirit to you.",
			note = "The summoning is done in the Prison of Immol'thar.",
			prerequisites = {
				{ questID = 7563, name = "Rage of Blood" },
				{ questID = 7564, name = "Wildeyes" },
				{ questID = 7623, name = "Lord Banehollow" },
				{ questID = 7624, name = "Ulathek the Traitor" },
				{ questID = 7625, name = "Xorothian Stardust" },
				{ questID = 7626, name = "Bell of Dethmoora" },
				{ questID = 7627, name = "Wheel of the Black March" },
				{ questID = 7628, name = "Doomsday Candle" },
				{ questID = 7629, name = "Imp Delivery" },
				{ questID = 7630, name = "Arcanite" },
			},
		},
		-- Ancient Equine Spirit (Questie)
		{
			questID = 7643, name = "Ancient Equine Spirit", level = 60, requiredLevel = 60, faction = "Alliance", classOnly = "PALADIN",
			pickup = "Lord Grayson Shadowbreaker, Cathedral District, Stormwind", turnin = "Ancient Equine Spirit, inside the dungeon",
			startMap = { mapID = 1453, x = 0.484, y = 0.502, label = "Lord Grayson Shadowbreaker" },
			objective = "Get the special horse feed from Merideth Carlson in Southshore, kill Tendris Warpwood in Dire Maul to free the Ancient Equine Spirit, feed it, and give it the Arcanite Barding to bless.",
			prerequisites = {
				{ questID = 7638, name = "Lord Grayson Shadowbreaker" },
				{ questID = 7637, name = "Emphasis on Sacrifice" },
				{ questID = 7639, name = "To Show Due Judgment" },
				{ questID = 7640, name = "Exorcising Terrordale" },
				{ questID = 7641, name = "The Work of Grimand Elmore" },
				{ questID = 7642, name = "Collection of Goods" },
			},
		},
		-- Blessed Arcanite Barding (Questie)
		{
			questID = 7644, name = "Blessed Arcanite Barding", level = 60, requiredLevel = 60, faction = "Alliance", classOnly = "PALADIN",
			pickup = "Ancient Equine Spirit, inside the dungeon", turnin = "Lord Grayson Shadowbreaker, Cathedral District, Stormwind",
			endMap = { mapID = 1453, x = 0.484, y = 0.502, label = "Lord Grayson Shadowbreaker" },
			objective = "Return with the Blessed Arcanite Barding to Lord Grayson Shadowbreaker in the Cathedral District of Stormwind.",
			prerequisites = {
				{ questID = 7638, name = "Lord Grayson Shadowbreaker" },
				{ questID = 7637, name = "Emphasis on Sacrifice" },
				{ questID = 7639, name = "To Show Due Judgment" },
				{ questID = 7640, name = "Exorcising Terrordale" },
				{ questID = 7641, name = "The Work of Grimand Elmore" },
				{ questID = 7642, name = "Collection of Goods" },
				{ questID = 7643, name = "Ancient Equine Spirit" },
			},
		},
		-- Unfinished Gordok Business (AAL, Questie, foreverchanges)
		{
			questID = 7703, name = "Unfinished Gordok Business", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Captain Kromcrush, inside Dire Maul", turnin = "Captain Kromcrush, inside Dire Maul",
			objective = "Find the Gauntlet of Gordok Might and return it to Captain Kromcrush in Dire Maul.",
			note = "The gauntlet is in The Prince's Chest, in Prince Tortheldrin's wing.",
			rewards = {
				choice = true,
				items = {
					{ itemID = 18366, name = "Gordok's Handguards" },
					{ itemID = 18367, name = "Gordok's Gauntlets" },
					{ itemID = 18368, name = "Gordok's Gloves" },
					{ itemID = 18369, name = "Gordok's Handwraps" },
				},
			},
		},
	},
	patches = {
		-- The Madness Within: pickup (Questie, foreverchanges, AAL)
		[7461] = {
			pickup = "Shen'dralar Ancient, inside the dungeon",
		},
		-- Garona: A Study on Stealth and Treachery: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7498] = {
			classOnly = "ROGUE",
			pickup = "Item start: Garona: A Study on Stealth and Treachery, inside Dire Maul",
			startItem = { itemID = 18356, name = "Garona: A Study on Stealth and Treachery", note = "From A Dusty Tome in Dire Maul." },
		},
		-- Codex of Defense: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7499] = {
			classOnly = "WARRIOR",
			pickup = "Item start: Codex of Defense, inside Dire Maul",
			startItem = { itemID = 18357, name = "Codex of Defense", note = "From A Dusty Tome in Dire Maul." },
		},
		-- The Arcanist's Cookbook: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7500] = {
			classOnly = "MAGE",
			pickup = "Item start: The Arcanist's Cookbook, inside Dire Maul",
			startItem = { itemID = 18358, name = "The Arcanist's Cookbook", note = "From A Dusty Tome in Dire Maul." },
		},
		-- The Light and How To Swing It: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7501] = {
			classOnly = "PALADIN",
			pickup = "Item start: The Light and How to Swing It, inside Dire Maul",
			startItem = { itemID = 18359, name = "The Light and How to Swing It", note = "From A Dusty Tome in Dire Maul." },
		},
		-- Harnessing Shadows: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7502] = {
			classOnly = "WARLOCK",
			pickup = "Item start: Harnessing Shadows, inside Dire Maul",
			startItem = { itemID = 18360, name = "Harnessing Shadows", note = "From A Dusty Tome in Dire Maul." },
		},
		-- The Greatest Race of Hunters: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7503] = {
			classOnly = "HUNTER",
			pickup = "Item start: The Greatest Race of Hunters, inside Dire Maul",
			startItem = { itemID = 18361, name = "The Greatest Race of Hunters", note = "From A Dusty Tome in Dire Maul." },
		},
		-- Holy Bologna: What the Light Won't Tell You: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7504] = {
			classOnly = "PRIEST",
			pickup = "Item start: Holy Bologna: What the Light Won't Tell You, inside Dire Maul",
			startItem = { itemID = 18362, name = "Holy Bologna: What the Light Won't Tell You", note = "From A Dusty Tome in Dire Maul." },
		},
		-- Frost Shock and You: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7505] = {
			classOnly = "SHAMAN",
			pickup = "Item start: Frost Shock and You, inside Dire Maul",
			startItem = { itemID = 18363, name = "Frost Shock and You", note = "From A Dusty Tome in Dire Maul." },
		},
		-- The Emerald Dream...: classOnly, pickup, startItem (Questie, foreverchanges, AAL)
		[7506] = {
			classOnly = "DRUID",
			pickup = "Item start: The Emerald Dream, inside Dire Maul",
			startItem = { itemID = 18364, name = "The Emerald Dream", note = "From A Dusty Tome in Dire Maul, or from Captain Kromcrush." },
		},
		-- Foror's Compendium: name, pickup, startItem (Questie, foreverchanges)
		[7507] = {
			name = "Nostro's Compendium",
			pickup = "Item start: Nostro's Compendium of Dragon Slaying, inside Dire Maul",
			startItem = { itemID = 18401, name = "Nostro's Compendium of Dragon Slaying", note = "From A Dusty Tome in Dire Maul." },
		},
		-- The Forging of Quel'Serrar: pickup, startItem, prerequisites (Questie, foreverchanges)
		[7508] = {
			pickup = "Item start: A Dull and Flat Elven Blade",
			startItem = { itemID = 18513, name = "A Dull and Flat Elven Blade" },
			prerequisites = { { questID = 7507, name = "Nostro's Compendium" } },
		},
		-- The Forging of Quel'Serrar: pickup, prerequisites (Questie, foreverchanges)
		[7509] = {
			pickup = "Lorekeeper Lydros, inside the dungeon",
			prerequisites = { { questID = 7507, name = "Nostro's Compendium" }, { questID = 7508, name = "The Forging of Quel'Serrar" } },
		},
		-- The Treasure of the Shen'dralar: faction, prerequisites (Questie, foreverchanges, AAL)
		[7877] = {
			faction = "Both",
			prerequisites = { { questID = 7461, name = "The Madness Within" } },
		},
		-- Anthion's Old Friend: prerequisites (Questie, foreverchanges, AAL)
		[8948] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
			},
		},
		-- Falrin's Vendetta: pickup, prerequisites (Questie, foreverchanges, AAL)
		[8949] = {
			pickup = "Falrin Treeshaper, inside the dungeon",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
			},
		},
		-- The Instigator's Enchantment: pickup, prerequisites (Questie, foreverchanges, AAL)
		[8950] = {
			pickup = "Falrin Treeshaper, inside the dungeon",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
			},
		},
	},
	remove = {
		1318, -- Unfinished Gordok Business: a duplicate of Unfinished Gordok Business (7703), not in the game
		5528, -- The Gordok Taste Test: Dire Maul North's: Stomper Kreeg gives and takes it there
		7462, -- The Treasure of the Shen'dralar: a duplicate of The Treasure of the Shen'dralar (7877), which both sides take
		8967, -- The Left Piece of Lord Valthalak's Amulet: Dire Maul East's: its target, Isalien, is there
		8990, -- The Right Piece of Lord Valthalak's Amulet: Dire Maul East's: its target, Isalien, is there
	},
})

Audit("DireMaulNorth", {
	add = {
		-- Unfinished Gordok Business (AAL, Questie, foreverchanges)
		{
			questID = 7703, name = "Unfinished Gordok Business", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Captain Kromcrush, inside Dire Maul", turnin = "Captain Kromcrush, inside Dire Maul",
			objective = "Find the Gauntlet of Gordok Might and return it to Captain Kromcrush in Dire Maul.",
			note = "The gauntlet is in The Prince's Chest, in Prince Tortheldrin's wing.",
			rewards = {
				choice = true,
				items = {
					{ itemID = 18366, name = "Gordok's Handguards" },
					{ itemID = 18367, name = "Gordok's Gauntlets" },
					{ itemID = 18368, name = "Gordok's Gloves" },
					{ itemID = 18369, name = "Gordok's Handwraps" },
				},
			},
		},
	},
	patches = {
		-- The Gordok Ogre Suit: pickup (Questie, foreverchanges, AAL)
		[5518] = {
			pickup = "Knot Thimblejack, inside the dungeon",
		},
		-- Free Knot!: pickup (Questie, foreverchanges)
		[5525] = {
			pickup = "Knot Thimblejack, inside the dungeon",
		},
		-- The Gordok Taste Test: pickup, turnin (Questie, foreverchanges, AAL)
		[5528] = {
			pickup = "Stomper Kreeg, inside the dungeon",
			turnin = "Stomper Kreeg, inside Dire Maul North",
		},
		-- Libram of Rapidity: note (Questie)
		[7483] = {
			note = "Repeatable. Lorekeeper Lydros offers it once you have done Elven Legends.",
		},
		-- Libram of Focus: note (Questie)
		[7484] = {
			note = "Repeatable. Lorekeeper Lydros offers it once you have done Elven Legends.",
		},
		-- Libram of Protection: note (Questie)
		[7485] = {
			note = "Repeatable. Lorekeeper Lydros offers it once you have done Elven Legends.",
		},
		-- Garona: A Study on Stealth and Treachery: classOnly, startItem (Questie, foreverchanges, AAL)
		[7498] = {
			classOnly = "ROGUE",
			startItem = { itemID = 18356, name = "Garona: A Study on Stealth and Treachery", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- Codex of Defense: classOnly, startItem (Questie, foreverchanges, AAL)
		[7499] = {
			classOnly = "WARRIOR",
			startItem = { itemID = 18357, name = "Codex of Defense", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- The Arcanist's Cookbook: classOnly, startItem (Questie, foreverchanges, AAL)
		[7500] = {
			classOnly = "MAGE",
			startItem = { itemID = 18358, name = "The Arcanist's Cookbook", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- The Light and How To Swing It: classOnly, startItem (Questie, foreverchanges, AAL)
		[7501] = {
			classOnly = "PALADIN",
			startItem = { itemID = 18359, name = "The Light and How to Swing It", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- Harnessing Shadows: classOnly, startItem (Questie, foreverchanges, AAL)
		[7502] = {
			classOnly = "WARLOCK",
			startItem = { itemID = 18360, name = "Harnessing Shadows", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- The Greatest Race of Hunters: classOnly, startItem (Questie, foreverchanges, AAL)
		[7503] = {
			classOnly = "HUNTER",
			startItem = { itemID = 18361, name = "The Greatest Race of Hunters", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- Holy Bologna: What the Light Won't Tell You: classOnly, startItem (Questie, foreverchanges, AAL)
		[7504] = {
			classOnly = "PRIEST",
			startItem = { itemID = 18362, name = "Holy Bologna: What the Light Won't Tell You", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- Frost Shock and You: classOnly, startItem (Questie, foreverchanges, AAL)
		[7505] = {
			classOnly = "SHAMAN",
			startItem = { itemID = 18363, name = "Frost Shock and You", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- The Emerald Dream...: classOnly, startItem (Questie, foreverchanges, AAL)
		[7506] = {
			classOnly = "DRUID",
			startItem = { itemID = 18364, name = "The Emerald Dream", note = "Found in A Dusty Tome inside Dire Maul." },
		},
		-- Foror's Compendium: name, startItem, objective (Questie, foreverchanges)
		[7507] = {
			name = "Nostro's Compendium",
			startItem = { itemID = 18401, name = "Nostro's Compendium of Dragon Slaying", note = "Found in A Dusty Tome inside Dire Maul." },
			objective = "Return Nostro's Compendium of Dragon Slaying to the Athenaeum.",
		},
		-- The Forging of Quel'Serrar: startItem, prerequisites (Questie, foreverchanges)
		[7508] = {
			startItem = { itemID = 18513, name = "A Dull and Flat Elven Blade" },
			prerequisites = { { questID = 7507, name = "Nostro's Compendium" } },
		},
		-- The Forging of Quel'Serrar: pickup, prerequisites (Questie, foreverchanges)
		[7509] = {
			pickup = "Lorekeeper Lydros, inside the dungeon",
			prerequisites = { { questID = 7507, name = "Nostro's Compendium" }, { questID = 7508, name = "The Forging of Quel'Serrar" } },
		},
		-- The Treasure of the Shen'dralar: faction, prerequisites (Questie, foreverchanges, AAL)
		[7877] = {
			faction = "Both",
			prerequisites = { { questID = 7461, name = "The Madness Within" } },
		},
		-- Anthion's Old Friend: startMap, prerequisites (Questie, foreverchanges)
		[8948] = {
			startMap = { mapID = 1423, x = 0.261, y = 0.113, label = "Anthion Harmon" },
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
			},
		},
		-- Falrin's Vendetta: pickup, prerequisites (Questie, foreverchanges)
		[8949] = {
			pickup = "Falrin Treeshaper, inside the dungeon",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
			},
		},
		-- The Instigator's Enchantment: pickup, prerequisites (Questie, foreverchanges)
		[8950] = {
			pickup = "Falrin Treeshaper, inside the dungeon",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
			},
		},
		-- The Left Piece of Lord Valthalak's Amulet: prerequisites (Questie, foreverchanges)
		[8967] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
			},
		},
		-- The Right Piece of Lord Valthalak's Amulet: prerequisites (Questie, foreverchanges)
		[8990] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
			},
		},
	},
	remove = {
		1318, -- Unfinished Gordok Business: a duplicate of Unfinished Gordok Business (7703), not in the game
		7462, -- The Treasure of the Shen'dralar: a duplicate of The Treasure of the Shen'dralar (7877), which both sides take
	},
})

Audit("Scholomance", {
	add = {
		-- Imp Delivery (Questie)
		{
			questID = 7629, name = "Imp Delivery", level = 60, requiredLevel = 60, faction = "Both", classOnly = "WARLOCK",
			pickup = "Gorzeeki Wildeyes, Burning Steppes", turnin = "Gorzeeki Wildeyes, Burning Steppes",
			startMap = { mapID = 1428, x = 0.124, y = 0.316, label = "Gorzeeki Wildeyes" },
			endMap = { mapID = 1428, x = 0.124, y = 0.316, label = "Gorzeeki Wildeyes" },
			objective = "Take the Imp in a Jar to the alchemy lab in Scholomance, then bring the jar back to Gorzeeki Wildeyes.",
			note = "A step of the warlock's Dreadsteed quests.",
			prerequisites = {
				{ questID = 7623, name = "Lord Banehollow" },
				{ questID = 7624, name = "Ulathek the Traitor" },
				{ questID = 7625, name = "Xorothian Stardust" },
			},
		},
		-- Judgment and Redemption (Questie)
		{
			questID = 7647, name = "Judgment and Redemption", level = 60, requiredLevel = 60, faction = "Alliance", classOnly = "PALADIN",
			pickup = "Lord Grayson Shadowbreaker, Stormwind City", turnin = "Darkreaver's Fallen Charger, inside the dungeon",
			startMap = { mapID = 1453, x = 0.484, y = 0.502, label = "Lord Grayson Shadowbreaker" },
			objective = "Use the Divination Scryer in the Great Ossuary's basement, defeat the spirits it calls and Death Knight Darkreaver, then give the Charger's Redeemed Soul and the Blessed Enchanted Barding to Darkreaver's Fallen Charger.",
			note = "The last step of the paladin's charger quests.",
			prerequisites = {
				{ questID = 7638, name = "Lord Grayson Shadowbreaker" },
				{ questID = 7637, name = "Emphasis on Sacrifice" },
				{ questID = 7639, name = "To Show Due Judgment" },
				{ questID = 7640, name = "Exorcising Terrordale" },
				{ questID = 7641, name = "The Work of Grimand Elmore" },
				{ questID = 7642, name = "Collection of Goods" },
				{ questID = 7643, name = "Ancient Equine Spirit" },
				{ questID = 7644, name = "Blessed Arcanite Barding" },
				{ questID = 7646, name = "The Divination Scryer" },
			},
		},
		-- The Darkreaver Menace (Questie)
		{
			questID = 8258, name = "The Darkreaver Menace", level = 60, requiredLevel = 60, faction = "Horde", classOnly = "SHAMAN",
			pickup = "Sagorne Creststrider, Valley of Wisdom, Orgrimmar", turnin = "Sagorne Creststrider, Valley of Wisdom, Orgrimmar",
			startMap = { mapID = 1454, x = 0.387, y = 0.359, label = "Sagorne Creststrider" },
			endMap = { mapID = 1454, x = 0.387, y = 0.359, label = "Sagorne Creststrider" },
			objective = "Use the Divination Scryer in the Great Ossuary's basement, defeat the spirits it calls and Death Knight Darkreaver, and bring Darkreaver's Head to Sagorne Creststrider.",
			prerequisites = { { questID = 7667, name = "Material Assistance" } },
		},
	},
	patches = {
		-- Dawn's Gambit: prerequisites (Questie, foreverchanges)
		[4771] = {
			prerequisites = {
				{ questID = 4726, name = "Broodling Essence" },
				{ questID = 4808, name = "Felnok Steelspring" },
				{ questID = 4809, name = "Chillwind Horns" },
				{ questID = 4810, name = "Return to Tinkee" },
				{ questID = 4734, name = "Egg Freezing" },
				{ questID = 4735, name = "Egg Collection" },
				{ questID = 5522, name = "Leonid Barthalomew" },
				{ questID = 5531, name = "Betina Bigglezink" },
			},
		},
		-- Kirtonos the Herald: prerequisites (Questie, foreverchanges)
		[5384] = {
			prerequisites = { { questID = 5382, name = "Doctor Theolen Krastinov, the Butcher" }, { questID = 5515, name = "Krastinov's Bag of Horrors" } },
		},
		-- The Lich, Ras Frostwhisper: prerequisites (Questie, foreverchanges)
		[5466] = {
			prerequisites = {
				{ questID = 5382, name = "Doctor Theolen Krastinov, the Butcher" },
				{ questID = 5515, name = "Krastinov's Bag of Horrors" },
				{ questID = 5384, name = "Kirtonos the Herald" },
				{ questID = 5461, name = "The Human, Ras Frostwhisper" },
				{ questID = 5462, name = "The Dying, Ras Frostwhisper" },
				{ questID = 5463, name = "Menethil's Gift" },
				{ questID = 5464, name = "Menethil's Gift" },
				{ questID = 5465, name = "Soulbound Keepsake" },
			},
		},
		-- Betina Bigglezink: prerequisites (Questie, foreverchanges)
		[5531] = {
			prerequisites = {
				{ questID = 4726, name = "Broodling Essence" },
				{ questID = 4808, name = "Felnok Steelspring" },
				{ questID = 4809, name = "Chillwind Horns" },
				{ questID = 4810, name = "Return to Tinkee" },
				{ questID = 4734, name = "Egg Freezing" },
				{ questID = 4735, name = "Egg Collection" },
				{ questID = 5522, name = "Leonid Barthalomew" },
			},
		},
		-- Healthy Dragon Scale: startItem (Questie)
		[5582] = {
			startItem = { itemID = 13920, name = "Healthy Dragon Scale", note = "Drops from Plagued Hatchlings inside Scholomance." },
		},
		-- The Left Piece of Lord Valthalak's Amulet: prerequisites (Questie, foreverchanges)
		[8969] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8965, name = "Components of Importance" },
			},
		},
		-- The Right Piece of Lord Valthalak's Amulet: prerequisites (Questie, foreverchanges)
		[8992] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
				{ questID = 8988, name = "More Components of Importance" },
			},
		},
	},
})

Audit("StratholmeMainGate", {
	add = {
		-- Sweet Serenity (Questie)
		{
			questID = 5305, name = "Sweet Serenity", level = 60, requiredLevel = 50, faction = "Both",
			pickup = "Lilith the Lithe, Everlook, Winterspring", turnin = "Lilith the Lithe, Everlook, Winterspring",
			startMap = { mapID = 1452, x = 0.613, y = 0.371 }, endMap = { mapID = 1452, x = 0.613, y = 0.371 },
			objective = "Travel to Stratholme and kill the Crimson Hammersmith. Recover the Crimson Hammersmith's Apron and return to Lilith.",
			note = "For blacksmiths with a skill of 250.",
			prerequisites = {},
		},
		-- Menethil's Gift (Questie, foreverchanges)
		{
			questID = 5464, name = "Menethil's Gift", level = 60, requiredLevel = 57, faction = "Both",
			pickup = "Menethil's Gift, inside Stratholme", turnin = "Leonid Barthalomew the Revered, Eastern Plaguelands",
			endMap = { mapID = 1423, x = 0.719, y = 0.483 },
			startObject = { name = "Menethil's Gift", note = "Inside Stratholme, where the Keepsake of Remembrance is placed." },
			objective = "Take the Soulbound Keepsake to Leonid Barthalomew in Eastern Plaguelands.",
			prerequisites = { { questID = 5382, name = "Doctor Theolen Krastinov, the Butcher" }, { questID = 5515, name = "Krastinov's Bag of Horrors" }, { questID = 5384, name = "Kirtonos the Herald" }, { questID = 5461, name = "The Human, Ras Frostwhisper" }, { questID = 5462, name = "The Dying, Ras Frostwhisper" }, { questID = 5463, name = "Menethil's Gift" } },
		},
	},
	patches = {
		-- Aurius' Reckoning: pickup, turnin (Questie, foreverchanges, AAL)
		[5125] = {
			pickup = "Aurius, inside Stratholme",
			turnin = "Aurius, inside Stratholme",
		},
		-- The Truth Comes Crashing Down: pickup, startItem (Questie, foreverchanges)
		[5262] = {
			pickup = "Head of Balnazzar, dropped by Balnazzar inside Stratholme",
			startItem = { itemID = 13250, name = "Head of Balnazzar", note = "Drops from Balnazzar inside Stratholme." },
		},
		-- Menethil's Gift: turnin, prerequisites (Questie, foreverchanges)
		[5463] = {
			turnin = "Menethil's Gift, inside Stratholme",
			prerequisites = {
				{ questID = 5382, name = "Doctor Theolen Krastinov, the Butcher" },
				{ questID = 5515, name = "Krastinov's Bag of Horrors" },
				{ questID = 5384, name = "Kirtonos the Herald" },
				{ questID = 5461, name = "The Human, Ras Frostwhisper" },
				{ questID = 5462, name = "The Dying, Ras Frostwhisper" },
			},
		},
		-- Of Love and Family: prerequisites (Questie, foreverchanges)
		[5848] = {
			prerequisites = {
				{ questID = 5542, name = "Demon Dogs" },
				{ questID = 5543, name = "Blood Tinged Skies" },
				{ questID = 5544, name = "Carrion Grubbage" },
				{ questID = 5742, name = "Redemption" },
				{ questID = 5781, name = "Of Forgotten Memories" },
				{ questID = 5845, name = "Of Lost Honor" },
				{ questID = 5846, name = "Of Love and Family" },
			},
		},
		-- Dead Man's Plea: prerequisites (Questie, foreverchanges)
		[8945] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
			},
		},
	},
})

Audit("StratholmeServiceGate", {
	add = {
		-- Menethil's Gift (Questie, foreverchanges)
		{
			questID = 5464, name = "Menethil's Gift", level = 60, requiredLevel = 57, faction = "Both",
			pickup = "Menethil's Gift, inside Stratholme", turnin = "Leonid Barthalomew the Revered, Eastern Plaguelands",
			endMap = { mapID = 1423, x = 0.719, y = 0.483 },
			startObject = { name = "Menethil's Gift", note = "Inside Stratholme, where the Keepsake of Remembrance is placed." },
			objective = "Take the Soulbound Keepsake to Leonid Barthalomew in Eastern Plaguelands.",
			prerequisites = { { questID = 5382, name = "Doctor Theolen Krastinov, the Butcher" }, { questID = 5515, name = "Krastinov's Bag of Horrors" }, { questID = 5384, name = "Kirtonos the Herald" }, { questID = 5461, name = "The Human, Ras Frostwhisper" }, { questID = 5462, name = "The Dying, Ras Frostwhisper" }, { questID = 5463, name = "Menethil's Gift" } },
		},
		-- Proof of Life (Questie, foreverchanges)
		{
			questID = 8946, name = "Proof of Life", level = 60, requiredLevel = 58, faction = "Both",
			pickup = "Ysida Harmon, inside the dungeon",
			turnin = "Anthion Harmon, Eastern Plaguelands",
			endMap = { mapID = 1423, x = 0.261, y = 0.113 },
			objective = "Bring Ysida's Locket to Anthion Harmon in the Eastern Plaguelands.",
			prerequisites = { { questID = 8921, name = "The Ectoplasmic Distiller" }, { questID = 8924, name = "Hunting for Ectoplasm" }, { questID = 8925, name = "A Portable Power Source" }, { questID = 8928, name = "A Shifty Merchant" }, { questID = 8945, name = "Dead Man's Plea" } },
		},
	},
	patches = {
		-- Aurius' Reckoning: pickup, turnin (Questie, foreverchanges, AAL)
		[5125] = {
			pickup = "Aurius, inside Stratholme",
			turnin = "Aurius, inside Stratholme",
		},
		-- Above and Beyond: prerequisites (Questie, foreverchanges)
		[5263] = {
			prerequisites = { { questID = 5251, name = "The Archivist" }, { questID = 5262, name = "The Truth Comes Crashing Down" } },
		},
		-- The Argent Hold: prerequisites (Questie, foreverchanges)
		[5265] = {
			prerequisites = {
				{ questID = 5251, name = "The Archivist" },
				{ questID = 5262, name = "The Truth Comes Crashing Down" },
				{ questID = 5263, name = "Above and Beyond" },
				{ questID = 5264, name = "Lord Maxwell Tyrosus" },
			},
		},
		-- Menethil's Gift: turnin, prerequisites (Questie, foreverchanges)
		[5463] = {
			turnin = "Menethil's Gift, inside the dungeon",
			prerequisites = {
				{ questID = 5382, name = "Doctor Theolen Krastinov, the Butcher" },
				{ questID = 5515, name = "Krastinov's Bag of Horrors" },
				{ questID = 5384, name = "Kirtonos the Herald" },
				{ questID = 5461, name = "The Human, Ras Frostwhisper" },
				{ questID = 5462, name = "The Dying, Ras Frostwhisper" },
			},
		},
		-- Of Love and Family: prerequisites (Questie, foreverchanges)
		[5848] = {
			prerequisites = {
				{ questID = 5542, name = "Demon Dogs" },
				{ questID = 5543, name = "Blood Tinged Skies" },
				{ questID = 5544, name = "Carrion Grubbage" },
				{ questID = 5742, name = "Redemption" },
				{ questID = 5781, name = "Of Forgotten Memories" },
				{ questID = 5845, name = "Of Lost Honor" },
				{ questID = 5846, name = "Of Love and Family" },
			},
		},
		-- Ramstein: prerequisites (Questie, foreverchanges)
		[6163] = {
			prerequisites = {
				{ questID = 6022, name = "To Kill With Purpose" },
				{ questID = 6042, name = "Un-Life's Little Annoyances" },
				{ questID = 6133, name = "The Ranger Lord's Behest" },
				{ questID = 6135, name = "Duskwing, Oh How I Hate Thee..." },
				{ questID = 6136, name = "The Corpulent One" },
			},
		},
		-- Dead Man's Plea: prerequisites (Questie, foreverchanges)
		[8945] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
			},
		},
	},
})

Audit("UpperBlackrockSpire", {
	add = {
		-- Eye of the Emberseer (Questie)
		{
			questID = 6821, name = "Eye of the Emberseer", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Duke Hydraxis, Azshara",
			turnin = "Duke Hydraxis, Azshara",
			startMap = { mapID = 1447, x = 0.793, y = 0.737 }, endMap = { mapID = 1447, x = 0.793, y = 0.737 },
			objective = "Slay Pyroguard Emberseer in Upper Blackrock Spire and bring his eye to Duke Hydraxis in Azshara.",
			prerequisites = { { questID = 6804, name = "Poisoned Water" }, { questID = 6805, name = "Stormers and Rumblers" } },
		},
		-- Three Kings of Flame (Questie, foreverchanges)
		{
			questID = 8961, name = "Three Kings of Flame", level = 60, requiredLevel = 58, faction = "Both",
			pickup = "Bodley, Burning Steppes",
			turnin = "Bodley, Burning Steppes",
			startMap = { mapID = 1428, x = 0.323, y = 0.258 }, endMap = { mapID = 1428, x = 0.323, y = 0.258 },
			objective = "Bring Bodley the Incendicite of Incendius (Lord Incendius, Blackrock Depths), the Ember of Emberseer (Pyroguard Emberseer, Upper Blackrock Spire) and the Cinder of Cynders (the Duke of Cynders, Silithus), with a Hallowed Brazier.",
			note = "Also needs your side's Bodley's Unfortunate Fate, after your class's Anthion's Parting Words.",
			prerequisites = { { questID = 8921, name = "The Ectoplasmic Distiller" }, { questID = 8924, name = "Hunting for Ectoplasm" }, { questID = 8925, name = "A Portable Power Source" }, { questID = 8928, name = "A Shifty Merchant" }, { questID = 8945, name = "Dead Man's Plea" }, { questID = 8946, name = "Proof of Life" }, { questID = 8947, name = "Anthion's Strange Request" }, { questID = 8948, name = "Anthion's Old Friend" }, { questID = 8949, name = "Falrin's Vendetta" }, { questID = 8950, name = "The Instigator's Enchantment" }, { questID = 9015, name = "The Challenge" } },
		},
		-- Final Preparations (Questie, foreverchanges)
		{
			questID = 8994, name = "Final Preparations", level = 60, requiredLevel = 58, faction = "Both",
			pickup = "Bodley, Burning Steppes",
			turnin = "Bodley, Burning Steppes",
			startMap = { mapID = 1428, x = 0.323, y = 0.258 }, endMap = { mapID = 1428, x = 0.323, y = 0.258 },
			objective = "Bring Bodley 40 Blackrock Bracers, taken from the orcs of Blackrock Spire, and a Flask of Supreme Power.",
			note = "Offered once one of the four Right Piece of Lord Valthalak's Amulet quests is done.",
			prerequisites = { { questID = 8921, name = "The Ectoplasmic Distiller" }, { questID = 8924, name = "Hunting for Ectoplasm" }, { questID = 8925, name = "A Portable Power Source" }, { questID = 8928, name = "A Shifty Merchant" }, { questID = 8945, name = "Dead Man's Plea" }, { questID = 8946, name = "Proof of Life" }, { questID = 8947, name = "Anthion's Strange Request" }, { questID = 8948, name = "Anthion's Old Friend" }, { questID = 8949, name = "Falrin's Vendetta" }, { questID = 8950, name = "The Instigator's Enchantment" }, { questID = 9015, name = "The Challenge" }, { questID = 8961, name = "Three Kings of Flame" }, { questID = 8970, name = "I See Alcaz Island In Your Future..." } },
		},
	},
	patches = {
		-- Egg Freezing: prerequisites (Questie, foreverchanges)
		[4734] = {
			prerequisites = {
				{ questID = 4726, name = "Broodling Essence" },
				{ questID = 4808, name = "Felnok Steelspring" },
				{ questID = 4809, name = "Chillwind Horns" },
				{ questID = 4810, name = "Return to Tinkee" },
			},
		},
		-- Egg Collection: prerequisites (Questie, foreverchanges)
		[4735] = {
			prerequisites = {
				{ questID = 4726, name = "Broodling Essence" },
				{ questID = 4808, name = "Felnok Steelspring" },
				{ questID = 4809, name = "Chillwind Horns" },
				{ questID = 4810, name = "Return to Tinkee" },
				{ questID = 4734, name = "Egg Freezing" },
			},
		},
		-- Seal of Ascension: pickup, turnin (Questie, foreverchanges, AAL)
		[4743] = {
			pickup = "Vaelan (a Scarshield Infiltrator), inside Lower Blackrock Spire",
			turnin = "Vaelan (a Scarshield Infiltrator), inside Lower Blackrock Spire",
		},
		-- Doomrigger's Clasp: prerequisites (Questie, foreverchanges)
		[4764] = {
			prerequisites = {},
		},
		-- The Darkstone Tablet: prerequisites (Questie, foreverchanges)
		[4768] = {
			prerequisites = {},
		},
		-- The Final Tablets: prerequisites (Questie, foreverchanges)
		[4788] = {
			prerequisites = {
				{ questID = 3520, name = "Screecher Spirits" },
				{ questID = 3527, name = "The Prophecy of Mosh'aru" },
				{ questID = 4787, name = "The Ancient Egg" },
				{ questID = 3528, name = "The God Hakkar" },
				{ questID = 5065, name = "The Lost Tablets of Mosh'aru" },
			},
		},
		-- Tinkee Steamboil: prerequisites (Questie, foreverchanges)
		[4907] = {
			prerequisites = {
				{ questID = 4726, name = "Broodling Essence" },
				{ questID = 4808, name = "Felnok Steelspring" },
				{ questID = 4809, name = "Chillwind Horns" },
				{ questID = 4810, name = "Return to Tinkee" },
			},
		},
		-- For The Horde!: prerequisites (Questie, foreverchanges)
		[4974] = {
			prerequisites = { { questID = 4903, name = "Warlord's Command" }, { questID = 4941, name = "Eitrigg's Wisdom" } },
		},
		-- Bijou's Belongings: prerequisites (Questie, foreverchanges)
		[4982] = {
			prerequisites = { { questID = 4981, name = "Operative Bijou" } },
		},
		-- Bijou's Reconnaissance Report: pickup, prerequisites (Questie, foreverchanges, AAL)
		[4983] = {
			pickup = "Bijou, inside Lower Blackrock Spire",
			prerequisites = { { questID = 4981, name = "Operative Bijou" }, { questID = 4982, name = "Bijou's Belongings" } },
		},
		-- Bijou's Belongings: pickup, turnin (Questie, foreverchanges)
		[5001] = {
			pickup = "Bijou, inside Lower Blackrock Spire",
			turnin = "Bijou, inside Lower Blackrock Spire",
		},
		-- Message to Maxwell: pickup (Questie, foreverchanges)
		[5002] = {
			pickup = "Bijou, inside Lower Blackrock Spire",
		},
		-- Finkle Einhorn, At Your Service!: pickup (Questie, foreverchanges)
		[5047] = {
			pickup = "Finkle Einhorn, inside the dungeon",
		},
		-- The Matron Protectorate: pickup (Questie, foreverchanges)
		[5160] = {
			pickup = "Awbee, inside the dungeon",
		},
		-- Drakefire Amulet: prerequisites (Questie, foreverchanges)
		[6502] = {
			prerequisites = {
				{ questID = 4182, name = "Dragonkin Menace" },
				{ questID = 4183, name = "The True Masters" },
				{ questID = 4184, name = "The True Masters" },
				{ questID = 4185, name = "The True Masters" },
				{ questID = 4186, name = "The True Masters" },
				{ questID = 4223, name = "The True Masters" },
				{ questID = 4224, name = "The True Masters" },
				{ questID = 4241, name = "Marshal Windsor" },
				{ questID = 4242, name = "Abandoned Hope" },
				{ questID = 4264, name = "A Crumpled Up Note" },
				{ questID = 4282, name = "A Shred of Hope" },
				{ questID = 4322, name = "Jail Break!" },
				{ questID = 6402, name = "Stormwind Rendezvous" },
				{ questID = 6403, name = "The Great Masquerade" },
				{ questID = 6501, name = "The Dragon's Eye" },
			},
		},
		-- Blood of the Black Dragon Champion: prerequisites (Questie, foreverchanges)
		[6602] = {
			prerequisites = {
				{ questID = 4903, name = "Warlord's Command" },
				{ questID = 4941, name = "Eitrigg's Wisdom" },
				{ questID = 4974, name = "For The Horde!" },
				{ questID = 6566, name = "What the Wind Carries" },
				{ questID = 6567, name = "The Champion of the Horde" },
				{ questID = 6568, name = "The Testament of Rexxar" },
				{ questID = 6569, name = "Oculus Illusions" },
				{ questID = 6570, name = "Emberstrife" },
				{ questID = 6582, name = "The Test of Skulls, Scryer" },
				{ questID = 6583, name = "The Test of Skulls, Somnus" },
				{ questID = 6584, name = "The Test of Skulls, Chronalis" },
				{ questID = 6585, name = "The Test of Skulls, Axtroz" },
				{ questID = 6601, name = "Ascension..." },
			},
		},
		-- Blackhand's Command: pickup, startItem, note (Questie, foreverchanges)
		[7761] = {
			pickup = "Blackhand's Command, dropped by the Scarshield Quartermaster in Blackrock Mountain",
			startItem = { itemID = 18987, name = "Blackhand's Command", note = "Dropped by the Scarshield Quartermaster in Blackrock Mountain, outside the Spire." },
			note = "Starts from Blackhand's Command, a letter the Scarshield Quartermaster drops in Blackrock Mountain, outside the Spire.",
		},
		-- Confront Yeh'kinya: prerequisites (Questie, foreverchanges)
		[8181] = {
			prerequisites = {
				{ questID = 3520, name = "Screecher Spirits" },
				{ questID = 3527, name = "The Prophecy of Mosh'aru" },
				{ questID = 4787, name = "The Ancient Egg" },
				{ questID = 3528, name = "The God Hakkar" },
				{ questID = 5065, name = "The Lost Tablets of Mosh'aru" },
				{ questID = 4788, name = "The Final Tablets" },
			},
		},
		-- The Right Piece of Lord Valthalak's Amulet: prerequisites (Questie, foreverchanges)
		[8989] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
			},
		},
		-- Mea Culpa, Lord Valthalak: prerequisites (Questie, foreverchanges)
		[8995] = {
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
				{ questID = 8994, name = "Final Preparations" },
			},
		},
		-- Return to Bodley: pickup, prerequisites (Questie, foreverchanges)
		[8996] = {
			pickup = "Spirit of Lord Valthalak, inside the dungeon",
			prerequisites = {
				{ questID = 8921, name = "The Ectoplasmic Distiller" },
				{ questID = 8924, name = "Hunting for Ectoplasm" },
				{ questID = 8925, name = "A Portable Power Source" },
				{ questID = 8928, name = "A Shifty Merchant" },
				{ questID = 8945, name = "Dead Man's Plea" },
				{ questID = 8946, name = "Proof of Life" },
				{ questID = 8947, name = "Anthion's Strange Request" },
				{ questID = 8948, name = "Anthion's Old Friend" },
				{ questID = 8949, name = "Falrin's Vendetta" },
				{ questID = 8950, name = "The Instigator's Enchantment" },
				{ questID = 9015, name = "The Challenge" },
				{ questID = 8961, name = "Three Kings of Flame" },
				{ questID = 8970, name = "I See Alcaz Island In Your Future..." },
				{ questID = 8994, name = "Final Preparations" },
				{ questID = 8995, name = "Mea Culpa, Lord Valthalak" },
			},
		},
	},
})
