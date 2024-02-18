local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	self:SetSize(scrW, scrH)
	self:SetPos(0, 0)

	local text = string.utf8upper(L("youreDead"))

	surface.SetFont("CHud2")
	local textW, textH = surface.GetTextSize(text)

	self.progress = 0

	
	self.label = self:Add("DLabel")
	self.label:SetPaintedManually(true)
	--self.label:SetPos(scrW * 0.425 - textW * 0.5, scrH * 0.5 - textH * 0.5)
	self.label:SetFont("CHud")
	self.label:SetText(("Vous êtes décédé"):utf8upper())
	self.label:SetTextColor(Color(146,9,9))
	self.label:SizeToContents()
	self.label:Center()

	self.label2 = self:Add("DLabel")
	self.label2:SetPaintedManually(true)
	self.label2:SetPos(scrW * 0.305 - textW * 0.5, scrH * 0.55 - textH * 0.5)
	self.label2:SetFont("CHud3")
	self.label2:SetText(("VOUS êtES SOUMIS AU NLR, VOUS N'êtes PAS EN capacité de REVENIR SUR LES LIEUX DE MORT AVANT 5 MINUTES"):utf8upper())
	self.label2:SetTextColor(color_white)
	self.label2:SizeToContents()

	self:CreateAnimation(ix.config.Get("spawnTime", 5), {
		bIgnoreConfig = true,
		target = {progress = 1},

		OnComplete = function(animation, panel)
			if (!panel:IsClosing()) then
				panel:Close()
			end
		end
	})
	hook.Add("HUDShouldDraw", self, function()
        return false
    end)
end

function PANEL:Think()
	self.label:SetAlpha(((self.progress - 0.3) / 0.3) * 255)
	self.label2:SetAlpha(((self.progress - 0.3) / 0.3) * 255)
end

function PANEL:IsClosing()
	return self.bIsClosing
end

function PANEL:Close()
	self.bIsClosing = true

	self:CreateAnimation(2, {
		index = 2,
		bIgnoreConfig = true,
		target = {progress = 0},

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})
end

function PANEL:Paint(width, height)
	--ix.util.DrawBlur(self)

	derma.SkinFunc("PaintDeathScreenBackground", self, width, height, self.progress)

		self.label:PaintManual()
		self.label2:PaintManual()
		
	derma.SkinFunc("PaintDeathScreen", self, width, height, self.progress)
end

vgui.Register("ixDeathScreen", PANEL, "Panel")
