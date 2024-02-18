ix.infoMenu = {}
ix.infoMenu.stored = {}
local PLUGIN = PLUGIN

function ix.infoMenu.Add(text)
	table.insert(ix.infoMenu.stored, text)
end

function ix.infoMenu.GetData()
	local character = LocalPlayer():GetCharacter()
	local faction = ix.faction.indices[LocalPlayer():Team()]

	hook.Run("SetInfoMenuData", character, faction)
end

function ix.infoMenu.Display()
	ix.infoMenu.stored = {}     
	ix.infoMenu.GetData()

	ix.infoMenu.open = true
	ix.infoMenu.panel = vgui.Create("ixInfoMenu")
end

function ix.infoMenu.Remove()
	if (IsValid(ix.infoMenu.panel)) then
		ix.infoMenu.panel:Remove()
	end

	ix.infoMenu.panel = nil
	ix.infoMenu.open = false
end 

local PANEL = {}

DEFINE_BASECLASS("DFrame")

function PANEL:Init(logs)
	self.startTime = SysTime()
	self.noAnchor = CurTime() + 0.4
	self.anchorMode = true

	self:SetAlpha(0)
	self:SetSize(564, 64)
	self:ShowCloseButton(false)
	self:MakePopup()
	self:SetTitle("")
	self:SetPos(ScrW()/2.8, ScrH()/2.8)

	self:Populate()
	self.infoBox:InvalidateLayout(true)
    self.infoBox:SizeToChildren(false, true)
	self:BuildMenuPanel()

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)

	self:AlphaTo(255, 0.5)
end

function PANEL:Populate()
	local faction = ix.faction.indices[LocalPlayer():Team()]
	local level = LocalPlayer():GetCharacter():GetLevel()
	local character = LocalPlayer():GetCharacter()
	

	self.titre = self:Add("DLabel")
	self.titre:SetContentAlignment(5)
	self.titre:SetText("INFORMATIONS SUR VOUS")
	self.titre:SetFont("ixInfoPanelTitleFont")
	self.titre:Dock(TOP)
	self.titre:SetTall(50)
	self.titre:DockMargin(0,0,0,10)
	self.titre.Paint = function (s ,w ,h)
		surface.SetDrawColor(color_white)
		surface.DrawRect(0,45,w, 3)
	end

	self.infoBox = self:Add("DPanel")
	self.infoBox:Dock(TOP)
	self.infoBox:DockPadding(5, 5, 5, 5)
	self.infoBox.Paint = function()
		draw.RoundedBox(8,0, 0, self.infoBox:GetWide(), self.infoBox:GetTall(),Color(51,51,51,100))
	end

	local name = LocalPlayer():GetName()
	local money = LocalPlayer():GetCharacter():GetMoney()

	self.name = self.infoBox:Add("DLabel")
	self.name:SetText(name)
	self.name:Dock(TOP)
	self.name:SetFont("CHud3")

	self.faction = self.infoBox:Add("DLabel")
	self.faction:SetText(faction.name)
	self.faction:Dock(TOP)
	self.faction:DockMargin(0,8,0,0)
	self.faction:SetFont("CHud3")

	self.money = self.infoBox:Add("DLabel")
	self.money:SetText(money.." €")
	self.money:Dock(TOP)
	self.money:DockMargin(0,8,0,0)
	self.money:SetFont("CHud3")

	self.pnllevel = self.infoBox:Add("Panel")
	self.pnllevel:Dock(TOP)
	self.pnllevel:DockMargin(0,8,0,0)

	self.pnlbar = self.infoBox:Add("Panel")
	self.pnlbar:Dock(TOP)
	self.pnlbar.Paint = function (s,w,h)
		draw.RoundedBox(8,0,5,w - 5,h - 5,Color(70,70,70,150))

		draw.RoundedBox(8, 2.5, 9, math.min(((w) / (PLUGIN:GetRequiredLevelXP(character:GetLevel()))) * character:GetLevelXP()), h - 13, Color(255, 255, 255, 150))

	end


	self.levelxp1 = self.pnllevel:Add("DLabel")
	self.levelxp1:SetText("Niveau : "..level)
	self.levelxp1:Dock(FILL)
	self.levelxp1:DockMargin(0,0,0,0)
	self.levelxp1:SetFont("CHud3")


	for k, v in pairs(ix.infoMenu.stored) do
		self.infoBox:Add(self:AddLabel(0, v))
	end
end

function PANEL:BuildMenuPanel()
	self.menu = self:Add("ixInteractMenu")
	self.menu:Dock(TOP)
	self.menu:DockMargin(0, 5, 0, 0)

	for k, v in pairs(ix.quickmenu.stored) do
		if (v.shouldShow and v.shouldShow() == true) or !v.shouldShow then
			self.menu:AddOption(k, v)
		end
	end

	self.menu:Build()

	self.initialized = true
end

function PANEL:Paint(w, h)
	--surface.SetDrawColor(0,0,0,125)
    --surface.DrawRect(0, 0, w, h)

	Derma_DrawBackgroundBlur(self, self.startTime)
end

function PANEL:AddLabel(margin, text, colored, title)
	local label = self:Add("DLabel")
	local font = "ixInfoPanelFont"

	if(title) then
		font = "ixInfoPanelTitleFont"
		text = L(text):upper()
	end

	if(colored) then
		label:SetTextColor(ix.config.Get("color"))
	end

	label:SetFont(font)
	label:SetText(text)
	label:SizeToContents()
	label:Dock(TOP)
	label:DockMargin(0, 0, 0, margin)
	return label
end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

	if (key == KEY_F2) then
		ix.infoMenu.Remove()
	end
end

function PANEL:Think()
	-- If the selector no longer exists, exit.
	if(!IsValid(self.menu)) then
		ix.infoMenu.Remove()
	end
 
	local bTabDown = input.IsKeyDown(KEY_F2)

	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.anchorMode = false
	end

	if ((!self.anchorMode and !bTabDown) or gui.IsGameUIVisible()) then
		gui.HideGameUI()
		ix.infoMenu.Remove()
	end

	if(self.initialized and !self.menu.IsVisible) then
		ix.infoMenu.Remove()
	end
end

vgui.Register("ixInfoMenu", PANEL, "DFrame")