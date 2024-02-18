PLUGIN.name = "Drag Drop Interaction"
PLUGIN.description = ""
PLUGIN.author = ""

ix.util.Include("sv_hooks.lua")
ix.util.Include("meta/sh_inventory.lua")
ix.inventory.Register("equipment", 1, MAX_EQUIPMENT_SLOTS)
ix.char.RegisterVar("equipID", {
	field = "equipID",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})

do 
	local CHAR = ix.meta.character

	function CHAR:GetEquipment()
		local index = self:GetEquipID()

		if index == 0 then 
			return false
		end

		return ix.item.inventories[index]
	end
end

function PLUGIN:CanTransferEquipment(item, oldInv, newInv, slot)
	local canTransfer, error = item.CanTransferEquipment and item:CanTransferEquipment(oldInv, newInv, slot)

	if !item.isEquipment or item.slot != slot or canTransfer == false then
		return false, error
	end

	if item.isOutfit and item.slot == EQUIP_TORSO then
		for z = 1, 7 do
			if z == EQUIP_EARS then continue end
			
			if newInv:GetItemAtSlot(z) then
				return false, "Vous devez retirer le reste de vos vêtements avant de vous équiper !"
			end
		end
	end

	return true
end



function PLUGIN:CanPlayerEquipItem(client, item)
	return item.invID == client:GetCharacter():GetEquipID() or item.invID == client:GetCharacter():GetInventory():GetID()
end

function PLUGIN:CanPlayerUnequipItem(client, item)
	return item.invID == client:GetCharacter():GetEquipID() or item.invID == client:GetCharacter():GetInventory():GetID()
end

function PLUGIN:OnItemTransferred(item, oldInv, newInv)
	local slot = item.gridY

	if (newInv and (newInv.vars or {}).isEquipment) then
		local client = newInv:GetOwner()

		if item.CanEquip and item:CanEquip(client, slot) and hook.Run("CanPlayerEquipItem", client, item, slot) != false then
			item:OnEquipped(client, slot)
		end
	elseif oldInv and (oldInv:GetID() != 0) then
		local client = oldInv:GetOwner()

		if item.CanUnequip and item:CanUnequip(client, slot) and hook.Run("CanPlayerUnequipItem", client, item, slot) != false then
			item:OnUnequipped(client, slot)
		end
	end
end
