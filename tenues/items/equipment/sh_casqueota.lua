ITEM.name = "Casque des Forces Transhumaines"
ITEM.description = "Un casque servant aux forces transhumaines."
ITEM.category = "TrexStudio"
ITEM.slot = EQUIP_HEAD
ITEM.weight = 3
ITEM.model = "models/wn7new/metropolice/n7_cp_gasmask4.mdl"
ITEM.replacements = "models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl"
ITEM.newSkin = 1
ITEM.rarity = 4
ITEM.rarityname = ("légendaire"):utf8upper()

function ITEM:OnItemEquipped(client)
    client:Freeze(true)
    client:ScreenFade(SCREENFADE.IN, Color(0, 157, 181), 1, 1)
    client:EmitSound("npc/zombie/foot_slide3.wav", 100, 100, 1)
    client:SetAction("Activation du Casque", 1, function()
        client:Freeze(false)
    end)
end


function ITEM:OnItemUnequipped(client)
    client:Freeze(true)
    client:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0), 1,  1)
    client:EmitSound("npc/zombie/foot_slide2.wav", 100, 100, 1)
    client:SetAction("Désactivation du Casque", 1, function()
        client:Freeze(false)
    end)
end