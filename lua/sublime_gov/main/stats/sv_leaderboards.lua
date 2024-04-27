--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.RequestLeaderboardsData");
util.AddNetworkString("SublimeGov.SendLeaderboardsData");
util.AddNetworkString("SublimeGov.AdminAdjustedData");
util.AddNetworkString("SublimeGov.AdminResetData");

local path = SublimeUI.GetCurrentPath();

hook.Add("OnPlayerChangedTeam", path, function(ply, before, after)
    if (not IsValid(ply) or ply:IsBot() or not SublimeGov.IsJobCP(after)) then
        return;
    end

    local seconds = sql.QueryValue("SELECT seconds_on_duty FROM SublimeGov_PoliceData WHERE SteamID = '" .. ply:SteamID64() .. "'");
    
    ply:sGov_SetInt("seconds_on_duty", seconds or 0);
end);

net.Receive("SublimeGov.RequestLeaderboardsData", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply) or not ply:sGov_IsConnected()) then
        return;
    end

    if (ply.SublimeGov_Leaderboards_Cooldown and ply.SublimeGov_Leaderboards_Cooldown > CurTime()) then
        return;
    end

    local currentPage   = net.ReadUInt(32);
    local start         = 23 * (currentPage - 1);
    local data          = sql.Query("SELECT SteamID, kills, deaths, teamkills, arrested_count, wanted_count, salary_total, seconds_on_duty FROM SublimeGov_PoliceData ORDER BY seconds_on_duty DESC");

    local players = {};
    for i = start + 1, start + 23 do
        local player_data = data[i];

        if (not player_data) then
            continue;
        end

        table.insert(players, {
            position = i,
            steamid = player_data.SteamID,
            kills = player_data.kills,
            deaths = player_data.deaths,
            teamkills = player_data.teamkills,
            arrested_count = player_data.arrested_count,
            wanted_count = player_data.wanted_count,
            salary_total = player_data.salary_total,
            seconds_on_duty = player_data.seconds_on_duty
        })
    end

    net.Start("SublimeGov.SendLeaderboardsData");
        net.WriteUInt(#players, 32);
        net.WriteUInt(math.ceil(#data / 23), 32);

        for i = 1, #players do
            local data = players[i];

            if (data) then
                net.WriteUInt(data.position, 32);
                net.WriteString(data.steamid);
                net.WriteUInt(data.kills, 32);
                net.WriteUInt(data.deaths, 32);
                net.WriteUInt(data.teamkills, 32);
                net.WriteUInt(data.arrested_count, 32);
                net.WriteUInt(data.wanted_count, 32);
                net.WriteUInt(data.salary_total, 32);
                net.WriteUInt(data.seconds_on_duty, 32);
            end
        end
    net.Send(ply);

    ply.SublimeGov_Leaderboards_Cooldown = CurTime() + 1;
end);

net.Receive("SublimeGov.AdminAdjustedData", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.Config.Administrators[ply:GetUserGroup()]) then
        return;
    end

    local owner     = net.ReadString();
    local column    = net.ReadString();
    local new       = net.ReadUInt(32);
    local SQL       = SublimeGov.GetSQL();

    sql.Query(SQL:FormatSQL("UPDATE SublimeGov_PoliceData SET %s = %s WHERE SteamID = '%s'", column, new, owner));
end);

net.Receive("SublimeGov.AdminResetData", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.Config.Administrators[ply:GetUserGroup()]) then
        return;
    end

    local owner = net.ReadString();
    local SQL   = SublimeGov.GetSQL();

    local hello = sql.Query(SQL:FormatSQL([[UPDATE SublimeGov_PoliceData SET
    kills = 0,
    teamkills = 0,
    deaths = 0,
    wanted_count = 0,
    warranted_count = 0,
    confiscated_count = 0,
    arrested_count = 0,
    released_count = 0,
    ram_count = 0,
    salary_total = 0,
    seconds_on_duty = 0,
    damage_dealt = 0
    WHERE SteamID = '%s']], owner));
end);