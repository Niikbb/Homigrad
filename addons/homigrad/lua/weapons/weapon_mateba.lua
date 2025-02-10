SWEP.Base = "salat_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.mateba.name")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("hg.mateba.inst")
	SWEP.Category = language.GetPhrase("hg.category.weapons")
end

SWEP.WepSelectIcon = "pwb2/vgui/weapons/matebahomeprotection"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ".44 Magnum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb2/weapons/matebahomeprotection/deagle-1.wav"
SWEP.Primary.SoundFar = "snd_jack_hmcd_smp_far.wav"
SWEP.Primary.Force = 105 / 40
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "revolver"
SWEP.revolver = true

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/pwb2/weapons/w_matebahomeprotection.mdl"
SWEP.WorldModel = "models/pwb2/weapons/w_matebahomeprotection.mdl"

function SWEP:ApplyEyeSpray()
	self.eyeSpray = self.eyeSpray - Angle(2, math.Rand(-0.5, 0.5), 0)
end

local function rolldrum(ply, wpn)
	print(wpn) -- TODO
	local wep = type(wpn) == "string" and ply:GetActiveWeapon() or wpn
	print(wep)

	if not IsValid(ply) or not IsValid(wep) or wep:GetClass() ~= "weapon_mateba" then return end

	wep.tries = math.random(math.max(7 - wep:Clip1(), 1))

	if CLIENT then
		net.Start("hg_rolldrum")
			net.WriteEntity(wep)
			net.WriteInt(wep.tries, 4)
		net.SendToServer()
	else
		net.Start("hg_rolldrum")
			net.WriteEntity(wep)
			net.WriteInt(wep.tries, 4)
		net.Send(ply)
	end
end

function SWEP:RollDrum()
	rolldrum(self:GetOwner(), self)
end

concommand.Add("hg_rolldrum", rolldrum)

if SERVER then
	util.AddNetworkString("hg_rolldrum")

	net.Receive("hg_rolldrum", function(len, ply)
		local wep = net.ReadEntity()

		if wep:GetOwner() ~= ply then return end
		if ply:GetActiveWeapon() ~= wep then return end

		wep.tries = net.ReadInt(4)

		ply:EmitSound("weapons/357/357_spin1.wav", 65)
	end)
else
	net.Receive("hg_rolldrum", function(len)
		local wep = net.ReadEntity()

		wep.tries = net.ReadInt(4)
	end)
end

if SERVER then
	util.AddNetworkString("real_bul")

	function SWEP:Deploy()
		self:SetHoldType("normal")

		self:GetOwner():EmitSound("snd_jack_hmcd_pistoldraw.wav", 65, 100, 1, CHAN_AUTO)

		self.NextShot = CurTime() + 0.5

		self:SetHoldType(self.HoldType)

		self.tries = self.tries or math.random(math.max(7 - self:Clip1(), 1))

		net.Start("real_bul")
			net.WriteEntity(self)
			net.WriteInt(self.tries, 4)
		net.Send(self:GetOwner())
	end
else
	function SWEP:Deploy()
		self:SetHoldType("normal")

		self.NextShot = CurTime() + 0.5

		self:SetHoldType(self.HoldType)
	end

	net.Receive("real_bul", function(len) net.ReadEntity().tries = net.ReadInt(4) end)
end

function SWEP:CanFireBullet()
	if not IsFirstTimePredicted() then return end

	self.tries = self.tries or 1 -- math.ceil(util.SharedRandom("hgRevolverTries" .. tostring(CurTime()), 1, math.max(6 - self:Clip1(), 1)))
	self.tries = self.tries - 1

	return self.tries <= 0
end

SWEP.OffsetVec = Vector(8, 5, 1)

SWEP.dwsPos = Vector(15, 15, 5)
SWEP.dwsItemPos = Vector(-5, 0, 1.5)

SWEP.vbwPos = Vector(6.2, 4.5, -4)

SWEP.addPos = Vector(0, -1, -0.5)
SWEP.addAng = Angle(0, 0, 0)

SWEP.SightPos = Vector(-25, -0.75, -0.6)