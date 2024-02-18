AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "CCA Terminal"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true
ENT.RenderGroup = RENDERGROUP_BOTH


if SERVER then

  function ENT:Initialize()
      self:SetModel("models/hla_combine_props/combine_breenconsole.mdl") -- models/props_combine/breenconsole.mdl
      self:SetSolid(SOLID_VPHYSICS)
  end


  function ENT:SetupDataTables()
      self:NetworkVar("String", 0, "UserName")
  end



  function ENT:Use(act)
    self:SetUseType(SIMPLE_USE)
    local char = act:GetCharacter()
    if (!char:IsCombine()) then
      act:Notify("Vous n'êtes pas un Agent de la PROTECTION CIVILE!")
      act:EmitSound("buttons/combine_button_locked.wav", 75, 120)
    else
      netstream.Start(act, "MPFTerminalUse")
      act:EmitSound("buttons/combine_button5.wav", 75, 120)
    end
  end

end

if CLIENT then
  function ENT:Draw() -- Credits to ZeMysticalTaco for code
    self:DrawModel()

    local ang = self:GetAngles()
    local pos = self:GetPos() + ang:Up() * 47 + ang:Right() * -5 + ang:Forward() * -8.75

  end

end
