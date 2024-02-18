AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:SpawnFunction(ply, tr, cn)
	local ent = ents.Create(cn)
	ent:SetPos(tr.HitPos + tr.HitNormal)
	if math.random(1, 4) == 4 then
		ent:SetClothType(2)
	else 
		ent:SetClothType(1)
	end
	ent:SetClean(false)
	ent:Spawn()

	return ent
end

function ENT:AcceptInput(name, activator, caller)	
	if IsValid(activator) and activator:IsPlayer() then
		if self:IsPlayerHolding() then return end
	   	activator:PickupObject(self)
	end 
end;

function ENT:Initialize()
	self:SetModel("models/willardnetworks/skills/explosive_material.mdl")

	if not self:GetClean() then
		self:SetMaterial("models/props_pipes/GutterMetal01a")
	end

	if self:GetClothType() == 1 then
		self:SetColor(Color(255,125,0))
	elseif self:GetClothType() == 2 then
		self:SetColor(Color(255,255,255))
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
