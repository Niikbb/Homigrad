if GetConVar("sv_construct"):GetBool() == true then 
    table.insert(LevelList,"construct") 
end

construct = {}
construct.Name = "Construct"
construct.LoadScreenTime = 0
construct.NoSelectRandom = true

local red = Color(155,155,255)

function construct.GetTeamName(ply)
    local teamID = ply:Team()

     if teamID == 1 then return "Builder",red end -- Corny ass name
end

function construct.StartRound(data)
    team.SetColor(1,red)
    --team.SetColor(2,blue)
    --team.SetColor(1,green)
    game.CleanUpMap(false)

    if CLIENT then
        roundTimeStart = data[1]
        roundTime = data[2]
        construct.StartRoundCL()
        return
    end

    return construct.StartRoundSV()
end

if SERVER then return end
local kill = 4
local white,red = Color(255,255,255),Color(255,0,0)
local fuck,fuckLerp = 0,0

local playsound = false
function construct.StartRoundCL()
    playsound = true
end

function construct.HUDPaint_RoundLeft(white)
    local lply = LocalPlayer()
	local startRound = roundTimeStart + 5 - CurTime()

    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,220),0.5,4)
        return
    end
end


-- For construct, this is probably fine because I assume that it will just force respawn the player.
net.Receive("construct_die",function()
    timeStartAnyDeath = CurTime()
end)

function construct.CanUseSpectateHUD() return false end

construct.RoundRandomDefalut = 3