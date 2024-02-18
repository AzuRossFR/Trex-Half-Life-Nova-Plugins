ITEM.base = "base_equipment"
ITEM.name = "Weapon"
ITEM.description = "A Weapon."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.slot = EQUIP_ARMEP
ITEM.height = 2
ITEM.isWeapon = true
ITEM.isGrenade = false
ITEM.weaponCategory = "sidearm"
ITEM.useSound = "items/ammo_pickup.wav"
ITEM.rarity = 0

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:Hook("drop", function(item)
	local inventory = ix.item.inventories[item.invID]

	if (!inventory) then
		return
	end

	-- the item could have been dropped by someone else (i.e someone searching this player), so we find the real owner
	local owner

	for client, character in ix.util.GetCharacters() do
		if (character:GetID() == inventory.owner) then
			owner = client
			break
		end
	end

	if (!IsValid(owner)) then
		return
	end

	if (item:GetData("equip")) then
		item:SetData("equip", nil)

		owner.carryWeapons = owner.carryWeapons or {}

		local weapon = owner.carryWeapons[item.weaponCategory]

		if (!IsValid(weapon)) then
			weapon = owner:GetWeapon(item.class)
		end

		if (IsValid(weapon)) then
			item:SetData("ammo", weapon:Clip1())

			owner:StripWeapon(item.class)
			owner.carryWeapons[item.weaponCategory] = nil
			owner:EmitSound(item.useSound, 80)
		end

		item:RemovePAC(owner)
	end
end)

function ITEM:WearPAC(client)
	if (ix.pac and self.pacData) then
		client:AddPart(self.uniqueID, self)
	end
end

function ITEM:RemovePAC(client)
	if (ix.pac and self.pacData) then
		client:RemovePart(self.uniqueID)
	end
end

function ITEM:OnItemEquipped(client, bNoSelect, bNoSound)
	local items = client:GetCharacter():GetInventory():GetItems()


	client.carryWeapons = client.carryWeapons or {}

	for _, v in pairs(items) do
		if (v.id != self.id) then
			local itemTable = ix.item.instances[v.id]

			if (!itemTable) then
				client:NotifyLocalized("tellAdmin", "wid!xt")

				return false
			else
				if (itemTable.isWeapon and client.carryWeapons[self.weaponCategory] and itemTable:GetData("equip")) then
					client:NotifyLocalized("weaponSlotFilled", self.weaponCategory)

					return false
				end
			end
		end
	end

	if (client:HasWeapon(self.class)) then
		client:StripWeapon(self.class)
	end

	local weapon = client:Give(self.class, !self.isGrenade)

	if (IsValid(weapon)) then
		local ammoType = weapon:GetPrimaryAmmoType()

		client.carryWeapons[self.weaponCategory] = weapon

		if (!bNoSelect) then
		end

		if (!bNoSound) then
			client:EmitSound(self.useSound, 80)
		end

		-- Remove default given ammo.
		if (client:GetAmmoCount(ammoType) == weapon:Clip1() and self:GetData("ammo", 0) == 0) then
			client:RemoveAmmo(weapon:Clip1(), ammoType)
		end

		-- assume that a weapon with -1 clip1 and clip2 would be a throwable (i.e hl2 grenade)
		-- TODO: figure out if this interferes with any other weapons
		if (weapon:GetMaxClip1() == -1 and weapon:GetMaxClip2() == -1 and client:GetAmmoCount(ammoType) == 0) then
			client:SetAmmo(1, ammoType)
		end

		self:SetData("equip", true)

		if (self.isGrenade) then
			weapon:SetClip1(1)
			client:SetAmmo(0, ammoType)
		else
			weapon:SetClip1(self:GetData("ammo", 0))
		end

		weapon.ixItem = self

		if (self.OnEquipWeapon) then
			self:OnEquipWeapon(client, weapon)
		end
	else
		print(Format("[Helix] Cannot equip weapon - %s does not exist!", self.class))
	end
end

function ITEM:OnItemUnequipped(client, bPlaySound, bRemoveItem)
	client.carryWeapons = client.carryWeapons or {}

	local weapon = client.carryWeapons[self.weaponCategory]

	if (!IsValid(weapon)) then
		weapon = client:GetWeapon(self.class)
	end

	if (IsValid(weapon)) then
		weapon.ixItem = nil

		self:SetData("ammo", weapon:Clip1())
		client:StripWeapon(self.class)
	else
		print(Format("[Helix] Cannot unequip weapon - %s does not exist!", self.class))
	end

	if (bPlaySound) then
		client:EmitSound(self.useSound, 80)
	end

	client.carryWeapons[self.weaponCategory] = nil
	self:SetData("equip", nil)
	self:RemovePAC(client)

	if (self.OnUnequipWeapon) then
		self:OnUnequipWeapon(client, weapon)
	end

	if (bRemoveItem) then
		self:Remove()
	end
end

function ITEM:CanEquip(client, slot)
	return IsValid(client) and self:GetData("equip") != true and self.slot == slot
end

function ITEM:CanUnequip(client, slot)
	return IsValid(client) and self:GetData("equip") == true
end

function ITEM:OnTransferred(curInv, inventory)
	if isfunction(curInv.GetOwner) then
		local owner = curInv:GetOwner()

		if IsValid(owner) and curInv.vars.isEquipment then
			self:OnUnequipped(owner)
		end
	end
end

function ITEM:OnLoadout()
	if (self:GetData("equip")) then
		local client = self.player
		client.carryWeapons = client.carryWeapons or {}

		local weapon = client:Give(self.class, true)

		if (IsValid(weapon)) then
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			client.carryWeapons[self.weaponCategory] = weapon

			weapon.ixItem = self
			weapon:SetClip1(self:GetData("ammo", 0))

			if (self.OnEquipWeapon) then
				self:OnEquipWeapon(client, weapon)
			end
		else
			print(Format("[Helix] Cannot give weapon - %s does not exist!", self.class))
		end
	end
end

function ITEM:OnSave()
	local weapon = self.player:GetWeapon(self.class)

	if (IsValid(weapon) and weapon.ixItem == self and self:GetData("equip")) then
		self:SetData("ammo", weapon:Clip1())
	end
end

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		local weapon = owner:GetWeapon(self.class)

		if (IsValid(weapon)) then
			weapon:Remove()
		end

		self:RemovePAC(owner)
	end
end

hook.Add("PlayerDeath", "ixStripClip", function(client)
	client.carryWeapons = {}

	for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
		if (v.isWeapon and v:GetData("equip")) then
			v:SetData("ammo", nil)
			v:SetData("equip", nil)

			if (v.pacData) then
				v:RemovePAC(client)
			end
		end
	end
end)

hook.Add("EntityRemoved", "ixRemoveGrenade", function(entity)
	-- hack to remove hl2 grenades after they've all been thrown
	if (entity:GetClass() == "weapon_frag") then
		local client = entity:GetOwner()

		if (IsValid(client) and client:IsPlayer() and client:GetCharacter()) then
			local ammoName = game.GetAmmoName(entity:GetPrimaryAmmoType())

			if (isstring(ammoName) and ammoName:lower() == "grenade" and client:GetAmmoCount(ammoName) < 1
			and entity.ixItem and entity.ixItem.Unequip) then
				entity.ixItem:Unequip(client, false, true)
			end
		end
	end
end)

function ITEM:GetRarity()
	return (self.GetRare and self:GetRare()) or self:GetData("rare", nil) or self.rarity or 0
end

function ITEM:GetRarityName()
	return self.rarityname or "Commun"
end

function ITEM:GetRarityColor()
	return RARITY_COLORS[self:GetRarity()] or RARITY_COLORS[0]
end

if CLIENT then
	RARITY_COLORS = {
		[0] = Color(235, 235, 235), -- Commun
		[1] = Color(37, 179, 79), -- Rare
		[2] = Color(44, 106, 199), -- Tres Rare
		[3] = Color(130, 62, 209), -- Epic
		[4] = Color(221, 207, 17), -- Legendary
		[5] = Color(165, 0, 0), -- Mythique


		-- [[Rareté Spécial]]
		[6] = Color(161, 35, 161),-- Only Staff
		[7] = Color(17, 17, 17)-- Ancien Staff
	}
	
function ITEM:PopulateTooltip(tooltip)
		local rColor = RARITY_COLORS[self:GetRarity()] or RARITY_COLORS[0]
		local name = tooltip:GetRow("name")
		name:SetImportant()
		name:SetBackgroundColor(rColor)
		name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
		name:SizeToContents()

		local rarityname = tooltip:AddRow("rarity")
		rarityname:SetText(self:GetRarityName() or "")
		rarityname:SetBackgroundColor(rColor)
		rarityname:SizeToContents()
	end
end