local meta = FindMetaTable("Entity")

function meta:IsAlerting()
	local class = self:GetClass()
	
	if class == "ix_civil_station" then
		return self:GetNetVar("isAlerting", true  )
	end
end