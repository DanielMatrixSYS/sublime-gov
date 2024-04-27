--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("SublimeGov.RequestCriminalRecordAccepted", function()
    local arrested_count    = net.ReadUInt(32);
    local confiscated_count = net.ReadUInt(32);
    local wanted_count      = net.ReadUInt(32);
    local warranted_count   = net.ReadUInt(32);

    hook.Run("SublimeGov.CriminalRecordWasUpdated", {
        arrested_count      = arrested_count,
        confiscated_count   = confiscated_count,
        wanted_count        = wanted_count,
        warranted_count     = warranted_count
    });
end);