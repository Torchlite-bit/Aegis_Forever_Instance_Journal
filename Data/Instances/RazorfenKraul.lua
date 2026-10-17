-- Razorfen Kraul: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "RazorfenKraul",
	instanceID = 47,
	kind = "dungeon",
	name = "Razorfen Kraul",
	levelMin = 29,
	levelMax = 38,
	location = "The Barrens",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenRazorfenKraul" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-RazorfenKraul" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-RazorfenKraul" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.714,
			y = 0.84,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 301,
				tiles = "Interface\\WorldMap\\RazorfenKraul\\RazorfenKraul1_",
			},
		},
	},
	zoneEntrance = {
		mapID = 1413,
		x = 0.429,
		y = 0.902,
	},
	bosses = {
		{
			name = "Roogug",
			npcID = 6168,
			level = 28,
			description = "A quilboar geomancer close to the Kraul's entrance.",
			displayID = 6110,
			loot = {
				{
					itemID = 274155,
					name = "Geomancer Headdress",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 274149,
					name = "Thornweaver Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 274152,
					name = "Roogug's Severed Head",
					slot = "Trinket",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.646,
				y = 0.43,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Aggem Thorncurse",
			npcID = 4424,
			level = 30,
			displayID = 6097,
			loot = {
				{
					itemID = 6681,
					name = "Thornspike",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 274158,
					name = "Death Prophet Spine",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 274159,
					name = "Thorncursed Grips",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 252820,
					name = "Pattern: Brawler's Leather Legguards",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.808,
				y = 0.521,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Death Speaker Jargba",
			npcID = 4428,
			level = 30,
			displayID = 4644,
			loot = {
				{
					itemID = 2816,
					name = "Death Speaker Scepter",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 6685,
					name = "Death Speaker Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 6682,
					name = "Death Speaker Robes",
					slot = "Chest, Cloth",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.876,
				y = 0.419,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Overlord Ramtusk",
			npcID = 4420,
			level = 32,
			displayID = 4652,
			loot = {
				{
					itemID = 6687,
					name = "Corpsemaker",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 6686,
					name = "Tusken Helm",
					slot = "Head, Mail",
					quality = 3,
				},
				{
					itemID = 274161,
					name = "Quillord Mail Leggings",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 251379,
					name = "Plans: Crusader's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252821,
					name = "Pattern: Trapper's Leather Legguards",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.576,
				y = 0.313,
				floor = 1,
			},
			order = 4,
		},
		{
			name = "Agathelos the Raging",
			npcID = 4422,
			level = 33,
			displayID = 2450,
			loot = {
				{
					itemID = 6691,
					name = "Swinetusk Shank",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 6690,
					name = "Ferine Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 274160,
					name = "Quilrager Throwing Axe",
					slot = "Thrown",
					quality = 3,
				},
				{
					itemID = 251378,
					name = "Plans: Acolyte's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.082,
				y = 0.686,
				floor = 1,
			},
			order = 5,
		},
		{
			name = "Charlga Razorflank",
			npcID = 4421,
			level = 33,
			description = "The last boss, deep in the Kraul.",
			displayID = 4642,
			loot = {
				{
					itemID = 6693,
					name = "Agamaggan's Clutch",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 6694,
					name = "Heart of Agamaggan",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 6692,
					name = "Pronged Reaver",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 273103,
					name = "Blueprint: Arcane Salvager",
					slot = "Blueprint",
					quality = 2,
				},
				{
					itemID = 17008,
				},
			},
			mapPin = {
				x = 0.221,
				y = 0.313,
				floor = 1,
			},
			order = 6,
		},
		{
			name = "Blind Hunter",
			npcID = 4425,
			level = 32,
			description = "Sometimes found in the bat caves.",
			rare = true,
			displayID = 4735,
			loot = {
				{
					itemID = 6695,
					name = "Stygian Bone Amulet",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 6697,
					name = "Batwing Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 6696,
					name = "Nightstalker Bow",
					slot = "Ranged, Bow",
					quality = 3,
				},
			},
			order = 7,
		},
		{
			name = "Earthcaller Halmgar",
			npcID = 4842,
			level = 32,
			rare = true,
			displayID = 6102,
			loot = {
				{
					itemID = 6689,
					name = "Wind Spirit Staff",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 6688,
					name = "Whisperwind Headdress",
					slot = "Head, Leather",
					quality = 3,
				},
			},
			order = 8,
		},
		{
			name = "Razorfen Spearhide",
			npcID = 4438,
			displayID = 6078,
			loot = {
				{
					itemID = 6679,
				},
			},
			order = 9,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 776,
					name = "Vendetta",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 1727,
					name = "Sword of Decay",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 1975,
					name = "Pysan's Old Greatsword",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 1976,
					name = "Slaghammer",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 2549,
					name = "Staff of the Shade",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 1978,
					name = "Wolfclaw Gloves",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 2264,
					name = "Mantle of Thieves",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 4438,
					name = "Pugilist Bracers",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 2039,
					name = "Plains Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 1488,
				},
			},
		},
	},
	quests = {
		{
			questID = 1221,
			name = "Blueleaf Tubers",
			level = 26,
			requiredLevel = 20,
			faction = "Both",
			startMap = {
				mapID = 1413,
				x = 0.62,
				y = 0.37,
				label = "Mebok Mizzyrix — Ratchet",
			},
			objective = "Use the Crate with Holes to summon a Snufflenose Gopher and the Command Stick to make it find 6 Blueleaf Tubers. Bring them, the Command Stick and the Crate back to Mebok Mizzyrix.",
			pickup = "Mebok Mizzyrix, Ratchet, The Barrens",
			turnin = "Mebok Mizzyrix, Ratchet, The Barrens",
			rewards = {
				xp = 2100,
			},
		},
		{
			questID = 1144,
			name = "Willix the Importer",
			level = 30,
			requiredLevel = 23,
			faction = "Both",
			objective = "Escort Willix the Importer out of Razorfen Kraul.",
			pickup = "Willix the Importer, inside Razorfen Kraul",
			turnin = "Willix the Importer, inside Razorfen Kraul",
			rewards = {
				xp = 3050,
				items = {
					{
						itemID = 6748,
						name = "Monkey Ring",
						quality = 2,
					},
					{
						itemID = 6750,
						name = "Snake Hoop",
						quality = 2,
					},
					{
						itemID = 6749,
						name = "Tiger Band",
						quality = 2,
					},
					{
						itemID = 274078,
						name = "Boar Signet",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1142,
			name = "Mortality Wanes",
			level = 30,
			requiredLevel = 25,
			faction = "Alliance",
			objective = "Find Treshala's Pendant and return it to Treshala Fallowbrook in Darnassus.",
			pickup = "Heralath Fallowbrook, inside Razorfen Kraul",
			turnin = "Treshala Fallowbrook, Darnassus",
			rewards = {
				xp = 3050,
				items = {
					{
						itemID = 6751,
						name = "Mourning Shawl",
						quality = 2,
					},
					{
						itemID = 6752,
						name = "Lancer Boots",
						quality = 2,
					},
					{
						itemID = 270047,
						name = "Sentinel's Boots",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1101,
			name = "The Crone of the Kraul",
			level = 34,
			requiredLevel = 29,
			faction = "Alliance",
			startMap = {
				mapID = 1444,
				x = 0.89,
				y = 0.46,
				label = "Falfindel Waywarder — Thalanaar",
			},
			objective = "Bring Razorflank's Medallion to Falfindel Waywarder in Thalanaar.",
			pickup = "Falfindel Waywarder, Thalanaar, Feralas",
			turnin = "Falfindel Waywarder, Thalanaar, Feralas",
			rewards = {
				xp = 3350,
				items = {
					{
						itemID = 4197,
						name = "Berylline Pads",
						quality = 2,
					},
					{
						itemID = 6742,
						name = "Stonefist Girdle",
						quality = 2,
					},
					{
						itemID = 6725,
						name = "Marbled Buckler",
						quality = 2,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 1100,
					name = "Lonebrow's Journal",
				},
			},
		},
		{
			questID = 1102,
			name = "A Vengeful Fate",
			level = 34,
			requiredLevel = 29,
			faction = "Horde",
			startMap = {
				mapID = 1456,
				x = 0.36,
				y = 0.59,
				label = "Auld Stonespire — Thunder Bluff",
			},
			objective = "Bring Razorflank's Heart to Auld Stonespire in Thunder Bluff.",
			pickup = "Auld Stonespire, Thunder Bluff",
			turnin = "Auld Stonespire, Thunder Bluff",
			rewards = {
				xp = 4050,
				items = {
					{
						itemID = 4197,
						name = "Berylline Pads",
						quality = 2,
					},
					{
						itemID = 6742,
						name = "Stonefist Girdle",
						quality = 2,
					},
					{
						itemID = 6725,
						name = "Marbled Buckler",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1109,
			name = "Going, Going, Guano!",
			level = 33,
			requiredLevel = 30,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.48,
				y = 0.69,
				label = "Master Apothecary Faranell — Apothecarium",
			},
			objective = "Bring 1 pile of Kraul Guano from the Kraul bats to Master Apothecary Faranell.",
			pickup = "Master Apothecary Faranell, Undercity",
			turnin = "Master Apothecary Faranell, Undercity",
			rewards = {
				xp = 3300,
			},
		},
		{
			questID = 6521,
			name = "An Unholy Alliance",
			level = 36,
			requiredLevel = 28,
			faction = "Horde",
			objective = "Bring Ambassador Malcin's Head to Varimathras in the Undercity.",
			pickup = "Varimathras, Royal Quarter, Undercity",
			turnin = "Varimathras, Royal Quarter, Undercity",
			rewards = {
				xp = 3500,
				money = 2000,
				items = {
					{
						itemID = 17039,
						name = "Skullbreaker",
						quality = 2,
					},
					{
						itemID = 17042,
						name = "Nail Spitter",
						quality = 2,
					},
					{
						itemID = 17043,
						name = "Zealot's Robe",
						quality = 2,
					},
					{
						itemID = 270054,
						name = "Cultist's Chestguard",
						quality = 3,
					},
				},
				choice = true,
			},
		},
	},
})
