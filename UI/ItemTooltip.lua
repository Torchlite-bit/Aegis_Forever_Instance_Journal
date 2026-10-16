local _, ns = ...
local L = ns.L

--[[
	The Gear Finder's stat weights on every item's tooltip, as Pawn shows its scales: in the bags,
	on the character sheet, in loot, a merchant's wares, links in chat and the Gear Finder's own.
	Under the item, a line for each spec of the class, in its order: the spec, and what the item is
	worth to it. Where it beats what is worn, the green arrow before the spec and, beside its worth,
	what it adds to the gear: the share the Gear Finder shows ("+4.2%"). These are the journal's own
	lines, from its own weights (Core/ItemScore.lua).

	Left out: items the class cannot use, ones with no slot, and specs the item is worth nothing to.
	The Show stat weights in tooltips box (the weights editor, the journal's options) turns them off,
	with the Gear Finder's own lines.
]]

local ItemTooltip = {}
ns.ItemTooltip = ItemTooltip

local SPEC_COLOR = { 1, 0.82, 0 }
local GAIN_COLOR = { 0.25, 1, 0.25 }
local GAIN_HEX, LATER_HEX = "|cff40ff40", "|cffff2020"

-- The tooltips that show an item for itself: the main one, a chat link's, and the ones beside
-- each with what is worn.
local TOOLTIPS = { "GameTooltip", "ItemRefTooltip", "ShoppingTooltip1", "ShoppingTooltip2",
	"ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2" }

local function Wanted(tooltip)
	for _, name in ipairs(TOOLTIPS) do
		if _G[name] == tooltip then return true end
	end
	return false
end

-- The equipment flyout's green arrow, as the Gear Finder marks its upgrades, in the line's text.
local arrow
local function Arrow()
	if arrow == nil then
		arrow = ns.AtlasExists("bags-greenarrow") and "|A:bags-greenarrow:0:0|a "
			or "|TInterface\\Buttons\\UI-MicroStream-Green:0|t "
	end
	return arrow
end

-- A link that can be read: not one the client withholds.
local function Readable(link)
	if ns.IsSecret(link) or type(link) ~= "string" or link == "" then return nil end
	return link
end

-- The item the tooltip shows, from its data, else as the client says it.
local function ShownLink(tooltip, data)
	local link = Readable(data and data.hyperlink)
	if not link and TooltipUtil and TooltipUtil.GetDisplayedItem then
		local ok, _, displayed = pcall(TooltipUtil.GetDisplayedItem, tooltip)
		if ok then link = Readable(displayed) end
	end
	if not link and tooltip.GetItem then
		local ok, _, shown = pcall(tooltip.GetItem, tooltip)
		if ok then link = Readable(shown) end
	end
	return link
end

-- The tooltips beside another that show what is worn, to compare with.
local SHOWS_WORN = { "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2" }

-- Whether the client was asked to show one of the player's own slots: the tooltip's info
-- (TooltipDataHandlerMixin:GetPrimaryTooltipInfo), the getter it was filled by, with its unit and slot.
local function ShowsPlayerSlot(tooltip)
	local ok, info = pcall(function() return tooltip.GetPrimaryTooltipInfo and tooltip:GetPrimaryTooltipInfo() end)
	if not ok or type(info) ~= "table" or info.getterName ~= "GetInventoryItem" or type(info.getterArgs) ~= "table" then
		return false
	end
	return info.getterArgs[1] == "player" and type(info.getterArgs[2]) == "number"
end

--[[
	Whether the tooltip shows an item the player wears, the one others are measured against:
	the very copy, not another of the same item (a second ring, the same green "of the Monkey"
	rather than "of the Bear"). The client names each copy (its guid) in the bags and on the
	character sheet; without one, the sheet's own slots still say so. A link in chat, a drop or a
	merchant's ware is the item, not the copy worn, and is weighed as the Gear Finder weighs it.
]]
local FIRST_SLOT, LAST_SLOT = 1, 19
local function IsWorn(tooltip, data)
	for _, name in ipairs(SHOWS_WORN) do
		if _G[name] == tooltip then return true end
	end
	local guid = data and data.guid
	if ns.IsSecret(guid) or type(guid) ~= "string" then guid = nil end
	if guid and C_Item and C_Item.GetItemGUID and ItemLocation and ItemLocation.CreateFromEquipmentSlot then
		for slot = FIRST_SLOT, LAST_SLOT do
			local ok, worn = pcall(C_Item.GetItemGUID, ItemLocation:CreateFromEquipmentSlot(slot))
			if ok and not ns.IsSecret(worn) and worn == guid then return true end
		end
		return false
	end
	return ShowsPlayerSlot(tooltip)
end

--[[
	The Gear Finder's tooltips show the gain it found for its own spec (UI/GearPanel.lua): on its
	second ring or trinket cell, the gain over the other, stronger one, as the cell itself says. Kept
	by the frame the tooltip belongs to, for that item only.
]]
local givenCompare = setmetatable({}, { __mode = "k" })

function ItemTooltip:UseCompare(owner, link, compare)
	givenCompare[owner] = link and { link = link, compare = compare } or nil
end

-- Whether an item is an upgrade for the player, by the Gear Finder's spec: the green arrows on
-- items in the bags, the loot window and rolls (UI/UpgradeArrows.lua).
function ItemTooltip:IsUpgrade(link)
	local IS = ns.ItemScore
	local compare = IS:Compare(link)
	return compare ~= nil and compare.usable and compare.delta ~= nil and compare.delta > 0.0001
		and compare.minLevel <= IS:Level() + ns.GearFinder.AHEAD
end

--[[
	The lines for an item, one per spec it is worth something to, in the class's order:
	{ label, value = "145", gain = "+4.2%" or nil, level = 24 or nil }; nil when there are none.
	A gain is an upgrade as the Gear Finder counts one: worn within its few levels ahead (`level`
	when not yet), and not the item worn itself or an off hand beside a two-hander.
]]
function ItemTooltip:Lines(link, tooltip, data)
	local IS = ns.ItemScore
	local rows, worn = {}, nil
	local reach = IS:Level() + ns.GearFinder.AHEAD
	local owner = tooltip and tooltip.GetOwner and tooltip:GetOwner()
	local given = owner and givenCompare[owner]
	if given and given.link ~= link then given = nil end
	local current = IS:Spec()
	for _, spec in ipairs(IS:Specs()) do
		local compare = (given and spec.key == current) and given.compare or IS:Compare(link, IS:Weights(spec.key))
		-- What the class cannot use, or what goes in no slot, is so for every spec.
		if not compare or not compare.usable then return nil end
		if compare.score > 0 then
			local row = { label = spec.label, value = ns.GearPanel.Points(compare.score) }
			if compare.delta and compare.delta > 0.0001 and compare.minLevel <= reach then
				if worn == nil then worn = IsWorn(tooltip, data) end
				if not worn then
					row.gain = ns.GearPanel.GainText(compare)
					if compare.later then row.level = compare.minLevel end
				end
			end
			rows[#rows + 1] = row
		end
	end
	return #rows > 0 and rows or nil
end

local function OnItem(tooltip, data)
	if not (ns.charDB and ns.GearPanel.ShowsGains()) then return end
	if tooltip.IsForbidden and tooltip:IsForbidden() then return end
	if not Wanted(tooltip) then return end
	local link = ShownLink(tooltip, data)
	local rows = link and ItemTooltip:Lines(link, tooltip, data)
	if not rows then return end
	for _, row in ipairs(rows) do
		local left, right, color = row.label, row.value, SPEC_COLOR
		if row.gain then
			-- "↑ Retribution     +4.2%  145", the level it waits for in red: "+4.2% (24)".
			left, color = Arrow() .. left, GAIN_COLOR
			local level = row.level and (" " .. LATER_HEX .. "(" .. row.level .. ")|r") or ""
			right = GAIN_HEX .. row.gain .. "|r" .. level .. "  " .. right
		end
		tooltip:AddDoubleLine(left, right, color[1], color[2], color[3], 1, 1, 1)
	end
end

-- The client's item tooltips all come through its tooltip data, Forever's as retail's.
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItem)
end
