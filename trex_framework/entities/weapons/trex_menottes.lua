SWEP.PrintName = "Menottes"
SWEP.Category = "TrexSCP | SWEP"
SWEP.Instructions = [[Clique gauche pour menotté
Clique droit pour démenotté]]
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModel = Model( "models/sterling/c_enchanced_handcuffs.mdl" ) -- just change the model 
SWEP.WorldModel = ( "models/sterling/w_enhanced_handcuffs.mdl" )
SWEP.ViewModelFOV = 85
SWEP.UseHands = true
SWEP.AnimPrefix = "rpg"
SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic  = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1 )
    self:SetNextSecondaryFire( CurTime() + 1.1 )
	if SERVER then 
		local ply = self.Owner
		local ent = ply:GetEyeTrace().Entity
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_1 )
		timer.Simple( 1, function() 
			if( IsValid( self ) and IsValid( self.Weapon ) ) then
				self.Weapon:SendWeaponAnim( ACT_VM_RELOAD ) 
			end
		end )
		if ply:GetPos():DistToSqr(ent:GetPos())<2500 then
			local wep = ent:GetActiveWeapon():GetClass()
			if wep == "trex_menotte" and ent:Team() == FACTION_BIAA then return false end
			if guigui_handcuff_wep(wep) then
				ply:Freeze(true)
				timer.Simple(3, function()
					ply:Freeze(false )
				end)
				ply:SetAction("Vous menottez "..ent:Nick(), 3, function() if ply:GetPos():DistToSqr(ent:GetPos())<2500 and ply:GetActiveWeapon():GetClass() == "trex_menottes" then Handcuff(ent, ply) end end)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	self:SetNextPrimaryFire( CurTime() + 1.1 )
    self:SetNextSecondaryFire( CurTime() + 1.1 )
	local ply = self.Owner
	local ent = ply:GetEyeTrace().Entity
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_1 )
	timer.Simple( 1, function() 
        if( IsValid( self ) and IsValid( self.Weapon ) ) then
            self.Weapon:SendWeaponAnim( ACT_VM_RELOAD ) 
        end
    end )
	if ply:GetPos():DistToSqr(ent:GetPos())<2500 then
		if ent:IsValid() and ent:IsPlayer() then
			local wep = ent:GetActiveWeapon():GetClass()
			if wep == "trex_menotte" then
				ply:Freeze(true)
				timer.Simple(3, function()
					ply:Freeze(false)
				end)
				ply:SetAction("Vous démenottez "..ent:Nick(), 3,function() if ply:GetPos():DistToSqr(ent:GetPos())<2500 and ply:GetActiveWeapon():GetClass() == "trex_menottes" then RemoveHandcuff(ent, ply) end end)
			end
		end
	end
end

function SWEP:Reload()
end