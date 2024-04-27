--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.UpdateDatabase");

local RESET_DATABASE_POLICE     = 0x1;
local RESET_DATABASE_CRIMINAL   = 0x2;
local RESET_DATABASE_COMPUTER   = 0x3;
local RESET_DATABASE_EVERYTHING = 0x4;

local functions = {
    [RESET_DATABASE_POLICE] = function()
        sql.Query("DROP TABLE SublimeGov_PoliceData");

        RunConsoleCommand("changelevel", game.GetMap());
    end,

    [RESET_DATABASE_CRIMINAL] = function()
        sql.Query("DROP TABLE SublimeGov_CriminalData");

        RunConsoleCommand("changelevel", game.GetMap());
    end,

    [RESET_DATABASE_COMPUTER] = function()
        sql.Query("DROP TABLE SublimeGov_Computers");

        RunConsoleCommand("changelevel", game.GetMap());
    end,

    [RESET_DATABASE_EVERYTHING] = function()
        sql.Query("DROP TABLE SublimeGov_PoliceData");
        sql.Query("DROP TABLE SublimeGov_CriminalData");
        sql.Query("DROP TABLE SublimeGov_Computers");

        RunConsoleCommand("changelevel", game.GetMap());
    end
}

net.Receive("SublimeGov.UpdateDatabase", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.Config.Administrators[ply:GetUserGroup()]) then
        return;
    end

    local reset = net.ReadUInt(4);
    functions[reset]();
end);