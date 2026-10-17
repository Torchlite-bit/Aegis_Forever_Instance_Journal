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

local hooked, weightsOf = false, {}

-- Pawn's scales or settings changed: its weights are read again, and the journal scores anew.
local function PawnChanged()
	wipe(weightsOf)
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
	ns.ItemScore:Changed()
	if Settings and Settings.NotifyUpdate then pcall(Settings.NotifyUpdate, "AEGIS_JOURNAL_PAWN_WEIGHTS") end
end

-- Whether the Gear Finder scores with Pawn's weights now.
function PawnLink:UsesWeights()
	return self:Source() == "pawn" and self:Present()
end

--[[
	Pawn's scale for a spec of the player's class: a scale shown for this character that is for the
	class and the spec (Pawn numbers a class's specs in the order the journal lists them), else one
	shown for the class, else any shown. Its name and its name as Pawn shows it.
]]
function PawnLink:ScaleFor(spec)
	local scales = type(PawnCommon) == "table" and type(PawnCommon.Scales) == "table" and PawnCommon.Scales
	if not scales or not self:Present() then return nil end
	local _, classFile, classID = UnitClass("player")
	local data = ns.GEAR_WEIGHTS[classFile]
	local specIndex
	for index, key in ipairs(data and data.order or {}) do
		if key == spec then specIndex = index end
	end
	local best, bestRank
	for name, scale in pairs(scales) do
		if type(scale) == "table" and Call(PawnIsScaleVisible, name) == true then
			local forClass = scale.ClassID == classID
			local rank = (forClass and specIndex and scale.SpecID == specIndex and 3) or (forClass and 2) or 1
			-- The same rank: the first by name, so the choice does not change between sessions.
			if not bestRank or rank > bestRank or (rank == bestRank and name < best) then
				best, bestRank = name, rank
			end
		end
	end
	if not best then return nil end
	return best, scales[best].LocalizedName or best
end

-- The weights of Pawn's scale for a spec, as the journal names its stats; nil without one.
function PawnLink:Weights(spec)
	local name = self:ScaleFor(spec)
	if not name then return nil end
	if weightsOf[name] == nil then
		local values = Call(PawnGetAllStatValues, name)
		local copy = {}
		for stat, value in pairs(type(values) == "table" and values or {}) do copy[stat] = value end
		weightsOf[name] = ns.ItemScore.FromPawnValues(copy) or false
	end
	return weightsOf[name] or nil
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
