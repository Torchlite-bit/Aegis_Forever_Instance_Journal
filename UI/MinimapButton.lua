local _, ns = ...
local L = ns.L

--[[
	The journal's button on the minimap's edge: the journal's icon, Ashbringer's, which its window
	wears too (UI/Journal.lua), round. Left-click opens or closes the journal, right-click opens its options; dragged, it goes round
	the minimap's edge and stays where it is left. Forever has no add-on compartment, so it is a
	button on the edge as classic ones are; a minimap button collector gathers it like the rest.
	Shown unless turned off in the journal's options.
]]

local MinimapButton = {}
ns.MinimapButton = MinimapButton

local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local DEFAULT_ANGLE = 210       -- degrees round the minimap, from its right, anticlockwise
local OUTSIDE = 10              -- how far past the minimap's edge the button's centre sits

function MinimapButton.Shows()
	return not (ns.db and ns.db.hideMinimapButton)
end

-- Shown or hidden by Show and Hide, not SetShown: a minimap button collector hears only those.
local function SetShown(button, shown)
	if shown then button:Show() else button:Hide() end
end

function MinimapButton.SetShows(shown)
	ns.db.hideMinimapButton = not shown or nil
	if MinimapButton.button then SetShown(MinimapButton.button, shown) end
end

-- Where the button goes for an angle: on a round minimap's edge, or a square one's.
local function Place(button, angle)
	local radians = math.rad(angle)
	local x, y = math.cos(radians), math.sin(radians)
	local square = type(GetMinimapShape) == "function" and GetMinimapShape() == "SQUARE"
	if square then
		local most = math.max(math.abs(x), math.abs(y))
		x, y = x / most, y / most
	end
	local radius = (Minimap:GetWidth() or 140) / 2 + OUTSIDE
	button:ClearAllPoints()
	button:SetPoint("CENTER", Minimap, "CENTER", x * radius, y * radius)
end

-- The angle from the minimap's centre to the cursor, while the button is dragged.
local function CursorAngle()
	local mx, my = Minimap:GetCenter()
	local cx, cy = GetCursorPosition()
	local scale = (Minimap.GetEffectiveScale and Minimap:GetEffectiveScale()) or 1
	if not (mx and cx) then return nil end
	return math.deg(math.atan2(cy / scale - my, cx / scale - mx)) % 360
end

local function ShowTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L.OPTIONS_TITLE, 1, 1, 1)
	GameTooltip:AddLine(L.MINIMAP_LEFT_CLICK, 0.1, 1, 0.1)
	GameTooltip:AddLine(L.MINIMAP_RIGHT_CLICK, 0.1, 1, 0.1)
	GameTooltip:AddLine(L.MINIMAP_DRAG, 0.6, 0.6, 0.6)
	GameTooltip:Show()
end

function MinimapButton:Create()
	if self.button or not Minimap then return self.button end
	local button = CreateFrame("Button", "AegisJournalMinimapButton", Minimap)
	button:SetSize(31, 31)
	button:SetFrameStrata("MEDIUM")
	button:SetFrameLevel((Minimap:GetFrameLevel() or 1) + 8)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:RegisterForDrag("LeftButton")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

	-- The minimap buttons' own look: a dark disc, the picture, the tracking button's gold ring.
	button.Background = button:CreateTexture(nil, "BACKGROUND")
	button.Background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	button.Background:SetSize(20, 20)
	button.Background:SetPoint("TOPLEFT", 7, -5)
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetTexture(ns.Journal.Icon())
	button.Icon:SetTexCoord(unpack(ns.Journal.ICON_CROP))
	button.Icon:SetSize(19, 19)
	button.Icon:SetPoint("TOPLEFT", 6, -5)
	if button.CreateMaskTexture and button.Icon.AddMaskTexture then
		local mask = button:CreateMaskTexture()
		mask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(button.Icon)
		button.Icon:AddMaskTexture(mask)
	end
	button.Border = button:CreateTexture(nil, "OVERLAY")
	button.Border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	button.Border:SetSize(53, 53)
	button.Border:SetPoint("TOPLEFT")

	button:SetScript("OnClick", function(_, mouseButton)
		if mouseButton == "RightButton" then
			ns.Options:Open()
		else
			ns.Journal:Toggle()
		end
	end)
	button:SetScript("OnEnter", ShowTooltip)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- Round the edge with the cursor, only while it is held.
	button:SetScript("OnDragStart", function(self)
		GameTooltip:Hide()
		self:SetScript("OnUpdate", function()
			local angle = CursorAngle()
			if angle then
				ns.db.minimapAngle = angle
				Place(self, angle)
			end
		end)
	end)
	button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)

	Place(button, ns.db.minimapAngle or DEFAULT_ANGLE)
	SetShown(button, MinimapButton.Shows())
	self.button = button
	return button
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function() MinimapButton:Create() end)
