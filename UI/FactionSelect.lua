local _, ns = ...
local L = ns.L

--[[
	The Reputation tab's list: a card for every faction with rewards, laid out like the
	dungeon grid and framed the same way. A card shows the faction's crest in the journal's
	gold ring over a glow of its colour, the player's standing, and how many rewards it has.
	Clicking one opens its rewards in the book, its standings where a dungeon lists bosses.
]]

local FactionSelect = {}
ns.FactionSelect = FactionSelect

local Reputation = ns.Reputation

local CARD_WIDTH, CARD_HEIGHT = 174, 96
local COLUMNS = 4
local SPACING_X, SPACING_Y = 15, 15
local GRID_LEFT, GRID_TOP = 17, 62
local CREST_COORDS = { 0.07, 0.93, 0.07, 0.93 }
local CREST_SIZE = 36
local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local GOLD_DARK, GOLD_LIGHT = { 0.50, 0.34, 0.10 }, { 1, 0.88, 0.52 }
local BLACK = { 0, 0, 0 }
local UNKNOWN_COLOR = { 0.6, 0.6, 0.6 }
local NAME_FONT = "QuestTitleFontBlackShadow"

local panels = {}

------------------------------------------------------------------------------------------
-- Cards
------------------------------------------------------------------------------------------

-- A round texture of the given size on the card's crest point.
local function Circle(card, subLevel, size)
	local texture = card:CreateTexture(nil, "OVERLAY", nil, subLevel)
	texture:SetSize(size, size)
	texture:SetPoint("CENTER", card, "BOTTOM", 0, 30)
	if card.CreateMaskTexture and texture.AddMaskTexture then
		local mask = card:CreateMaskTexture()
		mask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(texture)
		texture:AddMaskTexture(mask)
	end
	return texture
end

-- Long names drop a size so they keep to two lines above the crest.
local function SetName(card, name)
	card.Name:SetFontObject(NAME_FONT)
	card.Name:SetText(name)
	local lines = card.Name:GetNumLines()
	if type(lines) == "number" and lines > 2 then
		local font, size, flags = card.Name:GetFont()
		if font and size then card.Name:SetFont(font, size - 3, flags) end
	end
end

local function ShowTooltip(card)
	local faction = card.faction
	GameTooltip:SetOwner(card, "ANCHOR_RIGHT")
	GameTooltip:SetText(faction.name, 1, 1, 1)
	local standing = Reputation:Player(faction.factionID)
	if standing then
		local r, g, b = Reputation:Color(standing.reaction)
		GameTooltip:AddLine(Reputation:Label(standing.reaction), r, g, b)
		if standing.description then GameTooltip:AddLine(standing.description, 1, 0.82, 0, true) end
	else
		GameTooltip:AddLine(L.REP_UNKNOWN, 0.6, 0.6, 0.6)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L.REP_CARD_CLICK, 0.5, 0.8, 1)
	GameTooltip:Show()
end

local function CreateCard(parent)
	local card = CreateFrame("Button", nil, parent)
	card:SetSize(CARD_WIDTH, CARD_HEIGHT)

	-- A glow of the faction's colour, brightest behind the crest and darkening to the edges,
	-- inside the dungeon buttons' frame.
	card.Base = card:CreateTexture(nil, "BACKGROUND", nil, 0)
	card.Base:SetPoint("TOPLEFT", 3, -3)
	card.Base:SetPoint("BOTTOMRIGHT", -3, 3)
	card.GlowTop = card:CreateTexture(nil, "BACKGROUND", nil, 1)
	card.GlowTop:SetPoint("TOPLEFT", card.Base)
	card.GlowTop:SetPoint("BOTTOMRIGHT", card.Base, "RIGHT", 0, -14)
	card.GlowBottom = card:CreateTexture(nil, "BACKGROUND", nil, 1)
	card.GlowBottom:SetPoint("TOPLEFT", card.GlowTop, "BOTTOMLEFT")
	card.GlowBottom:SetPoint("BOTTOMRIGHT", card.Base)
	card.ShadeLeft = card:CreateTexture(nil, "BACKGROUND", nil, 2)
	card.ShadeLeft:SetPoint("TOPLEFT", card.Base)
	card.ShadeLeft:SetPoint("BOTTOMLEFT", card.Base)
	card.ShadeLeft:SetWidth(56)
	ns.Gradient(card.ShadeLeft, "HORIZONTAL", BLACK, 0.7, 0)
	card.ShadeRight = card:CreateTexture(nil, "BACKGROUND", nil, 2)
	card.ShadeRight:SetPoint("TOPRIGHT", card.Base)
	card.ShadeRight:SetPoint("BOTTOMRIGHT", card.Base)
	card.ShadeRight:SetWidth(56)
	ns.Gradient(card.ShadeRight, "HORIZONTAL", BLACK, 0, 0.7)
	ns.SetButtonArt(card, "DungeonButton-Up", "DungeonButton-Down", "DungeonButton-Highlight")

	card.Name = card:CreateFontString(nil, "OVERLAY", NAME_FONT)
	card.Name:SetSize(150, 0)
	card.Name:SetPoint("TOP", 0, -12)
	card.Name:SetJustifyH("CENTER")

	-- The crest in a true circle: a gold rim, a thin dark edge, then the icon, each rounded
	-- by its own mask and centred on the same point.
	card.Rim = Circle(card, 1, CREST_SIZE + 6)
	ns.Gradient(card.Rim, "VERTICAL", GOLD_DARK, 1, 1, GOLD_LIGHT)
	card.Edge = Circle(card, 2, CREST_SIZE + 2)
	card.Edge:SetColorTexture(0.1, 0.07, 0.03, 1)
	card.Crest = Circle(card, 3, CREST_SIZE)

	card.Standing = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	card.Standing:SetPoint("BOTTOMLEFT", 9, 9)
	card.Standing:SetJustifyH("LEFT")
	card.Count = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	card.Count:SetPoint("BOTTOMRIGHT", -9, 9)
	card.Count:SetJustifyH("RIGHT")

	-- A reputation new in WoW: Forever, beside its crest (where the player chose it to go).
	card.Forever = ns.CreateForeverMark(card)
	card.Forever:SetPoint("RIGHT", -10, 2)

	card:SetScript("OnEnter", ShowTooltip)
	card:SetScript("OnLeave", function() GameTooltip:Hide() end)
	card:SetScript("OnClick", function(self)
		ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
		ns.Journal:OpenInstance(self.faction)
	end)
	return card
end

local function SetCard(card, faction)
	card.faction = faction
	SetName(card, faction.name)
	card.Forever:SetShown(faction.forever == true)

	local color = Reputation:CardColor(faction)
	card.Base:SetColorTexture(color[1] * 0.2, color[2] * 0.2, color[3] * 0.2, 1)
	ns.Gradient(card.GlowTop, "VERTICAL", color, 0.85, 0.15)
	ns.Gradient(card.GlowBottom, "VERTICAL", color, 0.3, 0.85)

	card.Crest:SetTexture(Reputation:Crest(faction))
	card.Crest:SetTexCoord(CREST_COORDS[1], CREST_COORDS[2], CREST_COORDS[3], CREST_COORDS[4])

	local standing = Reputation:Player(faction.factionID)
	if standing then
		card.Standing:SetText(Reputation:Label(standing.reaction))
		card.Standing:SetTextColor(Reputation:Color(standing.reaction))
	else
		card.Standing:SetText(L.REP_UNKNOWN)
		card.Standing:SetTextColor(UNKNOWN_COLOR[1], UNKNOWN_COLOR[2], UNKNOWN_COLOR[3])
	end

	local count = Reputation:RewardCount(faction)
	card.Count:SetText(count == 1 and L.REP_REWARD_ONE or string.format(L.REP_REWARDS, count))
end

------------------------------------------------------------------------------------------
-- Grid
------------------------------------------------------------------------------------------

function FactionSelect:Build(panel)
	panel.Buttons = {}
	local scroll = ns.CreateScrollFrame(panel, ns.GRID_SCROLLBAR_X, -6, 4)
	scroll:SetPoint("TOPLEFT", GRID_LEFT, -GRID_TOP)
	scroll:SetPoint("BOTTOMRIGHT", -24, 6)
	scroll.Child:SetSize(COLUMNS * CARD_WIDTH + (COLUMNS - 1) * SPACING_X, 1)
	panel.Scroll = scroll

	-- Standings change as the player earns reputation.
	panel:RegisterEvent("UPDATE_FACTION")
	panel:SetScript("OnEvent", function(self)
		if self:IsVisible() and not self.refreshQueued then
			self.refreshQueued = true
			C_Timer.After(0.2, function()
				self.refreshQueued = nil
				if self:IsVisible() then FactionSelect:Refresh(self) end
			end)
		end
	end)
	panel:SetScript("OnShow", function(self) FactionSelect:Refresh(self) end)

	-- The cards are made the first time the tab shows (OnShow above), not with the window.
	panels[#panels + 1] = panel
end

function FactionSelect:Refresh(panel)
	local list = ns.GetFactions()
	local child = panel.Scroll.Child
	for index, faction in ipairs(list) do
		local card = panel.Buttons[index]
		if not card then
			card = CreateCard(child)
			panel.Buttons[index] = card
		end
		local column = (index - 1) % COLUMNS
		local row = math.floor((index - 1) / COLUMNS)
		card:ClearAllPoints()
		card:SetPoint("TOPLEFT", column * (CARD_WIDTH + SPACING_X), -row * (CARD_HEIGHT + SPACING_Y))
		SetCard(card, faction)
		card:Show()
	end
	for index = #list + 1, #panel.Buttons do panel.Buttons[index]:Hide() end

	local rows = math.ceil(#list / COLUMNS)
	child:SetHeight(math.max(1, rows * (CARD_HEIGHT + SPACING_Y) - SPACING_Y))
	panel.Empty:SetShown(#list == 0)
end
