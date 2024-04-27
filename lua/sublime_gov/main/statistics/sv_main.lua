--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.RequestStatisticsData");
util.AddNetworkString("SublimeGov.StatisticsDataSent");

net.Receive("SublimeGov.RequestStatisticsData", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply) or not ply:sGov_IsConnected()) then
        return;
    end

    local query = sql.QueryRow("SELECT SUM(kills), SUM(teamkills), SUM(deaths), SUM(wanted_count), SUM(warranted_count), SUM(confiscated_count), SUM(arrested_count), SUM(released_count), SUM(ram_count), SUM(salary_total), SUM(seconds_on_duty), SUM(damage_dealt) FROM SublimeGov_PoliceData");

    net.Start("SublimeGov.StatisticsDataSent");
        net.WriteUInt(table.Count(query), 32);

        for k, v in pairs(query) do
            net.WriteString(k);
            net.WriteUInt(v, 32);
        end

    net.Send(ply);
end);