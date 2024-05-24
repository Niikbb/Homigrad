table.insert(LevelList,"css")
css = {}
css.Name = "Conter-Strike: Source Govno"

css.red = {"Террористы",Color(176,0,0),
	weapons = {"megamedkit","weapon_binokle","weapon_hands","weapon_hg_hatchet","med_band_small","med_band_big","med_band_small","painkiller","weapon_handcuffs","weapon_radio"},
	main_weapon = {"weapon_galilsar", "weapon_mp5", "weapon_m3super"},
	secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_beretta"},
	models = {"models/player/leet.mdl","models/player/phoenix.mdl"}
}

css.blue = {"Контр-Терористы",Color(79,59,187),
	weapons = {"megamedkit","weapon_binokle","weapon_hg_hatchet","weapon_hands","med_band_big","med_band_small","medkit","painkiller","weapon_handcuffs","weapon_radio"},
	main_weapon = {"weapon_m4a1","weapon_mp7","weapon_galil"},
	secondary_weapon = {"weapon_hk_usp", "weapon_deagle"},
	models = {"models/player/riot.mdl"}
}

css.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function css.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,red)
	team.SetColor(2,blue)

	if CLIENT then
		css.StartRoundCL()
		return
	end

	css.StartRoundSV()
end
css.RoundRandomDefalut = 2
css.SupportCenter = false