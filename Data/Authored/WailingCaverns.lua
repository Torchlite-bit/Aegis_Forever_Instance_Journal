local _, ns = ...

--[[
	Wailing Caverns, written by hand over the generated data.

	Run order, areas and the Naralex event from warcraft.wiki.gg, "Wailing Caverns" (CC BY-SA 4.0),
	in our own words. The bosses' abilities are in Data/Authored/Abilities.lua; the role alerts
	here are for spells that list lacks (a recording's), and the abilities written out below are
	for the Deviate Faerie Dragon, which it does not cover. Recordings from the Record tab will
	correct them.
]]

local ICONS = "Interface\\Icons\\"

-- Role alerts for the spells the combat logs saw, by spell id. The Fanglords' Healing Touch
-- comes in three ranks.
local FANG_SPELLS = {
	[9532] = { "Interruptible" },              -- Lightning Bolt
	[5187] = { "Interruptible", "Important" }, -- Healing Touch
	[5188] = { "Interruptible", "Important" }, -- Healing Touch
	[6778] = { "Interruptible", "Important" }, -- Healing Touch
	[8040] = { "Interruptible", "Magic" },     -- Druid's Slumber
	[700] = { "Magic" },                       -- Sleep
	[8148] = { "Magic" },                      -- Thorns Aura
	[8147] = { "Healer" },                     -- Thunderclap
	[7965] = { "Tank" },                       -- Cobrahn Serpent Form
}

ns.AmendInstance("WailingCaverns", {
	description = "Druids of the Cenarion Circle came to these caves to heal the land, but their leader Naralex "
		.. "fell into a nightmare. His disciples, the Druids of the Fang, have turned the caverns into a "
		.. "twisted den of deviate creatures.",

	areas = { "Screaming Gully", "Pit of Fangs", "Crag of the Everliving", "Dreamer's Rock", "Cavern of Mists" },

	bossOrder = {
		"Lady Anacondra", "Kresh", "Lord Cobrahn", "Lord Pythas", "Deviate Faerie Dragon",
		"Skum", "Lord Serpentis", "Verdan the Everliving", "Mutanus the Devourer",
	},

	bosses = {
		["Lady Anacondra"] = {
			area = "Screaming Gully",
			notes = { "One of the four Fanglords; killing all four lets the Disciple of Naralex begin the ritual." },
			spellFlags = FANG_SPELLS,
		},
		["Kresh"] = {
			area = "Pit of Fangs",
			notes = { "A giant turtle that will not attack first; killing him is optional." },
		},
		["Lord Cobrahn"] = {
			area = "Pit of Fangs",
			notes = { "A Fanglord who turns into a serpent partway through the fight." },
			spellFlags = FANG_SPELLS,
		},
		["Lord Pythas"] = {
			area = "Pit of Fangs",
			notes = { "The toughest Fanglord, with heavy melee and a large health pool." },
			spellFlags = FANG_SPELLS,
		},
		["Deviate Faerie Dragon"] = {
			area = "Crag of the Everliving",
			extraAbilities = {
				{ title = "Sleep", icon = ICONS .. "Spell_Nature_Sleep",
					description = "Puts a player to sleep.", flags = { "Magic" } },
				{ title = "Arcane Explosion", icon = ICONS .. "Spell_Nature_WispSplode",
					description = "Blasts everyone nearby with arcane energy.", flags = { "Healer" } },
			},
		},
		["Skum"] = {
			area = "Crag of the Everliving",
			notes = { "A thunder lizard in the water; killing him is optional." },
			spellFlags = { [6254] = { "Healer" } }, -- Chained Bolt
		},
		["Lord Serpentis"] = {
			area = "Crag of the Everliving",
			notes = { "The last Fanglord, a plain melee fighter with fewer hit points than Pythas." },
			spellFlags = FANG_SPELLS,
		},
		["Verdan the Everliving"] = {
			area = "Crag of the Everliving",
			notes = { "A massive plant creature; optional." },
			spellFlags = { [8142] = { "Healer", "Important" } }, -- Grasping Vines
		},
		["Mutanus the Devourer"] = {
			area = "Dreamer's Rock",
			notes = {
				"With all four Fanglords dead, speak to the Disciple of Naralex at the entrance and escort him to Naralex.",
				"Guard the Disciple through waves of serpents and then oozes; Mutanus surfaces right after the oozes.",
			},
			spellFlags = {
				[8150] = { "Important" }, -- Thundercrack
				[7967] = { "Magic" },     -- Naralex's Nightmare
				[7399] = { "Important" }, -- Terrify
			},
		},
	},
})
