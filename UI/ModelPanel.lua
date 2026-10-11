local _, ns = ...

--[[
	The boss's model on the right page, as retail's Model tab shows it (the encounter frame's
	ModelFrame in Blizzard_EncounterJournal.xml): the creature standing on the page itself, the
	creature's name in the shadow along the bottom, and a round button for each creature of the
	fight down the left side. Retail's framed backdrop is left out, as the player asked.

	Retail draws it in a ModelScene set up from the encounter journal's own data, which Forever
	does not ship. A PlayerModel shows a creature from its display id alone, the same id the boss
	list's portraits use. Dragging turns the creature (the mouse is followed only while a button
	is held), and the mouse wheel zooms.
]]

local ModelPanel = {}
ns.ModelPanel = ModelPanel

local WIDTH, HEIGHT = 390, 423
local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
-- How far the creature turns per pixel dragged, and where it starts: turned a little, as
-- retail's scenes show them.
local TURN_PER_PIXEL, START_FACING = 0.02, 0.35
local ZOOM_STEP, ZOOM_MIN, ZOOM_MAX = 0.1, 0.5, 1.6
-- Retail's creature button: larger while its creature shows.
local BUTTON_SIZES = { shown = { 64, 61, 40 }, other = { 50, 49, 36 } }

-- The creatures of a boss's fight the client can draw: the boss, then its adds, each with a display id.
function ModelPanel:Creatures(boss)
	local list = {}
	if not boss then return list end
	if boss.displayID then list[#list + 1] = { name = boss.name, displayID = boss.displayID } end
	for _, add in ipairs(boss.adds or {}) do
		if add.displayID then list[#list + 1] = { name = add.name, displayID = add.displayID } end
	end
	return list
end

------------------------------------------------------------------------------------------
-- Turning and zooming
------------------------------------------------------------------------------------------

local function Turn(model)
	local x = GetCursorPosition()
	model:SetFacing(model.dragFacing + (x - model.dragX) * TURN_PER_PIXEL)
end

local function StopTurning(model)
	model:SetScript("OnUpdate", nil)
end

local function CreateModel(panel)
	local model = CreateFrame("PlayerModel", nil, panel)
	model:SetPoint("TOPLEFT", 6, -6)
	model:SetPoint("BOTTOMRIGHT", -6, 6)
	model:EnableMouse(true)
	model:EnableMouseWheel(true)
	model:SetScript("OnMouseDown", function(self, button)
		if button ~= "LeftButton" then return end
		self.dragX, self.dragFacing = GetCursorPosition(), self:GetFacing() or START_FACING
		self:SetScript("OnUpdate", Turn)
	end)
	model:SetScript("OnMouseUp", StopTurning)
	model:SetScript("OnHide", StopTurning)
	model:SetScript("OnMouseWheel", function(self, delta)
		self.zoom = math.min(ZOOM_MAX, math.max(ZOOM_MIN, (self.zoom or 1) - delta * ZOOM_STEP))
		self:SetCamDistanceScale(self.zoom)
	end)
	return model
end

------------------------------------------------------------------------------------------
-- Creature buttons
------------------------------------------------------------------------------------------

local function SizeButton(button, shown)
	local size = shown and BUTTON_SIZES.shown or BUTTON_SIZES.other
	button:SetSize(size[1], size[2])
	button.Creature:SetSize(size[3], size[3])
end

local function CreatureButton(panel, index)
	local button = panel.Buttons[index]
	if button then return button end
	button = CreateFrame("Button", nil, panel.Front)
	button:SetFrameLevel(panel.Front:GetFrameLevel() + 2)
	ns.SetButtonArt(button, "BossModelButton", nil, "BossModelButton")
	button.Creature = button:CreateTexture(nil, "BACKGROUND", nil, 6)
	button.Creature:SetPoint("CENTER")
	if button.CreateMaskTexture and button.Creature.AddMaskTexture then
		local mask = button:CreateMaskTexture()
		mask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(button.Creature)
		button.Creature:AddMaskTexture(mask)
	end
	if index == 1 then
		button:SetPoint("TOPLEFT", panel, "TOPLEFT", 3, -35)
	else
		button:SetPoint("TOPLEFT", panel.Buttons[index - 1], "BOTTOMLEFT", 0, 8)
	end
	button:SetScript("OnClick", function(self)
		ns.PlaySoundKit("IG_MAINMENU_OPTION")
		ModelPanel:ShowCreature(panel, self.creature)
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.creature.name, 1, 1, 1)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	panel.Buttons[index] = button
	return button
end

------------------------------------------------------------------------------------------
-- The panel
------------------------------------------------------------------------------------------

function ModelPanel:Create(page, info)
	local panel = CreateFrame("Frame", nil, info)
	panel:SetSize(WIDTH, HEIGHT)
	panel:SetPoint("BOTTOMRIGHT", -3, 1)
	panel:Hide()
	panel.Buttons = {}

	panel.Model = CreateModel(panel)

	-- In front of the creature: the name and the buttons.
	panel.Front = CreateFrame("Frame", nil, panel)
	panel.Front:SetAllPoints()
	panel.Front:SetFrameLevel(panel.Model:GetFrameLevel() + 5)
	panel.TitleShadow = panel.Front:CreateTexture(nil, "OVERLAY", nil, 1)
	ns.Art(panel.TitleShadow, "BossNameShadow")
	panel.TitleShadow:SetPoint("BOTTOM", 0, -2)
	panel.Title = panel.Front:CreateFontString(nil, "OVERLAY", ns.Font("QuestTitleFontBlackShadow", "GameFontNormalLarge"))
	panel.Title:SetSize(380, 10)
	panel.Title:SetPoint("BOTTOM", 0, 6)
	panel.Title:SetJustifyH("CENTER")
	return panel
end

-- Shows one creature of the fight, its button larger than the others.
function ModelPanel:ShowCreature(panel, creature)
	local model = panel.Model
	model:ClearModel()
	model:SetDisplayInfo(creature.displayID)
	model:SetFacing(START_FACING)
	model.zoom = 1
	model:SetCamDistanceScale(1)
	panel.Title:SetText(creature.name)
	panel.creature = creature
	for _, button in ipairs(panel.Buttons) do
		local shown = button.creature == creature
		SizeButton(button, shown)
		button:SetEnabled(not shown)
	end
end

-- Fills the panel for a boss: a button per creature of its fight, the boss shown first. The
-- same boss again keeps the creature the reader was looking at.
function ModelPanel:Refresh(panel, boss)
	local creatures = self:Creatures(boss)
	if panel.boss == boss and panel.creature then return end
	panel.boss = boss
	for index, creature in ipairs(creatures) do
		local button = CreatureButton(panel, index)
		button.creature = creature
		local drawn = type(SetPortraitTextureFromCreatureDisplayID) == "function"
			and pcall(SetPortraitTextureFromCreatureDisplayID, button.Creature, creature.displayID)
		if not drawn then button.Creature:SetColorTexture(0.1, 0.07, 0.04, 1) end
		button:Show()
	end
	for index = #creatures + 1, #panel.Buttons do panel.Buttons[index]:Hide() end
	panel.creature = nil
	if creatures[1] then self:ShowCreature(panel, creatures[1]) end
end
