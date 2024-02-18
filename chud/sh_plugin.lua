local PLUGIN = PLUGIN

PLUGIN.name = "Combine Improvements V2"
PLUGIN.author = "Scotnay"
PLUGIN.description = "A set of improvements for Universal Union factions"

-- This is only needed if you're going to use taglines
PLUGIN.divisions = { "UNION", "JURY", "DEFENDER", "HERO", "APEX", "HELIX", "OBSERVER", "SWORD", "ECHO", "MACE", "LEADER", "GRID", "ANVIL", "GHOST", "RANGER" }

-- Key is rank and bool is whether or not they can use HC Terminal
PLUGIN.ranks = {
  [ "00" ] = false,
  [ "25" ] = false,
  [ "50" ] = false,
  [ "75" ] = false,
  [ "RL" ] = true,
  [ "RC" ] = true,
  [ "SeC" ] = true,
  [ "EoW" ] = true,
  [ "OrD" ] = true,
}

PLUGIN.SocioColors = {
  [ "STABLE" ] = Color( 0, 255, 0 ),
  [ "MARGINALE" ] = Color( 255,192,0 ),
  [ "INFECTION" ] = Color( 230,145,56 ),
  [ "FRACTURE" ] = Color( 255, 0, 0 ),
  [ "AUTONOME" ] = Color( 120, 120, 120 ) -- This only exists for checks
}   

-- This is used to determine what factions should be considered citizens
-- and therefore show up in the terminals.
PLUGIN.civFactions = {
  [ FACTION_CITIZEN ] = true
}

ix.util.Include( "cl_hooks.lua" )
ix.util.Include( "cl_plugin.lua" )
ix.util.Include( "sv_hooks.lua" )
ix.util.Include( "sv_plugin.lua" )
ix.util.Include( "meta/sh_char.lua" )
ix.util.Include( "meta/sh_player.lua" )

ix.config.Add( "CP ID Offset", 11, "Set the offset for CP names, if the numbers are wrong make this higher or lower", nil,
  { data = {min = 0, max = 50 },
  category = "Combine Improvements"
} )

ix.config.Add( "Use Taglines", false, "Whether or not to use taglines in unit names", nil,
  {
  category = "Combine Improvements"
} )
