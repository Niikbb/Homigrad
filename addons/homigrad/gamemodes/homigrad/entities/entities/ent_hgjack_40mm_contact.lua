-- Jackarunda 2021
AddCSLuaFile()

ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Jackarunda, TheOnly8Z, Niik"
ENT.PrintName = "Контактный Заряд для Гранатомёта"
ENT.Category = "JModHomigrad"
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(0, -140, 0)
ENT.Model = "models/pwb/weapons/w_m320_projectile.mdl"
ENT.SpoonScale = 2

if SERVER then
	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > 0.2 and data.Speed > 40 then
			self:Detonate()
		end
	end

	function ENT:Arm()
		self:SetState(JMod.EZ_STATE_ARMING)
		self:SetBodygroup(2, 1)

		timer.Simple(.3, function()
			if IsValid(self) then
				self:SetState(JMod.EZ_STATE_ARMED)
			end
		end)
		self:EmitSound("snds_jack_gmod/ez_weapons/40mm_grenade.wav")
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self.Exploded = true
		local SelfPos = self:LocalToWorld(self:OBBCenter())
		JMod.Sploom(self:GetOwner(), self:GetPos(), 900, 500)
		self:EmitSound("dwr/explosions/indoors/distant/" .. math.random(3,8) .. ".wav", 90, 100)
		local plooie = EffectData()
		plooie:SetOrigin(SelfPos)
		plooie:SetScale(.2)
		plooie:SetRadius(1)
		plooie:SetNormal(vector_up)
		ParticleEffect("pcf_jack_airsplode_small",SelfPos,vector_up:Angle())

		self:Remove()
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
