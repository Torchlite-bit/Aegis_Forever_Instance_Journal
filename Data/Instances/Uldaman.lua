-- Uldaman: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "Uldaman",
	instanceID = 70,
	kind = "dungeon",
	name = "Uldaman",
	levelMin = 41,
	levelMax = 51,
	location = "Badlands",
	description = "A Titan vault buried under the Badlands, where Dark Iron dwarves and troggs dig for the secrets of the earthen, and the stone keeper Archaedas guards the deepest hall.",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenUldaman" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-Uldaman" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-Uldaman" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1418,
		world = { 0, -6092, -3179.4 },
	},
	map = {
		entrance = {
			x = 0.679,
			y = 0.724,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\Uldaman",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 230,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\Uldaman1",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 231,
			},
		},
	},
	floorNames = { "Hall of the Keepers", "Khaz'Goroth's Seat" },
	bosses = {
		{
			name = "Eric \"The Swift\"",
			displayID = 5708,
			level = 40,
			order = 1,
			loot = {
				{
					itemID = 9394,
					name = "Horned Viking Helmet",
					slot = "Head, Plate",
					quality = 3,
				},
				{
					itemID = 9398,
					name = "Worn Running Boots",
					slot = "Feet, Leather",
					quality = 2,
				},
				{
					itemID = 2459,
					name = "Swiftness Potion",
					slot = "Potions",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.601,
				y = 0.91,
				floor = 1,
			},
		},
		{
			name = "Olaf",
			displayID = 5709,
			level = 40,
			order = 2,
			loot = {
				{
					itemID = 9404,
					name = "Olaf's All Purpose Shield",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 9403,
					name = "Battered Viking Shield",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 1177,
					name = "Oil of Olaf",
					slot = "Other",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.586,
				y = 0.957,
				floor = 1,
			},
		},
		{
			name = "Ironaya",
			displayID = 6089,
			level = 40,
			order = 3,
			loot = {
				{
					itemID = 9409,
					name = "Ironaya's Bracers",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 9407,
					name = "Stoneweaver Leggings",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 9408,
					name = "Ironshod Bludgeon",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.37,
				y = 0.734,
				floor = 1,
			},
		},
		{
			name = "Ancient Stone Keeper",
			displayID = 10798,
			level = 44,
			order = 4,
			loot = {
				{
					itemID = 9410,
					name = "Cragfists",
					slot = "Hands, Plate",
					quality = 3,
				},
				{
					itemID = 9411,
					name = "Rockshard Pauldrons",
					slot = "Shoulder, Mail",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.475,
				y = 0.45,
				floor = 1,
			},
		},
		{
			name = "Grimlok",
			displayID = 11165,
			level = 45,
			order = 5,
			loot = {
				{
					itemID = 9415,
					name = "Grimlok's Tribal Vestments",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 9416,
					name = "Grimlok's Charge",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 9414,
					name = "Oilskin Leggings",
					slot = "Legs, Leather",
					quality = 2,
				},
				{
					itemID = 7670,
					name = "Shattered Necklace Sapphire",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.22,
				y = 0.257,
				floor = 1,
			},
		},
		{
			name = "Baelog",
			displayID = 5710,
			level = 41,
			order = 6,
			loot = {
				{
					itemID = 9401,
					name = "Nordic Longshank",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 9399,
					name = "Precision Arrow",
					slot = "Ammo, Arrow",
					quality = 2,
				},
				{
					itemID = 9400,
					name = "Baelog's Shortbow",
					slot = "Ranged, Bow",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.571,
				y = 0.91,
				floor = 1,
			},
		},
		{
			name = "Revelosh",
			displayID = 5945,
			level = 40,
			order = 7,
			loot = {
				{
					itemID = 9389,
					name = "Revelosh's Spaulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 9388,
					name = "Revelosh's Armguards",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 9390,
					name = "Revelosh's Gloves",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 9387,
					name = "Revelosh's Boots",
					slot = "Feet, Plate",
					quality = 3,
				},
				{
					itemID = 7741,
					name = "The Shaft of Tsol",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.533,
				y = 0.727,
				floor = 1,
			},
		},
		{
			name = "Obsidian Sentinel",
			displayID = 5285,
			level = 42,
			order = 8,
			loot = {
				{
					itemID = 8053,
					name = "Obsidian Power Source",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.288,
				y = 0.602,
				floor = 1,
			},
		},
		{
			name = "Galgann Firehammer",
			displayID = 6059,
			level = 45,
			order = 9,
			loot = {
				{
					itemID = 11310,
					name = "Flameseer Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 9412,
					name = "Galgann's Fireblaster",
					slot = "Ranged, Gun",
					quality = 3,
				},
				{
					itemID = 11311,
					name = "Emberscale Cape",
					slot = "Back, Cloth",
					quality = 2,
				},
				{
					itemID = 9419,
					name = "Galgann's Firehammer",
					slot = "One-Hand, Mace",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.268,
				y = 0.326,
				floor = 1,
			},
		},
		{
			name = "Archaedas",
			displayID = 5988,
			level = 47,
			order = 10,
			loot = {
				{
					itemID = 11118,
					name = "Archaedic Stone",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 9413,
					name = "The Rockpounder",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 9418,
					name = "Stoneslayer",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.555,
				y = 0.504,
				floor = 2,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 9431,
					name = "Papal Fez",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 9429,
					name = "Miner's Hat of the Deep",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 9420,
					name = "Adventurer's Pith Helmet",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 9430,
					name = "Spaulders of a Lost Age",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 9397,
					name = "Energy Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 9406,
					name = "Spirewind Fetter",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 9428,
					name = "Unearthed Bands",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 9432,
					name = "Skullplate Bracers",
					slot = "Wrist, Plate",
					quality = 3,
				},
				{
					itemID = 9396,
					name = "Legguards of the Vault",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 9393,
					name = "Beacon of Hope",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 7666,
					name = "Shattered Necklace",
					slot = "Quest",
					quality = 2,
				},
				{
					itemID = 9381,
					name = "Earthen Rod",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 9426,
					name = "Monolithic Bow",
					slot = "Ranged, Bow",
					quality = 3,
				},
				{
					itemID = 9422,
					name = "Shadowforge Bushmaster",
					slot = "Ranged, Gun",
					quality = 3,
				},
				{
					itemID = 9465,
					name = "Digmaster 5000",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 9384,
					name = "Stonevault Shiv",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 9386,
					name = "Excavator's Brand",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 9427,
					name = "Stonevault Bonebreaker",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 9392,
					name = "Annealed Blade",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 9424,
					name = "Ginn-su Sword",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 9383,
					name = "Obsidian Cleaver",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 9425,
					name = "Pendulum of Doom",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 9423,
					name = "The Jackhammer",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 9391,
					name = "The Shoveler",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
			},
		},
	},
	quests = {
		{
			questID = 2418,
			name = "Power Stones",
			level = 36,
			requiredLevel = 30,
			faction = "Both",
			startMap = {
				mapID = 1418,
				x = 0.424,
				y = 0.529,
			},
			endMap = {
				mapID = 1418,
				x = 0.424,
				y = 0.529,
			},
			objective = "Bring 8 Dentrium Power Stones and 8 An'Alleum Power Stones to Rigglefuzz in the Badlands.",
			pickup = "Rigglefuzz, Badlands",
			turnin = "Rigglefuzz, Badlands",
			rewards = {
				xp = 3500,
				items = {
					{
						itemID = 9522,
						name = "Energized Stone Circle",
					},
					{
						itemID = 10358,
						name = "Duracin Bracers",
					},
					{
						itemID = 10359,
						name = "Everlast Boots",
					},
					{
						itemID = 270055,
						name = "Charged Leather Bracers",
					},
				},
				choice = true,
			},
		},
		{
			questID = 709,
			name = "Solution to Doom",
			level = 40,
			requiredLevel = 30,
			faction = "Both",
			startMap = {
				mapID = 1418,
				x = 0.514,
				y = 0.769,
			},
			endMap = {
				mapID = 1418,
				x = 0.514,
				y = 0.769,
			},
			objective = "Bring the Tablet of Ryun'eh to Theldurin the Lost.",
			pickup = "Theldurin the Lost, Badlands",
			turnin = "Theldurin the Lost, Badlands",
			rewards = {
				xp = 3150,
				items = {
					{
						itemID = 4746,
						name = "Doomsayer's Robe",
					},
					{
						itemID = 270074,
						name = "Doomcaller's Pants",
					},
					{
						itemID = 270075,
						name = "Fists of Impending Doom",
					},
				},
				choice = true,
			},
		},
		{
			questID = 17,
			name = "Uldaman Reagent Run",
			level = 42,
			requiredLevel = 38,
			faction = "Alliance",
			startMap = {
				mapID = 1432,
				x = 0.371,
				y = 0.494,
			},
			endMap = {
				mapID = 1432,
				x = 0.371,
				y = 0.494,
			},
			objective = "Bring 12 Magenta Fungus Caps to Ghak Healtouch in Thelsamar.",
			pickup = "Ghak Healtouch, Loch Modan",
			turnin = "Ghak Healtouch, Loch Modan",
			rewards = {
				xp = 3450,
				money = 5500,
			},
			prerequisites = {
				{
					questID = 2500,
					name = "Badlands Reagent Run",
				},
			},
		},
		{
			questID = 704,
			name = "Agmond's Fate",
			level = 38,
			requiredLevel = 30,
			faction = "Alliance",
			startMap = {
				mapID = 1432,
				x = 0.659,
				y = 0.656,
			},
			endMap = {
				mapID = 1432,
				x = 0.659,
				y = 0.656,
			},
			objective = "Bring 4 Carved Stone Urns to Prospector Ironband in Loch Modan.",
			pickup = "Prospector Ironband, Loch Modan",
			turnin = "Prospector Ironband, Loch Modan",
			rewards = {
				xp = 2850,
				items = {
					{
						itemID = 4980,
						name = "Prospector Gloves",
					},
					{
						itemID = 270059,
						name = "Restorer's Fine Gloves",
					},
					{
						itemID = 270060,
						name = "Excavator Gauntlets",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 739,
					name = "Murdaloc",
				},
			},
		},
		{
			questID = 1360,
			name = "Reclaimed Treasures",
			level = 43,
			requiredLevel = 33,
			faction = "Alliance",
			startMap = {
				mapID = 1426,
				x = 0.63,
				y = 0.226,
			},
			endMap = {
				mapID = 1426,
				x = 0.63,
				y = 0.226,
			},
			objective = "Get Krom Stoutarm's treasured possession from his chest in the North Common Hall of Uldaman, and bring it to him in Ironforge.",
			pickup = "Krom Stoutarm, Dun Morogh",
			turnin = "Krom Stoutarm, Dun Morogh",
			rewards = {
				xp = 3600,
				money = 6000,
			},
		},
		{
			questID = 722,
			name = "Amulet of Secrets",
			level = 40,
			requiredLevel = 35,
			faction = "Alliance",
			startMap = {
				mapID = 1432,
				x = 0.373,
				y = 0.858,
			},
			endMap = {
				mapID = 1432,
				x = 0.373,
				y = 0.858,
			},
			objective = "Find Hammertoe's Amulet and return it to him in Uldaman.",
			pickup = "Hammertoe Grez, Loch Modan",
			turnin = "Hammertoe Grez, Loch Modan",
			rewards = {
				xp = 3150,
			},
			prerequisites = {
				{
					questID = 721,
					name = "A Sign of Hope",
				},
			},
		},
		{
			questID = 2240,
			name = "The Hidden Chamber",
			level = 40,
			requiredLevel = 35,
			faction = "Alliance",
			endMap = {
				mapID = 1426,
				x = 0.631,
				y = 0.23,
			},
			objective = "Read Baelog's Journal, explore the hidden chamber, then report to Prospector Stormpike.",
			turnin = "Prospector Stormpike, Dun Morogh",
			rewards = {
				xp = 3900,
				items = {
					{
						itemID = 9626,
						name = "Dwarven Charge",
					},
					{
						itemID = 9627,
						name = "Explorer's League Lodestar",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 2398,
					name = "The Lost Dwarves",
				},
			},
		},
		{
			questID = 1139,
			name = "The Lost Tablets of Will",
			level = 45,
			requiredLevel = 35,
			faction = "Alliance",
			startMap = {
				mapID = 1426,
				x = 0.635,
				y = 0.226,
			},
			endMap = {
				mapID = 1426,
				x = 0.635,
				y = 0.226,
			},
			objective = "Find the Tablet of Will, and return them to Advisor Belgrum in Ironforge.",
			pickup = "Advisor Belgrum, Dun Morogh",
			turnin = "Advisor Belgrum, Dun Morogh",
			rewards = {
				xp = 5850,
				money = 13000,
				items = {
					{
						itemID = 6723,
						name = "Medal of Courage",
					},
				},
			},
			prerequisites = {
				{
					questID = 762,
					name = "An Ambassador of Evil",
				},
			},
		},
		{
			questID = 2199,
			name = "Lore for a Price",
			level = 41,
			requiredLevel = 37,
			faction = "Alliance",
			startMap = {
				mapID = 1426,
				x = 0.569,
				y = 0.217,
			},
			endMap = {
				mapID = 1426,
				x = 0.569,
				y = 0.217,
			},
			objective = "Bring five silver bars to Talvash del Kissel in Ironforge.",
			pickup = "Talvash del Kissel, Dun Morogh",
			turnin = "Talvash del Kissel, Dun Morogh",
			rewards = {
				xp = 2450,
			},
			prerequisites = {
				{
					questID = 2198,
					name = "The Shattered Necklace",
				},
			},
		},
		{
			questID = 2198,
			name = "The Shattered Necklace",
			level = 41,
			requiredLevel = 37,
			faction = "Alliance",
			endMap = {
				mapID = 1426,
				x = 0.569,
				y = 0.217,
			},
			objective = "Search for the original creator of the shattered necklace to learn of its potential value.",
			turnin = "Talvash del Kissel, Dun Morogh",
			rewards = {
				xp = 3300,
			},
		},
		{
			questID = 2201,
			name = "Find the Gems",
			level = 43,
			requiredLevel = 37,
			faction = "Alliance",
			objective = "Find the ruby, sapphire, and topaz that are scattered throughout Uldaman. Once acquired, contact Talvash del Kissel remotely by using the Phial of Scrying he previously gave you.",
			turnin = "Talvash's Scrying Bowl, inside the dungeon",
			rewards = {
				xp = 3600,
			},
			prerequisites = {
				{
					questID = 2200,
					name = "Back to Uldaman",
				},
			},
		},
		{
			questID = 2204,
			name = "Restoring the Necklace",
			level = 44,
			requiredLevel = 37,
			faction = "Alliance",
			endMap = {
				mapID = 1426,
				x = 0.569,
				y = 0.217,
			},
			objective = "Obtain a power source from the most powerful construct you can find in Uldaman, and deliver it to Talvash del Kissel in Ironforge.",
			turnin = "Talvash del Kissel, Dun Morogh",
			rewards = {
				xp = 925,
			},
			prerequisites = {
				{
					questID = 2361,
					name = "Restoring the Necklace",
				},
			},
		},
		{
			questID = 2361,
			name = "Restoring the Necklace",
			level = 44,
			requiredLevel = 37,
			faction = "Alliance",
			startMap = {
				mapID = 1426,
				x = 0.569,
				y = 0.217,
			},
			endMap = {
				mapID = 1426,
				x = 0.569,
				y = 0.217,
			},
			pickup = "Talvash del Kissel, Dun Morogh",
			turnin = "Talvash del Kissel, Dun Morogh",
			rewards = {
				xp = 5600,
				items = {
					{
						itemID = 7673,
						name = "Talvash's Enhancing Necklace",
					},
				},
			},
			prerequisites = {
				{
					questID = 2204,
					name = "Restoring the Necklace",
				},
			},
		},
		{
			questID = 2279,
			name = "The Platinum Discs",
			level = 47,
			requiredLevel = 40,
			faction = "Alliance",
			endMap = {
				mapID = 1426,
				x = 0.623,
				y = 0.241,
			},
			objective = "Take the miniature version of the Discs of Norgannon to the Explorers' League in Ironforge.",
			turnin = "High Explorer Magellas, Dun Morogh",
			rewards = {
				xp = 5250,
			},
			prerequisites = {
				{
					questID = 2439,
					name = "The Platinum Discs",
				},
			},
		},
		{
			questID = 2439,
			name = "The Platinum Discs",
			level = 47,
			requiredLevel = 40,
			faction = "Alliance",
			startMap = {
				mapID = 1426,
				x = 0.623,
				y = 0.241,
			},
			endMap = {
				mapID = 1426,
				x = 0.565,
				y = 0.306,
			},
			objective = "Take your reward voucher to Dinita Stonemantle in the Vault of Ironforge.",
			pickup = "High Explorer Magellas, Dun Morogh",
			turnin = "Dinita Stonemantle, Dun Morogh",
			rewards = {
				xp = 420,
				items = {
					{
						itemID = 9587,
						name = "Thawpelt Sack",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 2279,
					name = "The Platinum Discs",
				},
			},
		},
		{
			questID = 2342,
			name = "Reclaimed Treasures",
			level = 43,
			requiredLevel = 33,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.623,
				y = 0.486,
			},
			endMap = {
				mapID = 1458,
				x = 0.623,
				y = 0.486,
			},
			objective = "Get Patrick Garrett's family treasure from their family chest in the South Common Hall of Uldaman, and bring it to him in the Undercity.",
			pickup = "Patrick Garrett, Undercity",
			turnin = "Patrick Garrett, Undercity",
			rewards = {
				xp = 3600,
				money = 6000,
			},
		},
		{
			questID = 2283,
			name = "Necklace Recovery",
			level = 41,
			requiredLevel = 37,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.596,
				y = 0.365,
			},
			endMap = {
				mapID = 1454,
				x = 0.596,
				y = 0.365,
			},
			objective = "Look for a valuable necklace within the Uldaman dig site and bring it back to Dran Droffers in Orgrimmar. The necklace may be damaged.",
			pickup = "Dran Droffers, Orgrimmar",
			turnin = "Dran Droffers, Orgrimmar",
			rewards = {
				xp = 2450,
			},
		},
		{
			questID = 2338,
			name = "Translating the Journal",
			level = 42,
			requiredLevel = 37,
			faction = "Horde",
			startMap = {
				mapID = 1418,
				x = 0.024,
				y = 0.461,
			},
			endMap = {
				mapID = 1418,
				x = 0.024,
				y = 0.461,
			},
			objective = "Let Jarkal borrow the necklace. In exchange, he will translate the journal for you.",
			pickup = "Jarkal Mossmeld, Badlands",
			turnin = "Jarkal Mossmeld, Badlands",
			rewards = {
				xp = 350,
			},
			prerequisites = {
				{
					questID = 2318,
					name = "Translating the Journal",
				},
			},
		},
		{
			questID = 2340,
			name = "Deliver the Gems",
			level = 44,
			requiredLevel = 37,
			faction = "Horde",
			startMap = {
				mapID = 1418,
				x = 0.024,
				y = 0.461,
			},
			endMap = {
				mapID = 1454,
				x = 0.596,
				y = 0.365,
			},
			objective = "Deliver the Necklace and Gem Salvage to Dran Droffers in Orgrimmar.",
			pickup = "Jarkal Mossmeld, Badlands",
			turnin = "Dran Droffers, Orgrimmar",
			rewards = {
				xp = 1850,
				money = 12500,
			},
			prerequisites = {
				{
					questID = 2339,
					name = "Find the Gems and Power Source",
				},
			},
		},
		{
			questID = 2339,
			name = "Find the Gems and Power Source",
			level = 44,
			requiredLevel = 37,
			faction = "Horde",
			startMap = {
				mapID = 1418,
				x = 0.024,
				y = 0.461,
			},
			endMap = {
				mapID = 1418,
				x = 0.024,
				y = 0.461,
			},
			objective = "Recover all three gems and a power source for the necklace from Uldaman, and then bring them to Jarkal Mossmeld in Kargath. Jarkal believes a power source might be found on the strongest construct present in Uldaman.",
			pickup = "Jarkal Mossmeld, Badlands",
			turnin = "Jarkal Mossmeld, Badlands",
			rewards = {
				xp = 3750,
			},
			prerequisites = {
				{
					questID = 2338,
					name = "Translating the Journal",
				},
			},
		},
		{
			questID = 2341,
			name = "Necklace Recovery, Take 3",
			level = 44,
			requiredLevel = 37,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.596,
				y = 0.365,
			},
			endMap = {
				mapID = 1418,
				x = 0.024,
				y = 0.461,
			},
			objective = "Visit Jarkal Mossmeld in Kargath to see if he was successful.",
			pickup = "Dran Droffers, Orgrimmar",
			turnin = "Jarkal Mossmeld, Badlands",
			rewards = {
				xp = 5600,
				items = {
					{
						itemID = 7888,
						name = "Jarkal's Enhancing Necklace",
					},
				},
			},
			prerequisites = {
				{
					questID = 2340,
					name = "Deliver the Gems",
				},
			},
		},
		{
			questID = 2280,
			name = "The Platinum Discs",
			level = 47,
			requiredLevel = 40,
			faction = "Horde",
			endMap = {
				mapID = 1456,
				x = 0.344,
				y = 0.469,
			},
			objective = "Take the miniature version of the Discs of Norgannon to the one of the sages in Thunder Bluff.",
			turnin = "Sage Truthseeker, Thunder Bluff",
			rewards = {
				xp = 5250,
			},
			prerequisites = {
				{
					questID = 2440,
					name = "The Platinum Discs",
				},
			},
		},
		{
			questID = 2440,
			name = "The Platinum Discs",
			level = 47,
			requiredLevel = 40,
			faction = "Horde",
			startMap = {
				mapID = 1456,
				x = 0.344,
				y = 0.469,
			},
			endMap = {
				mapID = 1456,
				x = 0.466,
				y = 0.332,
			},
			objective = "Take the reward voucher to Bena Winterhoof in Thunder Bluff.",
			pickup = "Sage Truthseeker, Thunder Bluff",
			turnin = "Bena Winterhoof, Thunder Bluff",
			rewards = {
				xp = 420,
				items = {
					{
						itemID = 9587,
						name = "Thawpelt Sack",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 2280,
					name = "The Platinum Discs",
				},
			},
		},
	},
})
