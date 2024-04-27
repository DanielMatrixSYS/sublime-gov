--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

util.AddNetworkString("SublimeGov.PlayerIsConnected");
util.AddNetworkString("SublimeGov.RequestPersonalPoliceData");
util.AddNetworkString("SublimeGov.PersonalPoliceDataAccepted");

-- Keep a list of active players that are currently using the system.
SublimeGov.ActiveConnections = SublimeGov.ActiveConnections or {};

local function RemoveConnection(ply)
    local to_remove_steamid = ply:SteamID64();

    for i = 1, #SublimeGov.ActiveConnections do
        local connection_data   = SublimeGov.ActiveConnections[i];
        local stored_steamid    = connection_data.steamid;

        if (stored_steamid == to_remove_steamid) then
            return table.remove(SublimeGov.ActiveConnections, i);
        end
    end

    return false;
end

function SublimeGov.GetConnections()
    return SublimeGov.ActiveConnections;
end

function SublimeGov.Player:sGov_IsConnected()
    for i = 1, #SublimeGov.ActiveConnections do
        local connection_data   = SublimeGov.ActiveConnections[i];
        local stored_player     = connection_data.player;

        if (stored_player == self) then
            return true;
        end
    end

    return false;
end

-- If the player gets kicked/disconnects whilst connected to the system
-- then we'll just remove him from the table to prevent unnecessary shit.
hook.Add("PlayerDisconnect", path, function(ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply)) then
        return;
    end

    RemoveConnection(ply);
end);

-- If the player gets demoted or force team changed whilst connected
-- then we'll just remove him from the table to prevent unnecessary shit.
hook.Add("OnPlayerChangedTeam", path, function(ply, before, after)
    if (SublimeGov.IsJobCP(before) and not SublimeGov.IsJobCP(after)) then
        RemoveConnection(ply);
    end
end);

net.Receive("SublimeGov.PlayerIsConnected", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply)) then
        return;
    end

    local bool = net.ReadBool();

    if (bool) then
        table.insert(SublimeGov.ActiveConnections, {player = ply, steamid = ply:SteamID64()});

        ply:sGov_UpdateRecentNews(false);
    else
        RemoveConnection(ply);
    end
end);

net.Receive("SublimeGov.RequestPersonalPoliceData", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply)) then
        return;
    end

    local data = sql.QueryRow("SELECT kills, teamkills, deaths, arrested_count, salary_total, seconds_on_duty FROM SublimeGov_PoliceData WHERE SteamID = '" .. ply:SteamID64() .. "'");
    local to = tonumber;

    net.Start("SublimeGov.PersonalPoliceDataAccepted");
        net.WriteUInt(to(data.kills), 32);
        net.WriteUInt(to(data.teamkills), 32);
        net.WriteUInt(to(data.deaths), 32);
        net.WriteUInt(to(data.arrested_count), 32);
        net.WriteUInt(to(data.salary_total), 32);
        net.WriteUInt(to(data.seconds_on_duty), 32);
    net.Send(ply);
end);