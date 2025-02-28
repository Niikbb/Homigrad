if not engine.ActiveGamemode() == "homigrad" then return end
blood = 5000
adrenaline = 0

net.Receive("info_blood",function()
	blood = net.ReadFloat()
end)

net.Receive("info_adrenaline",function()
	adrenaline = net.ReadFloat()
end)

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects","Blood_Effect_CL",function()
	if not LocalPlayer():Alive() then return end
	local fraction = math.Clamp(1 - ((blood - 3000) / ((5000 - 1400) - 2000)),0,1)
	DrawToyTown(fraction * 4, ScrH())
	DrawColorModify(tab)
	DrawSharpen(5,adrenaline / 5)
	if fraction <= 0.7 then return end
	DrawMotionBlur(0.2,0.9,0.03)
end)

net.Receive("organism_info",function(len)
	local organs = net.ReadTable()
	local stringinfo = net.ReadString()
	PrintTable(organs)
	print(stringinfo)
end)

hook.Add("ScalePlayerDamage","no_effects",function(ent,dmginfo)
	return true
end)