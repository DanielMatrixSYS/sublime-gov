--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("SublimeGov.StatisticsDataSent", function()
    local count = net.ReadUInt(32);
    local data  = {};

    for i = 1, count do
        local identifier    = net.ReadString();
        local value         = net.ReadUInt(32);

        identifier = identifier:gsub("SUM(", "");
        identifier = identifier:gsub("%(", "");
        identifier = identifier:gsub("%)", "");

        table.insert(data, {identifier = identifier, value = value});
    end

    hook.Run("SublimeGov.StatisticsDataUpdated", data);
end);