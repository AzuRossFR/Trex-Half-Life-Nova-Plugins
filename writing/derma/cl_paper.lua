local PLUGIN = PLUGIN

local PANEL = {}

AccessorFunc(PANEL, "bEditable", "Editable", FORCE_BOOL)
AccessorFunc(PANEL, "itemID", "ItemID", FORCE_NUMBER)

function PANEL:Init()
    if (IsValid(PLUGIN.panel)) then
        PLUGIN.panel:Remove()
    end

    self:SetSize(350, 400)
    self:Center()
	self:ShowCloseButton(false)
    self:SetBackgroundBlur(false)

    self:SetTitle("")

    self.text = self:Add("ixTextEntry")
    self.text:Dock(FILL)
	self.text:SetFont("CHud3")
	self.text:DockMargin(0,0,0,30)
    self.text:SetMultiline(true)
    self.text:SetEditable(false)
    self.text:SetDisabled(true)

    self.close = self:Add("DButton")
    self.close:Dock(BOTTOM)
    self.close:DockMargin(0, 4, 0, 0)
    self.close:SetText(L("close"))
	self.close:SetFont("CHud3")
    self.close.DoClick = function()
        if (self.bEditable) then
            netstream.Start("ixWritingEdit", self.itemID, self.text:GetValue():sub(1, PLUGIN.maxLength))
        end

        self:Close()
    end

    self.save = self:Add("DButton")
    self.save:Dock(BOTTOM)
    self.save:DockMargin(0, 4, 0, 0)
    self.save:SetText(L("save"))
	self.save:SetFont("CHud3")
    self.save.DoClick = function()
        if (self.bEditable) then
            netstream.Start("ixWritingEdit", self.itemID, self.text:GetValue():sub(1, PLUGIN.maxLength))
        end

    end

    self:MakePopup()

    self.bEditable = false
    PLUGIN.panel = self
end

function PANEL:Think()
    local text = self.text:GetValue()

    if (text:len() > PLUGIN.maxLength) then
        local newText = text:sub(1, PLUGIN.maxLength)

        self.text:SetValue(newText)
        self.text:SetCaretPos(newText:len())

        surface.PlaySound("common/talk.wav")
    end
end

function PANEL:SetEditable(bValue)
    bValue = tobool(bValue)

    if (bValue == self.bEditable) then
        return
    end

    if (bValue) then
        self.save:SetText(L("save"))
        self.close:SetText(L("close"))
        self.text:SetEditable(true)
        self.text:SetDisabled(false)
    else
        self.save:SetText(L("save"))
        self.close:SetText(L("close"))
        self.text:SetEditable(false)
        self.text:SetDisabled(true)
    end

    self.bEditable = bValue
end

function PANEL:SetText(text)
    self.text:SetValue(text)
end

function PANEL:OnRemove()
    PLUGIN.panel = nil
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 200))
end

vgui.Register("ixPaper", PANEL, "DFrame")
