local PANEL = {}
local gradl = surface.GetTextureID("vgui/gradient-l")
local icons = {
	Material("trex/new.png"),
	Material("trex/chars.png"),
	Material("trex/icon24.png"),
	Material("trex/info.png"),
	Material("trex/exit.png"),
	Material("trex/verifier.png"),
	Material("trex/trash.png"),
}
local btnColors = {
	[1] = {
		Color(247, 247, 247),
		Color(247, 247, 247),
		Color(247, 247, 247),
		Color(247, 247, 247),
		Color(247, 247, 247),
		Color(247, 247, 247)
	},
	[2] = {
		Color(187, 0, 0),
		Color(248, 56, 56),
		Color(187, 0, 0),
		Color(96, 10, 10),
		Color(187, 0, 0),
		Color(201, 45, 45)
	},
}

function PANEL:Init()
	self.BaseClass.SetText(self, "")
    self.paintW = 0
	self.paintH = 0
	self:SetSize(42, 50)
	self:SetTextColor(btnColors[1][1])
	self:SetFont("trex.main.btn")
	self:SetTextInset(32 + 13, 0)
	self:SetContentAlignment(4)

	self.text = ""
	self.icon = 0
end

function PANEL:SetText(value)
	self.text = value
end

function PANEL:SetIcon(ico)
	self.icon = math.Clamp(ico, 0, #icons)
end

function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound("willardnetworks/datapad/navigate.wav")
end

function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

	LocalPlayer():EmitSound("willardnetworks/datapad/navigate2.wav")

	if (code == MOUSE_LEFT and self.DoClick) then
		self:DoClick(self)
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick(self)
	end
end

local bg = Material("nova/main/btn_background.png")
local clrBG = Color(45, 162, 201, 255)

function PANEL:Paint(w, h)
	local clr = self:IsHovered() and 2 or 1
	local color = btnColors[clr]

	surface.SetDrawColor(color[1])
	surface.DrawRect(0, 0, 32, h)

	local x = 32

	surface.SetDrawColor(color[6])
	surface.SetMaterial(bg)
	surface.DrawTexturedRect(32, 1, w - 1, h - 2)

	surface.SetDrawColor(color[2])
	surface.DrawLine(x, 0, w - 1, 0)
	surface.DrawLine(x, h - 1, w - 1, h - 1)
	surface.DrawLine(w - 1, 1, w - 1, h - 1)

	surface.SetDrawColor(color[3])
	surface.DrawLine(w - 1, h - 1, x + w, h - 1)
	surface.DrawLine(w - 1, 0, x + w, 0)

	surface.SetFont("trex.main.btn")
	local textW, textH = surface.GetTextSize(self.text)
	local x, y = 32 + 13, h / 2 - textH / 2

	surface.SetFont("trex.main.btn")
	surface.SetTextColor(color[1])
	surface.SetTextPos(x + 5, y)
	surface.DrawText(self.text, true)

	if self.icon > 0 then
		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(icons[self.icon])
		surface.DrawTexturedRect(0, h / 2 - 16, 32, 32)
	end
end

vgui.Register("trexbutton", PANEL, "DButton")

PANEL = {}
function PANEL:Init()
	self.BaseClass.SetText(self, "")
	self.currentBackgroundAlpha = 0
	self:SetSize(42, 50)
    self.paintW = 0
	self.paintH = 0
	self:SetTextColor(btnColors[1][1])
	self:SetFont("trex.main.btn")
	self:SetTextInset(32 + 13, 0)
	self:SetContentAlignment(4)

	self.text = ""
	self.icon = 0
end

function PANEL:SetText(value)
	self.text = value
end

function PANEL:SetIcon(ico)
	self.icon = math.Clamp(ico, 0, #icons)
end

function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound("Helix.Rollover")
end

function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

	LocalPlayer():EmitSound("Helix.Press")

	if (code == MOUSE_LEFT and self.DoClick) then
		self:DoClick(self)
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick(self)
	end
end

function PANEL:Paint(w, h)
	local clr = self:IsHovered() and 2 or 1
	local color = btnColors[clr]

	surface.SetDrawColor(color[1])
	surface.DrawRect(0, 0, 32, h)

	local x = 32

	surface.SetDrawColor(color[6])
	surface.SetMaterial(bg)
	surface.DrawTexturedRect(32, 1, w - 1, h - 2)

	surface.SetDrawColor(color[2])
	surface.DrawLine(x, 0, w - 1, 0)
	surface.DrawLine(x, h - 1, w - 1, h - 1)
	surface.DrawLine(w - 1, 1, w - 1, h - 1)

	surface.SetDrawColor(color[3])
	surface.DrawLine(w - 1, h - 1, x + w, h - 1)
	surface.DrawLine(w - 1, 0, x + w, 0)

	surface.SetFont("trex.main.btn")
	local textW, textH = surface.GetTextSize(self.text)
	local x, y = 32 + 13, h / 2 - textH / 2

	surface.SetFont("trex.main.btn")
	surface.SetTextColor(color[1])
	surface.SetTextPos(x + 5, y)
	surface.DrawText(self.text, true)

	if self.icon > 0 then
		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(icons[self.icon])
		surface.DrawTexturedRect(0, h / 2 - 16, 32, 32)
	end
end


vgui.Register("trexbuttoninverser", PANEL, "DButton")

PANEL = {}

function PANEL:Init()
	self.BaseClass.SetText(self, "")

	self:SetSize(42, 50)

	self:SetTextColor(btnColors[1][1])
	self:SetFont("trex.main.btn")
	self:SetTextInset(32 + 13, 0)
	self:SetContentAlignment(4)

	self.text = ""
	self.icon = 0
end

function PANEL:SetText(value)
	self.text = value
end

function PANEL:SetIcon(ico)
	self.icon = math.Clamp(ico, 0, #icons)
end

function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound("Helix.Rollover")
end

function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

	LocalPlayer():EmitSound("Helix.Press")

	if (code == MOUSE_LEFT and self.DoClick) then
		self:DoClick(self)
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick(self)
	end
end

function PANEL:Paint(w, h)
	local clr = self:IsHovered() and 2 or 1
	local color = btnColors[clr]

	surface.SetDrawColor(color[1])
	--draw.RoundedBoxEx(8,0, 0, 40, h,color[1],false ,false ,false,false)



	surface.SetFont("trex.main.btn")
	local textW, textH = surface.GetTextSize(self.text)
	local x, y = 32 + 13, h / 2 - textH / 2

	surface.SetFont("trex.main.btn")
	surface.SetTextColor(color[1])
	surface.SetTextPos(x + 5, y)
	surface.DrawText(self.text, true)

	if self.icon > 0 then
		surface.SetDrawColor(color[1])
		surface.SetMaterial(icons[self.icon])
		surface.DrawTexturedRect(4.5, h / 2 - 16, 32, 32)
	end
end

vgui.Register("trexbuttonv2", PANEL, "DButton")