local _, ns = ...

--[[
	Pieces of the journal's texture sheet, at the sizes and coordinates Blizzard's own
	Blizzard_EncounterJournal.xml declares them. That file does not load on Forever, so its
	virtual textures are not there to inherit; these are the same cuts of the same files.
]]

local SHEET = "Interface\\EncounterJournal\\UI-EncounterJournalTextures"
local TILE = "Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile"

-- name = { width, height, left, right, top, bottom [, file] }; the file defaults to SHEET.
local PIECES = {
	-- The paper strips of the abilities tree (EncounterInfoTemplate), collapsed and expanded.
	["PaperHeader-UnSelectUp-Left"] = { 64, 29, 0.84960938, 0.97460938, 0.49023438, 0.51855469 },
	["PaperHeader-UnSelectUp-Right"] = { 64, 29, 0.72656250, 0.85156250, 0.52441406, 0.55273438 },
	["PaperHeader-UnSelectUp-Mid"] = { 64, 29, 0, 1, 0.34375000, 0.40039063, TILE },
	["PaperHeader-UnSelectDown-Left"] = { 64, 29, 0.47460938, 0.59960938, 0.49316406, 0.52148438 },
	["PaperHeader-UnSelectDown-Right"] = { 64, 29, 0.60351563, 0.72851563, 0.49316406, 0.52148438 },
	["PaperHeader-UnSelectDown-Mid"] = { 64, 29, 0, 1, 0.28320313, 0.33984375, TILE },
	["PaperHeader-SelectUp-Left"] = { 64, 29, 0.81445313, 0.93945313, 0.39453125, 0.42285156 },
	["PaperHeader-SelectUp-Right"] = { 64, 29, 0.34570313, 0.47070313, 0.49316406, 0.52148438 },
	["PaperHeader-SelectUp-Mid"] = { 64, 29, 0, 1, 0.22265625, 0.27929688, TILE },
	["PaperHeader-SelectDown-Left"] = { 64, 29, 0.64062500, 0.76562500, 0.21386719, 0.24218750 },
	["PaperHeader-SelectDown-Right"] = { 64, 29, 0.76953125, 0.89453125, 0.21386719, 0.24218750 },
	["PaperHeader-SelectDown-Mid"] = { 64, 29, 0, 1, 0.40429688, 0.46093750, TILE },
	["PaperHeader-Highlight-Left"] = { 64, 29, 0.74218750, 0.86718750, 0.15820313, 0.18652344 },
	["PaperHeader-Highlight-Right"] = { 64, 29, 0.87109375, 0.99609375, 0.15820313, 0.18652344 },
	["PaperHeader-Highlight-Mid"] = { 64, 29, 0, 1, 0.46484375, 0.52148438, TILE },
	["AbilityTextBG"] = { 256, 80, 0.00195313, 0.50195313, 0.02246094, 0.10058594 },
	["AbilityTextBottomBorder"] = { 243, 9, 0.04492188, 0.51953125, 0.00097656, 0.00976563 },

	["BossButton-Up"] = { 325, 55, 0.00195313, 0.63671875, 0.21386719, 0.26757813 },
	["BossButton-Down"] = { 325, 55, 0.00195313, 0.63671875, 0.10253906, 0.15625000 },
	["BossButton-Highlight"] = { 325, 55, 0.00195313, 0.63671875, 0.15820313, 0.21191406 },
	["BossModelButton"] = { 64, 61, 0.50585938, 0.63085938, 0.02246094, 0.08203125 },
	["DungeonButton-Up"] = { 174, 96, 0.00195313, 0.34179688, 0.42871094, 0.52246094 },
	["DungeonButton-Down"] = { 174, 96, 0.00195313, 0.34179688, 0.33300781, 0.42675781 },
	["DungeonButton-Highlight"] = { 174, 96, 0.34570313, 0.68554688, 0.33300781, 0.42675781 },
	["DungeonNameBg"] = { 256, 64, 0.34570313, 0.84570313, 0.42871094, 0.49121094 },
	["Tab-Highlight"] = { 63, 57, 0.00195313, 0.12500000, 0.90332031, 0.95898438 },
	["Tab-Selected"] = { 63, 57, 0.12890625, 0.25195313, 0.90332031, 0.95898438 },
	["Tab-UnSelected"] = { 63, 57, 0.25585938, 0.37890625, 0.90332031, 0.95898438 },
	["Tab-BossIcon-Selected"] = { 48, 43, 0.90234375, 0.99609375, 0.26953125, 0.31152344 },
	["Tab-BossIcon-UnSelected"] = { 48, 43, 0.85546875, 0.94921875, 0.52441406, 0.56640625 },
	["Tab-LootIcon-Selected"] = { 48, 43, 0.63281250, 0.72656250, 0.61816406, 0.66015625 },
	["Tab-LootIcon-UnSelected"] = { 48, 43, 0.73046875, 0.82421875, 0.61816406, 0.66015625 },
	["Tab-AbilitiesIcon-Selected"] = { 48, 43, 0.806640625, 0.8984375, 0.70703125, 0.748046875 },
	["Tab-AbilitiesIcon-UnSelected"] = { 48, 43, 0.904296875, 0.99609375, 0.70703125, 0.748046875 },
	["Tab-ModelIcon-Selected"] = { 48, 43, 0.8046875, 0.900390625, 0.662109375, 0.705078125 },
	["Tab-ModelIcon-UnSelected"] = { 48, 43, 0.90234375, 1, 0.662109375, 0.705078125 },
	-- The model page (the encounter frame's ModelFrame): its backdrop, paper frame and name shadow.
	["BossNameShadow"] = { 395, 63, 0.00195313, 0.77343750, 0.26953125, 0.33105469 },
	["LeftPageHeader"] = { 386, 39, 0, 0.755859375, 0.9599609375, 1 },
	["RightPageHeader"] = { 386, 39, 0.755859375, 0, 0.9599609375, 1 },
	["Header-Overview"] = { 327, 30, 0.359375, 0.99609375, 0.8525390625, 0.880859375 },
	["PaperOverlay-Bullet"] = { 13, 13, 0.974609375, 1.0, 0.7509765625, 0.763671875 },
	["ShowMapBG"] = { 171, 50, 0.00195313, 0.33593750, 0.85253906, 0.90136719 },
	["LootFrame"] = { 321, 45, 0.00195313, 0.62890625, 0.61816406, 0.66210938 },
	["FilterBar"] = { 320, 28, 0.00195313, 0.62695313, 0.58886719, 0.61621094 },
	["DungeonLootFrame"] = { 369, 64, 0.00195313, 0.72265625, 0.52441406, 0.58691406 },
}

-- Gives a texture one of the pieces. keepSize leaves its size alone, as for a button's own textures.
function ns.Art(texture, name, keepSize)
	local piece = PIECES[name]
	if not piece then error("unknown journal art: " .. tostring(name), 2) end
	texture:SetTexture(piece[7] or SHEET)
	texture:SetTexCoord(piece[3], piece[4], piece[5], piece[6])
	if not keepSize then texture:SetSize(piece[1], piece[2]) end
	return texture
end

function ns.ArtSize(name)
	local piece = PIECES[name]
	return piece[1], piece[2]
end

-- Normal, pushed, highlight (added) and disabled textures for a button, any of which may be nil.
function ns.SetButtonArt(button, normal, pushed, highlight, disabled)
	if normal then
		button:SetNormalTexture(SHEET)
		ns.Art(button:GetNormalTexture(), normal, true)
	end
	if pushed then
		button:SetPushedTexture(SHEET)
		ns.Art(button:GetPushedTexture(), pushed, true)
	end
	if highlight then
		button:SetHighlightTexture(SHEET, "ADD")
		ns.Art(button:GetHighlightTexture(), highlight, true)
	end
	if disabled then
		button:SetDisabledTexture(SHEET)
		ns.Art(button:GetDisabledTexture(), disabled, true)
	end
end

-- The parchment text colour Blizzard's journal uses for body text on its pages.
ns.PARCHMENT_TEXT_COLOR = { 0.25, 0.1484375, 0.02 }
-- The page-header colour for instance and boss names.
ns.PAGE_TITLE_COLOR = { 0.902, 0.788, 0.671 }
-- The label on a section bar (Header-Overview), such as a boss page's "Overview".
ns.HEADER_LABEL_COLOR = { 0.929, 0.788, 0.620 }
