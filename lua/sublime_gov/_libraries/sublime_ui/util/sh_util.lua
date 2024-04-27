--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

function SublimeUI.GetCurrentPath()
    return debug.getinfo(2).short_src;
end

local c = Color;
SublimeUI.White     = c(255, 255, 255);
SublimeUI.Black     = c(0, 0, 0);
SublimeUI.Red       = c(175, 25, 0);
SublimeUI.Green     = c(25, 179, 25);
SublimeUI.Outline   = c(57, 64, 78, 225);
SublimeUI.Grey      = c(150, 150, 150, 50);
SublimeUI.Yellow    = c(204, 204, 0);
SublimeUI.Blue      = c(0, 75, 200);