ITEM.name = "Bonemerge Armure base"
ITEM.model = "models/player/helmet_kiverm/kiverm.mdl"
ITEM.width = 1 
ITEM.height = 1
ITEM.weight = 5
ITEM.category = "TrexStudio"
ITEM.isEquipment = true
ITEM.maxArmor = 100;
ITEM.slot = EQUIP_TORSO 
ITEM.bonemerge = "models/eft_modular/gear/armor/cr/tt_plate_carrier_nopouch.mdl"

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
    client:SetArmor(self:GetData("armor", self.maxArmor))
    local char = client:GetCharacter()
    local ArmorAttachment = ents.Create("prop_dynamic")
    ArmorAttachment:SetModel(self.bonemerge)
    ArmorAttachment:SetParent(client, 4)
    ArmorAttachment:SetMoveType( MOVETYPE_NONE )
    ArmorAttachment:SetPos(client:GetPos() + Vector(0, 0, 100))
    ArmorAttachment:SetAngles(client:GetAngles() + Angle(0, 0, 0))
    ArmorAttachment:AddEffects(bit.bor(EF_BONEMERGE, EF_PARENT_ANIMATES,EF_BONEMERGE_FASTCULL))
    ArmorAttachment:DrawShadow(false)

    client:SetNWEntity(char:GetID().."armure", ArmorAttachment)
    self:SetData("equip", true)
end

function ITEM:RemoveOutfit(client)
    client:SetArmor(0)
    local char = client:GetCharacter()
	client = client or self.player
	self:SetData("equip", false)
    local char = client:GetCharacter()
    if(client:GetNWEntity(char:GetID().."armure", nil):IsValid()) then
        client:GetNWEntity(char:GetID().."armure", nil):Remove()
    end
end

function ITEM:OnLoadout()
	self.player:SetArmor(self:GetData("armor", self.maxArmor))
end

function ITEM:OnSave()
	self:SetData("armor", math.Clamp(self.player:Armor(), 0, self.maxArmor))
end