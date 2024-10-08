PLUGIN.name = "Holstered Weapons"
PLUGIN.author = "Trex"
PLUGIN.description = ""

ix.config.Add("showHolsteredWeps", true,"Est-ce que les armes s'affichent sur le joueurs ?.", nil, {
	category = "ARMES"
})

if (SERVER) then return end

-- To add your own holstered weapon model, add a new entry to HOLSTER_DRAWINFO
-- in *your* code (not here) where the key is the weapon class and the value
-- is a table that contains:
--   1. pos: a vector offset
--   2. ang: the angle of the model
--   3. bone: the bone to attach the model to
--   4. model: the model to show
HOLSTER_DRAWINFO = HOLSTER_DRAWINFO or {}

-- HELIX DEFINED WEAPONS
HOLSTER_DRAWINFO["ix_stunstick"] = {
	pos = Vector(2, 9, 0),
	ang = Angle(0, 100, 0),
	bone = "ValveBiped.Bip01_Pelvis",
	model = "models/weapons/w_stunbaton.mdl"
}
HOLSTER_DRAWINFO["tfa_ins2_416c"] = {
	pos = Vector(5, 12, 5),
	ang = Angle(-160, 8, 0),
	bone = "ValveBiped.Bip01_Spine",
	model = "models/weapons/w_nb_ins_416c.mdl"
}
HOLSTER_DRAWINFO["tfa_ins2_fiveseven_eft"] = {
	pos = Vector(-1, 6, -6),
	ang = Angle(3, 0, 95),
	bone = "ValveBiped.Bip01_R_Thigh",
	model = "models/weapons/w_fiveseven_eft.mdl"
}
HOLSTER_DRAWINFO["tfa_ins2_cz805"] = {
	pos = Vector(-12, 3, -2),
	ang = Angle(35, 180, 0),
	bone = "ValveBiped.Bip01_Spine1",
	model = "models/weapons/tfa_ins2/w_cz805.mdl"
}
HOLSTER_DRAWINFO["tfa_ins2_nova"] = {
	pos = Vector(4, 18, 5),
	ang = Angle(-160, 10, 0),
	bone = "ValveBiped.Bip01_Spine1",
	model = "models/weapons/tfa_ins2/w_nova.mdl"
}



function PLUGIN:PostPlayerDraw(client)
	if (not ix.config.Get("showHolsteredWeps")) then return end
	if (not client:GetCharacter()) then return end
	if (client == LocalPlayer() and not client:ShouldDrawLocalPlayer()) then
		return
	end

	local wep = client:GetActiveWeapon()
	local curClass = ((wep and wep:IsValid()) and wep:GetClass():lower() or "")

	client.holsteredWeapons = client.holsteredWeapons or {}

	for k, v in pairs(client.holsteredWeapons) do
		local weapon = client:GetWeapon(k)
		if (not IsValid(weapon)) then
			v:Remove()
		end
	end

	-- Create holstered models for each weapon.
	for k, v in ipairs(client:GetWeapons()) do
		local class = v:GetClass():lower()
		local drawInfo = HOLSTER_DRAWINFO[class]
		if (not drawInfo or not drawInfo.model) then continue end

		if (not IsValid(client.holsteredWeapons[class])) then
			local model =
				ClientsideModel(drawInfo.model, RENDERGROUP_TRANSLUCENT)
			model:SetNoDraw(true)
			client.holsteredWeapons[class] = model
		end

		local drawModel = client.holsteredWeapons[class]
		local boneIndex = client:LookupBone(drawInfo.bone)

		if (not boneIndex or boneIndex < 0) then continue end
		local bonePos, boneAng = client:GetBonePosition(boneIndex)

		if (curClass ~= class and IsValid(drawModel)) then
			local right = boneAng:Right()
			local up = boneAng:Up()
			local forward = boneAng:Forward()	

			boneAng:RotateAroundAxis(right, drawInfo.ang[1])
			boneAng:RotateAroundAxis(up, drawInfo.ang[2])
			boneAng:RotateAroundAxis(forward, drawInfo.ang[3])

			bonePos = bonePos
				+ drawInfo.pos[1] * right
				+ drawInfo.pos[2] * forward
				+ drawInfo.pos[3] * up

			drawModel:SetRenderOrigin(bonePos)
			drawModel:SetRenderAngles(boneAng)
			drawModel:DrawModel()
		end
	end
end

function PLUGIN:EntityRemoved(entity)
	if (entity.holsteredWeapons) then
		for k, v in pairs(entity.holsteredWeapons) do
			v:Remove()
		end
	end
end

for k, v in ipairs(player.GetAll()) do
	for k2, v2 in ipairs(v.holsteredWeapons or {}) do
		v2:Remove()
	end
	v.holsteredWeapons = nil

end