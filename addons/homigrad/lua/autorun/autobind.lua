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

		if not tbl[ply:SteamID()] then
			-- Send net message to client to show window
			net.Start("ShowWelcomeWindow")
			net.Send(ply)

			tbl[ply:SteamID()] = true

			-- Add info that player saw the window
			file.Write(window_file, util.TableToJSON(tbl))
		end
	end)
else
	net.Receive("ShowWelcomeWindow", function()
		-- Create the window frame
		local frame = vgui.Create("DFrame")
		frame:SetTitle("IMPORTANT!!! PLEASE READ!!!")
		frame:SetSize(400, 250)
		frame:Center()
		frame:MakePopup()

		-- Create a label for the paragraph text
		local text = vgui.Create("DLabel", frame)
		text:SetPos(10, 20)
		text:SetSize(360, 120)
		text:SetText([[Homigrad uses a mechanic called 'faking', which is the cornerstone and epitome of the Homigrad gamemode.

Without binding a key to the `fake` command, you will not be able to play the game effectively.

Please type 'bind g fake' into your console, which will make G the key you use to get up or ragdoll on command.]])
		text:SetWrap(true)
		text:SetContentAlignment(5)
		-- Create the checkbox
		local checkBox = vgui.Create("DCheckBoxLabel", frame)
		checkBox:SetPos(10, 165)
		checkBox:SetText("I have read & completed the above instructions, which will allow me\nto play the game as intended.")
		checkBox:SetValue(0)
		checkBox:SizeToContents()
		-- Create a close button to close the window
		local closeButton = vgui.Create("DButton", frame)
		closeButton:SetText("I'm ready!")
		closeButton:SetPos(120, 200)
		closeButton:SetSize(150, 30)
		closeButton:SetEnabled(false)

		-- Enable confirm button only if checkbox is checked
		checkBox.OnChange = function(checked)
			closeButton:SetEnabled(checked)
		end

		-- Define the action for closeButton (just closes the window)
		closeButton.DoClick = function()
			frame:Close()
		end
	end)
end