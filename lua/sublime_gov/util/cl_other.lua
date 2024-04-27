--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

function SublimeGov.CreateNotification(title, description, display_decline, func)
    local frame = vgui.Create("SublimeGov.Notification");
    frame:SetSize(500, 225);
    frame:Center();
    frame:MakePopup();
    frame:SetDisplayDecline(display_decline);
    frame:SetTitle(title);
    frame:SetDescription(description)

    frame.DoAcceptClick = function(s)
        if (func) then
            func(s);
        end
    end

    return frame;
end

net.Receive("SublimeGov.Notify", function(_, ply)
    chat.AddText(SublimeUI.Black, "[", SublimeUI.Red, "Government", SublimeUI.Black, "]", SublimeUI.White, ": ", net.ReadString());
end);