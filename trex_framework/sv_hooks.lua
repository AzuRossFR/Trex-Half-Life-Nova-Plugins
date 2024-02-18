local PLUGIN = PLUGIN

util.AddNetworkString("ixStartSound")
util.AddNetworkString("ixIAAOpen")
 hook.Add("OnEntityCreated", "OnEntityCreated", function( ent )
    if IsValid(ent) && ent:GetClass() == "prop_door_rotating" then
        ent:DrawShadow(false)
    end
end)

function PLUGIN:PlayerDeath(client)
    local char = client:GetCharacter()
    local inv = char:GetInventory()
    local slots = char:GetEquipment()
	if slots and char then
    	for i, v in pairs(slots:GetItems()) do
        	v:Call("OnUnequipped", client)
    	end
	end
end

CreateConVar("Handcuffs_StrictWeapons", "0", {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Strict weapons")

function Handcuff(ent, ply)
	if ent:GetActiveWeapon():GetClass() == "trex_menotte" then return end 
	if ent:IsValid() and ent:IsPlayer() then
		ent:Give("trex_menotte")
		ent:SelectWeapon("trex_menotte")
		local WalkSpeed = ent:GetWalkSpeed()/2
		local RunSpeed = ent:GetRunSpeed()/2
		ent:SetWalkSpeed(WalkSpeed)
		ent:SetRunSpeed(RunSpeed)
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(20, 8.8, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(15, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 75))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-15, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, -75))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(-20, 16.6, 0))
		ent:EmitSound("vehicles/atv_ammo_close.wav", 100, 255)	
		if ply then
			ix.util.Notify("Vous avez menotté "..ent:Nick(), ply)
			ent:EmitSound("weapons/357/357_spin1.wav")
		end	
	end
end

function RemoveHandcuff(ent, ply, lockpick)
	local wep = ent:GetActiveWeapon():GetClass()
	if wep == "trex_menotte" then
		ent:StripWeapon("trex_menotte")
		local WalkSpeed = ent:GetWalkSpeed()*2
		local RunSpeed = ent:GetRunSpeed()*2
		ent:SetWalkSpeed(WalkSpeed)
		ent:SetRunSpeed(RunSpeed)
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
		ent:EmitSound("weapons/357/357_reload1.wav",100)
		if ply then
			ix.util.Notify("Vous avez démenotté "..ent:Nick(), ply)
		end
	end
end

hook.Add("PlayerSwitchWeapon", "Handcuffs", function(ply)
	if ply:HasWeapon("trex_menotte") then
		timer.Simple(0, function() ply:SelectWeapon("trex_menotte") end)
	end
end)

hook.Add("PlayerDeath", "Handcuffs_death", function(ply)
	if ply:HasWeapon("trex_menotte") then
		ply:StripWeapon("trex_menotte")
		local WalkSpeed = ply:GetWalkSpeed()/2
		local RunSpeed = ply:GetRunSpeed()/2
		ply:SetWalkSpeed(WalkSpeed)
		ply:SetRunSpeed(RunSpeed)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
	end
end)

function PLUGIN:PostPlayerLoadout(client)
	if (client:Team() == FACTION_IAA) then
		client:SetHealth(999999999)
		client:SetMaxHealth(999999999)
        client:SetColor(Color(2,188,201))
		client:SetMaterial("models/wireframe")
		client:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	else
		client:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	    client:SetColor(color_white)
		client:SetMaterial("")
	end
end
