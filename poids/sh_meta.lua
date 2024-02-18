-- ITEM META START --
local ITEM = ix.meta.item or {}

RARITY_COLORS = {
	[0] = Color(153, 153, 153), -- Commun
	[1] = Color(37, 179, 79), -- Rare
	[2] = Color(44, 106, 199), -- Tres Rare
	[3] = Color(130, 62, 209), -- Epique
	[4] = Color(221, 160, 17), -- Legendaire
	[5] = Color(165, 0, 0), -- Mythique

	-- [[Rareté Spécial]]
	[6] = Color(161, 35, 161),
	[7] = Color(17, 17, 17)
}	

function ITEM:GetWeight()
	return self:GetData("weight", nil) or self.weight or nil
end

function ITEM:GetWeight()
	return self:GetData("weight", nil) or self.weight or nil
end

function ITEM:GetRarity()
	return (self.GetRare and self:GetRare()) or self:GetData("rare", nil) or self.rarity or 0
end

function ITEM:GetRarityName()
	return self.rarityname or "Commun"
end

function ITEM:GetRarityColor()
	return RARITY_COLORS[self:GetRarity()] or RARITY_COLORS[0]
end

function ITEM:DropWeight(w)
	if (self.player) then
		local weight = w or self:GetWeight()

		if (weight) then
			self.player:GetCharacter():DropWeight(weight)
		end
	end
end

ix.meta.item = ITEM
-- ITEM META END --

-- CHARACTER META START --
local CHAR = ix.meta.character or {}

function CHAR:Overweight()
	return self:GetData("carry", 0) > ix.weight.BaseWeight(self)
end

function CHAR:CanCarry(item)
	return ix.weight.CanCarry(item:GetWeight(), self:GetData("carry", 0), self)
end

function CHAR:UpdateWeight()
	ix.weight.Update(self)
end

-- these are primarily intended as internally used functions, you shouldn't use them in your own code --
function CHAR:AddCarry(item)
	self:SetData("carry", math.max(self:GetData("carry", 0) + item:GetWeight(), 0))
end

function CHAR:RemoveCarry(item)
	self:SetData("carry", math.max(self:GetData("carry", 0) - item:GetWeight(), 0))
end
-- these are primarily intended as internally used functions, you shouldn't use them in your own code --

function CHAR:DropWeight(weight)
	self:SetData("carry", math.max(self:GetData("carry", 0) - weight, 0))
end

ix.meta.char = CHAR
-- CHARACTER META END --
