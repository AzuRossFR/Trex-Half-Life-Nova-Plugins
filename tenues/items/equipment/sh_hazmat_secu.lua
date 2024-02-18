ITEM.name = "Combinaison Hazmat du CARTEL"
ITEM.description = "Une combinaison Hazmat qui protège celui qui la porte des matières dangereuses"
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_MASK
ITEM.weight = 3
ITEM.model = "models/props_forest/footlocker01_closed.mdl"
ITEM.replacements = "models/hlalyx/workers_cmb/hazmat_worker/npc/hazmat_worker_citizen.mdl"
ITEM.newSkin = 0
ITEM.rarity = 3
ITEM.rarityname = ("épique"):utf8upper()

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