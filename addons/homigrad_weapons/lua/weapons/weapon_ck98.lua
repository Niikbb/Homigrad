if not engine.ActiveGamemode() == "homigrad" then return end
SWEP.Base = 'salat_base'

-- заготовка для поддержки не только Русского, но и других языков вроде Английского. 🤔😁🤔
-- можно будет и в Воркшоп заливать потом. Запара лютая конечно...
/*if CLIENT then
    SWEP.PrintName 				= language.GetPhrase("weapon_ck98_name")
    SWEP.Author 				= "Homigrad"
    SWEP.Instructions			= language.GetPhrase("weapon_ck98_desc")
    SWEP.Category 				= language.GetPhrase("swep_category_two")
end*/

SWEP.PrintName 				= "Mauser K98"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Винтовка под калибр 7,62х39"
SWEP.Category 				= "Оружие 2"


SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "zcitysnd/sound/weapons/sks/sks_fp.wav"
SWEP.Primary.SoundFar = "zcitysnd/sound/weapons/sks/sks_dist.wav"
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 1.5
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"
SWEP.revolver = true

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/doi/w_kar98k.mdl"
SWEP.WorldModel				= "models/weapons/doi/w_kar98k.mdl"

SWEP.vbwPos = Vector(5,-6,-6)

SWEP.addAng = Angle(1,0,0)
SWEP.addPos = Vector(0,3,1.2)

function SWEP:ApplyEyeSpray()
    self.eyeSpray = self.eyeSpray - Angle(1.25,math.Rand(-0.2,0.2),0)
end