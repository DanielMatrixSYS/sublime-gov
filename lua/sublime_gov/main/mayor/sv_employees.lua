--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.ForceADemote");

net.Receive("SublimeGov.ForceADemote", function(_, ply)
    if (not IsValid(ply) or not ply:sGov_IsConnected() or not ply:isMayor()) then
        return;
    end

    local victim = player.GetBySteamID64(net.ReadString());
    
    if (IsValid(victim) and SublimeGov.IsJobCP(victim)) then
        victim:teamBan();
        victim:changeTeam(GAMEMODE.DefaultTeam, true);

        DarkRP.notify(victim, 1, 4, "You have been banned from your current job by " .. ply:Nick());
        DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") force-demoted " .. victim:Nick() .. " from sGov Computer", Color(30, 30, 30));
    end
end);