if engine.ActiveGamemode() == "homigrad" then
if CLIENT then
	local vecUp = Vector(0,0,50)

	local hg_flashlight_enable = CreateClientConVar("hg_flashlight_enable","1",true,false)
	local hg_flashlight_distance = CreateClientConVar("hg_flashlight_distance","4096",true,false)

	local tbl,ply,lply_pos,dis
	local player_GetAll = player.GetAll

	local function create(ply)
		ply.DynamicFlashlight = ProjectedTexture()
		ply.DynamicFlashlight:SetTexture("effects/flashlight001")
		ply.DynamicFlashlight:SetFarZ(900)
		ply.DynamicFlashlight:SetFOV(70)
		ply.DynamicFlashlight:SetEnableShadows(true) 
	end

	local function remove(ply)
		if IsValid(ply.DynamicFlashlight) then
			ply.DynamicFlashlight:Remove()
			ply.DynamicFlashlight = nil
		end
	end
	local material = Material( "sprites/gmdm_pickups/light" )
	local CT = CurTime()
	hook.Add("Think","DynamicFlashlight.Rendering",function()
		if CT > CurTime() then return end
		CT = CT + 0.02
		lply_pos = LocalPlayer():GetPos()
		dis = hg_flashlight_distance:GetFloat()
		
		tbl = player_GetAll()

		for i = 1,#tbl do
			ply = tbl[i]
			
			if hg_flashlight_enable:GetBool() and ply:GetNWBool("DynamicFlashlight") and ply:GetPos():Distance(lply_pos) <= dis then
				local fake = ply:GetNWEntity("Ragdoll")

				if ply:Alive() then
					local ent = ply:GetNWBool("fake") and IsValid(fake) and fake or ply

					if ply.DynamicFlashlight then
						local bone = ent:LookupBone("ValveBiped.Bip01_L_Hand")
						local pos
						if bone then pos = ent:GetBonePosition(bone) else pos = ply:EyePos() end
						
						ply.DynamicFlashlight:SetPos(pos + ply:EyeAngles():Forward() * 15)
						ply.DynamicFlashlight:SetAngles(ply:EyeAngles())
						ply.DynamicFlashlight:Update()
					else
						create(ply)
					end
				else
					ply:SetNWBool("DynamicFlashlight",false)
					if ply.DynamicFlashlight then remove(ply) end
				end
			else
				ply:SetNWBool("DynamicFlashlight",false)
				if ply.DynamicFlashlight then remove(ply) end
			end
		end
	end)

	local angZero = Angle(0,0,0)
	local vecZero = Vector(0,0,0)
	local addPosa = Vector(3,-2,0)
	
	hook.Add("PostDrawOpaqueRenderables","DynamicParticle",function()
		tbl = player_GetAll()

		for i = 1,#tbl do
			ply = tbl[i]

			ply.flashlightMdl = ply.flashlightMdl or ClientsideModel("models/maxofs2d/lamp_flashlight.mdl")
			if IsValid(ply.flashlightMdl) then
				ply.flashlightMdl:SetNoDraw(true)
			end

			if hg_flashlight_enable:GetBool() and ply:GetNWBool("DynamicFlashlight") then
				local fake = ply:GetNWEntity("Ragdoll")

				if ply:Alive() then
					if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() != "weapon_hands" then continue end

					local plya = IsValid(fake) and fake or ply
					local bone = plya:LookupBone("ValveBiped.Bip01_L_Hand")

					if bone then
						local pos,ang = plya:GetBonePosition(bone)
						local angla = ply:EyeAngles()
						local addpos = vecZero
						addpos:Set(addPosa)
						addpos:Rotate(ang)
						pos:Add(addpos)
						ply.flashlightMdl:SetPos(pos)
						ply.flashlightMdl:SetAngles(angla)
						ply.flashlightMdl:SetNoDraw(false)
						ply.flashlightMdl:SetModelScale(0.5)
						cam.Start3D()
							render.SetMaterial( material ) -- Tell render what material we want, in this case the flash from the gravgun
							render.DrawSprite( pos + angla:Forward()*5,32, 32, color_white)
						cam.End3D()
					end
				end
			end
		end

	end)

else
	hook.Add("PlayerSwitchFlashlight", "DynamicFlashlight.Switch", function(ply, state)
		if not ply.allowFlashlights then 
			ply:SetNWBool("DynamicFlashlight",false)
			return false 
		end
		
		local bool = ply:GetNWBool("DynamicFlashlight")
		ply:SetNWBool("DynamicFlashlight",not bool)
		ply:EmitSound("items/flashlight1.wav", 60, 100)
		
		return false
	end)
end

/*
ITEM PLACEHOLDER
1. Sound URL. I'd prefer Dropbox.
2. Model Path.
3. Not known. Maybe how long is Sound URL.
4. Model Position.
5. Item Angle.

medkit = {
		"https://dl.dropboxusercontent.com/s/n3w05ap5k4f6ddi/.mp3", -- Rob Zombie - Two Lane Blacktop (from Niikbal's Dropbox)
		"models/w_models/weapons/w_eq_medkit.mdl",
		13,
		nil, -- nil = default
		Angle(-30,0,0)
	},

*/


local items = { -- custom items. probably for donators.
	medkit = {
		"",
		"models/w_models/weapons/w_eq_medkit.mdl",
		13,
		nil,
		Angle(-30,0,0)
	},
	granade = {
		"",
		"models/weapons/w_jj_fraggrenade.mdl",
		70,
		nil,
		Angle(-30,0,0)
	},
	murder = {
		"",
		"models/player/mkx_jajon.mdl",
		2,
		Vector(0,0,-40),
		Angle(-40,0,0),
	},
	burger = {
		"",
		"models/foodnhouseholditems/mcdburgerbox.mdl",
		15,
		nil,
		Angle(-30,0,0)
	},
	sex = {
		"",
		"models/props_c17/oildrum001_explosive.mdl",
		7
	},
	glasses = {
		"",
		"models/gmod_tower/aviators.mdl",
		false,
		nil,
		Angle(-30,0,0)
	},
	romantical = {
		"",
		"models/Humans/Group01/male_03.mdl",
		false,
		Vector(0,0,-40),
		Angle(-40,0,0),
	},
	bow = {
		"",
		"models/weapons/w_snij_awp.mdl",
		70,
		nil,
		Angle(-40,0,0)
	},
	nuck = {
		"",
		"models/chappi/mininuq.mdl",
		false,
		Vector(-15,-15,10),
		Angle(-40,0,0)
	},
}

if SERVER then
	util.AddNetworkString("the item!")

	local send = function(item,ply)
		net.Start("the item!")
		net.WriteString(item)
		if ply then net.Send(ply) else net.Broadcast() end
	end

	COMMANDS.theitem = {function(ply,args)
		if args[1] == "*" then
			send(args[2])
		elseif args[1] == "^" then
			send(args[2],ply)
		else
			for i,ply in pairs(player.GetAll()) do
				if string.find(ply:Nick(),args[1]) then send(args[2],ply) end
			end
		end
	end}
else
	local function stop()
		timer.Remove("ItemPrekol")
		hook.Remove("HUDPaint","the item!")
		if IsValid(Item_Model) then Item_Model:Remove() end
		if IsValid(Item_Station) then Item_Station:Stop() end
	end

	net.Receive("the item!",function()
		local item = items[net.ReadString()]
		local url = item[1]

		stop()

		sound.PlayURL(url,"mono",function(_station)
			Item_Station = _station

			Item_Station:SetVolume(1)

			Item_Model = ClientsideModel(item[2])
			Item_Model:SetNoDraw(true)
			Item_Model:SetPos(item[4] or Vector(0,0,0))

			hook.Add("HUDPaint","the item!",function()
				local pos = Vector(20,20,20)
				cam.Start3D(pos,(-pos):Angle() + (item[5] or Angle(0,0,0)),120,0,0,ScrW(),ScrH())
				cam.IgnoreZ(true)
				render.SuppressEngineLighting(true)

				render.SetLightingOrigin(Item_Model:GetPos())
				render.ResetModelLighting(50 / 255,50 / 255,50 / 255)
				render.SetColorModulation(1,1,1)
				render.SetBlend(255)

				render.SetModelLighting(4,1,1,1)

				Item_Model:SetRenderAngles(Angle(0,(CurTime() * 120) % 360,0))
				Item_Model:DrawModel()

				render.SetColorModulation(1,1,1)
				render.SetBlend(1)
				render.SuppressEngineLighting(false)
				cam.IgnoreZ(false)
				cam.End3D()

				if Item_Station:GetState() == GMOD_CHANNEL_STOPPED then stop() end
			end)
		end)

		if item[3] ~= false then
			timer.Create("ItemPrekol",item[3] or 13,1,function()
				stop()
			end)
		end
	end)
end

if IsValid(testModel) then testModel:Remove() end
hook.Remove("HUDPaint","3d_camera_example")
end