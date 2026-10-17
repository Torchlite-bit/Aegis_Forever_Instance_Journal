local _, ns = ...
local L = ns.L

--[[
	Working with Pawn, where it is installed and enabled.

	While Pawn is there, its own item tooltips and upgrade arrows are the ones shown: the journal's
	(UI/ItemTooltip.lua, UI/UpgradeArrows.lua) stand aside, so an item never carries two. The player
	is asked once which stat weights the Gear Finder should score with, Pawn's or the journal's own,
	and can change that in the journal's options. With Pawn's, the Gear Finder takes the weights of
	Pawn's scale for the spec it scores for, read through Pawn's own functions (PawnIsReady,
	PawnCommon.Scales, PawnIsScaleVisible, PawnGetAllStatValues) and named as the journal names its
	stats (ItemScore.FromPawnValues); nothing of Pawn's is changed.

	Without Pawn, the journal's own weights, tooltips and arrows are used, as before.
]]

local PawnLink = {}
ns.PawnLink = PawnLink

local POPUP = "AEGIS_JOURNAL_WEIGHTS_SOURCE"

-- A call into Pawn that cannot break the journal: Pawn reports its own errors in chat.
local function Call(fn, ...)
	if type(fn) ~= "function" then return nil end
	local ok, a, b = pcall(fn, ...)
	if ok then return a, b end
	return nil
end

local hooked, weightsOf, scaleOf = false, {}, {}

-- Pawn's scales or settings changed: its weights are read again, and the journal scores anew.
local function PawnChanged()
	wipe(weightsOf)
	wipe(scaleOf)
	if PawnLink:UsesWeights() then ns.ItemScore:Changed() end
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

function PawnLink:SetSource(source)
	ns.db.weightsSource = source
	wipe(weightsOf)
	wipe(scaleOf)
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
	the journal can read (not one a provider no longer loaded left behind, nor a new one still
	empty), the one that fits it best, and the first by name of those, so the choice does not change
	between sessions. Its name and its name as Pawn shows it.
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
				and (scale.Provider == nil or scale.ProviderActive)
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

-- Asked once, when Pawn is there and the player has not chosen.
StaticPopupDialogs[POPUP] = {
	text = L.PAWN_ASK,
	button1 = L.PAWN_USE_PAWN,
	button2 = L.PAWN_USE_JOURNAL,
	OnAccept = function() PawnLink:SetSource("pawn") end,
	OnCancel = function(_, _, reason)
		-- Closed some other way: asked again next time.
		if reason == "clicked" then PawnLink:SetSource("journal") end
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
	-- After Pawn has set itself up, on the same login.
	C_Timer.After(1, function() PawnLink:Check() end)
end)
