local PANEL = {}
PANEL.IsEquipment = true
local PLUGIN = PLUGIN
local iconSize = ScrW() / 19
MAX_EQUIPMENT_SLOTS = 16

EQUIP_HEAD = 1
EQUIP_CLE = 2
EQUIP_PELLE = 3
EQUIP_MASK = 4
EQUIP_TORSO = 5
EQUIP_HANDS = 6
EQUIP_LEGS = 7
EQUIP_TENUE = 8
EQUIP_SHIRT = 9
EQUIP_RADIO = 10
EQUIP_BANDANA = 11
EQUIP_RHAND = 12
EQUIP_PINCE = 13
EQUIP_ARMEP = 14
EQUIP_ARMES = 15
EQUIP_AMNESIC = 16


PLUGIN.slotPlacements = {
    [EQUIP_HEAD] = {icon = Material("trex/ui/casque.png")},
    [EQUIP_TORSO] = {icon = Material("trex/ui/kevlar.png")},
    [EQUIP_SHIRT] = {icon = Material("trex/ui/shirt.png")},
    [EQUIP_RADIO] = {icon = Material("trex/ui/radio.png")},
    [EQUIP_AMNESIC] = {icon = Material("trex/ui/main.png")},
    [EQUIP_MASK] = {icon = Material("trex/ui/tenue.png")},
    [EQUIP_ARMES] = {icon = Material("trex/ui/armes.png")},
    [EQUIP_ARMEP] = {icon = Material("trex/ui/armep.png")},
    [EQUIP_CLE] = {icon = Material("trex/ui/cle.png")},
    [EQUIP_PINCE] = {icon = Material("trex/ui/pince.png")},
    [EQUIP_PELLE] = {icon = Material("trex/ui/pelle.png")},
}

-- Called when this panel has been created.
function PANEL:Init()
	ix.gui.equipment = self

	self:Dock(FILL)
	self.panels = {}
	
	self:Receiver("ixInventoryItem", self.ReceiveDrop)
end

-- Called when we are setting the target of the character panel
function PANEL:SetCharacter(character, equipment)

    self.model = self:Add("ixTrexModelPanel")
    self.model:Dock(FILL)
    self.model:SetFOV(42)
    self.model:SetLookAt(Vector(0, 0, 38))
    self.model:SetAlpha(255)

    
    self.character = character
    
    self:SetEquipment(equipment or self:GetCharacter():GetEquipment())
end


-- Returns the character tied to this character panel.
function PANEL:GetCharacter()
	if(self.character) then
		return self.character
	end

	return nil
end

function PANEL:OnTransfer(oldX, oldY, x, slot, oldInventory, noSend)
	local inventories = ix.item.inventories
	local inventory = inventories[oldInventory.invID]
	local inventory2 = inventories[self.invID]
	local item

	if (inventory) then
		item = inventory:GetItemAt(oldX, oldY)

		if (!item) then
			return false
		end

		local a, b = hook.Run("CanTransferEquipment", item, inventory, inventory2, slot)
		if (a == false) then
			if b then
				LocalPlayer():NotifyLocalized(b)
			end

			return false
		end

		if (item.CanTransfer and
			item:CanTransfer(inventory, inventory != inventory2 and inventory2 or nil, slot) == false) then
			return false
		end
		
	end

	if (!noSend) then
		net.Start("ixInventoryMove")
			net.WriteUInt(oldX, 6)
			net.WriteUInt(oldY, 6)
			net.WriteUInt(1, 6)
			net.WriteUInt(slot, 6)
			net.WriteUInt(oldInventory.invID, 32)
			net.WriteUInt(self != oldInventory and self.invID or oldInventory.invID, 32)
		net.SendToServer()
	end

	if (inventory) then
		inventory.slots[oldX][oldY] = nil
	end

	if (item and inventory2) then
		inventory2.slots[1] = inventory2.slots[1] or {}
		inventory2.slots[1][slot] = item
	end
end

-- Called when the panel receives a drop. Used to stop items from dropping to world if they are dropped on the panel's empty space.
function PANEL:ReceiveDrop(panels, bDropped, menuIndex, x, y)
	return 
end

function PANEL:Think()
	if(IsValid(ix.gui.menu) and ix.gui.menu.bClosing) then
		if(self.model) then
			self.model:Remove()
		end
	end

	local character = self:GetCharacter()

	if(character and IsValid(self.model)) then
		if(character:GetPlayer():GetModel() != self.model:GetModel()) then
			self:UpdateModel()
		end

		if (character:GetPlayer():GetBodyGroups() != self.model.Entity:GetBodyGroups()) then
			for i = 0, (self:GetCharacter():GetPlayer():GetNumBodyGroups() - 1) do
				self.model.Entity:SetBodygroup(i, self:GetCharacter():GetPlayer():GetBodygroup(i))
			end
		end

		local showSlots = hook.Run("CharPanelCanUse", character:GetPlayer())

		if(showSlots != false) then
			showSlots = true
		end

		self:ToggleSlots(showSlots)
	end
end

-- Helper function to set the visibility of the slots.
function PANEL:ToggleSlots(bShow)
	for k, v in pairs(self.slots or {}) do
		if(IsValid(v)) then
			v:SetVisible(bShow)
		end
	end
end

function PANEL:UpdateModel()
	if (IsValid(self.model)) then
		self.model:SetModel(self:GetCharacter().model or self:GetCharacter():GetPlayer():GetModel(), self:GetCharacter().vars.skin or self:GetCharacter():GetData("skin", 0))

		for i = 0, (self:GetCharacter():GetPlayer():GetNumBodyGroups() - 1) do
			self.model.Entity:SetBodygroup(i, self:GetCharacter():GetPlayer():GetBodygroup(i))
		end

		self.model.Entity.ProxyOwner = LocalPlayer()
	end
end


-- Called when we are assigning all the character panel data to this panel.
function PANEL:SetEquipment(charPanel)
	self.invID = charPanel:GetID()

	self:BuildSlots();

	for x, items in pairs(charPanel.slots) do
		for y, data in pairs(items) do
			if (!data.id) then continue end

			local item = ix.item.instances[data.id]

			if (item and !IsValid(self.panels[item.id])) then
				self:PerformLayout()
				local icon = self:AddIcon(
					item:GetModel() or "models/props_junk/popcan01a.mdl", nil, item.slot, item.width, item.height, item:GetSkin()
				)

				if (IsValid(icon)) then
					icon:SetHelixTooltip(function(tooltip)
						ix.hud.PopulateItemTooltip(tooltip, item)
					end)

					icon.itemID = item.id
					self.panels[item.id] = icon
				end

				self.slots[item.slot].isEmpty = false
			end
		end
	end
end

function PANEL:GetIconPlacement(category)
	return PLUGIN.slotPlacements[category]
end

function PANEL:BuildSlots()
    self.slots = self.slots or {}
    local faction = LocalPlayer():GetCharacter():GetFaction()

    for k, v in pairs(PLUGIN.slotPlacements) do
        local isCITOYEN = faction == FACTION_CITIZEN
        local isMPF = faction == FACTION_MPF
		local isOTA = faction == FACTION_OTA

        if isClassD then
            return
		elseif (isMPF or isOTA) then
			if k == EQUIP_HEAD or k == EQUIP_SHIRT or k == EQUIP_RADIO or k == EQUIP_AMNESIC or k == EQUIP_ARMEP or k == EQUIP_ARMES or k == EQUIP_TORSO or k == EQUIP_MASK then
				self:CreateSlot(k, v)
			end
		elseif (isCITOYEN) then
			if k == EQUIP_HEAD or k == EQUIP_SHIRT or k == EQUIP_RADIO or k == EQUIP_ARMEP or k == EQUIP_ARMES then
				self:CreateSlot(k, v)
			end
		end
    end
end

function PANEL:CreateSlot(slotType, v)
    local slot = self:Add("ixEquipmentSlot")
    slot.slot = slotType
	slot:SetSize(iconSize - 8, iconSize - 8)
	slot:SetCursor("hand")
    self.slots[slotType] = slot
    slot:Populate()
    slot.Paint = function(self, w, h)
		if slot.Hovered then
			col = Color(60, 60, 60, 200)
		else
			col = Color(0, 0, 0, 100)
		end

		draw.RoundedBoxEx(8 , 0, 0, w, h,col,false,false,false,false)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(v.icon)
        surface.DrawTexturedRect(13, 16, w - 30, h - 30)
    end
end

function PANEL:PerformLayout()
    local padding = 10

    local x = 0
    local y = padding

    for _, slot in pairs(self.slots) do
        slot:SetPos(x + 10, y)
        y = y + iconSize

        slot.PosX = x
        slot.PosY = y
    end
end


-- Called when we are adding items into their slots.
function PANEL:AddIcon(model, x, slot, w, h, skin)
	local panel = self:Add("ixItemIcon")
	local slotPanel = self.slots[slot]
	local pos_x = slotPanel.PosX + 10
    local pos_y = slotPanel.PosY - iconSize
	panel.IsEquip = true
	panel:SetSize(iconSize - 8, iconSize - 8)
	panel:SetZPos(-999)
	panel:InvalidateLayout(false)
	panel:SetVisible(false)
	panel:SetModel(model, skin)
	panel:SetPos(pos_x, pos_y)
	panel.gridX = 1
	panel.gridY = slot
	panel.gridW = w
	panel.gridH = h


	local test = self:Add("ixItemIcon")
	test.IsEquip = true
	test:SetSize(iconSize - 8, iconSize - 8)
	test:SetDragParent(panel)
	test:SetZPos(999)
	test:InvalidateLayout(false)
	test:SetModel(model, skin)
	test:SetPos(pos_x, pos_y)
	test.gridX = 1
	test.gridY = slot
	test.gridW = w
	test.gridH = h

	panel.OnRemove = function(self) self.Ghost:Remove() end
	panel.Ghost = test

	local inventory = ix.item.inventories[self.invID]

	if (!inventory) then
		return
	end

	local itemTable = inventory:GetItemAt(panel.gridX, panel.gridY)

	if !itemTable or !itemTable.GetID then
		panel:Remove()
		return
	end

	panel:SetInventoryID(inventory:GetID())
	panel:SetItemTable(itemTable)
	test:SetInventoryID(inventory:GetID())
	test:SetItemTable(itemTable)

	if (self.panels[itemTable:GetID()]) then
		self.panels[itemTable:GetID()]:Remove()
	end

	if (itemTable.exRender) then
		panel.Icon:SetVisible(false)
		panel.ExtraPaint = function(this, panelX, panelY)
			local exIcon = ikon:GetIcon(itemTable.uniqueID)
			if (exIcon) then
				surface.SetMaterial(exIcon)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(0, 0, panelX, panelY)
			else
				ikon:renderIcon(
					itemTable.uniqueID,
					itemTable.width,
					itemTable.height,
					itemTable:GetModel(),
					itemTable.iconCam
				)
			end
		end
	end

	test:SetHelixTooltip(function(tooltip)
		ix.hud.PopulateItemTooltip(tooltip, itemTable)
	end)

	test.itemID = itemTable.id

	local slot = self.slots[slot]

	if IsValid(slot) then
		slot.item = panel
	end

	return panel
end


function PANEL:PaintDragPreview(width, height, itemPanel)
	if dragndrop.m_Receiver == self then 
		ix.gui.equipment.dropSlot = nil
	end

	local item = itemPanel:GetItemTable()
	local canUse = true --hook.Run("CharPanelCanUse", self.parent:GetCharacter():GetPlayer())

	if item then
		local slotPanel = ix.gui.equipment.slots[ix.gui.equipment.dropSlot]

		if IsValid(slotPanel) then
			if item.isEquipment and item.slot == ix.gui.equipment.dropSlot and canUse != false then
				if slotPanel.isEmpty then
					Color2 = Color(0, 255, 0, 40)
				else
					Color2 = Color(255, 255, 0, 40)
				end
			else
				Color2 = Color(255, 0, 0, 40)
			end

			local x, y = slotPanel:GetPos()
			draw.RoundedBoxEx(8 , x , y , iconSize - 8, iconSize - 8 ,Color2,false,false,false,false)
		end
	end
end

function PANEL:PaintOver(width, height)
	local itemPanel = (dragndrop.GetDroppable() or {})[1]

	if IsValid(itemPanel) then
		self:PaintDragPreview(width, height, itemPanel)
	end
end


-- Called every frame.
function PANEL:Paint(width, height)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0,0,width, height)

	surface.SetDrawColor(120, 120, 120,150)
	surface.DrawOutlinedRect(0,0,width, height,1)
end

vgui.Register("ixEquipment", PANEL, "DPanel")