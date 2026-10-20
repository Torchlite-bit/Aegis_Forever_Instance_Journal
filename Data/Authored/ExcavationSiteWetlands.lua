local _, ns = ...

--[[
	Excavation Site: Wetlands, written by hand over the generated data.

	From foreverchanges.pro's Excavation Site page (2026-10-09), read by hand, facts only, in our
	own words: the level range Blizzard gives, how each fight goes, the Highland Horror (a fourth
	boss the other sources lack, with the model the site gives him), the Alliance's Titan
	Relic, the lead-in quests and the boss spots on Santiago Reyes's newer map (Media/Maps), the
	labelled one that faces the other way from the picture the journal had.

	Loads after FromGuides.lua, whose quests it links into their chains.
]]

ns.AmendInstance("ExcavationSiteWetlands", {
	levelMax = 31,

	addBosses = {
		{
			name = "Highland Horror",
			displayID = 9010,
			level = 28,
			loot = { { itemID = 270180, name = "Horrible Rootcore", slot = "Quest Item", quality = 1 } },
		},
	},
	bossOrder = { "Saltspine", "Shadetooth", "Highland Horror", "Relic Guardian" },

	bosses = {
		["Saltspine"] = {
			notes = {
				"A dust storm hits the whole group now and then, and he slows the tank.",
				"He roams the marsh near the start among elite crocolisks: clear them first, or pull him away from them.",
			},
			mapPin = { x = 0.498, y = 0.395, floor = 1 },
			area = "Lost Marsh",
		},
		["Shadetooth"] = {
			notes = {
				"Kill the raptor matriarch in the tall grass. Her death brings a wave of raptors, and Shadetooth comes once they are dead: finish the whole wave before he arrives.",
				"Small raptors leap out of the grass as you walk through it, and make you bleed.",
				"About every 20 seconds he fears up to three players near him: a shaman's Tremor Totem helps. Late in the fight he enrages.",
			},
			mapPin = { x = 0.400, y = 0.483, floor = 1 },
			area = "Stalker's Thicket",
		},
		["Highland Horror"] = {
			notes = {
				"He stands in a Dragonmaw camp. Its groups pull apart easily: take them one at a time first. The fight itself is short.",
				"Drops the Horrible Rootcore for Horrors in the Highland.",
			},
			mapPin = { x = 0.082, y = 0.395, floor = 1 },
		},
		["Relic Guardian"] = {
			notes = {
				"The last boss stands still at the end of the spider trail: click the small panel beside him to wake him.",
				"His Knock Away throws the tank back and drops his threat: damage dealers, ease off when the tank loses him; tank, take him back at once.",
				"Drops the Titan Relic that starts each side's relic quest.",
			},
			mapPin = { x = 0.345, y = 0.685, floor = 1 },
			area = "Site of the Guardian",
		},
	},

	-- The areas a recorded run passed through (2026-10-16), and where it came in.
	areas = { "Lost Marsh", "Stalker's Thicket", "Lost Dig Site", "Site of the Guardian" },

	-- Where each quest is given and handed in, and which quests it needs, as the site's quest pages
	-- give them (2026-10-16). Seeking Caitlin leads to these but is not needed for them. The labels
	-- where each starts are the ones Locales/ruRU_content.lua translates already. The quest audit
	-- (Data/Authored/QuestAudit.lua, 2026-10-20) corrected the rest from QuestieDB's Forever data:
	-- Horrors in the Highland needs Rethiel's three quests, Highland Hides needs Young Crocolisk
	-- Skins, and Dorin Songblade stands where Forever's redrawn Redridge has him.
	questPatches = {
		[95647] = {
			prerequisites = {},
			startMap = { mapID = 1437, x = 0.118, y = 0.586, label = "Caitlin Grassman, Menethil Harbor" },
		},
		[98824] = {
			prerequisites = { { questID = 95810, name = "Lost Relic Carry" } },
			startMap = { mapID = 1437, x = 0.388, y = 0.522, label = "Prospector Whelgar, Whelgar's Excavation Site, Wetlands" },
			endMap = { mapID = 1455, x = 0.696, y = 0.186, label = "High Explorer Magellas, Hall of Explorers" },
		},
		[98823] = {
			prerequisites = { { questID = 95664, name = "Elder Knowledge" } },
			endMap = { mapID = 1412, x = 0.334, y = 0.224, label = "Muln Earthfury, Skywatcher Plateau" },
		},
		[95682] = {
			startMap = { mapID = 1437, x = 0.514, y = 0.592, label = "Deathstalker Agent, in the hills above the Dragonmaw camp" },
			endMap = { mapID = 1437, x = 0.514, y = 0.592, label = "Deathstalker Agent, in the hills above the Dragonmaw camp" },
			note = "Zaruk in the Arathi Highlands sends you to her with Dragonmaw Rumors. The Dragonmaw Dispatch comes "
				.. "from the Dragonmaw forces inside the dungeon.",
		},
		[95697] = { endMap = { mapID = 1454, x = 0.574, y = 0.534, label = "Borstan, The Drag, Orgrimmar" } },
		[98815] = {
			startMap = { mapID = 1437, x = 0.086, y = 0.556, label = "James Halloran — Menethil Harbor" },
			endMap = { mapID = 1437, x = 0.086, y = 0.556, label = "James Halloran, Menethil Harbor" },
		},
		[95646] = {
			endMap = { mapID = 1437, x = 0.562, y = 0.404, label = "Rethiel the Greenwarden" },
			note = "Most players come to Rethiel by The Greenwarden, from First Mate Fitzsimmons in Menethil "
				.. "Harbor: it leads to Tramping Paws but is not needed for it.",
		},
		[95809] = { endMap = { mapID = 1437, x = 0.118, y = 0.586, label = "Caitlin Grassman, Menethil Harbor" } },
		[95810] = { endMap = { mapID = 1437, x = 0.388, y = 0.522, label = "Prospector Whelgar, Whelgar's Excavation Site" } },
		[95664] = { endMap = { mapID = 1456, x = 0.708, y = 0.338, label = "Bashana Runetotem, Elder Rise" } },
	},
})

-- The rewards the quest pages give beyond the generated data's: the right experience, how many of
-- each item, and the items that come with the choice.
local REWARD_FIXES = {
	[95682] = { xp = 6950, also = { { itemID = 271745, name = "Bloody Map", quality = 1 } } },
	[95697] = {
		also = {
			{ itemID = 250185, name = "Recipe: Twice-Spiced Raptor Slice", quality = 1 },
			{ itemID = 250077, name = "Twice-Spiced Raptor Slice", quality = 1, count = 5 },
		},
	},
	[95809] = {
		counts = { [1710] = 4, [3827] = 4 },
		also = {
			{ itemID = 2459, name = "Swiftness Potion", quality = 1 },
			{ itemID = 280766, name = "Satchel of Potions", quality = 3 },
		},
	},
	[98824] = { xp = 6150 },
	[98823] = { xp = 6950 },
}

local excavation = ns.GetInstance("ExcavationSiteWetlands")
if excavation then
	-- Each side's Titan Relic drops from the Relic Guardian; the generated data has the Horde's only.
	for _, boss in ipairs(excavation.bosses) do
		if boss.name == "Relic Guardian" then
			local has = false
			for _, row in ipairs(boss.loot) do has = has or row.itemID == 270865 end
			if not has then
				table.insert(boss.loot, { itemID = 270865, name = "Titan Relic", slot = "Quest Item", quality = 1 })
			end
		end
	end
	if excavation.map then excavation.map.entrance = { x = 0.887, y = 0.260, floor = 1 } end
	for _, quest in ipairs(excavation.quests) do
		local fix = REWARD_FIXES[quest.questID]
		if fix then
			quest.rewards = quest.rewards or {}
			quest.rewards.xp = fix.xp or quest.rewards.xp
			quest.rewards.also = fix.also
			for _, item in ipairs(quest.rewards.items or {}) do
				item.count = fix.counts and fix.counts[item.itemID] or item.count
			end
		end
	end
end
