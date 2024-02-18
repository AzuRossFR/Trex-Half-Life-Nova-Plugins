local PLUGIN = PLUGIN


--local tsin = TimedSin(1.5, 120, 255, 0)

PLUGIN.SocioStatusCol = {
  STABLE = Color(0, 255, 0),
  MARGINALE = Color(255,192,0),
  INFECTION = Color(230,145,56),
  FRACTURE = Color(255, 0, 0),
  MINUIT = Color(120, 120, 120),
  JUGEMENT = Color(255, 0, 0),
  AUTONOME = Color(120, 120, 120)
}

--[[PLUGIN.Ranks = { -- this only works for Civil Protection Upgrades
  [1] = {"i5", 0, 1},
  [2] = {"i4", 0, 2},
  [3] = {"i3", 0, 3},
  [4] = {"i2", 1, 4},
  [5] = {"i1", 1, 5},
  [6] = {"RL", 2, 6, true},
  [7] = {"CmD", 2, 6, true}
}]]

PLUGIN.Ranks = { -- Edit these following the template to make this work
  [1] = {"00°"},
  [2] = {"25°"},
  [3] = {"50°"},
  [4] = {"75°"},
  [5] = {"RL°"},
  [6] = {"RC", nil, nil, true},
  [7] = {"SeC", nil, nil, true},
  [8] = {"GrT"}, -- true means if they have access to the command terminal
  [9] = {"OwS"},
  [10] = {"DsP"},
  [11] = {"SgS"},
  [12] = {"LrD"},
  [13] = {"SnP"},
  [14] = {"ApF"},
  [15] = {"WlM"},
  [16] = {"SpK"},
  [17] = {"EoW", nil, nil, true},
  [18] = {"OrD", nil, nil, true},
  [19] = {"CmD", nil, nil, true}
}

PLUGIN.Divisions = { -- add your divisions here
  "UNION", "JURY", "DEFENDER", "HERO", "APEX", "HELIX", "OBSERVER", "SWORD", "ECHO", "MACE", "LEADER", "GRID", "ANVIL", "GHOST", "RANGER"
}

PLUGIN.Numbers = "%d%d" -- Edit this line depending on how many numbers you use, if you use City Numbers (E.g. C17, C8, I17, etc) and don't understand how to make it work DM me

PLUGIN.name = "Combine Improvements"
PLUGIN.author = "Scotnay"
PLUGIN.description = "A nice set of additions for Combine Factions"
PLUGIN.readme = [[
  This Plugin was made as a personal project of mine, please do feel free to use this on your server and feel free to make any additions or changes that you need.

  Furthermore if you use city digits e.g. "CCA:C17-i5.UNION-24" then this won't work unless you edit it, if you need help with that feel free to DM me

  Important lines with edits that can be made for your server:
  cl_hooks:
  137, 183

  WARNING! Not all division/tag names will have callouts, if you find that is a problem please do not complain to me as I have included every single tag in sv_hooks
  if your server uses its own sounds feel free to go to line 47 of sv_hooks and edit it for your own needs

  Thank you for using my Combine Improvements

  Credits to ZeMysticalTaco for code used on the screen of entities
  Credits to Trudeau and his Clockwork Plugin CTO for being the inspiration for this plugin
]]

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("meta/sh_char.lua")

ix.config.Add("UnobstructedBioSig", true, "Should you be able to see biosignals through objects?", nil, {
  category = "Combine HUD"
})


do
  local COMMAND = {}
  COMMAND.description = "Envoyez un message sur les données Combine"
  COMMAND.arguments = {ix.type.text}
  COMMAND.argumentNames = {"Message"}
  function COMMAND:OnRun(client, string)
    if !(client:IsCombine()) then
      client:Notify("Vous n'êtes pas un membre de la PC")
    else
      Schema:AddCombineDisplayMessage(client:GetName() .. " à envoyé: " .. string .. "...", Color(61,133,198))
      for ply, _ in ix.util.GetCharacters() do
        if client:IsCombine() then
          ply:EmitSound("npc/roller/code2.wav", 75, 100)
        end
      end

    end
  end
  ix.command.Add("MessageCombine", COMMAND)
end

do
  local COMMAND = {}
  COMMAND.description = "Force removes a BOL from the list"
  COMMAND.arguments = {ix.type.text}
  COMMAND.argumentsNames = {"Name"}
  function COMMAND:OnRun(client, text)
    if (!client:IsCombine()) then
      client:Notify("Vous ne pouvez pas.")
    else
      local CombPlayers = {}
      for ply, character in ix.util.GetCharacters() do
        if ply:IsCombine() then
          CombPlayers[#CombPlayers + 1] = ply
        end
      end
    end
  end
  ix.command.Add("ForceRemoveBOL", COMMAND)
end

-- for Val
do
  local COMMAND = {}
  COMMAND.description = "View a citizen's data"
  COMMAND.arguments = {ix.type.player}
  COMMAND.argumentNames = {"Citizen"}
  function COMMAND:OnRun(client, ply)
    if (!client:IsCombine()) then
      client:Notify("Petit malin !")
    elseif ply:IsCombine() then client:Notify("Vous ne pouvez pas faire ça.") else
      local char = ply:GetCharacter()
      local civRecord = char:GetRecord() or {}
      local points = {
        lp = char:GetData("lp", 0),
        vp = char:GetData("vp", 0)
      }
      client:EmitSound("buttons/combine_button3.wav")
      netstream.Start(client, "PDAUse", {ply, civRecord, points})
    end
  end
  ix.command.Add("ViewData", COMMAND)
end




concommand.Add("AllBOL", function()
  PrintTable(PLUGIN.BOL)
end)
