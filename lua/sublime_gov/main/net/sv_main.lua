--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.SetInt");
util.AddNetworkString("SublimeGov.SetString")
util.AddNetworkString("SublimeGov.SetBool")

local path = SublimeUI.GetCurrentPath();
local data = {}

function SublimeGov.Player:sGov_SetInt(identifier, value, global)
    value   = tonumber(value);
    global  = global == nil and true or global;

    if (not isnumber(value)) then
        return false;
    end

    if (global) then
        local active_officers = SublimeGov.GetActiveOfficers();

        for i = 1, #active_officers do
            local data      = active_officers[i];
            local player    = data.player;

            if (IsValid(player)) then
                net.Start("SublimeGov.SetInt");
                    net.WriteEntity(self);
                    net.WriteString(identifier);
                    net.WriteUInt(value, 32);
                net.Send(player);
            end
        end

        local steamid = self:SteamID64();
        if (not data[steamid]) then
            data[steamid] = {};
        end

        data[steamid][identifier] = value;
    else
        net.Start("SublimeGov.SetInt");
            net.WriteEntity(self);
            net.WriteString(identifier);
            net.WriteUInt(value, 32);
        net.Send(self);
    end

    self["sgov_" .. identifier] = value;
end

function SublimeGov.Player:sGov_SetString(identifier, value, global)
    value   = tostring(value);
    global  = global == nil and true or global;

    if (global) then
        local active_officers = SublimeGov.GetActiveOfficers();

        for i = 1, #active_officers do
            local data      = active_officers[i];
            local player    = data.player;

            if (IsValid(player)) then
                net.Start("SublimeGov.SetString");
                    net.WriteEntity(self);
                    net.WriteString(identifier);
                    net.WriteString(value);
                net.Send(player);
            end
        end

        local steamid = self:SteamID64();
        if (not data[steamid]) then
            data[steamid] = {};
        end

        data[steamid][identifier] = value;
    else
        net.Start("SublimeGov.SetString");
            net.WriteEntity(self);
            net.WriteString(identifier);
            net.WriteString(value);
        net.Send(self);
    end

    self["sgov_" .. identifier] = value;
end

function SublimeGov.Player:sGov_SetBool(identifier, value, global)
    value   = tobool(value);
    global  = global == nil and true or global;

    if (not isbool(value)) then
        return;
    end

    if (global) then
        local active_officers = SublimeGov.GetActiveOfficers();

        for i = 1, #active_officers do
            local data      = active_officers[i];
            local player    = data.player;

            if (IsValid(player)) then
                net.Start("SublimeGov.SetBool");
                    net.WriteEntity(self);
                    net.WriteString(identifier);
                    net.WriteBool(value);
                net.Send(player);
            end
        end

        local steamid = self:SteamID64();
        if (not data[steamid]) then
            data[steamid] = {};
        end

        data[steamid][identifier] = value;
    else
        net.Start("SublimeGov.SetBool");
            net.WriteEntity(self);
            net.WriteString(identifier);
            net.WriteBool(value);
        net.Send(self);
    end

    self["sgov_" .. identifier] = value;
end

function SublimeGov.GetData()
    return data;
end

-- Give new cops the data everyone else has.
hook.Add("OnPlayerChangedTeam", path, function(ply, before, after)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(after)) then
        return;
    end

    local to_remove = {};
    for k, v in pairs(data) do
        local player = player.GetBySteamID64(k);

        if (IsValid(player)) then
            for identifier, value in pairs(v) do
                if (isnumber(value)) then
                    net.Start("SublimeGov.SetInt");
                        net.WriteEntity(player);
                        net.WriteString(identifier);
                        net.WriteUInt(value, 32);
                    net.Send(ply);
                elseif(isstring(value)) then
                    net.Start("SublimeGov.SetString");
                        net.WriteEntity(player);
                        net.WriteString(identifier);
                        net.WriteString(value);
                    net.Send(ply);
                end
            end
        else
            table.insert(to_remove, k);
        end
    end

    if (#to_remove > 0) then
        for i = 1, #to_remove do
            local steamid = to_remove[i];

            data[steamid] = nil;
        end
    end
end);