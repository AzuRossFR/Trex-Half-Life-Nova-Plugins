PLUGIN = PLUGIN

PLUGIN.name = "Citizen Terminal"
PLUGIN.author = "TrexStudio"
PLUGIN.description = ""

if (CLIENT) then
	PLUGIN.points = 0
end

if (SERVER) then
	util.AddNetworkString("ixTerminalRequest")
	util.AddNetworkString("ixTerminalStopRequest")
end

ix.util.Include("thirdparty/cl_3d2dui.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("meta/sh_civent.lua", "shared")
ix.util.Include("cl_hooks.lua")