include("shared.lua")

local healsound = "snd_jack_hmcd_bandage.wav"

function SWEP:Heal(ent)
	if not ent or not ent:IsPlayer() and table.HasValue(BleedingEntities, ent) then
		sound.Play(healsound1, ent:GetPos(), 75, 100, 0.5)

		return true
	end

	if ent.Bloodlosing > 0 then
		ent.Bloodlosing = math.max(ent.Bloodlosing - 65, 0)

		ent:EmitSound(healsound)

		return true
	end

	return
end