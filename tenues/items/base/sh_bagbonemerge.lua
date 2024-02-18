
if (SERVER) then
	util.AddNetworkString("ixBagDrop")
end

ITEM.name = "Bag"
ITEM.description = "A bag to hold items."
ITEM.model = "models/props_c17/suitcase001a.mdl"
ITEM.category = "Storage"
ITEM.width = 2
ITEM.height = 2
ITEM.invWidth = 4
ITEM.invHeight = 2
ITEM.weight = 0
ITEM.attachement = "hips"
ITEM.bonemerge = "models/eft_modular/gear/backpacks/6sh118.mdl"
ITEM.isEquipment = true
ITEM.slot = EQUIP_TORSO 
ITEM.poids = 10
ITEM.isBag = true
ITEM.bone = "ValveBiped.Bip01_Spine1"
ITEM.functions.Ouvrir = {
	icon = "icon16/briefcase.png",
	OnClick = function(item)
		local index = item:GetData("id", "")

		if (index) then
			local panel = ix.gui["inv"..index]
			local inventory = ix.item.inventories[index]
			local parent = IsValid(ix.gui.menuCanvas) and ix.gui.menuCanvas or ix.gui.openedStorage

			if (IsValid(panel)) then
				panel:Remove()
			end

			if (inventory and inventory.slots) then
				
				panel = parent:Add("ixInventory")
				panel:SetInventory(inventory)
				panel:ShowCloseButton(false)
				panel:Dock(TOP)
				panel:SetDraggable(false)
				panel:SetTitle(item.name)

				if (parent != ix.gui.menuCanvas) then
					panel:Center()

					if (parent == ix.gui.openedStorage) then
						panel:MakePopup()
					end
				end

				ix.gui["inv"..index] = panel
			else
				ErrorNoHalt("[Helix] Attempt to view an uninitialized inventory '"..index.."'\n")
			end
		end

		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetData("id") and !IsValid(ix.gui["inv" .. item:GetData("id", "")]) and item:GetData("equip") == true
	end
}


function ITEM:OnInstanced(invID, x, y)
	local inventory = ix.item.inventories[invID]

	ix.inventory.New(inventory and inventory.owner or 0, self.uniqueID, function(inv)
		local client = inv:GetOwner()

		inv.vars.isBag = self.uniqueID
		self:SetData("id", inv:GetID())

		if (IsValid(client)) then
			inv:AddReceiver(client)
		end
	end)
end

function ITEM:OnUnequipped(client, slot)
    self:RemoveOutfit(self:GetOwner() or client)
end

function ITEM:OnEquipped(client, slot)
    local char = client:GetCharacter()
    local sacAttachment = ents.Create("prop_dynamic")
	local count = sacAttachment:GetBoneCount()
    sacAttachment:SetModel(self.bonemerge)
    sacAttachment:SetParent(client, client:LookupAttachment(self.attachement))
    sacAttachment:SetMoveType( MOVETYPE_NONE )
    sacAttachment:AddEffects(bit.bor(EF_BONEMERGE, EF_PARENT_ANIMATES))
	sacAttachment:DrawShadow(false)
    client:SetNWEntity(char:GetID().."sac", sacAttachment)
    self:SetData("equip", true)
end

function ITEM:RemoveOutfit(client)
	client = client or self.player
	local char = client:GetCharacter()
	self:SetData("equip", false)

    if(client:GetNWEntity(char:GetID().."sac", nil):IsValid()) then
        client:GetNWEntity(char:GetID().."sac", nil):Remove()
    end
end

function ITEM:GetInventory()
	local index = self:GetData("id")

	if (index) then
		return ix.item.inventories[index]
	end
end

ITEM.GetInv = ITEM.GetInventory

-- Called when the item first appears for a client.
function ITEM:OnSendData()
	local index = self:GetData("id")

	if (index) then
		local inventory = ix.item.inventories[index]

		if (inventory) then
			inventory.vars.isBag = self.uniqueID
			inventory:Sync(self.player)
			inventory:AddReceiver(self.player)
		else
			local owner = self.player:GetCharacter():GetID()

			ix.inventory.Restore(self:GetData("id"), self.invWidth, self.invHeight, function(inv)
				inv.vars.isBag = self.uniqueID
				inv:SetOwner(owner, true)

				if (!inv.owner) then
					return
				end

				for client, character in ix.util.GetCharacters() do
					if (character:GetID() == inv.owner) then
						inv:AddReceiver(client)
						break
					end
				end
			end)
		end
	else
		ix.inventory.New(self.player:GetCharacter():GetID(), self.uniqueID, function(inv)
			self:SetData("id", inv:GetID())
		end)
	end
end

function ITEM:CanEquip(client, slot)
	return IsValid(client) and self:GetData("equip") != true and self.slot == slot
end

function ITEM:CanUnequip(client, slot)
	return IsValid(client) and self:GetData("equip") == true
end

ITEM.postHooks.drop = function(item, result)
	local index = item:GetData("id")
    if (item:GetData("equip")) then
		item:OnUnequipped(item:GetOwner())
	end

	local query = mysql:Update("ix_inventories")
		query:Update("character_id", 0)
		query:Where("inventory_id", index)
	query:Execute()

	net.Start("ixBagDrop")
		net.WriteUInt(index, 32)
	net.Send(item.player)
end

if (CLIENT) then
	net.Receive("ixBagDrop", function()
		local index = net.ReadUInt(32)
		local panel = ix.gui["inv"..index]

		if (panel and panel:IsVisible()) then
			panel:Close()
		end
	end)
end

-- Called before the item is permanently deleted.
function ITEM:OnRemoved()
	local index = self:GetData("id")

	if (index) then
		local query = mysql:Delete("ix_items")
			query:Where("inventory_id", index)
		query:Execute()

		query = mysql:Delete("ix_inventories")
			query:Where("inventory_id", index)
		query:Execute()
	end
end

-- Called when the item should tell whether or not it can be transfered between inventories.
function ITEM:CanTransfer(oldInventory, newInventory)
    local index = self:GetData("id")
    
    if newInventory and newInventory.vars and newInventory.vars.isEquipment then
        return true
    end
    
    if newInventory then
        if newInventory.vars and newInventory.vars.isBag then
            return false
        end

        local index2 = newInventory:GetID()

        if index == index2 then
            return false
        end

        for _, v in pairs(self:GetInventory():GetItems()) do
            if v:GetData("id") == index2 then
                return false
            end
        end
    end

    return not newInventory or newInventory:GetID() ~= oldInventory:GetID() or newInventory.vars.isBag
end


function ITEM:OnTransferred(curInv, inventory)
	local bagInventory = self:GetInventory()

	if (isfunction(curInv.GetOwner)) then
		local owner = curInv:GetOwner()

		if (IsValid(owner)) then
			bagInventory:RemoveReceiver(owner)
		end
	end

	if (isfunction(inventory.GetOwner)) then
		local owner = inventory:GetOwner()

		if (IsValid(owner)) then
			bagInventory:AddReceiver(owner)
			bagInventory:SetOwner(owner)
		end
	else
		-- it's not in a valid inventory so nobody owns this bag
		bagInventory:SetOwner(nil)
	end
end

-- Called after the item is registered into the item tables.
function ITEM:OnRegistered()
	ix.inventory.Register(self.uniqueID, self.invWidth, self.invHeight, true)
end
