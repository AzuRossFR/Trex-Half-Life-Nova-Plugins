
ITEM.name = "Carte d'Identité"
ITEM.description = [[Une carte d'identité de citoyen avec un numéro d'identification #%s, affecté à %s.

]]
ITEM.rarity = 5
ITEM.rarityname = "Objet du Cartel"
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(90, 0, 0),
	fov = 2.67
}


function ITEM:GetDescription()
	return string.format(self.description, self:GetData("id", "00000"), self:GetData("name", "nobody"))
end
