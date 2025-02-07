if engine.ActiveGamemode() == "homigrad" then
SWEP.Base = 'salat_base'

SWEP.PrintName 				= "Milkor MGL"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "\nВыпускает 40мм заряды.\n\nПрицел сбит, ствол кривой.\nБаллистика зависит от ваших движений.\nЛюди от взрывов отлетают на километры."
SWEP.Category 				= "Оружие (GM)"
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Slot					= 3
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.HoldType               = "smg"

SWEP.Primary.ClipSize		= 6666
SWEP.Primary.DefaultClip	= 6666
SWEP.Primary.Ammo = "RPG_Round"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModel				= "models/weapons/w_jmod_milkormgl.mdl"
SWEP.WorldModel				= "models/weapons/w_jmod_milkormgl.mdl"
SWEP.TwoHands = true
SWEP.ShootWait = 0.333

SWEP.Automatic = false
SWEP.vbwPos = Vector(14,5,-7)
SWEP.vbwAng = Angle(60,0,90)
function SWEP:PrimaryAttack()
    self.ShootNext=self.NextShot or NextShot
    if (self.NextShot>CurTime()) then return end
    if self:Clip1()<=0 then return end
    self.NextShot=CurTime()+self.ShootWait
    local shotpos=self:GetOwner():GetPos()+Vector(0,0,35)+self:GetOwner():EyeAngles():Forward()*90+self:GetOwner():EyeAngles():Right()*5
    if SERVER then 
        local cmm=ents.Create( "ent_hgjack_40mm_contact" )
        cmm:SetPos(shotpos)
        cmm:SetAngles(self:GetOwner():EyeAngles()+Angle(0,0,0))
        cmm:Spawn()
        cmm:Arm()
        local cmm2=cmm:GetPhysicsObject()
		if IsValid(cmm2) then
			cmm2:SetVelocity(self:GetOwner():GetAimVector()*750+(self:GetOwner():GetVelocity()*2))
		end
    end
    --self:TakePrimaryAmmo(1)
end
--models/weapons/insurgency/w_rpg7.mdl
--models/weapons/insurgency/w_rpg7_projectile.mdl
end