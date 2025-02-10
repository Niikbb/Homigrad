include("shared.lua")

local healsound = "snd_jack_bandage.wav"

function SWEP:Heal(ent)
	if not ent or not ent:IsPlayer() then
		sound.Play(healsound, ent:GetPos(), 75, 100, 0.5)

		return true
	end

	if ent.LeftLeg < 1 then
		ent.LeftLeg = 1

		sound.Play(healsound, ent:GetPos(), 75, 100, 0.5)

		return true
	elseif ent.RightLeg < 1 then
		ent.RightLeg = 1

		sound.Play(healsound, ent:GetPos(), 75, 100, 0.5)

		return true
	elseif ent.RightArm < 1 then
		ent.RightArm = 1

		sound.Play(healsound, ent:GetPos(), 75, 100, 0.5)

		return true
	elseif ent.LeftArm < 1 then
		ent.LeftArm = 1

		sound.Play(healsound, ent:GetPos(), 75, 100, 0.5)

		return true
	end

	return false
end