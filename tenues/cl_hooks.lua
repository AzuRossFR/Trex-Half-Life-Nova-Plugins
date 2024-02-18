local PLUGIN = PLUGIN
local maskOverlayMat = ix.util.GetMaterial("trexhln/overlay")
function Schema:RenderScreenspaceEffects()

    if ( LocalPlayer().CanOverrideView ) then
        if ( LocalPlayer():CanOverrideView() or IsValid(ix.gui.menu)) then
            return LocalPlayer():SetDSP(1)
        end
    end

    if LocalPlayer():HasHazmat() then
        render.UpdateScreenEffectTexture()
        render.SetMaterial(maskOverlayMat)
        render.DrawScreenQuad()
    end
end
