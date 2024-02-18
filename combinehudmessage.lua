PLUGIN.name = "Combine Display Messages"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Adds additional messages to the combine display."

local display_messages = {
	"connexion de milice..",
	"connexion des conseillers..",
	"envoie des ordres de l'administrateur..",
	"devoir, exigence, respect...",
	"gloire au cartel...",
	"le cartel attends de vous que vous donniez tout...",
	"rappel aux agents de rang 00° votre formation doit etre accompli...",
	"n oubliez pas de recycler materiaux afin d obtenir resine combine...",
	"les actes anti-civiles doivent etre controler et punis...",
	"les citoyens sont toujours suspects...",
	"l union vous accepte, gagnez le privilege de les rejoindre...",
	"toute acte de trahison sera punis par vos superieurs...",
	"les transhumains sont superieur...",
	"union, roi ,milice"
}

--This might be expensive, i'm not sure.
function PLUGIN:PlayerTick(player)
	if player:IsCombine() and player:Alive() then
		if !player.nextTrivia or player.nextTrivia <= CurTime() then
			Schema:AddCombineDisplayMessage(table.Random(display_messages), Color(0,218,255))
			player.nextTrivia = CurTime() + 5
		end
	end
end