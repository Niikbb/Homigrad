CameraSetFOV = 120

local hg_cool_camera = CreateClientConVar("hg_cool_camera", "1", true, false, "epic camera", 0, 1)
CreateClientConVar("hg_fov", "120", true, false, nil, 70, 120)
CreateClientConVar("hg_smooth_cam", "1", true, false, nil, 0, 1)
CreateClientConVar("hg_bodycam", "0", true, false, nil, 0, 1)
CreateClientConVar("hg_fakecam_mode", "0", true, false, nil, 0, 1)
CreateClientConVar("hg_deathsound", "1", true, false, nil, 0, 1)
CreateClientConVar("hg_deathscreen", "1", true, false, nil, 0, 1)

function SETFOV(value)
	CameraSetFOV = value or GetConVar("hg_fov"):GetInt()
end

SETFOV()

cvars.AddChangeCallback("hg_fov", function(cmd, _, value)
	timer.Simple(0, function()
		SETFOV()

		-- print("[HG] Changed FOV: " .. value)
	end)
end)

surface.CreateFont("HomigradFontBig", {
	font = "Roboto",
	size = 25,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("BodyCamFont", {
	font = "Arial",
	size = 40,
	weight = 1100,
	outline = false,
	shadow = true
})

local view = {
	x = 0,
	y = 0,
	drawhud = true,
	drawviewmodel = false,
	dopostprocess = true,
	drawmonitors = true
}

local render_Clear = render.Clear
local render_RenderView = render.RenderView
local HasFocus = system.HasFocus
local oldFocus
local text

CreateClientConVar("hg_disable_stoprenderunfocus", "0", true)

local funnyText = {"afk?", "no", "hg_disable_stoprenderunfocus 1", "stop it", "kys"}
local CalcView -- huh
local vel = 0
local diffang = Vector(0, 0, 0)
local diffpos = Vector(0, 0, 0)
diffang2 = Angle(0, 0, 0)

hook.Add("RenderScene", "homigrad_mainrenderscene", function(pos, angle, fov)
	local focus = HasFocus()

	if focus ~= oldFocus then
		oldFocus = focus

		if not focus then text = funnyText[math.random(#funnyText)] end
	end

	hook.Run("Frame", pos, angle)

	STOPRENDER = false -- not hg_disable_stoprenderunfocus:GetBool() and not developer:GetBool() and not focus

	if STOPRENDER then
		cam.Start2D()
			draw.SimpleText(text, "DebugFixedSmall", ScrW() / 2, ScrH() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End2D()

		return true
	end

	RENDERSCENE = true

	local _view = CalcView(LocalPlayer(), pos, angle, fov)
	if not _view then
		RENDERSCENE = nil

		return
	end

	view.fov = fov
	view.origin = _view.origin
	view.angles = _view.angles
	view.znear = _view.znear
	view.drawviewmodel = _view.drawviewmodel

	if CAMERA_ZFAR then
		view.zfar = CAMERA_ZFAR + 250 -- cl_fog in homigrad gamemode
	else
		view.zfar = nil
	end

	render_Clear(0, 0, 0, 255, true, true, true)
	render_RenderView(view)

	RENDERSCENE = nil

	return true
end)

local whitelistweps = {
	["weapon_physgun"] = true,
	["weapon_gravgun"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["drgbase_possessor"] = true,
}

function RagdollOwner(rag)
	if not IsValid(rag) then return end

	local ply = rag:GetNWEntity("RagdollController")

	return IsValid(ply) and ply
end

--[[
hook.Add("Think", "pophead", function()
	for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
		if not IsValid(RagdollOwner(ent)) or not RagdollOwner(ent):Alive() then ent:ManipulateBoneScale(6, Vector(1, 1, 1)) end
	end
end) --]]

local angZero = Angle(0, 0, 0)
local playing = false
local deathtracks = {
	-- format: multiline
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144224389970272388/death1.mp3",
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144226357967065180/death2.mp3",
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144230250465734797/death3.mp3",
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144238942862979142/death4.mp3",
}
local deathtexts = {
	-- format: multiline
	"gone, gone",
	"all clyde, no bonnie",
	"burned out",
	"wasted",
	"bye bye!",
	"game over",
	"and over again",
	"fucked up",
	"hahahaha",
	"be free",
	"times up",
	"in the red",
	"riddled",
	"riddle me this batman",
	"whacked",
	"put on mute",
	"this is how you died",
	"so bad, so sad!",
	"cry more, in hell",
	"no more chances",
	"choker",
	"in another castle",
	"if you cant see",
	"here's a lil something",
	"i am ready",
	"let me try this shit",
	"evil",
	"dead",
	"only gone and done it",
	"routines in the night",
	"homigrad'ed",
	"iced",
	"hurts me more than you",
	"taking it like a champ",
	"would you look at that",
	"try again",
	"cука блять",
	"поздравляю",
	"вмер",
	"здох як лох",
	"якого біса",
	"срака репнула"
}

--[[
gameevent.Listen("entity_killed")
hook.Add("entity_killed", "killedplayer", function(data)
	local ent = Entity(data.entindex_killed)
	if ent:IsPlayer() then
		hook.Run("Player Death",ent)
	end
end) --]]

local oldrag

hook.Add("Player Death", "hgPlayerDeath2", function(ent)
	if ent ~= LocalPlayer() then return end

	if GetConVar("hg_deathscreen"):GetBool() then
		deathrag = ent:GetNWEntity("Ragdoll", oldrag)
		deathtext = string.upper(deathtexts[math.random(#deathtexts)])

		-- TODO: Fix issue where, upon dying and immediately respawning, screen still fades to black
		LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 1)

		if not playing and GetConVar("hg_deathsound"):GetBool() then
			playing = true

			sound.PlayURL(deathtracks[math.random(#deathtracks)], "mono", function(station)
				if IsValid(station) then
					station:SetPos(LocalPlayer():GetPos())
					station:Play()
					station:SetVolume(3)

					g_station = station
				end
			end)
		end

		timer.Create("DeathCam", 5, 1, function()
			LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 1)

			playing = false
		end)
	end

	timer.Simple(4, function()
		if GetConVar("hg_deathscreen"):GetBool() then LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 0.2, 1) end
		if IsValid(deathrag) then deathrag:ManipulateBoneScale(deathrag:LookupBone("ValveBiped.Bip01_Head1"), Vector(1, 1, 1)) end
	end)
end)

local ScopeLerp = 0
local scope
local firstPerson
local LerpEyeRagdoll = Angle(0, 0, 0)
-- local LerpEye = IsValid(LocalPlayer()) and LocalPlayer():EyeAngles() or Angle(0, 0, 0)

local vecZero, vecFull = Vector(0, 0, 0), Vector(1, 1, 1)
local startRecoil = 0
local angRecoil = Angle(0, 0, 0)
local recoil = 0
local sprint = 0
local oldview = {}
local view = {}

ADDFOV = 0
ADDROLL = 0
follow = follow or NULL

local helmEnt

net.Receive("nodraw_helmet", function() helmEnt = net.ReadEntity() end)

local oldangles = Angle(0, 0, 0)

function CalcView(ply, vec, ang, fov, znear, zfar)
	if STOPRENDER then return end

	local fov = CameraSetFOV + ADDFOV
	local lply = LocalPlayer()

	if not ply:Alive() and timer.Exists("DeathCam") and IsValid(deathrag) then
		-- deathrag:ManipulateBoneScale(6, vecZero)

		local att = deathrag:GetAttachment(deathrag:LookupAttachment("eyes"))
		LerpEyeRagdoll = LerpAngleFT(0.08, LerpEyeRagdoll, att.Ang)
		LerpEyeRagdoll[3] = LerpEyeRagdoll[3] + ADDROLL

		local view = {
			origin = att.Pos,
			angles = LerpEyeRagdoll,
			fov = fov,
			drawviewer = true
		}

		return view
	end

	DRAWMODEL = nil
	ADDFOV = 0
	ADDROLL = 0

	hook.Run("CalcAddFOV", ply)

	local result = hook.Run("PreCalcView", ply, vec, ang, fov, znear, zfar)

	if result ~= nil then
		result.fov = fov + ADDFOV
		result.angles[3] = result.angles[3] + ADDROLL
		return result
	end

	--[[
	if lply:InVehicle() then
		local diffvel = lply:GetVehicle():GetPos() - vel
		local view = {
			origin = lply:EyePos() + diffvel * 10,
			angles = lply:EyeAngles(),
			fov = fov
		}

		vel = lply:GetVehicle():GetPos()

		return view
	end --]]

	firstPerson = GetViewEntity() == lply

	local bone = lply:LookupBone("ValveBiped.Bip01_Head1")
	if bone then lply:ManipulateBoneScale(bone, firstPerson and vecZero or vecFull) end

	if not firstPerson then
		DRAWMODEL = true

		return
	end

	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
	local body = ply:LookupBone("ValveBiped.Bip01_Spine2")
	local tr = hg.eyeTrace(lply)

	if GetConVar("hg_bodycam"):GetInt() == 0 then
		angEye = lply:EyeAngles()
		vecEye = tr.StartPos or lply:EyePos()
	else
		local matrix = ply:GetBoneMatrix(body)
		local bodypos = matrix:GetTranslation()
		local bodyang = matrix:GetAngles()
		-- bodyang:RotateAroundAxis(bodyang:Right(), 90)
		-- bodyang[2] = eye.Ang[2]
		-- bodyang[3] = 0

		angEye = eye.Ang -- bodyang
		vecEye = eye and bodypos + bodyang:Up() * 0 + bodyang:Forward() * 14 + bodyang:Right() * -6 or lply:EyePos()
	end

	local ragdoll = ply:GetNWEntity("Ragdoll")
	follow = ragdoll

	if ply:Alive() and IsValid(ragdoll) then
		ragdoll:ManipulateBoneScale(ragdoll:LookupBone("ValveBiped.Bip01_Head1"), vecZero)

		local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))
		local eyeAngs = lply:EyeAngles()

		if GetConVar("hg_bodycam"):GetInt() == 1 then
			local matrix = ragdoll:GetBoneMatrix(body)
			local bodypos = matrix:GetTranslation()
			local bodyang = matrix:GetAngles()

			eyeAngs = att.Ang

			att.Pos = eye and bodypos + bodyang:Up() * 0 + bodyang:Forward() * 10 + bodyang:Right() * -8 or lply:EyePos()
		end

		local anghook = GetConVar("hg_fakecam_mode"):GetFloat()

		LerpEyeRagdoll = LerpAngleFT(0.08, LerpEyeRagdoll, LerpAngle(anghook, eyeAngs, att.Ang))
		LerpEyeRagdoll[3] = LerpEyeRagdoll[3] + ADDROLL

		local view = {
			origin = att.Pos,
			angles = LerpEyeRagdoll,
			fov = fov,
			drawviewer = true
		}

		if IsValid(helmEnt) then helmEnt:SetNoDraw(true) end

		return view
	end

	local wep = lply:GetActiveWeapon()

	view.fov = fov

	if lply:InVehicle() or not firstPerson then return end

	if not lply:Alive() or IsValid(wep) and whitelistweps[wep:GetClass()] or lply:GetMoveType() == MOVETYPE_NOCLIP then
		view.origin = ply:EyePos()
		view.angles = ply:EyeAngles()
		view.drawviewer = false

		return view
	end

	local output_ang = angEye + angRecoil
	local output_pos = vecEye

	if wep and wep.Camera then output_pos, output_ang, fov = wep:Camera(ply, output_pos, output_ang, fov) end

	view.fov = fov

	if wep and hand then
		local posRecoil = Vector(recoil * 8, 0, recoil * 1.5)
		posRecoil:Rotate(hand.Ang)

		view.znear = Lerp(ScopeLerp, 1, math.max(1 - recoil, 0.2))
		output_pos = output_pos + posRecoil

		if not RENDERSCENE then recoil = LerpFT(scope and (wep.CLR_Scope or 0.25) or wep.CLR or 0.1, recoil, 0) end
	else
		recoil = 0
	end

	vec = Vector(vec[1], vec[2], eye and eye.Pos[3] or vec[3])
	vel = math.max(math.Round(Lerp(0.1, vel, lply:GetVelocity():Length())) - 1, 0)

	sprint = LerpFT(0.1, sprint, -math.abs(math.sin(CurTime() * 6)) * vel / 400)

	output_ang[1] = output_ang[1] + sprint
	output_ang[3] = 0

	local anim_pos = math.max(startRecoil - CurTime(), 0) * 5
	local tick = 1 / engine.AbsoluteFrameTime()

	playerFPS = math.Round(Lerp(0.1, playerFPS or tick, tick))

	local val = math.min(math.Round(playerFPS / 120, 1), 1)

	diffpos = LerpFT(0.1, diffpos, (output_pos - (oldview.origin or output_pos)) / 6)
	diffang = LerpFT(0.1, diffang, (output_ang:Forward() - (oldview.angles or output_ang):Forward()) * 50 + (lply:EyeAngles() + (lply:GetActiveWeapon().eyeSpray or angZero) * 1000):Forward() * anim_pos * 1)

	local _, lang = WorldToLocal(vector_origin, lply:EyeAngles(), vector_origin, oldangles or lply:EyeAngles())

	oldangles = lply:EyeAngles()
	diffang2 = LerpFT(0.05, diffang2, lang * val)

	if RENDERSCENE then
		if hg_cool_camera:GetBool() then output_ang[3] = output_ang[3] + math.min(diffang:Dot(output_ang:Right()) * 3 * val, 10) end
		if hg_cool_camera:GetBool() then output_ang[3] = output_ang[3] + math.min(diffpos:Dot(output_ang:Right()) * 25 * val, 10) end
	end

	if diffang then output_pos:Add((diffang * 1.5 + diffpos) * val) end

	local size = Vector(6, 6, 0)
	local tr = {}
	tr.start = vec
	tr.endpos = output_pos
	tr.mins = -size
	tr.maxs = size
	tr.filter = ply
	local trZNear = util.TraceHull(tr)

	size = size / 2
	tr.mins = -size
	tr.maxs = size
	tr = util.TraceHull(tr)

	local pos = lply:GetPos()
	pos[3] = tr.HitPos[3] + 1 -- wtf is this bullshit

	local trace = util.TraceLine({
		start = lply:EyePos(),
		endpos = pos,
		filter = ply,
		mask = MASK_SOLID_BRUSHONLY
	})

	tr.HitPos[3] = trace.HitPos[3] - 1

	output_pos = tr.HitPos
	output_pos = output_pos

	if trZNear.Hit then
		view.znear = 0.1
	else
		view.znear = 1
	end

	output_ang[3] = output_ang[3] + ADDROLL

	view.origin = output_pos
	view.angles = output_ang
	view.drawviewer = true

	oldview = table.Copy(view)

	DRAWMODEL = true

	return view
end

hook.Add("CalcView", "hgCalcVie", CalcView)

hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true,
}

hook.Add("HUDShouldDraw", "HideHUD", function(name) if hide[name] then return false end end)

--[[ Scopes (don't use)
hook.Add("PostDrawOpaqueRenderables", "example", function()
	local hand = LocalPlayer():GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local eye = LocalPlayer():GetAttachment(ply:LookupAttachment("eyes"))
	possight = hand.Pos + hand.Ang:Up() * 4.4 - hand.Ang:Forward() * -1 + hand.Ang:Right() * -0.15
	angle = hand.Ang + Angle(-90, 0, 0)

	cam.Start3D2D(possight, angle, 1)
		surface.SetDrawColor(255, 0, 0, 200)
		draw.NoTexture()
		draw.Circle(0, 0, 0.05, 25)
	cam.End3D2D()
end) --]]

hook.Add("InputMouseApply", "asdasd2", function(cmd, x, y, angle)
	if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
	if not IsValid(follow) then return end

	local att = follow:GetAttachment(follow:LookupAttachment("eyes"))
	if not att or not istable(att) then return end

	local angRad = math.rad(angle[3])
	local newX = x * math.cos(angRad) - y * math.sin(angRad)
	local newY = x * math.sin(angRad) + y * math.cos(angRad)

	angle.pitch = math.Clamp(angle.pitch + newY / 50, -180, 180)
	angle.yaw = angle.yaw - newX / 50

	if math.abs(angle.pitch) > 89 then
		angle.roll = angle.roll + 180
		angle.yaw = angle.yaw + 180
		angle.pitch = 89 * angle.pitch / math.abs(angle.pitch)
	end

	cmd:SetViewAngles(angle)

	return true
end)

local HullVec = Vector(4, 4, 4)
local hand_material = Material("vgui/hud/hmcd_hand")
local hand_material_on = Material("vgui/hud/hmcd_closedhand")
local show_hands = CreateClientConVar("hg_showhands", 1, true, false, "Show hints on whether your hand will stick and what object you're currently about to hold.")
local last_hold_lh = 0
local last_hold_rh = 0

hook.Add("HUDPaint", "fakethings", function()
	local ragdoll = follow

	if not LocalPlayer():Alive() then return end
	if not show_hands:GetBool() then return end

	if IsValid(ragdoll) then
		local rh = ragdoll:LookupBone("ValveBiped.Bip01_R_Hand")
		local mat = ragdoll:GetBoneMatrix(rh)

		if mat then
			local position = mat:GetTranslation()
			local traceinfo = {
				start = position,
				endpos = position,
				mins = -HullVec,
				maxs = HullVec,
				filter = ragdoll,
			}

			local tr = util.TraceHull(traceinfo)

			if tr.Hit and not tr.HitSky then
				local vec = tr.HitPos + mat:GetAngles():Forward() * 3 + mat:GetAngles():Right() * 1 + mat:GetAngles():Up() * -1
				local vec1 = vec + mat:GetAngles():Up() * 2
				local vec2 = vec + mat:GetAngles():Forward() * -2 + mat:GetAngles():Up() * 2 + mat:GetAngles():Right() * 0.5
				local vec3 = vec + mat:GetAngles():Forward() * -2 + mat:GetAngles():Right() * 0.5
				-- local pos = vec:ToScreen()

				last_hold_rh = LocalPlayer():GetNWBool("rhon", false) and 255 or LerpFT(0.01, last_hold_rh, 0)

				--[[ uncomment if needed
				surface.SetFont("HomigradFont")
				local txt = "You're " .. (ply:GetNWBool("rhon", false) and "currently holding " or "about to hold ") .. (tr.Entity:IsWorld() and "a solid object" or tr.Entity:IsPlayer() and "player " .. tr.Entity:Name() or tr.Entity.PrintName or string.find(tr.Entity:GetClass(), "prop") and "a prop" or tr.Entity:GetClass()) .. " with your right hand."
				local x, y = surface.GetTextSize(txt)
				local posx = math.Clamp(Lerp(0.1, ScrW() * 2 / 3, pos.x), x / 2, ScrW() - x / 2)
				local posy = math.Clamp(Lerp(0.1, ScrH() * 9 / 10, pos.y), y, ScrH() - y)
				surface.SetTextPos(posx - x / 2, posy - y)
				surface.SetTextColor(255, 255, 255, last_hold_rh)
				surface.DrawText(txt) --]]

				cam.Start3D()
					render.SetMaterial(LocalPlayer():GetNWBool("rhon", false) and hand_material_on or hand_material)
					-- render.DrawSprite(vec, 1, 1, color_black)
					-- render.DrawSprite(vec1, 1, 1, Color(255, 0, 0))
					-- render.DrawSprite(vec2, 1, 1, color_white)
					-- render.DrawSprite(vec3, 1, 1, color_white)
					render.DrawQuad(vec, vec1, vec2, vec3, color_white)
				cam.End3D()
			end
		end

		local lh = ragdoll:LookupBone("ValveBiped.Bip01_L_Hand")
		local mat = ragdoll:GetBoneMatrix(lh)

		if mat then
			local position = mat:GetTranslation()
			local traceinfo = {
				start = position,
				endpos = position,
				mins = -HullVec,
				maxs = HullVec,
				filter = ragdoll,
			}

			local tr = util.TraceHull(traceinfo)

			if tr.Hit and not tr.HitSky then
				local vec = tr.HitPos + mat:GetAngles():Forward() * 3 + mat:GetAngles():Right() * 1 + mat:GetAngles():Up() * -1
				local vec1 = vec + mat:GetAngles():Up() * 2
				local vec2 = vec + mat:GetAngles():Forward() * -2 + mat:GetAngles():Up() * 2 + mat:GetAngles():Right() * 0.5
				local vec3 = vec + mat:GetAngles():Forward() * -2 + mat:GetAngles():Right() * 0.5
				-- local pos = vec:ToScreen()

				last_hold_lh = LocalPlayer():GetNWBool("lhon", false) and 255 or LerpFT(0.01, last_hold_lh, 0)

				--[[ uncomment if needed
				surface.SetFont("HomigradFont")
				local txt = "You're " .. (ply:GetNWBool("rhon", false) and "currently holding " or "about to hold ") .. (tr.Entity:IsWorld() and "a solid object" or tr.Entity:IsPlayer() and "player " .. tr.Entity:Name() or tr.Entity.PrintName or string.find(tr.Entity:GetClass(), "prop") and "a prop" or tr.Entity:GetClass()) .. " with your left hand."
				local x, y = surface.GetTextSize(txt)
				local posx = math.Clamp(Lerp(0.1, ScrW() / 3, pos.x), x / 2, ScrW() - x / 2)
				local posy = math.Clamp(Lerp(0.1, ScrH() * 9 / 10, pos.y), y, ScrH() - y)
				surface.SetTextPos(posx - x / 2, posy - y)
				surface.SetTextColor(255, 255, 255, last_hold_lh)
				surface.DrawText(txt) --]]

				cam.Start3D()
					render.SetMaterial(LocalPlayer():GetNWBool("lhon", false) and hand_material_on or hand_material)
					-- render.DrawSprite(vec, 1, 1, color_black)
					-- render.DrawSprite(vec1, 1, 1, Color(255, 0, 0))
					-- render.DrawSprite(vec2, 1, 1, color_white)
					-- render.DrawSprite(vec3, 1, 1, color_white)
					render.DrawQuad(vec, vec1, vec2, vec3, color_white)
				cam.End3D()
			end
		end
	end
end)

--[[
hook.Add("Think", "mouthanim", function()
	for _, ply in player.Iterator() do
		local ent = IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply
		local flexes = {ent:GetFlexIDByName("jaw_drop"), ent:GetFlexIDByName("left_part"), ent:GetFlexIDByName("right_part"), ent:GetFlexIDByName("left_mouth_drop"), ent:GetFlexIDByName("right_mouth_drop")}
		local weight = ply:IsSpeaking() and math.Clamp(ply:VoiceVolume() * 6, 0, 6) or 0
		for _, v in ipairs(flexes) do
			ent:SetFlexWeight(v, weight * 4)
		end
	end
end) --]]

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0.1,
	["$pp_colour_brightness"] = -0.05,
	["$pp_colour_contrast"] = 1.5,
	["$pp_colour_colour"] = 0.3,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0.5
}

local tab2 = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local blurMat2, Dynamic2 = Material("pp/blurscreen"), 0

local function BlurScreen(den, alp)
	local layers, density, alpha = 1, den, alph

	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blurMat2)

	local FrameRate, Num = 1 / FrameTime(), 3

	for i = 1, Num do
		blurMat2:SetFloat("$blur", i / layers * density * Dynamic2)
		blurMat2:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	Dynamic2 = math.Clamp(Dynamic2 + 1 / FrameRate * 7, 0, 1)
end

local r = math.random(1, 10)
local triangle = {
	{
		x = 1770,
		y = 150
	},
	{
		x = 1820,
		y = 50
	},
	{
		x = 1870,
		y = 150
	}
}

local addmat_r = Material("CA/add_r")
local addmat_g = Material("CA/add_g")
local addmat_b = Material("CA/add_b")
local vgbm = Material("vgui/black")

local function DrawCA(rx, gx, bx, ry, gy, by)
	render.UpdateScreenEffectTexture()

	addmat_r:SetTexture("$basetexture", render.GetScreenEffectTexture())
	addmat_g:SetTexture("$basetexture", render.GetScreenEffectTexture())
	addmat_b:SetTexture("$basetexture", render.GetScreenEffectTexture())

	render.SetMaterial(vgbm)
	render.DrawScreenQuad()

	render.SetMaterial(addmat_r)
	render.DrawScreenQuadEx(-rx / 2, -ry / 2, ScrW() + rx, ScrH() + ry)

	render.SetMaterial(addmat_g)
	render.DrawScreenQuadEx(-gx / 2, -gy / 2, ScrW() + gx, ScrH() + gy)

	render.SetMaterial(addmat_b)
	render.DrawScreenQuadEx(-bx / 2, -by / 2, ScrW() + bx, ScrH() + by)
end

hook.Add("RenderScreenspaceEffects", "BloomEffect-homigrad", function()
	if GetConVar("hg_bodycam"):GetInt() == 1 and LocalPlayer():Alive() then
		local splitTbl = string.Split(util.DateStamp(), " ")
		local date, time = splitTbl[1], splitTbl[2]
		time = string.Replace(time, "-", ":")

		draw.Text({
			text = date .. " " .. time .. " -0400",
			font = "BodyCamFont",
			pos = {ScrW() - 650, 50}
		})

		draw.Text({
			text = "AXON BODY " .. r .. " XG8A754GH",
			font = "BodyCamFont",
			pos = {ScrW() - 650, 100}
		})

		surface.SetDrawColor(255, 255, 0, 255)
		draw.NoTexture()
		surface.DrawPoly(triangle)
		DrawBloom(0.5, 1, 9, 9, 1, 1.2, 0.8, 0.8, 1.2)
		-- DrawTexturize(1, mat)
		DrawSharpen(1, 1.2)
		DrawColorModify(tab)
		BlurScreen(0.3, 55)
		LocalPlayer():SetDSP(55, true)
		DrawMotionBlur(0.2, 0.3, 0.001)
		--DrawToyTown(1, ScrH() / 2)

		local k3 = 6
		DrawCA(4 * k3, 2 * k3, 0, 2 * k3, 1 * k3, 0)
	end

	if not LocalPlayer():Alive() then LocalPlayer():SetDSP(1) end

	if LocalPlayer():Alive() then
		tab2["$pp_colour_colour"] = LocalPlayer():Health() / 150

		DrawColorModify(tab2)
	end

	if not LocalPlayer():Alive() and timer.Exists("DeathCam") then
		DrawMotionBlur(0.5, 0.3, 0.02)
		DrawSharpen(1, 0.2)

		local k3 = 15
		DrawCA(4 * k3, 2 * k3, 0, 2 * k3, 1 * k3, 0)

		tab2["$pp_colour_colour"] = 0.2
		tab2["$pp_colour_mulb"] = 0.5

		DrawColorModify(tab2)
		BlurScreen(1, 155)

		draw.Text({
			text = deathtext,
			font = "BodyCamFont",
			pos = {ScrW() / 2, ScrH() / 1.2},
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			color = Color(255, 35, 35, 220)
		})

		LocalPlayer():SetDSP(15)
	elseif not LocalPlayer():Alive() then
		LocalPlayer():SetDSP(1)
	end
end)

-- Create a client console variable to control showing the voice icon
CreateClientConVar("hg_showvoice", 1, true, false, "Show or hide the voice icon (1 = show, 0 = hide)")

hook.Add("HUDPaint", "ShowSpeakingIconWithSpin", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	-- Check if the console variable is set to 1 (enabled)
	if GetConVar("hg_showvoice"):GetInt() == 0 then return end

	-- Check if the player is speaking
	if ply:IsSpeaking() then
		-- Set the base position for the icon
		local x = ScrW() * 0.9 -- 90% of screen width (adjust for your desired position)
		local y = ScrH() * 0.8 -- 80% of screen height (adjust for your desired position)
		local baseSize = 64 -- Base size for the icon height

		-- Calculate dynamic scaling and flipping
		local time = CurTime() * 5 -- Speed of the spinning effect
		local scaleFactor = math.sin(time) -- Sinusoidal scaling between -1 and 1
		local dynamicWidth = math.abs(scaleFactor) * baseSize -- Scale width up and down
		local height = baseSize -- Keep the height constant

		-- Determine UV flipping based on the sign of scaleFactor
		local u1, v1 = 0, 0
		local u2, v2 = 1, 1

		if scaleFactor < 0 then
			u1, u2 = 1, 0 -- Flip texture horizontally
		end

		-- Center the icon correctly by offsetting the dynamic width
		local offsetX = dynamicWidth / 2

		-- Draw the icon with dynamic width and flipping
		surface.SetDrawColor(255, 255, 255, 255) -- White color
		surface.SetMaterial(Material("icon16/sound.png")) -- Replace with your custom icon path
		surface.DrawTexturedRectUV(x - offsetX, y - height / 2, dynamicWidth, height, u1, v1, u2, v2)
	end
end)

--[[
local colred = Color(255,0,0)
hook.Add("PostDrawTranslucentRenderables", "fuck_off", function()
	local lply = LocalPlayer()
	if lply == Entity(1) then
		local ent = lply:GetEyeTrace().Entity
		ent = ent:IsPlayer() and ent
		if ent then
			local pos, ang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
			local vec1 = Vector(3, -4, -2.5)
			local vec2 = Vector(7, 3, 2.5)
			local dmgpos = ply:GetEyeTrace().HitPos
			local penetration = ply:GetAimVector() * 100
			local raycast = util.IntersectRayWithOBB(dmgpos, penetration, pos, ang, vec1, vec2)
			render.DrawBox(pos, ang, vec1, vec2, raycast and colred or color_white)
		end
	end
end) --]]
