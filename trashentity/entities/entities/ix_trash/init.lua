include("shared.lua")

AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_residue/trashcan01.mdl")
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)

	local physics = self:GetPhysicsObject()
	print(physics)
	physics:EnableMotion(false)
	physics:Sleep()

end

function ENT:Touch(ent)
	if IsValid(ent) and not ent:IsPlayer() then
		ent:Remove()
		MsgC(Color(255,255,255), "[Poubelle]" .. ent:GetClass() .. " has been removed.\n")
	end
end