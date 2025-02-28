if SERVER then
    concommand.Add("hg_admin_virus", function(ply, cmd, args)
        if ply:IsAdmin() then
            if not args[1] then
                ply:ChatPrint("virus (ник)")
                return
            end

            local targetPlayers = player.GetListByName(args[1]) or {}

            if #targetPlayers == 0 then
                targetPlayers = { ply }
            end

            for _, fply in pairs(targetPlayers) do
                fply.virus = (fply.virus or 0) + 15
                ply:ChatPrint("заразил " .. fply:Name())
            end
        else
            ply:ChatPrint("Сначала выпроси админку.")
        end
    end, 1)

    concommand.Add("hg_admin_accessspawn", function(ply, cmd, args)
        if ply:IsAdmin() then
            SetGlobalBool("AccessSpawn", tonumber(args[1]) > 0)
            PrintMessage(3, "Q меню у всех игроков: " .. tostring(GetGlobalBool("AccessSpawn")))
        else
            if ply then
                ply:ChatPrint("Сначала выпроси админку.")
            end
        end
    end)

    concommand.Add("hg_admin_levelrandom", function(ply, cmd, args)
        local flag = tonumber(args[1])

        if flag ~= nil and (flag == 0 or flag == 1) then
            levelrandom = (flag == 1)
            PrintMessage(HUD_PRINTTALK, "Рандомизация режимов : " .. tostring(levelrandom))
        else
            if ply then ply:ChatPrint("1 0") end
        end
    end)

    concommand.Add("hg_admin_levelend", function(ply, cmd, args)
        if ply:IsAdmin() then
            EndRound()
            elseif ply then ply:ChatPrint("Сначала выпроси админку.") 
        end
    end)

    concommand.Add("hg_vote_levelend", function(ply, cmd, args)
        local calling_ply = ply
        if (calling_ply.canVoteNext or CurTime()) - CurTime() <= 0 then
            ulx.doVote("Закончить раунд?", {"No", "Yes"}, donaterVoteLevelEnd, 15, _, _, args, calling_ply, args)
        else
            if ply then ply:ChatPrint("Вам нужно подождать перед следующим голосованием.") end
        end
    end)

    concommand.Add("hg_admin_sync", function(ply, cmd, args)
        if not ply:IsAdmin() then 
            ply:ChatPrint("Сначала выпроси админку.")
            return 
        end

        local Sync = tobool(args[1])
        if Sync then
            hook.Add("PlayerDeath", "synchronisation", function(ply)
                if ply:IsAdmin() or ply:Team() == 1002 then return end
                ply:Kick(tostring(args[2] or "noob"))
            end)
            hook.Add("PlayerSilentDeath", "synchronisation", function(ply)
                if ply:IsAdmin() or ply:Team() == 1002 then return end
                ply:Kick(tostring(args[2] or "noob"))
            end)
        else
            hook.Remove("PlayerDeath", "synchronisation")
            hook.Remove("PlayerSilentDeath", "synchronisation")
        end

        PrintMessage(3, "Sync: " .. tostring(Sync))
    end)

    concommand.Add("hg_sadmin_setmaxplayers", function(ply, cmd, args)
        if not ply:IsSuperAdmin() then 
            ply:ChatPrint("Сначала выпроси админку.")
            return 
        end

        local maxPlayers = tonumber(args[1])
        if maxPlayers and maxPlayers >= 0 then
            MaxPlayers = maxPlayers
            SData_Set("maxplayers", MaxPlayers)
            RunConsoleCommand("sv_visiblemaxplayers", tostring(MaxPlayers))
            PrintMessageChat(3, "Лимит игроков: " .. tostring(MaxPlayers))
        else
            ply:ChatPrint("Говнапоешь")
        end
    end)

    concommand.Add("hg_sadmin_devmode", function(ply, cmd, args)
        if not ply:IsSuperAdmin() then 
            ply:ChatPrint("Сначала выпроси админку.")
            return 
        end

        local closeDev = tonumber(args[1]) > 0
        CloseDev = closeDev
        SData_Set("dev", tostring(CloseDev))

        if CloseDev then
            PrintMessageChat(3, "Сервер закрыт")
        else
            PrintMessageChat(3, "Сервер открыт")
        end
    end)


    concommand.Add("hg_admin_break_leg", function(ply, cmd, args)
    if not ply:IsAdmin() then
        ply:ChatPrint("Сначала выпроси админку.")
    return
    end

    local targetName = args[1]
    local leg = args[2]
    local value = tonumber(args[3])

    if not targetName or not leg or not value then
        ply:ChatPrint("Использование: break_leg <имя игрока> <left/right> <0/1>")
    return
    end

    if value ~= 0 and value ~= 1 then
        ply:ChatPrint("Значение должно быть 0 или 1.")
        return
    end

    local targetPlayer

    for _, v in ipairs(player.GetAll()) do
        if string.find(v:Nick(), targetName) then
            targetPlayer = v
            break
        end
    end

    if not targetPlayer then
        ply:ChatPrint("Игрок с таким именем не найден.")
        return
    end

    if leg == "left" then
        targetPlayer.LeftLeg = value
        targetPlayer:ChatPrint("Ваша левая нога " .. (value == 0 and "сломана." or "восстановлена."))
        PrintMessage(HUD_PRINTTALK, ply:Nick() .. " " .. (value == 0 and "сломал" or "восстановил") .. " левую ногу у " .. targetPlayer:Nick())
    elseif leg == "right" then
        targetPlayer.RightLeg = value
        targetPlayer:ChatPrint("Ваша правая нога " .. (value == 0 and "сломана." or "восстановлена."))
        PrintMessage(HUD_PRINTTALK, ply:Nick() .. " " .. (value == 0 and "сломал" or "восстановил") .. " правую ногу у " .. targetPlayer:Nick())
    else
        ply:ChatPrint("Укажите корректную ногу: левая или правая.")
        return
    end

    print(ply:Nick() .. " использовал команду break_leg на " .. targetPlayer:Nick() .. " (" .. leg .. " leg) со значением " .. value)
    end)
end