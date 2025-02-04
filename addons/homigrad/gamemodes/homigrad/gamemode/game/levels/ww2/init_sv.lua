ww2.ragdolls = {}

function ww2.SpawnsTwoCommand()
	local spawnsT = ReadDataMap("spawnpointst")
	local spawnsCT = ReadDataMap("spawnpointsct")

	if #spawnsT == 0 then
		for i, ent in RandomPairs(ents.FindByClass("info_player_terrorist")) do
			table.insert(spawnsT,ent:GetPos())
		end
	end

	if #spawnsCT == 0 then
		for i, ent in RandomPairs(ents.FindByClass("info_player_counterterrorist")) do
			table.insert(spawnsCT,ent:GetPos())
		end
	end

	return spawnsT,spawnsCT
end

local function GetTeamSpawns(ply)
	local spawnsT,spawnsCT = ww2.SpawnsTwoCommand()

    if ply:Team() == 1 then
        return spawnsT
    elseif ply:Team() == 2 then
        return spawnsCT
    else
        return false
    end
end

function ww2.SelectRandomPlayers(list,div,func)
	for i = 1,math.floor(#list / div) do
		local ply,key = table.Random(list)
		table.remove(list,key)

		func(ply)
	end
end

function ww2.SpawnSimfphys(list,name,func)
	for i,point in pairs(list) do
		local ent = simfphys.SpawnVehicleSimple(name,point[1],point[2])
		if func then func(ent) end
	end
end

function ww2.SpawnVehicle()
    ww2.SpawnEnt(ReadDataMap("car_red"),"sim_fphys_pwvolga")
    ww2.SpawnEnt(ReadDataMap("car_blue"),"lvs_wheeldrive_bmw_r75")
	ww2.SpawnEnt(ReadDataMap("car_red_btr"),"lvs_wheeldrive_dodwillyjeep")
    ww2.SpawnEnt(ReadDataMap("car_blue_btr"),"lvs_wheeldrive_dodwillyjeep")
    ww2.SpawnEnt(ReadDataMap("car_red_tank"),"lvs_wheeldrive_t34")
    ww2.SpawnEnt(ReadDataMap("car_blue_tank"),"lvs_wheeldrive_dodtiger")
end

function ww2.SpawnEnt(list,name,func)
    for i,point in pairs(list) do
		local ent = ents.Create(name)
		ent:SetPos(point[1])
		ent:SetAngles(point[2])
		ent:Spawn()
	end
end

function ww2.SpawnGred()
	ww2.SpawnEnt(ReadDataMap("gred_emp_breda35"),"gred_emp_breda35")
    ww2.SpawnEnt(ReadDataMap("gred_emp_dshk"),"gred_emp_rpk")
    ww2.SpawnEnt(ReadDataMap("gred_ammobox"),"gred_ammobox")
    ww2.SpawnEnt(ReadDataMap("gred_emp_2a65"),"gred_emp_2a65")
	ww2.SpawnEnt(ReadDataMap("gred_emp_pak40"),"gred_emp_pak40")
end

function ww2.StartRoundSV()
	tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 900

	tdm.DirectOtherTeam(3,1,2)

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	ww2.SpawnVehicle()
	ww2.SpawnGred()

	ww2.oi = false
end

function ww2.Think()
    ww2.LastWave = ww2.LastWave or CurTime() + 60

    if CurTime() >= ww2.LastWave then
        SetGlobalInt("ww2_respawntime", CurTime())
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
        for ent in pairs(ww2.ragdolls) do
            if IsValid(ent) then ent:Remove() end
            ww2.ragdolls[ent] = nil
        end
        ww2.LastWave = CurTime() + 60
    end
end

function ww2.GetCountLive(list,func)
	local count = 0
	local result

	for i,ply in pairs(list) do
		if not IsValid(ply) then continue end

		result = func and func(ply)
		if result == true then count = count + 1 continue elseif result == false then continue end
		if not PlayerIsCuffs(ply) and ply:Alive() then count = count + 1 end
	end

	return count
end

function ww2.PointsThink()
    local ww2_points = ww2.points
    for i, point in pairs(SpawnPointsList.controlpoint[3]) do
        local v = ww2_points[i]
        if not v then
            v = {}
            ww2_points[i] = v
        end

        v[1] = point[1]

        v.RedAmount = 0
        v.BlueAmount = 0

        for _, v2 in pairs(ents.FindInSphere(v[1], 256)) do
            if !v2:IsPlayer() or !v2:Alive() or v2.Otrub then continue end

            if v2:Team() == 1 then
                v.RedAmount = v.RedAmount + 1
            elseif v2:Team() == 2 then
                v.BlueAmount = v.BlueAmount + 1
            end
        end

        if v.RedAmount > v.BlueAmount then
            v.CaptureProgress = math.Clamp((v.CaptureProgress or 0) + 10, -100, 100)
        elseif v.BlueAmount > v.RedAmount then
            v.CaptureProgress = math.Clamp((v.CaptureProgress or 0) - 10, -100, 100)
        end

        if v.CaptureProgress == 100 then
            v.CaptureTeam = 1
        elseif v.CaptureProgress == -100 then
            v.CaptureTeam = 2
        elseif v.CaptureProgress == 0 then
            v.CaptureTeam = 0
        end

        if v.CaptureTeam and v.CaptureTeam != 0 then
            ww2.WinPoints[v.CaptureTeam] = ww2.WinPoints[v.CaptureTeam] + 3 / #SpawnPointsList.controlpoint[3]
        end

        SetGlobalInt(i .. "PointProgress", v.CaptureProgress)
        SetGlobalInt(i .. "PointCapture", v.CaptureTeam)
    end

    for i = 1, 2 do
        SetGlobalInt("ww2_Winpoints" .. i, ww2.WinPoints[i])
    end
end

function ww2.RoundEndCheck()
    for i = 1, 2 do
        if ww2.WinPoints[i] >= 1000 then
            EndRound(i)
        end
    end
    if roundTimeStart + roundTime < CurTime() then 
        EndRound() 
    end
end

function ww2.EndRoundMessage(winner,textNobody)
	local tbl = TableRound()
	if winner == 1 and tbl.red[1] then
	PrintMessage(3,"Красная Армия отстояла свою территорию.")
	elseif winner == 2 and tbl.blue[1] then
	PrintMessage(3,"Вермахт успешно окопался на данных территориях.")
	else
	PrintMessage(3,"Вермахт уплыл. Красноармейцы засели в окопах.")
	end
end

function ww2.EndRound(winner) 
    print("End round, win '" .. tostring(winner) .. "'")
    ww2.EndRoundMessage(winner)
    timer.Remove("ww2_NewWave")
    timer.Remove("ww2_ThinkAboutPoints") 
end

function ww2.PlayerInitialSpawn(ply) ply:SetTeam(math.random(1,2)) end

function ww2.PlayerSpawn(ply,teamID)
	local teamTbl = ww2[ww2.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])

	if teamID == 1 then
		ply:SetBodygroup(0,math.random(1,4))
	end
	if teamID == 2 then
        ply:SetBodygroup(0,3)
		ply:SetBodygroup(1,math.random(1,6))
        ply:SetBodygroup(2,math.random(1,2))
        ply:SetBodygroup(3,math.random(1,2))
        ply:SetBodygroup(4,math.random(1,2))
        ply:SetBodygroup(5,math.random(1,2))
        ply:SetBodygroup(6,math.random(1,2))
        ply:SetBodygroup(7,math.random(1,2))
        ply:SetBodygroup(8,math.random(1,2))
        ply:SetBodygroup(9,math.random(1,4))
	end
    ply:SetPlayerColor(color:ToVector())
	for i,weapon in pairs(teamTbl.weapons) do 
        ply:Give(weapon) 
    end
	tdm.GiveSwep(ply,teamTbl.main_weapon)
	JMod.EZ_Equip_Armor(ply,"Medium-Helmet",color)

	if roundStarter then
		ply.allowFlashlights = true
	end
end

function ww2.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("Не в этом режиме.") return false end
end
function ww2.PlayerDeath(ply,inf,att)
    ww2.ragdolls[ply:GetNWEntity("Ragdoll")] = true
    return false
end

function ww2.ShouldSpawnLoot() return false end
function ww2.NoSelectRandom() return false end