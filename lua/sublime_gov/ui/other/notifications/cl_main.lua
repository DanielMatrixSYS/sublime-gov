--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "Title", "Title", FORCE_STRING);
AccessorFunc(panel, "Description", "Description", FORCE_STRING);
AccessorFunc(panel, "DisplayDecline", "DisplayDecline", FORCE_BOOL);
AccessorFunc(panel, "UseTextEdit", "UseTextEdit", FORCE_BOOL);
AccessorFunc(panel, "TextEditTemp", "TextEditTemp", FORCE_STRING);
AccessorFunc(panel, "AcceptText", "AcceptText", FORCE_STRING);
AccessorFunc(panel, "DeclineText", "DeclineText", FORCE_STRING);

function panel:Init()
    self.Children   = {};
    self.Approach   = math.Approach;
    self.Player     = LocalPlayer();
    self.Time       = SysTime();
    self.Us         = self;
    self.L          = SublimeGov.L;

    self.Exit = self:Add("DButton");
    self.Exit:SetText("");
    self.Exit:SetCursor("arrow");

    self.Exit.Alpha = 200;

    self.Exit.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 0);
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(ColorAlpha(SublimeUI.Grey, s.Alpha));
        surface.SetMaterial(SublimeUI.Materials["Exit"]);
        surface.DrawTexturedRect(0, 0, 12, 12);

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 150, 2)
        else
            s.Alpha = self.Approach(s.Alpha, 200, 2);
        end
    end

    self.Exit.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end

    self.Exit.DoClick = function()
        if (IsValid(self)) then
            self:Remove();
        end
    end

    self.Accept = self:Add("Sublime.Button");
    self.Accept:SetText(self.L("ui_notification_accept"));
    self.Accept:SetTextPos(TEXT_ALIGN_CENTER);
    self.Accept:SetTextColor(SublimeUI.White);
    self.Accept.DoClick = function()
        local shouldRemove = self:DoAcceptClick(self);

        if (shouldRemove == false) then
            return;
        end

        self:Remove();
    end
end

function panel:DoAcceptClick(returnvalue)
    return returnvalue;
end

function panel:DoDeclineClick()
    return true;
end

function panel:GetTextEntryValue()
    if (IsValid(self.TextEdit)) then
        return self.TextEdit:GetValue();
    end

    return "";
end

function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    if (self.DisplayDecline) then
        self.Accept:SetPos(7, h - 37);
        self.Accept:SetSize((w / 2) - 14, 30);

        self.Decline:SetPos((w / 2) + 7, h - 37);
        self.Decline:SetSize((w / 2) - 14, 30);
    else
        self.Accept:SetPos(w / 4, h - 37);
        self.Accept:SetSize(w / 2, 30);
    end

    if (IsValid(self.TextEdit)) then
        self.TextEdit:SetPos(7, h / 2);
        self.TextEdit:SetSize(w - 14, 30);

        self.TextEdit:RequestFocus();
    end
end

function panel:Think()
    if (self.DisplayDecline and not self.DDHasBeenCalled) then
        self.Decline = self:Add("Sublime.Button");
        self.Decline:SetText(self.L("ui_notification_decline"));
        self.Decline:SetTextPos(TEXT_ALIGN_CENTER);
        self.Decline:SetTextColor(SublimeUI.White);
        self.Decline.DoClick = function()
            self:Remove();
            self:DoDeclineClick();
        end

        self.DDHasBeenCalled = true;
    end

    if (self.UseTextEdit and not self.TEHasBeenCalled) then
        self.TextEdit = self:Add("DTextEntry");
        self.TextEdit:SetFont("SublimeUI.16");
        self.TextEdit:SetDrawLanguageID(false);
        
        if (self.TextEditTemp) then
            self.TextEdit:SetText(self.TextEditTemp);
        end

        self.TextEdit.Paint = function(s, w, h)
            surface.SetDrawColor(0, 0, 0, 255);
            surface.DrawOutlinedRect(0, 0, w, h);

            surface.SetDrawColor(SublimeUI.Outline);
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

            s:DrawTextEntryText(SublimeUI.White, SublimeUI.Black, SublimeUI.White);
        end

        self.TEHasBeenCalled = true;
    end

    if (self.DeclineText and IsValid(self.Decline) and not self.HasSetDeclineText) then
        self.Decline:SetText(self.DeclineText);

        self.HasNotSetDeclineText = true;
    end

    if (self.AcceptText and IsValid(self.Accept) and not self.HasSetAcceptText) then
        self.Accept:SetText(self.AcceptText);

        self.HasSetAcceptText = true;
    end
end

function panel:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Time);

    surface.SetDrawColor(255, 255, 255, 255);
    surface.SetMaterial(SublimeUI.Materials["Background"]);
    surface.DrawTexturedRect(0, 0, w, h);
    surface.DrawTexturedRect(2, 2, w - 4, 30);

    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 32, w - 4, 1)

    SublimeUI.DrawTextOutlined(self.Title, "SublimeUI.16", 7, 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined(SublimeUI.textWrap(self.Description, "SublimeUI.16", w - 14), "SublimeUI.16", w / 2, 55, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
end
vgui.Register("SublimeGov.Notification", panel, "EditablePanel");