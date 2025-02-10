util.AddNetworkString("info_adrenaline")
util.AddNetworkString("info_staminamul")

hook.Add("Move", "move.speed", function(ply, movedata) if ply:Alive() then ply.speeed = movedata:GetVelocity():Length() end end)
hook.Add("PlayerPostThink", "homigrad-player-thinker", function(ply) hook.Run("Player Think", ply, CurTime()) end)
hook.Add("PlayerInitialSpawn", "homigrad-addcallback", function(ply) ply:AddCallback("PhysicsCollide", function(phys, data) hook.Run("Player Collide", ply, data.HitEntity, data) end) end)

hook.Add("PlayerSpawn", "homigrad-stamina", function(ply)
	if PLYSPAWN_OVERRIDE then return end

	ply.stamina = 100
	ply.staminaNext = 0
	ply.adrenaline = 0
	ply.adrenalineNeed = 0
end)

hook.Add("Player Think", "saystamina", function(ply, time)
	if ply:HasGodMode() or not ply:Alive() or (ply.staminaNext or time) > time then return end

	ply.staminaNext = time + 1
	ply.adrenaline = math.max(ply.adrenaline - 0.05, 0)

	local ent = IsValid(ply.FakeRagdoll) and IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply

	if ply.stamina < 60 and ply:WaterLevel() <= 2 and not ply.heartstop then ent:EmitSound("snds_jack_hmcd_breathing/m" .. math.random(1, 6) .. ".wav", 60, 100, 0.6, CHAN_AUTO) end

	if ply.stamina < 100 and not ply:IsSprinting() and ply:WaterLevel() <= 2 then
		ply.stamina = ply.stamina + 3 + ply.hungryregen / 2
		ply:SetNWInt("stamina", ply.stamina)
	end

	if ply:GetMoveType() == MOVETYPE_WALK and ply:IsSprinting() and ply.speeed > 1 then ply.stamina = ply.stamina - ply.speeed / 150 end
	if ply:WaterLevel() == 3 then ply.stamina = ply.stamina - 2 end

	if ply.stamina < 20 and ent:WaterLevel() == 3 then
		ply.o2 = math.max((ply.o2 or 1) - 0.2, -3)

		if not ply.unconscious then ent:EmitSound("Player.DrownContinue", 40, 100, 0.6, CHAN_AUTO) end
	end

	ply.stamina = math.Clamp(ply.stamina, 0, 100)

	net.Start("info_adrenaline")
		net.WriteFloat(ply.adrenaline)
	net.Send(ply)

	local k = math.Clamp(ply.stamina / 100, 0, 1) * 0.6
	k = k + ply.adrenaline / 4
	k = math.Clamp(k, 0, 1) * (ply.painlosing > 1 and 1 or ply.LeftLeg) * (ply.painlosing > 1 and 1 or ply.RightLeg) * math.max(ply:Health() / 150, 0.2)

	net.Start("info_staminamul")
		net.WriteFloat(k)
	net.Send(ply)

	ply.staminamul = k
end)

hook.Add("PlayerFootstep", "CustomFootstep1", function(ply, pos, foot)
	if ply:IsSprinting() then
		if foot == 0 and ply.LeftLeg < 1 then
			ply.pain = ply.pain + 25

			if ply.firstTimeNotifiedLeftLeg then
				net.Start("hg_sendchat_simple")
					net.WriteString("#hg.stamina.leftbroken")
				net.Send(ply)

				ply.firstTimeNotifiedLeftLeg = false
			end
		elseif foot == 1 and ply.RightLeg < 1 then
			ply.pain = ply.pain + 25

			if ply.firstTimeNotifiedRightLeg then
				net.Start("hg_sendchat_simple")
					net.WriteString("#hg.stamina.rightbroken")
				net.Send(ply)

				ply.firstTimeNotifiedRightLeg = false
			end
		end
	end
end)