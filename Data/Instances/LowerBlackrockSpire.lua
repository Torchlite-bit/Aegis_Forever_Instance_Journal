-- Lower Blackrock Spire: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "LowerBlackrockSpire",
	instanceID = 229,
	kind = "dungeon",
	name = "Lower Blackrock Spire",
	levelMin = 55,
	levelMax = 60,
	location = "Blackrock Mountain",
	description = "The lower halls of Blackrock Spire, held by the Blackrock orcs, ogres and trolls that serve Warchief Rend Blackhand.",
	buttonArt = {
		"Interface\\Glues\\LoadingScreens\\LoadScreenBlackrockSpire",
		"Interface\\Glues\\LoadingScreens\\LoadScreenBlackRockSpire",
	},
	buttonImage = {
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-LowerBlackrockSpire",
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-BlackrockSpire",
	},
	loreImage = {
		"Interface\\EncounterJournal\\UI-EJ-LOREBG-LowerBlackrockSpire",
		"Interface\\EncounterJournal\\UI-EJ-LOREBG-BlackrockSpire",
	},
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1427,
		x = 0.348,
		y = 0.853,
	},
	wingAreas = {
		["Hordemar City"] = true,
		["Mok'Doom"] = true,
		["Tazz'Alaor"] = true,
		["Tazz'Alor"] = true,
		["Skitterweb Tunnels"] = true,
		["The Storehouse"] = true,
		["Chamber of Battle"] = true,
		["Halycon's Lair"] = true,
	},
	map = {
		entrance = {
			x = 0.37,
			y = 0.42,
			floor = 4,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\LowerBlackrockSpire",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\LowerBlackrockSpire1",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\LowerBlackrockSpire2",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\LowerBlackrockSpire3",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\LowerBlackrockSpire4",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\LowerBlackrockSpire5",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
		},
	},
	floorNames = {
		"Tazz'Alor",
		"Skitterweb Tunnels",
		"Hordemar City",
		"Hall of Blackhand",
		"Halycon's Lair",
		"Chamber of Battle",
	},
	bosses = {
		{
			name = "Burning Felguard",
			displayID = 5047,
			level = 57,
			rare = true,
			order = 1,
			loot = {
				{
					itemID = 13181,
					name = "Demonskin Gloves",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 13182,
					name = "Phase Blade",
					slot = "One-Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.598,
				y = 0.557,
				floor = 1,
			},
		},
		{
			name = "Highlord Omokk",
			displayID = 11565,
			level = 59,
			order = 2,
			loot = {
				{
					itemID = 16670,
					name = "Boots of Elements",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 13166,
					name = "Slamshot Shoulders",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 13168,
					name = "Plate of the Shaman King",
					slot = "Chest, Plate",
					quality = 3,
				},
				{
					itemID = 13170,
					name = "Skyshroud Leggings",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 13169,
					name = "Tressermane Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 13167,
					name = "Fist of Omokk",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 12336,
					name = "Gemstone of Spirestone",
					slot = "Quest",
					quality = 2,
				},
				{
					itemID = 12534,
					name = "Omokk's Head",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.386,
				y = 0.59,
				floor = 3,
			},
		},
		{
			name = "War Master Voone",
			displayID = 9733,
			level = 59,
			order = 3,
			loot = {
				{
					itemID = 16676,
					name = "Beaststalker's Gloves",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 13177,
					name = "Talisman of Evasion",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 13179,
					name = "Brazecore Armguards",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 22231,
					name = "Kayser's Boots of Precision",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 13173,
					name = "Flightblade Throwing Axe",
					slot = "Thrown",
					quality = 3,
				},
				{
					itemID = 12582,
					name = "Keris of Zul'Serak",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 12335,
					name = "Gemstone of Smolderthorn",
					slot = "Quest",
					quality = 2,
				},
				{
					itemID = 13175,
					name = "Voone's Twitchbow",
					slot = "Ranged, Bow",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.524,
				y = 0.551,
				floor = 1,
			},
		},
		{
			name = "Mother Smolderweb",
			displayID = 9929,
			level = 59,
			order = 4,
			loot = {
				{
					itemID = 16715,
					name = "Wildheart Boots",
					slot = "Feet, Leather",
					quality = 3,
				},
				{
					itemID = 13244,
					name = "Gilded Gauntlets",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 13213,
					name = "Smolderweb's Eye",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 13183,
					name = "Venomspitter",
					slot = "One-Hand, Mace",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.624,
				y = 0.732,
				floor = 2,
			},
		},
		{
			name = "Urok Doomhowl",
			displayID = 11583,
			level = 60,
			order = 5,
			loot = {
				{
					itemID = 13258,
					name = "Slaghide Gauntlets",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 22232,
					name = "Marksman's Girdle",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 13259,
					name = "Ribsteel Footguards",
					slot = "Feet, Plate",
					quality = 3,
				},
				{
					itemID = 13178,
					name = "Rosewine Circle",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 18784,
					name = "Top Half of Advanced Armorsmithing: Volume III",
					slot = "Quest",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.452,
				y = 0.553,
				floor = 4,
			},
		},
		{
			name = "Halycon",
			displayID = 9567,
			level = 59,
			order = 6,
			loot = {
				{
					itemID = 13212,
					name = "Halycon's Spiked Collar",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 22313,
					name = "Ironweave Bracers",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 13211,
					name = "Slashclaw Bracers",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 13210,
					name = "Pads of the Dread Wolf",
					slot = "Feet, Leather",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.379,
				y = 0.842,
				floor = 5,
			},
		},
		{
			name = "Ghok Bashguud",
			displayID = 11809,
			level = 59,
			rare = true,
			order = 7,
			loot = {
				{
					itemID = 13203,
					name = "Armswake Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 13198,
					name = "Hurd Smasher",
					slot = "One-Hand, Fist Weapon",
					quality = 3,
				},
				{
					itemID = 13204,
					name = "Bashguuder",
					slot = "One-Hand, Mace",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.374,
				y = 0.605,
				floor = 5,
			},
		},
		{
			name = "Spirestone Butcher",
			displayID = 11574,
			level = 57,
			rare = true,
			order = 8,
			loot = {
				{
					itemID = 12608,
					name = "Butcher's Apron",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 13286,
					name = "Rivenspike",
					slot = "One-Hand, Axe",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.524,
				y = 0.575,
				floor = 3,
			},
		},
		{
			name = "Spirestone Battle Lord",
			displayID = 11576,
			level = 58,
			rare = true,
			order = 9,
			loot = {
				{
					itemID = 13284,
					name = "Swiftdart Battleboots",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 13285,
					name = "The Blackrock Slicer",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.357,
				y = 0.553,
				floor = 3,
			},
		},
		{
			name = "Spirestone Lord Magus",
			displayID = 11578,
			level = 58,
			rare = true,
			order = 10,
			loot = {
				{
					itemID = 13282,
					name = "Ogreseer Tower Boots",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 13283,
					name = "Magus Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 13261,
					name = "Globe of D'sak",
					slot = "Held In Off-hand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.422,
				y = 0.561,
				floor = 3,
			},
		},
		{
			name = "Shadow Hunter Vosh'gajin",
			displayID = 9732,
			level = 58,
			order = 11,
			loot = {
				{
					itemID = 16712,
					name = "Shadowcraft Gloves",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 13257,
					name = "Demonic Runed Spaulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 12626,
					name = "Funeral Cuffs",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 13255,
					name = "Trueaim Gauntlets",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 12653,
					name = "Riphook",
					slot = "Ranged, Bow",
					quality = 3,
				},
				{
					itemID = 12651,
					name = "Blackcrow",
					slot = "Ranged, Crossbow",
					quality = 3,
				},
				{
					itemID = 12654,
					name = "Doomshot",
					slot = "Ammo, Arrow",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.555,
				y = 0.688,
				floor = 2,
			},
		},
		{
			name = "Bannok Grimaxe",
			displayID = 9668,
			level = 59,
			rare = true,
			order = 12,
			loot = {
				{
					itemID = 12637,
					name = "Backusarian Gauntlets",
					slot = "Hands, Plate",
					quality = 3,
				},
				{
					itemID = 12634,
					name = "Chiselbrand Girdle",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 12621,
					name = "Demonfork",
					slot = "Main Hand, Axe",
					quality = 3,
				},
				{
					itemID = 12838,
					name = "Plans: Arcanite Reaper",
					slot = "Blacksmithing",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.525,
				y = 0.658,
				floor = 1,
			},
		},
		{
			name = "Crystal Fang",
			displayID = 9755,
			level = 60,
			rare = true,
			order = 13,
			loot = {
				{
					itemID = 13185,
					name = "Sunderseer Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 13184,
					name = "Fallbrush Handgrips",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 13218,
					name = "Fang of the Crystal Spider",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.603,
				y = 0.771,
				floor = 2,
			},
		},
		{
			name = "Quartermaster Zigris",
			displayID = 9738,
			level = 59,
			order = 14,
			loot = {
				{
					itemID = 13247,
					name = "Quartermaster Zigris' Footlocker",
					slot = "Junk",
					quality = 2,
				},
				{
					itemID = 13253,
					name = "Hands of Power",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 13252,
					name = "Cloudrunner Girdle",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 12835,
					name = "Plans: Annihilator",
					slot = "Blacksmithing",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.54,
				y = 0.849,
				floor = 5,
			},
		},
		{
			name = "Gizrul the Slavener",
			displayID = 9564,
			level = 60,
			order = 15,
			loot = {
				{
					itemID = 16718,
					name = "Wildheart Spaulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 13208,
					name = "Bleak Howler Armguards",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 13206,
					name = "Wolfshear Leggings",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 13205,
					name = "Rhombeard Protector",
					slot = "Off Hand, Shield",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.389,
				y = 0.793,
				floor = 5,
			},
		},
		{
			name = "Overlord Wyrmthalak",
			displayID = 8711,
			level = 60,
			order = 16,
			loot = {
				{
					itemID = 13143,
					name = "Mark of the Dragon Lord",
					slot = "Finger",
					quality = 4,
				},
				{
					itemID = 16679,
					name = "Beaststalker's Mantle",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 13162,
					name = "Reiver Claws",
					slot = "Hands, Plate",
					quality = 3,
				},
				{
					itemID = 13164,
					name = "Heart of the Scale",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 22321,
					name = "Heart of Wyrmthalak",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 13163,
					name = "Relentless Scythe",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 13148,
					name = "Chillpike",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 13161,
					name = "Trindlehaven Staff",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 12337,
					name = "Gemstone of Bloodaxe",
					slot = "Quest",
					quality = 2,
				},
				{
					itemID = 12780,
					name = "General Drakkisath's Command",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.576,
				y = 0.61,
				floor = 6,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 14513,
					name = "Pattern: Robe of the Archmage",
					slot = "Tailoring",
					quality = 4,
				},
				{
					itemID = 16696,
					name = "Devout Belt",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 16685,
					name = "Magister's Belt",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 16683,
					name = "Magister's Bindings",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 16703,
					name = "Dreadmist Bracers",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 16713,
					name = "Shadowcraft Belt",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 16716,
					name = "Wildheart Belt",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 16680,
					name = "Beaststalker's Belt",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 16673,
					name = "Cord of Elements",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 16736,
					name = "Belt of Valor",
					slot = "Waist, Plate",
					quality = 3,
				},
				{
					itemID = 16735,
					name = "Bracers of Valor",
					slot = "Wrist, Plate",
					quality = 3,
				},
				{
					itemID = 15749,
					name = "Pattern: Volcanic Breastplate",
					slot = "Leatherworking",
					quality = 2,
				},
				{
					itemID = 15775,
					name = "Pattern: Volcanic Shoulders",
					slot = "Leatherworking",
					quality = 2,
				},
				{
					itemID = 13494,
					name = "Recipe: Greater Fire Protection Potion",
					slot = "Alchemy",
					quality = 2,
				},
				{
					itemID = 16250,
					name = "Formula: Enchant Weapon - Superior Striking",
					slot = "Enchanting",
					quality = 2,
				},
				{
					itemID = 16244,
					name = "Formula: Enchant Gloves - Greater Strength",
					slot = "Enchanting",
					quality = 2,
				},
				{
					itemID = 9214,
					name = "Grimoire of Inferno",
					slot = "Book",
					quality = 2,
				},
				{
					itemID = 12219,
					name = "Unadorned Seal of Ascension",
					slot = "Quest",
					quality = 1,
				},
				{
					itemID = 12586,
					name = "Immature Venom Sac",
					slot = "Other",
					quality = 1,
				},
				{
					itemID = 13260,
					name = "Wind Dancer Boots",
					slot = "Feet, Mail",
					quality = 3,
				},
			},
		},
	},
	quests = {
		{
			questID = 4788,
			name = "The Final Tablets",
			level = 58,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.669,
				y = 0.24,
			},
			endMap = {
				mapID = 1446,
				x = 0.669,
				y = 0.24,
			},
			objective = "Bring the Fifth and Sixth Mosh'aru Tablets to Prospector Ironboot in Tanaris.",
			pickup = "Prospector Ironboot, Tanaris",
			turnin = "Prospector Ironboot, Tanaris",
			rewards = {
				xp = 7750,
			},
			prerequisites = {
				{
					questID = 5065,
					name = "The Lost Tablets of Mosh'aru",
				},
			},
		},
		{
			questID = 8181,
			name = "Confront Yeh'kinya",
			level = 58,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.669,
				y = 0.24,
			},
			endMap = {
				mapID = 1446,
				x = 0.67,
				y = 0.224,
			},
			objective = "Speak with Yeh'kinya.",
			pickup = "Prospector Ironboot, Tanaris",
			turnin = "Yeh'kinya, Tanaris",
			rewards = {
				xp = 6200,
				items = {
					{
						itemID = 20218,
						name = "Faded Hakkari Cloak",
					},
					{
						itemID = 20219,
						name = "Tattered Hakkari Cape",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 4788,
					name = "The Final Tablets",
				},
			},
		},
		{
			questID = 5001,
			name = "Bijou's Belongings",
			level = 59,
			requiredLevel = 55,
			faction = "Alliance",
			objective = "Find Bijou's Belongings and return them to her. Good luck!",
			turnin = "Bijou, inside the dungeon",
			rewards = {
				xp = 6400,
			},
		},
		{
			questID = 4862,
			name = "En-Ay-Es-Tee-Why",
			level = 59,
			requiredLevel = 55,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.659,
				y = 0.219,
			},
			endMap = {
				mapID = 1428,
				x = 0.659,
				y = 0.219,
			},
			objective = "Travel to Blackrock Spire and collect 15 Spire Spider Eggs for Kibler.",
			pickup = "Kibler, Burning Steppes",
			turnin = "Kibler, Burning Steppes",
			rewards = {
				xp = 6400,
				money = 9000,
				items = {
					{
						itemID = 12529,
						name = "Smolderweb Carrier",
					},
				},
			},
		},
		{
			questID = 4729,
			name = "Kibler's Exotic Pets",
			level = 59,
			requiredLevel = 55,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.659,
				y = 0.219,
			},
			endMap = {
				mapID = 1428,
				x = 0.659,
				y = 0.219,
			},
			objective = "Travel to Blackrock Spire and find Bloodaxe Worg Pups. Use the cage to carry the ferocious little beasts. Bring back a Caged Worg Pup to Kibler.",
			pickup = "Kibler, Burning Steppes",
			turnin = "Kibler, Burning Steppes",
			rewards = {
				xp = 6400,
				money = 9000,
				items = {
					{
						itemID = 12264,
						name = "Worg Carrier",
					},
				},
			},
		},
		{
			questID = 5047,
			name = "Finkle Einhorn, At Your Service!",
			level = 60,
			requiredLevel = 57,
			faction = "Both",
			endMap = {
				mapID = 1452,
				x = 0.61,
				y = 0.388,
			},
			objective = "Talk to Malyfous Darkhammer in Everlook.",
			turnin = "Malyfous Darkhammer, Winterspring",
			rewards = {
				xp = 6600,
			},
		},
		{
			questID = 4866,
			name = "Mother's Milk",
			level = 60,
			requiredLevel = 55,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.65,
				y = 0.238,
			},
			endMap = {
				mapID = 1428,
				x = 0.65,
				y = 0.238,
			},
			objective = "In the heart of Blackrock Spire you will find Mother Smolderweb. Engage her and get her to poison you. Chances are good that you will have to kill her as well. Return to Ragged John when you are poisoned so that he can 'milk' you.",
			pickup = "Ragged John, Burning Steppes",
			turnin = "Ragged John, Burning Steppes",
			rewards = {
				xp = 9950,
				money = 18000,
				items = {
					{
						itemID = 15873,
						name = "Ragged John's Neverending Cup",
					},
				},
			},
		},
		{
			questID = 5127,
			name = "The Demon Forge",
			level = 60,
			requiredLevel = 55,
			faction = "Both",
			startMap = {
				mapID = 1452,
				x = 0.638,
				y = 0.738,
			},
			endMap = {
				mapID = 1452,
				x = 0.638,
				y = 0.738,
			},
			objective = "Travel to Blackrock Spire and find Goraluk Anvilcrack. Slay him and then use the Blood Stained Pike upon his corpse. After his soul has been siphoned, the pike will be Soul Stained.",
			pickup = "Lorax, Winterspring",
			turnin = "Lorax, Winterspring",
			rewards = {
				xp = 8300,
				items = {
					{
						itemID = 12696,
						name = "Plans: Demon Forged Breastplate",
					},
					{
						itemID = 12849,
						name = "Demon Kissed Sack",
					},
				},
			},
			prerequisites = {
				{
					questID = 5126,
					name = "Lorax's Tale",
				},
			},
		},
		{
			questID = 4867,
			name = "Urok Doomhowl",
			level = 60,
			requiredLevel = 55,
			faction = "Both",
			objective = "Read Warosh's Scroll. Bring Warosh's Mojo to Warosh.",
			turnin = "Warosh, inside the dungeon",
			rewards = {
				xp = 9950,
				items = {
					{
						itemID = 15867,
						name = "Prismcharm",
					},
				},
			},
		},
		{
			questID = 4735,
			name = "Egg Collection",
			level = 60,
			requiredLevel = 57,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.652,
				y = 0.24,
			},
			endMap = {
				mapID = 1428,
				x = 0.652,
				y = 0.24,
			},
			objective = "Bring 8 Collected Dragon Eggs and the Collectronic Module to Tinkee Steamboil at Flame Crest in the Burning Steppes.",
			pickup = "Tinkee Steamboil, Burning Steppes",
			turnin = "Tinkee Steamboil, Burning Steppes",
			rewards = {
				xp = 9950,
				money = 27000,
			},
			prerequisites = {
				{
					questID = 4734,
					name = "Egg Freezing",
				},
			},
		},
		{
			questID = 4734,
			name = "Egg Freezing",
			level = 60,
			requiredLevel = 57,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.652,
				y = 0.24,
			},
			endMap = {
				mapID = 1428,
				x = 0.652,
				y = 0.24,
			},
			objective = "Use the Eggscilloscope Prototype on an egg in the Rookery.",
			pickup = "Tinkee Steamboil, Burning Steppes",
			turnin = "Tinkee Steamboil, Burning Steppes",
			rewards = {
				xp = 8300,
				money = 18000,
				items = {
					{
						itemID = 12144,
						name = "Eggscilloscope",
					},
				},
			},
			prerequisites = {
				{
					questID = 4907,
					name = "Tinkee Steamboil",
				},
			},
		},
		{
			questID = 4742,
			name = "Seal of Ascension",
			level = 60,
			requiredLevel = 57,
			faction = "Both",
			objective = "Find the three gemstones of command: The Gemstone of Smolderthorn, Gemstone of Spirestone, and Gemstone of Bloodaxe. Return them, along with the Unadorned Seal of Ascension, to Vaelan.",
			turnin = "Vaelan, inside the dungeon",
			rewards = {
				xp = 8300,
			},
			prerequisites = {
				{
					questID = 4743,
					name = "Seal of Ascension",
				},
			},
		},
		{
			questID = 4743,
			name = "Seal of Ascension",
			level = 60,
			requiredLevel = 57,
			faction = "Both",
			objective = "Travel to the Wyrmbog in Dustwallow Marsh. Find the ancient drake, Emberstrife and beat him without mercy until his will is broken.",
			turnin = "Vaelan, inside the dungeon",
			rewards = {
				xp = 9950,
				items = {
					{
						itemID = 12344,
						name = "Seal of Ascension",
					},
				},
			},
			prerequisites = {
				{
					questID = 4742,
					name = "Seal of Ascension",
				},
			},
		},
		{
			questID = 5160,
			name = "The Matron Protectorate",
			level = 60,
			requiredLevel = 57,
			faction = "Both",
			endMap = {
				mapID = 1452,
				x = 0.545,
				y = 0.512,
			},
			objective = "Travel to Winterspring and find Haleh. Give her Awbee's scale.",
			turnin = "Haleh, Winterspring",
			rewards = {
				xp = 6600,
			},
		},
		{
			questID = 8995,
			name = "Mea Culpa, Lord Valthalak",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			objective = "Use the Brazier of Beckoning to summon Lord Valthalak. Dispatch him, and use Lord Valthalak's Amulet on the corpse. Then, return Lord Valthalak's Amulet to the Spirit of Lord Valthalak.",
			pickup = "Bodley, Burning Steppes",
			turnin = "Spirit of Lord Valthalak, inside the dungeon",
			rewards = {
				xp = 9950,
			},
			prerequisites = {
				{
					questID = 8994,
					name = "Final Preparations",
				},
			},
		},
		{
			questID = 8996,
			name = "Return to Bodley",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			endMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			objective = "Return to Bodley inside Blackrock Mountain and give him the Brazier of Beckoning.",
			turnin = "Bodley, Burning Steppes",
			rewards = {
				xp = 650,
				items = {
					{
						itemID = 22057,
						name = "Brazier of Invocation",
					},
					{
						itemID = 22344,
						name = "Brazier of Invocation: User's Manual",
					},
				},
			},
			prerequisites = {
				{
					questID = 8995,
					name = "Mea Culpa, Lord Valthalak",
				},
			},
		},
		{
			questID = 8966,
			name = "The Left Piece of Lord Valthalak's Amulet",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			endMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			objective = "Use the Brazier of Beckoning to summon forth the spirit of Mor Grayhoof and slay him. Return to Bodley inside Blackrock Mountain with the Left Piece of Lord Valthalak's Amulet and the Brazier of Beckoning.",
			pickup = "Bodley, Burning Steppes",
			turnin = "Bodley, Burning Steppes",
			rewards = {
				xp = 8300,
			},
			prerequisites = {
				{
					questID = 8962,
					name = "Components of Importance",
				},
			},
		},
		{
			questID = 8989,
			name = "The Right Piece of Lord Valthalak's Amulet",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			endMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			objective = "Use the Brazier of Beckoning to summon forth the spirit of Mor Grayhoof and slay him. Return to Bodley inside Blackrock Mountain with the recombined Lord Valthalak's Amulet and the Brazier of Beckoning.",
			pickup = "Bodley, Burning Steppes",
			turnin = "Bodley, Burning Steppes",
			rewards = {
				xp = 8300,
			},
			prerequisites = {
				{
					questID = 8970,
					name = "I See Alcaz Island In Your Future...",
				},
			},
		},
		{
			questID = 5002,
			name = "Message to Maxwell",
			level = 59,
			requiredLevel = 55,
			faction = "Alliance",
			endMap = {
				mapID = 1428,
				x = 0.847,
				y = 0.69,
			},
			objective = "Travel to the Burning Steppes and give Bijou's Information to Marshal Maxwell.",
			turnin = "Marshal Maxwell, Burning Steppes",
			rewards = {
				xp = 6400,
				money = 18000,
			},
			prerequisites = {
				{
					questID = 5001,
					name = "Bijou's Belongings",
				},
			},
		},
		{
			questID = 4701,
			name = "Put Her Down",
			level = 59,
			requiredLevel = 55,
			faction = "Alliance",
			startMap = {
				mapID = 1428,
				x = 0.858,
				y = 0.689,
			},
			endMap = {
				mapID = 1428,
				x = 0.858,
				y = 0.689,
			},
			objective = "Travel to Blackrock Spire and destroy the source of the worg menace. As you left Helendis, he shouted a name: Halycon. It is what the orcs refer to in regards to the worg.",
			pickup = "Helendis Riverhorn, Burning Steppes",
			turnin = "Helendis Riverhorn, Burning Steppes",
			rewards = {
				xp = 6400,
				money = 18000,
				items = {
					{
						itemID = 15824,
						name = "Astoria Robes",
					},
					{
						itemID = 15825,
						name = "Traphook Jerkin",
					},
					{
						itemID = 15827,
						name = "Jadescale Breastplate",
					},
				},
				choice = true,
			},
		},
		{
			questID = 5089,
			name = "General Drakkisath's Command",
			level = 60,
			requiredLevel = 55,
			faction = "Alliance",
			endMap = {
				mapID = 1428,
				x = 0.847,
				y = 0.69,
			},
			objective = "Take General Drakkisath's Command to Marshal Maxwell in Burning Steppes.",
			turnin = "Marshal Maxwell, Burning Steppes",
			rewards = {
				xp = 6600,
			},
		},
		{
			questID = 5081,
			name = "Maxwell's Mission",
			level = 60,
			requiredLevel = 55,
			faction = "Alliance",
			startMap = {
				mapID = 1428,
				x = 0.847,
				y = 0.69,
			},
			endMap = {
				mapID = 1428,
				x = 0.847,
				y = 0.69,
			},
			objective = "Travel to Blackrock Spire and destroy War Master Voone, Highlord Omokk, and Overlord Wyrmthalak. Return to Marshal Maxwell when the job is done.",
			pickup = "Marshal Maxwell, Burning Steppes",
			turnin = "Marshal Maxwell, Burning Steppes",
			rewards = {
				xp = 8300,
				money = 18000,
				items = {
					{
						itemID = 13958,
						name = "Wyrmthalak's Shackles",
					},
					{
						itemID = 13959,
						name = "Omokk's Girth Restrainer",
					},
					{
						itemID = 13961,
						name = "Halycon's Muzzle",
					},
					{
						itemID = 13962,
						name = "Vosh'gajin's Strand",
					},
					{
						itemID = 13963,
						name = "Voone's Vice Grips",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 5002,
					name = "Message to Maxwell",
				},
			},
		},
		{
			questID = 4765,
			name = "Delivery to Ridgewell",
			level = 60,
			requiredLevel = 57,
			faction = "Alliance",
			startMap = {
				mapID = 1428,
				x = 0.848,
				y = 0.691,
			},
			endMap = {
				mapID = 1453,
				x = 0.769,
				y = 0.478,
			},
			objective = "Bring Ridgewell's Crate to Remington Ridgewell in Stormwind.",
			pickup = "Mayara Brightwing, Burning Steppes",
			turnin = "Count Remington Ridgewell, Stormwind City",
			rewards = {
				xp = 6600,
				money = 27000,
				items = {
					{
						itemID = 15861,
						name = "Swiftfoot Treads",
					},
					{
						itemID = 15860,
						name = "Blinkstrike Armguards",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 4764,
					name = "Doomrigger's Clasp",
				},
			},
		},
		{
			questID = 4764,
			name = "Doomrigger's Clasp",
			level = 60,
			requiredLevel = 57,
			faction = "Alliance",
			startMap = {
				mapID = 1428,
				x = 0.848,
				y = 0.691,
			},
			endMap = {
				mapID = 1428,
				x = 0.848,
				y = 0.691,
			},
			objective = "Bring Doomrigger's Clasp to Mayara Brightwing in the Burning Steppes.",
			pickup = "Mayara Brightwing, Burning Steppes",
			turnin = "Mayara Brightwing, Burning Steppes",
			rewards = {
				xp = 1650,
			},
			prerequisites = {
				{
					questID = 4766,
					name = "Mayara Brightwing",
				},
			},
		},
		{
			questID = 4983,
			name = "Bijou's Reconnaissance Report",
			level = 59,
			requiredLevel = 55,
			faction = "Horde",
			endMap = {
				mapID = 1418,
				x = 0.059,
				y = 0.476,
			},
			objective = "Take Bijou's Reconnaissance Report back to Grandmaster Lexlort in Kargath.",
			turnin = "Lexlort, Badlands",
			rewards = {
				xp = 6400,
				money = 18000,
				items = {
					{
						itemID = 15858,
						name = "Freewind Gloves",
					},
					{
						itemID = 15859,
						name = "Seapost Girdle",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 4982,
					name = "Bijou's Belongings",
				},
			},
		},
		{
			questID = 4724,
			name = "The Pack Mistress",
			level = 59,
			requiredLevel = 55,
			faction = "Horde",
			startMap = {
				mapID = 1418,
				x = 0.06,
				y = 0.477,
			},
			endMap = {
				mapID = 1418,
				x = 0.06,
				y = 0.477,
			},
			objective = "Slay Halycon, pack mistress of the Bloodaxe worg.",
			pickup = "Galamav the Marksman, Badlands",
			turnin = "Galamav the Marksman, Badlands",
			rewards = {
				xp = 6400,
				money = 18000,
				items = {
					{
						itemID = 15824,
						name = "Astoria Robes",
					},
					{
						itemID = 15825,
						name = "Traphook Jerkin",
					},
					{
						itemID = 15827,
						name = "Jadescale Breastplate",
					},
				},
				choice = true,
			},
		},
		{
			questID = 6569,
			name = "Oculus Illusions",
			level = 60,
			requiredLevel = 55,
			faction = "Horde",
			startMap = {
				mapID = 1422,
				x = 0.508,
				y = 0.778,
			},
			endMap = {
				mapID = 1422,
				x = 0.508,
				y = 0.778,
			},
			objective = "Travel to Blackrock Spire and collect 20 Black Dragonspawn Eyes. Return to Myranda the Hag when the task is complete.",
			pickup = "Myranda the Hag, Western Plaguelands",
			turnin = "Myranda the Hag, Western Plaguelands",
			rewards = {
				xp = 6600,
			},
			prerequisites = {
				{
					questID = 6568,
					name = "The Testament of Rexxar",
				},
			},
		},
		{
			questID = 4903,
			name = "Warlord's Command",
			level = 60,
			requiredLevel = 55,
			faction = "Horde",
			endMap = {
				mapID = 1418,
				x = 0.058,
				y = 0.475,
			},
			objective = "Slay Highlord Omokk, War Master Voone, and Overlord Wyrmthalak. Recover Important Blackrock Documents. Return to Warlord Goretooth in Kargath when the mission has been accomplished.",
			turnin = "Warlord Goretooth, Badlands",
			rewards = {
				xp = 8300,
				money = 18000,
				items = {
					{
						itemID = 13958,
						name = "Wyrmthalak's Shackles",
					},
					{
						itemID = 13959,
						name = "Omokk's Girth Restrainer",
					},
					{
						itemID = 13961,
						name = "Halycon's Muzzle",
					},
					{
						itemID = 13962,
						name = "Vosh'gajin's Strand",
					},
					{
						itemID = 13963,
						name = "Voone's Vice Grips",
					},
				},
				choice = true,
			},
		},
	},
})
