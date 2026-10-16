local _, ns = ...
local L = ns.L

--[[
	The Gear Finder's stat weights on every item's tooltip: in the bags, on the character sheet, in
	loot, a merchant's wares and links in chat. Under the item, what it is worth to the spec the
	Gear Finder scores for, and when it beats what is worn, the green arrow and what it adds to the
	gear, the share the Gear Finder shows ("+4.2%"). Pawn shows its scales on tooltips the same way;
	these are the journal's own lines, from its own weights (Core/ItemScore.lua).

	Left out: items the class cannot use, ones worth nothing to the spec or with no slot, and the
	Gear Finder's own tooltips (UI/GearPanel.lua), which say all this already. The weights' Show
	upgrades in tooltips box turns these off with the Gear Finder's own lines.
]]

local ItemTooltip = {}
ns.ItemTooltip = ItemTooltip

local VALUE_COLOR = { 1, 0.82, 0 }
local GAIN_COLOR = { 0.25, 1, 0.25 }

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

-- Whether the client was asked to show one of the player's own slots (retail's tooltip info:
-- the getter it was filled by, and that getter's unit and slot).
local function ShowsPlayerSlot(tooltip)
	local ok, info = pcall(function() return tooltip.GetPrimaryTooltipInfo and tooltip:GetPrimaryTooltipInfo() end)
	if not (ok and type(info) == "table") then info = rawget(tooltip, "info") end
	if type(info) ~= "table" or info.getterName ~= "GetInventoryItem" or type(info.getterArgs) ~= "table" then
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
	The lines for an item: { value = "145", upgrade = "+4.2%" or nil, level = 24 or nil }, or nil
	when it gets none. An upgrade, as the Gear Finder counts one: worn within its few levels
	ahead (`level` when not yet), and not the item worn itself or an off hand beside a two-hander.
]]
function ItemTooltip:Lines(link, tooltip, data)
	local IS = ns.ItemScore
	local compare = IS:Compare(link)
	if not compare or not compare.usable or compare.score <= 0 then return nil end
	local lines = { value = ns.GearPanel.Points(compare.score) }
	if compare.delta and compare.delta > 0.0001 and compare.minLevel <= IS:Level() + ns.GearFinder.AHEAD
		and not IsWorn(tooltip, data) then
		lines.upgrade = ns.GearPanel.GainText(compare)
		if compare.later then lines.level = compare.minLevel end
	end
	return lines
end

local function OnItem(tooltip, data)
	if not (ns.charDB and ns.GearPanel.ShowsGains()) then return end
	if tooltip.IsForbidden and tooltip:IsForbidden() then return end
	if not Wanted(tooltip) then return end
	-- The Gear Finder's own: it adds what an item is worth itself, and more.
	local owner = tooltip.GetOwner and tooltip:GetOwner()
	if type(owner) == "table" and rawget(owner, "gearFinderTip") then return end
	local link = ShownLink(tooltip, data)
	local lines = link and ItemTooltip:Lines(link, tooltip, data)
	if not lines then return end
	local IS = ns.ItemScore
	tooltip:AddDoubleLine(string.format(L.ITEM_TIP_VALUE, IS:SpecLabel(IS:Spec())), lines.value,
		VALUE_COLOR[1], VALUE_COLOR[2], VALUE_COLOR[3], 1, 1, 1)
	if lines.upgrade then
		local text = lines.level and string.format(L.ITEM_TIP_UPGRADE_LATER, lines.level, lines.upgrade)
			or string.format(L.ITEM_TIP_UPGRADE, lines.upgrade)
		tooltip:AddLine(Arrow() .. text, GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
	end
end

-- The client's item tooltips all come through its tooltip data, Forever's as retail's.
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItem)
end
