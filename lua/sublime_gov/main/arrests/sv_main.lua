--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

--
-- Players being arrested is handled on the client, however,
-- we can't do that for when the players are unarrested.
-- So we have to do this serverside and send the information to the clients when needed.
--

util.AddNetworkString("SublimeGov.RequestArrestsData");
util.AddNetworkString("SublimeGov.SendArrestData");

local path = SublimeUI.GetCurrentPath();

local function AddArrestData(victim, officer)
    if (not IsValid(victim)) then
        return false;
    end

    if (#SublimeGov.Unarrests >= 10) then
        table.remove(SublimeGov.Unarrests, 1);
    end

    local victim_nick       = victim:Nick();
    local victim_steamid    = victim:SteamID64();
    local officer_nick      = IsValid(officer) and officer:Nick() or "Unknown";

    table.insert(SublimeGov.Unarrests, {
        victim_nick     = victim_nick,
        victim_steamid  = victim_steamid,
        officer_nick    = officer_nick,
        released_at     = os.time(),
    });

    return true;
end

local function SendArrestData(ply, send_last)
    local released = SublimeGov.Unarrests;

    if (not send_last) then
        net.Start("SublimeGov.SendArrestData");
            net.WriteBool(send_last);
            net.WriteUInt(#released, 32);
            
            for i = 1, #released do
                local data = released[i];

                local victim_nick   = data.victim_nick;
                local officer_nick  = data.officer_nick;
                local released      = data.released_at;

                net.WriteString(victim_nick);
                net.WriteString(officer_nick);
                net.WriteUInt(released, 32);
            end
        net.Send(ply);
    else
        local last = released[#released];

        net.Start("SublimeGov.SendArrestData");
            net.WriteBool(send_last);
            net.WriteString(last.victim_nick);
            net.WriteString(last.officer_nick);
            net.WriteUInt(last.released_at, 32);
        net.Send(ply); 
    end

    return true;
end

function SublimeGov.GetReleasedData()
    return SublimeGov.Unarrests;
end

hook.Add("playerArrested", path, function(victim, time, officer)
    -- We don't need to do much more here as the clients are already,
    -- aware of who is arrested or not, the only thing the clients don't know,
    -- is how long they're there for, and the name of the officer,
    -- which is what we keep track of here.

    -- Apparently you can arrest people while they're arrested?
    if (victim:isArrested()) then
        return;
    end

    victim:sGov_SetInt("arrested_for", os.time() + time);
    victim:sGov_SetString("arrested_actor", IsValid(officer) and officer:Nick() or "Unknown");

    if (not victim:IsBot() and not SublimeGov.IsJobCP(victim)) then
        victim:sGovData_AddInt("criminal_records", "arrested_count", 1);
        victim:sGov_SetInt("todays_arrested_count", victim:sGov_GetInt("todays_arrested_count", 0) + 1);

        if (IsValid(officer)) then
            officer:sGovData_AddInt("police_records", "arrested_count", 1);
            officer:sGov_SetInt("police_todays_arrested_count", officer:sGov_GetInt("police_todays_arrested_count", 0) + 1);
        end
    end
end);

hook.Add("playerUnArrested", path, function(victim, officer)
    AddArrestData(victim, officer);

    -- Get the active police officers connected to the sGov system.
    -- this is to update the UI with the recent changes.
    local connections = SublimeGov.GetConnections();
    for i = 1, #connections do
        local data      = connections[i];
        local player    = data.player;

        if (IsValid(player)) then
            SendArrestData(player, true);
        end
    end

    if (IsValid(officer)) then
        officer:sGovData_AddInt("police_records", "released_count", 1);
    end
end);

net.Receive("SublimeGov.RequestArrestsData", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply)) then
        return;
    end

    SendArrestData(ply, false);
end);