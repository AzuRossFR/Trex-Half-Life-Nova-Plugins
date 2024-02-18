PLUGIN.name = "Passive Dispatch"
PLUGIN.description = "Automatic dispatch"
PLUGIN.author = "Stalker"

ix.util.Include("sv_hooks.lua")

do
	local CLASS = {}
	CLASS.color = Color(231,59,47)
	CLASS.format = "Annonce Milice \"%s\""

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, ix.util.GetMaterial("trexhln/chat/dispatch_icon.png"), string.format(self.format, text))
	end

	ix.chat.Register("dispatchs", CLASS) 
end   