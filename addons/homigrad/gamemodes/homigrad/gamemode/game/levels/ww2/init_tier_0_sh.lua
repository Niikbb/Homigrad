table.insert(LevelList,"ww2")
ww2 = {}
ww2.Name = "Вторая Мировая"

ww2.red = {"Красная Армия",Color(27,82,0),
	weapons = {"weapon_binokle","weapon_hands","med_band_big","med_band_small","medkit","shina","weapon_hg_f1"},
	main_weapon = {"weapon_cmosin","weapon_cppsh41"},
	models = {"models/player/sev2/russian_soldier.mdl"}
}

ww2.blue = {"Вермахт",Color(39,39,39),
	weapons = {"weapon_binokle","weapon_hands","med_band_big","med_band_small","medkit","shina","weapon_kabar","weapon_hg_stielhandgranate24"},
	main_weapon = {"weapon_ck98", "weapon_csmg40"},
	models = {"models/gerconscript7.mdl"}
}

ww2.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function ww2.StartRound()
	game.CleanUpMap(false)
	ww2.points = {}
	ww2.LastWave = CurTime()
    ww2.WinPoints = {}
    ww2.WinPoints[1] = 0
    ww2.WinPoints[2] = 0

	team.SetColor(1,ww2.red[2])
	team.SetColor(2,ww2.blue[2])

	for i, point in pairs(SpawnPointsList.controlpoint[3]) do
        SetGlobalInt(i .. "PointProgress", 0)
        SetGlobalInt(i .. "PointCapture", 0)
        ww2.points[i] = {}
    end

    SetGlobalInt("ww2_respawntime", CurTime())

	if CLIENT then return end
		timer.Create("ww2_ThinkAboutPoints", 1, 0, function()
        	ww2.PointsThink()
    	end)

	if CLIENT then

		ww2.StartRoundCL()
		return
	end

	ww2.StartRoundSV()
end
ww2.RoundRandomDefalut = 1
ww2.SupportCenter = false
