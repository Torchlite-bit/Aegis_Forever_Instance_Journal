-- The Hall of Thanes: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "HallOfThanes",
	instanceID = 3065,
	kind = "dungeon",
	forever = true,
	name = "The Hall of Thanes",
	levelMin = 13,
	levelMax = 20,
	location = "Beneath Ironforge, Dun Morogh",
	description = "Beneath Ironforge, someone has broken into the tomb of the dwarven kings.",
	buttonArt = 7963781,
	map = {
		entrance = {
			x = 0.51,
			y = 0.944,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\HallOfThanes",
				artBottom = 0.667,
			},
		},
	},
	zoneEntrance = {
		mapID = 1455,
		x = 0.435,
		y = 0.52,
	},
	bosses = {
		{
			name = "Faldrim Anvilmar",
			npcID = 261306,
			level = 16,
			displayID = 142826,
			loot = {
				{
					itemID = 270227,
					name = "Ephemeral Choker",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 271096,
					name = "Aetherwisp Bracers",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 271097,
					name = "Spiritwraith Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.509,
				y = 0.668,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Magmatus",
			npcID = 261316,
			aliases = { "Magmatus", "Infurnus" },
			level = 16,
			loot = {
				{
					itemID = 270230,
					name = "Kindlegem Girdle",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 270231,
					name = "Flamefist Grips",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 271095,
					name = "Fang of Magmatus",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.748,
				y = 0.478,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "Plunder",
			npcID = 261311,
			level = 16,
			displayID = 142840,
			loot = {
				{
					itemID = 270228,
					name = "Golemheart Stave",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 271098,
					name = "Golemguard Chest",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 270229,
					name = "Treads of the Protector Golem",
					slot = "Feet, Mail",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.51,
				y = 0.515,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Durgen Dirgehammer",
			npcID = 261319,
			level = 16,
			displayID = 142837,
			loot = {
				{
					itemID = 270256,
					name = "Durgen's Crescent Axe",
					slot = "Main Hand, Axe",
					quality = 3,
				},
				{
					itemID = 270260,
					name = "Direhammer Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 270261,
					name = "Robes of the Disgraced Thane",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 274286,
					name = "Durgen Dirgehammer's Head",
					slot = "Quest Item",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.509,
				y = 0.17,
				floor = 1,
			},
			order = 4,
		},
	},
	quests = {
		{
			questID = 96395,
			name = "An Ancient Grudge",
			level = 15,
			requiredLevel = 10,
			faction = "Both",
			objective = "Put the spirit of Faldrim Anvilmar to rest.",
			pickup = "Ghostly Attendant, inside Hall of Thanes, after the first room",
			turnin = "Ghostly Attendant, inside the dungeon",
			rewards = {
				xp = 1050,
				items = {
					{
						itemID = 279899,
						name = "Catacomb Cloak",
						quality = 3,
					},
					{
						itemID = 279900,
						name = "Deepgrave Trousers",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Catacomb Cloak or Deepgrave Trousers\n3,570 XP",
			},
		},
		{
			questID = 96403,
			name = "Important Heirlooms",
			level = 15,
			requiredLevel = 10,
			faction = "Both",
			objective = "Collect 8 Dwarven Heirlooms from the Hall of Thanes.",
			pickup = "Thom Filch, by the bridge / vault entrance in Ironforge",
			turnin = "Thom Filch, near the dungeon entrance",
			rewards = {
				xp = 1350,
				money = 700,
				reputation = {
					{
						faction = "Gadgetzan",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 279898,
						name = "Dwarven Tome",
						quality = 3,
					},
					{
						itemID = 280096,
						name = "Tomb Robber's Gloves",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Dwarven Tome or Tomb Robber's Gloves\n4,590 XP • 7s • Gadgetzan +100",
			},
		},
		{
			questID = 96394,
			name = "The Restless Dead",
			level = 15,
			requiredLevel = 10,
			faction = "Alliance",
			objective = "Kill 15 Enraged Apparitions and 10 Tormented Souls, then put Anvilmar's spirit to rest.",
			pickup = "Afadra Dunwall, Ironforge",
			turnin = "Afadra Dunwall, Ironforge",
			rewards = {
				xp = 1050,
				money = 700,
				reputation = {
					{
						faction = "Ironforge",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 279897,
						name = "Dusty Belt",
						quality = 3,
					},
					{
						itemID = 280095,
						name = "Cryptwalker Bracers",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Dusty Belt or Cryptwalker Bracers\n3,570 XP • 7s • Ironforge +100",
			},
		},
		{
			questID = 96393,
			name = "Old Ironforge Incursion",
			level = 16,
			requiredLevel = 9,
			faction = "Alliance",
			objective = "Enter Hall of Thanes and claim Durgen Dirgehammer's Head.",
			pickup = "Earthseer Farsen, Dun Morogh (after Underground Map)",
			turnin = "King Magni Bronzebeard, Ironforge",
			note = "The chain starts with the Dark Iron Map, which Dark Iron Spies in Dun Morogh drop.",
			rewards = {
				xp = 1450,
				money = 800,
				reputation = {
					{
						faction = "Ironforge",
						amount = 100,
					},
					{
						faction = "Gnomeregan Exiles",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 279894,
						name = "Calibrated Blunderbuss",
						quality = 3,
					},
					{
						itemID = 279895,
						name = "Ironforge Greathammer",
						quality = 3,
					},
					{
						itemID = 279896,
						name = "Deepblaze",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Calibrated Blunderbuss, Ironforge Greathammer or Deepblaze\n4,930 XP • 8s • Ironforge +100 • Gnomeregan Exiles +100",
			},
			noteItem = {
				itemID = 274268,
				name = "Dark Iron Map",
				note = "Dropped by: Dark Iron Spies in Dun Morogh",
			},
			prerequisites = {
				{
					questID = 96391,
					name = "Underground Map",
				},
			},
		},
		{
			questID = 98423,
			name = "The Treaty of Understanding",
			level = 16,
			requiredLevel = 9,
			faction = "Alliance",
			objective = "Deliver the Treaty of Understanding to Magni Bronzebeard in Ironforge.",
			pickup = "Stone tablet inside a vault in the Reliquary of Kings (Durgen Dirgehammer's room)",
			turnin = "King Magni Bronzebeard, Ironforge",
			rewards = {
				xp = 1150,
				money = 1600,
				reputation = {
					{
						faction = "Ironforge",
						amount = 100,
					},
					{
						faction = "Gnomeregan Exiles",
						amount = 100,
					},
				},
				text = "3,900 XP • 16s • Ironforge +100 • Gnomeregan Exiles +100",
			},
			startObject = {
				name = "Stone Tablet",
				icon = "Interface\\Icons\\INV_Misc_StoneTablet_05",
				note = "Inside a vault in the Reliquary of Kings (Durgen Dirgehammer's room)",
			},
		},
	},
})
