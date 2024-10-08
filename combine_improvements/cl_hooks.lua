local PLUGIN = PLUGIN

PLUGIN.SocioStatus = PLUGIN.SocioStatus or "STABLE"

PLUGIN.BOL = PLUGIN.BOL or {}

local StatCol = {
  FRACTURED = Color(255, 0, 0),
  MARGINAL = Color(255, 255, 0),
  STABLE = Color(0, 255, 0)
}


net.Receive("UpdateObjectives",function()

  local NewStatus = net.ReadString()
  local BOLTable = net.ReadTable()

  PLUGIN.SocioStatus = NewStatus

  PLUGIN.BOL = BOLTable

end)


net.Receive("BOL", function()
  local ply = net.ReadEntity()
  local Add = net.ReadBool()

  if Add == true then
    PLUGIN.BOL[#PLUGIN.BOL + 1] = ply:GetName()
  else
    table.RemoveByValue(PLUGIN.BOL, ply:GetName())
  end
end)

net.Receive("SoundEvent", function()

  local sound = net.ReadString()

  LocalPlayer():EmitSound(sound)

end)


function PLUGIN:PopulateEntityInfo(ent, tooltip)
  if ent:GetClass() == "ix_citizenterminal" then
    local name = tooltip:AddRow("name")
    name:SetText("Terminal Citoyen")
    name:SetBackgroundColor(Color(0, 110, 230))
    name:SetImportant()
    name:SizeToContents()

    local desc = tooltip:AddRowAfter("name", "desc")
    desc:SetText("Un terminal vous demandant d'introduire votre CID")
    desc:SetBackgroundColor(Color(0, 110, 230))
    desc:SizeToContents()
  end

  if LocalPlayer():IsCombine() and (ent:GetClass() == "ix_cpterminal" or ent:GetClass() == "ix_commandterminal") then
    local name = tooltip:AddRow("name")
    name:SetText("Terminal Combine")
    name:SetBackgroundColor(Color(0, 110, 230))
    name:SetImportant()
    name:SizeToContents()

    local desc = tooltip:AddRowAfter("name", "desc")
    desc:SetText("Un terminal vous demandant votre numéro d'exploitation du Cartel pour accéder à la data d'OverWatch")
    desc:SetBackgroundColor(Color(0, 110, 230))
    desc:SizeToContents()
  end
end

function PLUGIN:HUDPaint()
  if LocalPlayer():IsCombine() then

    local tsin = TimedSin(.75, 120, 255, 0)
    local NewStatus = self.SocioStatus
    local StatusCol = self.SocioStatusCol[NewStatus]
    local area = LocalPlayer():GetArea() -- What was the purpose of this?
    if NewStatus == "JW" then
      StatusCol = Color(tsin, 0, 0)
    elseif NewStatus == "AJW" then
      StatusCol = Color(tsin, tsin, tsin)
    end

    local AllCitizens = {}
    local AllUnits = {}

    for client, char in ix.util.GetCharacters() do
      if char:GetFaction() == FACTION_CITIZEN then
        AllCitizens[#AllCitizens + 1] = char:GetName() .. ": #" .. client:GetNWString("cid", "<ERR>")
      elseif char:IsCombine() then
        AllUnits[#AllUnits + 1] = char:GetName()
      end
    end

    local CitizenManifest = table.concat(AllCitizens, "\n")
    local List = table.concat(self.BOL, "\n")
    for client, char in ix.util.GetCharacters() do
      local bone = client:LookupBone("ValveBiped.Bip01_Head1")
      local bonepos
      if bone then
        bonepos = client:GetBonePosition(bone) + Vector(0, 0, 14)
      else
        bonepos = client:GetPos() + Vector(0, 0, 80)
      end
      local ToScreen = bonepos:ToScreen()
      local distance = LocalPlayer():GetPos():Distance(bonepos)
      local CanSee = LocalPlayer():IsLineOfSightClear(client)
      if char:GetFaction() == FACTION_CITIZEN and client:Alive() and (client:GetMoveType() != MOVETYPE_NOCLIP) then
        local cid = client:GetNWString("cid", "ERR NO CID")
        local cstatus = client:GetNWString("CivilStatus", "NO CIVIL STATUS")
        local statcol = StatCol[cstatus] or Color(255, 0, 0)

        if distance < 275 and CanSee then

          draw.SimpleText(":: CID: #" .. cid .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          draw.SimpleText(":: Statut de citoyen: " .. cstatus .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y + 15, statcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          if client:GetActiveWeapon() != NULL and client:IsWepRaised() then
            draw.SimpleText(":: Evaluation: EXPURGER ::", "BudgetLabel", ToScreen.x, ToScreen.y + 30, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          elseif table.HasValue(self.BOL, client:GetName()) or client:GetNWString("CivilStatus", "NO CIVIL STATUS") == "Anti-Citizen" then
            draw.SimpleText(":: Evaluation: PACIFIÉ ::", "BudgetLabel", ToScreen.x, ToScreen.y + 30, Color(255, 100, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          else
            draw.SimpleText(":: Evaluation: SURVEILLANCE ::", "BudgetLabel", ToScreen.x, ToScreen.y + 30, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          end

        elseif distance > 275 and distance < 450 and CanSee then
          if client:GetActiveWeapon() != NULL and client:IsWepRaised() then
            draw.SimpleText(":: Evaluation: EXPURGER ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          elseif table.HasValue(self.BOL, client:GetName()) or client:GetNWString("CivilStatus", "NO CIVIL STATUS") == "Anti-Citizen" then
            draw.SimpleText(":: Evaluation: PACIFIÉ ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 100, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          else
            draw.SimpleText(":: Evaluation: SURVEILLANCE ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          end
        end
      elseif char:GetFaction() == FACTION_MPF and client:Alive() and (client:GetMoveType() != MOVETYPE_NOCLIP) and client != LocalPlayer() then
        local unitdigits = string.match(client:GetName(), self.Numbers)
      --[[If you use city digits that are as long as ID digits this won't work eg. i17:i5.UNION-24,
          unless you edit this line to be string.match(client:GetName(), self.Numbers, (num)), num being how many characters of the string to skip before searching
          for my example the number would be 7, this is because 7 characters in is the . which is after the last unwanted number (5)]]
        local unitrank
        local division

        for _, v in ipairs(self.Ranks) do
          if string.match(client:GetName(), v[1]) then
            unitrank = v[1]
            break
          end
        end

        for _, v in ipairs(self.Divisions) do
          if string.match(client:GetName(), v) then
            division = v
            break
          end
        end

        if !unitdigits or !division or !unitrank then
          draw.SimpleText(":: AVERTISSEMENT SIGNAL D'UNITÉ MALFORMÉE ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          return
        end

        if distance < 275 and CanSee then
          draw.SimpleText(":: TAG DE L'UNITÉ: " .. division .. "-" .. unitdigits .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          draw.SimpleText(":: Rang de l'UNITÉ: " .. unitrank .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y + 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          if unitrank == "RC" then
            draw.SimpleText(":: Evaluation: SACRIFICE ::", "BudgetLabel", ToScreen.x, ToScreen.y + 30, Color(tsin, tsin, tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          else
            draw.SimpleText(":: Evaluation: PROTÉGER ::", "BudgetLabel", ToScreen.x, ToScreen.y + 30, Color(0, 110, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          end
        elseif distance > 275 and distance < 450 and CanSee then
          if unitrank == "RC" then
            draw.SimpleText(":: Evaluation: SACRIFICE ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(tsin, tsin, tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          else
            draw.SimpleText(":: Evaluation: PROTÉGER ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(0, 110, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          end
        elseif ix.config.Get("UnobstructedBioSig") == false then
          if CanSee then
            draw.SimpleText("::" .. division .. "-" .. unitdigits .. "::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(0, 110, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          end
        else
          draw.SimpleText("::" .. division .. "-" .. unitdigits .. "::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(0, 110, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end


      elseif char:GetFaction() == FACTION_OTA and client:Alive() and client != LocalPlayer() and client:GetMoveType() != MOVETYPE_NOCLIP then
        local unitdigits = string.match(client:GetName(), "%d%d%d%d%d")
        local unitrank = string.match(client:GetName(), "GRT") or string.match(client:GetName(), "ORD")

        if !unitdigits or !division or !unitrank then
          draw.SimpleText(":: Unité Transhumaine ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          return
        end

        if LocalPlayer():GetCharacter():GetFaction() != FACTION_OTA and distance < 275 and CanSee then
          draw.SimpleText(":: ID UNITE: #" .. math.random(11111, 99999) .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          draw.SimpleText(":: ID UNITE: #" .. math.random(111, 999) .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y + 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          draw.SimpleText(":: Evaluation: SACRIFICE ::", "BudgetLabel", ToScreen.x, ToScreen.y + 30, Color(tsin, tsin, tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif LocalPlayer():GetCharacter():GetFaction() == FACTION_OTA and distance < 275 and CanSee then
          draw.SimpleText(":: ID UNITE: #" .. unitdigits .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          draw.SimpleText(":: ID UNITE: #" .. unitrank .. " ::", "BudgetLabel", ToScreen.x, ToScreen.y + 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
          draw.SimpleText(":: Evaluation: SACRIFICE ::", "BudgetLabel", ToScreen.x, ToScreen.y + 30, Color(tsin, tsin, tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif distance > 275 and distance < 450 and CanSee then
          draw.SimpleText(":: Evaluation: SACRIFICE ::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(tsin, tsin, tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif LocalPlayer():GetCharacter():GetFaction() == FACTION_OTA then
          draw.SimpleText("::#" .. unitdigits .. "::", "BudgetLabel", ToScreen.x, ToScreen.y, Color(150, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
      end
    end
  end
end

netstream.Hook("MPFTerminalUse", function()
  vgui.Create("ixMPFTerminal"):PopulateCitizens()
end)

surface.CreateFont("BigLabel", {
  font = "BudgetLabel",
  size = 22,
  outline = true,
  weight = 20,
  extended = true,
  shadow = true
})



netstream.Hook("CitizenTerminalUse", function()
  vgui.Create("ixCitizenTerminal"):PopulateInfo()
end)



netstream.Hook("HCTerminalUse", function()
  vgui.Create("ixHCTerminal"):PopulateUnits()
end)


-- Credits to val for the idea

netstream.Hook("PDAUse", function(data) -- called PDA use since it is based on a custom request
  local civ = data[1]
  local civRecord = data[2]
  local civPoints = data[3]
  vgui.Create("ixDataView"):PopulateInfo(civ, civRecord, civPoints)
end)

netstream.Hook("MPFTerminalUse", function()
  vgui.Create("ixMPFTerminal"):PopulateCitizens()
end)

surface.CreateFont("BigLabel", {
  font = "BudgetLabel",
  size = 22,
  outline = true,
  weight = 20,
  extended = true,
  shadow = true
})



netstream.Hook("CitizenTerminalUse", function()
  vgui.Create("ixCitizenTerminal"):PopulateInfo()
end)



netstream.Hook("HCTerminalUse", function()
  vgui.Create("ixHCTerminal"):PopulateUnits()
end)


-- Credits to val for the idea

netstream.Hook("PDAUse", function(data) -- called PDA use since it is based on a custom request
  local civ = data[1]
  local civRecord = data[2]
  local civPoints = data[3]
  vgui.Create("ixDataView"):PopulateInfo(civ, civRecord, civPoints)
end)
