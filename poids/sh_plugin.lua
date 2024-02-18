PLUGIN.name = "Poids"
PLUGIN.author = "Trex"
PLUGIN.description = ""

color_hln = Color(255,255,255)

surface.CreateFont("ToolCHud5", {
	font = "Nagonia",
	size = 35,
	extended = true,
	scanlines = 0,
})

surface.CreateFont("ToolCHud1", {
	font = "Nagonia",
	size = 22,
	extended = true,
	scanlines = 0,
})

surface.CreateFont("ToolCHud1.5", {
	font = "Nagonia",
	size = ScreenScale(5),
	extended = true,
	scanlines = 0,
})


surface.CreateFont("ToolCHud2", {
	font = "Nagonia",
	size = ScreenScale(6),
	extended = true,
	scanlines = 0,
})

surface.CreateFont("ToolCHud2.5", {
	font = "Nagonia",
	size = ScreenScale(12),
	scanlines = 0,
})

ix.weight = ix.weight or {}

ix.config.Add("maxWeight", 30, "Le poids maximum en kilogrammes qu'une personne peut transporter dans son inventaire.", nil, {
	data = {min = 1, max = 100},
	category = "Weight"
})

ix.config.Add("maxOverWeight", 20, "Le poids maximum en kilogrammes qu'ils peuvent dépasser leur limite de poids doit être inférieur à maxWeight pour éviter les problèmes.", nil, {
	data = {min = 1, max = 100},
	category = "Weight"
})

ix.util.Include("sh_meta.lua")
ix.util.Include("sv_plugin.lua")

function ix.weight.WeightString(weight, imperial)
	if (imperial) then
		if (weight < 0.453592) then -- Filthy imperial system; Why do I allow their backwards thinking?
			return math.Round(weight * 35.274, 2).." oz"
		else
			return math.Round(weight * 2.20462, 2).." lbs"
		end
	else
		if (weight < 1) then -- The superior units of measurement.
			return math.Round(weight * 1000, 2).." g"
		else
			return math.Round(weight, 2).." kg"
		end
	end
end

function ix.weight.BaseWeight(character)
	local base = ix.config.Get("maxWeight", 30)

	return base
end

function ix.weight.CanCarry(weight, carry, character) -- Calculate if you are able to carry something.
	local max = ix.weight.BaseWeight(character) + ix.config.Get("maxOverWeight", 20)

	return (weight + carry) <= max
end

if (CLIENT) then
	function PLUGIN:PopulateItemTooltip(tooltip, item)
		local weight = item:GetWeight() or 0
		local weaponkit = item.isWeaponKit == true
		local bag = item.isBag == true
		local shadeColor = Color(0, 0, 0, 200)
		local blockSize = 4
		local blockSpacing = 2

		local maxDurability = item.maxDurability or ix.config.Get("maxValueDurability", 100)
		local durability = math.Clamp(math.floor(item:GetData("durability", maxDurability)), 0, maxDurability)
		durability = math.max(0, math.floor((durability / maxDurability) * 100))
		local durabilite = Format("%s %s%% / 100%%", "", durability)
		local quantity = item:GetData("quantity", item.quantity or 1)

		local name = tooltip:GetRow("name")
		name:SetText((item:GetName().. " | "..item:GetRarityName()):utf8upper())
		name:SetTextColor(color_white)
		name:SetFont("ToolCHud1")
		name:SetBackgroundColor(item:GetRarityColor())
		name:SetExpensiveShadow(0,Color(0,0,0))

		local desc = tooltip:GetRow("description")
		desc:SetText(item:GetDescription())
		desc:SetFont("ToolCHud2")
		desc:SetTextColor(color_hln)
		desc:SetBackgroundColor(color_black)
		desc:SetExpensiveShadow(0,Color(0,0,0))

		local panelinfo = desc:Add("Panel")
		panelinfo:Dock(BOTTOM)

		local poidsicon = panelinfo:Add("Panel")
		poidsicon:Dock(LEFT)
		poidsicon:SetWide(Schema:RX(30))
		poidsicon.Paint = function(s,w,h)
			surface.SetDrawColor(color_hln)
			surface.SetMaterial(Material("trex/ui/poids.png", "noclamp smooth"))
			surface.DrawTexturedRect(5,0,Schema:RX(20), Schema:RY(20))
		end

		local poids = panelinfo:Add("DLabel")
		poids:SetText(" "..ix.weight.WeightString(weight) or "???")
		poids:Dock(LEFT)
		poids:SetWide(Schema:RX(50))
		poids:SetFont("ToolCHud2")
		poids:SetTextColor(color_hln)

		local tailleicon = panelinfo:Add("Panel")
		tailleicon:Dock(LEFT)
		tailleicon:DockMargin(Schema:RX(20),0,0,0)
		tailleicon:SetWide(Schema:RX(50))
		tailleicon.Paint = function(s,w,h)
			local x, y = w * 0.3 - 1, h * 0.5 - 1
			local itemWidth = item.width - 1
			local itemHeight = item.height - 1
			local heightDifference = ((itemHeight + 1) * blockSize + blockSpacing * itemHeight)
			x = x - (itemWidth * blockSize + blockSpacing * itemWidth) * 0.5
			y = y - heightDifference * 0.5
			for i = 0, itemHeight do
				for j = 0, itemWidth do
					local blockX, blockY = x + j * blockSize + j * blockSpacing, y + i * blockSize + i * blockSpacing
			
					surface.SetDrawColor(shadeColor)
					surface.DrawRect(blockX + 1, blockY + 1, blockSize, blockSize)
			
					surface.SetDrawColor(color_hln)
					surface.DrawRect(blockX, blockY, blockSize, blockSize)
				end
			end
		end

		local taille = panelinfo:Add("DLabel")
		taille:SetText(item.width.." par ".. item.height)
		taille:Dock(LEFT)
		taille:SetWide(taille:GetTextSize() + Schema:RX(20))
		taille:SetFont("ToolCHud1.5")
		taille:SetTextColor(color_hln)

		local duraicon = panelinfo:Add("Panel")
		duraicon:Dock(LEFT)
		duraicon:DockMargin(Schema:RX(20),0,0,0)
		duraicon:SetWide(Schema:RX(30))
		duraicon.Paint = function(s,w,h)
			surface.SetDrawColor(color_hln)
			surface.SetMaterial(Material("trex/ui/wrench.png", "noclamp smooth"))
			surface.DrawTexturedRect(5,0,Schema:RX(20), Schema:RY(20))
		end

		local durabilitytext = panelinfo:Add("DLabel")
		if !weaponkit and !bag then
			durabilitytext:SetText(durabilite)
		elseif weaponkit then
			durabilitytext:SetText(quantity.." Utilisation(s)")
		elseif bag then
			durabilitytext:SetText("∞ / ∞")
		end
		durabilitytext:Dock(LEFT)
		durabilitytext:SetWide(durabilitytext:GetTextSize() + Schema:RX(50))
		durabilitytext:SetFont("ToolCHud2")
		durabilitytext:SetTextColor(color_hln)
	end
end

