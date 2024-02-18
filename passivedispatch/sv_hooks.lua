

function PLUGIN:EmitRandomChatter(player)
	local randomSounds = {
		"overwatch/citywide/other_languages/overwatch_french_inactionconspiracy.mp3",
		"overwatch/citywide/other_languages/overwatch_french_offworldrelocation.mp3",
		"npc/overwatch/cityvoice/fprison_missionfailurereminder.wav"
	}
	

	
	local randomSound = randomSounds[ math.random(1, #randomSounds) ];
		if(randomSound == "overwatch/citywide/other_languages/overwatch_french_inactionconspiracy.mp3") then
			ix.chat.Send(player, "dispatchs", "Rappel citoyen, inaction égale conspiration. Signalez opposition à une unité de protection civile immédiatement.", true)
		end
        if(randomSound == "overwatch/citywide/other_languages/overwatch_french_offworldrelocation.mp3") then
			ix.chat.Send(player, "dispatchs", "Avis aux citoyens, tout refus de coopération entraîne une relocation extérieure permanente.",true)
		end
		if(randomSound == "npc/overwatch/cityvoice/fprison_missionfailurereminder.wav") then
			ix.chat.Send(player, "dispatchs", "Attention aux unités terrestres. L'échec de la mission entraînera une affectation permanente hors du monde. Rappel du code : SACRIFICE, COAGULATION, PLANIFICATION.",true)
		end
		
	player:EmitSound( randomSound, 60)
end

-- Color(150, 100, 100)

function PLUGIN:Tick()
	for k, v in ipairs( player.GetAll() ) do
		
			local curTime = CurTime()
			
			if (!self.nextChatterEmit) then 
				self.nextChatterEmit = curTime + math.random(580, 600)
			end
			
			if ( (curTime >= self.nextChatterEmit) ) then
				self.nextChatterEmit = nil
				
				self:EmitRandomChatter(v)
			end

	end
end