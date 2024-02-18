ITEM.name = "Equipement de Terrain Médical"
ITEM.description = [[Un équipement qui vous permet d'être en toute sécurité sur le terrain.
]]
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_MASK
ITEM.weight = 3
ITEM.model = "models/foundation/detail/crate_01.mdl"
ITEM.replacements = "models/garde/trex/gardesd.mdl"
ITEM.newSkin = 3
ITEM.bodyGroups = {
    [8] = 1,
    [9] = 1,
    [14] = 1,
    [1] = 1,
    [3] = 1,
	[4] = 1,
	[5] = 1,
	[6] = 1,
}

function ITEM:CanTransferEquipment(oldinv, newinv, slot)
    if slot != self.slot then return false end
	local client = newinv:GetOwner()
	if client:Team() != FACTION_MEDECIN then
        return false, client:NotifyLocalized("Vous n'êtes pas Médecin")
    else
        return true
    end 
end