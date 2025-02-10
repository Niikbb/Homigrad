AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.zombie.name")
	SWEP.Author = "Kilburn, robotboy655, MaxOfS2D & Tenrys"
	SWEP.Instructions = language.GetPhrase("hg.zombie.inst")
	SWEP.Category = language.GetPhrase("hg.category.melee")
end

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_zombieswep.mdl")
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 90
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Damage = 80
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Damage = 80
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 48

local SwingSound = Sound("WeaponFrag.Throw")
local HitSound = Sound("Flesh.ImpactHard")

function SWEP:Initialize()
	self:SetHoldType("normal")

	self.ActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ZOMBIE
	self.ActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_01
	self.ActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE
	self.ActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE
	self.ActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE
	self.ActivityTranslate[ACT_MP_JUMP] = ACT_ZOMBIE_LEAPING
	self.ActivityTranslate[ACT_RANGE_ATTACK1] = ACT_GMOD_GESTURE_RANGE_ZOMBIE
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextMeleeAttack")
	self:NetworkVar("Float", 1, "NextIdle")
	self:NetworkVar("Int", 2, "Combo")
end

function SWEP:UpdateNextIdle()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate())
end

function SWEP:PrimaryAttack(right)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	if right then anim = "fists_right" end
	if self:GetCombo() >= 2 then anim = "fists_uppercut" end

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:EmitSound(SwingSound)
	self:UpdateNextIdle()
	self:SetNextMeleeAttack(CurTime() + 0.2)
	self:SetNextPrimaryFire(CurTime() + 0.9)
	self:SetNextSecondaryFire(CurTime() + 0.9)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end

local phys_pushscale = GetConVar("phys_pushscale")

function SWEP:DealDamage()
	local anim = self:GetSequenceName(self:GetOwner():GetViewModel():GetSequence())

	self:GetOwner():LagCompensation(true)

	local tr = util.TraceLine({
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.HitDistance,
		filter = self:GetOwner(),
		mask = MASK_SHOT_HULL
	})

	if not IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.HitDistance,
			filter = self:GetOwner(),
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8),
			mask = MASK_SHOT_HULL
		})
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if tr.Hit and not (game.SinglePlayer() and CLIENT) then self:EmitSound(HitSound) end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0) then
		local dmginfo = DamageInfo()
		local attacker = self:GetOwner()
		if not IsValid(attacker) then attacker = self end

		dmginfo:SetAttacker(attacker)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamage(math.random(60, 95))

		if anim == "fists_left" then
			dmginfo:SetDamageForce(self:GetOwner():GetRight() * 4912 * scale + self:GetOwner():GetForward() * 9998 * scale) -- Yes we need those specific numbers
		elseif anim == "fists_right" then
			dmginfo:SetDamageForce(self:GetOwner():GetRight() * -4912 * scale + self:GetOwner():GetForward() * 9989 * scale)
		elseif anim == "fists_uppercut" then
			dmginfo:SetDamageForce(self:GetOwner():GetUp() * 5158 * scale + self:GetOwner():GetForward() * 10012 * scale)
			dmginfo:SetDamage(math.random(38, 70))
		else
			dmginfo:SetDamageForce(self:GetOwner():GetForward() * 14910 * scale) -- Yes we need those specific numbers
		end

		SuppressHostEvents(NULL) -- Let the breakable gibs spawn in multiplayer on client

		tr.Entity:TakeDamageInfo(dmginfo)

		SuppressHostEvents(self:GetOwner())

		hit = true
	end

	if IsValid(tr.Entity) then
		local phys = tr.Entity:GetPhysicsObject()
		if IsValid(phys) then phys:ApplyForceOffset(self:GetOwner():GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos) end
	end

	if SERVER then
		if hit and anim ~= "fists_uppercut" then
			self:SetCombo(self:GetCombo() + 1)
		else
			self:SetCombo(0)
		end
	end

	self:GetOwner():LagCompensation(false)
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Deploy()
	local speed = GetConVar("sv_defaultdeployspeed"):GetFloat()
	local vm = self:GetOwner():GetViewModel()

	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetPlaybackRate(speed)
	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / speed)
	self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / speed)
	self:UpdateNextIdle()

	if SERVER then self:SetCombo(0) end

	return true
end

function SWEP:Holster()
	self:SetNextMeleeAttack(0)
	return true
end

function SWEP:Think()
	local idletime = self:GetNextIdle()
	if idletime > 0 and CurTime() > idletime then
		self:SendWeaponAnim(ACT_VM_IDLE)
		self:UpdateNextIdle()
	end

	local meleetime = self:GetNextMeleeAttack()
	if meleetime > 0 and CurTime() > meleetime then
		self:DealDamage()
		self:SetNextMeleeAttack(0)
	end

	if SERVER and CurTime() > self:GetNextPrimaryFire() + 0.1 then self:SetCombo(0) end
end