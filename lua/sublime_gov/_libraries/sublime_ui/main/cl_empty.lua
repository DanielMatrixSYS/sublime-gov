--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "TextPos", "TextPos", FORCE_NUMBER);
AccessorFunc(panel, "Text", "Text", FORCE_STRING);

function panel:Init()
    self.Position   = 7;
    self.Align      = TEXT_ALIGN_LEFT;

    return true;
end

function panel:Think()
    return true;
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

    if (self.TextPos) then
        if (self.TextPos == TEXT_ALIGN_CENTER) then
            self.Position = w / 2;
            self.Align = TEXT_ALIGN_CENTER;
        elseif(self.TextPos == TEXT_ALIGN_RIGHT) then
            self.Position = w - 7;
            self.Align = TEXT_ALIGN_RIGHT;
        end
    end

    SublimeUI.DrawTextOutlined(self.Text or "", "SublimeUI.16", self.Position, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, self.Align);
end
vgui.Register("Sublime.EmptyFrame", panel, "EditablePanel");