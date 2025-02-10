SWEP.Base = "weapon_base"

SWEP.PrintName = "Grenade Base"
SWEP.Author = "sadsalat"
SWEP.Purpose = "kaboom!"

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Spawnable = false

SWEP.ViewModel = "models/pwb/weapons/w_f1.mdl"
SWEP.WorldModel = "models/pwb/weapons/w_f1.mdl"

SWEP.Grenade = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawWeaponSelection = DrawWeaponSelection
SWEP.OverridePaintIcon = OverridePaintIcon

function TrownGrenade(ply, force, grenade)
	local ent = ents.Create(grenade)
	ent:SetPos(ply:GetShootPos() + ply:GetAimVector() * 10)
	ent:SetAngles(ply:EyeAngles() + Angle(45, 45, 0))
	ent:SetOwner(ply)
	ent:SetPhysicsAttacker(ply)
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ent:Spawn()
	ent:Arm()

	local phys = ent:GetPhysicsObject()
	if not IsValid(phys) then return ent:Remove() end

	phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * force)
	phys:AddAngleVelocity(VectorRand() * force / 2)
end

function SWEP:Deploy()
	self:SetHoldType("melee")
end

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:PrimaryAttack()
	if SERVER then
		TrownGrenade(self:GetOwner(), 750, self.Grenade)
		self:Remove()
		self:GetOwner():SelectWeapon("weapon_hands")
	end

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
end

function SWEP:SecondaryAttack()
	if SERVER then
		TrownGrenade(self:GetOwner(), 250, self.Grenade)
		self:Remove()
		self:GetOwner():SelectWeapon("weapon_hands")
	end

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:EmitSound("weapons/m67/handling/m67_throw_01.wav")
end