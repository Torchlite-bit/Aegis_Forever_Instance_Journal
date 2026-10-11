-- The Stockade: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "TheStockade",
	instanceID = 34,
	kind = "dungeon",
	name = "The Stockade",
	levelMin = 24,
	levelMax = 32,
	location = "Stormwind City",
	buttonArt = 131870,
	buttonImage = 608223,
	loreImage = 608262,
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.5,
			y = 0.815,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 225,
				tiles = "Interface\\WorldMap\\TheStockade\\TheStockade1_",
			},
		},
	},
	zoneEntrance = {
		mapID = 1453,
		x = 0.524,
		y = 0.7,
	},
	bosses = {
		{
			name = "Targorr the Dread",
			npcID = 1696,
			level = 24,
			displayID = 517,
			loot = {
				{
					itemID = 273805,
					name = "Blackrock Harness",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 273804,
					name = "Executioner Mantle",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 273806,
					name = "Dark Horde Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 251380,
					name = "Plans: Veteran's Silvered Chain Helm",
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
					itemID = 253942,
					name = "Pattern: Filigreed Flame Leggings",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253948,
				},
			},
			mapPin = {
				x = 0.44,
				y = 0.445,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Kam Deepfury",
			npcID = 1666,
			level = 27,
			displayID = 825,
			loot = {
				{
					itemID = 2280,
					name = "Kam's Walking Stick",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 273807,
					name = "Demolition Girdle",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 273808,
					name = "Bridgebreaker Bindings",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 251379,
					name = "Plans: Crusader's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 252825,
					name = "Pattern: Wisdom's Leather Leggings",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.32,
				y = 0.38,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Hamhock",
			npcID = 1717,
			level = 28,
			displayID = 3250,
			loot = {
				{
					itemID = 273809,
					name = "Hamhock's Cleaver",
					slot = "Main Hand, Axe",
					quality = 3,
				},
				{
					itemID = 273810,
					name = "Ogre Grips",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 273811,
					name = "Repurposed Rack",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 251377,
					name = "Plans: Protector's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.78,
				y = 0.455,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Dextren Ward",
			npcID = 1663,
			level = 26,
			displayID = 2149,
			loot = {
				{
					itemID = 273817,
					name = "Graverobber's Shovel",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 273819,
					name = "Boneslicer",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 273820,
					name = "Nightskulker Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 251375,
					name = "Plans: Veteran's Silvered Chain Leggings",
					slot = "Recipe, Blacksmithing",
					quality = 3,
				},
				{
					itemID = 251376,
					name = "Plans: Guard's Silvered Chain Leggings",
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
			},
			mapPin = {
				x = 0.735,
				y = 0.575,
				floor = 1,
			},
			order = 4,
		},
		{
			name = "Bazil Thredd",
			npcID = 1716,
			level = 29,
			displayID = 1621,
			loot = {
				{
					itemID = 273827,
					name = "Debt Collector",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 273824,
					name = "Defias Jailbreakers",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 273825,
					name = "Red Wool Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 273829,
					name = "Concealed Hand Crossbow",
					slot = "Ranged, Crossbow",
					quality = 3,
				},
				{
					itemID = 252824,
					name = "Pattern: Stormrider's Leather Kilt",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
				{
					itemID = 253976,
					name = "Pattern: Filigreed Pristine Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
				{
					itemID = 253986,
					name = "Pattern: Filigreed Shining Circlet",
					slot = "Recipe, Tailoring",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.215,
				y = 0.255,
				floor = 1,
			},
			order = 5,
		},
		{
			name = "Bruegal Ironknuckle",
			npcID = 1720,
			level = 26,
			rare = true,
			displayID = 2142,
			loot = {
				{
					itemID = 3228,
					name = "Jimmied Handcuffs",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 2941,
					name = "Prison Shank",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 2942,
					name = "Iron Knuckles",
					slot = "One-Hand, Fist Weapon",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.5,
				y = 0.19,
				floor = 1,
			},
			order = 6,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 274092,
					name = "Sharpened Cutlery",
					slot = "Thrown",
					quality = 3,
				},
				{
					itemID = 1076,
					name = "Defias Renegade Ring",
					slot = "Finger",
					quality = 3,
					droppedBy = "Stockade trash",
				},
			},
		},
	},
	quests = {
		{
			questID = 386,
			name = "What Comes Around...",
			level = 25,
			requiredLevel = 22,
			faction = "Alliance",
			startMap = {
				mapID = 1433,
				x = 0.212,
				y = 0.466,
				label = "Guard Berton — Lakeshire",
			},
			objective = "Kill Targorr the Dread in The Stockade and bring his head to Guard Berton.",
			pickup = "Guard Berton, Lakeshire, Redridge Mountains",
			turnin = "Guard Berton, Lakeshire, Redridge Mountains",
			rewards = {
				xp = 2000,
				reputation = {
					{
						faction = "Stormwind",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 3400,
						name = "Lucine Longsword",
						quality = 3,
					},
					{
						itemID = 1317,
						name = "Hardened Root Staff",
						quality = 3,
					},
					{
						itemID = 270027,
						name = "Unknown Reward",
						quality = 1,
					},
				},
				choice = true,
			},
		},
		{
			questID = 377,
			name = "Crime and Punishment",
			level = 26,
			requiredLevel = 22,
			faction = "Alliance",
			startMap = {
				mapID = 1431,
				x = 0.72,
				y = 0.478,
				label = "Councilman Millstipe — Darkshire",
			},
			objective = "Kill Dextren Ward in The Stockade and bring his hand to Councilman Millstipe.",
			pickup = "Councilman Millstipe, Darkshire, Duskwood",
			turnin = "Councilman Millstipe, Darkshire, Duskwood",
			rewards = {
				xp = 2100,
				reputation = {
					{
						faction = "Stormwind",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 2033,
						name = "Ambassador's Boots",
						quality = 3,
					},
					{
						itemID = 2906,
						name = "Darkshire Mail Leggings",
						quality = 3,
					},
					{
						itemID = 270029,
						name = "Town Clerk's Mittens",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 387,
			name = "Quell the Uprising",
			level = 26,
			requiredLevel = 22,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.518,
				y = 0.693,
				label = "Warden Thelwater — The Stockade",
			},
			objective = "Kill 10 Defias Prisoners, 8 Defias Convicts, and 8 Defias Insurgents inside The Stockade.",
			pickup = "Warden Thelwater, outside The Stockade, Stormwind",
			turnin = "Warden Thelwater, outside The Stockade, Stormwind",
			rewards = {
				xp = 2650,
				money = 4000,
				reputation = {
					{
						faction = "Stormwind",
						amount = 150,
					},
				},
			},
		},
		{
			questID = 388,
			name = "The Color of Blood",
			level = 26,
			requiredLevel = 22,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.736,
				y = 0.466,
				label = "Nikova Raskol — Old Town",
			},
			objective = "Collect 10 Red Wool Bandanas from Defias prisoners in The Stockade.",
			pickup = "Nikova Raskol, Old Town, Stormwind",
			turnin = "Nikova Raskol, Old Town, Stormwind",
			rewards = {
				xp = 2650,
				money = 4000,
				reputation = {
					{
						faction = "Stormwind",
						amount = 150,
					},
				},
			},
		},
		{
			questID = 378,
			name = "The Fury Runs Deep",
			level = 27,
			requiredLevel = 25,
			faction = "Alliance",
			startMap = {
				mapID = 1437,
				x = 0.496,
				y = 0.182,
				label = "Motley Garmason — Dun Modr",
			},
			objective = "Kill Kam Deepfury in The Stockade and bring his head to Motley Garmason.",
			pickup = "Motley Garmason, Dun Modr, Wetlands",
			turnin = "Motley Garmason, Dun Modr, Wetlands",
			note = "Opens once The Dark Iron War is done.",
			rewards = {
				xp = 5750,
				reputation = {
					{
						faction = "Ironforge",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 3562,
						name = "Belt of Vindication",
						quality = 3,
					},
					{
						itemID = 1264,
						name = "Headbasher",
						quality = 3,
					},
					{
						itemID = 270036,
						name = "Magistrate's Pantaloons",
						quality = 3,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 303,
					name = "The Dark Iron War",
				},
			},
		},
		{
			questID = 391,
			name = "The Stockade Riots",
			level = 29,
			requiredLevel = 16,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.518,
				y = 0.693,
				label = "Warden Thelwater — The Stockade",
			},
			objective = "Kill Bazil Thredd in The Stockade and bring his head back to Warden Thelwater.",
			pickup = "Warden Thelwater, outside The Stockade, Stormwind",
			turnin = "Warden Thelwater, outside The Stockade, Stormwind",
			note = "Part of the chain The Unsent Letter starts, from Edwin VanCleef in the Deadmines.",
			rewards = {
				xp = 2350,
				money = 2500,
				reputation = {
					{
						faction = "Stormwind",
						amount = 100,
					},
				},
			},
			prerequisites = {
				{
					questID = 373,
					name = "The Unsent Letter",
				},
				{
					questID = 389,
					name = "Bazil Thredd",
				},
			},
		},
	},
})
