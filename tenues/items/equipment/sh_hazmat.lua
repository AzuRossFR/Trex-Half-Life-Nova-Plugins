ITEM.name = "Combinaison Hazmat"
ITEM.description = "Une combinaison Hazmat qui protège celui qui la porte des matières dangereuses"
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_MASK
ITEM.weight = 3
ITEM.model = "models/foundation/detail/crate_01.mdl"
ITEM.replacements = "models/star/trex/hazmat.mdl"
ITEM.newSkin = 0

function ITEM:OnItemEquipped(client)
    client:Freeze(true)
    client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 1)
    client:EmitSound("npc/zombie/foot_slide3.wav", 100, 100, 1)
    client:SetAction("Enfilage de la Tenue Hazmat", 1, function()
        client:Freeze(false)
    end)
end


function ITEM:OnItemUnequipped(client)
    client:Freeze(true)
    client:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0), 1,  1)
    client:EmitSound("npc/zombie/foot_slide2.wav", 100, 100, 1)
    client:SetAction("Retrait de la Tenue Hazmat", 1, function()
        client:Freeze(false)
    end)
end
