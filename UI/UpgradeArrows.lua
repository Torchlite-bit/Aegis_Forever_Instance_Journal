local _, ns = ...

--[[
	Green arrows on upgrades: an item that is an upgrade for the player, by the Gear Finder's spec and
	weights and as the item tooltips count one (UI/ItemTooltip.lua), is marked with the bags' own
	green arrow at its top left: in the bags, in the loot window and on a group loot roll.

	Each arrow is the journal's own texture on Blizzard's button, kept in a table of the journal's:
	nothing of Blizzard's is changed or written to. Followed through Blizzard's own functions,
	hooked, not replaced: each bag frame's UpdateItems; the loot window's item rows' Init, which
	runs for every row shown, a row the list takes back for another slot as it scrolls too; and
	GroupLootFrame_SetupItemDisplay, which sets up a roll's item on the roll frames and on the
	gamepad's roll cards alike. In Baganator's bags, the arrow is a corner widget of the journal's,
	through Baganator's own API (Baganator.API.RegisterCornerWidget). Shown unless the player turns
	them off in the journal's options; while Pawn is installed and enabled, its arrows are the ones
	shown, and these stand aside (Core/PawnLink.lua).
]]

local UpgradeArrows = {}
ns.UpgradeArrows = UpgradeArrows

local ATLAS = "bags-greenarrow"
local FALLBACK = "Interface\\Buttons\\UI-MicroStream-Green"
local LOOT_ITEM = Enum and Enum.LootSlotType and Enum.LootSlotType.Item or LOOT_SLOT_ITEM or 1

local arrows = setmetatable({}, { __mode = "k" })
local bagFrames, rollFrames = {}, {}

function UpgradeArrows.Shows()
	return not (ns.db and ns.db.hideUpgradeArrows)
end

function UpgradeArrows.SetShows(shown)
	ns.db.hideUpgradeArrows = not shown or nil
	UpgradeArrows:Refresh()
end

-- The arrow on a button, made the first time one is needed, where the bags' own sits: its top
-- left, at its sublevel, under the cover a bag search lays on what does not match. The junk coin
-- a vendor shows on grey items is there too, above it: then the arrow takes the top right.
local function Arrow(button)
	local arrow = arrows[button]
	if not arrow then
		arrow = button:CreateTexture(nil, "OVERLAY", nil, 1)
		if ns.AtlasExists(ATLAS) then
			arrow:SetAtlas(ATLAS, true)
		else
			arrow:SetTexture(FALLBACK)
			arrow:SetSize(16, 16)
		end
		arrow:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
		arrows[button] = arrow
	end
	return arrow
end

function UpgradeArrows:Mark(button, link)
	if not button then return end
	local upgrade = type(link) == "string" and not ns.IsSecret(link) and ns.charDB ~= nil and UpgradeArrows.Shows()
		and not ns.PawnLink:Present() and ns.ItemTooltip:IsUpgrade(link)
	if upgrade then
		local arrow = Arrow(button)
		local junk = button.JunkIcon
		local corner = type(junk) == "table" and junk.IsShown and junk:IsShown() and "TOPRIGHT" or "TOPLEFT"
		arrow:ClearAllPoints()
		arrow:SetPoint(corner, button, corner, 0, 0)
		arrow:Show()
	elseif arrows[button] then
		arrows[button]:Hide()
	end
end

function UpgradeArrows:Marked(button)
	return arrows[button] ~= nil and arrows[button]:IsShown()
end

function UpgradeArrows:ArrowOf(button)
	return arrows[button]
end

-- A bag frame's items, after Blizzard has drawn them.
local function MarkBag(frame)
	if not frame:IsShown() then return end
	for _, button in frame:EnumerateValidItems() do
		local bag, slot = button:GetBagID(), button:GetID()
		UpgradeArrows:Mark(button, bag and C_Container.GetContainerItemLink(bag, slot))
	end
end

-- A loot window row: its item button and the loot slot it shows now.
local function MarkLootRow(row)
	local slot = row.GetSlotIndex and row:GetSlotIndex()
	local isItem = slot and GetLootSlotType(slot) == LOOT_ITEM
	UpgradeArrows:Mark(row.Item, isItem and GetLootSlotLink(slot) or nil)
end

local function MarkLoot()
	local scrollBox = LootFrame and LootFrame:IsShown() and LootFrame.ScrollBox
	if scrollBox and scrollBox.ForEachFrame then scrollBox:ForEachFrame(MarkLootRow) end
end

local function MarkRoll(frame)
	UpgradeArrows:Mark(frame.IconFrame, frame.rollID and GetLootRollItemLink(frame.rollID) or nil)
end

--[[
	Baganator's bags: an item button's corner shows the arrow when this says so. True or false, or
	nil while the client has not described the item yet (Baganator asks again). Only gear. It goes
	in the top right, which Baganator leaves empty: Baganator draws one widget a corner, and the top
	left holds the junk coin and the item level (the player can move it in Baganator's settings).
]]
local BAGANATOR_WIDGET = "aegis_journal_upgrade"
local ARMOR, WEAPON = 4, 2

function UpgradeArrows.BaganatorShows(itemLink)
	if type(itemLink) ~= "string" or ns.IsSecret(itemLink) or not ns.charDB then return false end
	if not UpgradeArrows.Shows() or ns.PawnLink:Present() then return false end
	local classID = select(6, C_Item.GetItemInfoInstant(itemLink))
	if classID ~= ARMOR and classID ~= WEAPON then return false end
	if not ns.ItemScore:Read(itemLink) then return nil end
	return ns.ItemTooltip:IsUpgrade(itemLink) == true
end

function UpgradeArrows:HookBaganator()
	local api = type(Baganator) == "table" and type(Baganator.API) == "table" and Baganator.API
	if self.baganator or not (api and api.RegisterCornerWidget) then return end
	self.baganator = api
	local ok = pcall(api.RegisterCornerWidget, ns.L.OPTIONS_TITLE, BAGANATOR_WIDGET,
		function(_, details) return UpgradeArrows.BaganatorShows(details and details.itemLink) end,
		function(itemButton)
			local arrow = itemButton:CreateTexture(nil, "OVERLAY")
			if ns.AtlasExists(ATLAS) then
				arrow:SetAtlas(ATLAS, true)
			else
				arrow:SetTexture(FALLBACK)
				arrow:SetSize(16, 16)
			end
			return arrow
		end,
		{ corner = "top_right", priority = 1 })
	if not ok then self.baganator = nil end
end

--[[
	Baganator draws its buttons' corners again: only while the arrow is in one of them and could
	show (not while Pawn's are shown), and only the corners, not the bags' whole layout.
]]
local function RefreshBaganator(api)
	if not (api and api.RequestItemButtonsRefresh) or ns.PawnLink:Present() then return end
	if api.IsCornerWidgetActive then
		local ok, active = pcall(api.IsCornerWidgetActive, BAGANATOR_WIDGET)
		if ok and not active then return end
	end
	local constants = type(Baganator) == "table" and Baganator.Constants
	local reasons = type(constants) == "table" and type(constants.RefreshReason) == "table" and constants.RefreshReason
	pcall(api.RequestItemButtonsRefresh, reasons and reasons.ItemWidgets and { reasons.ItemWidgets } or nil)
end

-- Everything showing again: a change of gear, spec or weights, or the option.
function UpgradeArrows:Refresh()
	RefreshBaganator(self.baganator)
	for _, frame in ipairs(bagFrames) do MarkBag(frame) end
	MarkLoot()
	for _, frame in ipairs(rollFrames) do
		if frame:IsShown() then MarkRoll(frame) end
	end
	local cards = GamepadGroupLootRollFrame and GamepadGroupLootRollFrame:IsShown() and GamepadGroupLootRollFrame.ScrollBox
	if cards and cards.ForEachFrame then cards:ForEachFrame(MarkRoll) end
end

-- The loot window's item rows take their mixin's Init when made: hooked before any is.
if LootFrameItemElementMixin and LootFrameItemElementMixin.Init then
	hooksecurefunc(LootFrameItemElementMixin, "Init", MarkLootRow)
end

function UpgradeArrows:Hook()
	if self.hooked then return end
	self.hooked = true
	local frames = { ContainerFrameCombinedBags }
	for index = 1, NUM_CONTAINER_FRAMES or 13 do frames[#frames + 1] = _G["ContainerFrame" .. index] end
	for _, frame in ipairs(frames) do
		if type(frame) == "table" and frame.UpdateItems and frame.EnumerateValidItems then
			hooksecurefunc(frame, "UpdateItems", MarkBag)
			bagFrames[#bagFrames + 1] = frame
		end
	end
	-- A roll's item is set up by one function for the roll frames and the gamepad's cards.
	local rollHooked = type(GroupLootFrame_SetupItemDisplay) == "function"
	if rollHooked then hooksecurefunc("GroupLootFrame_SetupItemDisplay", MarkRoll) end
	for index = 1, NUM_GROUP_LOOT_FRAMES or 4 do
		local frame = _G["GroupLootFrame" .. index]
		if type(frame) == "table" and frame.HookScript then
			if not rollHooked then frame:HookScript("OnShow", MarkRoll) end
			rollFrames[#rollFrames + 1] = frame
		end
	end
	self:HookBaganator()
	ns.ItemScore:OnChange(function() UpgradeArrows:Refresh() end)
end

local events = CreateFrame("Frame")
UpgradeArrows.events = events
ns.RegisterEvents(events, "PLAYER_LOGIN", "LOOT_OPENED", "LOOT_SLOT_CHANGED", "LOOT_SLOT_CLEARED")
events:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		UpgradeArrows:Hook()
	else
		-- After the loot window has drawn its rows for the loot.
		C_Timer.After(0, MarkLoot)
	end
end)
