-- Wailing Caverns: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "WailingCaverns",
	instanceID = 43,
	kind = "dungeon",
	name = "Wailing Caverns",
	levelMin = 15,
	levelMax = 24,
	location = "Northern Barrens",
	buttonArt = "Interface\\Glues\\LoadingScreens\\LoadScreenWailingCaverns",
	buttonImage = 608229,
	loreImage = 608313,
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.465,
			y = 0.59,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 279,
				tiles = "Interface\\WorldMap\\WailingCaverns\\WailingCaverns1_",
			},
		},
	},
	zoneEntrance = {
		mapID = 1413,
		x = 0.46,
		y = 0.364,
	},
	bosses = {
		{
			name = "Lord Cobrahn",
			npcID = 3669,
			level = 20,
			displayID = 4213,
			loot = {
				{
					itemID = 6460,
					name = "Cobrahn's Grasp",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 10410,
					name = "Leggings of the Fang",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 6465,
					name = "Robe of the Moccasin",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 9738,
				},
				{
					itemID = 1789,
				},
				{
					itemID = 1745,
				},
			},
			mapPin = {
				x = 0.155,
				y = 0.57,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Lady Anacondra",
			npcID = 3671,
			level = 20,
			displayID = 4313,
			loot = {
				{
					itemID = 10412,
					name = "Belt of the Fang",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 5404,
					name = "Serpent's Shoulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 6446,
					name = "Snakeskin Bag",
					slot = "Bag",
					quality = 2,
				},
				{
					itemID = 273088,
					name = "Snake Eye Kaleidoscope",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 9739,
				},
				{
					itemID = 252780,
				},
				{
					itemID = 251363,
				},
				{
					itemID = 273098,
				},
			},
			mapPin = {
				x = 0.31,
				y = 0.43,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Kresh",
			npcID = 3653,
			level = 20,
			displayID = 5126,
			loot = {
				{
					itemID = 13245,
					name = "Kresh's Back",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 6447,
					name = "Worn Turtle Shell Shield",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 273084,
					name = "Cloak of Hermitic Bliss",
					slot = "Back, Cloth",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.385,
				y = 0.35,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Lord Pythas",
			npcID = 3670,
			level = 21,
			displayID = 4214,
			loot = {
				{
					itemID = 6472,
					name = "Stinging Viper",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 6473,
					name = "Armor of the Fang",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 273089,
					name = "Slither Cord",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 9740,
				},
			},
			mapPin = {
				x = 0.6,
				y = 0.617,
				floor = 1,
			},
			order = 4,
		},
		{
			name = "Skum",
			npcID = 3674,
			level = 21,
			displayID = 4203,
			loot = {
				{
					itemID = 6449,
					name = "Glowing Lizardscale Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 6448,
					name = "Tail Spike",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 273137,
					name = "Skum's Bucket",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 5125,
				},
				{
					itemID = 253948,
				},
			},
			mapPin = {
				x = 0.622,
				y = 0.734,
				floor = 1,
			},
			order = 5,
		},
		{
			name = "Lord Serpentis",
			npcID = 3673,
			level = 21,
			displayID = 4215,
			loot = {
				{
					itemID = 6469,
					name = "Venomstrike",
					slot = "Ranged, Bow",
					quality = 3,
				},
				{
					itemID = 5970,
					name = "Serpent Gloves",
					slot = "Hands, Cloth",
					quality = 2,
				},
				{
					itemID = 10411,
					name = "Footpads of the Fang",
					slot = "Feet, Leather",
					quality = 3,
				},
				{
					itemID = 6459,
					name = "Savage Trodders",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 9741,
				},
				{
					itemID = 253938,
				},
				{
					itemID = 251384,
				},
				{
					itemID = 273087,
				},
				{
					itemID = 252801,
				},
			},
			mapPin = {
				x = 0.615,
				y = 0.535,
				floor = 1,
			},
			order = 6,
		},
		{
			name = "Verdan the Everliving",
			npcID = 5775,
			level = 21,
			displayID = 4256,
			loot = {
				{
					itemID = 6630,
					name = "Seedcloud Buckler",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 6631,
					name = "Living Root",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 6629,
					name = "Sporid Cape",
					slot = "Back, Cloth",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.545,
				y = 0.46,
				floor = 1,
			},
			order = 7,
		},
		{
			name = "Mutanus the Devourer",
			npcID = 3654,
			level = 22,
			displayID = 4088,
			loot = {
				{
					itemID = 6461,
					name = "Slime-encrusted Pads",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 6627,
					name = "Mutant Scale Breastplate",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 6463,
					name = "Deep Fathom Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 10441,
					name = "Glowing Shard",
					slot = "Quest Item",
					quality = 1,
				},
				{
					itemID = 1468,
				},
				{
					itemID = 6570,
				},
				{
					itemID = 6564,
				},
				{
					itemID = 10407,
				},
				{
					itemID = 9772,
				},
				{
					itemID = 6579,
				},
			},
			mapPin = {
				x = 0.345,
				y = 0.13,
				floor = 1,
			},
			order = 8,
		},
		{
			name = "Deviate Faerie Dragon",
			npcID = 5912,
			level = 20,
			rare = true,
			displayID = 1267,
			loot = {
				{
					itemID = 5243,
					name = "Firebelcher",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 6632,
					name = "Feyscale Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 252781,
					name = "Pattern: Stormrider's Leather Gloves",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.58,
				y = 0.6,
				floor = 1,
			},
			order = 9,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 10413,
					name = "Gloves of the Fang",
					slot = "Hands, Leather",
					quality = 3,
					droppedBy = "Druid of the Fang",
				},
			},
		},
	},
	quests = {
		{
			questID = 1486,
			name = "Deviate Hides",
			level = 17,
			requiredLevel = 13,
			faction = "Both",
			startMap = {
				mapID = 1413,
				x = 0.466,
				y = 0.363,
				label = "Nalpak",
			},
			objective = "Bring 20 Deviate Hides to Nalpak.",
			pickup = "Nalpak, above the entrance to Wailing Caverns, The Barrens",
			turnin = "Nalpak, above the entrance to Wailing Caverns, The Barrens",
			rewards = {
				xp = 1600,
				money = 1800,
				items = {
					{
						itemID = 6480,
						name = "Slick Deviate Leggings",
						quality = 2,
					},
					{
						itemID = 918,
						name = "Deviate Hide Pack",
						quality = 1,
					},
				},
				choice = true,
				text = "Choose: Slick Deviate Leggings or Deviate Hide Pack\n4,640 XP • 18s",
			},
		},
		{
			questID = 1491,
			name = "Smart Drinks",
			level = 18,
			requiredLevel = 13,
			faction = "Both",
			startMap = {
				mapID = 1413,
				x = 0.628,
				y = 0.367,
				label = "Mebok Mizzyrix",
			},
			objective = "Bring 6 Wailing Essence to Mebok Mizzyrix.",
			pickup = "Mebok Mizzyrix, Ratchet, The Barrens",
			turnin = "Mebok Mizzyrix, Ratchet, The Barrens",
			rewards = {
				xp = 1350,
				money = 1000,
				text = "3,915 XP • 10s",
			},
			prerequisites = {
				{
					questID = 865,
					name = "Raptor Horns",
				},
			},
		},
		{
			questID = 959,
			name = "Trouble at the Docks",
			level = 18,
			requiredLevel = 14,
			faction = "Both",
			startMap = {
				mapID = 1413,
				x = 0.639,
				y = 0.383,
				label = "Crane Operator Bigglefuzz",
			},
			objective = "Retrieve the 99-Year-Old Port from Mad Magglish in Wailing Caverns.",
			pickup = "Crane Operator Bigglefuzz, Ratchet, The Barrens",
			turnin = "Crane Operator Bigglefuzz, Ratchet, The Barrens",
			rewards = {
				xp = 1350,
				money = 1000,
				text = "3,915 XP • 10s",
			},
		},
		{
			questID = 1487,
			name = "Deviate Eradication",
			level = 21,
			requiredLevel = 15,
			faction = "Both",
			startMap = {
				mapID = 1413,
				x = 0.466,
				y = 0.357,
				label = "Ebru",
			},
			objective = "Kill 7 Deviate Ravagers, 7 Deviate Vipers, 7 Deviate Shamblers and 7 Deviate Dreadfangs.",
			pickup = "Ebru, above the entrance to Wailing Caverns, The Barrens",
			turnin = "Ebru, above the entrance to Wailing Caverns, The Barrens",
			rewards = {
				xp = 2050,
				money = 2500,
				items = {
					{
						itemID = 6476,
						name = "Pattern: Deviate Scale Belt",
						quality = 2,
					},
					{
						itemID = 8071,
						name = "Sizzle Stick",
						quality = 2,
					},
					{
						itemID = 6481,
						name = "Dagmire Gauntlets",
						quality = 2,
					},
				},
				choice = true,
				text = "Choose: Pattern: Deviate Scale Belt, Sizzle Stick or Dagmire Gauntlets\n5,945 XP • 25s",
			},
		},
		{
			questID = 6981,
			name = "The Glowing Shard",
			level = 26,
			requiredLevel = 15,
			faction = "Both",
			startMap = {
				mapID = 1456,
				x = 0.706,
				y = 0.3,
				label = "Falla Sagewind",
			},
			objective = "Travel to Ratchet to find someone who can identify the Glowing Shard, then deliver it as directed.",
			pickup = "Item start: Glowing Shard, dropped by Mutanus the Devourer",
			turnin = "Follow the quest directions beginning in Ratchet",
			note = "The quest itself gives no item; its follow-up, In Nightmares, does.",
			rewards = {
				xp = 2650,
				text = "7,685 XP",
			},
			startItem = {
				itemID = 10441,
				name = "Glowing Shard",
				note = "Dropped by: Mutanus the Devourer",
			},
		},
		{
			questID = 914,
			name = "Leaders of the Fang",
			level = 22,
			requiredLevel = 10,
			faction = "Horde",
			startMap = {
				mapID = 1456,
				x = 0.753,
				y = 0.313,
				label = "Nara Wildmane",
			},
			objective = "Bring the Gems of Cobrahn, Anacondra, Pythas and Serpentis to Nara Wildmane.",
			pickup = "Nara Wildmane, Thunder Bluff",
			turnin = "Nara Wildmane, Thunder Bluff",
			note = "Needs the Barrens oasis chain first: The Barrens Oases, The Forgotten Pools, The Stagnant Oasis and Altered Beings, then Hamuul Runetotem and Nara Wildmane, before Leaders of the Fang opens.",
			rewards = {
				xp = 2200,
				reputation = {
					{
						faction = "Thunder Bluff",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 6505,
						name = "Crescent Staff",
						quality = 3,
					},
					{
						itemID = 6504,
						name = "Wingblade",
						quality = 3,
					},
					{
						itemID = 270018,
						name = "Hammerbone",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Crescent Staff, Wingblade or Hammerbone\n6,380 XP • Thunder Bluff +150",
			},
			prerequisites = {
				{
					questID = 870,
					name = "The Forgotten Pools",
				},
				{
					questID = 877,
					name = "The Stagnant Oasis",
				},
				{
					questID = 880,
					name = "Altered Beings",
				},
				{
					questID = 1489,
					name = "Hamuul Runetotem",
				},
				{
					questID = 1490,
					name = "Nara Wildmane",
				},
			},
		},
		{
			questID = 962,
			name = "Serpentbloom",
			level = 18,
			requiredLevel = 14,
			faction = "Horde",
			startMap = {
				mapID = 1456,
				x = 0.23,
				y = 0.21,
				label = "Apothecary Zamah — Pools of Vision, Thunder Bluff",
			},
			objective = "Collect 10 Serpentbloom from Wailing Caverns.",
			pickup = "Apothecary Zamah, Thunder Bluff",
			turnin = "Apothecary Zamah, Thunder Bluff",
			rewards = {
				xp = 1700,
				money = 1000,
				items = {
					{
						itemID = 10919,
						name = "Apothecary Gloves",
						quality = 2,
					},
					{
						itemID = 270008,
						name = "Heat Resistant Mitts",
						quality = 2,
					},
					{
						itemID = 270009,
						name = "Safety Boots",
						quality = 2,
					},
				},
				choice = true,
				text = "Choose: Apothecary Gloves, Heat Resistant Mitts or Safety Boots\n4,930 XP • 10s",
			},
		},
	},
})
