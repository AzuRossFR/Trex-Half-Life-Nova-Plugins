ix.command.Add("AdminSearch", {
    description = "Allows an admin to search a player.",
    adminOnly = true,
    arguments = {
		ix.type.character
	},
    OnRun = function(self, client, target)
		Schema:SearchPlayer(client, target:GetPlayer())
	end;
})