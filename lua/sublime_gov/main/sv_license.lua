--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.AdjustedGunLicense");
util.AddNetworkString("SublimeGov.AdjustedGunLicenseSuccess");

net.Receive("SublimeGov.AdjustedGunLicense", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply) or not ply:sGov_IsConnected()) then
        return;
    end
    
    local changed = net.ReadBool();

    local target_steamid = net.ReadString();
    
    local player    = player.GetBySteamID64(target_steamid);
    local nick      = ply:Nick();
    local steamid   = ply:SteamID();

    if (IsValid(player)) then
        local target_nick = player:Nick();

        if (not changed) then
            player:setDarkRPVar("HasGunlicense", nil);

            DarkRP.notify(player, 1, 4, DarkRP.getPhrase("gunlicense_denied", nick, target_nick));
            if (ply ~= player) then
                DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("gunlicense_denied", nick, target_nick));
            end

            DarkRP.log(nick .. " (" .. steamid .. ") force-removed " .. target_nick .. "'s gun license", Color(30, 30, 30));
        else
            player:setDarkRPVar("HasGunlicense", true);

            DarkRP.notify(player, 1, 4, DarkRP.getPhrase("gunlicense_granted", nick, target_nick));
            if (ply ~= player) then
                DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("gunlicense_granted", nick, target_nick));
            end

            DarkRP.log(nick .. " (" .. steamid .. ") force-gave " .. target_nick .. "'s gun license", Color(30, 30, 30));
        end

        net.Start("SublimeGov.AdjustedGunLicenseSuccess");
        net.Send(ply);
    end
end);