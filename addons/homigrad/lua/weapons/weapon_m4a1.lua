SWEP.Base = "weapon_ar15"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.m4a1.name")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("hg.m4a1.inst")
	SWEP.Category = language.GetPhrase("hg.category.weapons")
end

SWEP.Primary.Automatic = true

SWEP.ShootWait = 0.07