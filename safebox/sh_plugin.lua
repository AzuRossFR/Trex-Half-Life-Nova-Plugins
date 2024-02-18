PLUGIN.name = "Safebox"
PLUGIN.author = "STEAM_0:1:29606990"
PLUGIN.description = "Personal storage of items for players."

ix.config.Add("safeInvWidth", 5, "Combien d'emplacements d'affilée y a-t-il dans l'inventaire d'un coffre-fort.", nil, {
	data = {min = 0, max = 20},
	category = PLUGIN.name
})

ix.config.Add("safeInvHeight", 5, "Combien d'emplacements dans une colonne il y a dans un inventaire de coffre-fort.", nil, {
	data = {min = 0, max = 20},
	category = PLUGIN.name
})

ix.config.Add("safeboxOpenTime", 0.5, "Combien de temps faut-il pour ouvrir un coffre-fort.", nil, {
	data = {min = 0, max = 50, decimals = 1},
	category = PLUGIN.name
})

ix.safebox = ix.safebox or {}
ix.util.Include("sv_plugin.lua")

function PLUGIN:InitializedPlugins()
	ix.inventory.Register("safebox", ix.config.Get("safeInvWidth"), ix.config.Get("safeInvHeight"))
end

if (CLIENT) then
	net.Receive("ixSafeboxOpen", function()
		if (IsValid(ix.gui.menu)) then
			return
		end

		local client = LocalPlayer()
		local character = client:GetCharacter()

		if (!character) then
			return
		end

		local index = character:GetData("safeboxID")
		local inventory = ix.inventory.Get(index)

		if (inventory and inventory.slots) then
			local localInventory = character:GetInventory()
			local panel = vgui.Create("ixStorageView")

			if (localInventory) then
				panel:SetLocalInventory(localInventory)
			end

			panel:SetStorageID(index)
			panel:SetStorageInventory(inventory)
		end
	end)
end