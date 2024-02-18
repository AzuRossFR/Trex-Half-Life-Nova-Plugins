
local padding = ScreenScale(32)
-- create character panel
DEFINE_BASECLASS("ixCharMenuPanel")
local PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 100 or 78

	self:ResetPayload(true)

	self.factionButtons = {}
	self.repopulatePanels = {}
	self.scpbuttons = {}

	self.factionPanel = self:AddSubpanel("faction", true)
	self.factionPanel:SetTitle(("parcours de vie"):utf8upper())
	self.factionPanel.OnSetActive = function()
		if (#self.factionButtons == 1) then
			self:SetActiveSubpanel("description", 0)
		end
	end


	local buttonList = self.factionPanel:Add("Panel")
	buttonList:Dock(BOTTOM)
	buttonList:SetSize(1000, 50)


	local factionBack = buttonList:Add("ixButtonTrex")
	factionBack:SetText("RETOUR")
	factionBack:SetFont("CHud2")
	factionBack:Dock(FILL)
	factionBack.DoClick = function()
		self.progress:DecrementProgress()

		self:SetActiveSubpanel("faction", 0)
		self:SlideDown()

		parent.mainPanel:Undim()
	end

	self.scp = self:AddSubpanel("factionscp", true)
	self.scp:SetTitle("CHOISISSEZ VOTRE SCP")

	self.scpPanel = self.scp:Add("ixHorizontalScroll")
	self.scpPanel:SetWide(halfWidth + padding * 2)
	self.scpPanel:Dock(FILL)

	local scrollBar = self.scpPanel:GetHBar()
	scrollBar:SetTall(8)
	scrollBar:SetHideButtons(true)
	scrollBar.Paint = function(scroll, w, h)
		surface.SetDrawColor(255, 255, 255, 10)
		surface.DrawRect(0, 0, w, h)
	end
	scrollBar.btnGrip.Paint = function(grip, w, h)
		local alpha = 50
		if (scrollBar.Dragging) then
			alpha = 150
		elseif (grip:IsHovered()) then
			alpha = 100
		end
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.DrawRect(0, 0, w, h)
	end

	for _, factionscp in SortedPairs(ix.faction.teams) do
		if (ix.faction.HasWhitelist(factionscp.index) and factionscp.isSCP == true) then
			local button = self.scpPanel:Add("ixMenuSelectionButtonTop")
			button:SetText("")
			button:SetFont("CHud4")
			button:SetWide(ScrW() / 6.3)
			button:Dock(LEFT)
			button:DockMargin(0,50,0,50)
			button:SetButtonList(self.scpbuttons)
			button.faction = factionscp.index
			button.DoClick = function ()
				self:SetActiveSubpanel("description")
				self:Populate()
			end
			button.OnSelected = function(panel)
				local faction = ix.faction.indices[panel.faction]
				local models = faction:GetModels(LocalPlayer())
				self.payload:Set("faction", panel.faction)
				self.payload:Set("model", math.random(1, #models))
			end
			button.Paint = function(w, h)

				
				if button.Hovered then
					color_hover = Color(255, 255, 255)
					sizew = button:GetWide() - 5
					sizeh = button:GetTall() - 5
				else
					color_hover = Color(176, 176, 176)
					sizew = button:GetWide() - 15
					sizeh = button:GetTall() - 15
				end

			
				surface.SetDrawColor(color_hover)
				surface.SetMaterial(factionscp.image)
				surface.DrawTexturedRect(0, 0, sizew, sizeh)
			end
		end
	end

	self.scpButtons = self.scp:Add("Panel")
	self.scpButtons:Dock(BOTTOM)
	self.scpButtons:SetTall(50)

	local scpBack = self.scpButtons:Add("ixButtonTrex")
	scpBack:SetText("RETOUR")
	scpBack:SetContentAlignment(5)
	scpBack:SetFont("CHud2")
	scpBack:Dock(FILL)
	scpBack.DoClick = function()
		self.progress:DecrementProgress()

		if (#self.factionButtons == 1) then
			factionBack:DoClick()
		else
			self:SetActiveSubpanel("faction")
		end
	end

	-- character customization subpanel
	self.description = self:AddSubpanel("description")
	self.description:SetTitle(("votre personnage"):utf8upper())

	local descriptionModelList = self.description:Add("Panel")
	descriptionModelList:Dock(RIGHT)
	descriptionModelList:SetWide(ScrW()/3.2)
	

    self.factionModel = descriptionModelList:Add("ixModelPanel")
    self.factionModel:Dock(FILL)
    self.factionModel:SetModel("models/error.mdl")
    self.factionModel:SetFOV(40)
    self.factionModel.PaintModel = self.factionModel.Paint
	self.factionModel.PaintOver = function(s,w,h)
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(Material("trex/ombre.png"))
		surface.DrawTexturedRect(0,0,w,h)
	end

	self.descriptionPanel = self.description:Add("Panel")
	self.descriptionPanel:SetWide(halfWidth + padding * 2)
	self.descriptionPanel:Dock(RIGHT)

	self.buttonList2 = self.descriptionPanel:Add("Panel")
	self.buttonList2:SetTall(60)
	self.buttonList2:Dock(BOTTOM)

	local descriptionBack = self.buttonList2:Add("trexbutton")
	descriptionBack:SetText("RETOUR")
	descriptionBack:SetFont("CHud2")
	descriptionBack:SetContentAlignment(5)
	descriptionBack:SetIcon(5)
	descriptionBack:SetSize(295, 50)
	descriptionBack:SetTextColor(Color(255,0,0))
	descriptionBack:Dock(LEFT)
	descriptionBack.DoClick = function()
		self.progress:DecrementProgress()

		if (#self.factionButtons == 1) then
			factionBack:DoClick()
		else
			self:SetActiveSubpanel("faction")
		end
	end

	self.PanelScroll = self.factionPanel:Add("Panel")
	self.PanelScroll:Dock(FILL)

	self.scroll = self.PanelScroll:Add("ixHorizontalScroll")
	self.scroll:Dock(FILL)
	self.scroll:SetWide(800)

	local scrollBar = self.scroll:GetHBar()
	scrollBar:SetTall(8)
	scrollBar:SetHideButtons(true)
	scrollBar.Paint = function(scroll, w, h)
		surface.SetDrawColor(255, 255, 255, 10)
		surface.DrawRect(0, 0, w, h)
	end
	scrollBar.btnGrip.Paint = function(grip, w, h)
		local alpha = 50
		if (scrollBar.Dragging) then
			alpha = 150
		elseif (grip:IsHovered()) then
			alpha = 100
		end
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.DrawRect(0, 0, w, h)
	end

	local descriptionProceed = self.buttonList2:Add("trexbuttoninverser")
	descriptionProceed:SetText("VALIDER")
	descriptionProceed:SetFont("CHud2")
	descriptionProceed:SetIcon(6)
	descriptionProceed:SetContentAlignment(5)
	descriptionProceed:SizeToContents()
	descriptionProceed:SetSize(295, 50)
	descriptionProceed:Dock(RIGHT)
	descriptionProceed.DoClick = function()
		if (self:VerifyProgression("description")) then
			self:SendPayload()
		end
	end

	-- attributes subpanel
	self.attributes = self:AddSubpanel("attributes")
	self.attributes:SetTitle("chooseSkills")

	local attributesModelList = self.attributes:Add("Panel")
	attributesModelList:Dock(LEFT)
	attributesModelList:SetSize(halfWidth, halfHeight)

	local attributesBack = attributesModelList:Add("ixMenuButton")
	attributesBack:SetText("return")
	attributesBack:SetFont("CHud2")
	attributesBack:SetContentAlignment(4)
	attributesBack:SizeToContents()
	attributesBack:Dock(BOTTOM)
	attributesBack.DoClick = function()
		self.progress:DecrementProgress()
		self:SetActiveSubpanel("description")
	end

	self.attributesPanel = self.attributes:Add("Panel")
	self.attributesPanel:SetWide(halfWidth + padding * 2)
	self.attributesPanel:Dock(RIGHT)

	local create = self.attributesPanel:Add("ixMenuButton")
	create:SetText("finish")
	create:SetFont("CHud2")
	create:SetContentAlignment(6)
	create:SizeToContents()
	create:Dock(BOTTOM)
	create.DoClick = function()
		self:SendPayload()
	end

	-- creation progress panel
	self.progress = self:Add("ixSegmentedProgress")
	self.progress:SetBarColor(ix.config.Get("color"))
	self.progress:SetSize(parent:GetWide(), 0)
	self.progress:SizeToContents()
	self.progress:SetPos(0, parent:GetTall() - self.progress:GetTall())

	-- setup payload hooks
	self:AddPayloadHook("model", function(value)
        local faction = ix.faction.indices[self.payload.faction]

        if (faction) then
            local model = faction:GetModels(LocalPlayer())[value]

            -- assuming bodygroups
            if (istable(model)) then
                self.factionModel:SetModel(model[1], model[2] or 0, model[3])


            else
                self.factionModel:SetModel(model)

            end
        end
    end)

	net.Receive("ixCharacterAuthed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local id = net.ReadUInt(32)
		local indices = net.ReadUInt(6)
		local charList = {}

		for _ = 1, indices do
			charList[#charList + 1] = net.ReadUInt(32)
		end

		ix.characters = charList

		self:SlideDown()

		if (!IsValid(self) or !IsValid(parent)) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			parent.mainPanel:Undim()
			parent:ShowNotice(2, L("charCreated"))
		elseif (id) then
			self.bMenuShouldClose = true

			net.Start("ixCharacterChoose")
				net.WriteUInt(id, 32)
			net.SendToServer()
		else
			self:SlideDown()
		end
	end)

	net.Receive("ixCharacterAuthFailed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local fault = net.ReadString()
		local args = net.ReadTable()

		self:SlideDown()

		parent.mainPanel:Undim()
		parent:ShowNotice(3, L(fault, unpack(args)))
	end)
end

function PANEL:SendPayload()
	if (self.awaitingResponse or !self:VerifyProgression()) then
		return
	end

	self.awaitingResponse = true

	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if (IsValid(self) and self.awaitingResponse) then
			local parent = self:GetParent()

			self.awaitingResponse = false
			self:SlideDown()

			parent.mainPanel:Undim()
			parent:ShowNotice(3, L("unknownError"))
		end
	end)

	self.payload:Prepare()

	net.Start("ixCharacterCreate")
	net.WriteUInt(table.Count(self.payload), 8)

	for k, v in pairs(self.payload) do
		net.WriteString(k)
		net.WriteType(v)
	end

	net.SendToServer()
end

function PANEL:OnSlideUp()
	self:ResetPayload()
	self:Populate()
	self.progress:SetProgress(1)
	self:SetActiveSubpanel("faction", 0)
end

function PANEL:OnSlideDown()
end

function PANEL:ResetPayload(bWithHooks)
	if (bWithHooks) then
		self.hooks = {}
	end

	self.payload = {}

	-- TODO: eh..
	function self.payload.Set(payload, key, value)
		self:SetPayload(key, value)
	end

	function self.payload.AddHook(payload, key, callback)
		self:AddPayloadHook(key, callback)
	end

	function self.payload.Prepare(payload)
		self.payload.Set = nil
		self.payload.AddHook = nil
		self.payload.Prepare = nil
	end
end

function PANEL:SetPayload(key, value)
	self.payload[key] = value
	self:RunPayloadHook(key, value)
end

function PANEL:AddPayloadHook(key, callback)
	if (!self.hooks[key]) then
		self.hooks[key] = {}
	end

	self.hooks[key][#self.hooks[key] + 1] = callback
end

function PANEL:RunPayloadHook(key, value)
	local hooks = self.hooks[key] or {}

	for _, v in ipairs(hooks) do
		v(value)
	end
end



function PANEL:GetContainerPanel(name)
	if (name == "description") then
		return self.descriptionPanel
	elseif (name == "attributes") then
		return self.attributesPanel
	elseif (name == "classes") then
		return self.classesPanel
	end

	return self.descriptionPanel
end

function PANEL:AttachCleanup(panel)
	self.repopulatePanels[#self.repopulatePanels + 1] = panel
end

function PANEL:Populate()
	local color_select = Color(0,0,0,0)

	if (!self.bInitialPopulate) then

		local lastSelected

		for _, v in pairs(self.factionButtons) do
			if (v:GetSelected()) then
				lastSelected = v.faction
			end

			if (IsValid(v)) then
				v:Remove()
			end
		end

		self.factionButtons = {}

		for _, v in SortedPairs(ix.faction.teams) do
			if (ix.faction.HasWhitelist(v.index) and v.isSCP != true) then
				local button = self.scroll:Add("ixMenuSelectionButtonTop")
				button:SetText("")
				button:SetFont("CHud4")
				button:SetWide(ScrW() / 6.3)
				button:Dock(LEFT)
				button:DockMargin(20,5,0,50)
				button:SetButtonList(self.factionButtons)
				button.faction = v.index
				button.Paint = function(w, h)
				
				
					if button.Hovered then
						color_hover = Color(255, 255, 255)
						sizew = button:GetWide() - 0.25
						sizeh = button:GetTall() - 1
					else
						color_hover = Color(255, 255, 255, 100)
						sizew = button:GetWide() - 0.25
						sizeh = button:GetTall() - 1
					end

				
					surface.SetDrawColor(color_hover)
					surface.SetMaterial(v.image)
					surface.DrawTexturedRect(0, 0, sizew, sizeh)
				end
				button.DoClick = function ()
					self.progress:IncrementProgress()

					if button.faction == FACTION_SCP then
						self:SetActiveSubpanel("factionscp")
					else
						self.progress:IncrementProgress()
						self:SetActiveSubpanel("description")
					end
					self:Populate()
				end
				button.DoRightClick = function ()
					button:DoClick()
				end
				button.OnSelected = function(panel)

					local faction = ix.faction.indices[panel.faction]
					local models = faction:GetModels(LocalPlayer())
					LocalPlayer():EmitSound("ABYSS/button3.wav", 30)
					self.payload:Set("faction", panel.faction)
					self.payload:Set("model", math.random(1, #models))


				end
				if ((lastSelected and lastSelected == v.index) or (!lastSelected and v.isDefault)) then
					button:SetSelected(true)
					lastSelected = v.index
				end
			end
		end
	end

	-- remove panels created for character vars
	for i = 1, #self.repopulatePanels do
		self.repopulatePanels[i]:Remove()
	end

	self.repopulatePanels = {}

	-- payload is empty because we attempted to send it - for whatever reason we're back here again so we need to repopulate
	if (!self.payload.faction) then
		for _, v in pairs(self.factionButtons) do
			if (v:GetSelected()) then
				v:SetSelected(true)
				break
			end
		end
	end

	self.factionPanel:SizeToContents()

	local zPos = 1

	-- set up character vars
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (!v.bNoDisplay and k != "__SortedIndex") then
			local container = self:GetContainerPanel(v.category or "description")

			if (v.ShouldDisplay and v:ShouldDisplay(container, self.payload) == false) then
				continue
			end

			local panel
			if (v.OnDisplay) then
				panel = v:OnDisplay(container, self.payload)
			elseif (isstring(v.default)) then
				panel = container:Add("ixTextEntry")
				panel:Dock(TOP)
				panel:SetFont("CHud2")
				panel:SetTextColor(color_white)
				panel:SetUpdateOnType(true)
				panel.OnValueChange = function(this, text)
					self.payload:Set(k, text)
				end
			end

			if (IsValid(panel)) then
				-- add label for entry

				local label = container:Add("DLabel")
				label:SetFont("CHud2")
				label:SetText(L(k):utf8upper())
				label:SizeToContents()
				label:DockMargin(0, 16, 0, 2)
				label:Dock(TOP)

				-- we need to set the docking order so the label is above the panel
				label:SetZPos(zPos - 1)
				panel:SetZPos(zPos)

				self:AttachCleanup(label)
				self:AttachCleanup(panel)

				if (v.OnPostSetup) then
					v:OnPostSetup(panel, self.payload)
				end

				zPos = zPos + 2
			end
		end
	end

	if (!self.bInitialPopulate) then
		-- setup progress bar segments
		if (#self.factionButtons > 1) then
			self.progress:AddSegment("@faction")
		end

		self.progress:AddSegment("@description")

		if (#self.attributesPanel:GetChildren() > 1) then
			self.progress:AddSegment("@skills")
		end

		-- we don't need to show the progress bar if there's only one segment
		if (#self.progress:GetSegments() == 1) then
			self.progress:SetVisible(false)
		end
	end

	self.bInitialPopulate = true
end

function PANEL:VerifyProgression(name)
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (name ~= nil and (v.category or "description") != name) then
			continue
		end

		local value = self.payload[k]

		if (!v.bNoDisplay or v.OnValidate) then
			if (v.OnValidate) then
				local result = {v:OnValidate(value, self.payload, LocalPlayer())}

				if (result[1] == false) then
					self:GetParent():ShowNotice(3, L(unpack(result, 2)))
					return false
				end
			end

			self.payload[k] = value
		end
	end

	return true
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(0,0,0)
	surface.DrawRect(0, 0, width, height)
end

vgui.Register("ixCharMenuNew", PANEL, "ixCharMenuPanel")
