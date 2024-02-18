
FACTION.name = "Cremator"
FACTION.description = "--."
FACTION.color = Color(0, 150, 0)
FACTION.pay = 10
FACTION.image = ix.util.GetMaterial("trex/bannierefaction/synth_ban.png")
FACTION.icon = ix.util.GetMaterial("trex/logo/icon_cmb.png")
FACTION.models = {"models/wn7new/combine_cremator/cremator.mdl"}
FACTION.weapons = {"weapon_bp_flamethrower_edited"} -- uncomment this if you using vfire
-- FACTION.weapons = {"weapon_bp_flamethrower_edited", "weapon_bp_immolator_edited"} -- uncomment, if you using hl2 beta weapons
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
-- FACTION.runSounds = {[0] = "npc/cremator/foot1.wav", [1] = "npc/cremator/foot2.wav", [2] = "npc/cremator/foot3.wav"}
FACTION.walkSounds = {[0] = "npc/cremator/foot1.wav", [1] = "npc/cremator/foot2.wav", [2] = "npc/cremator/foot3.wav"}
FACTION.taglines = {
	"CARTE",
	"LAME",
	"CLEANER",
	"FIRE",
	"CONTAIN",
	"BREACH",
	"OVER",
	"DAGUE"
}

function FACTION:GetDefaultName(ply)
	return "s24:CrM°" .. string.upper(self.taglines[math.random(1, #self.taglines)]) .. "." .. Schema:ZeroNumber(math.random(10000, 99999), 5), true
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

FACTION_CREMATOR = FACTION.index
