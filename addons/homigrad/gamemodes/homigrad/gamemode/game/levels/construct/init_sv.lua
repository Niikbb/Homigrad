-- Include the player model manager script (adjust the path as necessary)
include("../../playermodelmanager_sv.lua")

construct.ragdolls = {}

local function GetTeamSpawns(ply)
	local spawnsT = tdm.SpawnsTwoCommand()
    if ply:Team() == 1 then
        return spawnsT
    else
        return false
    end
end

function construct.StartRoundSV()
local players = PlayersInGame()
local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()

    tdm.RemoveItems()
	roundTimeStart = CurTime()
    roundTimeRespawn = CurTime() + 15
	roundTime = 604800 -- Seven days in seconds.

    tdm.SpawnCommand(team.GetPlayers(1),spawnsT)

    for i,ply in pairs(players) do ply:SetTeam(1) end
    return {roundTimeStart,roundTime}
end

function construct.Think()
    construct.LastWave = construct.LastWave or CurTime() + 15

    if CurTime() >= construct.LastWave then
        SetGlobalInt("construct_respawntime", CurTime())

        for _, v in player.Iterator() do

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

        for ent in pairs(construct.ragdolls) do
            if IsValid(ent) then ent:Remove() end

            construct.ragdolls[ent] = nil
        end

        construct.LastWave = CurTime() + 10
    end
end

-- Not needed :)
--[[]
function construct.RoundEndCheck()
    if roundTimeStart + roundTime < CurTime() then EndRound() end
end
]]

-- Not needed :)
--[[
function construct.EndRound(winner)
    for i, ply in ipairs( player.GetAll() ) do
	    if ply:Alive() then
            PrintMessage(3,"Раунд окончен.")
        end
    end
end
--]]
local red = Color(255,0,0)

function construct.PlayerSpawn2(ply, teamID)
	ply:SetModel(tdm.models[math.random(#tdm.models)])
	ply:SetPlayerColor(Vector(0, 0, 0.6))
	ply:Give("weapon_physgun")
	ply:Give("weapon_hands")

	-- FIXME: This doesn't seem to work.
	if ply.allowGrab then
		ply.allowGrab = false
	end
end

function construct.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function construct.PlayerCanJoinTeam(ply,teamID)
	if teamID == 2 or teamID == 3 then return false end
    return true
end

function construct.GuiltLogic() return false end

util.AddNetworkString("construct_die")
function construct.PlayerDeath()
    net.Start("construct_die")
    net.Broadcast()
end