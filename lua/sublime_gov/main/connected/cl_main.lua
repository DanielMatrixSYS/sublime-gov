--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

--
-- SetIsConnected
--
-- In order for the news list to be constantly updated with the most recent "news",
-- we need to send a net message to the server that tells the server we are actually,
-- in the menu.
--
-- Once we "disconnect" from the system then we'll alert the server again that we are no longer,
-- in the menu and no longer require instant updates.
function SublimeGov.SetIsConnected(bool)
    net.Start("SublimeGov.PlayerIsConnected");
        net.WriteBool(bool);
    net.SendToServer();
end

net.Receive("SublimeGov.PersonalPoliceDataAccepted", function()
    local kills             = net.ReadUInt(32);
    local teamkills         = net.ReadUInt(32);
    local deaths            = net.ReadUInt(32);
    local arrested_count    = net.ReadUInt(32);
    local salary            = net.ReadUInt(32);
    local seconds           = net.ReadUInt(32);

    hook.Run("SublimeGov.PersonalPoliceDataUpdated", {
        kills           = kills,
        teamkills       = teamkills,
        deaths          = deaths,
        arrested_count  = arrested_count,
        salary          = salary,
        seconds         = seconds
    });
end);