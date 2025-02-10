SWEP.Base = "salat_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.famas.name")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("hg.famas.inst")
	SWEP.Category = language.GetPhrase("hg.category.weapons")
end

SWEP.WepSelectIcon = "pwb/sprites/aks74u"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "5.56x45 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "m16a4/m16a4_fp.wav"
SWEP.Primary.SoundFar = "m16a4/m16a4_dist.wav"
SWEP.Primary.Force = 110 / 3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.09
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "ar2"

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/pwb2/weapons/w_famasg2.mdl"
SWEP.WorldModel = "models/pwb2/weapons/w_famasg2.mdl"

SWEP.vbwPos = Vector(-2, -4.2, 1)
SWEP.vbwAng = Angle(5, -30, 0)

SWEP.SightPos = Vector(-21, 4.5, -0.32)