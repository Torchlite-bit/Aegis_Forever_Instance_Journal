local _, ns = ...

--[[
	The Scarlet Monastery's wings, written by hand over their own data (Data/Instances).
	Facts from warcraft.wiki.gg, "Scarlet Monastery Graveyard" and "Scarlet Monastery Library"
	(CC BY-SA 4.0), in our own words.

	To the client every wing is the same instance (189), so each wing lists the areas inside it
	(wingAreas): the journal tells which wing the player is in by the area's name.
]]

ns.AmendInstance("ScarletMonasteryGraveyard", {
	description = "The Scarlet Monastery was a seat of Lordaeron's priesthood until the Scarlet Crusade made it "
		.. "their stronghold after the Third War. In its graveyard wing the Crusade's interrogators work, and "
		.. "the dead buried there no longer rest.",

	wingAreas = { ["Chamber of Atonement"] = true, ["Forlorn Cloister"] = true, ["Honor's Tomb"] = true },
	areas = { "Chamber of Atonement", "Forlorn Cloister", "Honor's Tomb" },

	bosses = {
		["Interrogator Vishas"] = { area = "Chamber of Atonement" },
		["Azshir the Sleepless"] = { area = "Forlorn Cloister" },
		["Fallen Champion"] = { area = "Forlorn Cloister" },
		["Ironspine"] = { area = "Forlorn Cloister" },
		["Bloodmage Thalnos"] = { area = "Honor's Tomb" },
	},
})

ns.AmendInstance("ScarletMonasteryLibrary", {
	description = "The monastery's library wing, where the Crusade's huntsmen keep their hounds and Arcanist Doan "
		.. "guards the Athenaeum and the key to the rest of the monastery.",

	wingAreas = { ["Huntsman's Cloister"] = true, ["Gallery of Treasures"] = true, ["Athenaeum"] = true },
	areas = { "Huntsman's Cloister", "Gallery of Treasures", "Athenaeum" },

	bosses = {
		["Houndmaster Loksey"] = {
			area = "Huntsman's Cloister",
			notes = { "His Scarlet Tracking Hounds fight beside him: kill them first. He uses Bloodlust." },
		},
		["Arcanist Doan"] = {
			area = "Athenaeum",
			notes = { "His Arcane Explosion hits everyone close to him, and Detonation hits harder still: keep your distance when he readies it." },
		},
	},
})

-- The Cathedral's two quests send you through the Armory too, for Herod: the Armory lists them as well
-- (foreverchanges.pro's page for it does). The world map still marks each once.
do
	local herodQuests = {}
	for _, quest in ipairs(ns.GetInstance("ScarletMonasteryCathedral").quests) do
		if quest.questID == 1053 or quest.questID == 1048 then herodQuests[#herodQuests + 1] = quest end
	end
	ns.AmendInstance("ScarletMonasteryArmory", { addQuests = herodQuests })
end