ix.command.Add("ClearDecals", {
    description = "Clears all decals for all players.",
    adminOnly = true,
    OnRun = function(self, client)
		for k, v in pairs(player.GetAll()) do
			v:ConCommand("r_cleardecals");
			client:Notify("You have cleared all decals.")
		end;
	end;
})