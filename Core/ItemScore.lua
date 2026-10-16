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
	-- Worth nothing in the journal's own weights, but a player's may give them some.
	RESISTANCE1_NAME = "HOLY RESISTANCE", RESISTANCE2_NAME = "FIRE RESISTANCE", RESISTANCE3_NAME = "NATURE RESISTANCE",
	RESISTANCE4_NAME = "FROST RESISTANCE", RESISTANCE5_NAME = "SHADOW RESISTANCE", RESISTANCE6_NAME = "ARCANE RESISTANCE",
	ITEM_MOD_HEALTH_REGEN_SHORT = "HEALTH PER 5", ITEM_MOD_HEALTH_REGENERATION_SHORT = "HEALTH PER 5",
}

--[[
	Every stat a weight can be given, grouped as the character panel groups its own: what the
	weights editor (UI/WeightsEditor.lua) lists.
]]
ItemScore.STAT_GROUPS = {
	{ key = "PRIMARY", stats = { "STRENGTH", "AGILITY", "STAMINA", "INTELLECT", "SPIRIT" } },
	{ key = "WEAPONS", stats = { "DPS", "RANGED DPS", "ATTACK POWER", "RANGED ATTACK POWER", "FERAL ATTACK POWER", "HIT",
		"CRIT", "RANGED CRIT", "HASTE", "RANGED HASTE" } },
	{ key = "SPELLS", stats = { "SPELL POWER", "SPELL DAMAGE", "HEALING", "SPELL HIT", "SPELL CRIT", "HOLY CRIT",
		"HOLY DAMAGE", "FIRE DAMAGE", "FROST DAMAGE", "NATURE DAMAGE", "SHADOW DAMAGE", "ARCANE DAMAGE",
		"SPELL PENETRATION", "MANA", "MANA PER 5", "CASTING REGEN" } },
	{ key = "DEFENSE", stats = { "ARMOR", "HEALTH", "HEALTH PER 5", "DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCK VALUE" } },
	{ key = "RESISTANCE", stats = { "HOLY RESISTANCE", "FIRE RESISTANCE", "NATURE RESISTANCE", "FROST RESISTANCE",
		"SHADOW RESISTANCE", "ARCANE RESISTANCE" } },
}

-- Names the client gave that the journal does not know yet, for /aegis gearscan.
ItemScore.unknownKeys = {}

--[[
	The "Equip:" lines, in the journal's own words for the classic wording: a pattern (on the
	line in lower case) and the stat it gives. The first match on a line wins; specific before
	general. School damage takes the school from the line, and a word that is no school
	("magical") goes on to the next pattern. `false`: the line is known and worth nothing, as
	attack power against one kind of creature.
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
	{ "allows " .. NUMBER .. "%% of your mana regeneration to continue while casting", "CASTING REGEN" },
	{ "magical resistances of your spell targets by " .. NUMBER, "SPELL PENETRATION" },
	{ "attack power when fighting", false },
	{ "attack power by " .. NUMBER .. " when fighting", false },
	{ "^%+" .. NUMBER .. " ranged attack power", "RANGED ATTACK POWER" },
	{ "ranged attack power by " .. NUMBER, "RANGED ATTACK POWER" },
	{ "^%+" .. NUMBER .. " attack power in cat", "FERAL ATTACK POWER" },
	{ "attack power by " .. NUMBER .. " in cat", "FERAL ATTACK POWER" },
	{ "attack power by " .. NUMBER, "ATTACK POWER" },
	{ "%+" .. NUMBER .. " attack power", "ATTACK POWER" },
	{ NUMBER .. " mana per 5 sec", "MANA PER 5" },
	{ "restores " .. NUMBER .. " health", "HEALTH PER 5" },
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

--[[
	Which stats the client gave, so a line does not count one again. Spell damage, spell power and
	healing are one stat here: the client may name a "damage and healing" line either way.
]]
local SAME_STAT = { ["SPELL DAMAGE"] = "SPELL", ["SPELL POWER"] = "SPELL", HEALING = "SPELL" }

local function MarkGiven(given, keys)
	if type(keys) == "table" then
		for _, key in ipairs(keys) do given[SAME_STAT[key] or key] = true end
	else
		given[SAME_STAT[keys] or keys] = true
	end
end

local function IsGiven(given, keys)
	if type(keys) == "table" then
		for _, key in ipairs(keys) do
			if given[SAME_STAT[key] or key] then return true end
		end
		return false
	end
	return given[SAME_STAT[keys] or keys] == true
end

-- Whether a line is red, as the tooltip shows what the player cannot use.
local function IsRed(color)
	if not color then return false end
	local r, g, b
	if color.GetRGB then r, g, b = color:GetRGB() else r, g, b = color.r, color.g, color.b end
	return (r or 0) > 0.9 and (g or 1) < 0.2 and (b or 1) < 0.2
end

-- The item's tooltip lines: { text, red, rightRed }, from the client's tooltip data, and the
-- data's id, which the client names again when more of it comes in.
local function TooltipLines(link)
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink) then return nil end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then return nil end
	local out = {}
	for index, line in ipairs(data.lines) do
		if line.leftText == nil and TooltipUtil and TooltipUtil.SurfaceArgs then pcall(TooltipUtil.SurfaceArgs, line) end
		out[index] = { text = line.leftText or "", red = IsRed(line.leftColor), rightRed = IsRed(line.rightColor) }
	end
	return out, data.dataInstanceID
end

-- The stats one line gives, unless the client gave them already.
local function ReadLine(text, stats, given, patterns)
	local lower = text:lower()
	for _, pattern in ipairs(patterns) do
		local a, b = lower:match(pattern[1])
		local key, value = pattern[2], tonumber(b or a)
		if a and key == "SCHOOL" then key, value = SCHOOLS[a], tonumber(b) end
		if a and key ~= nil then
			if key and value and not IsGiven(given, key) then Add(stats, key, value) end
			return
		end
	end
end

-- The client's own words, in its language: the level line, which is red until the player has
-- that level, and the start of an Equip: line.
local function LevelLine(minLevel)
	return string.format(ITEM_MIN_LEVEL or "Requires Level %d", minLevel or 0)
end
local EQUIP_PREFIX = "^" .. (ITEM_SPELL_TRIGGER_ONEQUIP or "Equip:"):gsub("%p", "%%%0") .. "%s*(.+)$"
--[[
	Only one may be worn: "Unique", "Unique-Equipped", or a limit of one ("Unique (1)",
	"Unique: Rings (1)", "Unique-Equipped: Rings (1)"); "Unique (2)" lets two be had, and worn.
	Read in the client's own words, its format strings made patterns: other languages word
	these, and bracket the count, their own way ("装备唯一：%s （%d）").
]]
local function FormatPattern(format)
	local pattern = format:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
	-- The format's own %d and %s (or %1$s), escaped above: the count, and anything.
	pattern = pattern:gsub("%%%%%d+%%%$([ds])", "%%%%%1"):gsub("%%%%d", "(%%d+)"):gsub("%%%%s", ".-")
	return "^" .. pattern .. "$"
end

local uniqueWordsOf, uniqueExact, uniqueLimits
local function UniqueWords()
	local words = { ITEM_UNIQUE or "Unique", ITEM_UNIQUE_EQUIPPABLE or "Unique-Equipped" }
	local formats = { ITEM_UNIQUE_MULTIPLE or "Unique (%d)", ITEM_LIMIT_CATEGORY or "Unique: %s (%d)",
		ITEM_LIMIT_CATEGORY_MULTIPLE or "Unique-Equipped: %s (%d)" }
	local key = table.concat(words, "\1") .. "\1" .. table.concat(formats, "\1")
	if key ~= uniqueWordsOf then
		uniqueWordsOf, uniqueExact, uniqueLimits = key, words, {}
		for _, format in ipairs(formats) do
			uniqueLimits[#uniqueLimits + 1] = { pattern = FormatPattern(format), counted = format:find("%%%d*%$?d") ~= nil }
		end
	end
	return uniqueExact, uniqueLimits
end

function ItemScore.IsUniqueLine(text)
	local exact, limits = UniqueWords()
	for _, words in ipairs(exact) do
		if text == words then return true end
	end
	for _, limit in ipairs(limits) do
		local count = text:match(limit.pattern)
		if count then return not limit.counted or tonumber(count) == 1 end
	end
	return false
end
local IsUniqueLine = ItemScore.IsUniqueLine

local readCache, linkOfData = {}, {}

--[[
	Everything about an item a score needs: { stats, equipLoc, minLevel, usable, unique, link },
	or nil while the client has not described it. Kept per link: stats never change, though the client
	may describe its Equip: lines later (TOOLTIP_DATA_UPDATE), and then it is read again.
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
					MarkGiven(given, key)
				elseif key == nil then
					self.unknownKeys[clientKey] = true
				end
			end
		end
	end
	local lines, dataID = TooltipLines(link)
	local levelLine = LevelLine(item.minLevel)
	for index, line in ipairs(lines or {}) do
		if index > 1 then
			local text = line.text
			if (line.red and text ~= levelLine and not text:find("^Requires Level")) or line.rightRed then
				item.usable = false
			end
			if IsUniqueLine(text) then item.unique = true end
			local equip = text:match(EQUIP_PREFIX)
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
	-- Without its tooltip it is read again next time: the client may not have it yet.
	if lines then
		readCache[link] = item
		if dataID then linkOfData[dataID] = link end
	end
	return item
end

-- The client described more of an item's tooltip: read it again. True if it was one of ours.
function ItemScore:TooltipUpdated(dataID)
	if dataID == nil then
		-- Something, unnamed: everything is read again at the next search, without asking for one.
		wipe(readCache)
		wipe(linkOfData)
		return false
	end
	local link = linkOfData[dataID]
	if not link then return false end
	linkOfData[dataID], readCache[link] = nil, nil
	return true
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

-- A spec's name in the client's language: the locale's (L.GEAR_SPEC_NAMES, by spec), else the
-- English in the generated weights.
local function SpecName(data, spec)
	local names = ns.L.GEAR_SPEC_NAMES
	return names and names[spec] or data and data[spec] and data[spec].label or spec
end

-- The class's specs, in order: { key, label }.
function ItemScore:Specs(classFile)
	local data = ns.GEAR_WEIGHTS[classFile or self:Class()]
	local out = {}
	for _, key in ipairs(data and data.order or {}) do out[#out + 1] = { key = key, label = SpecName(data, key) } end
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
		-- Each answer names its group, as the client's own talent frame matches them.
		local byGroup = {}
		for _, info in ipairs(C_Traits.GetGroupCurrencyInfo(configID, ids) or {}) do
			if info.traitNodeGroupID then byGroup[info.traitNodeGroupID] = info end
		end
		local best, bestPoints = nil, 0
		for _, group in ipairs(groups) do
			local info = byGroup[group.groupID]
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

-- The spec picked from the Gear Finder's menu, or nil for automatic.
function ItemScore:PickedSpec()
	local data = ns.GEAR_WEIGHTS[self:Class()]
	local picked = Settings().spec
	if picked and data and data[picked] then return picked end
	return nil
end

-- What automatic scores: the talents' spec, else the class's levelling spec. And why.
function ItemScore:AutoSpec()
	local classFile = self:Class()
	local data = ns.GEAR_WEIGHTS[classFile]
	if not data then return nil end
	local fromTalents = self:TalentSpec(classFile)
	if fromTalents then return fromTalents, "talents" end
	return data.levelling, "levelling"
end

--- The spec scored: the one picked, else automatic's. And why.
function ItemScore:Spec()
	local picked = self:PickedSpec()
	if picked then return picked, "picked" end
	return self:AutoSpec()
end

function ItemScore:SetSpec(spec)
	Settings().spec = spec
	self:Changed()
end

function ItemScore:SpecLabel(spec)
	return SpecName(ns.GEAR_WEIGHTS[self:Class()], spec)
end

-- What the journal's weights for a spec count in ("attack power"...), in the client's language
-- (L.GEAR_UNITS, by the English word); nil for a spec it has no weights for.
function ItemScore:SpecUnit(spec)
	local data = ns.GEAR_WEIGHTS[self:Class()]
	local unit = data and data[spec] and data[spec].unit
	local units = ns.L.GEAR_UNITS
	return unit and (units and units[unit] or unit)
end

-- The journal's own weights for a spec: the levelling set below 60 (tanks have one set).
function ItemScore:DefaultWeights(spec)
	local data = ns.GEAR_WEIGHTS[self:Class()]
	local entry = data and data[spec or self:Spec()]
	if not entry then return {} end
	return (self:Level() < MAX_LEVEL and entry.leveling) or entry.max
end

--[[
	The player's own weights for a spec, kept per character; nil while the journal's are used.
	Either changes made in the editor, { overrides = { [stat] = weight } }, laid over the journal's
	weights of the moment (so its level-60 set still takes over at 60), or a scale brought from
	Pawn, { weights = {...}, source = its name }, which stands in for them whole.
]]
function ItemScore:CustomWeights(spec)
	local custom = Settings().custom
	return custom and custom[spec or self:Spec()] or nil
end

-- The journal's weights with the player's changes laid over them, kept until anything changes.
local merged = {}

-- The weights in use: the player's own for the spec, else the journal's.
function ItemScore:Weights(spec)
	spec = spec or self:Spec()
	local custom = self:CustomWeights(spec)
	if not custom then return self:DefaultWeights(spec) end
	if custom.weights then return custom.weights end
	local defaults = self:DefaultWeights(spec)
	local kept = merged[spec]
	if kept and kept.defaults == defaults then return kept.weights end
	local weights = {}
	for key, value in pairs(defaults) do weights[key] = value end
	for key, value in pairs(custom.overrides or {}) do weights[key] = value end
	merged[spec] = { defaults = defaults, weights = weights }
	return weights
end

local function SameWeights(a, b)
	for key, value in pairs(a) do
		if math.abs(value - (b[key] or 0)) > 1e-9 then return false end
	end
	for key, value in pairs(b) do
		if a[key] == nil and value ~= 0 then return false end
	end
	return true
end

--[[
	One weight changed for a spec: an override on the journal's weights, let go when it is set
	back to theirs, or a change to a scale brought from Pawn.
]]
function ItemScore:SetWeight(spec, stat, value)
	local settings = Settings()
	settings.custom = settings.custom or {}
	local set = settings.custom[spec]
	if set and set.weights then
		set.weights[stat] = value ~= 0 and value or nil
		if SameWeights(set.weights, self:DefaultWeights(spec)) then settings.custom[spec] = nil end
	else
		set = set or {}
		set.overrides = set.overrides or {}
		local default = self:DefaultWeights(spec)[stat] or 0
		set.overrides[stat] = math.abs(value - default) > 1e-9 and value or nil
		settings.custom[spec] = next(set.overrides) and set or nil
	end
	self:Changed()
end

-- Back to the journal's weights for a spec.
function ItemScore:ResetWeights(spec)
	local custom = Settings().custom
	if custom then custom[spec] = nil end
	self:Changed()
end

-- A weight worth keeping: a number, and not an absurd one (Pawn marks what a class cannot use
-- with -1000000).
local function SaneWeight(value)
	return type(value) == "number" and value == value and math.abs(value) < 1e6
end
ItemScore.SaneWeight = SaneWeight

--[[
	Pawn's scale tags, as its Export gives them: ( Pawn: v1: "Name": Class=Warrior, Strength=1, ... ).
	Stat names are read in either of the spellings Pawn's tags use, without regard to case. One may
	stand for more than one of the journal's stats: Pawn's spell damage is that of "damage and
	healing" gear as well as of damage-only gear. `false`: known, and nothing an item here carries.
]]
local PAWN_STATS = {
	strength = "STRENGTH", agility = "AGILITY", stamina = "STAMINA", intellect = "INTELLECT", spirit = "SPIRIT",
	armor = "ARMOR", bonusarmor = "ARMOR",
	ap = "ATTACK POWER", attackpower = "ATTACK POWER", rap = "RANGED ATTACK POWER", rangedap = "RANGED ATTACK POWER",
	rangedattackpower = "RANGED ATTACK POWER", feralap = "FERAL ATTACK POWER",
	hit = "HIT", hitrating = "HIT", meleehit = "HIT", crit = "CRIT", critrating = "CRIT", meleecrit = "CRIT",
	rangedcrit = "RANGED CRIT", haste = "HASTE", hasterating = "HASTE", meleehaste = "HASTE", rangedhaste = "RANGED HASTE",
	spellpower = { "SPELL POWER", "SPELL DAMAGE" }, spelldamage = { "SPELL DAMAGE", "SPELL POWER" }, healing = "HEALING",
	spellhit = "SPELL HIT", spellhitrating = "SPELL HIT", spellcrit = "SPELL CRIT", spellcritrating = "SPELL CRIT",
	holyspelldamage = "HOLY DAMAGE", firespelldamage = "FIRE DAMAGE", frostspelldamage = "FROST DAMAGE",
	naturespelldamage = "NATURE DAMAGE", shadowspelldamage = "SHADOW DAMAGE", arcanespelldamage = "ARCANE DAMAGE",
	spellpenetration = "SPELL PENETRATION", mana = "MANA", mp5 = "MANA PER 5", health = "HEALTH", hp5 = "HEALTH PER 5",
	defense = "DEFENSE", defenserating = "DEFENSE", dodge = "DODGE", dodgerating = "DODGE", parry = "PARRY",
	parryrating = "PARRY", block = "BLOCK", blockrating = "BLOCK", blockvalue = "BLOCK VALUE",
	holyresist = "HOLY RESISTANCE", fireresist = "FIRE RESISTANCE", natureresist = "NATURE RESISTANCE",
	frostresist = "FROST RESISTANCE", shadowresist = "SHADOW RESISTANCE", arcaneresist = "ARCANE RESISTANCE",
	metasocketeffect = false, redsocket = false, yellowsocket = false, bluesocket = false, prismaticsocket = false,
}
-- Weapon damage, which adds up in Pawn: every weapon's Dps, a melee weapon's MeleeDps and that of
-- its hand, a ranged weapon's RangedDps. The journal has no off hand's own.
local PAWN_DPS = { dps = true, meleedps = true, rangeddps = true, mainhanddps = true, onehanddps = true,
	twohanddps = true, offhanddps = true }
-- What a tag says about itself rather than a stat.
local PAWN_SETTINGS = { class = true, spec = true, speedbaseline = true }

--[[
	The weights in a Pawn scale tag, its name, the stat names it has that the journal doesn't know,
	and the class it says it is for; nil when the text holds no tag, or no stat the journal knows.
]]
function ItemScore:ParsePawn(text)
	if type(text) ~= "string" then return nil end
	local name, body = text:match('%(%s*Pawn%s*:%s*v%d+%s*:%s*"([^"]*)"%s*:(.-)%)')
	if not body then return nil end
	local weights, unknown, dps, found, class = {}, {}, {}, 0, nil
	for pair in body:gmatch("[^,]+") do
		local key, value = pair:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
		if key then
			local lower, number = key:lower(), tonumber(value)
			local stat = PAWN_STATS[lower]
			if lower == "class" then
				class = value
			elseif PAWN_DPS[lower] then
				if SaneWeight(number) then dps[lower], found = number, found + 1 end
			elseif stat and SaneWeight(number) then
				for _, target in ipairs(type(stat) == "table" and stat or { stat }) do
					weights[target] = math.max(weights[target] or number, number)
				end
				found = found + 1
			elseif stat == nil and not PAWN_SETTINGS[lower] then
				unknown[#unknown + 1] = key
			end
		end
	end
	if found == 0 then return nil end
	local hand = math.max(dps.mainhanddps or 0, dps.onehanddps or 0, dps.twohanddps or 0)
	weights.DPS = (dps.dps or 0) + (dps.meleedps or 0) + hand
	weights["RANGED DPS"] = (dps.dps or 0) + (dps.rangeddps or 0)
	for stat, value in pairs(weights) do
		if value == 0 then weights[stat] = nil end
	end
	return weights, name, unknown, class
end

--[[
	A Pawn scale tag as a spec's weights: true, the scale's name and the names left out. False,
	and the class the tag is for, when that is another class than the player's.
]]
function ItemScore:ImportPawn(spec, text)
	local weights, name, unknown, class = self:ParsePawn(text)
	if not weights then return false end
	if class and class ~= "" and class:upper():gsub("[%s_]", "") ~= self:Class() then return false, nil, nil, class end
	local settings = Settings()
	settings.custom = settings.custom or {}
	settings.custom[spec] = { weights = weights, source = name ~= "" and name or nil }
	self:Changed()
	return true, name, unknown
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

-- The client's own answer, else the Dual Wield spell. IsPlayerSpell and IsSpellKnown are only
-- the client's fallbacks for old addons, there only while those are loaded.
function ItemScore:CanDualWield()
	if dualWield == nil then
		local known = false
		local checks = { CanDualWield, C_SpellBook and C_SpellBook.IsSpellKnown, IsPlayerSpell, IsSpellKnown }
		for index = 1, 4 do
			local check = checks[index]
			if not known and type(check) == "function" then
				local ok, result = pcall(check, check ~= CanDualWield and DUAL_WIELD_SPELL or nil)
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

-- The slots gear with stats goes in (not shirt or tabard).
local EQUIPMENT_SLOTS = { HEAD, NECK, SHOULDER, CHEST, WAIST, LEGS, FEET, WRIST, HANDS, FINGER1, FINGER2,
	TRINKET1, TRINKET2, BACK, MAINHAND, OFFHAND, RANGED }

-- What everything worn is worth together, for these weights.
function ItemScore:WornTotal(weights)
	weights = weights or self:Weights()
	local total = 0
	for _, slot in ipairs(EQUIPMENT_SLOTS) do total = total + self:Worn(slot, weights) end
	return total
end

-- Whether every worn item has been described: one that hasn't yet scores 0 for now.
function ItemScore:WornKnown()
	for _, slot in ipairs(EQUIPMENT_SLOTS) do
		local link = GetInventoryItemLink("player", slot)
		if link and not self:Read(link) then return false end
	end
	return true
end

-- Rings and trinkets: two slots, and a second upgrade replaces the other one.
local PAIRED = { INVTYPE_FINGER = true, INVTYPE_TRINKET = true }

-- Which of these slots wears the same item (by its id), if one does.
function ItemScore:WornSlot(link, slots)
	local itemID = ns.ItemIDFromLink(link)
	if not itemID then return nil end
	for _, slot in ipairs(slots or EQUIPMENT_SLOTS) do
		if ns.ItemIDFromLink(GetInventoryItemLink("player", slot)) == itemID then return slot end
	end
	return nil
end

--[[
	How an item compares with what is worn, for these weights: { score, slot, worn (its score),
	delta, pct (nil against an empty slot or one worth nothing), alsoSlot (the off hand a two-hander
	also replaces), total (everything worn), share
	(delta as a part of total, nil while nothing worn is worth anything), emptySlot, usable,
	later, minLevel, noCompare }, or nil when it can't be read yet or goes in no slot. A ring or
	trinket also says the other slot of the two: otherSlot, otherWorn, otherEmpty.

	The share is what the Gear Finder shows: against a worn item worth next to nothing, the gain
	over that item alone runs to thousands of percent; against everything worn, it stays a
	measure of how much stronger the item makes the character. `total` may be given, when many
	items are compared at once.
]]
function ItemScore:Compare(link, weights, total)
	weights = weights or self:Weights()
	local item = self:Read(link)
	if not item or not SLOTS[item.equipLoc or ""] then return nil end
	local score = self:ScoreStats(item.stats, weights)
	total = total or self:WornTotal(weights)
	local out = { score = score, usable = item.usable, minLevel = item.minLevel, later = item.minLevel > self:Level(),
		total = total }

	local loc = item.equipLoc
	local slots = SLOTS[loc]
	if loc == "INVTYPE_WEAPON" and self:CanDualWield() then slots = { MAINHAND, OFFHAND } end
	-- An off-hand weapon is for those who can wield two: the tooltip does not say so in red.
	if loc == "INVTYPE_WEAPONOFFHAND" and not self:CanDualWield() then out.usable = false end
	local mainScore, mainItem = self:Worn(MAINHAND, weights)
	local twoHanded = mainItem and mainItem.equipLoc == "INVTYPE_2HWEAPON"

	if loc == "INVTYPE_2HWEAPON" then
		local offScore = twoHanded and 0 or self:Worn(OFFHAND, weights)
		out.slot, out.worn = MAINHAND, mainScore + offScore
		-- It takes the off hand's place too.
		if not twoHanded and GetInventoryItemLink("player", OFFHAND) then out.alsoSlot = OFFHAND end
	elseif twoHanded and OFF_HAND_ONLY[loc] then
		-- An off hand is only half of what would replace a two-hander.
		out.slot, out.noCompare = OFFHAND, true
		return out
	else
		-- The slot it would replace: the weaker of those it fits. A unique item worn already can only
		-- take its own place: a second one cannot go beside it.
		local own = item.unique and self:WornSlot(link, slots)
		local scores = {}
		for index, slot in ipairs(slots) do
			scores[index] = self:Worn(slot, weights)
			if own then
				if slot == own then out.slot, out.worn = slot, scores[index] end
			elseif not out.slot or scores[index] < out.worn then
				out.slot, out.worn = slot, scores[index]
			end
		end
		if twoHanded and out.slot == OFFHAND then out.slot, out.worn = MAINHAND, mainScore end
		if PAIRED[loc] then
			local other = out.slot == slots[1] and 2 or 1
			out.otherSlot, out.otherWorn = slots[other], scores[other]
			out.otherEmpty = GetInventoryItemLink("player", out.otherSlot) == nil
		end
	end
	out.emptySlot = GetInventoryItemLink("player", out.slot) == nil and out.alsoSlot == nil
	out.delta = score - out.worn
	if out.worn > 0 then out.pct = out.delta / out.worn * 100 end
	if total > 0 then out.share = out.delta / total * 100 end
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
	wipe(merged)
	for _, callback in ipairs(listeners) do callback() end
end

-- What a level changes (which set of weights, what is red on a tooltip) and what learning a
-- spell may (dual wield, a weapon skill).
function ItemScore:Forget()
	dualWield = nil
	wipe(readCache)
	wipe(linkOfData)
	self:Changed()
end

-- Tooltip answers come in bursts: one change for all that came in this long.
local TOOLTIP_DELAY = 0.5
local tooltipQueued = false

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_EQUIPMENT_CHANGED", "PLAYER_LEVEL_UP", "SPELLS_CHANGED", "TRAIT_CONFIG_UPDATED",
	"TOOLTIP_DATA_UPDATE")
events:SetScript("OnEvent", function(_, event, dataID)
	if not ns.charDB then return end
	if event == "TOOLTIP_DATA_UPDATE" then
		if ItemScore:TooltipUpdated(dataID) and not tooltipQueued then
			tooltipQueued = true
			C_Timer.After(TOOLTIP_DELAY, function()
				tooltipQueued = false
				ItemScore:Changed()
			end)
		end
	elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
		ItemScore:Changed()
	else
		ItemScore:Forget()
	end
end)
