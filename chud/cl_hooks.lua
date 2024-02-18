local PLUGIN = PLUGIN

PLUGIN.SocioStatus = PLUGIN.SocioStatus or "STABLE"
PLUGIN.BOL = PLUGIN.BOL or { }
PLUGIN.FactionCalls = PLUGIN.FactionCalls or { }

surface.CreateFont("CHudLabel", {
    font = "' Mono Bold'",
    extended = true,
    size = ScreenScale( 7.5 ),
    weight = 200,
    antialias = true,
    shadow = true,
    outline = true,
    scanlines = 2
})

  surface.CreateFont("CHud", {
    font = "Combine_Alphabet",
    size = 74,
    extended = true,
    scanlines = 2,
    blursize = 1.5,
    shadow = true,
    weight = 100
})

surface.CreateFont("CHud2", {
    font = "Combine_Alphabet",
    size = 32,
    extended = true,
    scanlines = 2,
    blursize = 1.5,
    shadow = true,
    weight = 100
})

surface.CreateFont("CHud3", {
    font = "Combine_Alphabet",
    size = 40,
    extended = true,
    scanlines = 2,
    blursize = 1,
    shadow = true,
    weight = 100
})

surface.CreateFont("CHud4", {
    font = "Combine_Alphabet",
    size = 25,
    extended = true,
    scanlines = 2,
    blursize = 1,
    shadow = true,
    weight = 100
})

surface.CreateFont("CMBfont", {
    font = "Combine_Alphabet",
    size = 20,
    extended = true,
    scanlines = 2,
    blursize = 1,
    shadow = true,
    weight = 100
})

surface.CreateFont("CMBfont1", {
    font = "Boxed Round Heavy",
    size = 40,
    extended = true,
    scanlines = 2,
    blursize = 1,
    shadow = true,
    weight = 100
})

-- Clientside network receives
local function nUpdateSociostatus()
  local newStatus = net.ReadString()

  if ( !PLUGIN.SocioColors[ newStatus ] ) then
    return
  end

  PLUGIN.SocioStatus = newStatus
end
net.Receive( "nUpdateSociostatus", nUpdateSociostatus )

local function nUpdateBOL()
  local bolTable = net.ReadTable()

  PLUGIN.BOL = bolTable

  local oldTab = PLUGIN.BOLPos

  PLUGIN.BOLPos = { }

  -- Small loop so we can remove old positions
  for i, v in ipairs( PLUGIN.BOL ) do
    if ( oldTab[ v ] ) then
      PLUGIN.BOLPos[ v ] = oldTab[ v ]
    end
  end
end
net.Receive("BOL", function()
  local ply = net.ReadEntity()
  local Add = net.ReadBool()

  if Add == true then
    PLUGIN.BOL[#PLUGIN.BOL + 1] = ply:GetName()
  else
    table.RemoveByValue(PLUGIN.BOL, ply:GetName())
  end
end)

local function nMPFTerminal()
  vgui.Create( "ixMPFTerminal" )
end
net.Receive( "nMPFTerminal", nMPFTerminal )

local function nCommandTerminal()
  vgui.Create( "ixHighCommand" )
end
net.Receive( "nCommandTerminal", nCommandTerminal )

-- Clientside hooks
local client = LocalPlayer()

function PLUGIN:ShouldDrawLocalPlayer()
  return client.bShouldDraw
end

local col_white = Color( 255, 255, 255 )
local col_green = Color( 0, 255, 0 )
local col_yellow = Color( 255, 255, 0 )
local col_red = Color( 255, 0, 0 )

function PLUGIN:HUDPaint()
  if ( !IsValid( client ) ) then
    client = LocalPlayer()
  end

  if ( !client:IsCombine() ) then
    return
  end

  local socioColor = self.SocioColors[ self.SocioStatus ]

  local blackTSin = TimedSin( 0.5, 120, 200, 0 )

  if ( self.SocioStatus == "BLACK" ) then
    socioColor = Color( blackTSin, blackTSin, blackTSin )
  end

  local projectedThreat = 0
  local area = LocalPlayer():GetArea() or "NULL"
  draw.SimpleText( "Statut-Civique: " .. self.SocioStatus, "CMBfont1", ScrW() - 10, 5, socioColor, TEXT_ALIGN_RIGHT )
  draw.SimpleText( "Localisation actuelle: " .. area, "CHudLabel", ScrW() - 10, 85, col_white, TEXT_ALIGN_RIGHT )
  draw.DrawText( "Liste des recherchés: ", "CHudLabel", ScrW() - 10, 125, col_white, TEXT_ALIGN_RIGHT )


  self.BOLPos = self.BOLPos or { }

  local y = 165

  for i, v in ipairs( self.BOL ) do
    if ( !IsValid( v ) ) then
      table.remove( self.BOL, i )
      continue
    end

    self.BOLPos[ v ] = Lerp( 0.02, self.BOLPos[v] or 140, y )
    draw.SimpleText( v:GetName(), "CHudLabel", ScrW() - 10, self.BOLPos[ v ], col_white, TEXT_ALIGN_RIGHT )

    y = y + 40
  end

  for i, v in ipairs( player.GetAll() ) do
    if ( v == client ) then
      continue
    end

    if ( !v:Alive() ) then
      continue
    end

    local character = v:GetCharacter()

    if ( !character ) then
      continue
    end

    local faction = character:GetFaction()

    if ( !faction ) then
      continue
    end

    if ( !self.FactionCalls[ faction ] ) then
      continue
    end

    local suc, res, mult = pcall( self.FactionCalls[ faction ], v )

    if ( suc and res ) then
      projectedThreat = projectedThreat + mult
    end


    if ( !suc ) then
      ErrorNoHalt( "Le rappel d'avertissement a échoué pour " .. v:GetName() .. " faction!\n" .. res .. "\n" )
    end
  end
  self.threat = self.threat or projectedThreat
  self.nextTick = self.nextTick or 0

  if ( self.nextTick < CurTime() ) then
    self.threat = math.Approach( self.threat, projectedThreat, math.random( 1, 8 ) )
    self.nextTick = CurTime() + 0.25
  end

  local color = col_green

  local tsin = TimedSin( 1.25, 120, 200, 0 )

  if ( self.threat >= 40 and self.threat < 75 ) then
    color = col_yellow
  elseif ( self.threat >= 75 and self.threat <= 100 ) then
    color = col_red
  elseif ( self.threat > 100 ) then
    color = Color(tsin, tsin, tsin)
  end
  draw.DrawText( "Évaluation de stabilité : " .. self.threat .. "%", "CHudLabel", ScrW() - 10, 45, color, TEXT_ALIGN_RIGHT )
end
