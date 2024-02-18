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
ITEM.rarity = 1
ITEM.rarityname = "Rare (Illégal)"
ITEM.stationaryCanAccess = true

function ITEM:GetFrequency()
	return self:GetData("frequency", "100.0")
end

function ITEM:GetFrequencyID()
	return string.format("freq_%d", string.gsub(self:GetData("frequency", "100.0"), "%p", ""))
end

ITEM.functions.Frequency = {
	name = "Régler la fréquence",

	OnCanRun = function(item)
		return IsValid(item.player) and !IsValid(item.entity) and !item.player:IsRestricted()
	end,

	OnClick = function(item)a
		Derma_StringRequest("Fréquence", "Entrer la nouvelle fréquence de la radio", item:GetData("frequency", "100.0"), function(text)
			netstream.Start("ixRadioFrequency", item:GetID(), text)
		end)
	end,

	OnRun = function()
		return false
	end
}
y