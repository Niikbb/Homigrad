local function SendFiles(path)
	local files, dirs = file.Find("addons/homigrad/materials/" .. path .. "*", "GAME")

	for _, v in pairs(files) do
		if string.sub(v, #v - 2, #v) == "png" then
			resource.AddSingleFile("materials/" .. path .. v)
		end
	end

	for _, dir in pairs(dirs) do
		SendFiles(path .. dir .. "/")
	end
end

SendFiles("")