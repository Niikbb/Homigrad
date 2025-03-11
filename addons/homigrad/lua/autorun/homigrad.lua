if engine.ActiveGamemode() ~= "homigrad" then return end

hg = hg or {}

include("homigrad_scr/loader.lua")
-- if SERVER then include("homigrad_scr/run_serverside.lua") end
include("homigrad_scr/run.lua")