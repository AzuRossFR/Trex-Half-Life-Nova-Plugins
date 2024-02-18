local PLUGIN = PLUGIN

PLUGIN.name = "Faction Limit"
PLUGIN.author = "Khall"
PLUGIN.description = "Limite de Faction."

function PLUGIN:CanPlayerUseCharacter(client, character)
    local faction = ix.faction.Get(character:GetFaction())
    local class = ix.class.Get(character:GetClass())

    if (faction.limit and team.NumPlayers(faction.index) >= faction.limit) then
        return false, L("Il y a trop de personne dans la faction "..faction.name, client, faction.name)
    end
end