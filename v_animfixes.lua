local PLUGIN = PLUGIN
PLUGIN.name = "Animation Fixes for Various Addons"
PLUGIN.author = "Val"
PLUGIN.description = "Improves compatability for a bunch of models. 8)"


-- Metropolice Pack (https://steamcommunity.com/sharedfiles/filedetails/?id=104491619)
ix.anim.SetModelClass("models/dpfilms/metropolice/arctic_police.mdl", "metrocop") -- Arctic Police
ix.anim.SetModelClass("models/dpfilms/metropolice/badass_police.mdl", "metrocop") -- Badass Police
ix.anim.SetModelClass("models/dpfilms/metropolice/biopolice.mdl", "metrocop") -- Bio Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/blacop.mdl", "metrocop") -- Black Police
ix.anim.SetModelClass("models/dpfilms/metropolice/c08cop.mdl", "metrocop") -- City 08 Police
ix.anim.SetModelClass("models/dpfilms/metropolice/civil_medic.mdl", "metrocop") -- Civil Medic/HELIX
ix.anim.SetModelClass("models/dpfilms/metropolice/elite_police.mdl", "metrocop") -- Elite Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/female_police.mdl", "metrocop") -- Female Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/hd_barney.mdl", "metrocop") -- HD Barney 
ix.anim.SetModelClass("models/dpfilms/metropolice/hdpolice.mdl", "metrocop") -- HD Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/hl2beta_police.mdl", "metrocop") -- HL2 Beta Police
ix.anim.SetModelClass("models/dpfilms/metropolice/hl2concept.mdl", "metrocop") -- HL2 Concept Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/hunter_police.mdl", "metrocop") -- Hunter Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/police_bt.mdl", "metrocop") -- Breen Troop Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/police_fragger.mdl", "metrocop") -- Fragger Police 
ix.anim.SetModelClass("models/conceptbine_policeforce/conceptpolice_nemez.mdl", "metrocop") -- Trenchcoat Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/resistance_police.mdl", "metrocop") -- Resistance/Rebel Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/retrocop.mdl", "metrocop") -- Retro Police
ix.anim.SetModelClass("models/dpfilms/metropolice/rogue_police.mdl", "metrocop") -- Rogue Police
ix.anim.SetModelClass("models/dpfilms/metropolice/rtb_police.mdl", "metrocop") -- RTB Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/steampunk_police.mdl", "metrocop") -- Steampunk Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/tf2_metrocop.mdl", "metrocop") -- TF2 Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/tribal_police.mdl", "metrocop") -- Tribal Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/tron_police.mdl", "metrocop") -- Tron Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/urban_police.mdl", "metrocop") -- Urban Police 
ix.anim.SetModelClass("models/dpfilms/metropolice/zombie_police.mdl", "metrocop") -- Zombie/Infected Police 

-- jQueary's Combine Soldiers Redone (https://steamcommunity.com/sharedfiles/filedetails/?id=2223658602)
ix.anim.SetModelClass("models/jq/hlvr/characters/combine/combine_captain/combine_captain_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/jq/hlvr/characters/combine/heavy/combine_heavy_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/jq/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl", "overwatch")

-- jQueary's Combine Workers (https://steamcommunity.com/sharedfiles/filedetails/?id=2109019567)
ix.anim.SetModelClass("models/hlvr/characters/hazmat_worker/npc/hazmat_worker_citizen.mdl", "citizen_male")
ix.anim.SetModelClass("models/hlvr/characters/hazmat_worker/npc/hazmat_worker_combine.mdl", "overwatch")
ix.anim.SetModelClass("models/hlvr/characters/worker/npc/worker_citizen.mdl", "citizen_male")
ix.anim.SetModelClass("models/hlvr/characters/worker/npc/worker_combine.mdl", "overwatch")

-- Combine Soldiers Redone (https://steamcommunity.com/sharedfiles/filedetails/?id=1976083346)
ix.anim.SetModelClass("models/ninja/combine/combine_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combine_soldier_prisonguard.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combine_super_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combinonew.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combinonew_armor.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combinonew_mopp.mdl", "overwatch")

-- Civil Protection Upgrades (https://steamcommunity.com/sharedfiles/filedetails/?id=2149815819)
ix.anim.SetModelClass("models/ma/hla/terranovafemalepolice.mdl", "metrocop")
ix.anim.SetModelClass("models/ma/hla/terranovafemalepolicedead.mdl", "metrocop")
ix.anim.SetModelClass("models/ma/hla/terranovapolice.mdl", "metrocop")
ix.anim.SetModelClass("models/ma/hla/terranovapolicedead.mdl", "metrocop")

-- C24 Civil Protection Model (https://steamcommunity.com/sharedfiles/filedetails/?id=1119769089)
ix.anim.SetModelClass("models/dpfilms/metropolice/24nebcop.mdl", "metrocop")

-- HL2TS2 Citizen Models Overhaul (https://steamcommunity.com/sharedfiles/filedetails/?id=1801690724)
	-- I don't even know if this needs an animation fix, but I made it anyway.
	-- MALE
ix.anim.SetModelClass("models/fty/citizens/male_01.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_02.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_03.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_04.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_05.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_06.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_07.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_08.mdl", "citizen_male")
ix.anim.SetModelClass("models/fty/citizens/male_09.mdl", "citizen_male")
	-- FEMALE
ix.anim.SetModelClass("models/fty/citizens/female_01.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_02.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_03.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_04.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_05.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_06.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_07.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_08.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_10.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_11.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_17.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_19.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_21.mdl", "citizen_female")
ix.anim.SetModelClass("models/fty/citizens/female_22.mdl", "citizen_female")

-- Suits & Robbers (https://steamcommunity.com/sharedfiles/filedetails/?id=110138917)
	-- I don't even know if this needs an animation fix.
	-- Male 01
ix.anim.SetModelClass("models/suits/male_01_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_01_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_01_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_01_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_01_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_01_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_01_shirt_tie.mdl", "citizen_male")
	-- Male 02
ix.anim.SetModelClass("models/suits/male_02_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_02_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_02_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_02_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_02_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_02_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_02_shirt_tie.mdl", "citizen_male")
	-- Male 03
ix.anim.SetModelClass("models/suits/male_03_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_03_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_03_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_03_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_03_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_03_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_03_shirt_tie.mdl", "citizen_male")
	-- Male 04
ix.anim.SetModelClass("models/suits/male_04_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_04_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_04_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_04_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_04_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_04_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_04_shirt_tie.mdl", "citizen_male")
	-- Male 05
ix.anim.SetModelClass("models/suits/male_05_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_05_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_05_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_05_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_05_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_05_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_05_shirt_tie.mdl", "citizen_male")
	-- Male 06
ix.anim.SetModelClass("models/suits/male_06_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_06_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_06_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_06_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_06_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_06_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_06_shirt_tie.mdl", "citizen_male")
	-- Male 07
ix.anim.SetModelClass("models/suits/male_07_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_07_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_07_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_07_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_07_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_07_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_07_shirt_tie.mdl", "citizen_male")
	-- Male 08
ix.anim.SetModelClass("models/suits/male_08_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_08_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_08_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_08_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_08_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_08_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_08_shirt_tie.mdl", "citizen_male")
	-- Male 09
ix.anim.SetModelClass("models/suits/male_09_closed_coat_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_09_closed_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_09_open.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_09_open_tie.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_09_open_waistcoat.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_09_shirt.mdl", "citizen_male")
ix.anim.SetModelClass("models/suits/male_09_shirt_tie.mdl", "citizen_male")


-- Combine Soldiers Redone
ix.anim.SetModelClass("models/ninja/combine/combine_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combine_soldier_prisonguard.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combine_super_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/ninja/combine/combinonew.mdl", "citizen_male")
ix.anim.SetModelClass("models/ninja/combine/combinonew_armor.mdl", "citizen_male")
ix.anim.SetModelClass("models/ninja/combine/combinonew_mopp.mdl", "citizen_male")

-- Xen Fungus Zombies + Hazmat CP Models
ix.anim.SetModelClass("models/schwarzkruppzo/player/assassin.mdl", "player")

-- Willard Networks
ix.anim.SetModelClass("models/vortigaunt.mdl", "vortigaunt")
ix.anim.SetModelClass("models/vortigaunt_slave.mdl", "vortigaunt")
ix.anim.SetModelClass("models/willardupgrades/civilprotection.mdl", "metrocop")

-- Willard Networks Combine 2.0 (I really like their models.)
ix.anim.SetModelClass("models/willardnetworks/combine/charger.mdl", "overwatch")
ix.anim.SetModelClass("models/willardnetworks/combine/ordinal.mdl", "overwatch")
ix.anim.SetModelClass("models/willardnetworks/combine/soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/willardnetworks/combine/suppressor.mdl", "overwatch")
for i = 1,9 do ix.anim.SetModelClass("models/wn7new/metropolice/male_0"..i..".mdl", "metrocop") end
ix.anim.SetModelClass("models/wn7new/metropolice/male_10.mdl", "metrocop")

-- Combine Soldier Pack
ix.anim.SetModelClass("models/combine_darkelite1_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_darkelite_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_overwatch_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_soldier2000.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_soldiergrunt.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_soldieros.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_soldierproto.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_soldierproto_drt.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_soldiersnow.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_super_soldierproto.mdl", "overwatch")
ix.anim.SetModelClass("models/combine_super_soldierprotodirt.mdl", "overwatch")

-- Willard Models Pack

ix.anim.SetModelClass("models/police_nemez.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/female_01.mdl", "citizen_female")
ix.anim.SetModelClass("models/wn7new/metropolice/female_02.mdl", "citizen_female")
ix.anim.SetModelClass("models/wn7new/metropolice/female_03.mdl", "citizen_female")
ix.anim.SetModelClass("models/wn7new/metropolice/female_04.mdl", "citizen_female")
ix.anim.SetModelClass("models/wn7new/metropolice/female_06.mdl", "citizen_female")
ix.anim.SetModelClass("models/wn7new/metropolice/female_07.mdl", "citizen_female")
ix.anim.SetModelClass("models/wn7new/metropolice/male_01.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_02.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_03.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_04.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_05.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_06.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male/pc_male_07.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_08.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_09.mdl", "metrocop")
ix.anim.SetModelClass("models/wn7new/metropolice/male_10.mdl", "metrocop")

ix.anim.SetModelClass("models/Combine_Soldier_Prisonguard.mdl", "overwatch")
ix.anim.SetModelClass("models/Combine_Soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/theparrygod/spikewall.mdl", "overwatch")
ix.anim.SetModelClass("models/Combine_Super_Soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/jq/theparrygod/transition_period_overwatch_soldier_npc.mdl", "overwatch")

ix.anim.SetModelClass("models/willardnetworks/citizens/female_01.mdl", "citizen_female")
ix.anim.SetModelClass("models/willardnetworks/citizens/female_02.mdl", "citizen_female")
ix.anim.SetModelClass("models/willardnetworks/citizens/female_03.mdl", "citizen_female")
ix.anim.SetModelClass("models/willardnetworks/citizens/female_04.mdl", "citizen_female")
ix.anim.SetModelClass("models/willardnetworks/citizens/female_06.mdl", "citizen_female")
ix.anim.SetModelClass("models/willardnetworks/citizens/female_07.mdl", "citizen_female")
ix.anim.SetModelClass("models/willardnetworks/citizens/male01.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male02.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male03.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male04.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male05.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male06.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male07.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male08.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male09.mdl", "citizen_male")
ix.anim.SetModelClass("models/willardnetworks/citizens/male10.mdl", "citizen_male")

-- Synapse

ix.anim.SetModelClass("models/cultist/hl_a/combine_heavy/npc/combine_heavy_trooper.mdl", "overwatch")
ix.anim.SetModelClass("models/cultist/hl_a/combine_suppresor/npc/combine_suppresor.mdl", "overwatch")
ix.anim.SetModelClass("models/cultist/hl_a/combine_commander/npc/combine_commander.mdl", "overwatch")
ix.anim.SetModelClass("models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl", "overwatch")
ix.anim.SetModelClass("models/trexhln/metropolice/male_cp.mdl", "metrocop")
ix.anim.SetModelClass("models/trexhln/metropolice/sectorial.mdl", "metrocop")
ix.anim.SetModelClass("models/trexhln/metropolice/female_cp.mdl", "citizen_female")
ix.anim.SetModelClass("models/zombie/hla/hazmat.mdl", "zombie")
ix.anim.SetModelClass("models/zombie/hla/overalls1.mdl", "zombie")
ix.anim.SetModelClass("models/zombie/hla/overalls2.mdl", "zombie")
ix.anim.SetModelClass("models/zombie/hla/shirtless.mdl", "zombie")
ix.anim.SetModelClass("models/zombie/hla/tanktop.mdl", "zombie")
ix.anim.SetModelClass("models/zombie/hla/worker.mdl", "zombie")
ix.anim.SetModelClass("models/zombie/hla/worker2.mdl", "zombie")
ix.anim.SetModelClass("models/zombie/hla/zombine.mdl", "zombie")
ix.anim.SetModelClass("models/echo/hla/advisor_pm.mdl", "player")

player_manager.AddValidModel("ixMPF", "models/trexhln/metropolice/male_cp.mdl")
player_manager.AddValidHands("ixMPF", "models/player/hla/metropolice_chands.mdl", 0, "00000000")
player_manager.AddValidModel("ixORD", "models/cultist/hl_a/combine_commander/npc/combine_commander.mdl")
player_manager.AddValidHands("ixORD", "models/cultist/hl_a/combine_commander/combine_commander_hands.mdl", 0, "00000000")
