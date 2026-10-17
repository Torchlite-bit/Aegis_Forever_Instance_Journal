-- The Deadmines: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "TheDeadmines",
	instanceID = 36,
	kind = "dungeon",
	name = "The Deadmines",
	levelMin = 17,
	levelMax = 26,
	location = "Moonbrook, Westfall",
	buttonArt = "Interface\\Glues\\LoadingScreens\\LoadScreenDeadmines",
	buttonImage = 522352,
	loreImage = 526404,
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.295,
			y = 0.135,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 291,
				tiles = "Interface\\WorldMap\\TheDeadmines\\TheDeadmines1_",
			},
			{
				uiMapID = 292,
				tiles = "Interface\\WorldMap\\TheDeadmines\\TheDeadmines2_",
			},
		},
		transitions = {
			{
				floor = 1,
				to = 2,
				x = 0.615,
				y = 0.61,
			},
		},
	},
	zoneEntrance = {
		mapID = 1436,
		x = 0.425,
		y = 0.717,
	},
	bosses = {
		{
			name = "Rhahk'Zor",
			npcID = 644,
			level = 19,
			displayID = 14403,
			loot = {
				{
					itemID = 872,
					name = "Rockslicer",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 5187,
					name = "Rhahk'Zor's Hammer",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 273289,
					name = "Ogre Loincloth",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 251362,
					name = "Plans: Protector's Gloves",
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
					itemID = 253906,
					name = "Pattern: Filigreed Flame Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 6561,
				},
			},
			mapPin = {
				x = 0.365,
				y = 0.61,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Miner Johnson",
			npcID = 3586,
			level = 19,
			description = "Sometimes found in the side passage after Rhahk'Zor.",
			rare = true,
			displayID = 556,
			loot = {
				{
					itemID = 5443,
					name = "Gold-plated Buckler",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 5444,
					name = "Miner's Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.535,
				y = 0.52,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Sneed's Shredder",
			npcID = 642,
			level = 20,
			displayID = 1269,
			loot = {
				{
					itemID = 1937,
					name = "Buzz Saw",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 2169,
					name = "Buzzer Blade",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 285292,
					name = "Dull Sawblade",
					slot = "Thrown",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.475,
				y = 0.865,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Sneed",
			npcID = 643,
			level = 20,
			displayID = 7125,
			loot = {
				{
					itemID = 5194,
					name = "Taskmaster Axe",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 5195,
					name = "Gold-flecked Gloves",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 273293,
					name = "Bandsaw Wristbands",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 273092,
					name = "Blueprint: Repair Bot",
					slot = "Engineering",
					quality = 2,
				},
				{
					itemID = 251360,
					name = "Plans: Veteran's Gloves",
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
					itemID = 253902,
					name = "Pattern: Filigreed Pristine Gown",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.535,
				y = 0.865,
				floor = 1,
			},
			order = 4,
		},
		{
			name = "Gilnid",
			npcID = 1763,
			level = 20,
			displayID = 7124,
			loot = {
				{
					itemID = 1156,
					name = "Lavishly Jeweled Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 5199,
					name = "Smelting Pants",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 273297,
					name = "Goblin Hammer",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 252777,
					name = "Pattern: Brawler's Leather Gloves",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252778,
					name = "Pattern: Trapper's Leather Gloves",
					slot = "Recipe, Leatherworking",
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
					itemID = 273086,
					name = "Blueprint: Anvil",
					slot = "Blueprint",
					quality = 2,
				},
				{
					itemID = 14166,
				},
			},
			mapPin = {
				x = 0.122,
				y = 0.755,
				floor = 2,
			},
			order = 5,
		},
		{
			name = "Mr. Smite",
			npcID = 646,
			level = 20,
			displayID = 2026,
			loot = {
				{
					itemID = 7230,
					name = "Smite's Mighty Hammer",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 5192,
					name = "Thief's Blade",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 5196,
					name = "Smite's Reaver",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 284715,
					name = "First Mate Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 251362,
					name = "Plans: Protector's Gloves",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252779,
					name = "Pattern: Defender's Leather Gloves",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252780,
					name = "Pattern: Totemic Leather Gloves",
					slot = "Recipe, Leatherworking",
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
			},
			mapPin = {
				x = 0.515,
				y = 0.17,
				floor = 2,
			},
			order = 6,
		},
		{
			name = "Captain Greenskin",
			npcID = 647,
			level = 20,
			displayID = 7113,
			loot = {
				{
					itemID = 5201,
					name = "Emberstone Staff",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 10403,
					name = "Blackened Defias Belt",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 5200,
					name = "Impaling Harpoon",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.575,
				y = 0.35,
				floor = 2,
			},
			order = 7,
		},
		{
			name = "Edwin VanCleef",
			npcID = 639,
			level = 21,
			displayID = 2029,
			loot = {
				{
					itemID = 5193,
					name = "Cape of the Brotherhood",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 5202,
					name = "Corsair's Overshirt",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 10399,
					name = "Blackened Defias Armor",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 5191,
					name = "Cruel Barb",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 2874,
					name = "An Unsent Letter",
					slot = "Quest Item",
					quality = 1,
				},
				{
					itemID = 252799,
					name = "Pattern: Trapper's Leather Hood",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252800,
					name = "Pattern: Defender's Leather Hood",
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
					itemID = 253938,
					name = "Pattern: Filigreed Pristine Leggings",
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
				x = 0.605,
				y = 0.452,
				floor = 2,
			},
			order = 8,
		},
		{
			name = "Cookie",
			npcID = 645,
			level = 20,
			displayID = 1305,
			loot = {
				{
					itemID = 5198,
					name = "Cookie's Stirring Rod",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 5197,
					name = "Cookie's Tenderizer",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 273298,
					name = "Lookie's Spyglass",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 251360,
					name = "Plans: Veteran's Gloves",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252778,
					name = "Pattern: Trapper's Leather Gloves",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 252779,
					name = "Pattern: Defender's Leather Gloves",
					slot = "Recipe, Leatherworking",
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
					itemID = 273102,
					name = "Blueprint: Cookie's Feast",
					slot = "Blueprint",
					quality = 2,
				},
				{
					itemID = 8490,
				},
			},
			mapPin = {
				x = 0.665,
				y = 0.43,
				floor = 2,
			},
			order = 9,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 10402,
					name = "Blackened Defias Boots",
					slot = "Feet, Leather",
					quality = 3,
					droppedBy = "Defias Strip Miner",
				},
				{
					itemID = 10401,
					name = "Blackened Defias Gloves",
					slot = "Hands, Leather",
					quality = 3,
					droppedBy = "Defias Overseer / Defias Taskmaster",
				},
				{
					itemID = 10400,
					name = "Blackened Defias Leggings",
					slot = "Legs, Leather",
					quality = 3,
					droppedBy = "Defias Overseer / Defias Taskmaster",
				},
				{
					itemID = 1951,
					name = "Blackwater Cutlass",
					slot = "One-Hand, Sword",
					quality = 3,
					droppedBy = "Defias Pirate / Defias Squallshaper",
				},
				{
					itemID = 1929,
					name = "Silk-threaded Trousers",
					slot = "Legs, Cloth",
					quality = 3,
					droppedBy = "Defias Evoker / Defias Wizard",
				},
				{
					itemID = 1934,
					name = "Stonemason Trousers",
					slot = "Legs, Leather",
					quality = 3,
					droppedBy = "Defias Blackguard",
				},
				{
					itemID = 1936,
					name = "Goblin Screwdriver",
					slot = "One-Hand, Dagger",
					quality = 3,
					droppedBy = "Goblin Engineer",
				},
				{
					itemID = 8492,
				},
			},
		},
	},
	quests = {
		{
			questID = 214,
			name = "Red Silk Bandanas",
			level = 17,
			requiredLevel = 14,
			faction = "Alliance",
			startMap = {
				mapID = 1436,
				x = 0.5667,
				y = 0.4735,
				label = "Scout Riell",
			},
			objective = "Collect 10 Red Silk Bandanas from Defias inside the Deadmines.",
			pickup = "Scout Riell, Sentinel Hill tower, Westfall",
			turnin = "Scout Riell, Sentinel Hill tower, Westfall",
			note = "Needs the Defias Brotherhood escort step first.",
			rewards = {
				xp = 1250,
				reputation = {
					{
						faction = "Stormwind",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 2074,
						name = "Solid Shortblade",
						quality = 2,
					},
					{
						itemID = 2089,
						name = "Scrimshaw Dagger",
						quality = 2,
					},
					{
						itemID = 6094,
						name = "Piercing Axe",
						quality = 2,
					},
					{
						itemID = 270005,
						name = "Monastic Hammer",
						quality = 2,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 65,
					name = "The Defias Brotherhood",
				},
				{
					questID = 132,
					name = "The Defias Brotherhood",
				},
				{
					questID = 135,
					name = "The Defias Brotherhood",
				},
				{
					questID = 141,
					name = "The Defias Brotherhood",
				},
				{
					questID = 142,
					name = "The Defias Brotherhood",
				},
				{
					questID = 155,
					name = "The Defias Brotherhood",
				},
			},
		},
		{
			questID = 168,
			name = "Collecting Memories",
			level = 18,
			requiredLevel = 14,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.668,
				y = 0.438,
				label = "Wilder Thistlenettle",
			},
			objective = "Collect 4 Miners' Union Cards from undead miners in the tunnels outside the instance.",
			pickup = "Wilder Thistlenettle, the Dwarven District, Stormwind",
			turnin = "Wilder Thistlenettle, Stormwind",
			note = "The undead tunnel branches off before the portal.",
			rewards = {
				xp = 1350,
				reputation = {
					{
						faction = "Ironforge",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 2037,
						name = "Tunneler's Boots",
						quality = 2,
					},
					{
						itemID = 2036,
						name = "Dusty Mining Gloves",
						quality = 2,
					},
					{
						itemID = 270007,
						name = "Worn Miner's Waistcord",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 92753,
			name = "Destruction in Deadmines",
			level = 18,
			requiredLevel = 9,
			faction = "Alliance",
			objective = "Place the explosives beside the forge in the Deadmines.",
			pickup = "Use the Extra-Destructive Explosives quest-start item.",
			turnin = "Alba Fairmoon, Sentinel Hill inn, Westfall",
			rewards = {
				xp = 1350,
				reputation = {
					{
						faction = "Stormwind",
						amount = 50,
					},
				},
			},
			prerequisites = {
				{
					questID = 92742,
					name = "Testing the Wells",
				},
				{
					questID = 92744,
					name = "Murloc Gills",
				},
				{
					questID = 92745,
					name = "The State of the Mines",
				},
				{
					questID = 92747,
					name = "Moonbrook Espionage",
				},
				{
					questID = 92748,
					name = "Explosive Consultation",
				},
				{
					questID = 92749,
					name = "A Dynamite Plan",
				},
				{
					questID = 92750,
					name = "Detonation at a Distance",
				},
				{
					questID = 92751,
					name = "Detonation at a Distance",
				},
				{
					questID = 92752,
					name = "Explosive Consultation",
				},
				{
					questID = 92753,
					name = "Destruction in Deadmines",
				},
				{
					questID = 92819,
					name = "Destruction in Deadmines",
				},
			},
		},
		{
			questID = 167,
			name = "Oh Brother...",
			level = 20,
			requiredLevel = 15,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.668,
				y = 0.438,
				label = "Wilder Thistlenettle",
			},
			objective = "Recover Thistlenettle's Badge from Foreman Thistlenettle in the undead side tunnel.",
			pickup = "Wilder Thistlenettle, the Dwarven District, Stormwind",
			turnin = "Wilder Thistlenettle, Stormwind",
			note = "The foreman is in the tunnels before the portal into the dungeon.",
			rewards = {
				xp = 1550,
				reputation = {
					{
						faction = "Ironforge",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 1893,
						name = "Miner's Revenge",
						quality = 2,
					},
					{
						itemID = 270012,
						name = "Miner's Workgloves",
						quality = 2,
					},
					{
						itemID = 270013,
						name = "Miner's Workboots",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 2040,
			name = "Underground Assault",
			level = 20,
			requiredLevel = 15,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.63,
				y = 0.34,
				label = "Shoni the Shilent — Dwarven District, Stormwind",
			},
			objective = "Recover the Gnoam Sprecklesprocket from Sneed's Shredder.",
			pickup = "Shoni the Shilent, the Dwarven District, Stormwind",
			turnin = "Shoni the Shilent, Stormwind",
			note = "Comes after Speak with Shoni.",
			rewards = {
				xp = 1550,
				reputation = {
					{
						faction = "Stormwind",
						amount = 100,
					},
					{
						faction = "Gnomeregan Exiles",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 7606,
						name = "Polar Gauntlets",
						quality = 2,
					},
					{
						itemID = 7607,
						name = "Sable Wand",
						quality = 2,
					},
					{
						itemID = 270015,
						name = "Bravo's Armbands",
						quality = 2,
					},
					{
						itemID = 270016,
						name = "Dreamer's Leggings",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 166,
			name = "The Defias Brotherhood",
			level = 22,
			requiredLevel = 14,
			faction = "Alliance",
			startMap = {
				mapID = 1436,
				x = 0.564,
				y = 0.475,
				label = "Gryan Stoutmantle",
			},
			objective = "Defeat Edwin VanCleef and collect his head.",
			pickup = "Gryan Stoutmantle, Sentinel Hill tower, Westfall (56.4, 47.5)",
			turnin = "Gryan Stoutmantle, Sentinel Hill, Westfall",
			note = "The last dungeon step of the Defias Brotherhood chain: do the earlier steps first.",
			rewards = {
				xp = 2600,
				reputation = {
					{
						faction = "Stormwind",
						amount = 200,
					},
				},
				items = {
					{
						itemID = 6087,
						name = "Chausses of Westfall",
						quality = 3,
					},
					{
						itemID = 2041,
						name = "Tunic of Westfall",
						quality = 3,
					},
					{
						itemID = 2042,
						name = "Staff of Westfall",
						quality = 3,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 65,
					name = "The Defias Brotherhood",
				},
				{
					questID = 132,
					name = "The Defias Brotherhood",
				},
				{
					questID = 135,
					name = "The Defias Brotherhood",
				},
				{
					questID = 141,
					name = "The Defias Brotherhood",
				},
				{
					questID = 142,
					name = "The Defias Brotherhood",
				},
				{
					questID = 155,
					name = "The Defias Brotherhood",
				},
			},
		},
		{
			questID = 373,
			name = "The Unsent Letter",
			level = 22,
			requiredLevel = 16,
			faction = "Alliance",
			objective = "Take the letter to the city architect in Stormwind.",
			pickup = "Use An Unsent Letter, looted from Edwin VanCleef.",
			turnin = "Baros Alexston, City Hall, Cathedral Square, Stormwind",
			note = "Leads into a chain that carries on with Bazil Thredd.",
			rewards = {
				xp = 870,
				money = 700,
				reputation = {
					{
						faction = "Stormwind",
						amount = 50,
					},
				},
			},
			startItem = {
				itemID = 2874,
				name = "An Unsent Letter",
				note = "Looted from Edwin VanCleef",
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
			note = "A paladin quest for humans and dwarves, with parts from several places. Here: Whitestone Oak Lumber, which the Goblin Woodcarvers drop. The rest: Jordan's Smithing Hammer in Shadowfang Keep, the Kor Gem in Blackfathom Deeps and Jordan's ore shipment in Loch Modan.",
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
