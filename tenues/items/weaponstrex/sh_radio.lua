ITEM.name = "Radio"
ITEM.model = "models/realistic_police/radio/w_radio.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.class = "aradio"
ITEM.weight = 0.300 
ITEM.description = [[Une radio de poche est un petit appareil électronique portable conçu pour recevoir des signaux radio et diffuser des émissions radiophoniques.
]]
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_RADIO 
ITEM.bodyGroups = { 
	[13] = 1,
}
ITEM.rarity = 1
ITEM.rarityname = "Rare (Illégal)"

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("enabled")) then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(Material("trex/euip.png"))
			surface.DrawTexturedRect(-2, -2, w, h)
		end
	end
end

function ITEM:GetDescription()
	local enabled = self:GetData("enabled")
	return string.format(self.description, enabled and "on" or "off", enabled and (" and tuned to " .. self:GetData("frequency", "100.0")) or "")
end

function ITEM.postHooks.drop(item, status)
	item:SetData("enabled", false)
end

ITEM.functions.Fréquence = {
	OnRun = function(itemTable)
		netstream.Start(itemTable.player, "Frequency", itemTable:GetData("frequency", "000.0"))

		return false
	end
}

ITEM.functions.Basculer = {
	OnRun = function(itemTable)
		local character = itemTable.player:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("handheld_radio", true)
		local bCanToggle = true

		-- don't allow someone to turn on another radio when they have one on already
		if (#radios > 1) then
			for k, v in ipairs(radios) do
				if (v != itemTable and v:GetData("enabled", false)) then
					bCanToggle = false
					break
				end
			end
		end

		if (bCanToggle) then
			itemTable:SetData("enabled", !itemTable:GetData("enabled", false))
			itemTable.player:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)
		else
			itemTable.player:NotifyLocalized("radioAlreadyOn")
		end

		return false
	end
}