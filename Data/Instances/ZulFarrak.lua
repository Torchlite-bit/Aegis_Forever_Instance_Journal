-- Zul'Farrak: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "ZulFarrak",
	instanceID = 209,
	kind = "dungeon",
	name = "Zul'Farrak",
	levelMin = 44,
	levelMax = 54,
	location = "Tanaris",
	description = "The sun-baked city of the Sandfury trolls in northern Tanaris, ruled by Chief Ukorz Sandscalp, with the hydra Gahz'rilla in its sacred pool.",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenZulFarrak" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-ZulFarrak" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-ZulFarrak" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1446,
		world = { 1, -6350, -2716.7 },
	},
	map = {
		entrance = {
			x = 0.564,
			y = 0.902,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\ZulFarrak",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 219,
			},
		},
	},
	bosses = {
		{
			name = "Antu'sul",
			displayID = 7353,
			level = 48,
			order = 1,
			loot = {
				{
					itemID = 9640,
					name = "Vice Grips",
					slot = "Hands, Plate",
					quality = 3,
				},
				{
					itemID = 9641,
					name = "Lifeblood Amulet",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 9639,
					name = "The Hand of Antu'sul",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 9379,
					name = "Sang'thraze the Deflector",
					slot = "One-Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.641,
				y = 0.276,
				floor = 1,
			},
		},
		{
			name = "Nekrum Gutchewer",
			displayID = 6690,
			level = 46,
			order = 2,
			loot = {
				{
					itemID = 9471,
					name = "Nekrum's Medallion",
					slot = "Quest",
					quality = 1,
				},
			},
		},
		{
			name = "Shadowpriest Sezz'ziz",
			displayID = 6441,
			level = 47,
			order = 3,
			loot = {
				{
					itemID = 9470,
					name = "Bad Mojo Mask",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 9473,
					name = "Jinxed Hoodoo Skin",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 9474,
					name = "Jinxed Hoodoo Kilt",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 9475,
					name = "Diabolic Skiver",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.327,
				y = 0.174,
				floor = 1,
			},
		},
		{
			name = "Sergeant Bly",
			displayID = 6433,
			level = 45,
			order = 4,
			loot = {
				{
					itemID = 8548,
					name = "Divino-matic Rod",
					slot = "Other",
					quality = 1,
				},
				{
					itemID = 5616,
					name = "Gutwrencher",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
			},
		},
		{
			name = "Gahz'rilla",
			displayID = 7271,
			level = 46,
			order = 5,
			loot = {
				{
					itemID = 9469,
					name = "Gahz'rilla Scale Armor",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 9467,
					name = "Gahz'rilla Fang",
					slot = "One-Hand, Dagger",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.312,
				y = 0.411,
				floor = 1,
			},
		},
		{
			name = "Zerillis",
			displayID = 9293,
			level = 45,
			rare = true,
			order = 6,
			loot = {
				{
					itemID = 12470,
					name = "Sandstalker Ankleguards",
					slot = "Feet, Leather",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.524,
				y = 0.421,
				floor = 1,
			},
		},
		{
			name = "Theka the Martyr",
			displayID = 6696,
			level = 46,
			order = 7,
			loot = {
				{
					itemID = 10660,
					name = "First Mosh'aru Tablet",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.529,
				y = 0.264,
				floor = 1,
			},
		},
		{
			name = "Sandarr Dunereaver",
			displayID = 9291,
			level = 45,
			rare = true,
			order = 8,
			loot = {
				{
					itemID = 9523,
					name = "Troll Temper",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.44,
				y = 0.521,
				floor = 1,
			},
		},
		{
			name = "Witch Doctor Zum'rah",
			displayID = 6434,
			level = 46,
			order = 9,
			loot = {
				{
					itemID = 18083,
					name = "Jumanza Grips",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 18082,
					name = "Zum'rah's Vexing Cane",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.44,
				y = 0.176,
				floor = 1,
			},
		},
		{
			name = "Dustwraith",
			displayID = 9292,
			level = 45,
			rare = true,
			order = 10,
			loot = {
				{
					itemID = 12471,
					name = "Desertwalker Cane",
					slot = "Held In Off-hand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.381,
				y = 0.184,
				floor = 1,
			},
		},
		{
			name = "Sandfury Executioner",
			displayID = 6440,
			level = 46,
			order = 11,
			loot = {
				{
					itemID = 8444,
					name = "Executioner's Key",
					slot = "Other",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.293,
				y = 0.174,
				floor = 1,
			},
		},
		{
			name = "Hydromancer Velratha",
			displayID = 6685,
			level = 46,
			order = 12,
			loot = {
				{
					itemID = 9234,
					name = "Tiara of the Deep",
					slot = "Quest",
					quality = 1,
				},
				{
					itemID = 10661,
					name = "Second Mosh'aru Tablet",
					slot = "Quest",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.355,
				y = 0.399,
				floor = 1,
			},
		},
		{
			name = "Chief Ukorz Sandscalp",
			displayID = 6439,
			level = 48,
			order = 13,
			loot = {
				{
					itemID = 9479,
					name = "Embrace of the Lycan",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 9476,
					name = "Big Bad Pauldrons",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 9478,
					name = "Ripsaw",
					slot = "Main Hand, Axe",
					quality = 3,
				},
				{
					itemID = 9477,
					name = "The Chief's Enforcer",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 11086,
					name = "Jang'thraze the Protector",
					slot = "Main Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.425,
				y = 0.338,
				floor = 1,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 9512,
					name = "Blackmetal Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 9484,
					name = "Spellshock Leggings",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 862,
					name = "Runed Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 6440,
					name = "Brainlash",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 9483,
					name = "Flaming Incinerator",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 2040,
					name = "Troll Protector",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 5616,
					name = "Gutwrencher",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 9511,
					name = "Bloodletter Scalpel",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 9481,
					name = "The Minotaur",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 9480,
					name = "Eyegouger",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 9482,
					name = "Witch Doctor's Cane",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 9243,
					name = "Shriveled Heart",
					slot = "Neck",
					quality = 2,
				},
			},
		},
	},
	quests = {
		{
			questID = 2865,
			name = "Scarab Shells",
			level = 45,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.516,
				y = 0.268,
			},
			endMap = {
				mapID = 1446,
				x = 0.516,
				y = 0.268,
			},
			objective = "Bring 5 Uncracked Scarab Shells to Tran'rek in Gadgetzan.",
			pickup = "Tran'rek, Tanaris",
			turnin = "Tran'rek, Tanaris",
			rewards = {
				xp = 3900,
				money = 6500,
			},
			prerequisites = {
				{
					questID = 2864,
					name = "Tran'rek",
				},
			},
		},
		{
			questID = 3042,
			name = "Troll Temper",
			level = 45,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.514,
				y = 0.288,
			},
			endMap = {
				mapID = 1446,
				x = 0.514,
				y = 0.288,
			},
			objective = "Bring 20 Vials of Troll Temper to Trenton Lighthammer in Gadgetzan.",
			pickup = "Trenton Lighthammer, Tanaris",
			turnin = "Trenton Lighthammer, Tanaris",
			rewards = {
				xp = 3900,
				money = 19500,
			},
		},
		{
			questID = 2846,
			name = "Tiara of the Deep",
			level = 46,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1445,
				x = 0.461,
				y = 0.571,
			},
			endMap = {
				mapID = 1445,
				x = 0.461,
				y = 0.571,
			},
			objective = "Bring the Tiara of the Deep to Tabetha in Dustwallow Marsh.",
			pickup = "Tabetha, Dustwallow Marsh",
			turnin = "Tabetha, Dustwallow Marsh",
			rewards = {
				xp = 6050,
				money = 6500,
				items = {
					{
						itemID = 9527,
						name = "Spellshifter Rod",
					},
					{
						itemID = 9531,
						name = "Gemshale Pauldrons",
					},
				},
			},
			prerequisites = {
				{
					questID = 2861,
					name = "Tabetha's Task",
				},
			},
		},
		{
			questID = 2768,
			name = "Divino-matic Rod",
			level = 47,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.525,
				y = 0.285,
			},
			endMap = {
				mapID = 1446,
				x = 0.525,
				y = 0.285,
			},
			objective = "Bring the Divino-matic Rod to Chief Engineer Bilgewhizzle in Gadgetzan.",
			pickup = "Chief Engineer Bilgewhizzle, Tanaris",
			turnin = "Chief Engineer Bilgewhizzle, Tanaris",
			rewards = {
				xp = 6300,
				items = {
					{
						itemID = 9533,
						name = "Masons Fraternity Ring",
					},
					{
						itemID = 9534,
						name = "Engineer's Guild Headpiece",
					},
				},
				choice = true,
			},
		},
		{
			questID = 3527,
			name = "The Prophecy of Mosh'aru",
			level = 47,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.67,
				y = 0.224,
			},
			endMap = {
				mapID = 1446,
				x = 0.67,
				y = 0.224,
			},
			objective = "Bring the First and Second Mosh'aru Tablets to Yeh'kinya in Tanaris.",
			pickup = "Yeh'kinya, Tanaris",
			turnin = "Yeh'kinya, Tanaris",
			rewards = {
				xp = 5250,
			},
			prerequisites = {
				{
					questID = 3520,
					name = "Screecher Spirits",
				},
			},
		},
		{
			questID = 2770,
			name = "Gahz'rilla",
			level = 50,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1441,
				x = 0.781,
				y = 0.771,
			},
			endMap = {
				mapID = 1441,
				x = 0.781,
				y = 0.771,
			},
			objective = "Bring Gahz'rilla's Electrified Scale to Wizzle Brassbolts in the Shimmering Flats.",
			pickup = "Wizzle Brassbolts, Thousand Needles",
			turnin = "Wizzle Brassbolts, Thousand Needles",
			rewards = {
				xp = 7100,
				money = 7500,
				items = {
					{
						itemID = 11122,
						name = "Carrot on a Stick",
					},
				},
			},
			prerequisites = {
				{
					questID = 2769,
					name = "The Brassbolts Brothers",
				},
			},
		},
		{
			questID = 2991,
			name = "Nekrum's Medallion",
			level = 47,
			requiredLevel = 40,
			faction = "Alliance",
			startMap = {
				mapID = 1419,
				x = 0.669,
				y = 0.195,
			},
			endMap = {
				mapID = 1419,
				x = 0.669,
				y = 0.195,
			},
			objective = "Bring Nekrum's Medallion to Thadius Grimshade in the Blasted Lands.",
			pickup = "Thadius Grimshade, Blasted Lands",
			turnin = "Thadius Grimshade, Blasted Lands",
			rewards = {
				xp = 5250,
				money = 7000,
			},
			prerequisites = {
				{
					questID = 2990,
					name = "Thadius Grimshade",
				},
			},
		},
	},
})
