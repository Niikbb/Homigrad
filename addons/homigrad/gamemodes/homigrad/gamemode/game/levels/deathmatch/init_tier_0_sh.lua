table.insert(LevelList, "dm")

dm = {}
dm.Name = "hg.dm.name"
dm.LoadScreenTime = 5.5
dm.CantFight = dm.LoadScreenTime
dm.NoSelectRandom = false

local red = Color(155, 155, 255)

function dm.GetTeamName(ply)
	local teamID = ply:Team()
	if teamID == 1 then return "#hg.dm.team1", red end
end

function dm.StartRound(data)
	game.CleanUpMap(false)

	team.SetColor(1, red)
	team.SetColor(2, red)
	team.SetColor(3, red)

	if CLIENT then
		roundTimeStart = data[1]
		roundTime = data[2]

		return dm.StartRoundCL()
	end

	return dm.StartRoundSV()
end

if SERVER then return end

local playsound = false

function dm.StartRoundCL()
	playsound = true
end

function dm.HUDPaint_RoundLeft(white)
	local lply = LocalPlayer()
	local startRound = roundTimeStart + 5 - CurTime()

	if startRound > 0 and lply:Alive() then
		if playsound then
			playsound = false

			surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")

			lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 220), 0.5, 4)
		end

		draw.DrawText(language.GetPhrase("hg.dm.name"), "HomigradRoundFont", ScrW() / 2, ScrH() / 8, Color(red.r, red.g, red.b, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)
		draw.DrawText(language.GetPhrase("hg.dm.desc1"), "HomigradRoundFont", ScrW() / 2, ScrH() / 2, Color(red.r, red.g, red.b, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)
		draw.DrawText(language.GetPhrase("hg.dm.desc2"), "HomigradRoundFont", ScrW() / 2, ScrH() / 1.2, Color(red.r, red.g, red.b, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)

		return
	end
end

function dm.CanUseSpectateHUD()
	return false
end

dm.RoundRandomDefalut = 2