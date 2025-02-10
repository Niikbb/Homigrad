-- Doesn't do anything just yet.
local blacklist = {
    "ttt_minecraft_b5",
    "ttt_minecraftcity_v4",
    "freeway_thicc_v2",
    "ttt_airbus_b3",
    "gm_wick",
}

table.insert(LevelList,"zombie")
zombie = {}
zombie.Name = "Zombie Survival"

zombie.green = {"Survivors",Color(55,255,55),
    weapons = {"weapon_hands"},
    models = tdm.models
}

zombie.blue = {"National Guards",Color(55,55,255),
    weapons = {"weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_hg_f1","weapon_handcuffs","weapon_taser"},
    main_weapon = {"weapon_hk416","weapon_m4a1","weapon_m4super","weapon_mp7","weapon_xm1014","weapon_sa80","weapon_asval","weapon_m249","weapon_mp5","weapon_p90"},
    secondary_weapon = {"weapon_beretta","weapon_p99","weapon_hk_usp"},
    models = tdm.models
}

zombie.teamEncoder = {
    [1] = "green",
    [2] = "blue"
}

function zombie.StartRound(data)
	team.SetColor(1,zombie.green[2])
	team.SetColor(2,zombie.blue[2])

	game.CleanUpMap(false)

    if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

    return zombie.StartRoundSV()
end

zombie.SupportCenter = false
