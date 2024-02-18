local PLUGIN = PLUGIN

PLUGIN.name = 'Réveil Plugin'
PLUGIN.author = 'Khall'

local wakeupmessages = {
    [1] = {"Vous vous réveillez d'une longue sieste et récupérez de votre sommeil."},
    [2] = {"Vous vous levez et reniflez l'air chaud et désagréable du Site Daleth."},
    [3] = {"Vous commencez à vous lever et à récupérer de votre sommeil."},
    [4] = {"Vous transpirez à cause de toute la peur que vous avez ressentie à cause de votre cauchemar et vous vous réveillez."},
    [5] = {"Vous rêviez de quelqu'un et vous avez entendu sa voix, vous avez commencé à vous réveiller."},
    [6] = {"Vous entendez un bruit similaire à un gros objet tombant, vous vous réveillez instantanément."},
    [7] = {"Vous avez entendu un grognement et vous avez commencé à vous réveiller effrayé."},
}

local sonréveil = {
    [1] = {"music/stingers/industrial_suspense1.wav"},
    [2] = {"music/stingers/industrial_suspense2.wav"},
    [3] = {"music/stingers/hl1_stinger_song7.mp3"},
    [4] = {"music/stingers/hl1_stinger_song28.mp3"},
    [5] = {"music/stingers/hl1_stinger_song8.mp3"},
    [6] = {"physics/wood/wood_crate_break2.wav"},
    [7] = {"ambient/levels/prison/inside_battle_antlion1.wav"},
}

function PLUGIN:PostPlayerLoadout(client)
	if client:IsAdmin() or client:IsSuperAdmin() then
		client:Give("weapon_physgun")
        client:Give("gmod_tool")
    end
end

function PLUGIN:PlayerSpawn(ply)
    if ( ply:GetCharacter()) then  
        local randomIndex = math.random(1, 7)
        local message = wakeupmessages[randomIndex][1]
        local sondebout = sonréveil[randomIndex][1]

        ply:ConCommand("play " .. sondebout)
        ply:ScreenFade(SCREENFADE.IN, color_black, 5, 3)
        ply:ChatPrint(message)
    else

    return end
end
