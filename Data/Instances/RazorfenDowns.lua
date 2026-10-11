-- Razorfen Downs: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "RazorfenDowns",
	instanceID = 129,
	kind = "dungeon",
	name = "Razorfen Downs",
	levelMin = 37,
	levelMax = 46,
	location = "The Barrens",
	description = "In the thorny barrows of the southern Barrens the Scourge has struck a pact with the quilboar: Amnennar the Coldbringer rules the Razorfen's burial grounds.",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenRazorfenDowns" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-RazorfenDowns" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-RazorfenDowns" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1413,
		world = { 1, -4716.7, -2450 },
	},
	map = {
		entrance = {
			x = 0.235,
			y = 0.19,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\RazorfenDowns",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 300,
			},
		},
	},
	bosses = {
		{
			name = "Tuten'kash",
			displayID = 7845,
			level = 40,
			order = 1,
			loot = {
				{
					itemID = 10776,
					name = "Silky Spider Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 10775,
					name = "Carapace of Tuten'kash",
					slot = "Chest, Plate",
					quality = 3,
				},
				{
					itemID = 10777,
					name = "Arachnid Gloves",
					slot = "Hands, Leather",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.591,
				y = 0.338,
				floor = 1,
			},
		},
		{
			name = "Glutton",
			displayID = 7864,
			level = 40,
			order = 2,
			loot = {
				{
					itemID = 10774,
					name = "Fleshhide Shoulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 10772,
					name = "Glutton's Cleaver",
					slot = "One-Hand, Axe",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.347,
				y = 0.665,
				floor = 1,
			},
		},
		{
			name = "Amnennar the Coldbringer",
			displayID = 7971,
			level = 41,
			order = 3,
			loot = {
				{
					itemID = 10763,
					name = "Icemetal Barbute",
					slot = "Head, Plate",
					quality = 3,
				},
				{
					itemID = 10762,
					name = "Robes of the Lich",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 10764,
					name = "Deathchill Armor",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 10761,
					name = "Coldrage Dagger",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 10765,
					name = "Bonefingers",
					slot = "Hands, Leather",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.444,
				y = 0.602,
				floor = 1,
			},
		},
		{
			name = "Mordresh Fire Eye",
			displayID = 8055,
			level = 39,
			order = 4,
			loot = {
				{
					itemID = 10769,
					name = "Glowing Eye of Mordresh",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 10771,
					name = "Deathmage Sash",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 10770,
					name = "Mordresh's Lifeless Skull",
					slot = "Held In Off-hand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.858,
				y = 0.47,
				floor = 1,
			},
		},
		{
			name = "Ragglesnout",
			displayID = 11382,
			level = 40,
			rare = true,
			order = 5,
			loot = {
				{
					itemID = 10768,
					name = "Boar Champion's Belt",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 10767,
					name = "Savage Boar's Guard",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 10758,
					name = "X'caliboar",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.505,
				y = 0.702,
				floor = 1,
			},
		},
		{
			name = "Plaguemaw the Rotting",
			displayID = 6124,
			level = 40,
			order = 6,
			loot = {
				{
					itemID = 10766,
					name = "Plaguerot Sprig",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 10760,
					name = "Swine Fists",
					slot = "Hands, Leather",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.559,
				y = 0.301,
				floor = 1,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 10574,
					name = "Corpseshroud",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 10581,
					name = "Death's Head Vestment",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 10583,
					name = "Quillward Harness",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 10584,
					name = "Stormgale Fists",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 10578,
					name = "Thoughtcast Boots",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 10582,
					name = "Briar Tredders",
					slot = "Feet, Leather",
					quality = 3,
				},
				{
					itemID = 10572,
					name = "Freezing Shard",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 10567,
					name = "Quillshooter",
					slot = "Ranged, Bow",
					quality = 3,
				},
				{
					itemID = 10571,
					name = "Ebony Boneclub",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 10570,
					name = "Manslayer",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 10573,
					name = "Boneslasher",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
			},
		},
	},
	quests = {
		{
			questID = 6626,
			name = "A Host of Evil",
			level = 35,
			requiredLevel = 28,
			faction = "Both",
			startMap = {
				mapID = 1413,
				x = 0.49,
				y = 0.949,
			},
			endMap = {
				mapID = 1413,
				x = 0.49,
				y = 0.949,
			},
			objective = "Kill 8 Razorfen Battleguard, 8 Razorfen Thornweavers, and 8 Death's Head Cultists and return to Myriam Moonsinger near the entrance to Razorfen Downs.",
			pickup = "Myriam Moonsinger, The Barrens",
			turnin = "Myriam Moonsinger, The Barrens",
			rewards = {
				xp = 3450,
				money = 7500,
			},
		},
		{
			questID = 3525,
			name = "Extinguishing the Idol",
			level = 37,
			requiredLevel = 32,
			faction = "Both",
			objective = "Escort Belnistrasz to the Quilboar's idol in Razorfen Downs.",
			rewards = {
				xp = 4250,
				items = {
					{
						itemID = 10710,
						name = "Dragonclaw Ring",
					},
				},
			},
			prerequisites = {
				{
					questID = 3523,
					name = "Scourge of the Downs",
				},
			},
		},
		{
			questID = 3523,
			name = "Scourge of the Downs",
			level = 37,
			requiredLevel = 32,
			faction = "Both",
			objective = "If you agree to aid Belnistrasz, speak with him again and hand the Oathstone he gave you back to him.",
			rewards = {
				xp = 290,
			},
		},
		{
			questID = 3636,
			name = "Bring the Light",
			level = 42,
			requiredLevel = 39,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.503,
				y = 0.455,
			},
			endMap = {
				mapID = 1453,
				x = 0.503,
				y = 0.455,
			},
			objective = "Archbishop Bendictus wants you to slay Amnennar the Coldbringer in Razorfen Downs.",
			pickup = "Archbishop Benedictus, Stormwind City",
			turnin = "Archbishop Benedictus, Stormwind City",
			rewards = {
				xp = 4300,
				items = {
					{
						itemID = 10823,
						name = "Vanquisher's Sword",
					},
					{
						itemID = 10824,
						name = "Amberglow Talisman",
					},
				},
			},
		},
		{
			questID = 6521,
			name = "An Unholy Alliance",
			level = 36,
			requiredLevel = 28,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.563,
				y = 0.922,
			},
			endMap = {
				mapID = 1458,
				x = 0.563,
				y = 0.922,
			},
			objective = "Bring Ambassador Malcin's Head to Varimathras in the Undercity.",
			pickup = "Varimathras, Undercity",
			turnin = "Varimathras, Undercity",
			rewards = {
				xp = 3500,
				money = 2000,
				items = {
					{
						itemID = 17039,
						name = "Skullbreaker",
					},
					{
						itemID = 17042,
						name = "Nail Spitter",
					},
					{
						itemID = 17043,
						name = "Zealot's Robe",
					},
					{
						itemID = 270054,
						name = "Cultist's Chestguard",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 6522,
					name = "An Unholy Alliance",
				},
			},
		},
		{
			questID = 6522,
			name = "An Unholy Alliance",
			level = 36,
			requiredLevel = 28,
			faction = "Horde",
			endMap = {
				mapID = 1458,
				x = 0.563,
				y = 0.922,
			},
			objective = "Take the Small Scroll to Varimathras in the Undercity.",
			turnin = "Varimathras, Undercity",
			rewards = {
				xp = 2800,
				money = 4000,
			},
			prerequisites = {
				{
					questID = 6521,
					name = "An Unholy Alliance",
				},
			},
		},
		{
			questID = 3341,
			name = "Bring the End",
			level = 42,
			requiredLevel = 37,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.74,
				y = 0.333,
			},
			endMap = {
				mapID = 1458,
				x = 0.74,
				y = 0.333,
			},
			objective = "Andrew Brownell wants you to kill Amnennar the Coldbringer and return his skull.",
			pickup = "Andrew Brownell, Undercity",
			turnin = "Andrew Brownell, Undercity",
			rewards = {
				xp = 4300,
				items = {
					{
						itemID = 10823,
						name = "Vanquisher's Sword",
					},
					{
						itemID = 10824,
						name = "Amberglow Talisman",
					},
				},
			},
		},
	},
})
