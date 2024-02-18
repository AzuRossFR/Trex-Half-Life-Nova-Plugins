    function ENT:OnPopulateEntityInfo(tooltip)
        local definition = ix.container.stored[self:GetModel():lower()]

        surface.SetFont("ixIconsSmall")

        local title = tooltip:AddRow("name")
        title:SetImportant()
        title:SetText("Poubelle")
        title:SetBackgroundColor(ix.config.Get("color"))
        title:SetTextInset(5, 0)
        title:SizeToContents()
    end