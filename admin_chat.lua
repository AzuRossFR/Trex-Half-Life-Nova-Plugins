PLUGIN.name = "Chat Staff"
PLUGIN.author = "TrexStudio"

CAMI.RegisterPrivilege({
	Name = "Helix - Admin Chat",
	MinAccess = "admin"
})

ix.chat.Register("adminchat", {
	format = "staff",
	OnGetColor = function(self, speaker, text)
		return Color(0, 196, 255)
	end,
	OnCanHear = function(self, speaker, listener)
		if(CAMI.PlayerHasAccess(listener, "Helix - Admin Chat", nil)) then
			return true
		end

		return false
	end,
	OnCanSay = function(self, speaker, text)
		if(CAMI.PlayerHasAccess(speaker, "Helix - Admin Chat", nil)) then
			speaker:Notify("Vous n'êtes pas un administrateur. Utilisez '!ticket' pour créer un ticket.")

			return false
		end

		return true
	end,
	OnChatAdd = function(self, speaker, text)
		local icon = "icon16/user.png"

		if (speaker:IsSuperAdmin()) then
			icon = "icon16/shield.png"
		elseif (speaker:IsAdmin()) then
			icon = "icon16/star.png"
		elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
			icon = "icon16/wrench.png"
		end

		icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

		if(CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Admin Chat", nil) and CAMI.PlayerHasAccess(speaker, "Helix - Admin Chat", nil)) then
			chat.AddText( icon,Color(255, 0, 0), "[STAFF] - ", Color(225,225,225), speaker:SteamName(), ": ", Color(200, 200, 200), text)
		end
	end,
	prefix = "!ac"
})