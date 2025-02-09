function hl2dm.StartRoundSV()
	tdm.RemoveItems()
	roundTimeStart = CurTime()
	roundTime = 60 * (2 + math.min(#player.GetAll() / 8, 2))
	tdm.DirectOtherTeam(3, 1, 2)
	OpposingAllTeam()
	AutoBalanceTwoTeam()
	local spawnsT, spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1), spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2), spawnsCT)
	tdm.CenterInit()
end

function hl2dm.RoundEndCheck()
	if roundTimeStart + roundTime - CurTime() <= 0 then EndRound() end
	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive = tdm.GetCountLive(team.GetPlayers(2))
	if TAlive == 0 and CTAlive == 0 then
		EndRound()
		return
	end

	if TAlive == 0 then EndRound(2) end
	if CTAlive == 0 then EndRound(1) end
	tdm.Center()
end

function hl2dm.EndRound(winner)
	tdm.EndRoundMessage(winner)
end

function hl2dm.PlayerInitialSpawn(ply)
	ply:SetTeam(math.random(1, 2))
end

function hl2dm.PlayerSpawn(ply, teamID)
	local teamTbl = hl2dm[hl2dm.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
	ply:SetPlayerColor(color:ToVector())
	for i, weapon in pairs(teamTbl.weapons) do
		ply:Give(weapon)
	end

	if teamID == 2 then
		local r = math.random(1,3)
		ply:SetPlayerClass("combine")
		ply:Give("weapon_hk_usp")
		ply:SetAmmo(90, (r == 1 and "ar2") or (r == 2 and "12/70 gauge") or (r == 3 and "4.6×30 mm"))
		ply:SetAmmo(90, "9x19mm Parabellum")
		ply:Give((r == 1 and "weapon_sar2") or (r == 2 and "weapon_spas12") or (r == 3 and "weapon_mp7"))
		if r == 1 then
			ply:Give("weapon_hg_hl2")
			JMod.EZ_Equip_Armor(ply, "Super-Soldier-Suit", Color(255, 255, 255, 255))
			ply:SetModel("models/player/combine_super_soldier.mdl")
		elseif r == 2 then
			JMod.EZ_Equip_Armor(ply, "Shotgunner Suit", Color(255, 255, 255, 255))
			ply:SetModel("models/player/combine_soldier_prisonguard.mdl")
		elseif r == 3 then
			JMod.EZ_Equip_Armor(ply, "Soldier Suit", Color(255, 255, 255, 255))
			ply:SetModel("models/player/combine_soldier.mdl")
		end
	end

	if teamID == 1 then
		tdm.GiveSwep(ply, teamTbl.main_weapon)
		tdm.GiveSwep(ply, teamTbl.secondary_weapon)
		if math.random(1, 3) == 3 then ply:Give("adrinaline") end
		if math.random(1, 3) == 3 then ply:Give("morphine") end
		if math.random(1, 4) == 4 then ply:Give("weapon_hg_hl2") end
		JMod.EZ_Equip_Armor(ply, "Ballistic-Mask-Kolhoz-Edition", color)
		JMod.EZ_Equip_Armor(ply, "Medium-Helmet", color)
		JMod.EZ_Equip_Armor(ply, "Light-Vest", Color(0, 0, 0, 0))
	end
end

function hl2dm.PlayerCanJoinTeam(ply, teamID)
	if teamID == 3 then
		ply:ChatPrint("Иди нахуй")
		return false
	end
end

function hl2dm.ShouldSpawnLoot()
	return false
end

function hl2dm.PlayerDeath(ply, inf, att)
	return false
end