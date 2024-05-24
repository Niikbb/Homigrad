css.GetTeamName = tdm.GetTeamName

local playsound = false

function css.StartRoundCL()
    playsound = true
end

function css.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local name,color = css.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)
        draw.DrawText( "Ваша команда " .. name, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Командный Бой", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 155,155,255,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )

        draw.DrawText( "Нейтрализуйте вражескую команду...", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        return
    end
end