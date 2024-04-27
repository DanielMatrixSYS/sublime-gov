--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.LockdownStatus");

local path = SublimeUI.GetCurrentPath();

local function sendLockdownStatus(status)
    local players = player.GetAll();

    for i = 1, #players do
        local player = players[i];

        if (player:isMayor() and player:sGov_IsConnected()) then
            net.Start("SublimeGov.LockdownStatus");
                net.WriteBool(status);
            net.Send(player);
        end
    end
end

hook.Add("lockdownStarted", path, function(ply)
    sendLockdownStatus(true);
end);

hook.Add("lockdownEnded", path, function(ply)
    sendLockdownStatus(false);
end);