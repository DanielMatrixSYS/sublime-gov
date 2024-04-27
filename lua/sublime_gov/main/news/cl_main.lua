--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local function AddNews(victim, officer, result, time, color)
    if (#SublimeGov.News + 1 > SublimeGov.MaxNewsEntries) then
        table.remove(SublimeGov.News, 1);
    end

    table.insert(SublimeGov.News, {
        victim  = victim,
        officer = officer,
        result  = result,
        time    = time,
        color   = color
    });
end

net.Receive("SublimeGov.UpdateRecentNews", function()
    local give_last = net.ReadBool();

    if (not give_last) then
        table.Empty(SublimeGov.News);

        local count = net.ReadUInt(8);
        for i = 1, count do
            local victim    = net.ReadString();
            local officer   = net.ReadString();
            local result    = net.ReadString();
            local time      = net.ReadUInt(32);
            local color     = net.ReadColor();

            AddNews(victim, officer, result, time, color);
        end

        hook.Run("SublimeGov.NewsHaveBeenUpdated", SublimeGov.News);
    else
        local victim    = net.ReadString();
        local officer   = net.ReadString();
        local result    = net.ReadString();
        local time      = net.ReadUInt(32);
        local color     = net.ReadColor();

        AddNews(victim, officer, result, time, color);

        hook.Run("SublimeGov.NewsHaveBeenUpdated", {{
            victim  = victim,
            officer = officer,
            result  = result,
            time    = time,
            color   = color
        }});
    end
end);