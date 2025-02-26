table.insert(LevelList, "igib")
igib = igib or {}
igib.Name = "hg.igib.name"
igib.NoSelectRandom = true
igib.RoundRandomDefalut = 3
function igib.GetTeamName(ply)
    if ply:Team() == 1 then return "#hg.igib.team", Color(155, 155, 255) end
end

function igib.StartRound(data)
    team.SetColor(1, Color(155, 155, 255))
    game.CleanUpMap(false)
    if CLIENT then
        roundTimeStart = data[1]
        roundTime = data[2]
        igib.StartRoundCL()
        return
    end
    return igib.StartRoundSV()
end

if SERVER then return end

local playsound = false
function igib.StartRoundCL()
    playsound = true
end

function igib.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
    local startRound = roundTimeStart + 5 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            print("Station check.")
            sound.PlayURL("https://www.dropbox.com/scl/fi/2ajddo3n45q4bufqwrlmx/egor_letov_ubivat.mp3?rlkey=xf8iz1vhg2fiachxl80uv4n21&st=6zlx1may&dl=1", "", function(station)
                if IsValid(station) then
                    print("Station is Valid")
                    station:SetPos(LocalPlayer():GetPos())
                    station:Play()
                    station:SetVolume(.7)
                    g_station = station
                end
            end)

            lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 220), startRound, startRound)
        end

        draw.DrawText("#hg.igib.name", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color(155, 155, 255, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)
        draw.DrawText("#hg.igib.desc2", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color(55, 55, 55, math.Clamp(startRound, 0, 1) * 255), TEXT_ALIGN_CENTER)
        return
    end
end

net.Receive("dm die", function() timeStartAnyDeath = CurTime() end)
function igib.CanUseSpectateHUD()
    return false
end