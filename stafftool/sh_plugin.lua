PLUGIN = PLUGIN
PLUGIN.name = "Admin Stick"
PLUGIN.author = "TrexStudio"

MascoStick = MascoStick or {}

-------------------------
-- IX Utility Includes --
-------------------------

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("derma/cl_inventoryview.lua")
ix.util.Include("derma/cl_characterlist.lua")

---------------------------------------
-- CAMI replacement for Staff Groups --
-- Replace these ranks with your own --
---------------------------------------

MascoStick.StaffGroups = {
    ["superadmin"] = true,
    ["admin"] = true
}

------------------
-- IX Functions --
------------------

function MascoStick.GetCharacterData(CharID)
    MascoStick.CharBanOfflineSelect = mysql:Select("ix_characters");
        MascoStick.CharBanOfflineSelect:Where("id", CharID);
        MascoStick.CharBanOfflineSelect:Callback(function(result, status, lastID)
            if (type(result) == "table" and #result > 0 and result[1].data) then
                MascoStick.CharacterData.DataTable = util.JSONToTable(result[1].data)
            end
        end);
    MascoStick.CharBanOfflineSelect:Execute(true)
end

function MascoStick.SetCharacterData(CharID, key, val)
    MascoStick.GetCharacterData(CharID)
    
    MascoStick.CharacterData = MascoStick.CharacterData or {}

    if not MascoStick.CharacterData.DataTable then return false end

    MascoStick.CharacterData.DataTable[key] = val

    local JSONDataTable = util.TableToJSON(MascoStick.CharacterData.DataTable)

    MascoStick.CharBanOfflineUpdate = mysql:Update("ix_characters");
        MascoStick.CharBanOfflineUpdate:Update("data", JSONDataTable);
        MascoStick.CharBanOfflineUpdate:Where("id", CharID);
        MascoStick.CharBanOfflineUpdate:Callback(function(result, status, lastID)
            if not status then
                return false
            end
        end);
    MascoStick.CharBanOfflineUpdate:Execute();

    if ix.char.loaded[CharID] then
        ix.char.loaded[CharID]:SetData(key, val)
    end

    return true
end

-----------------
-- IX Commands --
-----------------

ix.command.Add("FlagPET", {
    description = "Gives the targeted character the PET Flags all at once.",
	arguments = {
		ix.type.number
	},
    OnRun = function(self, client, target)
        MascoStick.TargetCharacter = ix.char.loaded[target]

        if not IsValid(MascoStick.TargetCharacter) then return end
        
        if MascoStick.TargetCharacter:HasFlags("pet") then
            MascoStick.TargetCharacter:TakeFlags("pet")
            client:Notify("Vous avez repris tout les flags à " .. MascoStick.TargetCharacter:GetName())
        else
            MascoStick.TargetCharacter:GiveFlags("pet")
            client:Notify("Vous avez donné tout les flags à" .. MascoStick.TargetCharacter:GetName())
        end
    end,
    OnCheckAccess = function(self, client, charid)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            return false
        end
    end
})

ix.command.Add("SearchInventory", {
    description = "Searches the target's inventory.",
	arguments = {
		ix.type.number
	},
    OnRun = function(self, client, target)
        MascoStick.TargetCharacter = ix.char.loaded[target]

        if not IsValid(MascoStick.TargetCharacter) then return end
        
        if MascoStick.TargetCharacter == client:GetCharacter() then
            client:Notify("Vous ne pouvez pas rechercher votre propre inventaire. Veuillez réessayer.")
            return
        end
        MascoStick.TargetCharacter.InventoryID = MascoStick.TargetCharacter:GetInventory():GetID()
        MascoStick.TargetCharacter.Inventory = ix.inventory.Get(MascoStick.TargetCharacter.InventoryID)

        if (MascoStick.TargetCharacter.Inventory) then
            MascoStick.TargetCharacter.Inventory:Sync(client)
            MascoStick.TargetCharacter.Inventory:AddReceiver(client)

            MascoStick.TargetCharacter.Name = MascoStick.TargetCharacter:GetName()

            net.Start("MascoStick::OpenTargetInventory")
            net.WriteUInt(MascoStick.TargetCharacter.InventoryID, 32)
            net.WriteString(MascoStick.TargetCharacter.Name)
            net.Send(client)
        else
            client:Notify("Nous n'avons pas trouvé d'inventaire avec l'ID fourni. Veuillez réessayer.")
        end

        return false
    end,
    OnCheckAccess = function(self, client, charid)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            return false
        end
    end
})

ix.command.Add("CharacterList", {
    description = "Lists the characters of the targeted player.",
	arguments = {
		ix.type.string
	},
    OnRun = function(self, client, steamid)
        MascoStick.CharacterList = mysql:Select("ix_characters");
            MascoStick.CharacterList:Where("steamid", steamid);
            MascoStick.CharacterList:Callback(function(result, status, lastID)
                if (type(result) == "table" and #result > 0) then
                    net.Start("MascoStick::SendCharacterList")
                    MascoStick.CharacterList.Length = #result
                    net.WriteUInt(MascoStick.CharacterList.Length, 10)
                    
                    for _, character in ipairs(result) do
                        if type(character.data) == "string" then
                            MascoStick.CharacterList.UseData = util.JSONToTable(character.data) or {}
                        end
                        MascoStick.CharacterList.CharacterID = character.id
                        MascoStick.CharacterList.Name = character.name
                        MascoStick.CharacterList.Description = character.description
                        MascoStick.CharacterList.Faction = character.faction
                        MascoStick.CharacterList.Money = character.money
                        MascoStick.CharacterList.Banned = MascoStick.CharacterList.UseData.banned and "Oui" or "Non"

                        net.WriteUInt(MascoStick.CharacterList.CharacterID, 32)
                        net.WriteString(MascoStick.CharacterList.Name)
                        net.WriteString(MascoStick.CharacterList.Description)
                        net.WriteString(MascoStick.CharacterList.Faction)
                        net.WriteUInt(MascoStick.CharacterList.Money, 32)
                        net.WriteString(MascoStick.CharacterList.Banned)
                    end
                    net.Send(client)
                end
            end);
        MascoStick.CharacterList:Execute(true);
    end,
    OnCheckAccess = function(self, client, charid)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            return false
        end
    end
})

ix.command.Add("CharBanOffline", {
    description = "Bans (PK) the targeted character when they are offline.",
	arguments = {
		ix.type.number
	},
    OnRun = function(self, client, charid)
        MascoStick.SetCharacterData(charid, "banned", true)

        for _, player in ipairs(player.GetAll()) do
            if player:GetCharacter() and player:GetCharacter():GetID() == charid then
                if not IsValid(player) then return end
                
                player:GetCharacter():Kick()
                break
            end
        end

        client:Notify("Vous avez banni (PK) le personnage ID #" .. charid)
    end,
    OnCheckAccess = function(self, client, charid)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            return false
        end
    end
})

ix.command.Add("CharUnbanOffline", {
    description = "Unbans (Un-PK) the targeted character when they are offline.",
	arguments = {
		ix.type.number
	},
    OnRun = function(self, client, charid)
        MascoStick.SetCharacterData(charid, "banned", nil)

        client:Notify("Vous avez dé-banni (UnPK) le personnage ID #" .. charid)
    end,
    OnCheckAccess = function(self, client, charid)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            return false
        end
    end
})