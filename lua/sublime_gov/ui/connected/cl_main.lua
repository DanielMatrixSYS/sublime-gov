--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local main  = nil;
local panel = {};

function panel:Init()
    self.Approach   = math.Approach;
    self.Player     = LocalPlayer();

    self.Viewing    = nil;
    self.tSize      = surface.GetTextSize;
    self.L          = SublimeGov.L;

    self.Taskbar    = self:Add("SublimeGov.Connected.Taskbar");
    self.Apps       = self:Add("SublimeGov.Connected.Main");

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

        SublimeGov.StopViewing()
    end

    main = self;
end

function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.Taskbar:SetPos(7, h - 47);
    self.Taskbar:SetSize(w - 14, 40);

    self.Apps:SetPos(7, 38);
    self.Apps:SetSize(200, h - 90);

    if (IsValid(self.Viewing)) then
        self.Viewing:SetPos(212, 38);
        self.Viewing:SetSize(w - 219, h - 90);
    end
end

function panel:OnRemove()
    SublimeGov.SetIsConnected(false);
end

function panel:Paint(w, h)
    surface.SetDrawColor(255, 255, 255, 255);
    surface.SetMaterial(SublimeUI.Materials["Background"]);
    surface.DrawTexturedRect(0, 0, w, h);
    surface.DrawTexturedRect(2, 2, w - 4, 30);

    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 32, w - 4, 1)

    surface.SetFont("SublimeUI.16");
    local width = self.tSize(self.L("ui_login_title"));

    SublimeUI.DrawTextOutlined(self.L("ui_login_title"), "SublimeUI.16", 7, 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined(self.L("ui_connected_logged_in"), "SublimeUI.16", 7 + width, 9, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_LEFT);

    width = width + self.tSize(self.L("ui_connected_logged_in") .. " ");
    SublimeUI.DrawTextOutlined(self.L("ui_connected_as_a"), "SublimeUI.16", 7 + width, 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

    width = width + self.tSize(self.L("ui_connected_as_a") .. " ");
    SublimeUI.DrawTextOutlined(team.GetName(self.Player:Team()):upper(), "SublimeUI.16", 7 + width, 9, team.GetColor(self.Player:Team()), SublimeUI.Black, TEXT_ALIGN_LEFT);

    width = width + self.tSize(team.GetName(self.Player:Team()):upper() .. " ");
    SublimeUI.DrawTextOutlined(self.L("ui_connected_on"), "SublimeUI.16", 7 + width, 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

    width = width + self.tSize(self.L("ui_connected_on") .. " ");
    SublimeUI.DrawTextOutlined(game.GetIPAddress():gsub(":.*", ""), "SublimeUI.16", 7 + width, 9, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Frame", panel, "EditablePanel");