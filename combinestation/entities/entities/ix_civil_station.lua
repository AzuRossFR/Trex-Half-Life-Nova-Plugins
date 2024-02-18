
local PLUGIN = PLUGIN

ENT.PrintName		= "Station Civile"
ENT.Category		= "IX-E:HL2RP"
ENT.Spawnable		= true
ENT.AdminOnly		= true
ENT.Model			= Model("models/hls/alyxports/monitor_medium.mdl")
ENT.RenderGroup 	= RENDERGROUP_OPAQUE
ENT.bNoPersist = true

local scale = 0.07
local screenWidth, screenHeight = 56, 32.7
local halfWide, halfTall = screenWidth / 2, screenHeight / 2

if (SERVER) then
	function ENT:SpawnFunction(player, trace, class)
		if (!trace.Hit) then return end
		local entity = ents.Create("ix_civil_station")
		entity:SetPos(trace.HitPos + trace.HitNormal * 1.5)
		entity:Spawn()
		return entity
	end
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		timer.Simple(.5,function()
			self:SetNetVar("isAlerting", false )
		end)
		local phys = self:GetPhysicsObject()
		if (IsValid(phys)) then
			phys:Wake()
		end
	end
elseif (CLIENT) then
	function ENT:Initialize()
		self.m_bInitialized = true
		self:SetSolid(SOLID_VPHYSICS)
	end

	function ENT:Think()
		if (!self.m_bInitialized) then
			self:Initialize()
		end

		local bShouldDraw = EyePos():DistToSqr(self:GetPos()) < 16000

		if (!IsValid(self.panel) and bShouldDraw) then
			self.panel = vgui.Create("ixWelcomeScreen")
		elseif (IsValid(self.panel) and !bShouldDraw) then
			self.panel:Remove()
		end

		self:NextThink(CurTime() + 1)
		return true
	end

	function ENT:DrawScreen()
		if (!self.panel or halo.RenderedEntity() == self) then
			return
		end

		local up = self:GetUp()
		local right = self:GetRight()
		local forward = self:GetForward()

		local drawAng = self:GetAngles()
		drawAng:RotateAroundAxis(up, -90)
		drawAng:RotateAroundAxis(right, 90)

		local drawPos = self:GetPos()
		drawPos:Add(right * (halfWide - 43) + up * (screenHeight - 26) + forward * -24)

		vgui.Start3D2D(drawPos, drawAng + Angle(0,-10,0), scale)
		vgui.MaxRange3D2D(84)
		self.panel:Paint3D2D()
		vgui.End3D2D()
	end

	function ENT:Draw()
		self:DrawModel()

		if (EyePos():DistToSqr(self:GetPos()) < 16000) then
			self:DrawScreen()
		end
	end

	function ENT:OnRemove()
		if (IsValid(self.panel)) then
			self.panel:Remove()
		end
		self:StopSound("trexhla/civil_station_alarme.wav")
		if (IsValid(self.light)) then
			self.light:Remove()
		end
	end
end
