ITEM.name = "Repair Kit Base"
ITEM.category = "RepairKit"
ITEM.description = [[Ce kit de réparation réparera %s%% de durabilité.
]]
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.useSound = "interface/inv_repair_kit.ogg"
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.5

-- Percentage of the difference between maximum and current durability. See in ITEM:UseRepair
ITEM.durability = 25

-- How many times can an item be used before it is removed?
ITEM.quantity = 1

-- Only allowed for weapons.
ITEM.isWeaponKit = true

if (SERVER) then
	-- You can override this method in your item.
	-- item: The current used item.
	function ITEM:UseRepair(item, client)
		local maxDurability = item.maxDurability or ix.config.Get("maxValueDurability", 100)
		local durability = item:GetData("durability", maxDurability)
		local amount = math.max(0, (self.durability / 100) * (maxDurability - durability))

		item:SetData("durability", math.Clamp(math.floor(durability + amount), 0, maxDurability))
	end
end

if (CLIENT) then
	function ITEM:GetDescription()
		return Format(self.description, self.durability)
	end
end

function ITEM:OnInstanced(invID, x, y, item)
	item:SetData("quantity", item.quantity or 1)
end
