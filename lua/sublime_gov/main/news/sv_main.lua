--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.UpdateRecentNews")

local path      = SublimeUI.GetCurrentPath();
local format    = string.format;

function SublimeGov.Player:sGov_UpdateRecentNews(give_last)
    if (not self:sGov_IsConnected()) then
        return false;
    end

    local news = SublimeGov.News;

    -- If give_last is true then we'll give the last entry to the table to the client instead of the entire table.
    if (not give_last) then
        net.Start("SublimeGov.UpdateRecentNews");
            net.WriteBool(give_last);
            net.WriteUInt(#news, 8);

            for i = 1, #news do
                local data      = news[i];
                local victim    = data.victim;
                local officer   = data.officer;
                local result    = data.result;
                local time      = data.time;
                local color     = data.color;

                net.WriteString(victim);
                net.WriteString(officer);
                net.WriteString(result);
                net.WriteUInt(time, 32);
                net.WriteColor(color);
            end

        net.Send(self);
    else
        local last = news[#news];

        net.Start("SublimeGov.UpdateRecentNews");
            net.WriteBool(give_last);
            net.WriteString(last.victim);
            net.WriteString(last.officer);
            net.WriteString(last.result);
            net.WriteUInt(last.time, 32);
            net.WriteColor(last.color);
        net.Send(self);

    end

    return true;
end

local function AddNews(victim, officer, result, time, color, give_last)
    if (#SublimeGov.News + 1 > SublimeGov.MaxNewsEntries) then
        table.remove(SublimeGov.News, 1);
    end

    table.insert(SublimeGov.News, {
        victim  = victim,
        officer = officer or "",
        result  = result,
        time    = time,
        color   = color
    });

    local connections = SublimeGov.GetConnections();
    for i = 1, #connections do
        local data      = connections[i];
        local player    = data.player;

        if (IsValid(player)) then
            player:sGov_UpdateRecentNews(give_last);
        end
    end
end

hook.Add("PlayerDeath", path, function(victim, inflictor, attacker)
    if (IsValid(victim)) then
        local name  = victim:Nick();
        local time  = os.time();

        if (IsValid(attacker) and attacker:IsPlayer() and SublimeGov.IsJobCP(attacker)) then
            local officer = attacker:Nick();

            if (victim == attacker) then
                AddNews(name, "", "suicided", time, SublimeUI.Red, true);
            else
                if (SublimeGov.IsJobCP(victim)) then
                    AddNews(officer, name, "teamkilled", time, SublimeUI.Blue, true);
                else
                    AddNews(officer, name, "killed", time, SublimeUI.Red, true);
                end
            end
        else
            if (SublimeGov.IsJobCP(victim)) then
                AddNews(name, "", "died in action", time, SublimeUI.Red, true);
            end
        end
    end
end);

local drp_hooks = {
    {
        name = "playerUnArrested",
        reason = "released",
        color = SublimeUI.Green
    },

    {
        name = "playerWanted",
        reason = "wanted",
        color = SublimeUI.Red
    },

    {
        name = "playerUnWanted",
        reason = "unwanted",
        color = SublimeUI.Green
    },

    {
        name = "playerWarranted",
        reason = "warranted",
        color = SublimeUI.Red
    },

    {
        name = "playerUnWarranted",
        reason = "unwarranted",
        color = SublimeUI.Green
    },

    {
        name = "playerWeaponsConfiscated",
        reason = "confiscated",
        color = SublimeUI.Red,
        switch = true
    }
}

for i = 1, #drp_hooks do
    local data      = drp_hooks[i];
    local name      = data.name;
    local reason    = data.reason;
    local color     = data.color;
    local switch    = data.switch;

    hook.Add(name, path, function(victim, officer)
        if (not IsValid(victim) or not IsValid(officer)) then
            return;
        end

        if (data.switch) then
            AddNews(victim:Nick(), officer:Nick(), reason, os.time(), color, true);
        else
            AddNews(officer:Nick(), victim:Nick(), reason, os.time(), color, true);
        end
    end);
end

-- Can't use this in our above table because it has an extra argument.. In the middle..
hook.Add("playerArrested", path, function(victim, _, officer)

    -- Apparently you can arrest people while they're arrested?
    if (not IsValid(victim) or victim:isArrested()) then
        return;
    end

    local nick = IsValid(officer) and officer:Nick() or "Unknown";
    AddNews(nick, victim:Nick(), "arrested", os.time(), SublimeUI.Red, true);
end);

hook.Add("OnPlayerChangedTeam", path, function(ply, before, after)
    if (IsValid(ply)) then
        if (SublimeGov.IsJobCP(after)) then
            AddNews(ply:Nick(), "", "has joined the force", os.time(), SublimeUI.Blue, true);
        else
            if (SublimeGov.IsJobCP(before)) then
                AddNews(ply:Nick(), "", "has left the force", os.time(), SublimeUI.Red, true);
            end
        end
    end
end);