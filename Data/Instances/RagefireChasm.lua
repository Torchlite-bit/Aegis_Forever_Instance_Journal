-- Ragefire Chasm: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "RagefireChasm",
	instanceID = 389,
	kind = "dungeon",
	name = "Ragefire Chasm",
	levelMin = 13,
	levelMax = 18,
	location = "Cleft of Shadow, Orgrimmar",
	buttonArt = "Interface\\Glues\\LoadingScreens\\LoadScreenRagefireChasm",
	buttonImage = 608211,
	loreImage = 608250,
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.61,
			y = 0.075,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 213,
				tiles = "Interface\\WorldMap\\Ragefire\\Ragefire1_",
			},
		},
	},
	zoneEntrance = {
		mapID = 1454,
		x = 0.526,
		y = 0.49,
	},
	bosses = {
		{
			name = "Oggleflint",
			npcID = 11517,
			level = 16,
			displayID = 11611,
			loot = {
				{
					itemID = 272999,
					name = "Barbaric Crossbow",
					slot = "Ranged, Crossbow",
					quality = 3,
				},
				{
					itemID = 272996,
					name = "Trogg Scepter",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 272998,
					name = "Bone Knuckles",
					slot = "Main Hand, Fist Weapon",
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
					itemID = 14561,
				},
				{
					itemID = 15499,
				},
				{
					itemID = 253904,
				},
			},
			mapPin = {
				x = 0.561,
				y = 0.378,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Taragaman the Hungerer",
			npcID = 11520,
			level = 16,
			displayID = 7970,
			loot = {
				{
					itemID = 14149,
					name = "Subterranean Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 14148,
					name = "Crystalline Cuffs",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 14145,
					name = "Cursed Felblade",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 251361,
					name = "Plans: Guard's Gloves",
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
					itemID = 252782,
					name = "Pattern: Wisdom's Leather Gloves",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 14540,
				},
				{
					itemID = 1817,
				},
				{
					itemID = 15210,
				},
				{
					itemID = 253912,
				},
			},
			mapPin = {
				x = 0.405,
				y = 0.57,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Jergosh the Invoker",
			npcID = 11518,
			level = 16,
			displayID = 11429,
			loot = {
				{
					itemID = 14150,
					name = "Robe of Evocation",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 14147,
					name = "Cavedweller Bracers",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 14151,
					name = "Chanting Blade",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 251360,
					name = "Plans: Veteran's Gloves",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 253906,
					name = "Pattern: Filigreed Flame Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 15304,
				},
			},
			mapPin = {
				x = 0.34,
				y = 0.815,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Bazzalan",
			npcID = 11519,
			level = 16,
			displayID = 2007,
			loot = {
				{
					itemID = 273003,
					name = "Searing Dagger",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 273007,
					name = "Chasm Walkers",
					slot = "Feet, Leather",
					quality = 3,
				},
				{
					itemID = 273005,
					name = "Satyrskin Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 252780,
					name = "Pattern: Totemic Leather Gloves",
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
					itemID = 15507,
				},
			},
			mapPin = {
				x = 0.422,
				y = 0.842,
				floor = 1,
			},
			order = 4,
		},
	},
	quests = {
		{
			questID = 5723,
			name = "Testing an Enemy's Strength",
			level = 15,
			requiredLevel = 9,
			faction = "Horde",
			startMap = {
				mapID = 1456,
				x = 0.704,
				y = 0.322,
				label = "Rahauro",
			},
			objective = "Kill 8 Ragefire Troggs and 8 Ragefire Shamans inside Ragefire Chasm.",
			pickup = "Rahauro, Elder Rise, Thunder Bluff",
			turnin = "Rahauro, Elder Rise, Thunder Bluff",
			rewards = {
				xp = 1050,
				money = 700,
				reputation = {
					{
						faction = "Thunder Bluff",
						amount = 100,
					},
				},
			},
		},
		{
			questID = 5724,
			name = "Returning the Lost Satchel",
			level = 16,
			requiredLevel = 9,
			faction = "Horde",
			objective = "Take the Grimtotem Satchel to Rahauro in Thunder Bluff.",
			pickup = "Grimtotem Satchel, taken from Maur Grimtotem's corpse inside Ragefire Chasm",
			turnin = "Rahauro, Elder Rise, Thunder Bluff",
			rewards = {
				xp = 1450,
				reputation = {
					{
						faction = "Thunder Bluff",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 15452,
						name = "Featherbead Bracers",
						quality = 3,
					},
					{
						itemID = 15453,
						name = "Savannah Bracers",
						quality = 3,
					},
					{
						itemID = 270003,
						name = "Garrison Cuffs",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 5728,
			name = "Hidden Enemies",
			level = 16,
			requiredLevel = 9,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.32,
				y = 0.378,
				label = "Thrall",
			},
			objective = "Kill Bazzalan and Jergosh the Invoker inside Ragefire Chasm.",
			pickup = "Thrall, Valley of Wisdom, Orgrimmar",
			turnin = "Thrall, Valley of Wisdom, Orgrimmar",
			note = "Needs the earlier steps of the Hidden Enemies chain in Orgrimmar.",
			rewards = {
				xp = 1150,
				money = 800,
				reputation = {
					{
						faction = "Orgrimmar",
						amount = 100,
					},
				},
			},
			prerequisites = {
				{
					questID = 5726,
					name = "Hidden Enemies",
				},
				{
					questID = 5727,
					name = "Hidden Enemies",
				},
			},
		},
		{
			questID = 5761,
			name = "Slaying the Beast",
			level = 16,
			requiredLevel = 9,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.496,
				y = 0.506,
				label = "Neeru Fireblade",
			},
			objective = "Slay Taragaman the Hungerer and recover Taragaman the Hungerer's Heart.",
			pickup = "Neeru Fireblade, Cleft of Shadow, Orgrimmar",
			turnin = "Neeru Fireblade, Cleft of Shadow, Orgrimmar",
			rewards = {
				xp = 1150,
				money = 800,
			},
		},
		{
			questID = 5725,
			name = "The Power to Destroy...",
			level = 16,
			requiredLevel = 9,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.562,
				y = 0.926,
				label = "Varimathras",
			},
			objective = "Collect Spells of Shadow and Incantations from the Nether inside Ragefire Chasm.",
			pickup = "Varimathras, Royal Quarter, Undercity",
			turnin = "Varimathras, Royal Quarter, Undercity",
			rewards = {
				xp = 1450,
				reputation = {
					{
						faction = "Undercity",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 15449,
						name = "Ghastly Trousers",
						quality = 3,
					},
					{
						itemID = 15450,
						name = "Dredgemire Leggings",
						quality = 3,
					},
					{
						itemID = 15451,
						name = "Gargoyle Leggings",
						quality = 3,
					},
				},
				choice = true,
			},
		},
	},
})
