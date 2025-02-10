SWEP.Base = "salat_base"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.at4.name")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("hg.at4.inst")
	SWEP.Category = language.GetPhrase("hg.category.weapons")
end

-- SWEP.WepSelectIcon = "pwb/sprites/m134"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "RPG_Round"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.TwoHands = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "rpg"

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModel = "models/weapons/w_jmod_at4.mdl"
SWEP.WorldModel = "models/weapons/w_jmod_at4.mdl"

SWEP.vbwPos = Vector(14, 5, -7)
SWEP.vbwAng = Angle(60, 0, 90)

SWEP.addAng = Angle(-5.5, -0.3, -90)
SWEP.SightPos = Vector(-40, -3.6, -4.85)

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then return end

	local pos, ang = self:GetTrace()

	if SERVER then
		local rocket = ents.Create("gb_rocket_rp3") -- FIXME: this ent doesn't exists
		rocket:SetPos(pos)
		rocket:SetAngles(ang)
		rocket:Spawn()
		rocket:Launch()
	end

	self:TakePrimaryAmmo(1)
end

-- models/weapons/insurgency/w_rpg7.mdl
-- models/weapons/insurgency/w_rpg7_projectile.mdl