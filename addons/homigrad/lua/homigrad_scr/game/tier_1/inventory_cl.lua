local blackListedAmmo = {
	[8] = true,
	[9] = true,
	[10] = true
}

local AmmoTypes = {
	[47] = "vgui/hud/hmcd_round_792",
	[44] = "vgui/hud/hmcd_round_792",
	[2] = "vgui/hud/hmcd_health",
	[48] = "vgui/hud/hmcd_round_9",
	[45] = "vgui/hud/hmcd_round_556",
	[38] = "vgui/hud/hmcd_round_38",
	[6] = "vgui/hud/hmcd_round_arrow",
	[41] = "vgui/hud/hmcd_round_12",
	[8] = "vgui/wep_jack_hmcd_oldgrenade",
	[9] = "vgui/wep_jack_hmcd_oldgrenade",
	[10] = "vgui/wep_jack_hmcd_oldgrenade",
	[11] = "vgui/wep_jack_hmcd_ied"
}

local black = Color(0, 0, 0, 128)
local black2 = Color(64, 64, 64, 128)

local function getText(text, limitW)
	local newText = {}
	local newText_I = 1
	local curretText = ""

	surface.SetFont("DefaultFixedDropShadow")

	for i = 1, #text do
		local sumbol = string.sub(text, i, i)
		local w, _ = surface.GetTextSize(curretText .. sumbol)

		if w >= limitW then
			newText_I = newText_I + 1
			curretText = sumbol
		else
			curretText = curretText .. sumbol
		end

		newText[newText_I] = curretText
	end

	return newText
end

local panel
net.Receive("inventory", function()
	if IsValid(panel) then
		panel.override = true
		panel:Remove()
	end

	local lootEnt = net.ReadEntity()
	if lootEnt:GetClass() == "prop_ragdoll" then lootEnt = lootEnt:GetNWEntity("OldRagdollController") end -- If player is dead (lootEnt is prop_ragdoll) return who's ragdoll it was

	if not GetConVar("hg_lootalive"):GetBool() and lootEnt:Alive() then return end

	local success, items = pcall(net.ReadTable)
	if not success or not lootEnt then return end

	local nickname = lootEnt:IsPlayer() and lootEnt:Name() or lootEnt:GetNWString("Nickname") or ""

	if IsValid(lootEnt:GetNWEntity("ActiveWeapon")) and items[lootEnt:GetNWEntity("ActiveWeapon"):GetClass()] then items[lootEnt:GetNWEntity("ActiveWeapon"):GetClass()] = nil end

	local items_ammo = net.ReadTable()

	items.weapon_hands = nil

	panel = vgui.Create("DFrame")
	panel:SetAlpha(255)
	panel:SetSize(500, 400)
	panel:Center()
	panel:SetDraggable(false)
	panel:MakePopup()
	panel:SetTitle("")
	function panel:OnKeyCodePressed(key)
		if key == KEY_W or key == KEY_S or key == KEY_A or key == KEY_D then self:Remove() end
	end

	function panel:OnRemove()
		if self.override then return end

		net.Start("inventory")
			net.WriteEntity(lootEnt)
		net.SendToServer()
	end

	panel.Paint = function(self, w, h)
		if not IsValid(lootEnt) or not LocalPlayer():Alive() then return panel:Remove() end

		draw.RoundedBox(0, 0, 0, w, h, black)
		surface.SetDrawColor(255, 255, 255, 128)
		surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
		draw.SimpleText(language.GetPhrase("hg.inventory.title"):format(nickname), "DefaultFixedDropShadow", 6, 6, color_white)
	end

	local x, y = 40, 40
	local corner = 6

	for wep, weapon in pairs(items) do
		local button = vgui.Create("DButton", panel)
		button:SetPos(x, y)
		button:SetSize(64, 64)
		x = x + button:GetWide() + 6
		if x + button:GetWide() >= panel:GetWide() then
			x = 40
			y = y + button:GetTall() + 6
		end
		button:SetText("")

		local text = weapon.PrintName or wep
		text = getText(text, button:GetWide() - corner * 2)

		button.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and black2 or black)
			surface.SetDrawColor(255, 255, 255, 128)
			surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

			for i, text in pairs(text) do
				draw.SimpleText(text, "DefaultFixedDropShadow", corner, corner + (i - 1) * 12, color_white)
			end

			local x, y = self:LocalToScreen(0, 0)
			DrawWeaponSelectionEX(weapon, x, y, w, h)
		end

		function button:OnRemove()
			if IsValid(model) then model:Remove() end
		end

		button.DoClick = function()
			net.Start("ply_take_item")
				net.WriteEntity(lootEnt)
				net.WriteString(wep)
			net.SendToServer()
		end

		button.DoRightClick = button.DoClick
	end

	for ammo, _ in pairs(items_ammo) do
		if blackListedAmmo[ammo] then continue end

		local button = vgui.Create("DButton", panel)
		button:SetPos(x, y)
		button:SetSize(64, 64)
		x = x + button:GetWide() + 6
		if x + button:GetWide() >= panel:GetWide() then
			x = 40
			y = y + button:GetTall() + 6
		end

		button:SetText("")
		local text = game.GetAmmoName(ammo)
		text = getText(text, button:GetWide() - corner * 2)

		button.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and black2 or black)
			surface.SetDrawColor(255, 255, 255, 128)
			surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

			local round = Material(AmmoTypes[tonumber(ammo)] or "vgui/hud/hmcd_person", "noclamp smooth")

			surface.SetMaterial(round)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(2, 2, w - 4, h - 4)

			for i, text in pairs(text) do
				draw.SimpleText(text, "DefaultFixedDropShadow", corner, corner + (i - 1) * 12, color_white)
			end
		end

		button.DoClick = function()
			net.Start("ply_take_ammo")
				net.WriteEntity(lootEnt)
				net.WriteFloat(tonumber(ammo))
			net.SendToServer()
		end

		button.DoRightClick = button.DoClick
	end
end)