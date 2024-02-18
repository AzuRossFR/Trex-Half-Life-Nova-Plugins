local PANEL = {}

function PANEL:Init()
    self.color = Color(15,189,195)
    self.paintW = 0
end

function PANEL:Paint(width, height)
    if self.Hovered then
        self.paintW = Lerp(FrameTime() * 10, self.paintW, width)
    else
        self.paintW = Lerp(FrameTime() * 10, self.paintW, 0)
    end

    surface.SetDrawColor(32,143,146, 50)
    surface.DrawRect(1,1,self.paintW - 1,height - 1)

    surface.SetDrawColor(self.color)
    surface.DrawOutlinedRect(0,0,width,height)
end

vgui.Register("ixStationButton", PANEL, "DButton")

PANEL = {}

function PANEL:Init()
    self.paintW = 0
end

function PANEL:Paint(width, height)
    if self.Hovered then
        self.paintW = Lerp(FrameTime() * 10, self.paintW, width)
    else
        self.paintW = Lerp(FrameTime() * 10, self.paintW, 0)
    end

    surface.SetDrawColor(195,15,15, 50)
    surface.DrawRect(1,1,self.paintW - 1,height - 1)

    surface.SetDrawColor(195,15,15)
    surface.DrawOutlinedRect(0,0,width,height)
end

vgui.Register("ixStationAlertButton", PANEL, "DButton")