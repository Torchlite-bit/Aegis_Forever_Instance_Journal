-- Scarlet Monastery: Library: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "ScarletMonasteryLibrary",
	instanceID = 189,
	kind = "dungeon",
	name = "Scarlet Monastery: Library",
	levelMin = 33,
	levelMax = 41,
	location = "Tirisfal Glades",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenScarletMonastery" },
	buttonImage = {
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-ScarletHalls",
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-ScarletMonastery",
	},
	loreImage = {
		"Interface\\EncounterJournal\\UI-EJ-LOREBG-ScarletHalls",
		"Interface\\EncounterJournal\\UI-EJ-LOREBG-ScarletMonastery",
	},
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		floors = {
			{
				uiMapID = 303,
				tiles = "Interface\\WorldMap\\ScarletMonastery\\ScarletMonastery2_",
			},
		},
	},
	zoneEntrance = {
		mapID = 1420,
		x = 0.826,
		y = 0.338,
	},
	bosses = {
		{
			name = "Houndmaster Loksey",
			npcID = 3974,
			level = 34,
			description = "In the Huntsman's Cloister.",
			displayID = 2040,
			loot = {
				{
					itemID = 7756,
					name = "Dog Training Gloves",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 3456,
					name = "Dog Whistle",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 7710,
					name = "Loksey's Training Stick",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.302,
				y = 0.846,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Arcanist Doan",
			npcID = 6487,
			level = 37,
			description = "The last boss, in the Athenaeum. The Scarlet Key is in Doan's Strongbox behind him.",
			displayID = 5266,
			loot = {
				{
					itemID = 7714,
					name = "Hypnotic Blade",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 7713,
					name = "Illusionary Rod",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 274293,
					name = "Spellsever Crossbow",
					slot = "Ranged, Crossbow",
					quality = 3,
				},
				{
					itemID = 7712,
					name = "Mantle of Doan",
					slot = "Shoulder, Cloth",
					quality = 2,
				},
				{
					itemID = 7711,
					name = "Robe of Doan",
					slot = "Chest, Cloth",
					quality = 2,
				},
				{
					itemID = 7146,
					name = "The Scarlet Key",
					slot = "Key",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.835,
				y = 0.74,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 10332,
					name = "Scarlet Boots",
					slot = "Feet, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (Chain of the Scarlet Crusade)",
				},
				{
					itemID = 5819,
					name = "Sunblaze Coif",
					slot = "Head, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7730,
					name = "Cobalt Crusher",
					slot = "Two-Hand, Mace",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7757,
					name = "Windweaver Staff",
					slot = "Two-Hand, Staff",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7761,
					name = "Steelclaw Reaver",
					slot = "Main Hand, Axe",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7787,
					name = "Resplendent Guardian",
					slot = "Off Hand, Shield",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7755,
				},
				{
					itemID = 7727,
				},
				{
					itemID = 7728,
				},
				{
					itemID = 7759,
				},
				{
					itemID = 7760,
				},
				{
					itemID = 7754,
				},
				{
					itemID = 1992,
				},
				{
					itemID = 2262,
				},
				{
					itemID = 7729,
				},
				{
					itemID = 7752,
				},
				{
					itemID = 8226,
				},
				{
					itemID = 7786,
				},
				{
					itemID = 5756,
				},
				{
					itemID = 7736,
				},
				{
					itemID = 8225,
				},
				{
					itemID = 7753,
				},
				{
					itemID = 7758,
				},
			},
		},
	},
	quests = {
		{
			questID = 1050,
			name = "Mythology of the Titans",
			level = 38,
			requiredLevel = 28,
			faction = "Alliance",
			startMap = {
				mapID = 1455,
				x = 0.744,
				y = 0.128,
				label = "Librarian Mae Paledust — Hall of Explorers",
			},
			objective = "Retrieve Mythology of the Titans from the Monastery and bring it to Librarian Mae Paledust in Ironforge.",
			pickup = "Librarian Mae Paledust, Ironforge",
			turnin = "Librarian Mae Paledust, Ironforge",
			rewards = {
				xp = 3550,
				items = {
					{
						itemID = 7746,
						name = "Explorers' League Commendation",
						quality = 2,
					},
				},
			},
		},
		{
			questID = 96800,
			name = "Past Due",
			level = 38,
			requiredLevel = 30,
			faction = "Alliance",
			startMap = {
				mapID = 1416,
				x = 0.097,
				y = 0.619,
				label = "Magus Olvek — Dalaran",
			},
			objective = "Retrieve The Lost Magic of the Runemasters from the Scarlet Monastery.",
			pickup = "Magus Olvek, Dalaran, Alterac Mountains",
			turnin = "Magus Olvek, Dalaran, Alterac Mountains",
			note = "New in Forever: Arcanist Doan has the book.",
			rewards = {
				xp = 6750,
				money = 4500,
				items = {
					{
						itemID = 276898,
						name = "Salve and Salvation",
						quality = 3,
					},
					{
						itemID = 276899,
						name = "Knucklebound Thimble",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1049,
			name = "Compendium of the Fallen",
			level = 38,
			requiredLevel = 28,
			faction = "Horde",
			startMap = {
				mapID = 1456,
				x = 0.346,
				y = 0.476,
				label = "Sage Truthseeker — Thunder Bluff",
			},
			objective = "Retrieve the Compendium of the Fallen from the Monastery and return to Sage Truthseeker in Thunder Bluff.",
			pickup = "Sage Truthseeker, Thunder Bluff",
			turnin = "Sage Truthseeker, Thunder Bluff",
			rewards = {
				xp = 3550,
				items = {
					{
						itemID = 7747,
						name = "Vile Protector",
						quality = 3,
					},
					{
						itemID = 17508,
						name = "Forcestone Buckler",
						quality = 3,
					},
					{
						itemID = 7749,
						name = "Omega Orb",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1394,
			name = "Final Passage",
			level = 36,
			requiredLevel = 25,
			faction = "Horde",
			objective = "Speak to Dorn Plainstalker in Thousand Needles.",
			pickup = "Parqual Fintallas, Undercity",
			turnin = "Dorn Plainstalker, Thousand Needles",
			rewards = {
				xp = 4200,
				items = {
					{
						itemID = 6804,
						name = "Windstorm Hammer",
						quality = 3,
					},
					{
						itemID = 6806,
						name = "Dancing Flame",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1113,
			name = "Hearts of Zeal",
			level = 33,
			requiredLevel = 30,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.48,
				y = 0.69,
				label = "Master Apothecary Faranell — Apothecarium",
			},
			objective = "Bring 20 Hearts of Zeal from the Scarlet Monastery to Master Apothecary Faranell.",
			pickup = "Master Apothecary Faranell, Undercity",
			turnin = "Master Apothecary Faranell, Undercity",
			rewards = {
				xp = 3300,
			},
			prerequisites = {
				{
					questID = 1109,
					name = "Going, Going, Guano!",
				},
			},
		},
	},
})
