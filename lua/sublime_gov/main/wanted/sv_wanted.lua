--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

hook.Add("playerWanted", path, function(criminal, actor, reason)
    if (not reason or reason == "") then
        reason = "Unkonwn reason";
    end

    criminal:sGov_SetString("wanted_reason", reason);

    if (IsValid(actor) and actor:IsPlayer()) then
        criminal:sGov_SetString("wanted_actor", actor:Nick());
    end
end);