--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

function SublimeGov.Player:sGov_GetString(identifier, default)
    return tostring(self["sgov_" .. identifier]) or default;
end

function SublimeGov.Player:sGov_GetInt(identifier, default)
    return tonumber(self["sgov_" .. identifier]) or default;
end

function SublimeGov.Player:sGov_GetBool(identifier, default)
    return tobool(self["sgov_" .. identifier]) or default;
end