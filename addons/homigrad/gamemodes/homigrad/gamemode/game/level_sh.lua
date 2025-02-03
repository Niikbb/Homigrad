LevelList = {}

function TableRound(name) return _G[name or roundActiveName] end

timer.Simple(0,function()
    if roundActiveName == nil and string.find(string.lower(game.GetMap()), "rp_lone_pine") then
        roundActiveName = "ww2"
        roundActiveNameNext = "ww2"
        StartRound()
    elseif roundActiveName == nil and not string.find(string.lower(game.GetMap()), "rp_lone_pine") then
        roundActiveName = "homicide"
        roundActiveNameNext = "homicide"
        StartRound()
    end
end)

timer.Simple(0,function()
    if string.find(string.lower(game.GetMap()), "rp_lone_pine") then
        print("На данной карте форсирован режим - World War 2")
        roundActiveNameNext = "ww2"
    end
end)