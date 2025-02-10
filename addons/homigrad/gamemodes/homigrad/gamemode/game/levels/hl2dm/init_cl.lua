hl2dm.GetTeamName = tdm.GetTeamName

local playsound = false

function hl2dm.StartRoundCL()
	playsound = true
end

function hl2dm.HUDPaint_RoundLeft(white)
	local lply = LocalPlayer()
	local name, color = hl2dm.GetTeamName(lply)
	local startRound = roundTimeStart + 5 - CurTime()

	if startRound > 0 and lply:Alive() then
		if playsound then
			playsound = false

			lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 220), 0.5, 4)
		end

		draw.DrawText(language.GetPhrase("hg.modes.yourteam"):format(language.GetPhrase(name)), "HomigradRoundFont", ScrW() / 2, ScrH() / 2, Color(color.r, color.g, color.b, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)
		draw.DrawText(language.GetPhrase("hg.hl2dm.name"), "HomigradRoundFont", ScrW() / 2, ScrH() / 8, Color(155, 155, 55, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)
		draw.DrawText(language.GetPhrase("hg.hl2dm.desc1"), "HomigradRoundFont", ScrW() / 2, ScrH() / 1.2, Color(65, 65, 65, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)

		if lply:Team() == 1 then
			draw.DrawText(language.GetPhrase("hg.hl2dm.desc2"), "HomigradRoundFont", ScrW() / 2, ScrH() / 1.1, Color(65, 65, 65, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)
		end

		return
	end
end