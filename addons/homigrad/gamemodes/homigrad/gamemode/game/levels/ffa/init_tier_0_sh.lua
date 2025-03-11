--table.insert(LevelList, "ffa")
ffa = {}
ffa.Name = "Free For All"
ffa.LoadScreenTime = 5.5

function ffa.StartRound(data)
    team.SetColor(1, Color(9, 255, 0))  

    game.CleanUpMap(false)

    if CLIENT then
        roundTimeStart = data[1]
        roundTime = data[2]
        ffa.StartRoundCL()  

        return
    end

    return ffa.StartRoundSV()  
end


if SERVER then return end


local white, red = Color(255, 255, 255), Color(255, 0, 0)
local playsound = false

function ffa.StartRoundCL()
    playsound = true
end

function ffa.GetTeamName(ply)
    local teamID = ply:Team()

    if teamID == 1 then return "Fighter", red end
end


local function DrawTopPlayers()
    local players = player.GetAll()

    table.sort(players, function(a, b)
        return a:GetNWInt("KillCount", 0) > b:GetNWInt("KillCount", 0)
    end)

    local topPlayers = {}
    for i = 1, math.min(4, #players) do
        table.insert(topPlayers, players[i])
    end

    local boxWidth, boxHeight = 250, 150
    local boxX, boxY = ScrW() - boxWidth - 20, ScrH() * 0.25  
    draw.RoundedBox(10, boxX, boxY, boxWidth, boxHeight, Color(0, 0, 0, 150))  

    draw.SimpleText("Top Players", "DermaLarge", boxX + boxWidth / 2, boxY + 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

    for i, ply in ipairs(topPlayers) do
        local playerName = ply:Nick()
        local killCount = ply:GetNWInt("KillCount", 0)
        draw.SimpleText(i .. ". " .. playerName .. ": " .. killCount .. " kills", "DermaDefaultBold", boxX + 10, boxY + 10 + i * 30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end
end

function ffa.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()

    local timeLeft = roundTimeStart + roundTime - CurTime()
    local startRound = roundTimeStart + 5 - CurTime()  
    
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")  
        end

        lply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0.5)  

        draw.DrawText("Prepare yourself!", "HomigradRoundFont", ScrW() / 2, ScrH() / 2,
            Color(155, 155, 255, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        draw.DrawText("Free For All Mode (Respawns Allowed)", "HomigradRoundFont", ScrW() / 2, ScrH() / 8,
            Color(155, 155, 255, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        draw.DrawText("Kill everyone to win!", "HomigradRoundFont", ScrW() / 2, ScrH() / 1.2,
            Color(55, 55, 55, math.Clamp(startRound - 0.5, 0, 1) * 255), TEXT_ALIGN_CENTER)
        return
    end

    if timeLeft > 0 then
        draw.DrawText("Time Left: " .. string.ToMinutesSeconds(timeLeft), "HomigradRoundFont", ScrW() / 2, ScrH() / 10, 
            Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
    else
        draw.DrawText("Round Over", "HomigradRoundFont", ScrW() / 2, ScrH() / 10, 
            Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
    end

    DrawTopPlayers()
end

ffa.NoSelectRandom = false