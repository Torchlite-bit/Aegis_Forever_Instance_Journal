local addonName, ns = ...
local L = ns.L

--[[
	What is new in WoW: Forever (its own dungeons and raids) carries WoW: Forever's emblem in the
	corner of its button (Media/ForeverIcon, made by Tools/make_raid_art.py). Hovering it says
	what it means; clicks pass through to the button beneath.
]]
ns.FOREVER_ICON = "Interface\\AddOns\\" .. addonName .. "\\Media\\ForeverIcon"
local ICON_SIZE = 22

-- The emblem inline in a line of text.
function ns.ForeverIconText(size)
	return string.format("|T%s:%d:%d|t", ns.FOREVER_ICON, size or 14, size or 14)
end

function ns.CreateForeverMark(parent)
	local mark = CreateFrame("Frame", nil, parent)
	mark:SetSize(ICON_SIZE, ICON_SIZE)
	mark.Icon = mark:CreateTexture(nil, "OVERLAY")
	mark.Icon:SetAllPoints()
	mark.Icon:SetTexture(ns.FOREVER_ICON)
	-- A tooltip on hover, without taking the button's clicks.
	if mark.SetMouseMotionEnabled and mark.SetMouseClickEnabled then
		mark:SetMouseMotionEnabled(true)
		mark:SetMouseClickEnabled(false)
		mark:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L.FOREVER_MARK, 1, 1, 1)
			GameTooltip:Show()
		end)
		mark:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	mark:Hide()
	return mark
end
