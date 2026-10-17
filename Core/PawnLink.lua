local _, ns = ...
local L = ns.L

--[[
	Working with Pawn, where it is installed and enabled.

	While Pawn is there, its own item tooltips and upgrade arrows are the ones shown: the journal's
	(UI/ItemTooltip.lua, UI/UpgradeArrows.lua) stand aside, so an item never carries two. The player
	is asked once whose stat weights Pawn and the Gear Finder should both use, and can change that in
	the journal's options:
	  - The journal's: the journal adds itself to Pawn as a scale provider, with a scale for each
	    spec of the player's class holding the weights the Gear Finder has for it (PawnLink:Push).
	    Pawn shows the one for the spec the Gear Finder scores for, and none of its own, so Pawn's
	    tooltips and arrows weigh items as the Gear Finder does.
	  - Pawn's: the Gear Finder takes the weights of Pawn's scale for the spec it scores for, read
	    through Pawn's own functions (PawnCommon.Scales, PawnIsScaleVisible, PawnGetAllStatValues)
	    and named as the journal names its stats (ItemScore.FromPawnValues).
	Pawn's own scales are only ever hidden and shown again, on this character, through
	PawnSetScaleVisible; their weights are never changed.

	Without Pawn, the journal's own weights, tooltips and arrows are used, as before.
]]

local PawnLink = {}
ns.PawnLink = PawnLink

local POPUP = "AEGIS_JOURNAL_WEIGHTS_SOURCE"
-- The journal as a scale provider in Pawn, and its scales' colour there (Ashbringer's gold).
local PROVIDER = "AegisJournal"
local COLOR = "e6cc80"

-- A call into Pawn that cannot break the journal: Pawn reports its own errors in chat.
local function Call(fn, ...)
	if type(fn) ~= "function" then return nil end
	local ok, a, b = pcall(fn, ...)
	if ok then return a, b end
	return nil
end

local hooked, weightsOf, scaleOf = false, {}, {}
-- While the journal is giving Pawn its scales; what it gave last.
local pushing, pushed = false, nil

-- Pawn's scales or settings changed: its weights are read again, and the journal scores anew
-- (not for the journal's own changes to its scales in Pawn).
local function PawnChanged()
	wipe(weightsOf)
	wipe(scaleOf)
	if not pushing and PawnLink:UsesWeights() then ns.ItemScore:Changed() end
end

-- Whether Pawn is installed, enabled and ready.
function PawnLink:Present()
	if Call(PawnIsReady) ~= true then return false end
	if not hooked then
		hooked = true
		for _, name in ipairs({ "PawnResetTooltips", "PawnInvalidateBestItems" }) do
			if type(_G[name]) == "function" then hooksecurefunc(name, PawnChanged) end
		end
	end
	return true
end

-- "pawn" or "journal": the player's choice; nil until asked.
function PawnLink:Source()
	return ns.db and ns.db.weightsSource
end

-- Pawn shows the scales for the choice before the Gear Finder scores again.
function PawnLink:SetSource(source)
	ns.db.weightsSource = source
	wipe(weightsOf)
	wipe(scaleOf)
	self:Push()
	ns.ItemScore:Changed()
	if Settings and Settings.NotifyUpdate then pcall(Settings.NotifyUpdate, "AEGIS_JOURNAL_PAWN_WEIGHTS") end
end

-- Whether the Gear Finder scores with Pawn's weights now.
function PawnLink:UsesWeights()
	return self:Source() == "pawn" and self:Present()
end

--[[
	Pawn's number for a spec of a class: its place in the journal's list, but where Pawn's Forever
	scales number them otherwise. The Druid's cat (Feral Damage) comes before the bear (Feral Tank),
	and the Shaman has no tank scale, so the journal's Enhancement tank takes Pawn's Enhancement.
]]
local PAWN_SPECS = {
	DRUID = { Balance = 1, FeralCat = 2, FeralBear = 3, Restoration = 4 },
	SHAMAN = { Elemental = 1, Enhancement = 2, EnhancementTank = 2, Restoration = 3 },
}

function PawnLink.PawnSpec(classFile, spec)
	if PAWN_SPECS[classFile] then return PAWN_SPECS[classFile][spec] end
	local data = ns.GEAR_WEIGHTS[classFile]
	for index, key in ipairs(data and data.order or {}) do
		if key == spec then return index end
	end
	return nil
end

-- A scale's weights as the journal names its stats, copied; false where it has none the journal knows.
local function WeightsOf(name)
	if weightsOf[name] == nil then
		local values = Call(PawnGetAllStatValues, name)
		local copy = {}
		for stat, value in pairs(type(values) == "table" and values or {}) do copy[stat] = value end
		weightsOf[name] = ns.ItemScore.FromPawnValues(copy) or false
	end
	return weightsOf[name]
end

--[[
	How well a scale fits a spec of the player's class; the higher, the better. In order:
	  - not for another class, nor for another spec;
	  - the player's own before Pawn's starter scales: on Forever these hold one template for the
	    whole class, and a scale the player imported or made has no spec here (one copied keeps it);
	  - for the class, then for the spec.
]]
local function Fit(scale, classID, pawnSpec)
	local forClass = scale.ClassID == classID
	local forSpec = forClass and pawnSpec ~= nil and scale.SpecID == pawnSpec
	local fit = 0
	if scale.ClassID == nil or forClass then fit = fit + 16 end
	if scale.SpecID == nil or forSpec then fit = fit + 8 end
	if scale.Provider == nil then fit = fit + 4 end
	if forClass then fit = fit + 2 end
	if forSpec then fit = fit + 1 end
	return fit
end

--[[
	Pawn's scale for a spec of the player's class: of the scales shown for this character with weights
	the journal can read (not the journal's own, nor one a provider no longer loaded left behind, nor
	a new one still empty), the one that fits it best, and the first by name of those, so the choice
	does not change between sessions. Its name and its name as Pawn shows it.
]]
function PawnLink:ScaleFor(spec)
	local scales = type(PawnCommon) == "table" and type(PawnCommon.Scales) == "table" and PawnCommon.Scales
	if not scales or not self:Present() then return nil end
	if scaleOf[spec] == nil then
		local _, classFile, classID = UnitClass("player")
		local pawnSpec = PawnLink.PawnSpec(classFile, spec)
		local best, bestFit
		for name, scale in pairs(scales) do
			if type(scale) == "table" and type(scale.PerCharacterOptions) == "table"
				and scale.Provider ~= PROVIDER and (scale.Provider == nil or scale.ProviderActive)
				and Call(PawnIsScaleVisible, name) == true and WeightsOf(name) then
				local fit = Fit(scale, classID, pawnSpec)
				if not bestFit or fit > bestFit or (fit == bestFit and name < best) then
					best, bestFit = name, fit
				end
			end
		end
		scaleOf[spec] = best or false
	end
	local best = scaleOf[spec]
	if not best or not scales[best] then return nil end
	return best, scales[best].LocalizedName or best
end

-- The weights of Pawn's scale for a spec, as the journal names its stats; nil without one.
function PawnLink:Weights(spec)
	local name = self:ScaleFor(spec)
	return name and WeightsOf(name) or nil
end

------------------------------------------------------------------------------------------
-- The journal's scales in Pawn
------------------------------------------------------------------------------------------

-- The name Pawn knows a scale of the journal's by: "AegisJournal":<spec>.
function PawnLink.OwnScaleName(spec)
	return Call(PawnGetProviderScaleName, PROVIDER, spec) or ('"' .. PROVIDER .. '":' .. spec)
end

local function Shown(name)
	local scale = PawnCommon.Scales[name]
	return type(scale) == "table" and type(scale.PerCharacterOptions) == "table" and Call(PawnIsScaleVisible, name) == true
end

local function Show(name, shown)
	if type(PawnCommon.Scales[name]) == "table" and Shown(name) ~= shown then Call(PawnSetScaleVisible, name, shown) end
end

-- Whether the journal's weights are wanted in tooltips (its "Show stat weights in tooltips" box).
local function ShowsLines()
	return not (ns.GearPanel and ns.GearPanel.ShowsGains) or ns.GearPanel.ShowsGains() == true
end

--[[
	Which scales Pawn shows on this character. With the journal's weights: the journal's for the spec
	the Gear Finder scores for, unless the journal's weights are not wanted in tooltips, and none of
	Pawn's own: those shown are hidden once and remembered (charDB.pawnHidden), so a scale the player
	shows again in Pawn afterwards stays shown. Otherwise none of the journal's, and Pawn's hidden ones
	are shown again.
]]
local function ShowScales(spec)
	local journal = PawnLink:Source() == "journal"
	if journal and ns.charDB.pawnHidden == nil then
		local hidden = {}
		for name, scale in pairs(PawnCommon.Scales) do
			if type(scale) == "table" and scale.Provider ~= PROVIDER and Shown(name) then hidden[#hidden + 1] = name end
		end
		table.sort(hidden)
		ns.charDB.pawnHidden = hidden
		for _, name in ipairs(hidden) do Show(name, false) end
	elseif not journal and ns.charDB.pawnHidden then
		for _, name in ipairs(ns.charDB.pawnHidden) do Show(name, true) end
		ns.charDB.pawnHidden = nil
	end
	for _, entry in ipairs(ns.ItemScore:Specs()) do
		Show(PawnLink.OwnScaleName(entry.key), journal and entry.key == spec and ShowsLines())
	end
end

--[[
	Give Pawn the journal's scales: one for each spec of the player's class, with the weights the
	journal has for it, in Pawn's stat names (ItemScore.ToPawnValues), then show the right ones.
	Pawn adds a provider's scale again each session, and overwrites it when given it again; a changed
	scale is read anew as Pawn does for its own (its total, best items, tooltips and bag arrows). Only
	when the weights, the spec or the choice changed since last time.
]]
local registered = false

local function PushNow(spec, specs, values)
	for _, entry in ipairs(specs) do
		local name = PawnLink.OwnScaleName(entry.key)
		Call(PawnAddPluginScale, PROVIDER, entry.key, string.format(L.PAWN_SCALE, entry.label), COLOR, values[entry.key])
		Call(PawnRecalculateScaleTotal, name)
		Call(PawnInvalidateBestItemsForScale, name)
	end
	ShowScales(spec)
	Call(PawnResetTooltips)
	Call(PawnResetBags)
end

function PawnLink:Push()
	if pushing or not (registered and ns.charDB and self:Present()) then return end
	local IS = ns.ItemScore
	local spec, specs = IS:Spec(), IS:Specs()
	local values, parts = {}, { tostring(self:Source()), tostring(spec), tostring(ShowsLines()) }
	for _, entry in ipairs(specs) do
		values[entry.key] = IS.ToPawnValues(IS:OwnWeights(entry.key))
		local stats = {}
		for stat in pairs(values[entry.key]) do stats[#stats + 1] = stat end
		table.sort(stats)
		parts[#parts + 1] = entry.key .. "|" .. entry.label
		for _, stat in ipairs(stats) do parts[#parts + 1] = stat .. "=" .. values[entry.key][stat] end
	end
	local signature = table.concat(parts, ";")
	if signature == pushed then return end
	pushing = true
	local ok = pcall(PushNow, spec, specs, values)
	pushing = false
	if ok then pushed = signature end
end

-- The journal as one of Pawn's scale providers; Pawn calls back for the scales.
function PawnLink:Register()
	if registered or not self:Present() or type(PawnAddPluginScaleProvider) ~= "function" then return end
	registered = true
	Call(PawnAddPluginScaleProvider, PROVIDER, L.OPTIONS_TITLE, function() PawnLink:Push() end)
	self:Push()
end

------------------------------------------------------------------------------------------
-- The question
------------------------------------------------------------------------------------------

-- Asked once, when Pawn is there and the player has not chosen.
StaticPopupDialogs[POPUP] = {
	text = L.PAWN_ASK,
	button1 = L.PAWN_USE_JOURNAL,
	button2 = L.PAWN_USE_PAWN,
	OnAccept = function() PawnLink:SetSource("journal") end,
	OnCancel = function(_, _, reason)
		-- Closed some other way: asked again next time.
		if reason == "clicked" then PawnLink:SetSource("pawn") end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	-- Escape only puts the question off: the client would tell OnCancel it was the second button.
	noCancelOnEscape = true,
}

function PawnLink:Check()
	if self:Present() and self:Source() == nil then StaticPopup_Show(POPUP) end
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function()
	-- Pawn set itself up at the same event, first (the journal loads after it).
	PawnLink:Register()
	ns.ItemScore:OnChange(function() PawnLink:Push() end)
	C_Timer.After(1, function() PawnLink:Check() end)
end)
