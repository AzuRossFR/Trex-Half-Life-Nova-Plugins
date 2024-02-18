PLUGIN.name = "HUD"
PLUGIN.author = "Khall & AzuRoss"
PLUGIN.description = "HUD Retravaillé par l'équipe de Trex"


if not ( CLIENT ) then return end

function PLUGIN:ShouldHideBars()
    return true
end


local function MatrixText(text, font, x, y, color, scale, rotation)
    surface.SetFont("CHud2")
    local matrix = Matrix()
    matrix:Translate(Vector(x, y, 1))
    matrix:Scale(scale or Vector(1, 1, 1))
    matrix:Rotate(rotation or Angle(0, 0, 0))
    cam.PushModelMatrix(matrix)
    surface.SetTextPos(0, 0)
    surface.SetTextColor(color.r, color.g, color.b, color.a)
    surface.DrawText(text)
    cam.PopModelMatrix()
end

local predictedStamina = 100

function PLUGIN:Think()
    local offset = CalcStaminaChange(LocalPlayer())
    -- the server check it every 0.25 sec, here we check it every [FrameTime()] seconds
    offset = math.Remap(FrameTime(), 0, 0.25, 0, offset)

    if (offset != 0) then
        predictedStamina = math.Clamp(predictedStamina + offset, 0, 100)
    end
end

function PLUGIN:OnLocalVarSet(key, var)
    if (key != "stm") then return end
    if (math.abs(predictedStamina - var) > 5) then
        predictedStamina = var
    end
end

function CalcStaminaChange(client)
	local character = client:GetCharacter()

	if (!character or client:GetMoveType() == MOVETYPE_NOCLIP or client:Team() == FACTION_UCEK or client:Team() == FACTION_BIAA or client:Team() == FACTION_IAA) then
		return 0
	end

	local runSpeed

	if (SERVER) then
		runSpeed = ix.config.Get("runSpeed") + character:GetAttribute("stm", 0)

		if (client:WaterLevel() > 1) then
			runSpeed = runSpeed * 0.775
		end
	end

	local walkSpeed = ix.config.Get("walkSpeed")
	local maxAttributes = ix.config.Get("maxAttributes", 100)
	local offset

	if (client:KeyDown(IN_SPEED) and client:GetVelocity():LengthSqr() >= (walkSpeed * walkSpeed)) then
		-- characters could have attribute values greater than max if the config was changed
		offset = -ix.config.Get("staminaDrain", 1) + math.min(character:GetAttribute("end", 0), maxAttributes) / 100
	else
		offset = client:Crouching() and ix.config.Get("staminaCrouchRegeneration", 2) or ix.config.Get("staminaRegeneration", 1.75)
	end

	offset = hook.Run("AdjustStaminaOffset", client, offset) or offset

	if (CLIENT) then
		return offset -- for the client we need to return the estimated stamina change
	else
		local current = client:GetLocalVar("stm", 0)
		local value = math.Clamp(current + offset, 0, 100)

		if (current != value) then
			client:SetLocalVar("stm", value)

			if (value == 0 and !client:GetNetVar("brth", false)) then
				client:SetRunSpeed(walkSpeed)
				client:SetNetVar("brth", true)

				character:UpdateAttrib("end", 0.1)
				character:UpdateAttrib("stm", 0.01)

				hook.Run("PlayerStaminaLost", client)
			elseif (value >= 50 and client:GetNetVar("brth", false)) then
				client:SetRunSpeed(runSpeed)
				client:SetNetVar("brth", nil)

				hook.Run("PlayerStaminaGained", client)
			end
		end
	end
end

function PLUGIN:HUDPaint()
    local couleur = Color(255, 175, 125)
    local ply = LocalPlayer()

    local zone = ply:GetArea() or "Cité 24"

    local char = ply:GetCharacter()
    local index = char:GetFaction()
    local faction = ix.faction.indices[index]
    local color = faction and faction.color or color_white

---------------------  LOGO ---------------------------------------

    surface.SetDrawColor(255, 255, 255,255)
    surface.DrawRect(50, ScrH() - 95, 290, 2)

--[[---------------------  BARRE ---------------------------------------]]--

---------------------  VIE ---------------------------------------
    local am = math.max(0, LocalPlayer():Health() / LocalPlayer():GetMaxHealth())
    surface.SetDrawColor(faction.color)
    surface.DrawRect(50, ScrH() - 80, 255*am, 13)


    surface.SetDrawColor(60,60,60,50)
    surface.DrawRect(50, ScrH() - 80, 255, 13)

---------------------  ARMURE ---------------------------------------
    am = math.max(0, LocalPlayer():Armor() / LocalPlayer():GetMaxArmor())
    surface.SetDrawColor(faction.color)
    surface.DrawRect(50, ScrH() - 63, 255 *am, 5)

    surface.SetDrawColor(51, 51, 51, 50)
    surface.DrawRect(50, ScrH() - 63, 255, 5)

---------------------  STAMINA ---------------------------------------
    local am2 = predictedStamina / 100

    local transitionThreshold = 50 
    local blinkFrequency = 1 
    local currentTime = CurTime()

    local fillColor
    if predictedStamina <= transitionThreshold then
        local blinkFactor = math.sin(currentTime * blinkFrequency * math.pi * 2) -- Utilisez sin pour créer le clignotement

        if blinkFactor >= 0 then
       
            fillColor = Color(255, 0, 0, 150)
        else
        
            fillColor = Color(255, 255, 255, 150)
        end
    else
        fillColor = Color(255, 255, 255, 150)
    end

surface.SetDrawColor(fillColor)
surface.DrawRect(50, ScrH() - 55, 255 * am2, 5)

surface.SetDrawColor(51, 51, 51, 50)
surface.DrawRect(50, ScrH() - 55, 255, 5)


    draw.SimpleTextOutlined((zone), "CHud2", 50, ScrH() - 135, Color(255, 255, 255,150), 0, 0, 2, Color(255, 255, 255,1),TEXT_ALIGN_LEFT)
    
if IsValid(wep) then

    end
end
