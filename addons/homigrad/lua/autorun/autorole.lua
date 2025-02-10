--[[ You can uncomment this file if you want this functionality
-- Define the time threshold in seconds (12 hours = 43200 seconds)
local TIME_THRESHOLD = 43200

-- Function to get a player's total time using UTime
local function GetPlayerTime(ply)
	-- Retrieve UTime and UTimeCurTime from the player
	local pastTime = ply:GetNWInt("UTime", 0)
	local currentSessionTime = CurTime() - ply:GetNWInt("UTimeStart", 0)

	-- Calculate the total time spent (past + current session)
	return pastTime + currentSessionTime
end

-- Function to check player's time and assign to a group if they reach the threshold
local function CheckAndAssignGroup(ply)
	local totalTime = GetPlayerTime(ply)

	-- If the player has reached or exceeded the threshold
	if totalTime >= TIME_THRESHOLD then
		-- Assign the player to a ULX group, e.g., "veteran"
		if ply:IsUserGroup("user") then
			RunConsoleCommand("ulx", "adduser", ply:Nick(), "regular")
			-- RunConsoleCommand("ulx", "playsound", "package.wav")
			ply:ChatPrint("Congratulations! You have been promoted to the 'Regular' group for your time on the server.")
		end
	end
end

-- Function to start tracking time when a player joins
local function OnPlayerInitialSpawn(ply)
	-- Check if the player already qualifies for the time-based group
	CheckAndAssignGroup(ply)
end

hook.Add("PlayerInitialSpawn", "TrackPlayTime", OnPlayerInitialSpawn)
--]]