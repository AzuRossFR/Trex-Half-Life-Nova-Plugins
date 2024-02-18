-- luacheck: globals FACTION_ZOMBIE

FACTION.name = "Zombie"
FACTION.image = ix.util.GetMaterial("trex/bannierefaction/zombie_ban.png")
FACTION.icon = ix.util.GetMaterial("trex/logo/icon_zombie.png")
FACTION.description = ""
FACTION.color = Color(134, 76, 76)
FACTION.isDefault = true
FACTION.npcRelations = {
	["npc_zombie"] = D_LI,
	["npc_poisonzombie"] = D_LI,
	["npc_zombie_torso"] = D_LI,
	["npc_headcrab_black"] = D_LI,
	["npc_headcrab"] = D_LI,
	["npc_fastzombie_torso"] = D_LI,
	["npc_fastzombie"] = D_LI,
	["npc_headcrab_fast"] = D_LI,
	["npc_zombine"] = D_LI,
	["npc_antlion"] = D_HT,
	["npc_antlionguard"] = D_HT
}
FACTION.defaultLevel = 3
FACTION.models = {
	{"models/zombie/classic.mdl", nil, "01"},
}
FACTION.genders = {1}

function FACTION:GetDefaultName(ply)
	return "Nécrotique", true
end


function FACTION:GetModels(client, character)
	return self.models
end

FACTION_ZOMBIE = FACTION.index
