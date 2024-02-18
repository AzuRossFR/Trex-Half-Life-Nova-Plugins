ITEM.name = "Bonemerge base"
ITEM.model = "models/player/helmet_kiverm/kiverm.mdl"
ITEM.width = 1 
ITEM.height = 1
ITEM.weight = 5
ITEM.category = "TrexStudio"
ITEM.isEquipment = true
ITEM.slot = EQUIP_TORSO 
ITEM.bonemerge = ""

function ITEM:CanEquip(client, slot)
	return IsValid(client) and self:GetData("equip") != true and self.slot == slot
end

function ITEM:CanUnequip(client, slot)
	return IsValid(client) and self:GetData("equip") == true
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:OnUnequipped(item:GetOwner())
	end
end)

function ITEM:OnUnequipped(client, slot)
    self:RemoveOutfit(self:GetOwner() or client)
end

function ITEM:OnEquipped(client, slot)
    local char = client:GetCharacter()
    local headModelAttachment = ents.Create("prop_dynamic")
    headModelAttachment:SetModel(self.bonemerge)
    headModelAttachment:SetParent(client, client:LookupAttachment("lefteye"))
    headModelAttachment:SetMoveType( MOVETYPE_NONE )
    headModelAttachment:SetPos(client:GetPos() + Vector(0, 0, 100))
    headModelAttachment:SetAngles(client:GetAngles() + Angle(0, 0, 0))
    headModelAttachment:AddEffects(bit.bor(EF_BONEMERGE, EF_PARENT_ANIMATES))
    headModelAttachment:DrawShadow(false)
    client:SetNWEntity(char:GetID().."casque", headModelAttachment)
    self:SetData("equip", true)
end

function ITEM:RemoveOutfit(client)
    local char = client:GetCharacter()
	client = client or self.player
	self:SetData("equip", false)
    local char = client:GetCharacter()
    if(client:GetNWEntity(char:GetID().."casque", nil):IsValid()) then
        client:GetNWEntity(char:GetID().."casque", nil):Remove()
    end
end