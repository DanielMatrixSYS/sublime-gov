--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("SublimeGov.UpdateTaxFund", function()
    local money = net.ReadUInt(32);
    
    hook.Run("SublimeGov.TaxUpdated", money);
end);

net.Receive("SublimeGov.UpdateSalary", function()
    local job   = net.ReadUInt(32);
    local extra = net.ReadUInt(32);

    RPExtraTeams[job].extraSalary = extra;
end);