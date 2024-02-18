ITEM.name = "Tenue Classe-E"
ITEM.description = "La tenue Classe-E"
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_MASK
ITEM.model = "models/props_junk/cardboard_box001a.mdl"

ITEM.replacements = {
    {"trexc", "trexd"},
}

function ITEM:CanTransferEquipment(oldinv, newinv, slot)
    if slot != self.slot then return false end
	local client = newinv:GetOwner()
	if client:Team() != FACTION_CLASSD then
        return false, client:NotifyLocalized("Vous n'êtes pas Classe-D")
    else
        return true
    end 
end