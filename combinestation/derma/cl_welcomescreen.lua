local PANEL = {}
local PLUGIN = PLUGIN
local cartelog = Material("trexhln/cartellogo.png","noclamp smooth")
local cplogo = Material("trexhln/cp_logo.png","noclamp smooth")
local terminal
local spinnerSize = 64

function PLUGIN:Think()
    for k, v in ipairs(ents.FindInSphere(LocalPlayer():GetPos(), 150)) do
        if v:GetClass() ==  "ix_civil_station" and IsValid(v) then
            local entityPos = v:GetPos()
            local distanceThreshold = 150
            for _, ply in ipairs(player.GetAll()) do
                if IsValid(ply) then
                    local playerPos = ply:GetPos()
                    local distance = playerPos:Distance(entityPos)
                    if distance <= distanceThreshold then
                        terminal = v
                    end
                end
            end
        end
    end
end

function PANEL:Init()
    self:SetSize(ScrW() / 5, ScrH() / 5)
    self:SetPos(0,0)
    self.colorblue = Color(15,189,195)
    self.WelcomeMenu = self:Add("EditablePanel")
    self.WelcomeMenu:SetPos(0,0)
    self.WelcomeMenu:SetVisible(true)
    self.WelcomeMenu:SetSize(ScrW() / 5, ScrH() / 5)

    self.MainMenu = self:Add("EditablePanel")
    self.MainMenu:SetPos(0,0)
    self.MainMenu:SetVisible(false)
    self.MainMenu:SetSize(ScrW() / 5, ScrH() / 5)

    self.pcmenu = self:Add("EditablePanel")
    self.pcmenu:SetPos(0,0)
    self.pcmenu:SetVisible(false)
    self.pcmenu:SetSize(ScrW() / 5, ScrH() / 5)

    self.warnscreen = self:Add("EditablePanel")
    self.warnscreen:SetPos(0,0)
    self.warnscreen:SetVisible(false)
    self.warnscreen:SetSize(ScrW() / 5, ScrH() / 5)

    self.permitscreen = self:Add("EditablePanel")
    self.permitscreen:SetPos(0,0)
    self.permitscreen:SetVisible(false)
    self.permitscreen:SetSize(ScrW() / 5, ScrH() / 5)

    self.infoscreen = self:Add("EditablePanel")
    self.infoscreen:SetPos(0,0)
    self.infoscreen:SetVisible(false)
    self.infoscreen:SetSize(ScrW() / 5, ScrH() / 5)
    
--[[--------------------START MAIN MENU--------------------]]--
    self.returnbutton = self.MainMenu:Add("DButton")
    self.returnbutton:SetSize(200,30)
    self.returnbutton:SetPos(self:GetWide() / 3.75,self:GetTall() / 1.43)
    self.returnbutton:SetText(string.utf8upper("quitter")) 
    self.returnbutton:SetTextColor(self.colorblue)
    self.returnbutton:SetFont("StationCHud1")
    self.returnbutton.paintW = 0
    self.returnbutton.DoClick = function(s,w,h)
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        surface.PlaySound("trexhla/civil_station_fermer.mp3")
        self.WelcomeMenu:SetVisible(true)
        self.MainMenu:SetVisible(false)
    end
    self.returnbutton.Paint = function(s,w,h)
        if s.Hovered then
            s.paintW = Lerp(FrameTime() * 10, s.paintW, w)
        else
            s.paintW = Lerp(FrameTime() * 10, s.paintW, 0)
        end

        surface.SetDrawColor(32,143,146, 50)
        surface.DrawRect(1,1,s.paintW - 1,h - 1)
    
        surface.SetDrawColor(self.colorblue)
        surface.DrawOutlinedRect(0,0,w,h)
    end

    self.permitbutton = self.MainMenu:Add("DButton")
    self.permitbutton:SetSize(200,30)
    self.permitbutton:SetPos(self:GetWide() / 3.75,self:GetTall() / 1.85)
    self.permitbutton:SetText(string.utf8upper("parcourir les permis")) 
    self.permitbutton:SetTextColor(self.colorblue)
    self.permitbutton:SetFont("StationCHud1")
    self.permitbutton.paintW = 0
    self.permitbutton.DoClick = function(s,w,h)
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
    end
    self.permitbutton.Paint = function(s,w,h)
        if s.Hovered then
            s.paintW = Lerp(FrameTime() * 10, s.paintW, w)
        else
            s.paintW = Lerp(FrameTime() * 10, s.paintW, 0)
        end

        surface.SetDrawColor(32,143,146, 50)
        surface.DrawRect(1,1,s.paintW - 1,h - 1)
    
        surface.SetDrawColor(self.colorblue)
        surface.DrawOutlinedRect(0,0,w,h)
    end

    self.bankbutton = self.MainMenu:Add("DButton")
    self.bankbutton:SetSize(200,30)
    self.bankbutton:SetPos(self:GetWide() / 3.75,self:GetTall() / 2.7)
    self.bankbutton:SetText(string.utf8upper("VOIR VOS INFORMATIONS")) 
    self.bankbutton:SetTextColor(self.colorblue)
    self.bankbutton:SetFont("StationCHud1")
    self.bankbutton.paintW = 0
    self.bankbutton.DoClick = function(s,w,h)
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        self.MainMenu:SetVisible(false)
        self.infoscreen:SetVisible(true)
    end
    self.bankbutton.Paint = function(s,w,h)
        if s.Hovered then
            s.paintW = Lerp(FrameTime() * 10, s.paintW, w)
        else
            s.paintW = Lerp(FrameTime() * 10, s.paintW, 0)
        end

        surface.SetDrawColor(32,143,146, 50)
        surface.DrawRect(1,1,s.paintW - 1,h - 1)
    
        surface.SetDrawColor(self.colorblue)
        surface.DrawOutlinedRect(0,0,w,h)
    end

    self.callcivilprot = self.MainMenu:Add("ixStationButton")
    self.callcivilprot:SetSize(200,30)
    self.callcivilprot:SetPos(self:GetWide() / 3.75,self:GetTall() / 4.8)
    self.callcivilprot:SetText(string.utf8upper("APPELER LA PROTECTION CIVILE")) 
    self.callcivilprot:SetTextColor(self.colorblue)
    self.callcivilprot:SetFont("StationCHud1")
    self.callcivilprot.paintW = 0
    self.callcivilprot.DoClick = function(s,w,h)
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        self.WelcomeMenu:SetVisible(false)
        self.MainMenu:SetVisible(false)
        self.pcmenu:SetVisible(true)
    end

    self.spinner = self:Add("ixHelixSpinner")
    self.spinner:SetSize(spinnerSize, spinnerSize)
    self.spinner:SetPos(self:GetWide() * 0.5 - spinnerSize * 0.3, self:GetTall() * 0.5 - spinnerSize * 0.5)
    self.spinner:SetLarge(true)
    self.spinner:SetFrequency(0.8)
    self.spinner:SetPaintedManually(true)
    self.spinner:SetVisible(false)
    self.spinner:SetColor(self.colorblue)

    self.welcomebutton = self.WelcomeMenu:Add("ixStationButton")
    self.welcomebutton:SetSize(200,30)
    self.welcomebutton:SetPos(self:GetWide() / 3.75,self:GetTall() / 2.3)
    self.welcomebutton:SetText(string.utf8upper("APPUYEZ POUR ACCEDER"))
    self.welcomebutton:SetTextColor(self.colorblue)
    self.welcomebutton:SetFont("StationCHud1")
    self.welcomebutton.paintW = 0
    self.welcomebutton.DoClick = function(s,w,h)
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        surface.PlaySound("trexhla/civil_station_ouvert.mp3")
        self.WelcomeMenu:SetVisible(false)
        self.spinner:SetVisible(true)
        timer.Simple(math.random(.5,1.5),function()
            self.spinner:SetVisible(false)
            self.MainMenu:SetVisible(true)
        end)
    end

    local format = ix.option.Get("24hourTime", false) and "%A %d %B %Y. %H:%M"
    self.labelhour = self:Add("DLabel")
    self.labelhour:SetSize(200,30)
    self.labelhour:SetPos(self:GetWide() / 3.5,self:GetTall() / 1.15)
    self.labelhour:SetText(ix.date.GetFormatted(format))
    self.labelhour:SetTextColor(self.colorblue)
    self.labelhour:SetFont("StationCHud1")
    self.labelhour.Think = function()
        if self.labelhour:GetText() != ix.date.GetFormatted(format) then
            self.labelhour:SetText(ix.date.GetFormatted(format))
        end
    end

    self.labelhourred = self:Add("DLabel")
    self.labelhourred:SetSize(200,30)
    self.labelhourred:SetPos(self:GetWide() / 3.35,self:GetTall() / 1.15)
    self.labelhourred:SetText(ix.date.GetFormatted(format))
    self.labelhourred:SetTextColor(Color(195,15,15))
    self.labelhourred:SetVisible(false)
    self.labelhourred:SetFont("StationCHud1")
    self.labelhourred.Think = function()
        if self.labelhourred:GetText() != ix.date.GetFormatted(format) then
            self.labelhourred:SetText(ix.date.GetFormatted(format))
        end
    end

    self.civilstation = self:Add("DLabel")
    self.civilstation:SetSize(200,30)
    self.civilstation:SetPos(self:GetWide() / 1.8,self:GetTall() / 26)
    self.civilstation:SetText(string.utf8upper("Station Civile T.R.3.X"))
    self.civilstation:SetTextColor(self.colorblue)
    self.civilstation:SetFont("StationCHud1")

    self.civilstationred = self:Add("DLabel")
    self.civilstationred:SetSize(200,30)
    self.civilstationred:SetPos(self:GetWide() / 1.8,self:GetTall() / 26)
    self.civilstationred:SetText(string.utf8upper("Station Civile T.R.3.X"))
    self.civilstationred:SetTextColor(Color(195,15,15))
    self.civilstationred:SetVisible(false)
    self.civilstationred:SetFont("StationCHud1")

    self.cartellogo = self:Add("DPanel")
    self.cartellogo:SetSize(20,20)
    self.cartellogo:SetPos(self:GetWide() / 1.13,self:GetTall() / 23)
    self.cartellogo.Paint = function (s,w,h)
        surface.SetDrawColor(self.colorblue)
        surface.SetMaterial(cartelog)
        surface.DrawTexturedRect(0,0,w,h)
    end

    self.cartellogored = self:Add("DPanel")
    self.cartellogored:SetSize(20,20)
    self.cartellogored:SetPos(self:GetWide() / 1.13,self:GetTall() / 23)
    self.cartellogored:SetVisible(false)
    self.cartellogored.Paint = function (s,w,h)
        surface.SetDrawColor(Color(195,15,15))
        surface.SetMaterial(cartelog)
        surface.DrawTexturedRect(0,0,w,h)
    end

    self.sep1 = self:Add("DPanel")
    self.sep1:SetSize(self:GetWide() / 1.2,2)
    self.sep1:SetPos(40,self:GetTall() / 6)
    self.sep1.Paint = function (s,w,h)
        surface.SetDrawColor(self.colorblue)
        surface.DrawRect(0,0,w,h)
    end

    self.sep1red = self:Add("DPanel")
    self.sep1red:SetSize(self:GetWide() / 1.2,2)
    self.sep1red:SetPos(40,self:GetTall() / 6)
    self.sep1red:SetVisible(false)
    self.sep1red.Paint = function (s,w,h)
        surface.SetDrawColor(Color(195,15,15))
        surface.DrawRect(0,0,w,h)
    end

    self.sep2 = self:Add("DPanel")
    self.sep2:SetSize(self:GetWide() / 1.2,2)
    self.sep2:SetPos(40,self:GetTall() / 1.15)
    self.sep2.Paint = function (s,w,h)
        surface.SetDrawColor(self.colorblue)
        surface.DrawRect(0,0,w,h)
    end

    self.sep2red = self:Add("DPanel")
    self.sep2red:SetSize(self:GetWide() / 1.2,2)
    self.sep2red:SetPos(40,self:GetTall() / 1.15)
    self.sep2red:SetVisible(false)
    self.sep2red.Paint = function (s,w,h)
        surface.SetDrawColor(Color(195,15,15))
        surface.DrawRect(0,0,w,h)
    end
--[[--------------------END MAIN MENU--------------------]]--

--[[--------------------START PC MENU--------------------]]--

    self.callpc = self.pcmenu:Add("EditablePanel")
    self.callpc:SetSize(200,110)
    self.callpc:SetPos(self:GetWide() / 3.75,self:GetTall() / 4.8)
    self.callpc.Paint = function(s,w,h)
        local sinalpha = TimedSin(.65, 45, 155, 0)
        surface.SetDrawColor(Schema:LerpColor(sinalpha/50,Color(32,143,146,50),Color(15,189,195)))
        surface.SetMaterial(cplogo)
        surface.DrawTexturedRect(s:GetWide() / 3.15,s:GetTall() - 115,w / 2.5,h / 1.5)

        surface.SetDrawColor(32,143,146,50)
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(self.colorblue)
        surface.DrawOutlinedRect(0,0,w,h,2)
    end

    self.warning = self.callpc:Add("DLabel")
    self.warning:SetSize(200,30)
    self.warning:SetPos(self:GetWide() / 5.5, self:GetTall() / 4.1)
    self.warning:SetText(string.utf8upper([[ATTENTION !]]))
    self.warning:SetTextColor(self.colorblue)
    self.warning:SetFont("StationCHud1")

    self.warning2 = self.callpc:Add("DLabel")
    self.warning2:SetSize(200,30)
    self.warning2:SetPos(self:GetWide() / 9.2, self:GetTall() / 3.1)
    self.warning2:SetText(string.utf8upper([[            UNE FAUSSE ALERTE 
    ENTRAINERA UNE SANCTION !]]))
    self.warning2:SetTextColor(self.colorblue)
    self.warning2:SetFont("StationCHud.warn")

    self.returnpcbutton = self.pcmenu:Add("ixStationButton")
    self.returnpcbutton:SetSize(70,20)
    self.returnpcbutton:SetPos(self:GetWide() / 3.2,self:GetTall() / 1.35)
    self.returnpcbutton:SetText(string.utf8upper("RETOUR")) 
    self.returnpcbutton:SetTextColor(self.colorblue)
    self.returnpcbutton:SetFont("StationCHud1")
    self.returnpcbutton.paintW = 0
    self.returnpcbutton.DoClick = function(s,w,h)
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        surface.PlaySound("trexhla/civil_station_fermer.mp3")
        self.WelcomeMenu:SetVisible(false)
        self.pcmenu:SetVisible(false)
        self.MainMenu:SetVisible(true)
    end

    self.buttonnet = self.pcmenu:Add("ixStationButton")
    self.buttonnet:SetSize(70,20)
    self.buttonnet:SetPos(self:GetWide() / 1.8,self:GetTall() / 1.35)
    self.buttonnet:SetText(string.utf8upper("VALIDER")) 
    self.buttonnet:SetTextColor(self.colorblue)
    self.buttonnet:SetFont("StationCHud1")
    self.buttonnet.paintW = 0
    self.buttonnet.DoClick = function(s,w,h)
        if LocalPlayer():IsCombine() then return LocalPlayer():Notify("Vous ne pouvez pas appelez une unité de la PC en tant qu'unité de la PC.") or surface.PlaySound("trexhla/civil_station_refus.mp3")  end
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        surface.PlaySound("trexhla/civil_station_fermer.mp3")

        
        self.WelcomeMenu:SetVisible(false)
        self.pcmenu:SetVisible(false)
        self.MainMenu:SetVisible(false)
        self.warnscreen:SetVisible(true)

        self.sep1:SetVisible(false)
        self.sep2:SetVisible(false)
        self.labelhour:SetVisible(false)
        self.cartellogo:SetVisible(false)
        self.civilstation:SetVisible(false)

        self.labelhourred:SetVisible(true)
        self.sep1red:SetVisible(true)
        self.sep2red:SetVisible(true)
        self.cartellogored:SetVisible(true)
        self.civilstationred:SetVisible(true)

        net.Start("ixTerminalRequest")
        net.SendToServer()
    end

    self.alertpc = self.warnscreen:Add("EditablePanel")
    self.alertpc:SetSize(200,110)
    self.alertpc:SetPos(self:GetWide() / 3.75,self:GetTall() / 4.8)
    self.alertpc.Paint = function(s,w,h)
        local sinalpha = TimedSin(.65, 45, 155, 0)
        surface.SetDrawColor(Schema:LerpColor(sinalpha/50,Color(195,15,15,50),Color(195,15,15)))
        surface.SetMaterial(cplogo)
        surface.DrawTexturedRect(s:GetWide() / 3.15,s:GetTall() - 115,w / 2.5,h / 1.5)

        surface.SetDrawColor(195,15,15,100)
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(195,15,15)
        surface.DrawOutlinedRect(0,0,w,h,2)
    end

    self.alertpc1 = self.alertpc:Add("DLabel")
    self.alertpc1:SetSize(200,30)
    self.alertpc1:SetPos(self:GetWide() / 5.9, self:GetTall() / 4.1)
    self.alertpc1:SetText(string.utf8upper([[PATIENTEZ ICI]]))
    self.alertpc1:SetTextColor(Color(223,4,4))
    self.alertpc1:SetFont("StationCHud1")

    self.alertpc2 = self.alertpc:Add("DLabel")
    self.alertpc2:SetSize(200,30)
    self.alertpc2:SetPos(self:GetWide() / 9.2, self:GetTall() / 3.1)
    self.alertpc2:SetText(string.utf8upper([[               UNE UNITE DE LA 
    PROTECTION CIVILE ARRIVE !]]))
    self.alertpc2:SetTextColor(Color(223,4,4))
    self.alertpc2:SetFont("StationCHud.warn")

if LocalPlayer():IsCombine()  then
    self.returnpcwarnbutton = self.warnscreen:Add("ixStationAlertButton")
    self.returnpcwarnbutton:SetSize(200,20)
    self.returnpcwarnbutton:SetPos(self:GetWide() / 3.75,self:GetTall() / 1.35)
    self.returnpcwarnbutton:SetText(string.utf8upper("STOPPER L'ALERTE")) 
    self.returnpcwarnbutton:SetTextColor(Color(223,4,4))
    self.returnpcwarnbutton:SetFont("StationCHud1")
    self.returnpcwarnbutton.paintW = 0
    self.returnpcwarnbutton.DoClick = function(s,w,h)
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        surface.PlaySound("trexhla/civil_station_fermer.mp3")
        self.WelcomeMenu:SetVisible(false)
        self.pcmenu:SetVisible(false)
        self.warnscreen:SetVisible(false)
        self.MainMenu:SetVisible(true)

        self.sep1:SetVisible(true)
        self.sep2:SetVisible(true)
        self.labelhour:SetVisible(true)
        self.cartellogo:SetVisible(true)
        self.civilstation:SetVisible(true)
        
        self.labelhourred:SetVisible(false)
        self.sep1red:SetVisible(false)
        self.sep2red:SetVisible(false)
        self.cartellogored:SetVisible(false)
        self.civilstationred:SetVisible(false)

        net.Start("ixTerminalStopRequest")
        net.SendToServer()
    end
end

    if IsValid(terminal) then
        if terminal:IsAlerting() then
            self.permitscreen:SetVisible(false)
            self.pcmenu:SetVisible(false)
            self.MainMenu:SetVisible(false)
            self.WelcomeMenu:SetVisible(false)
            self.warnscreen:SetVisible(true )
        
            self.sep1:SetVisible(false)
            self.sep2:SetVisible(false)
            self.labelhour:SetVisible(false)
            self.cartellogo:SetVisible(false)
            self.civilstation:SetVisible(false)
        
            self.labelhourred:SetVisible(true)
            self.sep1red:SetVisible(true)
            self.sep2red:SetVisible(true)
            self.cartellogored:SetVisible(true)
            self.civilstationred:SetVisible(true)
        end
    end
--[[--------------------END PC MENU--------------------]]--

--[[--------------------START INFO MENU--------------------]]--
    self.infobloc = self.infoscreen:Add("EditablePanel")
    self.infobloc:SetSize(320,110)
    self.infobloc:SetPos(self:GetWide() / 9.5,self:GetTall() / 4.8)
    self.infobloc.Paint = function(s,w,h)
        surface.SetDrawColor(32,143,146,50)
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(self.colorblue)
        surface.DrawOutlinedRect(0,0,w,h,2)
    end

    self.returninfobutton = self.infoscreen:Add("ixStationButton")
    self.returninfobutton:SetSize(320,20)
    self.returninfobutton:SetPos(self:GetWide() / 9.5,self:GetTall() / 1.35)
    self.returninfobutton:SetText(string.utf8upper("RETOUR")) 
    self.returninfobutton:SetTextColor(self.colorblue)
    self.returninfobutton:SetFont("StationCHud1")
    self.returninfobutton.paintW = 0
    self.returninfobutton.DoClick = function()
        surface.PlaySound("trexhla/civil_station_appuie.mp3")
        surface.PlaySound("trexhla/civil_station_fermer.mp3")
        self.infoscreen:SetVisible(false)
        self.MainMenu:SetVisible(true)
    end

end



vgui.Register("ixWelcomeScreen", PANEL, "EditablePanel")