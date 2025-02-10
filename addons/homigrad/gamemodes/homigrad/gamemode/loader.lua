AddCSLuaFile()

local string_sub = string.sub
local string_split = string.Split
local string_GetFileFromFilename = string.GetFileFromFilename

function GM.includeFile(path)
	local fileName = string_GetFileFromFilename(path)
	if string_sub(fileName, 1, 1) == "!" then return end -- Don't load file if it starts with `!`

	local prefix = string_sub(fileName, 1, 3)

	if prefix ~= "sv_" and prefix ~= "cl_" and prefix ~= "sh_" then
		prefix = string_sub(fileName, #fileName - 6, #fileName - 4)

		if string_sub(prefix, 1, 1) == "_" then
			prefix = string_sub(prefix, 2, 3) .. "_"
		end
	end

	if prefix ~= "sv_" and prefix ~= "cl_" and prefix ~= "sh_" then return end -- If no prefix don't load

	if prefix == "cl_" then
		if SERVER then
			AddCSLuaFile(path)
		else
			result = include(path)
		end
	end

	if SERVER and prefix == "sv_" then
		result = include(path)
	end

	if prefix == "sh_" then
		if SERVER then
			AddCSLuaFile(path)
		end

		result = include(path)
	end

	return result
end

local file_Find = file.Find
local hg_includeFile = GM.includeFile
local hg_includeDir

INCLUDE_BREAK = 1

function GM.includeDir(path, includes)
	includes = includes or {}
	if includes[path] then return end
	includes[path] = path

	local _files, _dirs = file_Find(path .. "*", "LUA")
	local files, dirs, tier_files, tier_dirs = {}, {}, {}, {}
	local v, v2, tier

	for i = 1, #_files do
		v = _files[i]

		tier = nil

		for _, sum in pairs(string_split(v, "_")) do
			if tier then
				sum = string.gsub(sum, ".lua", "")
				tier = tonumber(sum)

				break
			end

			if sum == "tier" then
				tier = true
			end
		end

		if tier then
			v2 = tier_files[tier]

			if not v2 then
				v2 = {}
				tier_files[tier] = v2
			end

			v2[#v2 + 1] = v
			continue
		end

		files[#files + 1] = v
	end

	for i = 1, #_dirs do
		v = _dirs[i]
		tier = nil

		for _, sum in pairs(string_split(v, "_")) do
			if tier then
				tier = tonumber(sum)

				break
			end

			if sum == "tier" then
				tier = true
			end
		end

		if tier then
			v2 = tier_dirs[tier]

			if not v2 then
				v2 = {}
				tier_dirs[tier] = v2
			end

			v2[#v2 + 1] = v .. "/"

			continue
		end

		dirs[#dirs + 1] = v .. "/"
	end

	local result
	local empty = {}

	for tier = 0, #tier_files do
		v2 = tier_files[tier] or empty

		for i = 1, #v2 do
			result = hg_includeFile(path .. v2[i])
			if result == INCLUDE_BREAK then return end
		end
	end

	for i = 1, #files do
		result = hg_includeFile(path .. files[i])
		if result == INCLUDE_BREAK then return end
	end

	for tier = 0, #tier_dirs do
		v2 = tier_dirs[tier] or empty

		for i = 1, #v2 do
			hg_includeDir(path .. v2[i], includes)
		end
	end

	for i = 1, #dirs do
		hg_includeDir(path .. dirs[i], includes)
	end
end

hg_includeDir = GM.includeDir

hg.modesHooks = {}

local function LoadModes()
	for _, name in pairs(LevelList) do
		local mode = _G[name]

		for k, v2 in pairs(mode) do
			if isfunction(v2) then
				hg.modesHooks[name] = hg.modesHooks[name] or {}
				hg.modesHooks[name][k] = v2
			end
		end
	end
end

hg.LoadModes = LoadModes

local oldHook = oldHook or hook.Call

function hook.Call(name, gm, ...)
	local Current = roundActiveName

	if hg.modesHooks[Current] and hg.modesHooks[Current][name] then
		local a, b, c, d, e, f = hg.modesHooks[Current][name](...)
		if a ~= nil then return a, b, c, d, e, f end
	end

	return oldHook(name, gm, ...)
end