if SERVER then
	-- Create a unique identifier for checking if the player has seen the window.
	util.AddNetworkString("ShowWelcomeWindow")

	-- Check if the player has already joined the server before
	hook.Add("PlayerInitialSpawn", "ShowWindowOncePerPlayer", function(ply)
		if ply:IsBot() then return end

		local window_file = "homigrad/window_showed.txt"
		if not file.Exists(window_file, "DATA") then file.Write(window_file, "{}") end

		local window_file_content = file.Read(window_file, "DATA")
		local tbl = util.JSONToTable(window_file_content)

		if not tbl[ply:SteamID64()] then
			-- Send net message to client to show window
			net.Start("ShowWelcomeWindow")
			net.Send(ply)

			tbl[ply:SteamID64()] = true

			-- Add info that player saw the window
			file.Write(window_file, util.TableToJSON(tbl))
		end
	end)
else
	net.Receive("ShowWelcomeWindow", function()
		local frame = vgui.Create("DFrame")
		frame:SetTitle(language.GetPhrase("hg.warning.title"))
		frame:ShowCloseButton(false)
		frame:SetSize(400, 250)
		frame:Center()
		frame:MakePopup()

		local text = vgui.Create("DLabel", frame)
		text:SetPos(10, 20)
		text:SetSize(360, 120)
		text:SetText(language.GetPhrase("hg.warning.text"))
		text:SetWrap(true)
		text:SetContentAlignment(5)
		-- Create the checkbox
		local checkBox = vgui.Create("DCheckBoxLabel", frame)
		checkBox:SetPos(10, 165)
		checkBox:SetText(language.GetPhrase("hg.warning.check"))
		checkBox:SetValue(0)
		checkBox:SizeToContents()
		-- Create a close button to close the window
		local closeButton = vgui.Create("DButton", frame)
		closeButton:SetText(language.GetPhrase("hg.warning.button"))
		closeButton:SetPos(120, 200)
		closeButton:SetSize(150, 30)
		closeButton:SetEnabled(false)

		-- Enable confirm button only if checkbox is checked
		checkBox.OnChange = function()
			if closeButton:IsEnabled() then 
				closeButton:SetEnabled(false)
			else 
				closeButton:SetEnabled(true) 
			end
		end
		-- Define the action for closeButton (just closes the window)
		closeButton.DoClick = function()
			frame:Close()
		end
	end)
end