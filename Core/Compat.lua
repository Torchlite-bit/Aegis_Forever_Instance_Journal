local _, ns = ...

--[[
	What this client offers, asked rather than assumed.

	Forever runs the modern engine but ships its own subset of Blizzard's interface: the
	journal's own addon never loads here, and some templates other clients have are gated
	away. Everything the journal builds goes through these helpers, so a missing piece
	falls back to the next best one instead of stopping the window from opening.
]]

function ns.HasTemplate(name)
	if not name then return false end
	if C_XMLUtil and C_XMLUtil.GetTemplateInfo then
		local ok, info = pcall(C_XMLUtil.GetTemplateInfo, name)
		if ok then return info ~= nil end
	end
	-- No way to ask: let CreateFrame decide.
	return true
end

-- Creates the frame from the first template in the list that this client has.
function ns.CreateFrameWithTemplate(frameType, name, parent, ...)
	for index = 1, select("#", ...) do
		local template = select(index, ...)
		if ns.HasTemplate(template) then
			local ok, frame = pcall(CreateFrame, frameType, name, parent, template)
			if ok and frame then return frame, template end
		end
	end
	return CreateFrame(frameType, name, parent), nil
end

-- A texture made from a virtual texture template, or nil when the client lacks it.
function ns.CreateTextureFromTemplate(parent, layer, template, subLevel)
	if not ns.HasTemplate(template) then return nil end
	local ok, texture = pcall(parent.CreateTexture, parent, nil, layer, template, subLevel)
	if ok then return texture end
	return nil
end

-- Registers each event this client has; one it lacks is skipped instead of raising an error.
function ns.RegisterEvents(frame, ...)
	for index = 1, select("#", ...) do
		pcall(frame.RegisterEvent, frame, (select(index, ...)))
	end
end

function ns.UnregisterEvents(frame, ...)
	for index = 1, select("#", ...) do
		pcall(frame.UnregisterEvent, frame, (select(index, ...)))
	end
end

function ns.AtlasExists(name)
	if not (C_Texture and C_Texture.GetAtlasInfo) then return false end
	local ok, info = pcall(C_Texture.GetAtlasInfo, name)
	return ok and info ~= nil
end

local fileProbe = UIParent:CreateTexture()
fileProbe:Hide()

-- Whether the client has a file. Texture paths are given without their extension; the client's
-- file list may know them only with it, so both are asked.
function ns.FileExists(path)
	if type(GetFileIDFromPath) == "function" then
		local answered = false
		for _, candidate in ipairs({ path, path .. ".blp" }) do
			local ok, fileID = pcall(GetFileIDFromPath, candidate)
			if ok then
				answered = true
				if fileID ~= nil and fileID ~= 0 then return true end
			end
		end
		if answered then return false end
	end
	fileProbe:SetTexture(nil)
	fileProbe:SetTexture(path)
	local fileID = fileProbe:GetTextureFileID()
	return fileID ~= nil and fileID ~= 0
end

-- Uses the atlas when the client has it, the file when it has that, or reports false.
function ns.SetAtlasOrFile(texture, atlas, file)
	if atlas and ns.AtlasExists(atlas) then
		texture:SetAtlas(atlas)
		return true
	end
	if file and ns.FileExists(file) then
		texture:SetTexture(file)
		return true
	end
	return false
end

-- Fills a texture with a gradient from color at fromAlpha on its bottom (or left) edge to
-- toColor (or the same colour) at toAlpha on the top (or right), with whichever gradient
-- call this client has.
function ns.Gradient(texture, orientation, color, fromAlpha, toAlpha, toColor)
	toColor = toColor or color
	local r, g, b = color[1], color[2], color[3]
	local r2, g2, b2 = toColor[1], toColor[2], toColor[3]
	texture:SetColorTexture(1, 1, 1, 1)
	if texture.SetGradient and type(CreateColor) == "function" then
		if pcall(texture.SetGradient, texture, orientation, CreateColor(r, g, b, fromAlpha), CreateColor(r2, g2, b2, toAlpha)) then
			return
		end
	end
	if texture.SetGradientAlpha and pcall(texture.SetGradientAlpha, texture, orientation, r, g, b, fromAlpha, r2, g2, b2, toAlpha) then
		return
	end
	texture:SetColorTexture((r + r2) / 2, (g + g2) / 2, (b + b2) / 2, (fromAlpha + toAlpha) / 2)
end

--[[
	A scroll frame with retail's thin scroll bar, built the way Blizzard's own templates do:
	the bar's offsets are set on the frame, then ScrollFrame_OnLoad attaches it and wires the
	mouse wheel. Content goes on scroll.Child. Without that helper, the wheel still scrolls.
]]
function ns.CreateScrollFrame(parent, barX, barTopY, barBottomY)
	local scroll = CreateFrame("ScrollFrame", nil, parent)
	scroll.scrollBarX, scroll.scrollBarTopY, scroll.scrollBarBottomY = barX or -10, barTopY or -10, barBottomY or 10
	scroll.scrollBarHideIfUnscrollable = true
	scroll.scrollBarHideTrackIfThumbExceedsTrack = true

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)
	scroll.Child = child

	if type(ScrollFrame_OnLoad) == "function" and pcall(ScrollFrame_OnLoad, scroll) then
		return scroll
	end
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local target = self:GetVerticalScroll() - delta * 30
		self:SetVerticalScroll(math.max(0, math.min(self:GetVerticalScrollRange(), target)))
	end)
	return scroll
end

-- A font object by name, or the fallback when this client lacks it.
function ns.Font(name, fallback)
	if _G[name] then return name end
	return fallback
end

function ns.PlaySoundKit(key)
	if SOUNDKIT and SOUNDKIT[key] then PlaySound(SOUNDKIT[key]) end
end

local COIN_ICON = "%d|TInterface\\MoneyFrame\\UI-%sIcon:0:0:2:0|t"

--[[
	The currencies a reward can cost besides coins, by the English name its captured cost gives
	("180 Merchant's Favor"): the currency's id, and the icon for a client that cannot say. From the
	client's own currency table (CurrencyTypes, Forever build 1.60.1.70450): Merchant's Favor is the
	trade camps' currency, which the Azeroth Commerce Authority's and Durotar Supply and Logistics'
	quartermasters take.
]]
local CURRENCIES = { ["Merchant's Favor"] = { id = 3402, icon = 135725 } }
local CURRENCY_TEXT = "%s|T%s:0:0:2:0|t"

-- The client's word for a currency: its name, in the client's language, and its icon.
local function CurrencyIcon(currency)
	if currency.clientName == nil then
		local getInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo
		local ok, info = false, nil
		if type(getInfo) == "function" then ok, info = pcall(getInfo, currency.id) end
		info = ok and type(info) == "table" and info or {}
		currency.clientName = info.name or false
		currency.clientIcon = info.iconFileID
	end
	return currency.clientIcon or currency.icon
end

local function FindCurrency(name)
	if CURRENCIES[name] then return CURRENCIES[name] end
	for _, currency in pairs(CURRENCIES) do
		CurrencyIcon(currency)
		if currency.clientName == name then return currency end
	end
end

-- A cost ("180 Merchant's Favor") as the merchant shows it: each amount with its currency's icon.
-- Nil unless the journal knows every currency in it.
function ns.CostIcons(cost)
	local parts = {}
	for part in tostring(cost or ""):gmatch("[^+]+") do
		local amount, name = part:match("^%s*(%d+)%s+(.-)%s*$")
		local currency = name and FindCurrency(name)
		if not currency then return nil end
		parts[#parts + 1] = CURRENCY_TEXT:format(amount, CurrencyIcon(currency))
	end
	return #parts > 0 and table.concat(parts, " ") or nil
end

-- Coins as icons. The Forever client keeps GetCoinTextureString under C_CurrencyInfo;
-- GetMoneyString (SharedXML), the old global and our own icons are fallbacks.
function ns.MoneyText(copper)
	local formatters = {
		C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString,
		GetMoneyString,
		GetCoinTextureString,
	}
	for index = 1, 3 do
		local format = formatters[index]
		if type(format) == "function" then
			local ok, text = pcall(format, copper)
			if ok and type(text) == "string" and text:find("|T", 1, true) then return text end
		end
	end
	local gold, silver, rest = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
	local parts = {}
	if gold > 0 then parts[#parts + 1] = COIN_ICON:format(gold, "Gold") end
	if silver > 0 then parts[#parts + 1] = COIN_ICON:format(silver, "Silver") end
	if rest > 0 then parts[#parts + 1] = COIN_ICON:format(rest, "Copper") end
	return table.concat(parts, " ")
end

--[[
	Values the client may withhold. Inside dungeons Forever hands addons "secret" values
	for enemy guids and casts; those are treated as unknown rather than compared or stored.
]]
function ns.IsSecret(value)
	if type(issecretvalue) ~= "function" then return false end
	local ok, secret = pcall(issecretvalue, value)
	return ok and secret == true
end

function ns.Readable(value)
	if ns.IsSecret(value) then return nil end
	return value
end

function ns.InInstance()
	local ok, inside = pcall(IsInInstance)
	return ok and ns.Readable(inside) == true
end

function ns.NpcIDFromGUID(guid)
	guid = ns.Readable(guid)
	if type(guid) ~= "string" then return nil end
	local unitType, _, _, _, _, npcID = strsplit("-", guid)
	if unitType == "Creature" or unitType == "Vehicle" then return tonumber(npcID) end
	return nil
end

function ns.ItemIDFromLink(link)
	link = ns.Readable(link)
	if type(link) ~= "string" then return nil end
	return tonumber(link:match("item:(%d+)"))
end

-- The player's map and position, where the client reports one (not inside Forever's own dungeons).
function ns.PlayerMapPosition()
	if not (C_Map and C_Map.GetBestMapForUnit) then return nil end
	local mapID = ns.Readable(C_Map.GetBestMapForUnit("player"))
	if type(mapID) ~= "number" then return nil end
	local position = C_Map.GetPlayerMapPosition(mapID, "player")
	if not position then return mapID end
	local x, y = position:GetXY()
	x, y = ns.Readable(x), ns.Readable(y)
	if type(x) ~= "number" or type(y) ~= "number" then return mapID end
	return mapID, math.floor(x * 10000 + 0.5) / 10000, math.floor(y * 10000 + 0.5) / 10000
end
