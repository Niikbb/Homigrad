function igib.StartRoundSV()
    tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 300

    local players = PlayersInGame()
    for i,ply in pairs(players) do ply:SetTeam(1) end

    local aviable = ReadDataMap("dm")
    aviable = #aviable ~= 0 and aviable or homicide.Spawns()
    tdm.SpawnCommand(team.GetPlayers(1),aviable,function(ply)
        ply:Freeze(true)
    end)
    freezing = true

    RTV_CountRound = RTV_CountRound - 1
    roundTimeRespawn = CurTime() + 15

    return {roundTimeStart,roundTime}
end

function cp.Think()
    cp.LastWave = cp.LastWave or CurTime() + 15

    if CurTime() >= cp.LastWave then
        SetGlobalInt("igib_respawntime", CurTime())
    
        for _, v in pairs(player.GetAll()) do
            local players = {}
            if !v:Alive() and v:Team() != 1002 then
                v:Spawn()
                local teamspawn = GetTeamSpawns(v)
    
                local point,key = table.Random(teamspawn)
                point = ReadPoint(point)
                if not point then continue end
    
                v:SetPos(point[1])
                players[v:Team()] = players[v:Team()] or {}
                players[v:Team()][v] = true
            end
        end
    
        for ent in pairs(cp.ragdolls) do
            if IsValid(ent) then ent:Remove() end
    
            cp.ragdolls[ent] = nil
        end

        cp.LastWave = CurTime() + 15
    end
end


function igib.RoundEndCheck()
    if roundTimeStart + roundTime < CurTime() then EndRound() end
end

function igib.EndRound(winner)
    for i, ply in ipairs( player.GetAll() ) do
	    if ply:Alive() then
            PrintMessage(3,"Раунд окончен.")
        end
    end
end

local red = Color(255,0,0)

function igib.PlayerSpawn(ply,teamID)
	ply:SetModel(tdm.models[math.random(#tdm.models)])
    ply:SetPlayerColor(Vector(0,0,0.6))
    ply:Give("weapon_igib")
    ply:SetLadderClimbSpeed(100)
    ply:SetWalkSpeed(350)
    ply:SetRunSpeed(500)
end

function igib.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function igib.PlayerCanJoinTeam(ply,teamID)
	if teamID == 2 or teamID == 3 then return false end
    return true
end

function igib.GuiltLogic() return false end

util.AddNetworkString("dm die")
function igib.PlayerDeath()
    net.Start("dm die")
    net.Broadcast()
end