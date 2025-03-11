AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("TTT_ConfirmUseTButton")
ENT.RemoveOnPress = false
ENT.Model = Model("models/weapons/w_bugbait.mdl")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetNoDraw(true)
    self:DrawShadow(false)
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetDelay(self.RawDelay or 1)

    if self:GetDelay() < 0 then
        self.RemoveOnPress = true
    end

    if self.RemoveOnPress then
        self:SetDelay(-1)
    end

    if self:GetUsableRange() < 1 then
        self:SetUsableRange(1024)
    end

    self:SetNextUseTime(0)
    self:SetLocked(self:HasSpawnFlags(2048))
    self:SetDescription(self.RawDescription or "?")

    self.RawDelay = nil
    self.RawDescription = nil
end

function ENT:KeyValue(key, value)
    if key == "OnPressed" then
        self:StoreOutput(key, value)
    elseif key == "wait" then
        self.RawDelay = tonumber(value)
    elseif key == "description" then
        self.RawDescription = tostring(value)
        if self.RawDescription and string.len(self.RawDescription) < 1 then
            self.RawDescription = nil
        end
    elseif key == "RemoveOnPress" then
        self[key] = tobool(value)
    else
        self:SetNetworkKeyValue(key, value)
    end
end

function ENT:AcceptInput(name, activator)
    if name == "Toggle" then
        self:SetLocked(not self:GetLocked())
        return true
    elseif name == "Hide" or name == "Lock" then
        self:SetLocked(true)
        return true
    elseif name == "Unhide" or name == "Unlock" then
        self:SetLocked(false)
        return true
    end
end

function GAMEMODE:TTTCanUseTraitorButton(ent, ply)
    return true
end

function ENT:TraitorUse(ply)
    if not IsValid(ply) then
        return false
    end
    if not self:IsUsable() then
        return false
    end

    if self:GetPos():Distance(ply:GetPos()) > self:GetUsableRange() then
        return false
    end

    local use, message = hook.Run("TTTCanUseTraitorButton", self, ply)
    if not use then
        if message then 
            TraitorMsg(ply, message)
        end
        return false
    end

    net.Start("TTT_ConfirmUseTButton")
    net.Send(ply)
    self:TriggerOutput("OnPressed", ply)

    if self.RemoveOnPress then
        self:SetLocked(true)
        self:Remove()
    else
        self:SetNextUseTime(CurTime() + self:GetDelay())
    end

    hook.Run("TTTTraitorButtonActivated", self, ply)
    return true
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

local function TraitorUseCmd(ply, cmd, args)
    if #args ~= 1 then
        return
    end
    if IsValid(ply) then
        local idx = tonumber(args[1])
        if idx then
            local ent = Entity(idx)
            if IsValid(ent) and ent:GetClass() == "ttt_traitor_button" and ent.TraitorUse then
                ent:TraitorUse(ply)
            end
        end
    end
end

concommand.Add("ttt_use_tbutton", TraitorUseCmd)