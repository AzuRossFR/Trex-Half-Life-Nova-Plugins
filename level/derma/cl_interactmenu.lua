local PANEL = {}

function PANEL:Init()
    if(IsValid(ix.gui.interactMenu)) then
        ix.gui.interactMenu:Destroy()
    end

    ix.gui.interactMenu = self

    self.options = {}
    self.backgroundColor = Color(0, 0, 0)
end

function PANEL:Build()
    self:SetWide(128)
    self:SetTall(12)

    local newHeight = self:GetTall()
    
    for k, v in pairs(self.options) do
       newHeight = newHeight+24
    end

    self:SetTall(newHeight)
end

function PANEL:AddOption(k, v)
    local option = self:Add("DButton")
    option:SetText("")
    option:Dock(TOP)
    option:SetTall(24)
    option.Paint = function() 
        if(option:IsHovered()) then
            textColor = Color(0,0,0)
            surface.SetDrawColor(90, 90, 90, 150)
            --surface.DrawRect(0, 0, option:GetWide(), option:GetTall())
            draw.RoundedBox(8,0,0,option:GetWide(), option:GetTall(),ColorAlpha(Color(255,255,255), self.currentBackgroundAlpha))
        else
            textColor = color_white
        end
        ix.util.DrawText(v.name, 24, 4, textColor, 0, 0, "ixSmallFont")
    end
    option.DoClick = function()
	LocalPlayer():EmitSound("ABYSS/button3.wav", 30)
        if(v.callback) then
            v.callback()
        end

        self:Destroy()
    end

    if(#self.options < 1) then
        option:DockMargin(6, 6, 6, 0)
    else
        option:DockMargin(6, 0, 6, 0)
    end
    
    if(v.icon) then
        self.icon = option:Add("DImage")
        self.icon:SetSize(12, 12)   
        self.icon:SetPos(4, 6)
        self.icon:SetMaterial(v.icon)
        self.icon.AutoSize = false
    end

    table.insert(self.options, option)
end

function PANEL:Destroy()
    self:Remove()
    ix.gui.interactMenu = nil
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8,0, 0, w, h,Color(51,51,51,100))
end

vgui.Register("ixInteractMenu", PANEL, "DPanel")