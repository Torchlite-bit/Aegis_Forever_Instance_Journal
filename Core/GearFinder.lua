local _, ns = ...
local L = ns.L

--[[
	The Gear Finder, after Aegis: Pathfinder's: for each slot, the best upgrade waiting in the
	journal's dungeons for the player's class, spec and level, and the dungeon that holds the most.

	It looks in every dungeon that starts no more than AHEAD levels above the player, at the drops
	their class can wear now or within AHEAD levels ("at level 24"). Each is scored against what
	is worn (Core/ItemScore.lua) and kept if it is an upgrade, under the slot it would replace;
	its gain is measured against everything worn. An item the client has not described yet is
	asked for (Core/Items.lua) and weighed when it comes.

	Pathfinder's other sources (quest rewards, reputation vendors, crafted gear, raids) are left
	out of this first version: dungeon drops only.

	As in Pathfinder, a slot shows its biggest upgrade, or one the player picked from its top
	TOP_PICKS. Picks are kept for each character, and the suggested dungeon follows them. A pick
	that stops being an upgrade (another spec, better gear) gives the slot back its biggest, and
	comes back if it is one again; one the player has put on is forgotten.
]]

local GearFinder = {}
ns.GearFinder = GearFinder

local AHEAD = 3              -- dungeons and items up to this many levels above the player
local REFRESH_DELAY = 0.5    -- seconds to gather item answers before weighing again
GearFinder.TOP_PICKS = 3     -- a slot's upgrades the player can pick from

-- The slots, in the character sheet's order, and the group each inventory slot is in.
local GROUP_OF = {
	[1] = "HEAD", [2] = "NECK", [3] = "SHOULDER", [15] = "BACK", [5] = "CHEST", [9] = "WRIST", [10] = "HANDS",
	[6] = "WAIST", [7] = "LEGS", [8] = "FEET", [11] = "FINGER", [12] = "FINGER", [13] = "TRINKET", [14] = "TRINKET",
	[16] = "MAINHAND", [17] = "OFFHAND", [18] = "RANGED",
}

--[[ The cells, one per equipment slot in the character sheet's order: `slot` is its inventory
	slot, `inv` that slot's name (for its empty picture), `second` the second of two rings or
	trinkets. Shirt and tabard are left out: they have no stats. Where each goes on the tab is
	the panel's business (UI/GearPanel.lua). ]]
GearFinder.CELLS = {
	{ key = "head", group = "HEAD", slot = 1, inv = "HeadSlot" },
	{ key = "neck", group = "NECK", slot = 2, inv = "NeckSlot" },
	{ key = "shoulder", group = "SHOULDER", slot = 3, inv = "ShoulderSlot" },
	{ key = "back", group = "BACK", slot = 15, inv = "BackSlot" },
	{ key = "chest", group = "CHEST", slot = 5, inv = "ChestSlot" },
	{ key = "wrist", group = "WRIST", slot = 9, inv = "WristSlot" },
	{ key = "mainhand", group = "MAINHAND", slot = 16, inv = "MainHandSlot" },
	{ key = "offhand", group = "OFFHAND", slot = 17, inv = "SecondaryHandSlot" },
	{ key = "hands", group = "HANDS", slot = 10, inv = "HandsSlot" },
	{ key = "waist", group = "WAIST", slot = 6, inv = "WaistSlot" },
	{ key = "legs", group = "LEGS", slot = 7, inv = "LegsSlot" },
	{ key = "feet", group = "FEET", slot = 8, inv = "FeetSlot" },
	{ key = "finger1", group = "FINGER", slot = 11, inv = "Finger0Slot", second = false },
	{ key = "finger2", group = "FINGER", slot = 12, inv = "Finger1Slot", second = true },
	{ key = "trinket1", group = "TRINKET", slot = 13, inv = "Trinket0Slot", second = false },
	{ key = "trinket2", group = "TRINKET", slot = 14, inv = "Trinket1Slot", second = true },
	{ key = "ranged", group = "RANGED", slot = 18, inv = "RangedSlot" },
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
	local total = IS:WornTotal(weights)
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
						local compare = info.link and IS:Compare(info.link, weights, total)
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
	self:ForgetWornPicks()
	self:Recheck()
	return results, missing
end

------------------------------------------------------------------------------------------
-- Picks
------------------------------------------------------------------------------------------

-- The player's picks: the item each cell shows instead of its biggest upgrade, by the cell's key.
function GearFinder:Picks()
	ns.charDB.gearFinder = ns.charDB.gearFinder or {}
	local settings = ns.charDB.gearFinder
	settings.picks = settings.picks or {}
	return settings.picks
end

-- A pick the player has put on is theirs: the slot goes back to its biggest upgrade.
function GearFinder:ForgetWornPicks()
	local picks = self:Picks()
	if next(picks) == nil then return end
	local worn = {}
	for slot = 1, 19 do
		local link = GetInventoryItemLink("player", slot)
		local itemID = link and tonumber(link:match("item:(%d+)"))
		if itemID then worn[itemID] = true end
	end
	for key, itemID in pairs(picks) do
		if worn[itemID] then picks[key] = nil end
	end
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
	local since = GetTime()
	C_Timer.After(ns.Items.GIVE_UP_SECONDS + 1, function()
		recheckQueued = false
		-- Only once that time has really gone by: a timer that ran early would search, find the
		-- same items waiting, and ask again, round and round.
		if GetTime() - since < ns.Items.GIVE_UP_SECONDS then return end
		if missing > 0 and GearFinder.IsShowing() then GearFinder:Queue() end
	end)
end

function GearFinder:Results()
	return results, missing, looked
end

-- What an upgrade is worth when dungeons are ranked: its share of everything worn, or its plain
-- gain while nothing worn is worth anything.
function GearFinder.Worth(entry)
	return entry.compare.share or entry.compare.delta
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
			again.share = compare.total > 0 and again.delta / compare.total * 100 or nil
			out[#out + 1] = { itemID = entry.itemID, link = entry.link, info = entry.info, instance = entry.instance,
				boss = entry.boss, compare = again }
		end
	end
	table.sort(out, ByGain)
	return out
end

-- The upgrade `itemID` among `list`'s, or nil.
local function Listed(list, itemID)
	if not itemID then return nil end
	for _, entry in ipairs(list) do
		if entry.itemID == itemID then return entry end
	end
	return nil
end

-- The first of `list` that is not `itemID`.
local function FirstBut(list, itemID)
	for _, entry in ipairs(list) do
		if entry.itemID ~= itemID then return entry end
	end
	return nil
end

--[[
	The cells: { def (from CELLS), entries (its slot's upgrades, best first), shown (the one it
	shows, or nil), picked (shown because the player picked it) }. Two cells of one slot (rings,
	trinkets) never show the same item, and neither lists the other's.

	Of those two, the cell of the weaker worn one (the slot every upgrade of the pair replaces,
	Core/ItemScore.lua) shows the pair's first choice. The other cell's must also beat the other
	worn one, and is measured against it. A pick in either cell is kept from the other.
]]
function GearFinder:Cells()
	local picks = self:Picks()
	local out, firstOf = {}, {}
	for _, def in ipairs(self.CELLS) do
		local list = results[def.group] or {}
		local cell = { def = def, entries = list }
		if def.second then
			local main, other = firstOf[def.group], cell
			if not main or (list[1] and list[1].compare.slot == def.slot) then main, other = cell, main end
			local mainPick, otherPick = picks[main.def.key], other and picks[other.def.key]
			-- The other cell's pick is left to it only while it can show it, beating the other worn
			-- one; else it would be in neither cell.
			local held = Listed(list, otherPick)
			local leftToOther = held and held.compare.otherSlot and held.compare.score - held.compare.otherWorn > 0.0001
				and held.itemID or nil
			main.shown = Listed(list, mainPick) or FirstBut(list, leftToOther)
			main.picked = main.shown ~= nil and main.shown.itemID == mainPick
			if other then
				other.entries = SecondOf(list, main.shown)
				other.shown = Listed(other.entries, otherPick) or other.entries[1]
				other.picked = other.shown ~= nil and other.shown.itemID == otherPick
				main.entries = Without(list, other.shown and other.shown.itemID)
			end
		else
			cell.shown = Listed(list, picks[def.key]) or list[1]
			cell.picked = cell.shown ~= nil and cell.shown.itemID == picks[def.key]
			firstOf[def.group] = cell
		end
		out[#out + 1] = cell
	end
	return out
end

-- What a cell offers to pick from: its top TOP_PICKS, and the one it shows if that is further down.
function GearFinder:Choices(cell)
	local out = {}
	for index = 1, math.min(#cell.entries, self.TOP_PICKS) do out[#out + 1] = cell.entries[index] end
	if cell.shown and not Listed(out, cell.shown.itemID) then out[#out + 1] = cell.shown end
	return out
end

--[[
	Shows upgrade `itemID` in cell `key`; nil, or the item the cell would show unpicked, gives it
	back its biggest.
]]
function GearFinder:SetPick(key, itemID)
	local picks = self:Picks()
	picks[key] = nil
	if itemID == nil then return end
	for _, cell in ipairs(self:Cells()) do
		if cell.def.key == key and cell.shown and cell.shown.itemID == itemID then return end
	end
	picks[key] = itemID
end

--[[
	The dungeons the cells' upgrades drop in, best first: by how many cells, then by what those
	upgrades add up to. Each: { instance, count, total, slots (the cells' keys), entries (the
	upgrades, in the same order) }.
]]
function GearFinder:Suggest(cells)
	local tally, order = {}, {}
	for _, cell in ipairs(cells or self:Cells()) do
		local entry = cell.shown
		if entry then
			local key = entry.instance.key
			local dungeon = tally[key]
			if not dungeon then
				dungeon = { instance = entry.instance, count = 0, total = 0, slots = {}, entries = {} }
				tally[key] = dungeon
				order[#order + 1] = dungeon
			end
			dungeon.count = dungeon.count + 1
			dungeon.total = dungeon.total + self.Worth(entry)
			dungeon.slots[#dungeon.slots + 1] = cell.def.key
			dungeon.entries[#dungeon.entries + 1] = entry
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

-- Whether anyone is looking: the journal's Gear Finder tab.
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
local SCAN_ATLASES = {
	"UI-Character-Info-General-BG", "UI-Character-Info-Stat-BG", "UI-Character-Info-Stat-StoneBG",
	"UI-Character-Info-CLASS-BG", "UI-Character-Info-GearSlot", "UI-Character-Info-Title",
	"UI-Character-Info-Line-Bounce2", "UI-Character-Info-ItemLevel-Bounce", "common-framedivider", "bags-greenarrow",
	"common-sidetab", "charactercreate-customize-dropdown-linemouseover-middle",
}

-- Only plain values go in the saved file: the client keeps some of its answers secret, and a
-- secret cannot be written there.
local function Plain(value)
	if issecretvalue and issecretvalue(value) then return "<secret>" end
	local kind = type(value)
	if kind == "string" or kind == "number" or kind == "boolean" then return value end
	if value == nil then return nil end
	return tostring(value)
end

local function PlainTable(source)
	local out = {}
	for key, value in pairs(source or {}) do
		local plainKey = Plain(key)
		if plainKey ~= nil then out[plainKey] = Plain(value) end
	end
	return out
end

local function Raw(link)
	local getStats = C_Item and C_Item.GetItemStats or GetItemStats
	if not getStats then return "no C_Item.GetItemStats" end
	local ok, raw = pcall(getStats, link)
	if not ok then return "error: " .. tostring(raw) end
	if type(raw) ~= "table" then return Plain(raw) end
	return PlainTable(raw)
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
		r, g, b = Plain(r), Plain(g), Plain(b)
		out[index] = { left = Plain(line.leftText), right = Plain(line.rightText), type = Plain(line.type),
			color = type(r) == "number" and type(g) == "number" and type(b) == "number"
				and string.format("%.2f,%.2f,%.2f", r, g, b) or nil }
	end
	return out
end

local function Sample(link, label)
	local item = ns.ItemScore:Read(link)
	return { label = label, link = Plain(link), raw = Raw(link), lines = Lines(link),
		read = item and { stats = PlainTable(item.stats), equipLoc = Plain(item.equipLoc), minLevel = Plain(item.minLevel),
			usable = Plain(item.usable) } }
end

--[[
	What the Gear Finder sees on this client, saved for checking its scoring against Forever's own
	words: the client's stat names and tooltip lines for the worn gear and some dungeon drops near
	the player's level. Kept in the saved file (AegisJournalDB.gearScan) until the next scan. It is
	saved before the items are read, and an item that fails is noted in `errors`, so a problem with
	one still leaves the rest.
]]
function GearFinder:Scan()
	local IS = ns.ItemScore
	local spec, why = IS:Spec()
	local scan = {
		build = select(4, GetBuildInfo()) or 0, version = (GetBuildInfo()), class = IS:Class(), level = IS:Level(),
		spec = spec, specWhy = why, talentSpec = IS:TalentSpec(IS:Class()) or false, dualWield = IS:CanDualWield(),
		worn = {}, drops = {}, unknownKeys = {}, errors = {},
	}
	ns.db.gearScan = scan
	local function Add(list, link, label)
		local ok, sample = pcall(Sample, link, label)
		if ok then
			list[#list + 1] = sample
		else
			scan.errors[#scan.errors + 1] = label .. ": " .. tostring(sample)
		end
	end
	for slot = 1, 19 do
		local link = GetInventoryItemLink("player", slot)
		if link then Add(scan.worn, link, "slot " .. slot) end
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
							Add(scan.drops, info.link, instance.name .. " / " .. boss.name)
						end
					end
				end
			end
		end
	end
	for key in pairs(IS.unknownKeys) do scan.unknownKeys[#scan.unknownKeys + 1] = Plain(key) end
	-- The character panel's side tabs, ours among them, and what each hangs from.
	local ok, tabs = pcall(function() return ns.CharacterTab and ns.CharacterTab:Describe() end)
	scan.tabs = {}
	if not ok then scan.errors[#scan.errors + 1] = "tabs: " .. tostring(tabs) end
	for index, entry in ipairs(ok and tabs or {}) do scan.tabs[index] = PlainTable(entry) end
	-- The character panel's art the Gear Finder tab borrows, at the sizes this client has it.
	scan.atlases = {}
	local getAtlas = C_Texture and C_Texture.GetAtlasInfo
	for _, atlas in ipairs(getAtlas and SCAN_ATLASES or {}) do
		local ok, info = pcall(getAtlas, (atlas:gsub("CLASS", IS:Class() or "")))
		scan.atlases[atlas] = ok and info and { width = Plain(info.width), height = Plain(info.height) } or false
	end
	ns.Print(string.format(L.GEAR_SCAN_DONE, #scan.worn, #scan.drops))
	if #scan.errors > 0 then ns.Print(string.format(L.GEAR_SCAN_ERRORS, #scan.errors)) end
	if waiting > 0 and #scan.drops < SCAN_ITEMS then ns.Print(L.GEAR_SCAN_LOADING) end
end
