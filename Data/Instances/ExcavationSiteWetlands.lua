-- Excavation Site: Wetlands: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "ExcavationSiteWetlands",
	instanceID = 2998,
	kind = "dungeon",
	forever = true,
	name = "Excavation Site: Wetlands",
	levelMin = 26,
	levelMax = 33,
	location = "Wetlands",
	description = "A Titan dig site above Whelgar's Excavation, caught out of time, where the Titans' constructs answer to no one now. Inside: the Lost Marsh, Stalker's Thicket, the Site of the Guardian and the Lost Dig Site.",
	buttonArt = 7963777,
	map = {
		entrance = {
			x = 0.888,
			y = 0.258,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\ExcavationSiteWetlands",
				artBottom = 0.667,
			},
		},
	},
	zoneEntrance = {
		mapID = 1437,
		x = 0.478,
		y = 0.565,
	},
	bosses = {
		{
			name = "Saltspine",
			npcID = 260322,
			level = 28,
			description = "A white crocolisk of the marsh.",
			displayID = 144209,
			loot = {
				{
					itemID = 273024,
					name = "Glinteye Slippers",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 273022,
					name = "Supple Bellyskin Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 273023,
					name = "Saltscale Girdle",
					slot = "Waist, Mail",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.55,
				y = 0.361,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Shadetooth",
			npcID = 260325,
			level = 29,
			description = "A huge violet raptor, the leader of Stalker's Thicket.",
			displayID = 144210,
			loot = {
				{
					itemID = 273025,
					name = "Raptorclaw Greaves",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 273026,
					name = "Garb of Florid Feathers",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 273027,
					name = "Raptor's Gaze",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 273106,
					name = "Blueprint: Greenhouse",
					slot = "Blueprint",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.305,
				y = 0.484,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Relic Guardian",
			npcID = 260326,
			level = 31,
			description = "The last boss: a stone construct of the Titans.",
			displayID = 144224,
			loot = {
				{
					itemID = 273028,
					name = "Reliquary Mantle",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 273029,
					name = "Golemsight Long Gun",
					slot = "Ranged, Gun",
					quality = 3,
				},
				{
					itemID = 273030,
					name = "Ring of Power Regulation",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 270866,
					name = "Titan Relic",
					slot = "Quest Item",
					quality = 1,
				},
				{
					itemID = 273097,
					name = "Blueprint: Rock Garden",
					slot = "Blueprint",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.324,
				y = 0.687,
				floor = 1,
			},
			order = 3,
		},
	},
	quests = {
		{
			questID = 95682,
			name = "Open the Maw",
			level = 31,
			requiredLevel = 24,
			faction = "Horde",
			startMap = {
				mapID = 1437,
				x = 0.478,
				y = 0.563,
				label = "Deathstalker Agent — outside Excavation Site: Wetlands",
			},
			objective = "Defeat 2 Dragonmaw Saboteurs and 4 Dragonmaw Warders, recover the Dragonmaw Dispatch, and report to the Deathstalker Agent outside the dungeon.",
			pickup = "Deathstalker Agent, just outside Excavation Site: Wetlands",
			turnin = "Deathstalker Agent, just outside Excavation Site: Wetlands",
			rewards = {
				xp = 7158,
				items = {
					{
						itemID = 271740,
						name = "Knife-Polishing Rag",
						quality = 3,
					},
					{
						itemID = 271732,
						name = "Dirt-Heavy Bracers",
						quality = 3,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 95663,
					name = "Dragonmaw Rumors",
				},
			},
		},
		{
			questID = 95697,
			name = "Changing Tastes",
			level = 31,
			requiredLevel = 24,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.572,
				y = 0.533,
				label = "Borstan — The Drag, Orgrimmar",
			},
			objective = "Enter the Excavation Sites in the Wetlands and bring back 4 Thicket Raptor Meat.",
			pickup = "Borstan, The Drag, Orgrimmar",
			turnin = "Borstan, The Drag, Orgrimmar",
			note = "The raptors of Stalker's Thicket, Shadetooth's part of the dig, drop the meat: Thicket Lurkers, Hunters and Matriarchs.",
			rewards = {
				xp = 6950,
				items = {
					{
						itemID = 280766,
						name = "Satchel of Potions",
						quality = 3,
					},
					{
						itemID = 280805,
						name = "Serrated Raptor Claw",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 98815,
			name = "Highland Hides",
			level = 28,
			requiredLevel = 24,
			faction = "Alliance",
			startMap = {
				mapID = 1437,
				x = 0.08,
				y = 0.55,
				label = "James Halloran — Menethil Harbor",
			},
			objective = "Collect 4 Thicket Raptor Hides and take them to James Halloran in Menethil Harbor.",
			pickup = "James Halloran, Menethil Harbor, Wetlands",
			turnin = "James Halloran, Menethil Harbor, Wetlands",
			rewards = {
				xp = 1150,
				money = 1200,
				reputation = {
					{
						faction = "Stormwind",
						amount = 50,
					},
				},
			},
			prerequisites = {
				{
					questID = 484,
					name = "Young Crocolisk Skins",
				},
			},
		},
		{
			questID = 95772,
			name = "Songblade Search",
			level = 31,
			requiredLevel = 24,
			faction = "Alliance",
			startMap = {
				mapID = 1433,
				x = 0.256,
				y = 0.466,
				label = "Dorin Songblade — Redridge Mountains",
			},
			objective = "Look for Dorin Songblade's brother, Daewyn, in Whelgar's Excavation Site.",
			pickup = "Dorin Songblade, Redridge Mountains",
			turnin = "Daewyn Songblade, inside Excavation Site: Wetlands",
			note = "Daewyn is inside the dungeon. Fallen in the Fen then sends you back to Dorin Songblade in Lakeshire.",
			rewards = {
				xp = 6150,
			},
		},
		{
			questID = 95646,
			name = "Horrors in the Highland",
			level = 31,
			requiredLevel = 24,
			faction = "Alliance",
			startMap = {
				mapID = 1437,
				x = 0.562,
				y = 0.406,
				label = "Rethiel the Greenwarden — Wetlands",
			},
			objective = "Kill a Highland Horror within Excavation Sites and bring its root core to Rethiel the Greenwarden in the Wetlands.",
			pickup = "Rethiel the Greenwarden, Wetlands",
			turnin = "Rethiel the Greenwarden, Wetlands",
			rewards = {
				xp = 6150,
				items = {
					{
						itemID = 271667,
						name = "Ironwood Destroyer",
						quality = 3,
					},
					{
						itemID = 271670,
						name = "Curl of Life",
						quality = 3,
					},
					{
						itemID = 271664,
						name = "Hornbeam Heft",
						quality = 3,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 463,
					name = "The Greenwarden",
				},
				{
					questID = 276,
					name = "Tramping Paws",
				},
				{
					questID = 277,
					name = "Fire Taboo",
				},
				{
					questID = 275,
					name = "Blisters on The Land",
				},
			},
		},
		{
			questID = 95809,
			name = "Heartwoven",
			level = 31,
			requiredLevel = 24,
			faction = "Alliance",
			objective = "Take the Reed-woven Heart back to Caitlin Grassman in Menethil Harbor.",
			pickup = "Ardin Grassman, inside Excavation Site: Wetlands",
			turnin = "Caitlin Grassman, Menethil Harbor",
			note = "Comes after Lost in the Thicket Things.",
			rewards = {
				xp = 6150,
				items = {
					{
						itemID = 1710,
						name = "Greater Healing Potion",
						quality = 1,
					},
					{
						itemID = 3827,
						name = "Mana Potion",
						quality = 1,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 95647,
					name = "Lost in the Thicket Things",
				},
			},
		},
		{
			questID = 98824,
			name = "Prehistoric Prism",
			level = 31,
			requiredLevel = 24,
			faction = "Alliance",
			objective = "Deliver the Titan Relic to High Explorer Magellas in the Hall of Explorers.",
			pickup = "Prospector Whelgar, Whelgar's Excavation Site, Wetlands",
			turnin = "High Explorer Magellas, Hall of Explorers, Ironforge",
			rewards = {
				xp = 3150,
				money = 6000,
				items = {
					{
						itemID = 271716,
						name = "Explorer's League Dustcover",
						quality = 3,
					},
					{
						itemID = 271767,
						name = "Healer's Staff",
						quality = 3,
					},
					{
						itemID = 271766,
						name = "Heavehammer",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 98823,
			name = "Earthen Echo",
			level = 31,
			requiredLevel = 24,
			faction = "Horde",
			startMap = {
				mapID = 1456,
				x = 0.708,
				y = 0.334,
				label = "Bashana Runetotem — Elder Rise, Thunder Bluff",
			},
			objective = "Deliver the Titan Relic to Muln Earthfury on Skywatcher Plateau in northwest Mulgore.",
			pickup = "Bashana Runetotem, Elder Rise, Thunder Bluff",
			turnin = "Muln Earthfury, Skywatcher Plateau, Mulgore",
			rewards = {
				xp = 3150,
				money = 6000,
				items = {
					{
						itemID = 271766,
						name = "Heavehammer",
						quality = 3,
					},
					{
						itemID = 271767,
						name = "Healer's Staff",
						quality = 3,
					},
					{
						itemID = 271719,
						name = "Furs of the Earthen Ring",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 95795,
			name = "Fallen in the Fen",
			level = 31,
			requiredLevel = 24,
			faction = "Alliance",
			objective = "Report Daewyn's fate to Dorin Songblade in Lakeshire.",
			pickup = "Daewyn Songblade, inside Excavation Site: Wetlands",
			turnin = "Dorin Songblade, Lakeshire, Redridge Mountains",
			rewards = {
				xp = 6150,
				items = {
					{
						itemID = 271769,
						name = "Daewyn's Girdle",
						quality = 3,
					},
					{
						itemID = 271768,
						name = "Songblade Stabilizer",
						quality = 3,
					},
				},
				choice = true,
			},
		},
	},
})
