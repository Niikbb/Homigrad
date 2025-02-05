if not engine.ActiveGamemode() == "homigrad" then return end
SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Винтовка Мосина"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Винтовка под калибр 7,62х39"
SWEP.Category 				= "Оружие 2"


SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/mosin/mosin_fp.wav"
SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/mosin/mosin_dist.wav"
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 1.5
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"
SWEP.revolver = true

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/w_grub_mosin.mdl"
SWEP.WorldModel				= "models/weapons/w_grub_mosin.mdl"

SWEP.vbwPos = Vector(5,-6,-6)
SWEP.addAng = Angle(0,0,0)
SWEP.addPos = Vector(0,1.5,-.3)

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(1.5,math.Rand(-0.2,0.2),0)
end