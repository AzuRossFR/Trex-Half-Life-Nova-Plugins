local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Command Terminal"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true
ENT.RenderGroup = RENDERGROUP_BOTH


if SERVER then

  function ENT:Initialize()
      self:SetModel("models/hla_combine_props/combine_console_main_1.mdl") -- models/props_combine/breenconsole.mdl
      self:SetSolid(SOLID_VPHYSICS)
  end


  function ENT:SetupDataTables()
      self:NetworkVar("String", 0, "UserName")
  end



  function ENT:Use(act)
    self:SetUseType(SIMPLE_USE)
    local char = act:GetCharacter()
    local hc
    for _, v in ipairs(PLUGIN.Ranks) do
      if v[4] == true and string.match(act:GetName(), v[1]) then
        hc = true
        break
      else
        hc = false
      end
    end
    if (!char:IsCombine()) then
      act:Notify("Vous n'êtes pas un Agent de la Proteciton Civile!")
      act:EmitSound("buttons/combine_button_locked.wav", 75, 120)
    elseif char:IsCombine() and !hc then
      act:Notify("Vous n'avez pas un rang assez élevé")
      act:EmitSound("buttons/combine_button_locked.wav", 75, 120)
      --act:EmitSound("buttons/combine_button5.wav", 75, 120)
    elseif char:IsCombine() and hc then
      netstream.Start(act, "HCTerminalUse")
      act:EmitSound("buttons/combine_button5.wav", 75, 120)
    end
  end

end

if CLIENT then
  function ENT:Draw() -- Credits to ZeMysticalTaco for code
    self:DrawModel()

    local ang = self:GetAngles()
    local pos = self:GetPos() + ang:Up() * 49 + ang:Right() * 10 + ang:Forward() * -2.3

  end

end
