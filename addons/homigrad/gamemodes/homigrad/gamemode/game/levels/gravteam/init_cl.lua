gravteam.GetTeamName = tdm.GetTeamName

local playsound = false
function gravteam.StartRoundCL()
    playsound = true
end

function gravteam.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = gravteam.GetTeamName(lply)

	local startRound = roundTimeStart + 5 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,220),0.5,4)

        draw.DrawText( "You are on team: " .. name, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Gravity Gun Gambit (TDM)", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 155,155,55,math.Clamp(startRound,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "You only have a crowbar & gravity gun. Use the environment to take out the enemy team!", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,55,math.Clamp(startRound,0,1) * 255 ), TEXT_ALIGN_CENTER )
        return
    end
end