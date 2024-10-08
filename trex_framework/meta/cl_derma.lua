local panelMeta = FindMetaTable('Panel')

function panelMeta:ResponsiveXY(w, h, x, y)
    local sW, sH = ScrW(), ScrH()
    local positions = (x && y && x + y > 0)

    w = math.Clamp(w, 10, 1920);
    h = math.Clamp(h, 10, 1080);
    self:SetSize( sW * (w / 1920), sH * (h / 1080) )

    x = positions && math.Clamp(x, 0, 1.25) || 0;
    y = positions && math.Clamp(y, 0, 1.25) || 0;
    self:SetPos( sW * x, sH * y )
    if !positions then self:Center() end
end;