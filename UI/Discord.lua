local _, ns = ...
local L = ns.L

--[[
	The journal's Discord, where testers post what they recorded, and the Log Reader page, which
	adds a combat log's boss spells to a recording. The game cannot open a browser, so a link
	sits in a box that picks it out when clicked: Ctrl+C copies it. Typing in the box puts the
	link back. On a parchment page (onParchment) the box gets a dark ground, so its light text
	reads, and the hint the page's ink.
]]
ns.DISCORD_URL = "https://discord.gg/Hr66t25vE7"
ns.LOG_READER_URL = "https://torchlite-bit.github.io/Aegis_Forever_Instance_Journal/log-reader/"

-- A dark ground behind an input box on a parchment page, where its light text would not read.
function ns.DarkenInputBox(box)
	box.Ground = box:CreateTexture(nil, "BACKGROUND", nil, -8)
	box.Ground:SetPoint("TOPLEFT", -5, -1)
	box.Ground:SetPoint("BOTTOMRIGHT", 0, 1)
	box.Ground:SetColorTexture(0.1, 0.07, 0.04, 0.85)
	return box
end

function ns.CreateDiscordLink(parent, width, onParchment)
	return ns.CreateLinkBox(parent, ns.DISCORD_URL, width, onParchment)
end

function ns.CreateLinkBox(parent, url, width, onParchment)
	local box = ns.CreateFrameWithTemplate("EditBox", nil, parent, "InputBoxTemplate")
	box:SetSize(width or 210, 22)
	if onParchment then ns.DarkenInputBox(box) end
	box:SetAutoFocus(false)
	box:SetText(url)
	box:SetCursorPosition(0)
	box:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	box:SetScript("OnEditFocusLost", function(self)
		self:HighlightText(0, 0)
		self:SetCursorPosition(0)
	end)
	box:SetScript("OnTextChanged", function(self, userInput)
		if userInput then
			self:SetText(url)
			self:HighlightText()
		end
	end)
	box:SetScript("OnMouseUp", function(self)
		self:SetFocus()
		self:HighlightText()
	end)
	box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	box:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	box.Hint = box:CreateFontString(nil, "OVERLAY", onParchment and "GameFontBlack"
		or ns.Font("GameFontDisableSmall", "GameFontNormalSmall"))
	box.Hint:SetPoint("LEFT", box, "RIGHT", 8, 0)
	box.Hint:SetText(L.DISCORD_COPY_HINT)
	if onParchment then
		local ink = ns.PARCHMENT_TEXT_COLOR
		box.Hint:SetTextColor(ink[1], ink[2], ink[3])
	end
	return box
end
