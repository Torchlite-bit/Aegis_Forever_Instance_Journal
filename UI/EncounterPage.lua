local _, ns = ...
local L = ns.L

--[[
	An instance's open book: the boss list on the left page, the side tabs on the right edge,
	and the right page showing the selected tab. Frame names, sizes and anchors follow the
	encounter frame in Blizzard_EncounterJournal.xml (EncounterJournal.encounter).

	The right page shows:
	  Overview, no boss chosen   the instance's picture, name and lore (retail's instance frame)
	  Overview, a boss chosen    the boss's description and an Overview section of bullets
	  Loot, Abilities, Model     their panels (UI/LootPanel.lua, UI/AbilitiesPanel.lua, UI/ModelPanel.lua)
	  Quests                     both pages (UI/QuestsPanel.lua)
]]

local EncounterPage = {}
ns.EncounterPage = EncounterPage

-- Retail's four tabs in its order, then the journal's own Quests tab.
local TAB_OVERVIEW, TAB_LOOT, TAB_ABILITIES, TAB_MODEL, TAB_QUESTS = 1, 2, 3, 4, 5

local SIDE_TABS = {
	{ id = TAB_OVERVIEW, tooltip = L.TAB_OVERVIEW, selected = "Tab-BossIcon-Selected", unselected = "Tab-BossIcon-UnSelected" },
	{ id = TAB_LOOT, tooltip = L.TAB_LOOT, selected = "Tab-LootIcon-Selected", unselected = "Tab-LootIcon-UnSelected" },
	{ id = TAB_ABILITIES, tooltip = L.TAB_ABILITIES, selected = "Tab-AbilitiesIcon-Selected", unselected = "Tab-AbilitiesIcon-UnSelected" },
	{ id = TAB_MODEL, tooltip = L.TAB_MODEL, selected = "Tab-ModelIcon-Selected", unselected = "Tab-ModelIcon-UnSelected" },
	-- Retail has no quest tab; its icon is the client's own quest-giver "!".
	{ id = TAB_QUESTS, tooltip = L.TAB_QUESTS, atlas = "QuestNormal" },
}

-- Text for a tab whose page is not built yet; every tab has its page now.
local PLACEHOLDERS = {}

local BOOK = "Interface\\EncounterJournal\\UI-EJ-JournalBG"
local BOOK_COORDS = { 0, 0.766601562, 0, 0.830078125 }
local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local DEFAULT_BOSS = "Interface\\EncounterJournal\\UI-EJ-BOSS-Default"
local REACHED_ICON = "Interface\\Buttons\\UI-CheckBox-Check"
local STATUS_BAR = "Interface\\TargetingFrame\\UI-StatusBar"
local STANDING_BAR_TEMPLATE = "ColoredProgressBarTemplate"
local MAP_BUTTON = "Interface\\QuestFrame\\UI-QuestMap_Button"
local BOSS_NAME_COLOR = { 0.827, 0.659, 0.463 }
-- The "not yet tested" note on a placeholder dungeon's overview: a dark red that reads on the lore box.
local UNTESTED_COLOR = "|cff8c1a1a"
-- "New in WoW: Forever" on the overview: a deep blue, which stands out from the parchment
-- (a gold one sank into it).
local FOREVER_COLOR = "|cff123a6e"

-- The top padding leaves room for the first portrait's circle, which stands a little taller than its plate.
local BOSS_BUTTON_HEIGHT, BOSS_SPACING, BOSS_TOP_PADDING, BOSS_BOTTOM_PADDING = 55, 15, 6, 20

-- Crops of a Forever loading screen: square for the round icon, wide for the lore picture.
local ICON_COORDS = { 0.32, 0.68, 0.15, 0.85 }
local BUTTON_IMAGE_ICON_COORDS = { 0.156, 0.527, 0, 0.742 }
local LORE_COORDS = { 0.20, 0.80, 0.15, 0.85 }
local FACTION_CREST_COORDS = { 0.07, 0.93, 0.07, 0.93 }
local FALLBACK_ART = "Interface\\EncounterJournal\\UI-EJ-LOREBG-Default"

------------------------------------------------------------------------------------------
-- Small helpers
------------------------------------------------------------------------------------------

local function SetColor(fontString, color)
	fontString:SetTextColor(color[1], color[2], color[3])
end

local function ParchmentText(parent, width)
	local text = parent:CreateFontString(nil, "ARTWORK", "GameFontBlack")
	text:SetWidth(width)
	text:SetJustifyH("LEFT")
	SetColor(text, ns.PARCHMENT_TEXT_COLOR)
	return text
end

local function SetCroppedArt(texture, art, coords)
	texture:SetTexture(art or FALLBACK_ART)
	if art then
		texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
	else
		texture:SetTexCoord(0, 1, 0, 1)
	end
end

-- Rounds a texture with a separate mask object, as Blizzard's creature buttons do. The older
-- texture:SetMask would forbid the crop (SetTexCoord) the dungeon icon needs. shape, when given,
-- is the region the circle fills, for a texture larger than its circle.
local function Masked(owner, texture, shape)
	if owner.CreateMaskTexture and texture.AddMaskTexture then
		local mask = owner:CreateMaskTexture()
		mask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(shape or texture)
		texture:AddMaskTexture(mask)
		texture.CircleMask = mask
	end
	return texture
end

local function BreakUp(value)
	if type(BreakUpLargeNumbers) == "function" then
		local ok, text = pcall(BreakUpLargeNumbers, value)
		if ok and text then return text end
	end
	return tostring(value)
end

-- The bosses listed: not the trash, nor a creature listed only for loot that is hidden until
-- confirmed (Core/Items.lua).
local function BossesOf(instance)
	local list = {}
	for _, boss in ipairs(instance.bosses) do
		if not boss.trash and not ns.Items:HidesBoss(boss) then list[#list + 1] = boss end
	end
	return list
end

local function NameList(rows, limit)
	local names = {}
	for index, row in ipairs(rows) do
		if index > limit then
			names[#names + 1] = string.format(L.AND_MORE, #rows - limit)
			break
		end
		names[#names + 1] = row.name or "?"
	end
	return table.concat(names, ", ")
end

------------------------------------------------------------------------------------------
-- Left page: instance header and boss list
------------------------------------------------------------------------------------------

--[[
	A boss's portrait is a full circle that starts the button, ringed like the faction cards'
	crests: a gold band, then a thin dark edge. PORTRAIT gives its centre (from the button's left
	edge, on the plate's middle), the portrait's radius and the band's width.

	The plate starts behind the circle, so nothing of it shows to the portrait's left. Its own
	round cap, made for retail's pictures, is left off: the plate's art is taken from PLATE.from
	(measured on an in-game screenshot, where the cap's dark hollow ends) and drawn from PLATE.at,
	where the circle covers its cut end top to bottom. The rest of the plate is stretched a tenth
	to make up the length.
]]
local PORTRAIT = { x = 33.5, radius = 27, band = 3 }
local PLATE = { width = 325, from = 72, at = 45, art = { "BossButton-Up", "BossButton-Down", "BossButton-Highlight" } }
local RIM_DARK, RIM_LIGHT = { 0.50, 0.34, 0.10 }, { 1, 0.88, 0.52 }

-- The plate's normal, pushed and highlight art without its cap.
local function DropPlateCap(button)
	local textures = { button:GetNormalTexture(), button:GetPushedTexture(), button:GetHighlightTexture() }
	for index, texture in ipairs(textures) do
		local left, right, top, bottom = ns.ArtCoords(PLATE.art[index])
		texture:SetTexCoord(left + (right - left) * PLATE.from / PLATE.width, right, top, bottom)
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", PLATE.at, 0)
		texture:SetPoint("BOTTOMRIGHT")
	end
end

-- A circle of the given radius, centred on the portrait.
local function PortraitCircle(button, holder, subLevel, radius)
	local texture = Masked(holder, holder:CreateTexture(nil, "ARTWORK", nil, subLevel))
	texture:SetSize(radius * 2, radius * 2)
	texture:SetPoint("CENTER", button, "LEFT", PORTRAIT.x, 0)
	return texture
end

local function CreateBossButton(parent)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(325, BOSS_BUTTON_HEIGHT)
	ns.SetButtonArt(button, "BossButton-Up", "BossButton-Down", "BossButton-Highlight")
	DropPlateCap(button)

	-- The creature's own portrait, where the client knows its model; otherwise Blizzard's
	-- default boss picture in the same circle, its figure's shoulders on the circle's foot.
	local holder = CreateFrame("Frame", nil, button)
	holder:SetAllPoints()
	button.Rim = PortraitCircle(button, holder, 1, PORTRAIT.radius + PORTRAIT.band + 1)
	ns.Gradient(button.Rim, "VERTICAL", RIM_DARK, 1, 1, RIM_LIGHT)
	button.Edge = PortraitCircle(button, holder, 2, PORTRAIT.radius + 1)
	button.Edge:SetColorTexture(0.1, 0.07, 0.03, 1)
	button.Portrait = PortraitCircle(button, holder, 3, PORTRAIT.radius)
	button.DefaultArt = Masked(holder, holder:CreateTexture(nil, "ARTWORK", nil, 4), button.Portrait)
	button.DefaultArt:SetTexture(DEFAULT_BOSS)
	button.DefaultArt:SetSize(128, 64)
	button.DefaultArt:SetPoint("BOTTOMLEFT", button, "LEFT", PORTRAIT.x - 37.5, -PORTRAIT.radius)

	button.Name = button:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalMed3", "GameFontNormal"))
	button.Name:SetJustifyH("LEFT")
	SetColor(button.Name, BOSS_NAME_COLOR)

	-- A faction's standings say how many rewards each holds, and tick the ones reached.
	button.Detail = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	button.Detail:SetPoint("LEFT", 105, -11)
	button.Detail:SetJustifyH("LEFT")
	button.Detail:SetTextColor(0.75, 0.68, 0.58)
	button.Reached = button:CreateTexture(nil, "OVERLAY", nil, 7)
	button.Reached:SetTexture(REACHED_ICON)
	button.Reached:SetSize(22, 22)
	button.Reached:SetPoint("RIGHT", -18, 0)

	button:SetScript("OnClick", function(self)
		ns.PlaySoundKit("IG_ABILITY_PAGE_TURN")
		-- A standing shows only its own rewards; clicking it again shows them all.
		if self.boss.standing and self.selected then
			ns.Journal:OpenInstance(self.instance)
		else
			ns.Journal:OpenBoss(self.instance, self.boss)
		end
	end)
	return button
end

local function SetBossButton(button, instance, boss)
	button.instance, button.boss = instance, boss
	button.Name:SetText(boss.rare and (boss.name .. L.RARE_SUFFIX) or boss.name)
	button.Name:ClearAllPoints()

	local hasPortrait = false
	if boss.standing then
		button.Name:SetSize(160, 20)
		button.Name:SetPoint("LEFT", 105, 7)
		local count = #(boss.loot or {})
		button.Detail:SetText(count == 1 and L.REP_REWARD_ONE or string.format(L.REP_REWARDS, count))
		local badge = ns.Reputation:Badge(boss.reaction)
		if badge then
			button.Portrait:SetTexture(badge)
			button.Portrait:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			hasPortrait = true
		end
	else
		button.Name:SetSize(160, 40)
		button.Name:SetPoint("LEFT", 105, -3)
		if boss.displayID and type(SetPortraitTextureFromCreatureDisplayID) == "function" then
			button.Portrait:SetTexCoord(0, 1, 0, 1)
			hasPortrait = pcall(SetPortraitTextureFromCreatureDisplayID, button.Portrait, boss.displayID)
		end
	end
	button.Detail:SetShown(boss.standing == true)
	button.Reached:SetShown(boss.standing == true and ns.Reputation:Reached(instance, boss.reaction))
	button.Portrait:SetShown(hasPortrait)
	button.DefaultArt:SetShown(not hasPortrait)
end

--[[
	The bar itself: Forever's own reputation bar from the character panel (its framed track,
	fill and mask), or a plain status bar on a client without that template.
]]
local function CreateStandingBar(parent)
	if ns.HasTemplate(STANDING_BAR_TEMPLATE) then
		local ok, bar = pcall(CreateFrame, "Frame", nil, parent, STANDING_BAR_TEMPLATE)
		if ok and bar and rawget(bar, "Fill") then return bar end
	end
	local bar = CreateFrame("StatusBar", nil, parent)
	bar:SetStatusBarTexture(STATUS_BAR)
	bar.Background = bar:CreateTexture(nil, "BACKGROUND")
	bar.Background:SetAllPoints()
	bar.Background:SetColorTexture(0, 0, 0, 0.6)
	bar.Text = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	bar.Text:SetPoint("CENTER", 0, 1)
	return bar
end

local function SetStandingBar(bar, standing)
	local r, g, b = ns.Reputation:Color(standing.reaction)
	local max = math.max(1, standing.max)
	local text = string.format(L.REP_PROGRESS, BreakUp(standing.value), BreakUp(standing.max))
	if rawget(bar, "Fill") then
		-- Forever's bar: its white fill, tinted the standing's colour.
		if bar.SetFillTextureByColorType and bar.ColorType then
			pcall(bar.SetFillTextureByColorType, bar, bar.ColorType.White)
		end
		bar.Fill:SetVertexColor(r, g, b)
		bar:SetFillPercent(standing.value / max)
		bar.Text:SetText(text)
	else
		bar:SetMinMaxValues(0, max)
		bar:SetValue(standing.value)
		bar:SetStatusBarColor(r, g, b)
		bar.Text:SetText(text)
	end
end

--[[
	Beneath a faction's standings, on the same plate as they sit on: the handshake of the
	player's standing now, its name, and how far through it they are.
]]
local function CreateFactionStanding(page)
	local holder = CreateFrame("Frame", nil, page.Bosses.Child)
	holder:SetSize(325, BOSS_BUTTON_HEIGHT)
	holder.Plate = holder:CreateTexture(nil, "BACKGROUND")
	ns.Art(holder.Plate, "BossButton-Up")
	holder.Plate:SetAllPoints()

	holder.Badge = Masked(holder, holder:CreateTexture(nil, "OVERLAY", nil, 5))
	holder.Badge:SetSize(48, 48)
	holder.Badge:SetPoint("CENTER", holder, "LEFT", 46, 0)
	holder.Ring = holder:CreateTexture(nil, "OVERLAY", nil, 6)
	ns.Art(holder.Ring, "BossModelButton", true)
	holder.Ring:SetSize(77, 73)
	holder.Ring:SetPoint("CENTER", holder.Badge)

	holder.Label = holder:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalMed3", "GameFontNormal"))
	holder.Label:SetSize(205, 16)
	holder.Label:SetJustifyH("LEFT")
	SetColor(holder.Label, BOSS_NAME_COLOR)

	-- At the template's own height, which its fill and mask art are cut for.
	holder.Bar = CreateStandingBar(holder)
	holder.Bar:SetSize(205, 29)
	holder.Bar:SetPoint("TOPLEFT", 100, -21)

	-- Standings change as the player earns reputation.
	holder:RegisterEvent("UPDATE_FACTION")
	holder:SetScript("OnEvent", function(self)
		if self:IsVisible() and page.instance and page.instance.kind == "faction" then
			EncounterPage:RefreshStanding(page, true)
		end
	end)
	holder:Hide()
	page.FactionStanding = holder
end

--[[
	Beneath a placeholder's list (a raid or dungeon not open in Forever yet): what it waits on,
	and our Discord, where a recorded run can be sent.
]]
local COMING_SOON_HEIGHT = 128

local function CreateComingSoon(page)
	local box = CreateFrame("Frame", nil, page.Bosses.Child)
	box:SetSize(325, COMING_SOON_HEIGHT)
	box.Title = box:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalMed3", "GameFontNormal"))
	box.Title:SetPoint("TOPLEFT", 14, -6)
	box.Title:SetText(L.COMING_SOON)
	SetColor(box.Title, ns.PARCHMENT_TEXT_COLOR)
	box.Text = ParchmentText(box, 300)
	box.Text:SetPoint("TOPLEFT", box.Title, "BOTTOMLEFT", 0, -6)
	box.Link = ns.CreateDiscordLink(box, 190, true)
	box.Link:SetPoint("TOPLEFT", box.Text, "BOTTOMLEFT", 6, -8)
	box:Hide()
	page.ComingSoon = box
end

-- redrawLoot: the reward list's standing colours change too (reputation was earned); a page
-- being opened draws its list once, afterwards.
function EncounterPage:RefreshStanding(page, redrawLoot)
	local faction, holder = page.instance, page.FactionStanding
	local standing = ns.Reputation:Player(faction.factionID)
	local badge = ns.Reputation:Badge(standing and standing.reaction or 4)
	holder.Badge:SetTexture(badge or ns.Reputation:Crest(faction))
	holder.Badge:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	holder.Badge:SetDesaturated(standing == nil)
	if standing then
		holder.Label:SetText(string.format(L.REP_YOUR_STANDING, ns.Reputation:Label(standing.reaction)))
		holder.Bar:Show()
		SetStandingBar(holder.Bar, standing)
		holder.Label:ClearAllPoints()
		holder.Label:SetPoint("TOPLEFT", 102, -6)
	else
		holder.Label:SetText(L.REP_NOT_MET)
		holder.Bar:Hide()
		holder.Label:ClearAllPoints()
		holder.Label:SetPoint("LEFT", 102, 0)
	end
	for _, button in ipairs(page.Bosses.Buttons) do
		if button:IsShown() and button.boss.standing then
			button.Reached:SetShown(ns.Reputation:Reached(faction, button.boss.reaction))
		end
	end
	if redrawLoot and page.Loot:IsShown() then ns.LootPanel:Refresh(page.Loot) end
end

local function CreateLeftPage(page, info)
	info.LeftShadow = info:CreateTexture(nil, "BACKGROUND", nil, 3)
	ns.Art(info.LeftShadow, "LeftPageHeader")
	info.LeftShadow:SetPoint("TOPLEFT", 0, -11)

	local instanceButton = CreateFrame("Button", nil, info)
	instanceButton:SetSize(64, 61)
	instanceButton:SetPoint("TOPLEFT", 0, -3)
	instanceButton.Icon = Masked(instanceButton, instanceButton:CreateTexture(nil, "BACKGROUND", nil, 6))
	instanceButton.Icon:SetSize(40, 40)
	instanceButton.Icon:SetPoint("CENTER")
	ns.SetButtonArt(instanceButton, "BossModelButton", nil, "BossModelButton")
	instanceButton:SetScript("OnClick", function()
		ns.PlaySoundKit("IG_ABILITY_PAGE_TURN")
		ns.Journal:OpenInstance(page.instance)
	end)
	info.InstanceButton = instanceButton

	info.InstanceTitle = info:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	info.InstanceTitle:SetSize(290, 12)
	info.InstanceTitle:SetPoint("TOPLEFT", 65, -20)
	info.InstanceTitle:SetJustifyH("LEFT")
	SetColor(info.InstanceTitle, ns.PAGE_TITLE_COLOR)

	-- The list scrolls below the dungeon's icon, so a portrait's circle never shows round it.
	local bosses = ns.CreateScrollFrame(info, 5, -5, 5)
	bosses:SetSize(338, 364)
	bosses:SetPoint("BOTTOMLEFT", 25, 1)
	bosses.Child:SetWidth(325)
	bosses.Buttons = {}
	page.Bosses = bosses
	CreateFactionStanding(page)
	CreateComingSoon(page)
end

------------------------------------------------------------------------------------------
-- Right page
------------------------------------------------------------------------------------------

-- Retail's instance frame: picture, name banner and lore, over the right page.
local function CreateInstanceOverview(page, info)
	local overview = CreateFrame("Frame", nil, page)
	overview:SetSize(390, 425)
	overview:SetPoint("BOTTOMRIGHT", -1, 2)
	overview:SetFrameLevel(info:GetFrameLevel() + 2)

	overview.PictureBorder = overview:CreateTexture(nil, "BACKGROUND")
	overview.PictureBorder:SetColorTexture(0.12, 0.08, 0.04, 0.85)
	overview.PictureBorder:SetSize(336, 200)
	overview.PictureBorder:SetPoint("TOP", 3, -22)
	overview.Picture = overview:CreateTexture(nil, "BORDER")
	overview.Picture:SetPoint("TOPLEFT", overview.PictureBorder, 2, -2)
	overview.Picture:SetPoint("BOTTOMRIGHT", overview.PictureBorder, -2, 2)

	overview.TitleBackground = overview:CreateTexture(nil, "ARTWORK")
	ns.Art(overview.TitleBackground, "DungeonNameBg")
	overview.TitleBackground:SetPoint("TOP", overview.PictureBorder, "TOP", 0, -14)
	overview.Title = overview:CreateFontString(nil, "OVERLAY", ns.Font("QuestFont_Super_Huge", "GameFontNormalHuge"))
	overview.Title:SetSize(320, 35)
	overview.Title:SetPoint("CENTER", overview.TitleBackground, "CENTER", 0, 2)
	overview.Title:SetJustifyH("CENTER")

	local lore = ns.CreateScrollFrame(overview, 9, -6, 6)
	lore:SetSize(315, 178)
	lore:SetPoint("BOTTOMLEFT", 35, 10)
	lore.Child:SetWidth(315)
	lore.Text = ParchmentText(lore.Child, 310)
	lore.Text:SetPoint("TOPLEFT", 2, -2)
	overview.Lore = lore

	-- Retail's Show Map: the quest log's map icon on a dark strip, above the lore.
	local mapButton = CreateFrame("Button", nil, overview)
	mapButton:SetSize(48, 32)
	mapButton:SetFrameLevel(overview:GetFrameLevel() + 5)
	mapButton.Shadow = mapButton:CreateTexture(nil, "BACKGROUND")
	ns.Art(mapButton.Shadow, "ShowMapBG")
	mapButton.Shadow:SetPoint("LEFT", -3, 5)
	mapButton.Icon = mapButton:CreateTexture(nil, "ARTWORK")
	mapButton.Icon:SetTexture(MAP_BUTTON)
	mapButton.Icon:SetTexCoord(0.125, 0.875, 0, 0.5)
	mapButton.Icon:SetSize(48, 32)
	mapButton.Icon:SetPoint("RIGHT")
	mapButton.Text = mapButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	mapButton.Text:SetPoint("LEFT", mapButton, "RIGHT", 2, 0)
	mapButton.Text:SetText(L.MAP_SHOW)
	mapButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	local highlight = mapButton:GetHighlightTexture()
	if highlight then
		highlight:ClearAllPoints()
		highlight:SetSize(36, 25)
		highlight:SetPoint("RIGHT", -7, 0)
	end
	mapButton:SetScript("OnMouseDown", function(self) self.Icon:SetTexCoord(0.125, 0.875, 0.5, 1) end)
	mapButton:SetScript("OnMouseUp", function(self) self.Icon:SetTexCoord(0.125, 0.875, 0, 0.5) end)
	mapButton:SetScript("OnClick", function()
		ns.PlaySoundKit("IG_MAINMENU_OPTION")
		ns.DungeonMap:Show(page.instance)
	end)
	overview.MapButton = mapButton

	page.InstanceOverview = overview
end

-- The boss Overview: description, the "Overview" header bar and bullets beneath it.
local function CreateBossOverview(page, info)
	local scroll = ns.CreateScrollFrame(info, -15, -6, 6)
	scroll:SetSize(350, 383)
	scroll:SetPoint("BOTTOMRIGHT", -5, 1)
	scroll.Child:SetWidth(320)
	local child = scroll.Child

	child.Description = ParchmentText(child, 315)
	child.Description:SetPoint("TOPLEFT", 2, -8)

	child.Header = child:CreateTexture(nil, "ARTWORK")
	ns.Art(child.Header, "Header-Overview")
	child.Header:SetPoint("TOPLEFT", child.Description, "BOTTOMLEFT", -6, -6)
	child.HeaderLabel = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	child.HeaderLabel:SetPoint("BOTTOMLEFT", child.Header, "BOTTOMLEFT", 8, 6)
	child.HeaderLabel:SetText(L.TAB_OVERVIEW)
	SetColor(child.HeaderLabel, ns.HEADER_LABEL_COLOR)

	child.Bullets = {}
	page.BossOverview = scroll
end

local function CreatePlaceholder(page, info)
	local placeholder = CreateFrame("Frame", nil, info)
	placeholder:SetSize(350, 383)
	placeholder:SetPoint("BOTTOMRIGHT", -5, 1)
	placeholder.Text = ParchmentText(placeholder, 315)
	placeholder.Text:SetPoint("TOPLEFT", 2, -8)
	page.Placeholder = placeholder
end

local function CreateSideTabs(page, info)
	page.Tabs = {}
	for index, definition in ipairs(SIDE_TABS) do
		local tab = CreateFrame("Button", nil, info)
		tab:SetSize(63, 57)
		tab:SetID(definition.id)
		tab:SetFrameLevel(info:GetFrameLevel() + 30)
		ns.SetButtonArt(tab, "Tab-UnSelected", "Tab-Selected", "Tab-Highlight", "Tab-UnSelected")
		if index == 1 then
			tab:SetPoint("TOPLEFT", info, "TOPRIGHT", -12, -35)
		else
			tab:SetPoint("TOP", page.Tabs[index - 1], "BOTTOM", 0, 2)
		end

		tab.unselected = tab:CreateTexture(nil, "OVERLAY")
		tab.selected = tab:CreateTexture(nil, "OVERLAY")
		if definition.atlas then
			for _, icon in ipairs({ tab.unselected, tab.selected }) do
				icon:SetAtlas(definition.atlas)
				icon:SetSize(32, 32)
			end
			tab.unselected:SetPoint("RIGHT", -14, 0)
			tab.unselected:SetVertexColor(0.75, 0.75, 0.75)
		else
			ns.Art(tab.unselected, definition.unselected)
			ns.Art(tab.selected, definition.selected)
			tab.unselected:SetPoint("RIGHT", -6, 0)
		end
		tab.selected:SetPoint("CENTER", tab.unselected, "CENTER")

		tab.tooltip = definition.tooltip
		tab:SetScript("OnClick", function(self)
			ns.PlaySoundKit("IG_ABILITY_PAGE_TURN")
			EncounterPage:SetTab(page, self:GetID())
		end)
		tab:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
			GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
		end)
		tab:SetScript("OnLeave", function() GameTooltip:Hide() end)
		page.Tabs[index] = tab
	end
end

------------------------------------------------------------------------------------------
-- Building the page
------------------------------------------------------------------------------------------

function EncounterPage:Create(parent)
	local page = CreateFrame("Frame", nil, parent)
	page:SetPoint("TOPLEFT")
	page:SetPoint("BOTTOMRIGHT", -3, 0)
	page:Hide()
	page.tab = TAB_OVERVIEW

	local info = CreateFrame("Frame", nil, page)
	info:SetSize(785, 425)
	info:SetPoint("BOTTOMRIGHT", -1, 2)
	page.info = info

	info.Book = info:CreateTexture(nil, "BACKGROUND")
	info.Book:SetSize(785, 425)
	info.Book:SetPoint("BOTTOMRIGHT")
	info.Book:SetTexture(BOOK)
	info.Book:SetTexCoord(BOOK_COORDS[1], BOOK_COORDS[2], BOOK_COORDS[3], BOOK_COORDS[4])

	info.RightShadow = info:CreateTexture(nil, "BACKGROUND", nil, 3)
	ns.Art(info.RightShadow, "RightPageHeader")
	info.RightShadow:SetPoint("TOPRIGHT", 0, -11)
	info.EncounterTitle = info:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	info.EncounterTitle:SetSize(220, 12)
	info.EncounterTitle:SetPoint("BOTTOMLEFT", info, "TOPRIGHT", -350, -36)
	info.EncounterTitle:SetJustifyH("LEFT")
	SetColor(info.EncounterTitle, ns.PAGE_TITLE_COLOR)

	CreateLeftPage(page, info)
	CreateBossOverview(page, info)
	CreatePlaceholder(page, info)
	page.Loot = ns.LootPanel:Create(page, info)
	page.Abilities = ns.AbilitiesPanel:Create(page, info)
	page.Model = ns.ModelPanel:Create(page, info)
	ns.QuestsPanel:Create(page, info)
	CreateInstanceOverview(page, info)
	CreateSideTabs(page, info)
	return page
end

------------------------------------------------------------------------------------------
-- Filling it
------------------------------------------------------------------------------------------

local function FillBossList(page)
	local bosses, child = page.Bosses, page.Bosses.Child
	local list = BossesOf(page.instance)
	for index, boss in ipairs(list) do
		local button = bosses.Buttons[index]
		if not button then
			button = CreateBossButton(child)
			bosses.Buttons[index] = button
		end
		button:ClearAllPoints()
		button:SetPoint("TOPLEFT", 0, -(BOSS_TOP_PADDING + (index - 1) * (BOSS_BUTTON_HEIGHT + BOSS_SPACING)))
		SetBossButton(button, page.instance, boss)
		button:Show()
	end
	for index = #list + 1, #bosses.Buttons do
		bosses.Buttons[index]:Hide()
	end
	local height = BOSS_TOP_PADDING + #list * BOSS_BUTTON_HEIGHT + math.max(0, #list - 1) * BOSS_SPACING + BOSS_BOTTOM_PADDING

	-- A faction's list ends with the player's own standing.
	local holder = page.FactionStanding
	holder:SetShown(page.instance.kind == "faction")
	if holder:IsShown() then
		-- Where another standing would go, one gap further down.
		local top = BOSS_TOP_PADDING + #list * (BOSS_BUTTON_HEIGHT + BOSS_SPACING) + BOSS_SPACING
		holder:ClearAllPoints()
		holder:SetPoint("TOPLEFT", 0, -top)
		height = top + BOSS_BUTTON_HEIGHT + BOSS_BOTTOM_PADDING
		EncounterPage:RefreshStanding(page)
	end

	-- A placeholder's list ends with what it waits on, and where to send a run; a faction with no
	-- quartermaster captured yet, beneath the player's standing, with how to capture one.
	local soon, instance = page.ComingSoon, page.instance
	local uncaptured = instance.kind == "faction" and not ns.FactionCaptured(instance)
	soon:SetShown(instance.comingSoon == true or instance.untested == true or uncaptured)
	if soon:IsShown() then
		local top = BOSS_TOP_PADDING + #list * (BOSS_BUTTON_HEIGHT + BOSS_SPACING)
		if uncaptured then
			top = BOSS_TOP_PADDING + #list * (BOSS_BUTTON_HEIGHT + BOSS_SPACING) + BOSS_SPACING + BOSS_BUTTON_HEIGHT
				+ BOSS_SPACING
			if ns.FactionListed(instance) then
				soon.Title:SetText(L.REP_NOT_CAPTURED)
				soon.Text:SetText(L.REP_LISTED_TEXT)
			else
				soon.Title:SetText(instance.forever and L.COMING_SOON or L.REP_NOT_CAPTURED)
				soon.Text:SetText(instance.forever and L.REP_COMING_SOON_TEXT or L.REP_NOT_CAPTURED_TEXT)
			end
		else
			soon.Title:SetText(L.COMING_SOON)
			soon.Text:SetText(#list > 0 and L.COMING_SOON_PARTLY or L.COMING_SOON_TEXT)
		end
		soon:ClearAllPoints()
		soon:SetPoint("TOPLEFT", 0, -top)
		height = top + COMING_SOON_HEIGHT + BOSS_BOTTOM_PADDING
	end
	child:SetHeight(height)
	bosses:SetVerticalScroll(0)
end

local function HighlightSelectedBoss(page)
	for _, button in ipairs(page.Bosses.Buttons) do
		button.selected = button:IsShown() and button.boss == page.boss
		if button.selected then
			button:LockHighlight()
		else
			button:UnlockHighlight()
		end
	end
end

-- Two layouts: retail's own, for dungeons with Blizzard's lore picture (390x330 at the top
-- of the page, the name banner over it, a short lore box beneath); and a framed crop of the
-- loading screen, for Forever's dungeons, which have no journal art.
local function LayoutInstanceOverview(overview, retail)
	overview.PictureBorder:SetShown(not retail)
	overview.Picture:ClearAllPoints()
	overview.TitleBackground:ClearAllPoints()
	overview.Lore:ClearAllPoints()
	overview.MapButton:ClearAllPoints()
	if retail then
		overview.Picture:SetSize(390, 330)
		overview.Picture:SetPoint("TOP", 3, -9)
		overview.TitleBackground:SetPoint("TOP", overview.Picture, "TOP", 0, -38)
		overview.Lore:SetSize(315, 95)
		overview.Lore:SetPoint("BOTTOMLEFT", 35, 5)
		-- Where retail puts it: over the foot of the picture.
		overview.MapButton:SetPoint("BOTTOMLEFT", 33, 126)
	else
		overview.Picture:SetPoint("TOPLEFT", overview.PictureBorder, 2, -2)
		overview.Picture:SetPoint("BOTTOMRIGHT", overview.PictureBorder, -2, 2)
		overview.TitleBackground:SetPoint("TOP", overview.PictureBorder, "TOP", 0, -14)
		overview.Lore:SetSize(315, 178)
		overview.Lore:SetPoint("BOTTOMLEFT", 35, 10)
		overview.MapButton:SetPoint("BOTTOMLEFT", overview.PictureBorder, "BOTTOMLEFT", 6, 8)
	end
end

local function FillInstanceOverview(page)
	local instance, overview = page.instance, page.InstanceOverview
	LayoutInstanceOverview(overview, instance.loreImage ~= nil)
	if instance.loreImage then
		overview.Picture:SetTexture(instance.loreImage)
		overview.Picture:SetTexCoord(0, 0.7617187, 0, 0.65625)
	else
		SetCroppedArt(overview.Picture, instance.buttonArt, instance.loreArtCoords or LORE_COORDS)
	end
	overview.Title:SetText(instance.name)
	overview.TitleBackground:SetWidth(math.min(380, overview.Title:GetStringWidth() + 80))
	overview.MapButton:SetShown(ns.DungeonMap:HasMap(instance))

	local lines = {}
	if instance.forever then lines[#lines + 1] = ns.ForeverIconText(16) .. " " .. FOREVER_COLOR .. L.FOREVER_LINE .. "|r" end
	if instance.location then lines[#lines + 1] = string.format(L.LOCATION_LINE, instance.location) end
	if instance.levelMin then
		lines[#lines + 1] = string.format(L.LEVEL_RANGE, instance.levelMin, instance.levelMax or instance.levelMin)
	end
	if instance.untested then
		lines[#lines + 1] = ""
		lines[#lines + 1] = UNTESTED_COLOR .. L.UNTESTED_NOTE .. "|r"
	end
	if instance.description then
		lines[#lines + 1] = ""
		lines[#lines + 1] = instance.description
	end
	local lore = overview.Lore
	lore.Text:SetText(table.concat(lines, "\n"))
	lore.Child:SetHeight(lore.Text:GetStringHeight() + 4)
	lore:SetVerticalScroll(0)
end

-- Hand-written notes first, then quick facts from the data.
local function BossBullets(boss)
	local bullets = {}
	for _, note in ipairs(boss.notes or {}) do bullets[#bullets + 1] = note end
	if boss.area then bullets[#bullets + 1] = string.format(L.BULLET_AREA, boss.area) end
	if boss.rare then bullets[#bullets + 1] = L.BULLET_RARE end
	if boss.level then bullets[#bullets + 1] = string.format(L.BULLET_LEVEL, boss.level) end
	if boss.abilities and #boss.abilities > 0 then
		bullets[#bullets + 1] = string.format(L.BULLET_ABILITIES, NameList(boss.abilities, 6))
	end
	if boss.adds and #boss.adds > 0 then
		bullets[#bullets + 1] = string.format(L.BULLET_ADDS, NameList(boss.adds, 4))
	end
	if boss.loot and #boss.loot > 0 then
		bullets[#bullets + 1] = string.format(L.BULLET_LOOT, #boss.loot, NameList(boss.loot, 4))
	end
	if #bullets == 0 then bullets[1] = L.BULLET_NOTHING_YET end
	return bullets
end

local function FillBossOverview(page)
	local child = page.BossOverview.Child
	local boss = page.boss
	child.Description:SetText(boss.description or "")
	child.Header:ClearAllPoints()
	if boss.description and boss.description ~= "" then
		child.Header:SetPoint("TOPLEFT", child.Description, "BOTTOMLEFT", -6, -6)
	else
		child.Header:SetPoint("TOPLEFT", 0, -4)
	end

	local previous = child.Header
	local height = (boss.description and child.Description:GetStringHeight() or 0) + 8 + 30 + 9
	for index, text in ipairs(BossBullets(boss)) do
		local bullet = child.Bullets[index]
		if not bullet then
			bullet = CreateFrame("Frame", nil, child)
			bullet:SetSize(300, 15)
			bullet.Icon = bullet:CreateTexture(nil, "ARTWORK")
			ns.Art(bullet.Icon, "PaperOverlay-Bullet")
			bullet.Icon:SetPoint("TOPLEFT")
			bullet.Text = ParchmentText(bullet, 290)
			bullet.Text:SetPoint("TOPLEFT", bullet.Icon, "TOPRIGHT", 4, 0)
			child.Bullets[index] = bullet
		end
		bullet:ClearAllPoints()
		bullet:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", index == 1 and 10 or 0, index == 1 and -9 or -6)
		bullet.Text:SetText(text)
		bullet:SetHeight(math.max(15, bullet.Text:GetStringHeight()))
		bullet:Show()
		height = height + bullet:GetHeight() + 6
		previous = bullet
	end
	for index = #BossBullets(boss) + 1, #child.Bullets do
		child.Bullets[index]:Hide()
	end
	child:SetHeight(height)
	page.BossOverview:SetVerticalScroll(0)
end

local function SetTabEnabled(tab, enabled)
	tab:SetEnabled(enabled)
	local disabled = tab:GetDisabledTexture()
	if disabled then disabled:SetDesaturated(not enabled) end
	tab.unselected:SetDesaturated(not enabled)
end

local function UpdateTabStates(page)
	local tabs = page.Tabs
	SetTabEnabled(tabs[TAB_OVERVIEW], true)
	SetTabEnabled(tabs[TAB_LOOT], true)
	-- As on retail, abilities belong to a boss: the tab waits until one is chosen.
	SetTabEnabled(tabs[TAB_ABILITIES], page.boss ~= nil)
	-- The model, too, needs a boss, and one whose creature the client can draw.
	SetTabEnabled(tabs[TAB_MODEL], #ns.ModelPanel:Creatures(page.boss) > 0)
	SetTabEnabled(tabs[TAB_QUESTS], #page.instance.quests > 0)
end

function EncounterPage:SetTab(page, tabID)
	if page.instance and page.instance.kind == "faction" then tabID = TAB_LOOT end
	if not page.Tabs[tabID] or not page.Tabs[tabID]:IsEnabled() then tabID = TAB_OVERVIEW end
	page.tab = tabID
	for _, tab in ipairs(page.Tabs) do
		local isSelected = tab:GetID() == tabID
		tab.selected:SetShown(isSelected)
		tab.unselected:SetShown(not isSelected)
		if isSelected then tab:LockHighlight() else tab:UnlockHighlight() end
	end

	local instancePage = tabID == TAB_OVERVIEW and not page.boss
	local lootPage = tabID == TAB_LOOT
	page.InstanceOverview:SetShown(instancePage)
	page.BossOverview:SetShown(tabID == TAB_OVERVIEW and page.boss ~= nil)
	page.Placeholder:SetShown(PLACEHOLDERS[tabID] ~= nil)
	page.Placeholder.Text:SetText(PLACEHOLDERS[tabID] or "")

	-- An already open page still needs redrawing for a new boss or dungeon.
	if lootPage and page.Loot:IsShown() then ns.LootPanel:Refresh(page.Loot) end
	page.Loot:SetShown(lootPage)
	local abilitiesPage = tabID == TAB_ABILITIES
	if abilitiesPage and page.Abilities:IsShown() then ns.AbilitiesPanel:Refresh(page.Abilities) end
	page.Abilities:SetShown(abilitiesPage)
	local modelPage = tabID == TAB_MODEL
	if modelPage then ns.ModelPanel:Refresh(page.Model, page.boss) end
	page.Model:SetShown(modelPage)
	-- The quests take both pages: their list replaces the boss list on the left.
	local questsPage = tabID == TAB_QUESTS
	ns.QuestsPanel:Show(page, questsPage)

	local info = page.info
	-- The right page's dark header band; the quest page goes without, as on the classic journals,
	-- and the model fills the page, its name along the bottom, as on retail.
	info.RightShadow:SetShown(not instancePage and not questsPage and not modelPage)
	-- On the loot page the header holds the filters instead, as on retail; a quest has its own title.
	info.EncounterTitle:SetShown(not instancePage and not lootPage and not questsPage and not modelPage)
	info.EncounterTitle:SetText(page.boss and page.boss.name or page.instance.name)
end

--[[
	A faction opens on its rewards alone: no side tabs, the Loot page on the right. The tab
	the reader had in the dungeons is kept for when they go back to one.
]]
local function SwitchKind(page, previous, instance)
	local wasFaction = previous ~= nil and previous.kind == "faction"
	local isFaction = instance.kind == "faction"
	if isFaction and not wasFaction then
		page.dungeonTab = page.tab
	elseif wasFaction and not isFaction then
		page.tab = page.dungeonTab or TAB_OVERVIEW
	end
	for _, tab in ipairs(page.Tabs) do tab:SetShown(not isFaction) end
	if isFaction then page.tab = TAB_LOOT end
end

function EncounterPage:ShowInstance(page, instance)
	local previous = page.instance
	local changed = previous ~= instance
	page.instance, page.boss = instance, nil
	if changed then
		SwitchKind(page, previous, instance)
		local info = page.info
		info.InstanceTitle:SetText(instance.name)
		if instance.kind == "faction" then
			SetCroppedArt(info.InstanceButton.Icon, ns.Reputation:Crest(instance), FACTION_CREST_COORDS)
		elseif instance.buttonImage then
			-- A square from the middle of Blizzard's button picture (its art fills 174x95 of 256x128).
			SetCroppedArt(info.InstanceButton.Icon, instance.buttonImage, BUTTON_IMAGE_ICON_COORDS)
		else
			SetCroppedArt(info.InstanceButton.Icon, instance.buttonArt, instance.iconArtCoords or ICON_COORDS)
		end
		FillBossList(page)
		if instance.kind ~= "faction" then FillInstanceOverview(page) end
	end
	HighlightSelectedBoss(page)
	UpdateTabStates(page)
	self:SetTab(page, page.tab)
	page:Show()
end

function EncounterPage:ShowBoss(page, instance, boss)
	-- Passing through another dungeon's overview must not lose the tab the reader was on.
	local wantedTab = page.tab
	if page.instance ~= instance then
		local previous = page.instance
		self:ShowInstance(page, instance)
		if instance.kind == "faction" then
			wantedTab = TAB_LOOT
		elseif previous and previous.kind == "faction" then
			wantedTab = page.dungeonTab or TAB_OVERVIEW
		end
	end
	page.boss = boss
	HighlightSelectedBoss(page)
	FillBossOverview(page)
	UpdateTabStates(page)
	self:SetTab(page, wantedTab)
	page:Show()
end

EncounterPage.TAB_OVERVIEW, EncounterPage.TAB_LOOT = TAB_OVERVIEW, TAB_LOOT
EncounterPage.TAB_ABILITIES, EncounterPage.TAB_QUESTS = TAB_ABILITIES, TAB_QUESTS
EncounterPage.TAB_MODEL = TAB_MODEL
