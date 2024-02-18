PLUGIN.name = "Blacklist"
PLUGIN.author = "Khall"
PLUGIN.description = ""

local blacklist =
{
["STEAM_0:1:172934589"] = {raison =  "Blacklist communauté, aucun déban possible"}, -- Smoke (by toute la direction)
["STEAM_0:1:707671750"] = {raison =  "Blacklist communauté, aucun déban possible"}, -- kowalski (by Khall)
["STEAM_1:0:139007665"] = {raison =  "Blacklist communauté, aucun déban possible"}, -- Zekirax (by Khall)
["STEAM_1:1:810576354"] = {raison =  "Blacklist communauté, aucun déban possible"}, -- Zothh (by Khall)
["STEAM_0:1:527569401"] = {raison =  "Blacklist communauté, aucun déban possible"}, -- Mulex Deus (by Khall)
}
if SERVER then
	function PLUGIN:PlayerAuthed(client, steamid, uniqueid)
		if blacklist[client:SteamID()] then
			client:Kick("Vous êtes blacklist de TrexSCP. " ..blacklist[client:SteamID()].raison)
			client:Ban(0, false)
		end
	end
end