--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("SublimeGov.SendLeaderboardsData", function()
    local count = net.ReadUInt(32);
    local max   = net.ReadUInt(32);
    local tbl   = {}

    for i = 1, count do
        local position          = net.ReadUInt(32);
        local steamid           = net.ReadString();
        local kills             = net.ReadUInt(32);
        local deaths            = net.ReadUInt(32);
        local teamkills         = net.ReadUInt(32);
        local arrested_count    = net.ReadUInt(32);
        local wanted_count      = net.ReadUInt(32);
        local salary_total      = net.ReadUInt(32);
        local seconds_on_duty   = net.ReadUInt(32);

        table.insert(tbl, {
            position = position,
            steamid = steamid,
            kills = kills,
            deaths = deaths,
            teamkills = teamkills,
            arrested_count = arrested_count,
            wanted_count = wanted_count,
            salary_total = salary_total,
            seconds_on_duty = seconds_on_duty
        })
    end

    hook.Run("SublimeGov.LeaderboardsHasBeenUpdated", tbl, max);
end);