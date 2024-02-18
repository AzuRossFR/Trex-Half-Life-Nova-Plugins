local PLUGIN = PLUGIN

PLUGIN.name = "Level System"
PLUGIN.author = "TrexStudio"
PLUGIN.description = ""

PLUGIN.maxLevel = 50

ix.util.Include("cl_hooks.lua")

ix.char.RegisterVar("level", {
	field = "level",
	fieldType = ix.type.number,
	default = 1,
	isLocal = false,
	bNoDisplay = true
})

ix.char.RegisterVar("levelXP", {
	field = "levelXP",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})

function PLUGIN:GetRequiredLevelXP(currentLevel)
	return 50 * (currentLevel - 1) ^ 2.25 + (75 + (currentLevel * 25))
end

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_plugin.lua")

ix.command.Add("Roll", {
	description = "@cmdRoll",
	OnRun = function(self, client, maximum)
		local rolls = client:GetCharacter():GetRolls()
		local value = math.random(rolls[1], rolls[2])

		ix.chat.Send(client, "roll", tostring(value), nil, nil, {
			max = rolls[2]
		})

		ix.log.Add(client, "roll", value, rolls[2])
	end
})

ix.command.Add("CharSetLevel", {
	description = "",
	privilege = "Manage Character Levels",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, targetValue)
		local lastLVL = target:GetLevel()
		targetValue = math.Clamp(targetValue, 1, PLUGIN.maxLevel)

		target:SetLevel(targetValue)

		if targetValue > lastLVL then
			target:SetData("levelup", true)
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 1,
			})
		else
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 3,
			})
		end

		return "Vous avez réussi à changer le niveau avec succès."
	end
})

ix.command.Add("CharAddLevel", {
	description = "",
	privilege = "Manage Character Levels",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, targetValue)
		local lastLVL = target:GetLevel()
		targetValue = math.Clamp(lastLVL + targetValue, 1, PLUGIN.maxLevel)

		target:SetLevel(targetValue)

		if targetValue > lastLVL then
			target:SetData("levelup", true)
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 1,
			})
		else
			ix.chat.Send(nil, "level", "", nil, {target:GetPlayer()}, {
				t = 3,
			})
		end

		return "Vous avez réussi à ajouter des niveaux avec succès."
	end
})

ix.command.Add("CharAddLevelXP", {
	description = "",
	privilege = "Manage Character Levels",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, xp)
		target:AddLevelXP(xp)

		return "Vous avez réussi à ajouter de l'expérience avec succès."
	end
})