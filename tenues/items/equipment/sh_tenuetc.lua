ITEM.name = "Combinaison - Travailleur du Cartel"
ITEM.description = [[Une combinaison qui permet aux travailleurs du cartel d'accomplir leurs tâches.
]]
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_MASK
ITEM.weight = 3
ITEM.model = "models/props_forest/footlocker01_closed.mdl"
ITEM.replacements = "models/hlalyx/workers_cmb/combine_worker/npc/worker_citizen.mdl"
ITEM.newSkin = 0
ITEM.rarity = 2
ITEM.rarityname = ("Rare"):utf8upper()

function ITEM:OnItemEquipped(client)
    client:Freeze(true)
    client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 1)
    client:EmitSound("npc/zombie/foot_slide3.wav", 100, 100, 1)
    client:SetAction("Enfilage de la Tenue", 1, function()
        client:Freeze(false)
    end)
end


function ITEM:OnItemUnequipped(client)
    client:Freeze(true)
    client:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0), 1,  1)
    client:EmitSound("npc/zombie/foot_slide2.wav", 100, 100, 1)
    client:SetAction("Retrait de la Tenue", 1, function()
        client:Freeze(false)
    end)
end