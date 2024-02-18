local ix = ix

ix.quickmenu = {}
ix.quickmenu.stored = {}

local function Recognize(level)
	net.Start("ixRecognize")
		net.WriteUInt(level, 2)
	net.SendToServer()
end

function ix.quickmenu:AddCallback(name, icon, callback, shouldShow)
	self.stored[#ix.quickmenu.stored+1] = {
		shouldShow = shouldShow,
		callback = callback,
		name = name,
		icon = icon
	};
end;

ix.quickmenu:AddCallback("Permettre à la personne que vous regardez de vous reconnaître", "icon16/arrow_up.png", function()
	Recognize(0)
end)

ix.quickmenu:AddCallback("Fouiller la personne en face de vous", "icon16/briefcase.png", function()
	ix.command.Send("CharSearch")
end)

ix.quickmenu:AddCallback("Modifier votre description", "icon16/note_edit.png", function()
	ix.command.Send("CharDesc")
end)


ix.quickmenu:AddCallback("Fermer le menu", "icon16/cross.png", function()
	ix.infoMenu.Remove()
end)

