
local backgroundColor = Color(0, 0, 0, 66)

local PANEL = {}

AccessorFunc(PANEL, "maxWidth", "MaxWidth", FORCE_NUMBER)

function PANEL:Init()
	self:SetWide(180)
	self:Dock(RIGHT)
	local client = self.player

	self.maxWidth = ScrW() * 0.2
end

function PANEL:Paint(width, height)
end

function PANEL:SizeToContents()
	local width = 0

	for _, v in ipairs(self:GetChildren()) do
		width = math.max(width, v:GetWide())
	end

	self:SetSize(math.max(32, math.min(width, self.maxWidth)), self:GetParent():GetTall())
end

vgui.Register("ixHelpMenuCategories", PANEL, "EditablePanel")

-- help menu
PANEL = {}

function PANEL:Init()
	self:Dock(FILL)

	self.categories = {}
	self.categorySubpanels = {}
	self.categoryPanel = self:Add("ixHelpMenuCategories")

	self.canvasPanel = self:Add("EditablePanel")
	self.canvasPanel:Dock(FILL)

	local categories = {}
	hook.Run("PopulateHelpMenu", categories)

	for k, v in SortedPairs(categories) do
		if (!isstring(k)) then
			ErrorNoHalt("expected string for help menu key\n")
			continue
		elseif (!isfunction(v)) then
			ErrorNoHalt(string.format("expected function for help menu entry '%s'\n", k))
			continue
		end

		self:AddCategory(k)
		self.categories[k] = v
	end

	self.categoryPanel:SizeToContents()

	if (ix.gui.lastHelpMenuTab) then
		self:OnCategorySelected(ix.gui.lastHelpMenuTab)
	end
end


function PANEL:AddCategory(name)
	local button = self.categoryPanel:Add("ixButtonTrex")
	button:SetText(L(name))
	button:SetTextColor(Color(158,157,157))
	button:SetFont("CHud2")
	button:SetWide(350)
	button:SetTall(65)
	button:SetTextInset(150,0)
	button:SetContentAlignment(5)
	--button:SizeToContents()
	button:Dock(TOP)
	button:DockMargin(50,30,0,0)
	button.DoClick = function()
		self:OnCategorySelected(name)
	end

	local panel = self.canvasPanel:Add("DScrollPanel")
	panel:SetVisible(false)
	panel:Dock(FILL)
	panel:DockMargin(0, 0, 0, 0)
	panel:GetCanvas():DockPadding(8, 18, 8, 8)
	panel.DisableScrolling = function()
		panel:GetCanvas():SetVisible(false)
		panel:GetVBar():SetVisible(false)
		panel.OnChildAdded = function() end
	end
	local scrollBar = panel:GetVBar()
	scrollBar:SetTall(8)
	scrollBar:SetHideButtons(true)
	scrollBar.Paint = function(scroll, w, h)
		surface.SetDrawColor(255, 255, 255, 10)
	end
	scrollBar.btnGrip.Paint = function(grip, w, h)
		local alpha = 50
		if (scrollBar.Dragging) then
			alpha = 150
		elseif (grip:IsHovered()) then
			alpha = 100
		end
	end

	self.categorySubpanels[name] = panel
end


function PANEL:OnCategorySelected(name)
	local panel = self.categorySubpanels[name]

	if (!IsValid(panel)) then
		return
	end

	if (!panel.bPopulated) then
		self.categories[name](panel)
		panel.bPopulated = true
	end

	if (IsValid(self.activeCategory)) then
		self.activeCategory:SetVisible(false)
	end

	panel:SetVisible(true)

	self.activeCategory = panel
	ix.gui.lastHelpMenuTab = name
end

vgui.Register("ixHelpMenu", PANEL, "EditablePanel")


hook.Add("CreateMenuButtons", "ixHelpMenu", function(tabs)
	tabs["help"] = {
		Create = function(info,container)
		local panel = container:Add("ixHelpMenu")
	end
}
end)

hook.Add("PopulateHelpMenu", "ixHelpMenu", function(tabs)

	tabs["JOUEURS"] = function(container)

		for k, v in ipairs(player.GetAll()) do
			local panel = container:Add("DPanel")
			panel:Dock(TOP)
			panel:SetTall(60)
			panel:DockMargin(0, 0, 0, 8)
			panel:DockPadding(4, 4, 4, 4)
			panel.Paint = function(_, width, height)
				draw.RoundedBoxEx(8,0, 0, width, height, Color(50,50,50,220), true,false,false ,true )
			end

			local utilPly = panel:Add("DLabel")
			utilPly:SetFont("CHud2")
			utilPly:SetText(v:Nick())
			utilPly:Dock(FILL)
			utilPly:SetTextColor(color_white)
			utilPly:SetExpensiveShadow(1, color_black)
			utilPly:SetTextInset(4, 0)
			utilPly:SizeToContents()
			utilPly:SetTall(utilPly:GetTall() + 8)
			utilPly.Paint = function()
			end
			utilPly.Think = function()
				if (utilPly:GetText() != v:Nick()) then
					utilPly:SetText(v:Nick())
				end
			end

			local bdy = panel:Add("ixMenuButton")
			bdy:Dock(RIGHT)
			bdy:SetText("BODYGROUPS")
			bdy:SetFont("CHud1")
			bdy:SizeToContents()
			bdy:SetContentAlignment(5)
			bdy.DoClick = function(s,w,h)
				local panel = vgui.Create("ixBodygroupView")
				panel:Display(v)
			end

			local name = panel:Add("ixMenuButton")
			name:Dock(RIGHT)
			name:SetText("RENOMMER")
			name:SetFont("CHud1")
			name:SizeToContents()
			name:SetContentAlignment(5)
			name.DoClick = function (s,w,h)
				if (IsValid(v)) then
					Derma_StringRequest("", "En quoi voulez-vous changer le nom de ce personnage ?", v:Name(), function(text)
						ix.command.Send("CharSetName", v:Name(), text)
					end, nil, "Changer", "Annuler")
				end
			end

			local mdl = panel:Add("ixMenuButton")
			mdl:Dock(RIGHT)
			mdl:SetText("MODEL")
			mdl:SetFont("CHud1")
			mdl:SizeToContents()
			mdl:SetContentAlignment(5)
			mdl.DoClick = function (s,w,h)
				Derma_StringRequest("", "En quoi voulez-vous changer le modèle de ce personnage ?", v:GetModel(), function(text)
					ix.command.Send("CharSetModel", v:Nick(), text)
				end, nil, "Changer", "Annuler")
			end

			local flag = panel:Add("ixMenuButton")
			flag:Dock(RIGHT)
			flag:SetText("FLAGS")
			flag:SetFont("CHud1")
			flag:SizeToContents()
			flag:SetContentAlignment(5)
			flag.DoClick = function(s,w,h)
				local menu = vgui.Create("DFrame")
				menu:SetSize(ScrW() / 5, ScrH() / 2)
				menu:MakePopup()
				menu:Center()
				menu:SetTitle("")
				menu.Paint = function (s,w,h)
					draw.RoundedBoxEx(8,0,0,w,h,Color(32,32,32,220),false,true,true,false)
				end

				local panel = menu:Add("DScrollPanel")
				panel:Dock(FILL)

				for i, flags in SortedPairs(ix.flag.list) do
					local button = panel:Add("ixMenuButton")
					button:Dock(TOP)
					button:SetSize(20,50)
					button:SetText(L(i) .. " - " .. flags.description)
					button:SetFont("ixSmallFont")
					button:DockMargin(4,4,4,4)

					function button:DoClick()
						ix.command.Send("CharGiveFlag", v:Name(),i)
						button:Remove()
					end

					if(v:GetCharacter():HasFlags(i)) then
						button:Remove()
					end
				end
			end
		end
	end

	tabs["SONS"] = function(container)
		-- info text
		local info = container:Add("DPanel")
		info:Dock(TOP)
		info:DockMargin(0, 0, 0, 8)
		info:SizeToContents()
		info:SetTall(info:GetTall() + 16)
		info.Paint = function(_, width, height)
		end

		local stopson = info:Add("DButton")
		stopson:Dock(LEFT)
		stopson:DockMargin(0,0,0,0)
		stopson:SetFont("CHud2")
		stopson:SetText("STOPSOUND")
		stopson:SetContentAlignment(5)
		stopson:SetWide(ScrW()/2.85)
		stopson:SetTextColor(Color(0,0,0))
		stopson:SetExpensiveShadow(1, color_black)
		stopson.DoClick = function(s,w,h)
			RunConsoleCommand("sam", "stopsound")
			LocalPlayer():Notify("Vous avez stoppez tout les sons !")
		end
		stopson.Paint = function(s,w,h)
			draw.RoundedBoxEx(8,0, 0, w,h, ix.config.Get("color"), true,false,false ,true )
		end

		local playurl = info:Add("DButton")
		playurl:Dock(FILL)
		playurl:SetFont("CHud2")
		playurl:DockMargin(10,0,0,0)
		playurl:SetText("PLAY - URL")
		playurl:SetContentAlignment(5)
		playurl:SetWide(ScrW()/2)
		playurl:SetTextColor(Color(0,0,0))
		playurl:SetExpensiveShadow(1, color_black)
		playurl.DoClick = function(s,w,h)
			RunConsoleCommand("playurl_menu")
		end
		playurl.Paint = function(s,w,h)
			draw.RoundedBoxEx(8,0, 0, w,h, ix.config.Get("color"), true,false,false ,true )
		end

		local boutons = {
			{text = "Niveau 1", son = "alarmlevel1.ogg"},
			{text = "Niveau 2", son = "alarmlevel2.ogg"},
			{text = "Niveau 3", son = "alarmlevel3.mp3"},
			{text = "Niveau 4 (EN)", son = "alarmlevel4.ogg"},
			{text = "Destruction du Site (EN)", son = "destruct_sequence.mp3"},
			{text = "Intrus par Gate (FR)", son = "giattaque.mp3"},
			{text = "Nuclear Alarm", son = "nuclearalarm.mp3"},
			{text = "Warhead (FR)", son = "warheadfr.mp3"},
			{text = "Alpha Warhead (FR)", son = "alphawarheadvf.mp3"},
			{text = "Breach Générale (FR)", son = "breche.mp3"},
			{text = "Evacuate (EN)", son = "evacuate.mp3"},
			{text = "Quarantaine Initier (FR)", son = "qivf.mp3"},
			{text = "Quarantaine Levé (FR)", son = "qlvf.mp3"},
			{text = "Alarme de la Purge (FR)", son = "purge.mp3"},
			{text = "FIM Alpha-1 - ENTREE (FR)", son = "fim_alphavf.mp3"},
			{text = "FIM Omega-7 - ENTREE (FR)", son = "fim_omegavf.mp3"},
			{text = "FIM Inconnue - ENTREE (FR)", son = "fim_inconnue.mp3"},
			{text = "FIM Alpha-1 - SORTIE (FR)", son = "fim_sortie_e11.mp3"},
			{text = "FIM Epsilon11 - SORTIE (FR)", son = "fim_sortie_alpha1.mp3"},
			{text = "DECONFINEMENTS SCP SCP-049 (FR)", son = "deconf049.mp3"},
			{text = "DECONFINEMENTS SCP SCP-079 (FR)", son = "deconf079.mp3"},
			{text = "DECONFINEMENTS SCP SCP-079 (EN)", son = "deconf079en.mp3"},
			{text = "DECONFINEMENTS SCP SCP-096 (FR)", son = "deconf096.mp3"},
			{text = "DECONFINEMENTS SCP SCP-106 (FR)", son = "deconf106.mp3"},
			{text = "DECONFINEMENTS SCP SCP-682 (FR)", son = "deconf682.mp3"},
			{text = "DECONFINEMENTS SCP SCP-939 (FR)", son = "deconf939.mp3"},
			{text = "DECONFINEMENTS SCP SCP-173 (FR)", son = "deconf173.mp3"},
			{text = "DECONFINEMENTS SCP SCP-457 (FR)", son = "deconf457.mp3"},
			{text = "RECONFINEMENTS SCP SCP-049 (FR)", son = "reconf049.mp3"},
			{text = "RECONFINEMENTS SCP SCP-096 (FR)", son = "reconf096.mp3"},
			{text = "RECONFINEMENTS SCP SCP-939 (FR)", son = "reconf939.mp3"},
			{text = "RECONFINEMENTS SCP SCP-939 MUSIQUE", son = "reconf939_musique.mp3"},
			{text = "RECONFINEMENTS SCP SCP-173 (FR)", son = "reconf173.mp3"},
			{text = "RECONFINEMENTS SCP SCP-106 (FR)", son = "reconf106.mp3"},
			{text = "ZONE CARCERALES Classe-D Fuite (FR)", son = "classedfuite.mp3"},
			{text = "ZONE CARCERALES Classe-D Maitriser (FR)", son = "classedmaitrise.mp3"},
			{text = "ZONE CARCERALES Prise Autage Zone Classe-D (FR)", son = "poclassed.mp3"},
			{text = "AMBIANCES Ambiance Pesante", son = "ambiance_1.mp3"},
			{text = "AMBIANCES Ambiance SCP", son = "ambiance_2.mp3"},
			{text = "Mise A Jour I.A.", son = "maj_scan_ia.mp3"},
			{text = "Allumage des Intercom", son = "intercomstart.mp3"},
			{text = "Fin de transmition intercoms", son = "intercomend.mp3"},
			{text = "Allumage des Générateurs", son = "powerup.mp3"},
			{text = "Fin de fonction des générateur", son = "powerdown.mp3"},
			{text = "SCP-049 Paroles", son = "scp049theme.mp3"},
			{text = "Groupe D'interet", son = "themegi.mp3"},
			{text = "MUSIQUES Carol Of The Bell [Lindsey Stirling]", son = "carol_of_the_bell.mp3"},
			{text = "MUSIQUES Aggressive War Epic Music [CEPHEI]", son = "epicmusic_1.mp3"},
			{text = "MUSIQUES OFFENSIVE AGGRESSIVE WAR [CEPHEI]", son = "epicmusic_2.mp3"},
			{text = "MUSIQUES Katyusha HARD BASS [COSMOWAVE]", son = "katyusha.mp3"},
			{text = "MUSIQUES Intro SCP Contain Breach", son = "introscpcb.mp3"},
			{text = "MUSIQUES Menu SCP Containement Breach", son = "menu.mp3"},
			{text = "MUSIQUES This Is Your Last Warning [Õige Eesti Mees]", son = "lastwarning.mp3"},
			{text = "MUSIQUES Nine Tailed Fox [Glenn Leroi]", son = "ntfsong.mp3"},
			{text = "MUSIQUES SCP-006 Song [Glenn Leroi]", son = "006song.mp3"},
			{text = "MUSIQUES 28 Day Later [wallonthefloor]", son = "28dl.mp3"},
			{text = "MUSIQUES NightCore - Here Come the Wolves [Lola Blanc]", son = "nightcore.mp3"},
			{text = "MUSIQUES SCP-420 Song [Mandeville SCP]", son = "420song.mp3"},
			{text = "MUSIQUES Fondation Musique [Ajoura]", son = "scpfsong.mp3"},
			{text = "MUSIQUES Astronomia Remix", son = "astrosong.mp3"},
			{text = "EVENTS SCP-173 Deconf + Mise en Situation", son = "deconf173_event.mp3"},
			{text = "EVENTS Fin d'event (alarme + Nuke...)", son = "finevent.mp3"}
		}


		for _, bouton in pairs(boutons) do
			local panel = container:Add("DPanel")
			panel:Dock(TOP)
			panel:DockMargin(0, 0, 0, 8)
			panel:DockPadding(4, 4, 4, 4)
			panel.Paint = function(_, width, height)
				draw.RoundedBoxEx(8,0, 0, width, height, Color(50,50,50,220), true,false,false ,true )
			end
	
			local text = bouton.text
			local son = bouton.son
	
			local flag = panel:Add("DButton")
			flag:SetFont("CHud1")
			flag:SetText(text)
			flag:Dock(FILL)
			flag:SetTextColor(color_white)
			flag:SetExpensiveShadow(1, color_black)
			flag:SetTextInset(4, 0)
			flag:SizeToContents()
			flag:SetTall(flag:GetTall() + 8)
			flag.Paint = function()
			end
			flag.DoClick = function(s,w,h)
				Derma_Query(
    				"Est-tu sur du son à jouer ?",
    				"Confirmer:",
    				"Oui",
    				function() 	ix.command.Send("playsoundglobal", son) end,
					"Non",
					function() end
				)
			end
	
			local description = panel:Add("DLabel")
			description:SetFont("ixMediumLightFont")
			description:SetText("")
			description:Dock(FILL)
			description:SetTextColor(color_white)
			description:SetExpensiveShadow(1, color_black)
			description:SetTextInset(8, 0)
			description:SizeToContents()
			description:SetTall(description:GetTall() + 8)

			panel:SizeToChildren(false, true)
		end
	end
end)
