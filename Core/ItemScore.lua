local _, ns = ...

--[[
	What an item is worth to the player, and how it compares with what they wear: the Gear
	Finder's scoring, after Aegis: Pathfinder's (its ItemScore.lua), with its stat weights
	(Data/Generated/GearWeights.lua).

	Pathfinder read every stat off a tooltip, 1.12 having no other way. Forever's client says an
	item's stats itself (C_Item.GetItemStats); what that leaves out, the classic "Equip:" lines
	(chance to hit, spell damage, mana per 5), is read from the item's tooltip lines with the
	journal's own patterns. A stat the client gave is never counted a second time from a line.

	A score is the sum of each stat times its weight, in the spec's unit. Comparing: the slot an
	item would go in, against the weaker of two rings or trinkets, a two-hander against main hand
	and off hand together; the gain is the difference, and as a share of what is worn.
]]

local ItemScore = {}
ns.ItemScore = ItemScore

local MAX_LEVEL = 60
local DUAL_WIELD_SPELL = 674

-- Inventory slots (INVSLOT_*).
local HEAD, NECK, SHOULDER, CHEST, WAIST, LEGS, FEET, WRIST, HANDS = 1, 2, 3, 5, 6, 7, 8, 9, 10
local FINGER1, FINGER2, TRINKET1, TRINKET2, BACK, MAINHAND, OFFHAND, RANGED = 11, 12, 13, 14, 15, 16, 17, 18
ItemScore.MAINHAND, ItemScore.OFFHAND, ItemScore.RANGED = MAINHAND, OFFHAND, RANGED

-- The slots an item may go in, by its equip location.
local SLOTS = {
	INVTYPE_HEAD = { HEAD }, INVTYPE_NECK = { NECK }, INVTYPE_SHOULDER = { SHOULDER }, INVTYPE_CLOAK = { BACK },
	INVTYPE_CHEST = { CHEST }, INVTYPE_ROBE = { CHEST }, INVTYPE_WAIST = { WAIST }, INVTYPE_LEGS = { LEGS },
	INVTYPE_FEET = { FEET }, INVTYPE_WRIST = { WRIST }, INVTYPE_HAND = { HANDS },
	INVTYPE_FINGER = { FINGER1, FINGER2 }, INVTYPE_TRINKET = { TRINKET1, TRINKET2 },
	INVTYPE_WEAPON = { MAINHAND }, INVTYPE_2HWEAPON = { MAINHAND }, INVTYPE_WEAPONMAINHAND = { MAINHAND },
	INVTYPE_WEAPONOFFHAND = { OFFHAND }, INVTYPE_SHIELD = { OFFHAND }, INVTYPE_HOLDABLE = { OFFHAND },
	INVTYPE_RANGED = { RANGED }, INVTYPE_RANGEDRIGHT = { RANGED }, INVTYPE_THROWN = { RANGED }, INVTYPE_RELIC = { RANGED },
}
ItemScore.SLOTS = SLOTS
local RANGED_WEAPON = { INVTYPE_RANGED = true, INVTYPE_RANGEDRIGHT = true, INVTYPE_THROWN = true }
local OFF_HAND_ONLY = { INVTYPE_WEAPONOFFHAND = true, INVTYPE_SHIELD = true, INVTYPE_HOLDABLE = true }

------------------------------------------------------------------------------------------
-- Reading an item
------------------------------------------------------------------------------------------

-- The client's stat names (C_Item.GetItemStats) and the weights' own. A stat with two names
-- counts as both: "damage and healing" is spell damage to a caster and healing to a healer.
local STAT_KEYS = {
	ITEM_MOD_STRENGTH_SHORT = "STRENGTH", ITEM_MOD_AGILITY_SHORT = "AGILITY", ITEM_MOD_STAMINA_SHORT = "STAMINA",
	ITEM_MOD_INTELLECT_SHORT = "INTELLECT", ITEM_MOD_SPIRIT_SHORT = "SPIRIT",
	RESISTANCE0_NAME = "ARMOR", ITEM_MOD_EXTRA_ARMOR_SHORT = "ARMOR",
	ITEM_MOD_DAMAGE_PER_SECOND_SHORT = "DPS",
	ITEM_MOD_ATTACK_POWER_SHORT = "ATTACK POWER", ITEM_MOD_RANGED_ATTACK_POWER_SHORT = "RANGED ATTACK POWER",
	ITEM_MOD_FERAL_ATTACK_POWER_SHORT = "FERAL ATTACK POWER",
	ITEM_MOD_SPELL_POWER_SHORT = { "SPELL POWER", "HEALING" },
	ITEM_MOD_SPELL_DAMAGE_DONE_SHORT = "SPELL DAMAGE", ITEM_MOD_SPELL_HEALING_DONE_SHORT = "HEALING",
	ITEM_MOD_CRIT_RATING_SHORT = "CRIT", ITEM_MOD_CRIT_MELEE_RATING_SHORT = "CRIT",
	ITEM_MOD_CRIT_RANGED_RATING_SHORT = "RANGED CRIT", ITEM_MOD_CRIT_SPELL_RATING_SHORT = "SPELL CRIT",
	ITEM_MOD_HIT_RATING_SHORT = "HIT", ITEM_MOD_HIT_MELEE_RATING_SHORT = "HIT", ITEM_MOD_HIT_RANGED_RATING_SHORT = "HIT",
	ITEM_MOD_HIT_SPELL_RATING_SHORT = "SPELL HIT",
	ITEM_MOD_HASTE_RATING_SHORT = "HASTE", ITEM_MOD_HASTE_MELEE_RATING_SHORT = "HASTE",
	ITEM_MOD_HASTE_RANGED_RATING_SHORT = "RANGED HASTE",
	ITEM_MOD_MANA_REGENERATION_SHORT = "MANA PER 5", ITEM_MOD_POWER_REGEN0_SHORT = "MANA PER 5",
	ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = "DEFENSE", ITEM_MOD_DODGE_RATING_SHORT = "DODGE",
	ITEM_MOD_PARRY_RATING_SHORT = "PARRY", ITEM_MOD_BLOCK_RATING_SHORT = "BLOCK",
	ITEM_MOD_BLOCK_VALUE_SHORT = "BLOCK VALUE", ITEM_MOD_SHIELD_BLOCK_VALUE_SHORT = "BLOCK VALUE",
	ITEM_MOD_MANA_SHORT = "MANA", ITEM_MOD_HEALTH_SHORT = "HEALTH",
	ITEM_MOD_SPELL_PENETRATION_SHORT = "SPELL PENETRATION",
	-- Known, and worth nothing to any spec: resistances, health per 5.
	RESISTANCE1_NAME = false, RESISTANCE2_NAME = false, RESISTANCE3_NAME = false, RESISTANCE4_NAME = false,
	RESISTANCE5_NAME = false, RESISTANCE6_NAME = false, ITEM_MOD_HEALTH_REGEN_SHORT = false,
	ITEM_MOD_HEALTH_REGENERATION_SHORT = false,
}

-- Names the client gave that the journal does not know yet, for /aegis gearscan.
ItemScore.unknownKeys = {}

--[[
	The "Equip:" lines, in the journal's own words for the classic wording: a pattern (on the
	line in lower case) and the stat it gives. The first match on a line wins; specific before
	general. School damage takes the school from the line.
]]
local SCHOOLS = { holy = "HOLY DAMAGE", fire = "FIRE DAMAGE", frost = "FROST DAMAGE", nature = "NATURE DAMAGE",
	shadow = "SHADOW DAMAGE", arcane = "ARCANE DAMAGE" }
local NUMBER = "(%d+%.?%d*)"
local LINE_PATTERNS = {
	{ "critical strike with holy spells by " .. NUMBER, "HOLY CRIT" },
	{ "critical strike with spells by " .. NUMBER, "SPELL CRIT" },
	{ "critical strike with ranged weapons by " .. NUMBER, "RANGED CRIT" },
	{ "critical strike by " .. NUMBER, "CRIT" },
	{ "chance to hit with spells by " .. NUMBER, "SPELL HIT" },
	{ "chance to hit by " .. NUMBER, "HIT" },
	{ "damage and healing done by magical spells and effects by up to " .. NUMBER, { "SPELL POWER", "HEALING" } },
	{ "healing done by spells and effects by up to " .. NUMBER, "HEALING" },
	{ "damage done by (%a+) spells and effects by up to " .. NUMBER, "SCHOOL" },
	{ "damage done by magical spells and effects by up to " .. NUMBER, "SPELL DAMAGE" },
	{ "ranged attack power by " .. NUMBER, "RANGED ATTACK POWER" },
	{ "attack power by " .. NUMBER .. " in cat", "FERAL ATTACK POWER" },
	{ "attack power by " .. NUMBER, "ATTACK POWER" },
	{ "%+" .. NUMBER .. " attack power", "ATTACK POWER" },
	{ NUMBER .. " mana per 5 sec", "MANA PER 5" },
	{ "defense %+" .. NUMBER, "DEFENSE" },
	{ "defense rating by " .. NUMBER, "DEFENSE" },
	{ "chance to dodge an attack by " .. NUMBER, "DODGE" },
	{ "chance to parry an attack by " .. NUMBER, "PARRY" },
	{ "chance to block attacks with a shield by " .. NUMBER, "BLOCK" },
	{ "block value of your shield by " .. NUMBER, "BLOCK VALUE" },
	{ "attack speed by " .. NUMBER, "HASTE" },
}
-- Without the client's stats (a client that lacks C_Item.GetItemStats), the plain lines too.
local PLAIN_PATTERNS = {
	{ "^%+" .. NUMBER .. " strength", "STRENGTH" }, { "^%+" .. NUMBER .. " agility", "AGILITY" },
	{ "^%+" .. NUMBER .. " stamina", "STAMINA" }, { "^%+" .. NUMBER .. " intellect", "INTELLECT" },
	{ "^%+" .. NUMBER .. " spirit", "SPIRIT" }, { "^" .. NUMBER .. " armor", "ARMOR" },
	{ "%(" .. NUMBER .. " damage per second%)", "DPS" },
}

local function Add(stats, keys, value)
	if type(keys) == "table" then
		for _, key in ipairs(keys) do stats[key] = (stats[key] or 0) + value end
	else
		stats[keys] = (stats[keys] or 0) + value
	end
end

-- Whether a line is red, as the tooltip shows what the player cannot use.
local function IsRed(color)
	if not color then return false end
	local r, g, b
	if color.GetRGB then r, g, b = color:GetRGB() else r, g, b = color.r, color.g, color.b end
	return (r or 0) > 0.9 and (g or 1) < 0.2 and (b or 1) < 0.2
end

-- The item's tooltip lines: { text, red, rightRed }, from the client's tooltip data.
local function TooltipLines(link)
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink) then return nil end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then return nil end
	local out = {}
	for index, line in ipairs(data.lines) do
		if line.leftText == nil and TooltipUtil and TooltipUtil.SurfaceArgs then pcall(TooltipUtil.SurfaceArgs, line) end
		out[index] = { text = line.leftText or "", red = IsRed(line.leftColor), rightRed = IsRed(line.rightColor) }
	end
	return out
end

-- The stats one line gives, unless the client gave them already.
local function ReadLine(text, stats, given, patterns)
	local lower = text:lower()
	for _, pattern in ipairs(patterns) do
		local a, b = lower:match(pattern[1])
		if a then
			local key, value = pattern[2], tonumber(b or a)
			if key == "SCHOOL" then key, value = SCHOOLS[a], tonumber(b) end
			local first = type(key) == "table" and key[1] or key
			if key and value and not given[first] then Add(stats, key, value) end
			return
		end
	end
end

local readCache = {}

--[[
	Everything about an item a score needs: { stats, equipLoc, minLevel, usable, link }, or nil
	while the client has not described it. Kept per link: stats never change.
	`usable` is false when its tooltip has a red line other than the level it needs (armour or
	weapon the class cannot use, a class it is not for).
]]
function ItemScore:Read(link)
	if not link then return nil end
	local cached = readCache[link]
	if cached then return cached end
	local getInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	local ok, name, _, _, _, minLevel, _, _, _, equipLoc = pcall(getInfo, link)
	if not (ok and name) then return nil end
	local item = { stats = {}, equipLoc = equipLoc, minLevel = minLevel or 0, usable = true, link = link }
	local given = {}
	local getStats = C_Item and C_Item.GetItemStats or GetItemStats
	local haveStats = false
	if getStats then
		local statsOk, raw = pcall(getStats, link)
		if statsOk and type(raw) == "table" then
			haveStats = true
			for clientKey, value in pairs(raw) do
				local key = STAT_KEYS[clientKey]
				if key then
					Add(item.stats, key, value)
					given[type(key) == "table" and key[1] or key] = true
				elseif key == nil then
					self.unknownKeys[clientKey] = true
				end
			end
		end
	end
	local lines = TooltipLines(link)
	for index, line in ipairs(lines or {}) do
		if index > 1 then
			local text = line.text
			if (line.red and not text:find("^Requires Level")) or line.rightRed then item.usable = false end
			local equip = text:match("^Equip:%s*(.+)$")
			if equip then
				ReadLine(equip, item.stats, given, LINE_PATTERNS)
			elseif not haveStats then
				ReadLine(text, item.stats, given, PLAIN_PATTERNS)
			end
		end
	end
	-- A ranged weapon's damage is ranged.
	if RANGED_WEAPON[equipLoc or ""] and item.stats.DPS then
		item.stats["RANGED DPS"], item.stats.DPS = item.stats.DPS, nil
	end
	readCache[link] = item
	return item
end

------------------------------------------------------------------------------------------
-- The player's spec and weights
------------------------------------------------------------------------------------------

local function Settings()
	ns.charDB.gearFinder = ns.charDB.gearFinder or {}
	return ns.charDB.gearFinder
end

function ItemScore:Class()
	local _, classFile = UnitClass("player")
	return classFile
end

function ItemScore:Level()
	return UnitLevel("player") or 1
end

-- The class's specs, in order: { key, label }.
function ItemScore:Specs(classFile)
	local data = ns.GEAR_WEIGHTS[classFile or self:Class()]
	local out = {}
	for _, key in ipairs(data and data.order or {}) do out[#out + 1] = { key = key, label = data[key].label } end
	return out
end

-- Pathfinder's names for the classic trees, where they differ from the tree's own.
local TREE_SPEC = { ["Beast Mastery"] = "BeastMastery", ["Feral Combat"] = "FeralCat" }

--[[
	The tree with the most points spent, from Forever's talent data: its talents are the classic
	three trees, kept as the groups of one trait tree. Untested on Forever, so every step is
	guarded and any doubt answers nil.
]]
function ItemScore:TalentSpec(classFile)
	local data = ns.GEAR_WEIGHTS[classFile]
	if not (data and C_ClassTalents and C_ClassTalents.GetActiveConfigID and C_Traits and C_Traits.GetConfigInfo
		and C_Traits.GetGroupDisplayInfoByTreeID and C_Traits.GetGroupCurrencyInfo) then
		return nil
	end
	local ok, spec = pcall(function()
		local configID = C_ClassTalents.GetActiveConfigID()
		local config = configID and C_Traits.GetConfigInfo(configID)
		local treeID = config and config.treeIDs and config.treeIDs[1]
		local groups = treeID and C_Traits.GetGroupDisplayInfoByTreeID(treeID)
		if type(groups) ~= "table" then return nil end
		local ids = {}
		for index, group in ipairs(groups) do ids[index] = group.groupID end
		local spent = C_Traits.GetGroupCurrencyInfo(configID, ids)
		local best, bestPoints = nil, 0
		for index, group in ipairs(groups) do
			local info = spent and spent[index]
			local points = info and info.currencyInfos and info.currencyInfos[1] and info.currencyInfos[1].spent or 0
			if points > bestPoints then
				local name = TREE_SPEC[group.displayName] or (group.displayName or ""):gsub("%s", "")
				if data[name] then best, bestPoints = name, points end
			end
		end
		return best
	end)
	return ok and spec or nil
end

--- The spec scored: the one picked, else the talents', else the class's levelling spec. And why.
function ItemScore:Spec()
	local classFile = self:Class()
	local data = ns.GEAR_WEIGHTS[classFile]
	if not data then return nil end
	local picked = Settings().spec
	if picked and data[picked] then return picked, "picked" end
	local fromTalents = self:TalentSpec(classFile)
	if fromTalents then return fromTalents, "talents" end
	return data.levelling, "levelling"
end

function ItemScore:SetSpec(spec)
	Settings().spec = spec
	self:Changed()
end

function ItemScore:SpecLabel(spec)
	local data = ns.GEAR_WEIGHTS[self:Class()]
	return data and data[spec] and data[spec].label or spec
end

-- The weights in use: the levelling set below 60 (tanks have one set).
function ItemScore:Weights(spec)
	local data = ns.GEAR_WEIGHTS[self:Class()]
	local entry = data and data[spec or self:Spec()]
	if not entry then return {} end
	return (self:Level() < MAX_LEVEL and entry.leveling) or entry.max
end

function ItemScore:ScoreStats(stats, weights)
	local score = 0
	for key, value in pairs(stats) do score = score + value * (weights[key] or 0) end
	return score
end

------------------------------------------------------------------------------------------
-- Against what is worn
------------------------------------------------------------------------------------------

local dualWield

function ItemScore:CanDualWield()
	if dualWield == nil then
		local known = false
		for _, check in ipairs({ IsPlayerSpell, IsSpellKnown, C_SpellBook and C_SpellBook.IsSpellKnown }) do
			if not known and type(check) == "function" then
				local ok, result = pcall(check, DUAL_WIELD_SPELL)
				known = ok and result == true
			end
		end
		dualWield = known
	end
	return dualWield
end

-- What is worn in a slot: its score (0 if nothing) and its item.
function ItemScore:Worn(slot, weights)
	local link = GetInventoryItemLink("player", slot)
	local item = link and self:Read(link)
	if not item then return 0, nil, link end
	return self:ScoreStats(item.stats, weights), item, link
end

--[[
	How an item compares with what is worn, for these weights: { score, slot, worn (its score),
	delta, pct (nil against an empty slot), emptySlot, usable, later, minLevel, noCompare }, or nil
	when it can't be read yet or goes in no slot.
]]
function ItemScore:Compare(link, weights)
	weights = weights or self:Weights()
	local item = self:Read(link)
	if not item or not SLOTS[item.equipLoc or ""] then return nil end
	local score = self:ScoreStats(item.stats, weights)
	local out = { score = score, usable = item.usable, minLevel = item.minLevel, later = item.minLevel > self:Level() }

	local loc = item.equipLoc
	local slots = SLOTS[loc]
	if loc == "INVTYPE_WEAPON" and self:CanDualWield() then slots = { MAINHAND, OFFHAND } end
	local mainScore, mainItem = self:Worn(MAINHAND, weights)
	local twoHanded = mainItem and mainItem.equipLoc == "INVTYPE_2HWEAPON"

	if loc == "INVTYPE_2HWEAPON" then
		local offScore = twoHanded and 0 or self:Worn(OFFHAND, weights)
		out.slot, out.worn = MAINHAND, mainScore + offScore
	elseif twoHanded and OFF_HAND_ONLY[loc] then
		-- An off hand is only half of what would replace a two-hander.
		out.slot, out.noCompare = OFFHAND, true
		return out
	else
		-- The slot it would replace: the weaker of those it fits.
		for _, slot in ipairs(slots) do
			local worn = self:Worn(slot, weights)
			if not out.slot or worn < out.worn then out.slot, out.worn = slot, worn end
		end
		if twoHanded and out.slot == OFFHAND then out.slot, out.worn = MAINHAND, mainScore end
	end
	out.emptySlot = GetInventoryItemLink("player", out.slot) == nil
	out.delta = score - out.worn
	if out.worn > 0 then out.pct = out.delta / out.worn * 100 end
	return out
end

------------------------------------------------------------------------------------------
-- Changes
------------------------------------------------------------------------------------------

local listeners = {}

function ItemScore:OnChange(callback)
	listeners[#listeners + 1] = callback
end

function ItemScore:Changed()
	for _, callback in ipairs(listeners) do callback() end
end

-- What a level changes (which set of weights, what is red on a tooltip) and what learning a
-- spell may (dual wield, a weapon skill).
function ItemScore:Forget()
	dualWield = nil
	wipe(readCache)
	self:Changed()
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_EQUIPMENT_CHANGED", "PLAYER_LEVEL_UP", "SPELLS_CHANGED", "TRAIT_CONFIG_UPDATED")
events:SetScript("OnEvent", function(_, event)
	if not ns.charDB then return end
	if event == "PLAYER_EQUIPMENT_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
		ItemScore:Changed()
	else
		ItemScore:Forget()
	end
end)
