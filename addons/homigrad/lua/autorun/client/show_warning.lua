if engine.ActiveGamemode() ~= "homigrad" then return end

hook.Add("InitPostEntity", "hg_BindFakeCommandWarning", function()
	if cookie.GetString("jhg_bindfakewarning") == "1" then return end

	local frame = vgui.Create("DFrame")
	frame:SetTitle("#hg.warning.title")
	frame:ShowCloseButton(false)
	frame:SetSize(400, 250)
	frame:Center()
	frame:MakePopup()

	-- Create frame text
	local text = vgui.Create("DLabel", frame)
	text:SetPos(10, 20)
	text:SetSize(360, 120)
	text:SetText("#hg.warning.text")
	text:SetWrap(true)
	text:SetContentAlignment(5)

	-- Create the checkbox
	local checkBox = vgui.Create("DCheckBoxLabel", frame)
	checkBox:SetPos(10, 165)
	checkBox:SetText("#hg.warning.check")
	checkBox:SetValue(0)
	checkBox:SizeToContents()

	-- Create a close button to close the window
	local closeButton = vgui.Create("DButton", frame)
	closeButton:SetText("#hg.warning.button")
	closeButton:SetPos(120, 200)
	closeButton:SetSize(150, 30)
	closeButton:SetEnabled(false)

	-- Enable confirm button only if checkbox is checked and `fake` is binded
	checkBox.OnChange = function()
		if closeButton:IsEnabled() then
			closeButton:SetEnabled(false)
		else
			closeButton:SetEnabled(true)
		end
	end

	-- Define the action for closeButton
	-- Don't allow player to skip this part until he actually binds `fake`
	closeButton.DoClick = function()
		if input.LookupBinding("fake") then
			cookie.Set("jhg_bindfakewarning", "1")

			frame:Close()
		else
			closeButton:SetText("#hg.warning.no")
			timer.Simple(2, function() if IsValid(closeButton) then closeButton:SetText("#hg.warning.button") end end)
		end
	end
end)