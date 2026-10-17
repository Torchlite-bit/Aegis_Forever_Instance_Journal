-- Shadowfang Keep: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "ShadowfangKeep",
	instanceID = 33,
	kind = "dungeon",
	name = "Shadowfang Keep",
	levelMin = 20,
	levelMax = 30,
	location = "Silverpine Forest",
	buttonArt = "Interface\\Glues\\LoadingScreens\\LoadScreenShadowFangKeep",
	buttonImage = 522358,
	loreImage = 526410,
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.705,
			y = 0.605,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 310,
				tiles = "Interface\\WorldMap\\ShadowfangKeep\\ShadowfangKeep1_",
			},
			{
				uiMapID = 316,
				tiles = "Interface\\WorldMap\\ShadowfangKeep\\ShadowfangKeep7_",
			},
			{
				uiMapID = 315,
				tiles = "Interface\\WorldMap\\ShadowfangKeep\\ShadowfangKeep6_",
			},
		},
		transitions = {
			{
				floor = 1,
				to = 2,
				x = 0.145,
				y = 0.864,
			},
			{
				floor = 2,
				to = 3,
				x = 0.515,
				y = 0.915,
			},
		},
	},
	zoneEntrance = {
		mapID = 1421,
		x = 0.448,
		y = 0.678,
	},
	bosses = {
		{
			name = "Rethilgore",
			npcID = 3914,
			level = 20,
			displayID = 524,
			loot = {
				{
					itemID = 5254,
					name = "Rugged Spaulders",
					slot = "Shoulder, Leather",
					quality = 2,
				},
				{
					itemID = 273457,
					name = "Sorcerer Collar",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 273456,
					name = "Cell Keeper's Claws",
					slot = "Main Hand, Fist Weapon",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.67,
				y = 0.715,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Fel Steed / Shadow Charger",
			npcID = 3864,
			aliases = { "Fel Steed", "Shadow Charger", "Fel Steed / Shadow Charger" },
			displayID = 1951,
			loot = {
				{
					itemID = 6341,
					name = "Eerie Stable Lantern",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 932,
					name = "Fel Steed Saddlebags",
					slot = "Bag",
					quality = 2,
				},
				{
					itemID = 251341,
					name = "Plans: Guard's Chain Shirt",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251362,
					name = "Plans: Protector's Gloves",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251363,
					name = "Plans: Acolyte's Gloves",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251364,
					name = "Plans: Crusader's Gloves",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252781,
					name = "Pattern: Stormrider's Leather Gloves",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252782,
					name = "Pattern: Wisdom's Leather Gloves",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 253902,
					name = "Pattern: Filigreed Pristine Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253904,
					name = "Pattern: Filigreed Silky Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253906,
					name = "Pattern: Filigreed Flame Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253908,
					name = "Pattern: Filigreed Shadow Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253910,
					name = "Pattern: Filigreed Pearly Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253912,
					name = "Pattern: Filigreed Shining Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 251381,
					name = "Plans: Guard's Silvered Chain Helm",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251382,
					name = "Plans: Protector's Silvered Chain Helm",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252799,
					name = "Pattern: Trapper's Leather Hood",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252801,
					name = "Pattern: Totemic Leather Hood",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252803,
					name = "Pattern: Wisdom's Leather Hood",
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
					itemID = 253946,
					name = "Pattern: Filigreed Pearly Leggings",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253948,
					name = "Pattern: Filigreed Shining Leggings",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.345,
				y = 0.635,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Razorclaw the Butcher",
			npcID = 3886,
			level = 22,
			displayID = 524,
			loot = {
				{
					itemID = 1292,
					name = "Butcher's Cleaver",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 6226,
					name = "Bloody Apron",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 6633,
					name = "Butcher's Slicer",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 1206,
				},
				{
					itemID = 789,
				},
				{
					itemID = 273096,
				},
			},
			mapPin = {
				x = 0.327,
				y = 0.447,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Baron Silverlaine",
			npcID = 3887,
			level = 24,
			displayID = 3222,
			loot = {
				{
					itemID = 6321,
					name = "Silverlaine's Family Seal",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 6323,
					name = "Baron's Scepter",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 273637,
					name = "Blade of Silverlaine",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 253942,
				},
			},
			mapPin = {
				x = 0.162,
				y = 0.807,
				floor = 1,
			},
			order = 4,
		},
		{
			name = "Commander Springvale",
			npcID = 4278,
			level = 24,
			displayID = 3223,
			loot = {
				{
					itemID = 6320,
					name = "Commander's Crest",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 3191,
					name = "Arced War Axe",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 273643,
					name = "Worgenbane Talisman",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 273105,
					name = "Blueprint: Toxin Study",
					slot = "Blueprint",
					quality = 2,
				},
				{
					itemID = 6341,
					name = "Eerie Stable Lantern",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 251383,
				},
			},
			order = 5,
		},
		{
			name = "Odo the Blindwatcher",
			npcID = 4279,
			level = 24,
			displayID = 522,
			loot = {
				{
					itemID = 6318,
					name = "Odo's Ley Staff",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 6319,
					name = "Girdle of the Blindwatcher",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 273645,
					name = "Blindwatcher's Sight",
					slot = "Head",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.583,
				y = 0.828,
				floor = 2,
			},
			order = 6,
		},
		{
			name = "Deathsworn Captain",
			npcID = 3872,
			level = 25,
			rare = true,
			displayID = 3224,
			loot = {
				{
					itemID = 6642,
					name = "Phantom Armor",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 6641,
					name = "Haunting Blade",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 2765,
				},
			},
			mapPin = {
				x = 0.63,
				y = 0.525,
				floor = 2,
			},
			order = 7,
		},
		{
			name = "Arugal's Voidwalker",
			npcID = 4627,
			aliases = { "Arugal's Voidwalker", "Arugal’s Voidwalker" },
			displayID = 1131,
			loot = {
				{
					itemID = 5943,
					name = "Rift Bracers",
					slot = "Wrist, Mail",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.492,
				y = 0.71,
				floor = 3,
			},
			order = 8,
		},
		{
			name = "Fenrus the Devourer",
			npcID = 4274,
			level = 25,
			displayID = 2352,
			loot = {
				{
					itemID = 6340,
					name = "Fenrus' Hide",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 3230,
					name = "Black Wolf Bracers",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 273646,
					name = "Half-Eaten Boots",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 252798,
				},
				{
					itemID = 251384,
				},
			},
			mapPin = {
				x = 0.546,
				y = 0.627,
				floor = 3,
			},
			order = 9,
		},
		{
			name = "Wolf Master Nandos",
			npcID = 3927,
			level = 25,
			displayID = 11179,
			loot = {
				{
					itemID = 3748,
					name = "Feline Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 6314,
					name = "Wolfmaster Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 273647,
					name = "Worgpelt Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.59,
				y = 0.533,
				floor = 3,
			},
			order = 10,
		},
		{
			name = "Archmage Arugal",
			npcID = 4275,
			level = 24,
			displayID = 2353,
			loot = {
				{
					itemID = 6324,
					name = "Robes of Arugal",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 6392,
					name = "Belt of Arugal",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 6220,
					name = "Meteor Shard",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 5442,
				},
				{
					itemID = 1748,
				},
				{
					itemID = 1712,
				},
				{
					itemID = 253938,
				},
			},
			mapPin = {
				x = 0.685,
				y = 0.334,
				floor = 3,
			},
			order = 11,
		},
		{
			name = "Sever",
			npcID = 14682,
			displayID = 1061,
			loot = {
				{
					itemID = 23173,
				},
				{
					itemID = 23171,
				},
			},
			order = 12,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 1489,
					name = "Gloomshroud Armor",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 1974,
					name = "Mindthrust Bracers",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 1483,
					name = "Face Smasher",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 2292,
					name = "Necrology Robes",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 2205,
					name = "Duskbringer",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 2807,
					name = "Guillotine Axe",
					slot = "Main Hand, Axe",
					quality = 3,
				},
				{
					itemID = 3194,
					name = "Black Malice",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 1482,
					name = "Shadowfang",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 1935,
					name = "Assassin's Blade",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 1318,
					name = "Night Reaver",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 1484,
					name = "Witching Stave",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
			},
		},
	},
	quests = {
		{
			questID = 1098,
			name = "Deathstalkers in Shadowfang",
			level = 25,
			requiredLevel = 18,
			faction = "Horde",
			startMap = {
				mapID = 1421,
				x = 0.434,
				y = 0.409,
				label = "High Executor Hadrec",
			},
			objective = "Find Deathstalker Adamant and Deathstalker Vincent inside Shadowfang Keep.",
			pickup = "High Executor Hadrec, The Sepulcher, Silverpine Forest",
			turnin = "Deathstalker Vincent, inside Shadowfang Keep",
			rewards = {
				xp = 2000,
				money = 1800,
				reputation = {
					{
						faction = "Undercity",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 3324,
						name = "Ghostly Mantle",
						quality = 3,
					},
					{
						itemID = 270023,
						name = "Tanned Shoulderpads",
						quality = 3,
					},
					{
						itemID = 270024,
						name = "Bronzed Shoulderguards",
						quality = 3,
					},
				},
				choice = true,
				text = "Ghostly Mantle, Tanned Shoulderpads and Bronzed Shoulderguards\n8,700 XP • 18s • Undercity +100",
			},
		},
		{
			questID = 1740,
			name = "The Orb of Soran'ruk",
			level = 25,
			requiredLevel = 20,
			faction = "Both",
			classOnly = "WARLOCK",
			startMap = {
				mapID = 1413,
				x = 0.493,
				y = 0.572,
				label = "Doan Karhan",
			},
			objective = "Find 3 Soran'ruk Fragments and 1 Large Soran'ruk Fragment and return them to Doan Karhan.",
			pickup = "Doan Karhan, The Barrens",
			turnin = "Doan Karhan, The Barrens",
			note = "A warlock quest. The fragments come from here and from Blackfathom Deeps.",
			rewards = {
				xp = 2550,
				items = {
					{
						itemID = 6898,
						name = "Orb of Soran'ruk",
						quality = 3,
					},
					{
						itemID = 15109,
						name = "Staff of Soran'ruk",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Orb of Soran'ruk or Staff of Soran'ruk\n2,550 XP",
			},
		},
		{
			questID = 1013,
			name = "The Book of Ur",
			level = 26,
			requiredLevel = 16,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.537,
				y = 0.545,
				label = "Keeper Bel'dugur",
			},
			objective = "Bring the Book of Ur from Shadowfang Keep to Keeper Bel'dugur.",
			pickup = "Keeper Bel'dugur, Apothecarium, Undercity",
			turnin = "Keeper Bel'dugur, Apothecarium, Undercity",
			rewards = {
				xp = 2100,
				reputation = {
					{
						faction = "Undercity",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 6335,
						name = "Grizzled Boots",
						quality = 3,
					},
					{
						itemID = 4534,
						name = "Steel-clasped Bracers",
						quality = 3,
					},
					{
						itemID = 270030,
						name = "Tattered Mittens",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Grizzled Boots, Steel-clasped Bracers or Tattered Mittens\n9,135 XP • Undercity +100",
			},
		},
		{
			questID = 1014,
			name = "Arugal Must Die",
			level = 27,
			requiredLevel = 18,
			faction = "Horde",
			startMap = {
				mapID = 1421,
				x = 0.442,
				y = 0.398,
				label = "Dalar Dawnweaver",
			},
			objective = "Kill Archmage Arugal and bring his head to Dalar Dawnweaver.",
			pickup = "Dalar Dawnweaver, The Sepulcher, Silverpine Forest",
			turnin = "Dalar Dawnweaver, The Sepulcher, Silverpine Forest",
			note = "Forever's quest data also lists Arcane Intellect among the spells it teaches.",
			rewards = {
				xp = 3300,
				reputation = {
					{
						faction = "Undercity",
						amount = 200,
					},
				},
				items = {
					{
						itemID = 6414,
						name = "Seal of Sylvanas",
						quality = 3,
					},
				},
				text = "Seal of Sylvanas\n14,355 XP • Undercity +200",
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
			note = "A paladin quest for humans and dwarves, with parts from several places. Here: Jordan's Smithing Hammer, picked up from Jordan's Hammer in the courtyard. The rest: Whitestone Oak Lumber in the Deadmines, the Kor Gem in Blackfathom Deeps and Jordan's ore shipment in Loch Modan.",
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
