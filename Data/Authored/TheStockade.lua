local _, ns = ...

--[[
	The Stockade, written by hand over the generated data.
	Facts from warcraft.wiki.gg, "Stormwind Stockade (Classic)" (CC BY-SA 4.0), in our own words.
	Its map and boss spots, the cells included, are foreverchanges.pro's (Data/Authored/ClassicMaps.lua).
]]

ns.AmendInstance("TheStockade", {
	description = "Stormwind's prison beneath the canals has fallen to a riot. Led by Bazil Thredd of the Defias "
		.. "Brotherhood, the inmates have taken the cell blocks, and the Warden wants the ringleaders dealt with.",

	bosses = {
		["Targorr the Dread"] = {
			notes = { "A Blackrock orc who can be found in one of four cells." },
		},
		["Kam Deepfury"] = {
			notes = { "A Dark Iron dwarf held for his part in the Thandol Span attacks." },
		},
		["Hamhock"] = {
			notes = { "An ogre who throws lightning that jumps between players." },
			spellFlags = { [421] = { "Healer", "Interruptible" }, [6742] = { "Important", "Magic" } },
		},
		["Dextren Ward"] = {
			notes = {
				"His shout sends nearby players fleeing in fear.",
				"The prison is tight: a fleeing player can easily run into another cell block and bring it along.",
			},
			spellFlags = { [19134] = { "Important" }, [11976] = { "Tank" } },
		},
		["Bazil Thredd"] = {
			notes = { "The ringleader of the uprising, found in one of three places." },
			spellFlags = { [7964] = { "Important" } },
		},
		["Bruegal Ironknuckle"] = {
			notes = { "A rare spawn with two possible locations: not every run meets him." },
		},
	},

	-- Nikova Raskol stands at 73.3, 55.4 on Forever's Stormwind, read in game (2026-10-12).
	questPatches = {
		[388] = { startMap = { mapID = 1453, x = 0.733, y = 0.554, label = "Nikova Raskol — Old Town" } },
	},
})
