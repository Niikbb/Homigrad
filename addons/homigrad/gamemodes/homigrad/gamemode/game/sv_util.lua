local GetAll = player.GetAll
local max, abs, min = math.max, math.abs, math.min

LimitAutoBalance = 1

function NeedAutoBalance(addT, addCT)
	addT = addT or 0
	addCT = addCT or 0

	local count = (#team.GetPlayers(1) + addT) - (#team.GetPlayers(2) + addCT)
	if count == 0 then return end

	local favorT

	if count > 0 then
		favorT = true
	end

	local limit = min(#GetAll() - LimitAutoBalance - 1, LimitAutoBalance)
	count = max(abs(count) - limit, 0)
	if count == 0 then return end

	return favorT, count
end

function AutoBalanceTwoTeam()
	for _ in pairs(GetAll()) do
		local favorT, count = NeedAutoBalance()
		if not count then break end

		if favorT then
			local ply = team.GetPlayers(1)[math.random(#team.GetPlayers(1))]
			--local ply = math.random(#team.GetPlayers(1))
			ply:SetTeam(2)
		else
			local ply = team.GetPlayers(2)[math.random(#team.GetPlayers(2))]
			--local ply = math.random(#team.GetPlayers(2))
			ply:SetTeam(1)
		end
	end
end

local table_CopyFromTo = table.CopyFromTo

function OpposingAllTeam()
	local oldT, oldCT = {}, {}

	table_CopyFromTo(team.GetPlayers(1), oldT)
	table_CopyFromTo(team.GetPlayers(2), oldCT)

	for _, ply in pairs(oldT) do
		ply:SetTeam(math.random(2))
	end

	for _, ply in pairs(oldCT) do
		ply:SetTeam(math.random(2))
	end
end