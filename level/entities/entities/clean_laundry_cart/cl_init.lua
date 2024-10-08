include("shared.lua")

function ENT:Draw()
  self:DrawModel()

  local pos = self:LocalToWorld(self:OBBCenter())
  local ang = self:GetAngles()
  local nb = "<clothes> Vêtements propre"
  local phrase = string.gsub(nb, "<clothes>", self:GetClothesNumber())

  cam.Start3D2D(pos + (ang:Up() * 5) + (ang:Right() * 21), ang + Angle(0,0,90), 0.25)
    draw.SimpleText(tostring(phrase), "CHud2", 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  cam.End3D2D()
end
