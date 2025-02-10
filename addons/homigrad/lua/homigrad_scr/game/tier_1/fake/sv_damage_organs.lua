hook.Add("HomigradDamage", "Organs", function(ply, hitgroup, dmginfo, rag, armorMul, armorDur, haveHelmet)
	local ent = rag or ply
	local inf = dmginfo:GetInflictor()

	if hitgroup == HITGROUP_HEAD then
		if not haveHelmet and dmginfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then
			dmginfo:ScaleDamage(inf.RubberBullets and 0.1 or 1)

			ply.pain = ply.pain + (ply.nopain and 1 or inf.RubberBullets and 100 or 350)

			ply:SetDSP(37)
		end

		if dmginfo:GetDamageType() == DMG_CRUSH and dmginfo:GetDamage() >= 6 and ent:GetVelocity():Length() > 500 then
			net.Start("hg_sendchat_simple")
				net.WriteString("#hg.damage.neck")
			net.Send(ply)

			ent:EmitSound("NPC_Barnacle.BreakNeck", 511, 200, 1, CHAN_ITEM)

			dmginfo:ScaleDamage(5000 * 5)

			return
		end
	end

	if dmginfo:GetDamage() >= 40 or dmginfo:GetDamageType() == DMG_CRUSH and dmginfo:GetDamage() >= 6 and ent:GetVelocity():Length() > 700 then
		local brokenLeftLeg = hitgroup == HITGROUP_LEFTLEG
		local brokenRightLeg = hitgroup == HITGROUP_RIGHTLEG
		local brokenLeftArm = hitgroup == HITGROUP_LEFTARM
		local brokenRightArm = hitgroup == HITGROUP_RIGHTARM
		local sub = dmginfo:GetDamage() / 120 * armorMul

		if brokenLeftArm then
			ply.LeftArm = math.min(0.6, ply.LeftArm - sub)

			if ply.msgLeftArm < CurTime() then
				ply.msgLeftArm = CurTime() + 1

				net.Start("hg_sendchat_simple")
					net.WriteString("#hg.damage.larm")
				net.Send(ply)

				ent:EmitSound("NPC_Barnacle.BreakNeck", 70, 65, 0.4, CHAN_ITEM)
			end
		end

		if brokenRightArm then
			ply.RightArm = math.max(0.6, ply.RightArm - sub)

			if ply.msgRightArm < CurTime() then
				ply.msgRightArm = CurTime() + 1

				net.Start("hg_sendchat_simple")
					net.WriteString("#hg.damage.rarm")
				net.Send(ply)

				ent:EmitSound("NPC_Barnacle.BreakNeck", 70, 65, 0.4, CHAN_ITEM)
			end
		end

		if brokenLeftLeg then
			ply.LeftLeg = math.max(0.6, ply.LeftLeg - sub)

			if ply.msgLeftLeg < CurTime() then
				ply.msgLeftLeg = CurTime() + 1

				net.Start("hg_sendchat_simple")
					net.WriteString("#hg.damage.lleg")
				net.Send(ply)

				ent:EmitSound("NPC_Barnacle.BreakNeck", 70, 65, 0.4, CHAN_ITEM)
			end
		end

		if brokenRightLeg then
			ply.RightLeg = math.max(0.6, ply.RightLeg - sub)

			if ply.msgRightLeg < CurTime() then
				ply.msgRightLeg = CurTime() + 1

				net.Start("hg_sendchat_simple")
					net.WriteString("#hg.damage.rleg")
				net.Send(ply)

				ent:EmitSound("NPC_Barnacle.BreakNeck", 70, 65, 0.4, CHAN_ITEM)
			end
		end
	end

	local penetration = dmginfo:GetDamageForce()

	if dmginfo:IsDamageType(DMG_BULLET + DMG_SLASH) then
		penetration:Mul(0.024)
	else
		penetration:Mul(0.004)
	end

	penetration:Mul(armorMul)

	if not rag or rag and not dmginfo:IsDamageType(DMG_CRUSH) then
		local dmg = dmginfo:GetDamage() * armorMul * 1

		if hitgroup == HITGROUP_HEAD and math.random(1, math.max(math.floor(armorDur), 1)) == 1 and dmginfo:IsDamageType(DMG_BULLET + DMG_SLASH + DMG_CLUB + DMG_GENERIC + DMG_BUCKSHOT) and not haveHelmet then
			timer.Simple(0.01, function()
				local wep = ply:GetActiveWeapon()

				if ply:Alive() and not IsValid(ply.FakeRagdoll) and not ply.nopain and IsValid(wep) and not (wep.GetBlocking and wep:GetBlocking()) then Faking(ply) end
			end)
		end

		local dmgpos = dmginfo:GetDamagePosition() -- penetration:GetNormalized() * 0.5
		local pos, ang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Spine2"))
		local raycast = util.IntersectRayWithOBB(dmgpos, penetration, pos, ang, Vector(1, 0, -1), Vector(5, 4, 3))

		if raycast and ply.organs["heart"] ~= 0 and not dmginfo:IsDamageType(DMG_CLUB) and ply.organs["heart"] == 0 and ply:IsPlayer() then
			ply.organs["heart"] = math.max(ply.organs["heart"] - dmg, 0)

			net.Start("hg_sendchat_simple")
				net.WriteString("#hg.damage.heart")
			net.Send(ply)
		end

		if dmginfo:IsDamageType(DMG_BULLET + DMG_SLASH + DMG_BLAST + DMG_ENERGYBEAM + DMG_NEVERGIB + DMG_ALWAYSGIB + DMG_PLASMA + DMG_AIRBOAT + DMG_SNIPER + DMG_BUCKSHOT) then --and ent:LookupBone(bonename)==2 then
			local pos, ang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
			local raycast = util.IntersectRayWithOBB(dmgpos, penetration, pos, ang, Vector(-3, -2, -2), Vector(0, -1, -1))
			local raycast2 = util.IntersectRayWithOBB(dmgpos, penetration, pos, ang, Vector(-3, -2, 1), Vector(0, -1, 2))

			if (raycast or raycast2) and ply.organs.artery ~= 0 and not dmginfo:IsDamageType(DMG_CLUB) and ply.organs["heart"] == 0 and ply:IsPlayer() then
				ply.organs.artery = math.max(ply.organs.artery - dmg, 0)

				net.Start("hg_sendchat_simple")
					net.WriteTable("#hg.damage.artery")
				net.Send(ply)
			end
		end

		local matrix = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Spine4"))
		local ang = matrix:GetAngles()
		local pos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Spine4"))
		local raycast = util.IntersectRayWithOBB(dmgpos, penetration, pos, ang, Vector(-8, -1, -1), Vector(2, 0, 1))

		local matrix = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Spine1"))
		local ang = matrix:GetAngles()
		local pos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Spine1"))
		local raycast2 = util.IntersectRayWithOBB(dmgpos, penetration, pos, ang, Vector(-8, -3, -1), Vector(2, -2, 1))

		if (raycast or raycast2) and ply.organs["spine"] ~= 0 and ply.organs["spine"] == 0 and ply:IsPlayer() then
			ply.organs["spine"] = math.Clamp(ply.organs["spine"] - dmg, 0, 1)

			timer.Simple(0.01, function() if not IsValid(ply.FakeRagdoll) then Faking(ply) end end)

			ply.brokenspine = true

			net.Start("hg_sendchat_simple")
				net.WriteString("#hg.damage.spine")
			net.Send(ply)

			ent:EmitSound("NPC_Barnacle.BreakNeck", 70, 125, 0.7, CHAN_ITEM)
		end
	end
end)

hook.Add("HomigradDamage", "BurnDamage", function(ply, hitgroup, dmginfo) if dmginfo:IsDamageType(DMG_BURN) then dmginfo:ScaleDamage(5) end end)