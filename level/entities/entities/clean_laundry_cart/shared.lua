ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Chariot de Vêtements"
ENT.Author = "vikR"
ENT.Category = "TrexSCP | Lavage"
ENT.Contact = "none"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ClothesNumber")
end
