table.insert(LevelList, "hideandseek")

hideandseek = {}
hideandseek.Name = "hg.hideandseek.name"

hideandseek.red = {
	"#hg.hideandseek.team1", Color(255, 55, 55), weapons = {"weapon_radio", "weapon_kukri", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
	main_weapon = {"weapon_m4super", "weapon_remington870", "weapon_xm1014"},
	secondary_weapon = {"weapon_p220", "weapon_mateba", "weapon_glock"},
	models = tdm.models
}

hideandseek.green = {
	"#hg.hideandseek.team2", Color(55, 255, 55), weapons = {"weapon_hands"},
	models = tdm.models
}

hideandseek.blue = {
	"#hg.modes.team.swat", Color(55, 55, 255), weapons = {"weapon_radio", "weapon_hands", "weapon_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_hg_f1", "weapon_handcuffs", "weapon_taser"},
	main_weapon = {"weapon_hk416", "weapon_m4a1", "weapon_m4super", "weapon_mp7", "weapon_xm1014", "weapon_sa80", "weapon_asval", "weapon_m249", "weapon_mp5", "weapon_p90"},
	secondary_weapon = {"weapon_beretta", "weapon_p99", "weapon_hk_usp"},
	models = tdm.models
}

hideandseek.teamEncoder = {
	[1] = "red",
	[2] = "green",
	[3] = "blue"
}

function hideandseek.StartRound(data)
	game.CleanUpMap(false)

	team.SetColor(1, hideandseek.red[2])
	team.SetColor(2, hideandseek.green[2])
	team.SetColor(3, hideandseek.blue[2])

	if CLIENT then
		roundTimeLoot = data.roundTimeLoot

		return
	end

	return hideandseek.StartRoundSV()
end

hideandseek.SupportCenter = true
hideandseek.NoSelectRandom = true