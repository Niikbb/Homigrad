-- table.insert(LevelList,"bahmut") -- Disabled
bahmut = {}
bahmut.Name = "Конфликт Хомиграда"

bahmut.red = {
	"ЧВК\"ВАГНЕР\"", Color(60, 75, 60), weapons = {"megamedkit", "weapon_binokle", "weapon_kukri", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_hg_rgd5", "weapon_handcuffs", "weapon_radio"},
	main_weapon = {"weapon_aks74u", "weapon_akm", "weapon_galil", "weapon_rpk", "weapon_asval"},
	secondary_weapon = {"weapon_p220", "weapon_mateba", "weapon_glock"},
	models = {"models/knyaje pack/sso_politepeople/sso_politepeople.mdl"}
}

local models = {}

for i = 1, 9 do
	table.insert(models, "models/player/rusty/natguard/male_0" .. i .. ".mdl")
end

bahmut.blue = {
	"НАТО", Color(125, 125, 60), weapons = {"megamedkit", "weapon_binokle", "weapon_hands", "weapon_kabar", "med_band_small", "med_band_big", "med_band_small", "painkiller", "weapon_hg_f1", "weapon_handcuffs", "weapon_radio"},
	main_weapon = {"weapon_hk416", "weapon_m4a1", "weapon_xm1014", "weapon_m249"},
	secondary_weapon = {"weapon_beretta", "weapon_p99", "weapon_hk_usp"},
	models = models
}

bahmut.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function bahmut.StartRound()
	game.CleanUpMap(false)
	bahmut.points = {}

	if not file.Read("homigrad/maps/controlpoint/" .. game.GetMap() .. ".txt", "DATA") and SERVER then
		print("Скажите админу чтоб тот создал !point control_point или хуярьтесь без Точек Захвата.")
		PrintMessage(HUD_PRINTCENTER, "Скажите админу чтоб тот создал !point control_point или хуярьтесь без Точек Захвата.")
	end

	bahmut.LastWave = CurTime()
	bahmut.WinPoints = {}
	bahmut.WinPoints[1] = 0
	bahmut.WinPoints[2] = 0

	team.SetColor(1, bahmut.red[2])
	team.SetColor(2, bahmut.blue[2])

	for i, _ in pairs(SpawnPointsList.controlpoint[3]) do
		SetGlobalInt(i .. "PointProgress", 0)
		SetGlobalInt(i .. "PointCapture", 0)
		bahmut.points[i] = {}
	end

	SetGlobalInt("Bahmut_respawntime", CurTime())

	if CLIENT then return end

	timer.Create("Bahmut_ThinkAboutPoints", 1, 0, function()
		bahmut.PointsThink()
	end)

	if CLIENT then
		bahmut.StartRoundCL()

		return
	end

	bahmut.StartRoundSV()
end

bahmut.RoundRandomDefalut = 1
bahmut.SupportCenter = true