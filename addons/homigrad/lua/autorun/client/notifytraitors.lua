-- Client-side code to receive traitor positions and draw markers

net.Receive("SendTraitorPositions", function()
	local traitors = net.ReadTable()

	hook.Add("HUDPaint", "DrawTraitorMarkers", function()
		for _, traitor in pairs(traitors) do
			local pos = traitor.pos:ToScreen()

			-- Draw a red marker on the screen at the traitor's position
			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawRect(pos.x - 10, pos.y - 10, 20, 20)

			-- Draw the traitor's name
			draw.SimpleText(traitor.name, "Default", pos.x, pos.y - 20, Color(255, 0, 0), TEXT_ALIGN_CENTER)
		end
	end)
end)