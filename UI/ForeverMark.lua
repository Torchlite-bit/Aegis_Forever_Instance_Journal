local _, ns = ...
local L = ns.L

--[[
	What is new in WoW: Forever (its own dungeons and raids, its new reputations) carries a mark:
	retail's way of calling out something new, white words on a soft gold glow (its
	NewFeatureLabel, without the pulse), saying "New in Forever". Built here rather than from
	the template, which needs the client's layout frames.
]]
local GLOW_ATLAS = "collections-newglow"

function ns.CreateForeverMark(parent)
	local mark = CreateFrame("Frame", nil, parent)
	mark:SetSize(10, 16)
	mark.Label = mark:CreateFontString(nil, "OVERLAY", ns.Font("GameFontHighlightSmall", "GameFontNormalSmall"))
	mark.Label:SetPoint("CENTER")
	mark.Label:SetText(L.FOREVER_MARK)
	mark.Label:SetShadowColor(0.4, 0.2, 0, 1)
	mark.Label:SetShadowOffset(1, -1)
	mark.Glow = mark:CreateTexture(nil, "ARTWORK")
	if not pcall(mark.Glow.SetAtlas, mark.Glow, GLOW_ATLAS) then mark.Glow:Hide() end
	mark.Glow:SetPoint("TOPLEFT", mark.Label, "TOPLEFT", -14, 8)
	mark.Glow:SetPoint("BOTTOMRIGHT", mark.Label, "BOTTOMRIGHT", 14, -8)
	mark:SetWidth(mark.Label:GetStringWidth() + 4)
	mark:Hide()
	return mark
end
