ITEM.name = "Carte d'Indentification"
ITEM.model = Model("models/sky/cid.mdl")
ITEM.description = "Une carte d'identification standard du Cartel."
ITEM.category = "misc"

function ITEM:IsWorker()
  return self:GetData("cwu", false)
end

function ITEM:GetModel()
  if self:IsWorker() then
    return "models/sky/cwuid.mdl"
  else
    return self.model
  end
end

function ITEM:GetDescription()
  if self:IsWorker() then
    return "A standard Universal Union Worker's identification card."
  else
    return self.description
  end
end

function ITEM:GetName()
  if self:IsWorker() then
    return "Worker ID Card"
  else
    return self.name
  end
end

function ITEM:PopulateTooltip(tooltip)
  if !self:IsWorker() then
    local data = tooltip:AddRow("data")
    data:SetBackgroundColor(Color(0, 120, 230))
    data:SetText("Name: " .. self:GetData("owner_name", "UNISSUED") .. "\n" .. "ID CITOYEN: #" .. self:GetData("cid", "AUCUNE IDENTIFICATION"))
    data:SizeToContents()
  else
    local data = tooltip:AddRow("data")
    data:SetBackgroundColor(Color(0, 120, 230))
    data:SetText("Name: " .. self:GetData("owner_name", "UNISSUED") .. "\n" .. "Worker ID: #" .. self:GetData("cid", "NO CID ISSUED"))
    data:SizeToContents()
  end

  local data2 = tooltip:AddRow("data")
  data2:SetBackgroundColor(Color(255, 0, 0))
  data2:SetFont("BudgetLabel")
  data2:SetText("ATTENTION ! Cette carte d'identité contient une puce RFID émise par le Cartel. Le fait de ne pas porter cette carte d'identité entraînera des poursuites de la part des unités de la protection civile.")
  data2:SizeToContents()
end

ITEM.functions.Assign = {
  name = "Assign CID",
  OnRun = function(item)
    local client = item.player

    local ent = client:GetEyeTrace().Entity
    if ent:IsPlayer() then
      item:SetData("owner_name", ent:GetName())
      item:SetData("cid", ent:GetNWString("cid", "ERR NO CID"))
    else
      client:Notify("Vous n'êtes pas en présence d'un citoyen valide")
    end
    return false
  end,


  OnCanRun = function(item)
    if item:GetData("owner_name") == nil and item:GetData("cid") == nil and item.player:IsCombine() then
      return true
    else
      return false
    end
  end
}

ITEM.functions.Assign = {
  name = "Set Worker",
  OnRun = function(item)
    item:SetData("cwu", true)
    item.player:Notify("Vous avez fait de cette carte une carte de travailleur")
    return false
  end,


  OnCanRun = function(item)
    if item:GetData("cwu", false) != true and item.player:IsCombine() then
      return true
    else
      return false
    end
  end
}
