ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Vêtements"
ENT.Category = "TrexSCP | Lavage"
ENT.Contact = "none"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Clean")
	self:NetworkVar("Float", 1, "ClothType") -- 1 = prisonnier, 2 = garde

	if SERVER then
		self:NetworkVarNotify("Clean", self.OnClothChangeState)
	end
end
