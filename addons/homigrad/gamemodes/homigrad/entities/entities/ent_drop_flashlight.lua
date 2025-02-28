AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Flashlight"
ENT.Author = "JMOD"
ENT.Spawnable = true
ENT.AdminSpawnable = false
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/maxofs2d/lamp_flashlight.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetModelScale(0.5)
		self:PhysWake()
	end

	function ENT:Use(ply)
		if not ply.allowFlashlights then
			ply.allowFlashlights = true
			self:Remove()
		elseif not self:IsPlayerHolding() then
			ply:PickupObject(self)
		end
	end
end