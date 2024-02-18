PLUGIN.name = "Durability"
PLUGIN.author = "STEAM_0:1:29606990" -- AleXXX_007 - original idea.
PLUGIN.description = "Adds durability for all weapons."

-- HL2 Weapons bullet damage is not counted.
-- bullet.Damage = (bullet.Damage / 100) * durability
-- bullet.Damage always 0

ix.config.Add("maxValueDurability", 100, "Maximum value of the durability.", nil, {
	data = {min = 1, max = 9999},
	category = PLUGIN.name
})

ix.config.Add("decDurability", 0.5, "By how many units do reduce the durability with each shot?", nil, {
	data = {min = 0.0001, max = 100, decimals = 4},
	category = PLUGIN.name
})

ix.config.Add("unequipItemDurability", false, "Unequip the item if durability is less than zero?", nil, {
	category = PLUGIN.name
})

ix.lang.AddTable("russian", {
	['Repair'] = "Починить",
	['RepairKitWrong'] = 'У вас нет ремкомплекта!',
	['DurabilityUnusableTip'] = 'Оружие теперь полностью сломано!',
	['DurabilityText'] = 'Прочность',
})

ix.lang.AddTable("french", {
	['RepairKitWrong'] = "Vous n'avez pas de kit de réparation!",
	['DurabilityUnusableTip'] = 'Votre arme est cassé !',
	['DurabilityText'] = 'Durabilité',
})

if (SERVER) then
	function PLUGIN:Tick()
		local curTime = CurTime()

		for _, v in ipairs(player.GetAll()) do
			if (curTime >= (v.ixNextTickDurability or 0) and v:Alive() and v:GetCharacter()) then
				local weapon = v:GetActiveWeapon()

				if (IsValid(weapon) and weapon.ixItem and weapon.ixItem.isWeapon) then
					local canShoot = weapon.ixItem:GetData("durability", weapon.ixItem.maxDurability or ix.config.Get("maxValueDurability", 100)) > 0

					if (canShoot ~= v:CanShootWeapon()) then
						v:SetNetVar("canShoot", canShoot)
					end
				end

				v.ixNextTickDurability = curTime + 0.1
			end
		end
	end

	function PLUGIN:EntityFireBullets(entity, bullet)
		if (IsValid(entity) and entity:IsPlayer()) then
			local weapon = entity:GetActiveWeapon()

			if (IsValid(weapon) and weapon.ixItem) then
				local item = weapon.ixItem

				if (item.isWeapon) then
					local durability = item:GetData("durability", item.maxDurability or ix.config.Get("maxValueDurability", 100))
					local oldDurability = durability
					local originalDamage = bullet.Damage

					bullet.Damage = (originalDamage / 100) * durability
					bullet.Spread = bullet.Spread * (1 + (1 - (0.01 * durability)))

					if (originalDamage < 1) then
						durability = math.max(durability - ix.config.Get("decDurability", 1), 0)
					else
						durability = math.max(durability - (originalDamage / 100), 0) -- 100 = drainScale
					end

					if (oldDurability ~= durability) then
						item:SetData("durability", durability)
					end

					if (oldDurability > 0 and durability == 0) then
						entity:SetNetVar("canShoot", false)
						entity:NotifyLocalized('DurabilityUnusableTip')
					end

					if (ix.config.Get("unequipItemDurability", false) and durability < 1 and item.Unequip) then
						item:Unequip(entity)
					end
				end
			end
		end
	end
end

function PLUGIN:InitializedPlugins()
	local maxDurability = ix.config.Get("maxValueDurability", 100)

	for _, v in pairs(ix.item.list) do
		if (!v.isWeapon) then continue end

		maxDurability = v.maxDurability or maxDurability

		v.functions.Réparer = {
			name = "Réparer",
			tip = "equipTip",
			icon = "icon16/bullet_wrench.png",
			OnRun = function(item)
				local client = item.player
				local itemKit = client:GetCharacter():GetInventory():HasItemOfBase("base_repair_kit")

				if (itemKit and itemKit.isWeaponKit) then
					local quantity = itemKit:GetData("quantity", itemKit.quantity or 1) - 1

					if (quantity < 1) then
						itemKit:Remove()
					else
						itemKit:SetData("quantity", quantity)
					end

					if (itemKit.UseRepair) then
						itemKit:UseRepair(item, client)
					end

					if (itemKit.useSound) then
						client:EmitSound(itemKit.useSound, 110)
					end

					itemKit = nil
				else
					client:NotifyLocalized('RepairKitWrong')
				end

				return false
			end,

			OnCanRun = function(item)
				if (item:GetData("durability", maxDurability) >= maxDurability) then
					return false
				end

				if (!item.player:GetCharacter():GetInventory():HasItemOfBase("base_repair_kit")) then
					return false
				end

				return true
			end
		}
	end
end

function PLUGIN:CanPlayerEquipItem(_, itemObj)
	if (ix.config.Get("unequipItemDurability", false)) then
		return itemObj:GetData("durability", ix.config.Get("maxValueDurability", 100)) > 0
	end
end