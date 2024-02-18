local PLUGIN = PLUGIN

net.Receive("ixTerminalRequest", function(len, player)
    if !player:Alive() then return end

    local terminal
    for k, v in pairs(ents.FindInSphere(player:GetPos(), 80)) do
        if v:GetClass() == "ix_civil_station" then
            terminal = v
            break
        end
    end

    if !IsValid(terminal) then 
        return 
    end
    
    if CurTime() < (player.nextTerminalRequest or 0) then return end

    local waypoint = {
        pos = terminal:GetPos(),
        noDistance = true,
        text = "Signal d'Alerte lancée !",
        color = Color(255, 0, 0),
        addedBy = player,
        time = CurTime() + 20
    }

    terminal:EmitSound("trexhla/civil_station_alarme.wav")
    terminal:SetBodygroup(2,1)
    terminal:SetNetVar("isAlerting", true )
    player.nextTerminalRequest = CurTime() + 1
end)

net.Receive("ixTerminalStopRequest", function(len, player)
    if !player:Alive() then return end

    local terminal
    for k, v in pairs(ents.FindInSphere(player:GetPos(), 80)) do
        if v:GetClass() == "ix_civil_station" then
            terminal = v
            break
        end
    end

    if !IsValid(terminal) then 
        return 
    end
    
    terminal:SetBodygroup(2,0)
    terminal:StopSound("trexhla/civil_station_alarme.wav")
    terminal:SetNetVar("isAlerting", false )
end)