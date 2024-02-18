
local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()

	local pWidth, pHeight = ScrW() * 0.75, ScrH() * 0.75
	self:SetSize(pWidth, pHeight)
	self:Center()
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(true)

	self:MakePopup()
	self:SetTitle("")

	self.bodygroups = self:Add("DScrollPanel")
	self.bodygroups:Dock(RIGHT)

end

function PANEL:Display(target)

	local pWidth, pHeight = ScrW() * 0.75, ScrH() * 0.75

	self.saveButton = self:Add("ixMenuButton")
	self.saveButton:Dock(BOTTOM)
	self.saveButton:SetTall(55)
	self.saveButton:DockMargin(0, 4, 0, 0)
	self.saveButton:SetText("Valider")
	self.saveButton:SetContentAlignment(5)
	self.saveButton:SetFont("CHud2")
	self.saveButton.DoClick = function()
		local bodygroups = {}
		for _, v in pairs(self.bodygroupIndex) do
			table.insert(bodygroups, v.index, v.value)
		end

		net.Start("ixBodygroupTableSet")
			net.WriteEntity(self.target)
			net.WriteTable(bodygroups)
		net.SendToServer()

		LocalPlayer():Notify("Bodygroup changé avec succès !")
		self:Remove()
	end

	self.model = self:Add("DAdjustableModelPanel")
	self.model:SetSize(pWidth * 1/2, pHeight)
	self.model:Dock(LEFT)
	self.model:SetModel(target:GetModel())
	self.model:SetLookAng(Angle(10, 225, 0))
	self.model:SetCamPos(Vector(40, 40, 50))

	function self.model:FirstPersonControls()
		local x, y = self:CaptureMouse()

		local scale = self:GetFOV() / 180
		x = x * -0.5 * scale
		y = y * 0.5 * scale

		-- Look around
		self.aLookAngle = self.aLookAngle + Angle( y, x, 0 )

		local Movement = Vector( 0, 0, 0 )

		-- TODO: Use actual key bindings, not hardcoded keys.
		if ( input.IsKeyDown( KEY_Z ) || input.IsKeyDown( KEY_UP ) ) then Movement = Movement + self.aLookAngle:Forward() end
		if ( input.IsKeyDown( KEY_S ) || input.IsKeyDown( KEY_DOWN ) ) then Movement = Movement - self.aLookAngle:Forward() end
		if ( input.IsKeyDown( KEY_Q ) || input.IsKeyDown( KEY_LEFT ) ) then Movement = Movement - self.aLookAngle:Right() end
		if ( input.IsKeyDown( KEY_D ) || input.IsKeyDown( KEY_RIGHT ) ) then Movement = Movement + self.aLookAngle:Right() end
		if ( input.IsKeyDown( KEY_SPACE ) || input.IsKeyDown( KEY_SPACE ) ) then Movement = Movement + self.aLookAngle:Up() end
		if ( input.IsKeyDown( KEY_LCONTROL ) || input.IsKeyDown( KEY_LCONTROL ) ) then Movement = Movement - self.aLookAngle:Up() end

		local speed = 0.5
		if ( input.IsShiftDown() ) then speed = 4.0 end

		self.vCamPos = self.vCamPos + Movement * speed
	end

	self.target = target
	self:PopulateBodygroupOptions()
	self:SetTitle("")

	function self.model:LayoutEntity(Entity)
		Entity:SetAngles(Angle(0,45,0))
		local sequence = Entity:SelectWeightedSequence(ACT_IDLE)

		if (sequence <= 0) then
			sequence = Entity:LookupSequence("idle_unarmed")
		end

		if (sequence > 0) then
			Entity:ResetSequence(sequence)
		else
			local found = false

			for _, v in ipairs(Entity:GetSequenceList()) do
				if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
					Entity:ResetSequence(v)
					found = true

					break
				end
			end

			if (!found) then
				Entity:ResetSequence(4)
			end
		end

	end
end

function PANEL:Paint(width,height)
	draw.RoundedBoxEx(8,0, 0, width, height, Color(14,14,14), true,false,false ,true )
end

function PANEL:PopulateBodygroupOptions()
	self.bodygroupBox = {}
	self.bodygroupName = {}
	self.bodygroupPrevious = {}
	self.bodygroupNext = {}
	self.bodygroupIndex = {}
	self.bodygroups:Dock(FILL)

	for k, v in pairs(self.target:GetBodyGroups()) do
		-- Disregard the model bodygroup.
		if !(v.id == 0) then
			local index = v.id

			self.bodygroupBox[v.id] = self.bodygroups:Add("Panel")
			self.bodygroupBox[v.id]:Dock(TOP)
			self.bodygroupBox[v.id]:DockMargin(20, 20, 20, 0)
			self.bodygroupBox[v.id]:SetHeight(50)
			self.bodygroupBox[v.id].Paint = function (s,w,h)
				draw.RoundedBoxEx(8,0, 0, w, h, Color(136,136,136), true,false,false ,true )
			end

			self.bodygroupName[v.id] = self.bodygroupBox[v.id]:Add("DLabel")
			self.bodygroupName[v.id].index = v.id
			self.bodygroupName[v.id]:SetText(v.name:gsub("^%l", string.upper))
			self.bodygroupName[v.id]:SetFont("CHud1")
			self.bodygroupName[v.id]:Dock(LEFT)
			self.bodygroupName[v.id]:DockMargin(30, 0, 0, 0)
			self.bodygroupName[v.id]:SetWidth(200)
			self.bodygroupName[v.id].Paint = function()
			end

			self.bodygroupNext[v.id] = self.bodygroupBox[v.id]:Add("ixMenuButton")
			self.bodygroupNext[v.id].index = v.id
			self.bodygroupNext[v.id]:Dock(RIGHT)
			self.bodygroupNext[v.id]:SetText(">")
			self.bodygroupNext[v.id]:SetContentAlignment(5)
			self.bodygroupNext[v.id]:SetFont("CHud2")
			self.bodygroupNext[v.id].DoClick = function()
				local index = v.id
				if (self.model.Entity:GetBodygroupCount(index) - 1) <= self.bodygroupIndex[index].value then
					return
				end

				self.bodygroupIndex[index].value = self.bodygroupIndex[index].value + 1
				self.bodygroupIndex[index]:SetText(self.bodygroupIndex[index].value)
				self.model.Entity:SetBodygroup(index, self.bodygroupIndex[index].value)
			end

			self.bodygroupIndex[v.id] = self.bodygroupBox[v.id]:Add("DLabel")
			self.bodygroupIndex[v.id].index = v.id
			self.bodygroupIndex[v.id].value = self.target:GetBodygroup(index)
			self.bodygroupIndex[v.id]:SetText(self.bodygroupIndex[v.id].value)
			self.bodygroupIndex[v.id]:SetFont("CHud5")
			self.bodygroupIndex[v.id]:Dock(RIGHT)
			self.bodygroupIndex[v.id]:SetContentAlignment(5)

			self.bodygroupPrevious[v.id] = self.bodygroupBox[v.id]:Add("ixMenuButton")
			self.bodygroupPrevious[v.id].index = v.id
			self.bodygroupPrevious[v.id]:Dock(RIGHT)
			self.bodygroupPrevious[v.id]:SetText("<")
			self.bodygroupPrevious[v.id]:SetContentAlignment(5)
			self.bodygroupPrevious[v.id]:SetFont("CHud2")
			self.bodygroupPrevious[v.id].DoClick = function()
				local index = v.id
				if 0 == self.bodygroupIndex[index].value then
					return
				end
				self.bodygroupIndex[index].value = self.bodygroupIndex[index].value - 1
				self.bodygroupIndex[index]:SetText(self.bodygroupIndex[index].value)
				self.model.Entity:SetBodygroup(index, self.bodygroupIndex[index].value)

			end

			self.model.Entity:SetBodygroup(index, self.target:GetBodygroup(index))
		end
	end
end

vgui.Register("ixBodygroupView", PANEL, "DFrame")
