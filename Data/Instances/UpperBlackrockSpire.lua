-- Upper Blackrock Spire: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "UpperBlackrockSpire",
	instanceID = 229,
	kind = "dungeon",
	name = "Upper Blackrock Spire",
	levelMin = 59,
	levelMax = 60,
	location = "Blackrock Mountain",
	description = "The top of the spire, where Warchief Rend Blackhand and General Drakkisath command the black dragonflight's armies.",
	buttonArt = {
		"Interface\\Glues\\LoadingScreens\\LoadScreenBlackrockSpire",
		"Interface\\Glues\\LoadingScreens\\LoadScreenBlackRockSpire",
	},
	buttonImage = {
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-UpperBlackrockSpire",
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-BlackrockSpire",
	},
	loreImage = {
		"Interface\\EncounterJournal\\UI-EJ-LOREBG-UpperBlackrockSpire",
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
		["Dragonspire Hall"] = true,
		["The Rookery"] = true,
		["Blackrock Stadium"] = true,
	},
	map = {
		entrance = {
			x = 0.372,
			y = 0.325,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\UpperBlackrockSpire",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\UpperBlackrockSpire1",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\UpperBlackrockSpire2",
				artRight = 0.9785,
				artBottom = 0.6523,
			},
		},
	},
	floorNames = { "Dragonspire Hall", "The Rookery", "Hall of Blackhand" },
	bosses = {
		{
			name = "Pyroguard Emberseer",
			displayID = 2172,
			level = 60,
			order = 1,
			loot = {
				{
					itemID = 16672,
					name = "Gauntlets of Elements",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 12929,
					name = "Emberfury Talisman",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 12927,
					name = "Truestrike Shoulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 12905,
					name = "Wildfire Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12926,
					name = "Flaming Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 23320,
					name = "Tablet of Flame Shock VI",
					slot = "Book",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.302,
				y = 0.269,
				floor = 2,
			},
		},
		{
			name = "Jed Runewatcher",
			displayID = 9686,
			level = 59,
			rare = true,
			order = 2,
			loot = {
				{
					itemID = 12604,
					name = "Starfire Tiara",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 12930,
					name = "Briarwood Reed",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 12605,
					name = "Serpentine Skuller",
					slot = "Ranged, Wand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.35,
				y = 0.255,
				floor = 3,
			},
		},
		{
			name = "Gyth",
			displayID = 9806,
			level = 62,
			order = 3,
			loot = {
				{
					itemID = 12871,
					name = "Chromatic Carapace",
					slot = "Junk",
					quality = 4,
				},
				{
					itemID = 16669,
					name = "Pauldrons of Elements",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 22225,
					name = "Dragonskin Cowl",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 12960,
					name = "Tribal War Feathers",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 12953,
					name = "Dragoneye Coif",
					slot = "Head, Mail",
					quality = 3,
				},
				{
					itemID = 12952,
					name = "Gyth's Skull",
					slot = "Head, Plate",
					quality = 3,
				},
				{
					itemID = 13522,
					name = "Recipe: Flask of Chromatic Resistance",
					slot = "Alchemy",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.487,
				y = 0.228,
				floor = 3,
			},
		},
		{
			name = "The Beast",
			displayID = 10193,
			level = 62,
			order = 4,
			loot = {
				{
					itemID = 12731,
					name = "Pristine Hide of the Beast",
					slot = "Junk",
					quality = 4,
				},
				{
					itemID = 16729,
					name = "Lightforge Spaulders",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 12967,
					name = "Bloodmoon Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12968,
					name = "Frostweaver Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12966,
					name = "Blackmist Armguards",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 12965,
					name = "Spiritshroud Leggings",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 12963,
					name = "Blademaster Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 12964,
					name = "Tristam Legguards",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 22311,
					name = "Ironweave Boots",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 12709,
					name = "Pip's Skinner",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 12969,
					name = "Seeping Willow",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 24101,
					name = "Book of Ferocious Bite V",
					slot = "Book",
					quality = 3,
				},
				{
					itemID = 19227,
					name = "Ace of Beasts",
					slot = "Quest",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.644,
				y = 0.313,
				floor = 3,
			},
		},
		{
			name = "Solakar Flamewreath",
			displayID = 9581,
			level = 60,
			order = 5,
			loot = {
				{
					itemID = 16695,
					name = "Devout Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 12609,
					name = "Polychromatic Visionwrap",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 12603,
					name = "Nightbrace Tunic",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 12589,
					name = "Dustfeather Sash",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 12606,
					name = "Crystallized Girdle",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 18657,
					name = "Schematic: Hyper-Radiant Flame Reflector",
					slot = "Engineering",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.381,
				y = 0.379,
				floor = 2,
			},
		},
		{
			name = "Goraluk Anvilcrack",
			displayID = 10222,
			level = 61,
			order = 6,
			loot = {
				{
					itemID = 13502,
					name = "Handcrafted Mastersmith Girdle",
					slot = "Waist, Plate",
					quality = 3,
				},
				{
					itemID = 13498,
					name = "Handcrafted Mastersmith Leggings",
					slot = "Legs, Plate",
					quality = 3,
				},
				{
					itemID = 18047,
					name = "Flame Walkers",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 18048,
					name = "Mastersmith's Hammer",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 12834,
					name = "Plans: Arcanite Champion",
					slot = "Blacksmithing",
					quality = 3,
				},
				{
					itemID = 12837,
					name = "Plans: Masterwork Stormhammer",
					slot = "Blacksmithing",
					quality = 3,
				},
				{
					itemID = 18779,
					name = "Bottom Half of Advanced Armorsmithing: Volume I",
					slot = "Quest",
					quality = 3,
				},
				{
					itemID = 12806,
					name = "Unforged Rune Covered Breastplate",
					slot = "Quest",
					quality = 3,
				},
				{
					itemID = 12696,
					name = "Plans: Demon Forged Breastplate",
					slot = "Blacksmithing",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.298,
				y = 0.255,
				floor = 3,
			},
		},
		{
			name = "Warchief Rend Blackhand",
			displayID = 9778,
			level = 62,
			order = 7,
			loot = {
				{
					itemID = 12590,
					name = "Felstriker",
					slot = "One-Hand, Dagger",
					quality = 4,
				},
				{
					itemID = 16733,
					name = "Spaulders of Valor",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 12587,
					name = "Eye of Rend",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 12588,
					name = "Bonespike Shoulder",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 12936,
					name = "Battleborn Armbraces",
					slot = "Wrist, Plate",
					quality = 3,
				},
				{
					itemID = 18104,
					name = "Feralsurge Girdle",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 12935,
					name = "Warmaster Legguards",
					slot = "Legs, Plate",
					quality = 3,
				},
				{
					itemID = 18102,
					name = "Dragonrider Boots",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 22247,
					name = "Faith Healer's Boots",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 18103,
					name = "Band of Rumination",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 12940,
					name = "Dal'Rend's Sacred Charge",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12939,
					name = "Dal'Rend's Tribal Guardian",
					slot = "Off Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12583,
					name = "Blackhand Doomsaw",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.487,
				y = 0.277,
				floor = 3,
			},
		},
		{
			name = "General Drakkisath",
			displayID = 10115,
			level = 62,
			order = 8,
			loot = {
				{
					itemID = 12592,
					name = "Blackblade of Shahram",
					slot = "Two-Hand, Sword",
					quality = 4,
				},
				{
					itemID = 22267,
					name = "Spellweaver's Turban",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 13141,
					name = "Tooth of Gnarr",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 22269,
					name = "Shadow Prowler's Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 13142,
					name = "Brigam Girdle",
					slot = "Waist, Plate",
					quality = 3,
				},
				{
					itemID = 13098,
					name = "Painweaver Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 22268,
					name = "Draconic Infused Emblem",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 22253,
					name = "Tome of the Lost",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 12602,
					name = "Draconian Deflector",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 15730,
					name = "Pattern: Red Dragonscale Breastplate",
					slot = "Leatherworking",
					quality = 3,
				},
				{
					itemID = 13519,
					name = "Recipe: Flask of the Titans",
					slot = "Alchemy",
					quality = 2,
				},
				{
					itemID = 16690,
					name = "Devout Robe",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 16688,
					name = "Magister's Robes",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 16700,
					name = "Dreadmist Robe",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 16721,
					name = "Shadowcraft Tunic",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 16706,
					name = "Wildheart Vest",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 16674,
					name = "Beaststalker's Tunic",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 16666,
					name = "Vest of Elements",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 16726,
					name = "Lightforge Breastplate",
					slot = "Chest, Plate",
					quality = 3,
				},
				{
					itemID = 16730,
					name = "Breastplate of Valor",
					slot = "Chest, Plate",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.351,
				y = 0.502,
				floor = 3,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 24102,
					name = "Manual of Eviscerate IX",
					slot = "Book",
					quality = 3,
				},
				{
					itemID = 13260,
					name = "Wind Dancer Boots",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 16696,
					name = "Devout Belt",
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
					itemID = 16681,
					name = "Beaststalker's Bindings",
					slot = "Wrist, Mail",
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
					itemID = 16735,
					name = "Bracers of Valor",
					slot = "Wrist, Plate",
					quality = 3,
				},
				{
					itemID = 16247,
					name = "Formula: Enchant 2H Weapon - Superior Impact",
					slot = "Enchanting",
					quality = 2,
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
			questID = 6502,
			name = "Drakefire Amulet",
			level = 60,
			requiredLevel = 50,
			faction = "Alliance",
			startMap = {
				mapID = 1452,
				x = 0.545,
				y = 0.512,
			},
			endMap = {
				mapID = 1452,
				x = 0.545,
				y = 0.512,
			},
			objective = "You must retrieve the Blood of the Black Dragon Champion from General Drakkisath. Drakkisath can be found in his throne room behind the Halls of Ascension in Blackrock Spire.",
			pickup = "Haleh, Winterspring",
			turnin = "Haleh, Winterspring",
			rewards = {
				xp = 8300,
				items = {
					{
						itemID = 16309,
						name = "Drakefire Amulet",
					},
				},
			},
			prerequisites = {
				{
					questID = 6501,
					name = "The Dragon's Eye",
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
			questID = 5102,
			name = "General Drakkisath's Demise",
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
			objective = "Travel to Blackrock Spire and destroy General Drakkisath. Return to Marshal Maxwell when the job is done.",
			pickup = "Marshal Maxwell, Burning Steppes",
			turnin = "Marshal Maxwell, Burning Steppes",
			rewards = {
				xp = 9950,
				money = 27000,
				items = {
					{
						itemID = 13966,
						name = "Mark of Tyranny",
					},
					{
						itemID = 13968,
						name = "Eye of the Beast",
					},
					{
						itemID = 13965,
						name = "Blackhand's Breadth",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 5089,
					name = "General Drakkisath's Command",
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
			questID = 6602,
			name = "Blood of the Black Dragon Champion",
			level = 60,
			requiredLevel = 55,
			faction = "Horde",
			startMap = {
				mapID = 1444,
				x = 0.464,
				y = 0.182,
			},
			endMap = {
				mapID = 1444,
				x = 0.464,
				y = 0.182,
			},
			objective = "Travel to Blackrock Spire and slay General Drakkisath. Gather his blood and return it to Rexxar.",
			pickup = "Rexxar, Feralas",
			turnin = "Rexxar, Feralas",
			rewards = {
				xp = 9950,
				items = {
					{
						itemID = 16309,
						name = "Drakefire Amulet",
					},
				},
			},
			prerequisites = {
				{
					questID = 6601,
					name = "Ascension...",
				},
			},
		},
		{
			questID = 4974,
			name = "For The Horde!",
			level = 60,
			requiredLevel = 55,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.317,
				y = 0.378,
			},
			endMap = {
				mapID = 1454,
				x = 0.317,
				y = 0.378,
			},
			objective = "Travel to Blackrock Spire and slay Warchief Rend Blackhand. Take his head and return to Orgrimmar.",
			pickup = "Thrall, Orgrimmar",
			turnin = "Thrall, Orgrimmar",
			rewards = {
				xp = 9950,
				money = 27000,
				items = {
					{
						itemID = 13966,
						name = "Mark of Tyranny",
					},
					{
						itemID = 13968,
						name = "Eye of the Beast",
					},
					{
						itemID = 13965,
						name = "Blackhand's Breadth",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 4941,
					name = "Eitrigg's Wisdom",
				},
			},
		},
		{
			questID = 4768,
			name = "The Darkstone Tablet",
			level = 60,
			requiredLevel = 57,
			faction = "Horde",
			startMap = {
				mapID = 1418,
				x = 0.029,
				y = 0.478,
			},
			endMap = {
				mapID = 1418,
				x = 0.029,
				y = 0.478,
			},
			objective = "Bring the Darkstone Tablet to Shadow Mage Vivian Lagrave in Kargath.",
			pickup = "Shadowmage Vivian Lagrave, Badlands",
			turnin = "Shadowmage Vivian Lagrave, Badlands",
			rewards = {
				xp = 8300,
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
					questID = 4769,
					name = "Vivian Lagrave and the Darkstone Tablet",
				},
			},
		},
	},
})
