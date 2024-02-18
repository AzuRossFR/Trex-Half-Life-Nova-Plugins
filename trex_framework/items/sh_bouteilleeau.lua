
ITEM.name = "Bouteille d'Eau"
ITEM.model = Model("models/props_junk/popcan01a.mdl")
ITEM.description = "Une petite bouteille d'eau."
ITEM.category = "TrexNourriture"

ITEM.functions.Boire = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:RestoreStamina(25)
		client:SetHealth(math.Clamp(client:Health() + 6, 0, client:GetMaxHealth()))
		client:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 90, 0.35)
	end,
}