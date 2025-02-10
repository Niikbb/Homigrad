AddCSLuaFile()

SWEP.Base = "medkit"

if CLIENT then
	SWEP.PrintName = language.GetPhrase("hg.splint.name")
	SWEP.Author = "Homigrad"
	SWEP.Instructions = language.GetPhrase("hg.splint.inst")
	SWEP.Category = language.GetPhrase("hg.category.medicine")
end

SWEP.Spawnable = true

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.ViewModel = "models/w_models/weapons/w_eq_painpills.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_eq_painpills.mdl"

SWEP.dwsPos = Vector(15, 15, 15)

SWEP.vbwPos = Vector(0, -1, -7)
SWEP.vbwAng = Angle(-90, 90, 180)
SWEP.vbwModelScale = 0.8

function SWEP:vbwFunc(ply)
	local ent = ply:GetWeapon("medkit")
	if ent and ent.vbwActive then return self.vbwPos, self.vbwAng end

	return self.vbwPos2, self.vbwAng2
end

SWEP.dwmModeScale = 1
SWEP.dwmForward = 3
SWEP.dwmRight = 0.3
SWEP.dwmUp = 0

SWEP.dwmAUp = 0
SWEP.dwmARight = 180
SWEP.dwmAForward = 90