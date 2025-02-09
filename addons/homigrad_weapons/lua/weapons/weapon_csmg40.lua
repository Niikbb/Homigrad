if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = "salat_base" -- base 

SWEP.PrintName 				= "MP40"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Пистолет-пулемёт под калибр 9х19"
SWEP.Category 				= "Оружие 2"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 32
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 20
SWEP.Primary.Spread = 5
SWEP.Primary.Sound = "zcitysnd/sound/weapons/mp40/mp40_fp.wav"
SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/mp40/mp40_dist.wav"
SWEP.Primary.Force = 25
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12
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

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/w_grub_mp40.mdl"
SWEP.WorldModel				= "models/weapons/w_grub_mp40.mdl"

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(0.25,math.Rand(-0.4,0.4),0)
end

SWEP.vbwPos = Vector(-4,-3.7,2)
SWEP.vbwAng = Angle(2,-30,0)

SWEP.addAng = Angle(0,0,0)
SWEP.addPos = Vector(0,1,0)
end