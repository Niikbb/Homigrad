--table.insert(LevelList, "gravdm")
gravdm = {}
gravdm.Name = "Gravity Gun Gambit (Free for All)"
gravdm.LoadScreenTime = 5.5
gravdm.CantFight = gravdm.LoadScreenTime

gravdm.NoSelectRandom = true

local red = Color(155, 155, 255)

function gravdm.GetTeamName(ply)
    local teamID = ply:Team()

    if teamID == 1 then return "Fighter", red end
end

function gravdm.StartRound(data)
    team.SetColor(1, red)
    team.SetColor(2, blue)
    team.SetColor(1, green)

    game.CleanUpMap(false)

    if CLIENT then
        roundTimeStart = data[1]
        roundTime = data[2]
        gravdm.StartRoundCL()

        return
    end

    return gravdm.StartRoundSV()
end

if SERVER then return end

local black = Color(0, 0, 0)
local red = Color(255, 0, 0)

local kill = 4

local white, red = Color(255, 255, 255), Color(255, 0, 0)

local fuck, fuckLerp = 0, 0


local playsound = false
function gravdm.StartRoundCL()
    playsound = true
end

function gravdm.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()

    local startRound = roundTimeStart + 5 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")
        end
        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)


        --[[surface.SetFont("HomigradFontBig")
        surface.SetTextColor(color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255)
        surface.SetTextPos(ScrW() / 2 - 40,ScrH() / 2)

        surface.DrawText("Вы " .. name)]] --
        draw.DrawText("It's Only You.", "HomigradFontBig", ScrW() / 2, ScrH() / 2,
            Color(155, 155, 255, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        draw.DrawText("Gravity Gun Gambit (Free for All)", "HomigradFontBig", ScrW() / 2, ScrH() / 8,
            Color(155, 155, 255, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        --draw.DrawText( roundTypes[roundType], "HomigradFontBig", ScrW() / 2, ScrH() / 5, Color( 55,55,155,math.Clamp(startRound,0,1) * 255 ), TEXT_ALIGN_CENTER )

        draw.DrawText("Fight everyone else to the death!", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2,
            Color(55, 55, 55, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        return
    end
end

net.Receive("gravdm die", function()
    timeStartAnyDeath = CurTime()
end)

function gravdm.CanUseSpectateHUD()
    return false
end

gravdm.RoundRandomDefalut = 3
gravdm.NoSelectRandom = true