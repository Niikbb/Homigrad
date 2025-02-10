--[[ This function iterates through all entities and removes any that are weapons.
local function RemoveMapWeapons()
	for _, ent in ipairs(ents.GetAll()) do
		if ent:IsWeapon() then
			ent:Remove()
		end
	end
end

-- Call the function immediately when the map loads.
hook.Add("Initialize", "RemoveMapWeaponsOnLoad", RemoveMapWeapons)

-- Call the function again after entities have been fully initialized.
hook.Add("PostCleanupMap", "RemoveMapWeaponsAfterCleanup", RemoveMapWeapons)
]]