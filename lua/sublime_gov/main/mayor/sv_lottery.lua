--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

hook.Add("lotteryEnded", path, function(_, winner, amount)
    winner:sGov_SetBool("lottery_winner", true);
    winner:sGov_SetInt("lottery_amount", amount);
    winner:sGov_SetInt("lotter_time", os.time());
end);