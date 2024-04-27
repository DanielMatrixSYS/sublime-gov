--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.ComputerView");

function SublimeGov.SendView(ply, ent)
    net.Start("SublimeGov.ComputerView");
        net.WriteEntity(ent);
    net.Send(ply);
end