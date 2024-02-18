hook.Add("CreateMenuButtons", "ixInventory", function(tabs)
    if (hook.Run("CanPlayerViewInventory") == false) then
        return
    end

    tabs["inv"] = {
        bDefault = true,
        Create = function(info, container)
            local characterPanel = container:Add("Panel")
            characterPanel:Dock(RIGHT)
            characterPanel:SetSize(ScrW() / 3)
            characterPanel:DockMargin(0,50,0,0)

            ix.gui.containerCharPanel = characterPanel

			local canvas = container:Add("DTileLayout")
			local canvasLayout = canvas.PerformLayout
			canvas.PerformLayout = nil
			canvas:SetBorder(0)
			canvas:SetSpaceX(2)
			canvas:SetSpaceY(2)
			canvas:Dock(LEFT)
            canvas:SetWide(ScrW() / 3.8)
			ix.gui.menuInventoryContainer = canvas

			local panel = canvas:Add("ixInventory")
			panel:SetPos(0, ScrH() / 4)
			panel:SetDraggable(false)
			panel:SetSizable(false)
			panel:SetTitle(nil)
			panel.bNoBackgroundBlur = true
			panel.childPanels = {}

            local equipPanel = characterPanel:Add("ixEquipment")
            equipPanel:SetCharacter(LocalPlayer():GetCharacter())
            equipPanel:Dock(FILL)

            ix.gui.menuInventoryContainer = canvas


            local inventory = LocalPlayer():GetCharacter():GetInventory()
            local equipment = LocalPlayer():GetCharacter():GetEquipment()

            if (inventory) then
                panel:SetInventory(inventory)
            end
            

            ix.gui.inv1 = panel

            if(equipment) then
                if (ix.option.Get("openBags", true)) then
                    for _, v in pairs(equipment:GetItems()) do
                        if (!v.isBag) then
                            continue
                        end

                        v.functions.View.OnClick(v)
                    end
                end
            end
            local character = LocalPlayer():GetCharacter()
            local carry = character:GetData("carry", 0)
            local maxWeight = ix.config.Get("maxWeight", 30)

            local w, h = panel:GetSize()


            local weight = panel:Add("DPanel")
                weight:SetPos(0, h - 32)
                weight:SetSize(w, 24)
                weight.Paint = function(self, w, h)
                    draw.RoundedBoxEx(24,0, 0, w, h,Color(0, 0, 0, 100),false,false,false ,false)
                end
                local bar = weight:Add("DPanel")
                    bar:SetSize(w, 24)
                    bar.Paint = function(self)
                        draw.RoundedBoxEx(8,4, 4, math.min(((w - 8) / maxWeight) * carry, w - 8), 16,Color(138,138,138),false,false,false ,false )
                    end
                local barO = weight:Add("DPanel")
                    barO:SetSize(w, 24)
                    barO.Paint = function(self)
                        if (carry > maxWeight) then
                            draw.RoundedBoxEx(8,4, 4, math.min(((w - 8) / maxWeight) * (carry - maxWeight), w - 8), 16,Color(205, 50, 50), false,false,false ,false )
                        end
                    end
                local barT = weight:Add("DLabel")
                    barT:SetSize(w, 24)
                    barT:SetContentAlignment(5)
                    barT:SetFont("CHud3.5")
                    barT.Think = function()
                        carry = character:GetData("carry", 0)
                        barT:SetText(math.Round(carry, 2).." kg / "..maxWeight.." kg")
                        barT:SetContentAlignment(5)
                        barT:SetTextInset(5,0)
                    end
            ix.gui["inv"..LocalPlayer():GetCharacter():GetEquipID()] = equipPanel
        end
    }
end)

hook.Add("PostRenderVGUI", "ixInvHelper", function()
    local pnl = ix.gui.inv1

    hook.Run("PostDrawInventory", pnl)
end)