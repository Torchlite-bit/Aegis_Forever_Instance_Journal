local _, ns = ...

--[[
	Each boss's loot, as foreverchanges.pro's loot tables list it (2026-10-11): the "Map, bosses
	and loot" section of its page for each of the 16 dungeons, read in the browser.

	The player chose the site as the one source for loot. A boss here lists exactly what the
	site lists for it, in the journal's order, and the dungeon's trash what the site lists for
	its trash. What other sources gave and the site does not (recipes Alex Atlas Loot's players
	saw elsewhere, old world drops, Scorn and Sever) is left out, with two kinds of exceptions:

	  QUEST_ITEMS    items the journal's quests need, which the site lists among quest items,
	                 not loot: they stay on the boss that drops them
	  DROP_BOSSES    creatures the site's page does not list at all: removed from the dungeon

	Each dungeon's own data (Data/Instances) may list more; the names, slots and notes on the
	rows that remain are kept, and this file has the last word. The site
	also lists two quest objects in Shadowfang Keep among its bosses (Jordan's Smithing Hammer
	and The Book of Ur); the journal has no such bosses.

	Loads after every file that adds loot, and before ItemNames.lua, which names the rows.
]]

local QUEST_ITEMS = {
	[14540] = true, -- Taragaman the Hungerer's Heart (Ragefire Chasm)
	[9738] = true, [9739] = true, [9740] = true, [9741] = true, -- the Gems of the Fanglords (Wailing Caverns)
	[5442] = true, -- Head of Arugal (Shadowfang Keep)
	[5881] = true, -- Head of Kelris (Blackfathom Deeps; seen dropping in a recorded run)
	-- The Stockade, seen dropping in a recorded run (2026-10-12): the ringleaders' heads and hand,
	-- and the bandanas The Color of Blood asks for
	[3630] = true, [3640] = true, [3628] = true, [2926] = true, [2909] = true,
	[7146] = true, -- The Scarlet Key (Arcanist Doan, Scarlet Monastery: Library)
	[270866] = true, -- Titan Relic, the Horde's (Relic Guardian, Excavation Site)
	[280438] = true, -- Abominable Head (The Baron, Ruins of Lordaeron)
	[275443] = true, -- Highly Toxic Strain (Witherfang, Ruins of Lordaeron)
}

local DROP_BOSSES = {
	ScarletMonasteryGraveyard = { "Scorn" },
	ShadowfangKeep = { "Sever" },
}

local LOOT = {
	CityOfDalaran = {
		["Atrexis the Grave Knight"] = { 273036, 273032, 273033 },
		["Lyn the Ignored"] = { 273054, 273053, 273055 },
		["Arcane Anomaly"] = { 273031, 273034, 273035 },
		["Arcanic Enigma"] = { 273045, 273044, 273043 },
		["Unstable Sentinel"] = { 273046, 273048, 273047, 273099 },
		["Mana Devourer"] = { 273040, 273042, 273041 },
		["Fel Ancient"] = { 273039, 273038, 273037 },
		["Shade of the Archmage"] = { 273052, 273051, 273049, 273103 },
		-- The site's two, and the Violet Sorcerer's Sandals: seen dropping from the trash before Lyn
		-- (creature 255066) in both of Skep's recorded runs (2026-10-19).
		Trash = { 276160, 276158, 286987 },
	},
	HallOfThanes = {
		["Faldrim Anvilmar"] = { 270227, 271096, 271097 },
		["Magmatus"] = { 270230, 270231, 271095 },
		["Plunder"] = { 270228, 270229, 271098 },
		["Durgen Dirgehammer"] = { 270256, 270260, 270261, 274286 },
	},
	RuinsOfLordaeron = {
		["The Baron"] = { 271204, 271205, 271206 },
		["Witherfang"] = { 271201, 271202, 271203 },
		["The Abandoned"] = { 271207, 271208, 271216 },
		["Bjork"] = { 271209, 271210, 271217 },
		["Rath'mael"] = { 271213, 271214, 271215, 273085, 273103 },
		["Viktor the Vile"] = { 271211, 271212, 271218 },
		["Lordaeron Captain"] = { 6641, 6642 },
		-- 286977 Sword of the Fallen: not on the site's dungeon page; a zone drop seen in game.
		Trash = { 286980, 286979, 286978, 286977 },
	},
	ExcavationSiteWetlands = {
		["Saltspine"] = { 273022, 273023, 273024 },
		["Shadetooth"] = { 273025, 273026, 273027, 273106 },
		["Highland Horror"] = { 270180 },
		["Relic Guardian"] = { 273028, 273030, 270865, 273029, 273097 },
	},
	RagefireChasm = {
		["Oggleflint"] = { 272999, 272996, 272998 },
		["Taragaman the Hungerer"] = { 14149, 14148, 14145 },
		["Jergosh the Invoker"] = { 14150, 14147, 14151 },
		["Bazzalan"] = { 273003, 273005, 273007 },
	},
	WailingCaverns = {
		["Lord Cobrahn"] = { 6460, 10410, 6465, 253908, 252778 },
		["Lady Anacondra"] = { 10412, 5404, 6446, 273088, 273098, 253904 },
		["Kresh"] = { 13245, 6447, 273084, 252778 },
		["Lord Pythas"] = { 6472, 6473, 273089, 253938 },
		["Skum"] = { 6449, 6448, 273137, 253944, 252799 },
		["Lord Serpentis"] = { 6469, 5970, 10411, 6459, 273087 },
		["Verdan the Everliving"] = { 6630, 6631, 6629, 253938 },
		["Mutanus the Devourer"] = { 6461, 6627, 6463, 10441 },
		["Deviate Faerie Dragon"] = { 5243, 6632 },
		Trash = { 10413 },
	},
	TheDeadmines = {
		["Rhahk'Zor"] = { 872, 5187, 273289, 251363, 253904 },
		["Miner Johnson"] = { 5443, 5444 },
		["Sneed"] = { 5194, 5195, 273293, 273092 },
		["Sneed's Shredder"] = { 1937, 2169, 285292 },
		["Gilnid"] = { 1156, 5199, 273297, 273086 },
		["Mr. Smite"] = { 7230, 5192, 5196, 284715 },
		["Captain Greenskin"] = { 5201, 10403, 5200, 253906 },
		["Edwin VanCleef"] = { 5193, 5202, 10399, 5191, 2874, 253940 },
		["Cookie"] = { 5198, 5197, 8490, 273298, 273102 },
		Trash = { 8492, 1934, 10402, 1943, 1951, 10400, 10401, 1929, 1930, 1936, 1944, 1945, 1925 },
	},
	ShadowfangKeep = {
		["Rethilgore"] = { 5254, 273456, 273457 },
		["Fel Steed / Shadow Charger"] = { 6341, 932 },
		["Razorclaw the Butcher"] = { 1292, 6226, 6633, 273096 },
		["Baron Silverlaine"] = { 6321, 6323, 273637 },
		["Commander Springvale"] = { 6320, 3191, 273643, 273105 },
		["Odo the Blindwatcher"] = { 6318, 6319, 273645 },
		["Deathsworn Captain"] = { 6642, 6641 },
		["Arugal's Voidwalker"] = { 5943 },
		["Fenrus the Devourer"] = { 6340, 3230, 273646 },
		["Wolf Master Nandos"] = { 3748, 6314, 273647 },
		["Archmage Arugal"] = { 6324, 6392, 6220 },
		Trash = { 2292, 1489, 1974, 2807, 1482, 1935, 1483, 1318, 3194, 2205, 1484, 5943, 6341 },
	},
	BlackfathomDeeps = {
		["Ghamoo-ra"] = { 6907, 6908, 273839 },
		["Lady Sarevess"] = { 888, 3078, 11121 },
		["Gelihast"] = {
			6906, 6905, 1470, 273840, 273141, 252512, 252515, 252820, 252456, 252513, 252514, 252455,
		},
		["Lorgus Jett"] = { 273843, 273841, 252455, 252513, 252820, 252512, 252456, 252822, 273842 },
		["Baron Aquanis"] = { 16782, 252822, 252456 },
		["Twilight Lord Kelris"] = {
			1155, 6903, 273846, 252456, 252513, 252822, 252820, 252455, 252515, 252512,
		},
		["Old Serra'kis"] = { 6901, 6904, 6902, 252455, 252820, 252456, 252822 },
		["Aku'mai"] = { 6911, 6910, 6909, 252455, 252512, 252515, 252820, 252456, 252514 },
		Trash = { 1486, 3416, 1491, 3414, 1454, 1481, 2567, 3413, 3417, 3415, 2271, 2034 },
	},
	TheStockade = {
		["Targorr the Dread"] = { 273804, 273805, 273806 },
		["Kam Deepfury"] = {
			2280, 273807, 273808, 252515, 252455, 252512, 252513, 252456, 252514, 252820, 252822,
		},
		["Hamhock"] = { 273809, 273810, 273811, 252513, 252822, 252455, 252456, 252512 },
		["Dextren Ward"] = { 273817, 273819, 273820, 252514, 252515, 252512, 252820, 252456 },
		["Bazil Thredd"] = {
			273824, 273825, 273827, 273829, 252822, 252455, 252456, 252515, 252512, 252514, 252820,
		},
		["Bruegal Ironknuckle"] = { 3228, 2941, 2942 },
		Trash = { 1076, 274092 },
	},
	Gnomeregan = {
		["Techbot"] = { 9444 },
		["Grubbis"] = { 9445, 274043, 274042 },
		["Viscous Fallout"] = { 9454, 9453, 9452 },
		["Electrocutioner 6000"] = { 9447, 9446, 9448, 6893, 252822 },
		["Crowd Pummeler 9-60"] = { 9449, 9450, 274068, 274049 },
		["Dark Iron Ambassador"] = { 9455, 9456, 9457, 252820 },
		["Mekgineer Thermaplugg"] = { 9492, 9461, 9458, 9459, 4415, 4413, 4411, 7742, 11828 },
		Trash = {
			9508, 9491, 9509, 9510, 9487, 9485, 9488, 9486, 9490, 9489, 11827, 9327, 7191, 9308, 9326, 9279,
			9280, 9282, 9281, 9316,
		},
	},
	RazorfenKraul = {
		["Aggem Thorncurse"] = { 6681, 274158, 274159, 252512, 252455, 252822, 252820, 252456, 252515 },
		["Death Speaker Jargba"] = { 2816, 6685, 6682, 252822, 252512, 252515, 252820 },
		["Roogug"] = { 274155, 274149, 252512, 252820, 274152 },
		["Overlord Ramtusk"] = { 6687, 6686, 274161, 252512, 252822, 252513, 252515 },
		["Razorfen Spearhide"] = { 6679 },
		["Agathelos the Raging"] = { 6691, 6690, 274160, 252455, 252820, 252512, 252513 },
		["Blind Hunter"] = { 6695, 6697, 6696 },
		["Charlga Razorflank"] = { 6693, 6694, 6692, 17008, 252515, 252455, 252456, 252512, 273103 },
		["Earthcaller Halmgar"] = { 6689, 6688, 252455, 252514 },
		Trash = { 2264, 1488, 4438, 1978, 2039, 1727, 776, 1976, 1975, 2549, 6681, 6679, 3569 },
	},
	ScarletMonasteryGraveyard = {
		["Interrogator Vishas"] = { 7682, 7683, 274290, 252822, 252455, 252513, 252456, 252820 },
		["Azshir the Sleepless"] = { 7709, 7708, 7731, 252512, 252456 },
		["Fallen Champion"] = { 7691, 7690, 7689, 252820, 252456, 252513 },
		["Ironspine"] = { 7688, 7687, 7686, 252820, 252512 },
		["Bloodmage Thalnos"] = { 7685, 7684, 252455, 274291, 252822, 252513, 252514 },
		Trash = {
			5819, 7727, 7728, 7754, 10332, 2262, 7787, 7729, 7761, 7752, 8226, 7786, 7753, 7730, 1992, 5756,
			7736, 7755, 7757, 7758, 7759, 7760, 8225, 10328, 10329, 10330, 10331, 10333,
		},
	},
	ScarletMonasteryLibrary = {
		["Houndmaster Loksey"] = { 7710, 7756, 3456, 274292, 252512 },
		["Arcanist Doan"] = { 7714, 7713, 7712, 7711, 274293, 274294 },
		Trash = {
			5819, 7755, 7727, 7728, 7759, 7760, 7754, 10332, 1992, 2262, 7787, 7729, 7761, 7752, 8226, 7786,
			5756, 7736, 8225, 7753, 7730, 7758, 7757, 10328, 10329, 10330, 10331, 10333,
		},
	},
	ScarletMonasteryArmory = {
		["Herod"] = { 7719, 7718, 10330, 7717 },
		Trash = {
			5819, 7755, 7727, 7728, 7759, 7754, 10332, 1992, 2262, 7787, 7729, 7761, 7752, 8226, 7786, 5756,
			7736, 8225, 7753, 7730, 7757, 10333, 10329, 23192, 7758, 7760, 10328, 10330, 10331,
		},
	},
	ScarletMonasteryCathedral = {
		["High Inquisitor Fairbanks"] = { 19507, 19508, 19509 },
		["Scarlet Commander Mograine"] = { 7724, 10330, 7726, 7723 },
		["High Inquisitor Whitemane"] = { 7720, 7722, 7721 },
		Trash = {
			5819, 7755, 7727, 7728, 7759, 7760, 7754, 10332, 1992, 2262, 7787, 7729, 7761, 7752, 8226, 7786,
			5756, 7736, 8225, 7753, 7730, 7758, 7757, 10328, 10331, 10329, 10330, 10333,
		},
	},
}

-- The boss's rows for what the site lists (and its quest items), then any listed item it lacked.
local function SiteRows(boss, listed)
	local onSite, have, rows = {}, {}, {}
	for _, itemID in ipairs(listed) do onSite[itemID] = true end
	for _, row in ipairs(boss.loot or {}) do
		if row.itemID and (onSite[row.itemID] or QUEST_ITEMS[row.itemID]) and not have[row.itemID] then
			rows[#rows + 1] = row
			have[row.itemID] = true
		end
	end
	for _, itemID in ipairs(listed) do
		if not have[itemID] then
			rows[#rows + 1] = { itemID = itemID }
			have[itemID] = true
		end
	end
	return rows
end

for key, lists in pairs(LOOT) do
	local instance = ns.GetInstance(key)
	if instance then
		local drop = {}
		for _, name in ipairs(DROP_BOSSES[key] or {}) do drop[name] = true end
		local bosses, trash = {}, nil
		for _, boss in ipairs(instance.bosses) do
			if not drop[boss.name] then
				bosses[#bosses + 1] = boss
				if boss.trash then trash = trash or boss end
			end
		end
		if lists.Trash and not trash then
			trash = { name = "Trash Drops", trash = true, loot = {} }
			bosses[#bosses + 1] = trash
		end
		for _, boss in ipairs(bosses) do
			local listed = lists[boss.trash and "Trash" or boss.name]
			if listed then boss.loot = SiteRows(boss, listed) end
		end
		instance.bosses = bosses
	end
end
