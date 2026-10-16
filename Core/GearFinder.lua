local _, ns = ...
local L = ns.L

--[[
	The Gear Finder, after Aegis: Pathfinder's: for each slot, the best upgrade waiting in the
	journal's dungeons for the player's class, spec and level, and the dungeon that holds the most.

	It looks in every dungeon that starts no more than AHEAD levels above the player, at the drops
	their class can wear now or within AHEAD levels ("at level 24"). Each is scored against what
	is worn (Core/ItemScore.lua) and kept if it is an upgrade, under the slot it would replace. An
	item the client has not described yet is asked for (Core/Items.lua) and weighed when it comes.

	Pathfinder's other sources (quest rewards, reputation vendors, crafted gear, raids) are left
	out of this first version: dungeon drops only.
]]

local GearFinder = {}
ns.GearFinder = GearFinder

local AHEAD = 3              -- dungeons and items up to this many levels above the player
local EMPTY_WORTH = 100      -- what filling an empty slot counts for, in %, when dungeons are ranked
local REFRESH_DELAY = 0.5    -- seconds to gather item answers before weighing again

-- The slots, in the character sheet's order, and the group each inventory slot is in.
local GROUP_OF = {
	[1] = "HEAD", [2] = "NECK", [3] = "SHOULDER", [15] = "BACK", [5] = "CHEST", [9] = "WRIST", [10] = "HANDS",
	[6] = "WAIST", [7] = "LEGS", [8] = "FEET", [11] = "FINGER", [12] = "FINGER", [13] = "TRINKET", [14] = "TRINKET",
	[16] = "MAINHAND", [17] = "OFFHAND", [18] = "RANGED",
}

--[[ The panel's cells, laid out like the character sheet: two columns of eight, and the ranged
	slot under the suggested dungeon. `inv` names the inventory slot whose empty picture a cell
	shows when it has no upgrade. Shirt and tabard are left out: they have no stats. ]]
GearFinder.CELLS = {
	{ key = "head", group = "HEAD", col = 1, row = 1, inv = "HeadSlot" },
	{ key = "neck", group = "NECK", col = 1, row = 2, inv = "NeckSlot" },
	{ key = "shoulder", group = "SHOULDER", col = 1, row = 3, inv = "ShoulderSlot" },
	{ key = "back", group = "BACK", col = 1, row = 4, inv = "BackSlot" },
	{ key = "chest", group = "CHEST", col = 1, row = 5, inv = "ChestSlot" },
	{ key = "wrist", group = "WRIST", col = 1, row = 6, inv = "WristSlot" },
	{ key = "mainhand", group = "MAINHAND", col = 1, row = 7, inv = "MainHandSlot" },
	{ key = "offhand", group = "OFFHAND", col = 1, row = 8, inv = "SecondaryHandSlot" },
	{ key = "hands", group = "HANDS", col = 2, row = 1, inv = "HandsSlot" },
	{ key = "waist", group = "WAIST", col = 2, row = 2, inv = "WaistSlot" },
	{ key = "legs", group = "LEGS", col = 2, row = 3, inv = "LegsSlot" },
	{ key = "feet", group = "FEET", col = 2, row = 4, inv = "FeetSlot" },
	{ key = "finger1", group = "FINGER", col = 2, row = 5, inv = "Finger0Slot", second = false },
	{ key = "finger2", group = "FINGER", col = 2, row = 6, inv = "Finger1Slot", second = true },
	{ key = "trinket1", group = "TRINKET", col = 2, row = 7, inv = "Trinket0Slot", second = false },
	{ key = "trinket2", group = "TRINKET", col = 2, row = 8, inv = "Trinket1Slot", second = true },
	{ key = "ranged", group = "RANGED", col = 3, row = 8, inv = "RangedSlot" },
}

local results, missing, looked = {}, 0, 0

--[[
	Items the client has never described are asked for a few at a time, as Pathfinder asks: some
	servers drop a client that asks for too many at once. A search only fills the queue; the
	asking starts on the next frame. One the client has already is read at once.
]]
local LOAD_BATCH, LOAD_EVERY = 5, 0.1
local loadQueue, asked, loading = {}, {}, false

local function LoadStep()
	for _ = 1, LOAD_BATCH do
		local nextItem = table.remove(loadQueue, 1)
		if not nextItem then
			loading = false
			if GearFinder.IsShowing() then GearFinder:Queue() end
			return
		end
		ns.Items:Get(nextItem.itemID, nextItem.row)
	end
	C_Timer.After(LOAD_EVERY, LoadStep)
end

local function Cached(itemID)
	local isCached = C_Item and C_Item.IsItemDataCachedByID
	if not isCached then return false end
	local ok, cached = pcall(isCached, itemID)
	return ok and cached == true
end

-- The item's info if the journal has it or the client can say at once; else nil, and it is asked for.
local function Info(itemID, row)
	if ns.Items:Peek(itemID) or Cached(itemID) then return ns.Items:Get(itemID, row) end
	if not asked[itemID] then
		asked[itemID] = true
		loadQueue[#loadQueue + 1] = { itemID = itemID, row = row }
		if not loading then
			loading = true
			C_Timer.After(0, LoadStep)
		end
	end
	return nil
end

-- The dungeons looked in: those starting no more than AHEAD levels above the player.
function GearFinder:Dungeons()
	local level = UnitLevel("player") or 1
	local out = {}
	for _, instance in ipairs(ns.GetInstances("dungeon")) do
		if (instance.levelMin or 0) <= level + AHEAD and not instance.comingSoon then out[#out + 1] = instance end
	end
	return out
end

-- Upgrades in order: the biggest gain first.
local function ByGain(a, b)
	if a.compare.delta ~= b.compare.delta then return a.compare.delta > b.compare.delta end
	return a.itemID < b.itemID
end

--[[
	Weighs every drop of those dungeons. Each upgrade: { itemID, link, info, instance, boss,
	compare }. Grouped by slot, best first. An item that drops in more than one place is kept
	where it is met first: the lowest dungeon.
]]
function GearFinder:Find()
	local IS = ns.ItemScore
	local level = UnitLevel("player") or 1
	local classFile = IS:Class()
	local weights = IS:Weights()
	local bySlot, seen = {}, {}
	missing = 0
	local dungeons = self:Dungeons()
	looked = #dungeons
	for _, instance in ipairs(dungeons) do
		for _, boss in ipairs(instance.bosses or {}) do
			for _, row in ipairs(boss.loot or {}) do
				local itemID = row.itemID
				if type(itemID) == "number" and not seen[itemID] and not ns.Items:IsHidden(itemID) then
					seen[itemID] = true
					local info = Info(itemID, row)
					if not info then
						missing = missing + 1
					elseif info.kind == "EQUIPMENT" and ns.Items:ClassCanUse(classFile, info) and not info.unavailable then
						local compare = info.link and IS:Compare(info.link, weights)
						if not compare then
							-- Not described yet (or by a client that cannot): weighed when it is.
							if info.pending or not info.link then missing = missing + 1 end
						elseif compare.minLevel <= level + AHEAD and compare.usable and not compare.noCompare
							and compare.delta > 0.0001 then
							local group = GROUP_OF[compare.slot]
							if group then
								bySlot[group] = bySlot[group] or {}
								table.insert(bySlot[group], { itemID = itemID, link = info.link, info = info,
									instance = instance, boss = boss, compare = compare })
							end
						end
					end
				end
			end
		end
	end
	-- Worn gear the client has not described yet counts nothing for now, and is waited for too.
	if not IS:WornKnown() then missing = missing + 1 end
	for _, list in pairs(bySlot) do table.sort(list, ByGain) end
	results = bySlot
	self:Recheck()
	return results, missing
end

--[[
	Items the server never answers stop counting as loading once Core/Items.lua gives up on them,
	which it decides when they are next looked at: so a search still waiting for some looks
	again after that time, once, while anyone is looking.
]]
local recheckQueued = false
function GearFinder:Recheck()
	if missing == 0 or recheckQueued then return end
	recheckQueued = true
	C_Timer.After(ns.Items.GIVE_UP_SECONDS + 1, function()
		recheckQueued = false
		if missing > 0 and GearFinder.IsShowing() then GearFinder:Queue() end
	end)
end

function GearFinder:Results()
	return results, missing, looked
end

-- What an upgrade is worth when dungeons are ranked: its %, or EMPTY_WORTH for a slot with
-- nothing in it, or nothing worth anything to the spec.
function GearFinder.Worth(entry)
	return entry.compare.pct or EMPTY_WORTH
end

-- The list without one item.
local function Without(list, itemID)
	if not itemID then return list end
	local out = {}
	for _, entry in ipairs(list) do
		if entry.itemID ~= itemID then out[#out + 1] = entry end
	end
	return out
end

--[[
	The second cell of a pair (rings, trinkets). The first cell's pick takes the weaker of the
	two slots, so what is left must beat the other worn one, and is measured against that.
]]
local function SecondOf(list, first)
	local out = {}
	for _, entry in ipairs(list) do
		local compare = entry.compare
		if entry ~= first and compare.otherSlot and compare.score - compare.otherWorn > 0.0001 then
			local again = {}
			for key, value in pairs(compare) do again[key] = value end
			again.slot, again.worn, again.emptySlot = compare.otherSlot, compare.otherWorn, compare.otherEmpty
			again.delta = compare.score - compare.otherWorn
			again.pct = compare.otherWorn > 0 and again.delta / compare.otherWorn * 100 or nil
			out[#out + 1] = { itemID = entry.itemID, link = entry.link, info = entry.info, instance = entry.instance,
				boss = entry.boss, compare = again }
		end
	end
	table.sort(out, ByGain)
	return out
end

--[[
	The cells: { def (from CELLS), entries (its slot's upgrades, best first), shown (the one it
	shows, or nil) }. Two cells of one slot (rings, trinkets) never show the same item, and
	neither lists the other's.
]]
function GearFinder:Cells()
	local out, firstOf = {}, {}
	for _, def in ipairs(self.CELLS) do
		local list = results[def.group] or {}
		local cell = { def = def, entries = list }
		if def.second then
			local first = firstOf[def.group]
			cell.entries = SecondOf(list, first and first.shown)
			cell.shown = cell.entries[1]
			if first and cell.shown then first.entries = Without(list, cell.shown.itemID) end
		else
			cell.shown = list[1]
			firstOf[def.group] = cell
		end
		out[#out + 1] = cell
	end
	return out
end

--[[
	The dungeons the cells' upgrades drop in, best first: by how many cells, then by what those
	upgrades add up to. Each: { instance, count, total, slots (the cells' keys) }.
]]
function GearFinder:Suggest(cells)
	local tally, order = {}, {}
	for _, cell in ipairs(cells or self:Cells()) do
		local entry = cell.shown
		if entry then
			local key = entry.instance.key
			local item = tally[key]
			if not item then
				item = { instance = entry.instance, count = 0, total = 0, slots = {} }
				tally[key] = item
				order[#order + 1] = item
			end
			item.count = item.count + 1
			item.total = item.total + self.Worth(entry)
			item.slots[#item.slots + 1] = cell.def.key
		end
	end
	table.sort(order, function(a, b)
		if a.count ~= b.count then return a.count > b.count end
		if a.total ~= b.total then return a.total > b.total end
		return a.instance.name < b.instance.name
	end)
	return order
end

------------------------------------------------------------------------------------------
-- Refreshing
------------------------------------------------------------------------------------------

local listeners, queued, finding, again = {}, false, false, false

-- `callback` runs after each new search.
function GearFinder:OnUpdate(callback)
	listeners[#listeners + 1] = callback
end

-- Searches again now, and tells the panel. Asked again while it is searching (items that came
-- in meanwhile), it searches once more when done rather than inside itself.
function GearFinder:Refresh()
	queued = false
	if finding then
		again = true
		return
	end
	finding = true
	local ok, problem = pcall(self.Find, self)
	finding = false
	for _, callback in ipairs(listeners) do callback() end
	if again then
		again = false
		self:Queue()
	end
	if not ok then error(problem, 0) end
end

-- Searches again shortly, once however often it is asked: item answers come in bursts.
function GearFinder:Queue()
	if queued then return end
	queued = true
	C_Timer.After(REFRESH_DELAY, function()
		if queued then self:Refresh() end
	end)
end

-- Whether anyone is looking: the journal's Gear tab.
GearFinder.IsShowing = function() return false end

ns.ItemScore:OnChange(function()
	if GearFinder.IsShowing() then GearFinder:Queue() end
end)

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "GET_ITEM_INFO_RECEIVED")
events:SetScript("OnEvent", function()
	if missing > 0 and GearFinder.IsShowing() then GearFinder:Queue() end
end)

------------------------------------------------------------------------------------------
-- /aegis gearscan
------------------------------------------------------------------------------------------

local SCAN_ITEMS = 30

local function Raw(link)
	local getStats = C_Item and C_Item.GetItemStats or GetItemStats
	if not getStats then return "no C_Item.GetItemStats" end
	local ok, raw = pcall(getStats, link)
	if not ok then return "error: " .. tostring(raw) end
	return raw
end

local function Lines(link)
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink) then return "no C_TooltipInfo.GetHyperlink" end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" then return "error: " .. tostring(data) end
	local out = {}
	for index, line in ipairs(data.lines or {}) do
		if line.leftText == nil and TooltipUtil and TooltipUtil.SurfaceArgs then pcall(TooltipUtil.SurfaceArgs, line) end
		local color = line.leftColor
		local r, g, b
		if color and color.GetRGB then r, g, b = color:GetRGB() elseif color then r, g, b = color.r, color.g, color.b end
		out[index] = { left = line.leftText, right = line.rightText, type = line.type,
			color = r and string.format("%.2f,%.2f,%.2f", r, g, b) or nil }
	end
	return out
end

local function Sample(link, label)
	local item = ns.ItemScore:Read(link)
	return { label = label, link = link, raw = Raw(link), lines = Lines(link),
		read = item and { stats = item.stats, equipLoc = item.equipLoc, minLevel = item.minLevel, usable = item.usable } }
end

--[[
	What the Gear Finder sees on this client, saved for checking its scoring against Forever's own
	words: the client's stat names and tooltip lines for the worn gear and some dungeon drops near
	the player's level. Kept in the saved file (AegisJournalDB.gearScan) until the next scan.
]]
function GearFinder:Scan()
	local IS = ns.ItemScore
	local spec, why = IS:Spec()
	local scan = {
		build = select(4, GetBuildInfo()) or 0, version = (GetBuildInfo()), class = IS:Class(), level = IS:Level(),
		spec = spec, specWhy = why, talentSpec = IS:TalentSpec(IS:Class()) or false, dualWield = IS:CanDualWield(),
		worn = {}, drops = {}, unknownKeys = {},
	}
	for slot = 1, 19 do
		local link = GetInventoryItemLink("player", slot)
		if link then scan.worn[#scan.worn + 1] = Sample(link, "slot " .. slot) end
	end
	-- Drops the client has described already; the rest are asked for a few at a time, as a
	-- search asks, for the next scan.
	local level, waiting = IS:Level(), 0
	for _, instance in ipairs(self:Dungeons()) do
		if (instance.levelMax or 0) >= level - 5 then
			for _, boss in ipairs(instance.bosses or {}) do
				for _, row in ipairs(boss.loot or {}) do
					if type(row.itemID) == "number" and #scan.drops < SCAN_ITEMS then
						local info = Info(row.itemID, row)
						if not info or info.pending then
							waiting = waiting + 1
						elseif info.kind == "EQUIPMENT" and info.link then
							scan.drops[#scan.drops + 1] = Sample(info.link, instance.name .. " / " .. boss.name)
						end
					end
				end
			end
		end
	end
	for key in pairs(IS.unknownKeys) do scan.unknownKeys[#scan.unknownKeys + 1] = key end
	ns.db.gearScan = scan
	ns.Print(string.format(L.GEAR_SCAN_DONE, #scan.worn, #scan.drops))
	if waiting > 0 and #scan.drops < SCAN_ITEMS then ns.Print(L.GEAR_SCAN_LOADING) end
end
