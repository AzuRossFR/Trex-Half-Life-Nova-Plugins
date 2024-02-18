ITEM.name = "Tenue Protection Civile"
ITEM.description = [[
Une combinaison composé de plusieurs protection qui sert d'uniforme de la Protection Civile présente dans toute les cités."

    ]]
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_MASK
ITEM.weight = 3
ITEM.model = "models/trexhln/metropolice/cpuniform.mdl"
ITEM.replacements = "models/trexhln/metropolice/male_cp.mdl"
ITEM.newSkin = 0
ITEM.bodyGroups = {
    [3] = 0,
}
ITEM.rarity = 3
ITEM.rarityname = ("épique"):utf8upper()

function ITEM:OnItemEquipped(client)
    client:Freeze(true)
    client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 3, 3)
    client:EmitSound("npc/zombie/foot_slide3.wav", 100, 100, 1)
    client:SetAction("Enfilage de l'uniforme", 3, function()
        client:Freeze(false)
    end)
end


function ITEM:OnItemUnequipped(client)
    client:Freeze(true)
    client:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0), 3, 3)
    client:EmitSound("npc/zombie/foot_slide2.wav", 100, 100, 1)
    client:SetAction("Retrait de l'uniform", 3, function()
        client:Freeze(false)
    end)
end
