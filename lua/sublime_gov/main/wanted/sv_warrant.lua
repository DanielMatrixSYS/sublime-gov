--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

hook.Add("playerWarranted", path, function(criminal, actor, reason)
    criminal:sGov_SetBool("warranted", true);

    if (not reason or reason == "") then
        reason = "Unkonwn reason";
    end

    criminal:sGov_SetString("warranted_reason", reason);

    if (IsValid(actor) and actor:IsPlayer()) then
        criminal:sGov_SetString("warrant_actor", actor:Nick());
    end
end);

hook.Add("playerUnWarranted", path, function(criminal, actor)
    criminal:sGov_SetBool("warranted", false);
end);