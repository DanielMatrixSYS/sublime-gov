--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.RequestCriminalRecord");
util.AddNetworkString("SublimeGov.RequestCriminalRecordAccepted");

net.Receive("SublimeGov.RequestCriminalRecord", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply)) then
        return;
    end

    if (ply.sgov_criminal_req_cd and ply.sgov_criminal_req_cd > CurTime()) then
        return;
    end

    local steamid   = net.ReadString();
    local criminal  = player.GetBySteamID64(steamid);

    if (not IsValid(criminal) or criminal:IsBot()) then
        return;
    end

    local data = sql.QueryRow("SELECT wanted_count, warranted_count, confiscated_count, arrested_count FROM SublimeGov_CriminalData WHERE SteamID = '" .. steamid .. "'");
    local to = tonumber;

    net.Start("SublimeGov.RequestCriminalRecordAccepted");
        net.WriteUInt(to(data.arrested_count), 32);
        net.WriteUInt(to(data.confiscated_count), 32);
        net.WriteUInt(to(data.wanted_count), 32);
        net.WriteUInt(to(data.warranted_count), 32);
    net.Send(ply);

    ply.sgov_criminal_req_cd = CurTime() + 2;
end);