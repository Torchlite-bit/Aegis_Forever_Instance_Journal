-- Blackfathom Deeps: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "BlackfathomDeeps",
	instanceID = 48,
	kind = "dungeon",
	name = "Blackfathom Deeps",
	levelMin = 24,
	levelMax = 32,
	location = "Zoram Strand, Ashenvale",
	buttonArt = {
		"Interface\\Glues\\LoadingScreens\\LoadScreenBlackfathomDeeps",
		"Interface\\Glues\\LoadingScreens\\LoadScreenBlackFathom",
	},
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-BlackfathomDeeps" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-BlackfathomDeeps" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.455,
			y = 0.085,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 221,
				tiles = "Interface\\WorldMap\\BlackFathomDeeps\\BlackFathomDeeps1_",
			},
			{
				uiMapID = 222,
				tiles = "Interface\\WorldMap\\BlackFathomDeeps\\BlackFathomDeeps2_",
			},
			{
				uiMapID = 223,
				tiles = "Interface\\WorldMap\\BlackFathomDeeps\\BlackFathomDeeps3_",
			},
		},
		transitions = {
			{
				floor = 1,
				to = 2,
				x = 0.615,
				y = 0.7,
			},
			{
				floor = 2,
				to = 3,
				x = 0.47,
				y = 0.7,
			},
		},
	},
	zoneEntrance = {
		mapID = 1440,
		x = 0.145,
		y = 0.142,
	},
	bosses = {
		{
			name = "Ghamoo-ra",
			npcID = 4887,
			level = 25,
			displayID = 5027,
			loot = {
				{
					itemID = 6907,
					name = "Tortoise Armor",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 6908,
					name = "Ghamoo-ra's Bind",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 273839,
					name = "Spiked Shell Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 251382,
					name = "Plans: Protector's Silvered Chain Helm",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252801,
					name = "Pattern: Totemic Leather Hood",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 253940,
					name = "Pattern: Filigreed Silky Leggings",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253942,
					name = "Pattern: Filigreed Flame Leggings",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.325,
				y = 0.605,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Lady Sarevess",
			npcID = 4831,
			level = 25,
			displayID = 4979,
			loot = {
				{
					itemID = 888,
					name = "Naga Battle Gloves",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 3078,
					name = "Naga Heartpiercer",
					slot = "Ranged, Bow",
					quality = 2,
				},
				{
					itemID = 11121,
					name = "Darkwater Talwar",
					slot = "Main Hand, Sword",
					quality = 2,
				},
				{
					itemID = 252798,
					name = "Pattern: Brawler's Leather Hood",
					slot = "Leatherworking Recipe",
					quality = 3,
				},
				{
					itemID = 251382,
					name = "Plans: Protector's Silvered Chain Helm",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251383,
					name = "Plans: Acolyte's Silvered Chain Helm",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 253944,
					name = "Pattern: Filigreed Shadow Leggings",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.11,
				y = 0.385,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Gelihast",
			npcID = 6243,
			aliases = { "Gelihast", "Geilhast" },
			level = 26,
			displayID = 1773,
			loot = {
				{
					itemID = 6906,
					name = "Algae Fists",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 6905,
					name = "Reef Axe",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 1470,
					name = "Murloc Skin Bag",
					slot = "Bag",
					quality = 1,
				},
				{
					itemID = 273840,
					name = "Cursed Murloc Eye",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 251375,
					name = "Plans: Veteran's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251377,
					name = "Plans: Protector's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252820,
					name = "Pattern: Brawler's Leather Legguards",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252821,
					name = "Pattern: Trapper's Leather Legguards",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252825,
					name = "Pattern: Wisdom's Leather Leggings",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 253978,
					name = "Pattern: Filigreed Silky Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253980,
					name = "Pattern: Filigreed Flame Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 273141,
					name = "Blueprint: Fishing Rack",
					slot = "Blueprint",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.54,
				y = 0.575,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Lorgus Jett",
			npcID = 12902,
			level = 26,
			displayID = 12822,
			loot = {
				{
					itemID = 273843,
					name = "Fallenroot Longbow",
					slot = "Ranged, Bow",
					quality = 3,
				},
				{
					itemID = 273841,
					name = "Twilight Maul",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 273842,
					name = "Treacherous Treads",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 253978,
					name = "Pattern: Filigreed Silky Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253982,
					name = "Pattern: Filigreed Shadow Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.325,
				y = 0.7,
				floor = 2,
			},
			order = 4,
		},
		{
			name = "Old Serra'kis",
			npcID = 4830,
			aliases = { "Old Serra'kis", "Old Serra’kis" },
			level = 26,
			displayID = 1816,
			loot = {
				{
					itemID = 6901,
					name = "Glowing Thresher Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 6904,
					name = "Bite of Serra'kis",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 6902,
					name = "Bands of Serra'kis",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 251375,
					name = "Plans: Veteran's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252825,
					name = "Pattern: Wisdom's Leather Leggings",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 253978,
					name = "Pattern: Filigreed Silky Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253982,
					name = "Pattern: Filigreed Shadow Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.585,
				y = 0.29,
				floor = 3,
			},
			order = 5,
		},
		{
			name = "Twilight Lord Kelris",
			npcID = 4832,
			level = 27,
			displayID = 4939,
			loot = {
				{
					itemID = 1155,
					name = "Rod of the Sleepwalker",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 6903,
					name = "Gaze Dreamer Pants",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 273846,
					name = "Twilight Lord Girdle",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 252820,
					name = "Pattern: Brawler's Leather Legguards",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252821,
					name = "Pattern: Trapper's Leather Legguards",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252822,
					name = "Pattern: Defender's Leather Kilt",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252823,
					name = "Pattern: Totemic Leather Leggings",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252825,
					name = "Pattern: Wisdom's Leather Leggings",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 253982,
					name = "Pattern: Filigreed Shadow Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 251379,
				},
			},
			mapPin = {
				x = 0.525,
				y = 0.81,
				floor = 2,
			},
			order = 6,
		},
		{
			name = "Aku'mai",
			npcID = 4829,
			aliases = { "Aku'mai", "Aku’mai" },
			level = 28,
			displayID = 2837,
			loot = {
				{
					itemID = 6911,
					name = "Moss Cinch",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 6910,
					name = "Leech Pants",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 6909,
					name = "Strike of the Hydra",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 251376,
					name = "Plans: Guard's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251377,
					name = "Plans: Protector's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251378,
					name = "Plans: Acolyte's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252821,
					name = "Pattern: Trapper's Leather Legguards",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252824,
					name = "Pattern: Stormrider's Leather Kilt",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 253980,
					name = "Pattern: Filigreed Flame Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253984,
					name = "Pattern: Filigreed Pearly Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 252513,
				},
			},
			mapPin = {
				x = 0.855,
				y = 0.86,
				floor = 2,
			},
			order = 7,
		},
		{
			name = "Baron Aquanis",
			npcID = 12876,
			level = 28,
			displayID = 110,
			loot = {
				{
					itemID = 16782,
				},
			},
			order = 8,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 1454,
					name = "Axe of the Enforcer",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 1481,
					name = "Grimclaw",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 3413,
					name = "Doomspike",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 2567,
					name = "Evocator's Blade",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 3414,
					name = "Crested Scepter",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 3415,
					name = "Staff of the Friar",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 2271,
					name = "Staff of the Blessed Seer",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 3417,
					name = "Onyx Claymore",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 1491,
					name = "Ring of Precision",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 1486,
					name = "Tree Bark Jacket",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 3416,
					name = "Martyr's Chain",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 2034,
					name = "Scholarly Robes",
					slot = "Chest, Cloth",
					quality = 3,
				},
			},
		},
	},
	quests = {
		{
			questID = 971,
			name = "Knowledge in the Deeps",
			level = 23,
			requiredLevel = 10,
			faction = "Alliance",
			startMap = {
				mapID = 1455,
				x = 0.5083,
				y = 0.0561,
				label = "Gerrig Bonegrip",
			},
			objective = "Recover the Lorgalis Manuscript from Blackfathom Deeps.",
			pickup = "Gerrig Bonegrip, Forlorn Cavern, Ironforge (50.8, 5.6)",
			turnin = "Gerrig Bonegrip, Forlorn Cavern, Ironforge",
			note = "The manuscript lies in a Pitted Iron Chest under the water of the Pool of Ask'ar, in the north alcove past Ghamoo-ra's room.",
			rewards = {
				xp = 2750,
				reputation = {
					{
						faction = "Ironforge",
						amount = 50,
					},
				},
				items = {
					{
						itemID = 6743,
						name = "Sustaining Ring",
						quality = 2,
					},
				},
			},
			noteItem = {
				itemID = 5359,
				name = "Lorgalis Manuscript",
				note = "Found in a Pitted Iron Chest underwater in the Pool of Ask'ar, in the northern alcove just past Ghamoo-ra's turtle room.",
			},
		},
		{
			questID = 1275,
			name = "Researching the Corruption",
			level = 24,
			requiredLevel = 18,
			faction = "Alliance",
			startMap = {
				mapID = 1439,
				x = 0.383,
				y = 0.431,
				label = "Gershala Nightwhisper",
			},
			objective = "Collect 8 Corrupted Brain Stems from creatures in Blackfathom Deeps.",
			pickup = "Gershala Nightwhisper, Auberdine, Darkshore (38.3, 43.1)",
			turnin = "Gershala Nightwhisper, Auberdine, Darkshore",
			note = "Comes after The Corruption Abroad.",
			rewards = {
				xp = 2400,
				money = 3500,
				reputation = {
					{
						faction = "Darnassus",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 7003,
						name = "Beetle Clasps",
						quality = 2,
					},
					{
						itemID = 7004,
						name = "Prelacy Cape",
						quality = 2,
					},
					{
						itemID = 270021,
						name = "Staghide Armguards",
						quality = 3,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 3765,
					name = "The Corruption Abroad",
				},
			},
		},
		{
			questID = 1198,
			name = "In Search of Thaelrid",
			level = 24,
			requiredLevel = 18,
			faction = "Alliance",
			startMap = {
				mapID = 1457,
				x = 0.55,
				y = 0.24,
				label = "Dawnwatcher Shaedlass",
			},
			objective = "Find Argent Guard Thaelrid inside Blackfathom Deeps.",
			pickup = "Dawnwatcher Shaedlass, Craftsmen's Terrace, Darnassus",
			turnin = "Argent Guard Thaelrid, inside Blackfathom Deeps",
			rewards = {
				xp = 2400,
				reputation = {
					{
						faction = "Argent Dawn",
						amount = 150,
					},
					{
						faction = "Darnassus",
						amount = 150,
					},
				},
			},
		},
		{
			questID = 1199,
			name = "Twilight Falls",
			level = 25,
			requiredLevel = 20,
			faction = "Alliance",
			startMap = {
				mapID = 1457,
				x = 0.55,
				y = 0.24,
				label = "Argent Guard Manados",
			},
			objective = "Collect 10 Twilight Pendants from Twilight's Hammer members in Blackfathom Deeps.",
			pickup = "Argent Guard Manados, Craftsmen's Terrace, Darnassus (55, 24)",
			turnin = "Argent Guard Manados, Craftsmen's Terrace, Darnassus",
			rewards = {
				xp = 2550,
				reputation = {
					{
						faction = "Argent Dawn",
						amount = 150,
					},
					{
						faction = "Darnassus",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 6998,
						name = "Nimbus Boots",
						quality = 2,
					},
					{
						itemID = 7000,
						name = "Heartwood Girdle",
						quality = 2,
					},
					{
						itemID = 270025,
						name = "Silvered Gauntlets",
						quality = 3,
					},
				},
			},
		},
		{
			questID = 1200,
			name = "Blackfathom Villainy",
			level = 27,
			requiredLevel = 18,
			faction = "Alliance",
			objective = "Defeat Twilight Lord Kelris and recover the Head of Kelris.",
			pickup = "Argent Guard Thaelrid, inside Blackfathom Deeps",
			turnin = "Dawnwatcher Selgorm, Darnassus",
			rewards = {
				xp = 3300,
				money = 6500,
				reputation = {
					{
						faction = "Argent Dawn",
						amount = 200,
					},
					{
						faction = "Darnassus",
						amount = 200,
					},
				},
				items = {
					{
						itemID = 7001,
						name = "Gravestone Scepter",
						quality = 3,
					},
					{
						itemID = 7002,
						name = "Arctic Buckler",
						quality = 3,
					},
					{
						itemID = 270031,
						name = "Dark Ritual Leggings",
						quality = 3,
					},
					{
						itemID = 270032,
						name = "Cultist's Armguards",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 6564,
			name = "Allegiance to the Old Gods",
			level = 22,
			requiredLevel = 17,
			faction = "Horde",
			objective = "Bring the Damp Note to Je'neu Sancrea in Ashenvale.",
			pickup = "Use the Damp Note dropped by Blackfathom Tide Priestesses",
			turnin = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale",
			rewards = {
				xp = 1300,
				money = 1100,
				reputation = {
					{
						faction = "Darkspear Trolls",
						amount = 150,
					},
				},
			},
			startItem = {
				itemID = 16790,
				name = "Damp Note",
				note = "Drops from Blackfathom Tide Priestess in the entrance tunnels leading to Blackfathom Deeps.",
			},
		},
		{
			questID = 6562,
			name = "Trouble in the Deeps",
			level = 22,
			requiredLevel = 17,
			faction = "Horde",
			startMap = {
				mapID = 1442,
				x = 0.472,
				y = 0.642,
				label = "Tsunaman — Sun Rock Retreat",
			},
			objective = "Speak to Je'neu Sancrea in Ashenvale.",
			pickup = "Tsunaman, Stonetalon Mountains",
			turnin = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale",
			note = "Leads into The Essence of Aku'Mai.",
			rewards = {
				xp = 435,
				reputation = {
					{
						faction = "Darkspear Trolls",
						amount = 25,
					},
					{
						faction = "Earthen Ring",
						amount = 100,
					},
				},
			},
		},
		{
			questID = 6563,
			name = "The Essence of Aku'Mai",
			level = 22,
			requiredLevel = 17,
			faction = "Horde",
			startMap = {
				mapID = 1440,
				x = 0.12,
				y = 0.34,
				label = "Je'neu Sancrea",
			},
			objective = "Collect 20 Sapphires of Aku'Mai in Blackfathom Deeps.",
			pickup = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale (12, 34)",
			turnin = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale",
			note = "Optional: a way into the dungeon's other Aku'Mai quests.",
			rewards = {
				xp = 1750,
				money = 1400,
				reputation = {
					{
						faction = "Darkspear Trolls",
						amount = 100,
					},
					{
						faction = "Earthen Ring",
						amount = 150,
					},
				},
			},
		},
		{
			questID = 6565,
			name = "Allegiance to the Old Gods",
			level = 26,
			requiredLevel = 17,
			faction = "Horde",
			startMap = {
				mapID = 1440,
				x = 0.12,
				y = 0.34,
				label = "Je'neu Sancrea",
			},
			objective = "Defeat Lorgus Jett in Blackfathom Deeps.",
			pickup = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale (12, 34)",
			turnin = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale",
			note = "Comes after Allegiance to the Old Gods, the one the Damp Note starts.",
			rewards = {
				xp = 6489,
				money = 4000,
				reputation = {
					{
						faction = "Darkspear Trolls",
						amount = 150,
					},
					{
						faction = "Earthen Ring",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 17694,
						name = "Band of the Fist",
						quality = 3,
					},
					{
						itemID = 17695,
						name = "Chestnut Mantle",
						quality = 3,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 6564,
					name = "Allegiance to the Old Gods",
				},
			},
		},
		{
			questID = 6561,
			name = "Blackfathom Villainy",
			level = 27,
			requiredLevel = 18,
			faction = "Horde",
			objective = "Defeat Twilight Lord Kelris and recover the Head of Kelris.",
			pickup = "Argent Guard Thaelrid, inside Blackfathom Deeps",
			turnin = "Bashana Runetotem, Elder Rise, Thunder Bluff",
			rewards = {
				xp = 3300,
				money = 6500,
				reputation = {
					{
						faction = "Argent Dawn",
						amount = 200,
					},
					{
						faction = "Thunder Bluff",
						amount = 200,
					},
				},
				items = {
					{
						itemID = 7001,
						name = "Gravestone Scepter",
						quality = 3,
					},
					{
						itemID = 7002,
						name = "Arctic Buckler",
						quality = 3,
					},
					{
						itemID = 270031,
						name = "Dark Ritual Leggings",
						quality = 3,
					},
					{
						itemID = 270032,
						name = "Cultist's Armguards",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 6921,
			name = "Amongst the Ruins",
			level = 27,
			requiredLevel = 21,
			faction = "Horde",
			startMap = {
				mapID = 1440,
				x = 0.12,
				y = 0.34,
				label = "Je'neu Sancrea",
			},
			objective = "Recover the Fathom Core from the Fathom Stone in Blackfathom Deeps.",
			pickup = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale (12, 34)",
			turnin = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale",
			note = "Its Fathom Stone also calls up Baron Aquanis, an optional fight.",
			rewards = {
				xp = 6746,
				money = 4500,
				reputation = {
					{
						faction = "Darkspear Trolls",
						amount = 150,
					},
					{
						faction = "Earthen Ring",
						amount = 150,
					},
				},
			},
		},
		{
			questID = 6922,
			name = "Baron Aquanis",
			level = 30,
			requiredLevel = 21,
			faction = "Horde",
			objective = "Bring the Strange Water Globe to Je'neu Sancrea at Zoram'gar Outpost, Ashenvale.",
			pickup = "Strange Water Globe, dropped by Baron Aquanis inside Blackfathom Deeps",
			turnin = "Je'neu Sancrea, Zoram'gar Outpost, Ashenvale",
			rewards = {
				xp = 7468,
				reputation = {
					{
						faction = "Darkspear Trolls",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 16886,
						name = "Outlaw Sabre",
						quality = 3,
					},
					{
						itemID = 16887,
						name = "Witch's Finger",
						quality = 3,
					},
					{
						itemID = 270043,
						name = "Dreamer's Chestguard",
						quality = 3,
					},
				},
				choice = true,
			},
			startItem = {
				itemID = 16782,
				name = "Strange Water Globe",
				note = "Drops from Baron Aquanis inside Blackfathom Deeps.",
			},
		},
		{
			questID = 1806,
			name = "The Test of Righteousness",
			level = 22,
			requiredLevel = 20,
			faction = "Alliance",
			classOnly = "PALADIN",
			startMap = {
				mapID = 1426,
				x = 0.526,
				y = 0.368,
				label = "Jordan Stilwell — Gates of Ironforge",
			},
			objective = "Wait for Jordan Stilwell to finish forging a weapon for you.",
			pickup = "Jordan Stilwell, Gates of Ironforge, Dun Morogh",
			turnin = "Jordan Stilwell, Gates of Ironforge, Dun Morogh",
			note = "A paladin quest for humans and dwarves, with parts from several places. Here: the Corrupted Kor Gem, from the Blackfathom Sea Witches inside or the Tide Priestesses and Oracles at the entrance in Ashenvale; Thundris Windweaver in Auberdine cleanses it. The rest: Whitestone Oak Lumber in the Deadmines, Jordan's Smithing Hammer in Shadowfang Keep and Jordan's ore shipment in Loch Modan.",
			rewards = {
				xp = 5500,
				items = {
					{
						itemID = 6953,
						name = "Verigan's Fist",
						quality = 3,
					},
				},
			},
		},
	},
})
