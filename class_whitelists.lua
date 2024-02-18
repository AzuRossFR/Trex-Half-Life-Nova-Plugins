local PLUGIN = PLUGIN

PLUGIN.name = "Class Whitelists"
PLUGIN.description = "Allows classes to be obtainable with whitelists."
PLUGIN.author = "wowm0d"

ix.lang.AddTable("french", {
	cmdPlyUnClassWhitelist = "Interdit à quelqu'un de passer à une classe spécifique au sein d'une faction.",
	cmdPlyClassWhitelist = "Permet à quelqu'un de passer à une classe spécifique au sein d'une faction.",
	classwhitelist = "%s a ajouté %s à la liste blanche pour la classe %s.",
	unclasswhitelist = "%s a retiré %s de la liste blanche de la classe %s."
})

local playerMeta = FindMetaTable("Player")

function playerMeta:HasClassWhitelist(class)
	local data = ix.class.list[class]
	if (data) then
		if (data.isDefault) then
			return true
		end

		local clientData = self:GetData("classWhitelists", {})

		return clientData[Schema.folder] and clientData[Schema.folder][data.uniqueID]
	end

	return false
end

if (SERVER) then
	function playerMeta:SetClassWhitelisted(class, whitelisted)
		if (whitelisted != true) then
			whitelisted = nil
		end

		local data = ix.class.list[class]

		if (data) then
			local classWhitelists = self:GetData("classWhitelists", {})
			classWhitelists[Schema.folder] = classWhitelists[Schema.folder] or {}
			classWhitelists[Schema.folder][data.uniqueID] = whitelisted

			self:SetData("classWhitelists", classWhitelists)
			self:SaveData()

			return true
		end

		return false
	end
end

do
	local COMMAND = {}
	COMMAND.arguments = {ix.type.player, ix.type.text}
	COMMAND.superAdminOnly = true
	COMMAND.privilege = "Manage Character Whitelist"
	COMMAND.description = "@cmdPlyClassWhitelist"

	function COMMAND:OnRun(client, target, name)
		if (name == "") then
			return "@invalidArg", 2
		end

		local class = ix.class.list[name]

		if (!class) then
			for _, v in ipairs(ix.class.list) do
				if (ix.util.StringMatches(L(v.name, client), name) or ix.util.StringMatches(v.uniqueID, name)) then
					class = v

					break
				end
			end
		end

		if (class) then
			if (target:SetClassWhitelisted(class.index, true)) then
				for _, v in ipairs(player.GetAll()) do
					v:NotifyLocalized("classwhitelist", client:GetName(), target:GetName(), L(class.name, v))
				end
			end
		else
			return "@invalidClass"
		end
	end

	ix.command.Add("PlyClassWhitelist", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = {ix.type.string, ix.type.text}
	COMMAND.superAdminOnly = true
	COMMAND.privilege = "Manage Character Whitelist"
	COMMAND.description = "@cmdPlyUnClassWhitelist"

	function COMMAND:OnRun(client, target, name)
		if (name == "") then
			return "@invalidArg", 2
		end

		local class = ix.class.list[name]

		if (!class) then
			for _, v in ipairs(ix.class.list) do
				if (ix.util.StringMatches(L(v.name, client), name) or ix.util.StringMatches(v.uniqueID, name)) then
					class = v

					break
				end
			end
		end

		if (class) then
			local targetPlayer = ix.util.FindPlayer(target)

			if (IsValid(targetPlayer) and targetPlayer:SetClassWhitelisted(class.index, false)) then
				for _, v in ipairs(player.GetAll()) do
					v:NotifyLocalized("unclasswhitelist", client:GetName(), targetPlayer:GetName(), L(class.name, v))
				end
			else
				local steamID64 = util.SteamIDTo64(target)
				local query = mysql:Select("ix_players")
					query:Select("data")
					query:Where("steamid", steamID64)
					query:Limit(1)
					query:Callback(function(result)
						if (istable(result) and #result > 0) then
							local data = util.JSONToTable(result[1].data or "[]")
							local whitelists = data.classWhitelists and data["classWhitelists"][Schema.folder]

							if (whitelists and whitelists[class.uniqueID]) then
								whitelists[class.uniqueID] = nil
								data["classWhitelists"][Schema.folder] = whitelists

								local updateQuery = mysql:Update("ix_players")
									updateQuery:Update("data", util.TableToJSON(data))
									updateQuery:Where("steamid", steamID64)
								updateQuery:Execute()

								for _, v in ipairs(player.GetAll()) do
									v:NotifyLocalized("unclasswhitelist", client:GetName(), target, L(class.name, v))
								end
							end
						end
					end)
				query:Execute()
			end
		else
			return "@invalidClass"
		end
	end

	ix.command.Add("PlyUnClassWhitelist", COMMAND)
end