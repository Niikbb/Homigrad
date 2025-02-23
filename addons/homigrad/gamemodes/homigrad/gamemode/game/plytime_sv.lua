util.AddNetworkString("Time Ply")

local data = util.JSONToTable(file.Read("homigrad/plytime.txt", "DATA") or "") or {}

local function sync(ply, time, send)
	net.Start("Time Ply")
	net.WriteEntity(ply)
	net.WriteString(tostring(time))

	if send then net.Send(send)
	else net.Broadcast() end
end

hook.Add("PlayerInitialSpawn", "Time", function(ply)
	if ply:IsBot() or !IsValid(ply) then return end
	timer.Simple(2, function()
		sync(ply, data[ply:SteamID()] or 0)

		for _, ply2 in player.Iterator() do
			sync(ply2, (data[ply2:SteamID()] or 0) + ply2:TimeConnected(), ply)
		end
	end)
end)

hook.Add("PlayerDisconnected", "Time", function(ply)
	if ply:IsBot() then return end

	data[ply:SteamID()] = (data[ply:SteamID()] or 0) + ply:TimeConnected()
	sync(ply)

	file.Write("homigrad/plytime.txt", util.TableToJSON(data))
end)