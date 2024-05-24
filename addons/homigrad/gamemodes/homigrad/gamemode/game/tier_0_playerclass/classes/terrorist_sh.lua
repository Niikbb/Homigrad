local CLASS = player.RegClass("terrorist")

CLASS.main_weapons = {
    "weapon_sar2","weapon_spas12","weapon_mp7"
}

function CLASS.Off(self)
    if CLIENT then return end

    self.isCombine = nil
    self.cantUsePer4ik = nil
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel("models/player/leet.mdl")
    self:SetWalkSpeed(250)
    self:SetRunSpeed(350)

    self:SetHealth(150)
    self:SetMaxHealth(150)
end

local function getList(self)
    local list = {}

    for i,ply in RandomPairs(player.GetAll()) do
        if ply == self or not ply.isCombine then continue end
        
        local pos = ply:EyePos()
        local deathPos = self:GetPos()

        if pos:Distance(deathPos) > 1000 then continue end

        local trace = {start = pos}
        trace.endpos = deathPos
        trace.filter = ply
        
        if util.TraceLine(trace).HitPos:Distance(deathPos) <= 512 then
            list[#list + 1] = ply
        end
    end

    return list
end