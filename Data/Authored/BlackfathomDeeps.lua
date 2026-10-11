local _, ns = ...

--[[
	Blackfathom Deeps, written by hand over the generated data.
	Facts from warcraft.wiki.gg, "Blackfathom Deeps (Classic)" (CC BY-SA 4.0), in our own words.
]]

ns.AmendInstance("BlackfathomDeeps", {
	description = "Once a temple to Elune on the Ashenvale shore, Blackfathom Deeps sank beneath the sea in the "
		.. "Sundering. The Twilight's Hammer now holds its flooded halls, guarding Aku'mai, a beast prized by the "
		.. "Old Gods, while naga and murlocs prowl its pools.",

	areas = { "Pool of Ask'ar", "Moonshrine Ruins", "The Forgotten Pool", "Moonshrine Sanctum", "Aku'mai's Lair" },

	bosses = {
		["Ghamoo-ra"] = {
			area = "Pool of Ask'ar",
			notes = { "A giant turtle in the first great pool." },
		},
		["Lady Sarevess"] = {
			area = "Pool of Ask'ar",
			notes = { "A naga sorceress in a side cavern off the pool; optional." },
		},
		["Gelihast"] = {
			notes = { "A murloc chieftain in his shrine. His followers run for help when they are low on health, so finish them off." },
		},
		["Lorgus Jett"] = {
			notes = { "A Twilight's Hammer shaman patrolling the tunnels." },
		},
		["Old Serra'kis"] = {
			area = "The Forgotten Pool",
			notes = { "A threshadon in the underwater cave; optional." },
		},
		["Twilight Lord Kelris"] = {
			area = "Moonshrine Sanctum",
			notes = {
				"Clear the cultists around him one group at a time before pulling him.",
				"The braziers of the sanctum open the way to Aku'mai; each one lit calls a wave of enemies, so rest between them.",
			},
		},
		["Aku'mai"] = {
			area = "Aku'mai's Lair",
			notes = { "The hydra at the end of the Deeps, and the hardest fight here: keep a steady tank and healer on it." },
		},
	},
})
