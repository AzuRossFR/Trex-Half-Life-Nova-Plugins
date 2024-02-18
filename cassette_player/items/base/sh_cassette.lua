ITEM.name = "Cassette"
ITEM.description = "A basic playable Cassette."
ITEM.category = "Cassette"
ITEM.model = "models/kek1ch/cassette_backkek.mdl"
ITEM.busflag = "dev"
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0.40000000596046, 0, 200),
	ang = Angle(90, 0, -174.26751708984),
	fov = 2.3
}
ITEM.weight = 0.14
ITEM.isCassette = true

ITEM.functions.insert = {
	name = "Insérer dans l'écouteur",
	icon = "willardnetworks/chat/radio_icon.png",
	OnRun = function(item)
		local client = item.player
		local Hit = client:GetEyeTraceNoCursor()
		local entity = Hit.Entity
		local dist = client:GetPos():Distance(entity:GetPos())

		item.options = {}
		for k, v in pairs(item.cassette_options) do
			item.options[#item.options + 1] = k
		end

		if (entity:GetClass() == "ix_cassette_player") and (dist < 200) then
			item:remove()
			if not (entity.PutCassette) then
				entity.sound = CreateSound( entity, table.Random(item.options))
				entity.sound:Play()
				entity.sound:SetSoundLevel(0)
				entity.PutCassette = item.uniqueID
				entity:EmitSound("stalkersound/inv_slot.mp3", 40)

				entity:Repeat(item.cassette_options)
			else
				return false
			end
		else
			return false
		end
	end,
	OnCanRun = function(item)
		return (!IsValid(item.entity))
	end
}

