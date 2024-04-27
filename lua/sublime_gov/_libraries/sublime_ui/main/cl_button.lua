--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "TextPos", "TextPos", FORCE_NUMBER);
AccessorFunc(panel, "SizeToContents","SizeToContents", FORCE_BOOL);
AccessorFunc(panel, "TextColor", "TextColor");
AccessorFunc(panel, "Material", "Material");
AccessorFunc(panel, "RotateMaterial", "RotateMaterial");

function panel:SetText(str)
    if (self:GetSizeToContents() == true) then
        surface.SetFont("SublimeUI.16");
        
        local width = surface.GetTextSize(str) + 14;
        self:SetSize(width, self:GetTall());
    end

    self.Text = str;
end

function panel:DoClick()
    return true;
end

function panel:DoRightClick()
    return true;
end

function panel:OnMousePressed(key)
    if (key == MOUSE_LEFT) then
        self:DoClick();
    elseif(key == MOUSE_RIGHT) then
        self:DoRightClick();
    end
end

function panel:Init()
    self.Approach   = math.Approach;
    self.Alpha      = 0;
    self.Position   = 7;
    self.Align      = TEXT_ALIGN_LEFT;

    self:SetText("Button Text");
end

function panel:OnCursorEntered()
    surface.PlaySound("sublimeui/button.mp3");
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, self.Alpha);
    surface.DrawRect(2, 2, w - 4, h - 4);

    surface.SetDrawColor(0, 0, 0);
    surface.DrawOutlinedRect(0, 0, w, h)

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

    if (self:IsHovered()) then
        self.Alpha = self.Approach(self.Alpha, 100, 8);
    else
        if (self.Alpha ~= 0) then
            self.Alpha = self.Approach(self.Alpha, 0, 2);
        end
    end

    if (self.TextPos) then
        if (self.TextPos == TEXT_ALIGN_CENTER) then
            self.Position = w / 2;
            self.Align = TEXT_ALIGN_CENTER;
        elseif(self.TextPos == TEXT_ALIGN_RIGHT) then
            self.Position = w - 7;
            self.Align = TEXT_ALIGN_RIGHT;
        end
    end

    local color = self.TextColor and self.TextColor or SublimeUI.White;

    if (not self.Material) then
        SublimeUI.DrawTextOutlined(self.Text, "SublimeUI.16", self.Position, h / 2, color, SublimeUI.Black, self.Align, TEXT_ALIGN_CENTER);
    else
        surface.SetDrawColor(255, 255, 255);
        surface.SetMaterial(self.Material);
        
        if (self.RotateMaterial) then
            surface.DrawTexturedRectRotated(14, h / 2, 16, 16, self.RotateMaterial);
        else
            surface.DrawTexturedRect(7, (h / 2) - 8, 16, 16);
        end

        SublimeUI.DrawTextOutlined(self.Text, "SublimeUI.16", self.Position + 21, h / 2, color, SublimeUI.Black, self.Align, TEXT_ALIGN_CENTER);
    end
end
vgui.Register("Sublime.Button", panel, "EditablePanel");