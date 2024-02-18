ITEM.name = "Gilet Pare Balle AIT"
ITEM.model = "models/weapons/thenextscp/vest_w.mdl"
ITEM.width = 1 
ITEM.height = 1
ITEM.weight = 5
ITEM.description = [[Un gilet pare-balles est un vêtement conçu pour offrir une protection contre les projectiles balistiques, tels que les balles de pistolet ou de fusil.
]]
ITEM.category = "TrexStudio"
ITEM.maxArmor = 75
ITEM.slot = EQUIP_TORSO 
ITEM.bodyGroups = {
	[7] = 1,
    [8] = 1,
    [1] = 1
}
ITEM.Stats = {
    [HITGROUP_STOMACH] = 75,
}

function ITEM:CanTransferEquipment(oldinv, newinv, slot)
    if slot != self.slot then return false end
	local client = newinv:GetOwner()
	if client:Team() != FACTION_AIT then
        return false, client:NotifyLocalized("Vous n'êtes pas AIT")
    else
        return true
    end 
end