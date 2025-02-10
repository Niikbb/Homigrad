COMMANDS = COMMANDS or {}

function COMMAND_FAKEPLYCREATE()
	local fakePly = {}

	function fakePly:IsValid()
		return true
	end

	function fakePly:IsAdmin()
		return true
	end

	function fakePly:GetUserGroup()
		return "superadmin"
	end

	function fakePly:Name()
		return "FakePlayer"
	end

	fakePly.fakePly = true

	return fakePly
end

local plyServer = COMMAND_FAKEPLYCREATE()
local speak = {}

local validUserGroupSuperAdmin = {
	superadmin = true,
	servermanager = true,
	owner = true,
	admin = true,
	headmod = true
}

local validUserGroup = {
	supporter = true,
	supporterplus = true,
	sponsor = true,
	operator = true,
	tmod = true
}

function COMMAND_GETASSES(ply)
	local group = ply:GetUserGroup()

	if validUserGroup[group] then
		return 1 -- Donator & Admin Permissions
	elseif validUserGroupSuperAdmin[group] then
		return 2 -- Superadmin only
	end

	return 0 -- Everyone
end

function COMMAND_ASSES(ply, cmd)
	local access = cmd[2] or 1
	if access ~= 0 and COMMAND_GETASSES(ply) < access then return end

	return true
end

function COMMAND_GETARGS(args)
	local newArgs = {}
	local waitClose, waitCloseText

	for _, text in pairs(args) do
		if not waitClose and string.sub(text, 1, 1) == "\"" then
			waitClose = true

			if string.sub(text, #text, #text) == "\n" then
				newArgs[#newArgs + 1] = string.sub(text, 2, #text - 1)
				waitClose = nil
			else
				waitCloseText = string.sub(text, 2, #text)
			end

			continue
		end

		if waitClose then
			if string.sub(text, #text, #text) == "\"" then
				waitClose = nil
				newArgs[#newArgs + 1] = waitCloseText .. string.sub(text, 1, #text - 1)
			else
				waitCloseText = waitCloseText .. string.sub(text, 1, #text)
			end

			continue
		end

		newArgs[#newArgs + 1] = text
	end

	return newArgs
end

function PrintMessageChat(id, text)
	timer.Simple(0, function()
		if type(id) == "table" or type(id) == "Player" then
			if not IsValid(id) then return end

			id:ChatPrint(text)
		else
			PrintMessage(id, text)
		end
	end)
end

function COMMAND_Input(ply, args)
	local cmd = COMMANDS[args[1]]
	if not cmd then return false end
	if not COMMAND_ASSES(ply, cmd) then return true, false end

	table.remove(args, 1)

	return true, cmd[1](ply, args)
end

concommand.Add("hg_say", function(ply, cmd, args, text)
	if not IsValid(ply) then ply = plyServer end

	COMMAND_Input(ply, COMMAND_GETARGS(string.Split(text, " ")))
end)

hook.Add("PlayerCanSeePlayersChat", "AddSpawn", function(text, _, _, ply)
	if not IsValid(ply) then ply = plyServer end
	if speak[ply] then return end

	speak[ply] = true

	COMMAND_Input(ply, COMMAND_GETARGS(string.Split(string.sub(text, 2, #text), " ")))

	-- local func = TableRound().ShouldDiscordOutput
	-- if ply.fakePly or not func or (func and func(ply, text) == nil) then end
end)

hook.Add("Think", "Speak Chat Shit", function()
	for k in pairs(speak) do
		speak[k] = nil
	end
end)

COMMANDS.help = {
	function(ply, args)
		local text = ""

		if args[1] then
			local cmd = COMMANDS[args[1]]
			local argsList = cmd[3]
			if argsList then
				argsList = " - " .. argsList
			else
				argsList = ""
			end

			text = text .. "	" .. args[1] .. argsList .. "\n"
		else
			local list = {}

			for name in pairs(COMMANDS) do
				list[#list + 1] = name
			end

			table.sort(list, function(a, b) return a > b end)

			for _, name in pairs(list) do
				local cmd = COMMANDS[name]
				if not COMMAND_ASSES(ply, cmd) then continue end

				local argsList = cmd[3]
				if argsList then
					argsList = " - " .. argsList
				else
					argsList = ""
				end

				text = text .. "	" .. name .. argsList .. "\n"
			end
		end

		text = string.sub(text, 1, #text - 1)

		ply:ChatPrint(text)
	end,
	0
}

function player.GetListByName(name, plr)
	local tbl = {}

	if name == "^" then
		return {plr}
	elseif name == "*" then
		return player.GetAll()
	end

	for _, ply in player.Iterator() do
		if string.find(string.lower(ply:Name()), string.lower(name)) then tbl[#tbl + 1] = ply end
	end

	return tbl
end

COMMANDS.submat = {
	function(ply, args)
		if not ply:IsAdmin() then return end

		if args[2] == "^" then
			ply:SetSubMaterial(tonumber(args[1], 10), args[2])
		end
	end
}