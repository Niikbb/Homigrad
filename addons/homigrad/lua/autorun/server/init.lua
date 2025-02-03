util.AddNetworkString( "SIX.SIDETO" )
SIX = SIX or {}

CreateConVar( "lean_speed", 5, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_CLIENTCMD_CAN_EXECUTE } )
CreateConVar( "lean_strength", 11, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_CLIENTCMD_CAN_EXECUTE } )

local cvar_st = GetConVar( "lean_strength" ):GetInt()

net.Receive("SIX.SIDETO", function(len, pl)
    local side = net.ReadInt(3)
    cvar_st = GetConVar( "lean_strength" ):GetInt() -- updating

    if side == 1 then
        side = -cvar_st * 2.1
    elseif side == 2 then
        side = cvar_st * 2.1
    elseif side == 0 then
        side = 0
    end

    if not SIX[pl:SteamID()] then
        SIX[pl:SteamID()] = {
            pl = pl,
            side = side,
            angle = 0.01,
            oldangle = 0,
        }
    end
    SIX[pl:SteamID()].side = side
end)

hook.Add("Think","SIX.SENDTOSIDE",function()
    for k, v in pairs(SIX) do

        if not IsValid(v.pl) or SIX[k].angle == 0 then
            SIX[k] = nil
            continue
        end

        SIX[k].angle = Lerp(GetConVar( "lean_speed" ):GetInt()/100,SIX[k].oldangle,SIX[k].side)

        SIX[k].oldangle = SIX[k].angle

        v.pl:ManipulateBoneAngles( 2, Angle( SIX[k].angle,0,0 ) )

    end
end)

hook.Add("PreGamemodeLoaded", "widgets_disabler_cpu", function()
    function widgets.PlayerTick() end
    hook.Remove("PlayerTick", "TickWidgets")
end)

hook.Add("InitPostEntity","RemoveShittyHooks",function()
	local phys_settings = physenv.GetPerformanceSettings()

	phys_settings.LookAheadTimeObjectsVsObject = 0 -- 0.5
	phys_settings.LookAheadTimeObjectsVsWorld = 0.1 -- 1
	phys_settings.MaxAngularVelocity = 3600 -- 7272.7275390625
	phys_settings.MaxCollisionChecksPerTimestep = 100 -- 50000
	phys_settings.MaxCollisionsPerObjectPerTimestep = 1 -- 10
	phys_settings.MaxFrictionMass = 2500 -- 2500
	phys_settings.MaxVelocity = 768 -- 4000
	phys_settings.MinFrictionMass = 100 -- 10

	physenv.SetPerformanceSettings(phys_settings)
end)