local _, ns = ...
local L = ns.L

--[[
	The Gear Finder's upgrades on every item's tooltip: in the bags, on the character sheet, in
	loot, a merchant's wares, links in chat and the Gear Finder's own.
	Under the item, a line for each spec of the class it is an upgrade for, in the class's order:
	the green arrow, the spec, and what it adds to the gear, the share the Gear Finder shows
	("+4.2%"), and nothing more (the user found the item's worth and the level it waits for too
	much). These are the journal's own lines, from its own weights (Core/ItemScore.lua).

	Left out: items the class cannot use, ones with no slot, and specs the item is no upgrade for.
	The Show stat weights in tooltips box (the weights editor, the journal's options) turns them off,
	with the Gear Finder's own lines. While Pawn is installed and enabled its own tooltip lines are
	the ones shown, and these stand aside (Core/PawnLink.lua).

	Below them, where the item drops: "Drops from Edwin VanCleef in The Deadmines", on the item
	itself (the main tooltip and a chat link's, not the ones beside them with what is worn), for
	every item a dungeon's or raid's loot lists (ns.ItemDrops). An item of several bosses there or
	of a dungeon's trash says so; one of several dungeons names the dungeons. A faction's wares
	are sold, not dropped, and an item hidden until the server confirms it gets no line. The
	journal's own frames say where themselves (ItemTooltip:UseSource): a loot row names only the
	other dungeons, the Gear Finder and the search none. The journal's options turn it off; Pawn
	and the stat weights box leave it be.
]]

local ItemTooltip = {}
ns.ItemTooltip = ItemTooltip

local GAIN_COLOR = { 0.25, 1, 0.25 }
-- The Gear Finder's own line for where an item drops (UI/GearPanel.lua).
local SOURCE_COLOR = { 1, 0.82, 0 }
-- Places named before "and 2 more".
local MAX_PLACES = 3

-- The tooltips that show an item: the main one and a chat link's.
local SHOWS_ITEM = { "GameTooltip", "ItemRefTooltip" }
-- The tooltips beside another that show what is worn, to compare with.
local SHOWS_WORN = { "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2" }

local function IsOneOf(tooltip, names)
	for _, name in ipairs(names) do
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
	if IsOneOf(tooltip, SHOWS_WORN) then return true end
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
	The lines for an item, one per spec it is an upgrade for, in the class's order:
	{ label, gain = "+4.2%" }; nil when there are none. An upgrade as the Gear Finder counts one:
	worn within its few levels ahead, and not the item worn itself or an off hand beside a
	two-hander.
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
		if compare.score > 0 and compare.delta and compare.delta > 0.0001 and compare.minLevel <= reach then
			-- The item worn is no upgrade on itself, for any spec.
			if worn == nil then worn = IsWorn(tooltip, data) end
			if worn then return nil end
			rows[#rows + 1] = { label = spec.label, gain = ns.GearPanel.GainText(compare) }
		end
	end
	return #rows > 0 and rows or nil
end

------------------------------------------------------------------------------------------
-- Where it drops
------------------------------------------------------------------------------------------

-- On by default, for the whole account: the journal's options.
function ItemTooltip.ShowsSources()
	return not (ns.db and ns.db.hideItemSources)
end

function ItemTooltip.SetShowsSources(shown)
	ns.db.hideItemSources = not shown or nil
end

--[[
	A journal frame whose tooltip says where the item drops itself: `instance`, the dungeon its
	row is in (the line then names only the others), or none (the Gear Finder, the search: they
	name the very place a click opens, and no line is added). Kept by the frame, for that item only.
]]
local givenSource = setmetatable({}, { __mode = "k" })

function ItemTooltip:UseSource(owner, itemID, instance)
	givenSource[owner] = itemID and { itemID = itemID, instance = instance or false } or nil
end

-- Whether a boss's drop counts: a boss's always, a dungeon's trash only where its Trash page lists it.
local function Counts(boss, itemID)
	if not boss.trash then return true end
	for _, row in ipairs(boss.loot or {}) do
		if row.itemID == itemID then return not ns.Items:Unremarkable(boss, row) end
	end
	return false
end

-- "Blackfathom Deeps, The Stockade, Razorfen Kraul, and 2 more"
local function PlaceList(places)
	local names = {}
	for index, place in ipairs(places) do
		if index > MAX_PLACES then
			names[#names + 1] = string.format(L.AND_MORE, #places - MAX_PLACES)
			break
		end
		names[#names + 1] = place.instance.name
	end
	return table.concat(names, ", ")
end

--[[
	The line for an item, or nil: the places it drops in, in the journal's order, without
	`except` (the dungeon the frame shows it in). One place names its boss, its number of bosses,
	or its trash (named only where no boss there drops it); several places are named in a list.
]]
function ItemTooltip:SourceText(itemID, except)
	local places, byInstance = {}, {}
	for _, boss, instance in ns.ItemDrops(itemID) do
		if instance ~= except and Counts(boss, itemID) then
			local place = byInstance[instance]
			if not place then
				place = { instance = instance, bosses = {} }
				byInstance[instance] = place
				places[#places + 1] = place
			end
			if boss.trash then
				place.trash = true
			else
				place.bosses[#place.bosses + 1] = boss
			end
		end
	end
	if #places == 0 then return nil end
	if except then return string.format(L.DROPS_ALSO_IN, PlaceList(places)) end
	if #places > 1 then return string.format(L.DROPS_IN, PlaceList(places)) end
	local place = places[1]
	if #place.bosses == 1 then return string.format(L.DROPS_FROM_BOSS, place.bosses[1].name, place.instance.name) end
	if #place.bosses > 1 then return string.format(L.DROPS_FROM_BOSSES, #place.bosses, place.instance.name) end
	return string.format(L.DROPS_FROM_TRASH, place.instance.name)
end

-- Each item's line once worked out, until the data changes (ns.DataVersion): false for none.
local sourceLines, linesVersion = {}, nil
local function SourceLine(itemID)
	local version = ns.DataVersion()
	if version ~= linesVersion then sourceLines, linesVersion = {}, version end
	local text = sourceLines[itemID]
	if text == nil then
		text = ItemTooltip:SourceText(itemID) or false
		sourceLines[itemID] = text
	end
	return text or nil
end

-- Whether the journal shows the item at all: one hidden until the server confirms it is shown
-- once the client describes it, which a tooltip is often the first to ask for.
local function Shown(itemID)
	if not ns.Items:IsHidden(itemID) then return true end
	ns.Items:Get(itemID)
	return not ns.Items:IsHidden(itemID)
end

-- The item's id: the client gives it in the tooltip's data, else its link says.
local function ShownItemID(tooltip, data)
	local id = data and data.id
	if type(id) == "number" and not ns.IsSecret(id) then return id end
	return ns.ItemIDFromLink(ShownLink(tooltip, data))
end

local function AddSource(tooltip, data)
	local itemID = ShownItemID(tooltip, data)
	if not itemID or not ns.HasDrops(itemID) then return end
	-- An item added beneath another (a set's piece under its token) is not the item shown.
	local ok, primary = pcall(function() return tooltip.GetPrimaryTooltipData and tooltip:GetPrimaryTooltipData() end)
	local primaryID = ok and type(primary) == "table" and ns.Readable(primary.id) or nil
	if type(primaryID) == "number" and primaryID ~= itemID then return end
	if not Shown(itemID) then return end
	local owner = tooltip.GetOwner and tooltip:GetOwner()
	local given = owner and givenSource[owner]
	if given and given.itemID ~= itemID then given = nil end
	local text
	if given then
		if not given.instance then return end
		text = ItemTooltip:SourceText(itemID, given.instance)
	else
		text = SourceLine(itemID)
	end
	if text then tooltip:AddLine(text, SOURCE_COLOR[1], SOURCE_COLOR[2], SOURCE_COLOR[3], true) end
end

local function AddGains(tooltip, data)
	local link = ShownLink(tooltip, data)
	local rows = link and ItemTooltip:Lines(link, tooltip, data)
	if not rows then return end
	-- "↑ Retribution     +4.2%"
	local r, g, b = GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3]
	for _, row in ipairs(rows) do
		tooltip:AddDoubleLine(Arrow() .. row.label, row.gain, r, g, b, r, g, b)
	end
end

-- The upgrade lines first, then where it drops, then whatever the frame the tooltip belongs to adds.
local function OnItem(tooltip, data)
	if tooltip.IsForbidden and tooltip:IsForbidden() then return end
	-- The item shown for itself: the tooltips beside it show what is worn, no upgrade on itself.
	if not IsOneOf(tooltip, SHOWS_ITEM) then return end
	if ns.charDB and ns.GearPanel.ShowsGains() and not ns.PawnLink:Present() then AddGains(tooltip, data) end
	if ns.db and ItemTooltip.ShowsSources() then AddSource(tooltip, data) end
end

-- The client's item tooltips all come through its tooltip data, Forever's as retail's.
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItem)
end
