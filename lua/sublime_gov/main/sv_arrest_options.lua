--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.AdjustSentence");

local shouldExtend = {};

local path = SublimeUI.GetCurrentPath();

net.Receive("SublimeGov.AdjustSentence", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply) or not ply:sGov_IsConnected()) then
        return;
    end

    local bool      = net.ReadBool();
    local player    = player.GetBySteamID64(net.ReadString());
    
    -- true = release; false = extend.

    if (IsValid(player)) then
        if (bool) then
            player:unArrest(ply);

            DarkRP.notify(player, 1, 10, ply:Nick() .. " has released you early from your sentence.");
            DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") has released " .. player:Nick() .. "'s jail sentence from the sGov Computer", Color(30, 30, 30));
        else
            table.insert(shouldExtend, {player = player, actor = ply, time = GAMEMODE.Config.jailtimer or 120})

            DarkRP.notify(player, 1, 30, ply:Nick() .. " has extended your jail sentence by another " .. (GAMEMODE.Config.jailtimer or 120) .. " seconds, you will be jailed again once you spawn.");
            DarkRP.log(ply:Nick() .. " (" .. ply:SteamID() .. ") has extended " .. player:Nick() .. "'s jail sentence from the sGov Computer", Color(30, 30, 30));
        end
    end
end);

hook.Add("playerUnArrested", path, function(ply, actor)
    timer.Simple(2, function()
        if (IsValid(ply)) then
            for i = 1, #shouldExtend do
                local data      = shouldExtend[i];
                local player    = data.player;
                local time      = data.time;
                local actor     = data.actor;

                if (IsValid(player) and player == ply) then
                    ply:arrest(time, actor);
                
                    table.remove(shouldExtend, i);
                end
            end
        end
    end);
end);