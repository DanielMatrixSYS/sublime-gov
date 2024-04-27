--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

-- Keep a list of on duty cops.
SublimeGov.ActiveOfficers = SublimeGov.ActiveOfficers or {};

local function RemoveFromActive(steamid)
    for i = 1, #SublimeGov.ActiveOfficers do
        local data      = SublimeGov.ActiveOfficers[i];
        local stored    = data.steamid;

        if (stored == steamid) then
            return table.remove(SublimeGov.ActiveOfficers, i);
        end
    end

    return false;
end

function SublimeGov.GetActiveOfficers()
    return SublimeGov.ActiveOfficers;
end

hook.Add("PlayerDisconnect", path, function(ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply)) then
        return;
    end

    RemoveFromActive(ply);
end);

hook.Add("OnPlayerChangedTeam", path, function(ply, before, after)
    if (not IsValid(ply)) then
        return;
    end

    if (SublimeGov.IsJobCP(before) and not SublimeGov.IsJobCP(after)) then
        RemoveFromActive(ply:SteamID64());

        return;
    end

    if (SublimeGov.IsJobCP(after) and not SublimeGov.IsJobCP(before)) then
        table.insert(SublimeGov.ActiveOfficers, {player = ply, steamid = ply:SteamID64()});
        
        ply.SublimeGov_Timer = CurTime() + 60;
    end
end);