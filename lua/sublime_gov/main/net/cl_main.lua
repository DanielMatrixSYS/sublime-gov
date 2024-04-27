--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("SublimeGov.SetInt", function()
    local player        = net.ReadEntity();
    local identifier    = net.ReadString();
    local value         = net.ReadUInt(32);

    player["sgov_" .. identifier] = value;
end);

net.Receive("SublimeGov.SetString", function()
    local player        = net.ReadEntity();
    local identifier    = net.ReadString();
    local value         = net.ReadString();

    player["sgov_" .. identifier] = value;
end);

net.Receive("SublimeGov.SetBool", function()
    local player        = net.ReadEntity();
    local identifier    = net.ReadString();
    local value         = net.ReadBool();

    player["sgov_" .. identifier] = value;
end);