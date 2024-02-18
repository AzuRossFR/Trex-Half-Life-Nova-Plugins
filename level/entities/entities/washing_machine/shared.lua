ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Machine à Laver"
ENT.Category = "TrexSCP | Lavage"
ENT.Contact = "none"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "WashState")
	self:NetworkVar("Float", 1, "ClothType")
	self:NetworkVar("Bool", 2, "Washing")

	if SERVER then
		self:NetworkVarNotify("Washing", self.OnWash)
	end
end
