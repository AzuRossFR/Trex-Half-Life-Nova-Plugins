ix.command.Add("PlaySoundGlobal", {
    description = "Joue un son sur toute la map.",
    arguments = {
		ix.type.text
	},
    OnRun = function(self, client, sound)
	local faction = client:GetCharacter():GetFaction()
		if faction == FACTION_IAA or CAMI.PlayerHasAccess(client, "Helix - PlayGlobalSound", nil) then
        	for _, target in pairs(player.GetAll()) do
            	netstream.Start(target, "ixPlaySound", sound)
        	end

        	client:Notify("Le son : '" .. sound .. "' est joué à tout les joueurs.")
		else 
			client:Notify("Vous n'avez pas les permissions requises !")
		end
	end
})