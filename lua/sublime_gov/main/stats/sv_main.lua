--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

hook.Add("PlayerDeath", path, function(victim, _, attacker)
    if (IsValid(victim) and IsValid(attacker) and attacker:IsPlayer()) then
        if (victim == attacker) then
            return;
        end

        if (victim:IsBot()) then
            return;
        end

        local attacker_is_government = SublimeGov.IsJobCP(attacker);

        if (SublimeGov.IsJobCP(victim)) then
            if (attacker_is_government) then
                attacker:sGovData_AddInt("police_records", "teamkills", 1);
            end

            victim:sGovData_AddInt("police_records", "deaths", 1);
        else
            if (attacker_is_government) then
                attacker:sGovData_AddInt("police_records", "kills", 1);
            end
        end
    end
end);

hook.Add("playerWanted", path, function(criminal, actor, reason)
    criminal:sGovData_AddInt("criminal_records", "wanted_count", 1);
    criminal:sGov_SetInt("todays_wanted_count", criminal:sGov_GetInt("todays_wanted_count", 0) + 1);

    if (IsValid(actor)) then
        actor:sGovData_AddInt("police_records", "wanted_count", 1);
        actor:sGov_SetInt("police_todays_wanted_count", actor:sGov_GetInt("police_todays_wanted_count", 0) + 1);
    end
end);

hook.Add("playerWarranted", path, function(criminal, actor, reason)
    criminal:sGovData_AddInt("criminal_records", "warranted_count", 1);
    criminal:sGov_SetInt("todays_warranted_count", criminal:sGov_GetInt("todays_warranted_count", 0) + 1);

    if (IsValid(actor)) then
        actor:sGovData_AddInt("police_records", "warranted_count", 1);
        actor:sGov_SetInt("police_todays_warranted_count", actor:sGov_GetInt("police_todays_warranted_count", 0) + 1);
    end
end);

hook.Add("playerWeaponsConfiscated", path, function(checker, target, weps)
    if (weps and #weps > 0) then
        checker:sGovData_AddInt("police_records", "confiscated_count", #weps);
        target:sGovData_AddInt("criminal_records", "confiscated_count", #weps);
    end
end);

hook.Add("onDoorRamUsed", path, function(success, ply)
    if (success) then
        ply:sGovData_AddInt("police_records", "ram_count", 1);
    end
end);

hook.Add("playerGetSalary", path, function(ply, amount)
    if (SublimeGov.IsJobCP(ply)) then
        ply:sGovData_AddInt("police_records", "salary_total", amount);
    end
end);

hook.Add("EntityTakeDamage", path, function(victim, dmg)
    if (not IsValid(victim) or not victim:IsPlayer() or SublimeGov.IsJobCP(victim)) then
        return;
    end

    local attacker = dmg:GetAttacker();
    if (not IsValid(attacker) or not attacker:IsPlayer() or not SublimeGov.IsJobCP(attacker)) then
        return;
    end

    if (victim == attacker or victim:IsBot()) then
        return;
    end

    local damage = dmg:GetDamage();
    attacker:sGovData_AddInt("police_records", "damage_dealt", damage);
end);

hook.Add("Tick", path, function()
    local officers = SublimeGov.GetActiveOfficers();

    for i = 1, #officers do
        local data      = officers[i];
        local player    = data.player;

        if (IsValid(player) and not player:IsBot()) then
            if (player.SublimeGov_Timer and player.SublimeGov_Timer <= CurTime()) then
                player:sGovData_AddInt("police_records", "seconds_on_duty", 60);
                player:sGov_SetInt("seconds_on_duty", player:sGov_GetInt("seconds_on_duty", 0) + 60);

                player.SublimeGov_Timer = CurTime() + 60;
            end
        end
    end
end);

hook.Add("PlayerInitialSpawn", path, function(ply)
    timer.Simple(2, function()
        if (IsValid(ply)) then
            local age_type  = table.Random(SublimeGov.Config.AgeTypes);
            local race      = table.Random(SublimeGov.Config.Race);
            local height    = math.random(SublimeGov.Config.MinMaxHeight[1], SublimeGov.Config.MinMaxHeight[2]);

            ply:sGov_SetString("player_age", age_type);
            ply:sGov_SetString("player_race", race);
            ply:sGov_SetInt("player_height", height);
        end
    end);
end);