LevelList = {}

function TableRound(name) return _G[name or roundActiveName] end

timer.Simple(0,function()
    if roundActiveName == nil then
        roundActiveName = "homicide"
        roundActiveNameNext = "homicide"
        StartRound()
    end
end)

timer.Simple(0,function()
    if string.find(string.lower(game.GetMap()), "rp_lone_pine") then -- такая хуйня чтоб режим форсировать это ужас
        print("На данной карте форсирован режим - World War 2")
        roundActiveName = "ww2"
        roundActiveNameNext = "ww2"
        table.Empty(LevelList)
        table.insert(LevelList,"ww2")
    end
end)