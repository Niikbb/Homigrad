SWEP.Base = "weapon_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.pipe.name")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("hg.pipe.inst")
	SWEP.Category = language.GetPhrase("hg.category.weapons")
end

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/props_canal/mattpipe.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Primary.Sound = Sound("Weapon_Knife.Single")
SWEP.Primary.Damage = 35
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 1.1
SWEP.Primary.Force = 400

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	if not IsValid(DrawModel) then
		DrawModel = ClientsideModel(self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
		DrawModel:SetNoDraw(true)
	else
		DrawModel:SetModel(self.WorldModel)

		local vec = Vector(55, 55, 55)
		local ang = Vector(-48, -48, -48):Angle()

		cam.Start3D(vec, ang, 20, x, y + 35, wide, tall, 5, 4096)
			cam.IgnoreZ(true)

			render.SuppressEngineLighting(true)
			render.SetLightingOrigin(self:GetPos())
			render.ResetModelLighting(50 / 255, 50 / 255, 50 / 255)
			render.SetColorModulation(1, 1, 1)
			render.SetBlend(255)
			render.SetModelLighting(4, 1, 1, 1)

			DrawModel:SetRenderAngles(Angle(0, RealTime() * 30 % 360, 0))
			DrawModel:DrawModel()
			DrawModel:SetRenderAngles()

			render.SetColorModulation(1, 1, 1)
			render.SetBlend(1)
			render.SuppressEngineLighting(false)

			cam.IgnoreZ(false)
		cam.End3D()
	end

	self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
end

function Circle(x, y, radius, seg)
	local cir = {}
	table.insert(cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})

	for i = 0, seg do
		local a = math.rad(i / seg * -360)
		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, {
		x = x + math.sin(a) * radius,
		y = y + math.cos(a) * radius,
		u = math.sin(a) / 2 + 0.5,
		v = math.cos(a) / 2 + 0.5
	})

	surface.DrawPoly(cir)
end

function SWEP:DrawHUD()
	if GetViewEntity() ~= LocalPlayer() then return end
	if LocalPlayer():InVehicle() then return end

	local ply = self:GetOwner()

	local t = {}
	t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	t.endpos = t.start + ply:GetAngles():Forward() * 90
	t.filter = self:GetOwner()
	local Tr = util.TraceLine(t)

	if Tr.Hit then
		local Size = math.Clamp(1 - ((Tr.HitPos - self:GetOwner():GetShootPos()):Length() / 90) ^ 2, .1, .3)

		surface.SetDrawColor(Color(200, 200, 200, 200))
		draw.NoTexture()
		Circle(Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y, 55 * Size, 32)

		surface.SetDrawColor(Color(255, 255, 255, 200))
		draw.NoTexture()
		Circle(Tr.HitPos:ToScreen().x, Tr.HitPos:ToScreen().y, 40 * Size, 32)
	end
end

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
	self:SetHoldType("melee")
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay / ((self:GetOwner().stamina or 100) / 100) - self:GetOwner():GetNWInt("Adrenaline") / 5)

	if SERVER then
		self:GetOwner():EmitSound("weapons/slam/throw.wav", 60)
		self:GetOwner().stamina = math.max(self:GetOwner().stamina - 7, 0)
	end

	self:GetOwner():LagCompensation(true)

	local ply = self:GetOwner()

	local tra = {}
	tra.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
	tra.endpos = tra.start + ply:GetAngles():Forward() * 80
	tra.filter = self:GetOwner()
	local Tr = util.TraceLine(tra)

	local t = {}
	local tr

	if not Tr.Hit then
		t.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
		t.endpos = t.start + ply:GetAngles():Forward() * 80
		t.filter = function(ent) return ent ~= self:GetOwner() and (ent:IsPlayer() or ent:IsRagdoll()) end
		t.mins = -Vector(10, 10, 10)
		t.maxs = Vector(10, 10, 10)
		tr = util.TraceHull(t)
	else
		tr = util.TraceLine(tra)
	end

	if true then
		if SERVER and tr.HitWorld then self:GetOwner():EmitSound("physics/metal/metal_canister_impact_hard2.wav", 60) end

		if IsValid(tr.Entity) and SERVER then
			local dmginfo = DamageInfo()
			dmginfo:SetDamageType(DMG_CLUB)
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamagePosition(tr.HitPos)
			dmginfo:SetDamageForce(self:GetOwner():GetForward() * self.Primary.Force)

			local angle = self:GetOwner():GetAngles().y - tr.Entity:GetAngles().y
			if angle < -180 then angle = 360 + angle end

			dmginfo:SetDamage(self.Primary.Damage / 1.5)

			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
				self:GetOwner():EmitSound("Flesh.ImpactHard", 60)
			else
				if tr.Entity:GetClass() == "prop_ragdoll" then
					self:GetOwner():EmitSound("Flesh.ImpactHard", 60)
				else
					self:GetOwner():EmitSound("physics/metal/metal_canister_impact_hard2.wav", 60)
				end
			end

			tr.Entity:TakeDamageInfo(dmginfo)
		end
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()

		if IsValid(owner) then
			local offsetVec = Vector(8, -1, 0)
			local offsetAng = Angle(150, 0, 0)

			local boneid = owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if not boneid then return end

			local matrix = owner:GetBoneMatrix(boneid)
			if not matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
			WorldModel:SetModelScale(1)
			WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end