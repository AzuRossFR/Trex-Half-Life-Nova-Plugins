
PLUGIN.name = "Primary Needs"
PLUGIN.author = "Bilwin"
PLUGIN.schema = "Any"
PLUGIN.version = 'Need to rework'

ix.char.RegisterVar("saturation", {
    field = "saturation",
    fieldType = ix.type.number,
    isLocal = true,
    bNoDisplay = true,
    default = 60
})

ix.char.RegisterVar("satiety", {
    field = "satiety",
    fieldType = ix.type.number,
    isLocal = true,
    bNoDisplay = true,
    default = 60
})

ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_meta.lua")
ix.util.Include("sh_config.lua")
ix.util.Include("sh_commands.lua")