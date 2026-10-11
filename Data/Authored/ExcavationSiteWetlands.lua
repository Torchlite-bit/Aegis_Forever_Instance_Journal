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
				"Nothing special seen in the fight yet: he hits, and has a lot of health.",
				"He roams the marsh near the start among elite crocolisks: clear them first, or pull him away from them.",
			},
			mapPin = { x = 0.498, y = 0.395, floor = 1 },
		},
		["Shadetooth"] = {
			notes = {
				"Kill the raptor matriarch in the tall grass. Her death brings a wave of raptors, and Shadetooth comes once they are dead: finish the whole wave before he arrives.",
				"Small raptors leap out of the grass as you walk through it, and make you bleed.",
				"He fears the tank several times: a shaman's Tremor Totem helps.",
			},
			mapPin = { x = 0.400, y = 0.483, floor = 1 },
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
				"He drops his threat and changes target during the fight: damage dealers, ease off when the tank loses him; tank, take him back at once.",
				"Drops the Titan Relic that starts each side's relic quest.",
			},
			mapPin = { x = 0.345, y = 0.685, floor = 1 },
		},
	},

	questPatches = {
		[95647] = { prerequisites = { { questID = 95737, name = "Seeking Caitlin" } } },
		[95795] = { prerequisites = { { questID = 95772, name = "Songblade Search" } } },
		[98824] = { prerequisites = { { questID = 95810, name = "Lost Relic Carry" } } },
		[98823] = { prerequisites = { { questID = 95664, name = "Elder Knowledge" } } },
		[95682] = {
			startMap = { mapID = 1437, x = 0.514, y = 0.592, label = "Deathstalker Agent, in the hills above the Dragonmaw camp" },
			note = "Zaruk in the Arathi Highlands sends you to her with Dragonmaw Rumors. The Dragonmaw Dispatch comes "
				.. "from the Dragonmaw forces inside the dungeon.",
		},
	},
})

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
end
