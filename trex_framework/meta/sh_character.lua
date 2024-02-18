local CHAR = ix.meta.character

function CHAR:PlaySound(sound)
    net.Start("ixStartSound")
        net.WriteString(sound, 32)
    net.Send(self:GetPlayer())
end
