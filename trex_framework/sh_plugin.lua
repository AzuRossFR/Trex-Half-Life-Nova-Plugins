PLUGIN.name = "Trex Framework";
PLUGIN.description = "";
PLUGIN.author = "Khall";

ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)

color_buttonapo = Color(188,183,165,255)
color_textapo = Color(4,11,11) 

if CLIENT then
    ix.option.Add("colorCorrection", ix.type.number, 1.5, {
		category = "appearance", min = 0.5, max = 1.5,decimals = 1
	})

    ix.option.Add("luminosite", ix.type.number, 0, {
		category = "appearance", min = -0.05, max = 0.05,decimals = 2
	})

	ix.option.Add("disablehud", ix.type.bool, false, {
		category = "general",
	})
	
	function PLUGIN:HUDPaint()
		if ix.option.Get("disablehud", false) then
			return false
		end
	end
end

Handcuffs = Handcuffs or {}

function guigui_handcuff_wep(wep)
	for k, v in pairs(Handcuffs.wepTable) do
		if k == wep then
			return v
		end
	end
	if GetConVar("Handcuffs_StrictWeapons"):GetString() == "1" then
		return false
	else
		return true
	end
end

Handcuffs.wepTable = {
	["weapon_physgun"] = true, 
	["weapon_physcannon"] = true, 
	["gmod_tool"] = true, 
	["weapon_fists"] = true, 
	["keys"] = true, 
	["pocket"] = true, 
}