--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

function panel:DoLogin()
    local LoginChildren = {};
    local can_proceed   = true;

    local time  = CurTime();
    local texts = {
        {
            text        = self.L("ui_login_username"),
            done        = SublimeGov.IsJobCP(self.Player) and true or false,
            done_good   = self.L("ui_ok"),
            done_bad    = self.L("ui_no"),
            bad_info    = {self.L("ui_login_bad_username"), self.L("ui_login_bad_username_desc")},
            color       = SublimeUI.Yellow,
            time        = time + 0.5
        },

        {
            text        = self.L("ui_login_password"),
            done        = SublimeGov.IsJobCP(self.Player) and true or false,
            done_good   = self.L("ui_ok"),
            done_bad    = self.L("ui_no"),
            bad_info    = {self.L("ui_login_bad_password"), self.L("ui_login_bad_password_desc")},
            color       = SublimeUI.Yellow,
            time        = time + 1
        },

        {
            text        = self.L("ui_login_is_government"),
            done        = SublimeGov.IsJobCP(self.Player) and true or false,
            done_good   = self.L("ui_ok"),
            done_bad    = self.L("ui_no"),
            bad_info    = {self.L("ui_login_bad_is_government"), self.L("ui_login_bad_is_government_desc")},
            color       = SublimeUI.Yellow,
            time        = time + 1.5
        },

        {
            text        = self.L("ui_login_ip"),
            done        = true,
            done_good   = game.GetIPAddress():gsub(":.*", "");
            color       = SublimeUI.Yellow,
            time        = time + 2
        },

        {
            text        = self.L("ui_login_established_connect"),
            done        = true,
            done_good   = self.L("ui_ok"),
            done_bad    = self.L("ui_no"),
            bad_info    = {self.L("ui_login_bad_established_connect"), self.L("ui_login_bad_established_connect_desc")},
            color       = SublimeUI.Yellow,
            time        = time + 4,
            finished    = function(can_proceed, data)
                if (can_proceed) then
                    self.Proceed = self.LoginPanel:Add("Sublime.Button");
                    self.Proceed:SetText("Proceed with the connection");
                    self.Proceed:SetTextPos(TEXT_ALIGN_CENTER);
                    self.Proceed:SetTextColor(SublimeUI.Green);
                    self.Proceed.DoClick = function()
                        self:Remove();
                        
                        -- Notify server that we're connected to the system.
                        SublimeGov.SetIsConnected(true);

                        -- Continue..
                        local connected = vgui.Create("SublimeGov.Connected.Frame");
                        connected:SetPos(0, 0);
                        connected:SetSize(ScrW(), ScrH());
                        connected:MakePopup();
                    end
                else

                    -- Perform layout changes the size of the login panel the the original.
                    -- this is just to prevent that.
                    self.CanModifyLoginPanel = false;

                    -- Continue..
                    if (IsValid(self.LoginPanel)) then
                        self.LoginPanel:SetSize(self.LoginPanel:GetWide(), 289);
                    end

                    self.CantProceed = self.LoginPanel:Add("Sublime.EmptyFrame");
                    self.CantProceed:SetTextPos(TEXT_ALIGN_CENTER);
                    self.CantProceed:SetText(self.L("ui_login_proceed_unable"));

                    self.Info = self.LoginPanel:Add("Sublime.Button");
                    self.Info:SetText(self.L("ui_login_show"));
                    self.Info:SetTextPos(TEXT_ALIGN_CENTER);
                    self.Info:SetTextColor(SublimeUI.White);
                    self.Info.DoClick = function()
                        if (not data.done) then
                            local info  = data.bad_info;
                            local title = info[1];
                            local desc  = info[2];

                            local frame = vgui.Create("SublimeGov.Notification");
                            frame:SetSize(500, 225);
                            frame:Center();
                            frame:MakePopup();
                            frame:SetDisplayDecline(false);
                            frame:SetTitle(title);
                            frame:SetDescription(desc);
                        end
                    end
                end
            end
        },
    };

    self.LoginPanel = self:Add("Sublime.EmptyFrame");

    self.LoginPanel.PerformLayout = function(s, w, h)
        for i = 1, #LoginChildren do
            local panel = LoginChildren[i];

            if (IsValid(panel)) then
                panel:SetPos(7, 7 + (35 * (i - 1)));
                panel:SetSize(w - 14, 30);
            end
        end
        
        if (IsValid(self.Proceed)) then
            self.Proceed:SetPos(7, h - 72);
            self.Proceed:SetSize(w - 14, 30);
        end

        if (IsValid(self.CantProceed)) then
            self.CantProceed:SetPos(7, h - 107);
            self.CantProceed:SetSize(w - 14, 30);
        end

        if (IsValid(self.Info)) then
            self.Info:SetPos(7, h - 72);
            self.Info:SetSize(w - 14, 30);
        end

        self.Abort:SetPos(7, h - 37);
        self.Abort:SetSize(w - 14, 30);
    end
    
    local cant_proceed_data = {};
    for i = 1, #texts do
        local data  = texts[i];
        local text  = data.text;
        local color = data.color;
        local time  = data.time;

        LoginChildren[i] = self.LoginPanel:Add("DPanel");
        local child = LoginChildren[i];

        child.Paint = function(s, w, h)
            surface.SetDrawColor(0, 0, 0, 255);
            surface.DrawOutlinedRect(0, 0, w, h);

            surface.SetDrawColor(SublimeUI.Outline);
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

            SublimeUI.DrawTextOutlined(text, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

            local other = "CHECKING...";
            if (time <= CurTime()) then
                if (data.done) then
                    other = data.done_good;
                    color = SublimeUI.Green;
                else
                    other = data.done_bad;
                    color = SublimeUI.Red;

                    -- If something returns false then we can not proceed with the connection.
                    -- Then return the faulty data.
                    can_proceed         = false;
                    cant_proceed_data   = data;
                end

                if (data.finished and not data.finished_called) then
                    data.finished(can_proceed, cant_proceed_data);
                    data.finished_called = true;
                end
            end

            SublimeUI.DrawTextOutlined(other, "SublimeUI.16", w - 7, (h / 2) - 8, color, SublimeUI.Black, TEXT_ALIGN_RIGHT);
        end
    end

    self.Abort = self.LoginPanel:Add("Sublime.Button");
    self.Abort:SetText(self.L("ui_login_abort"));
    self.Abort:SetTextPos(TEXT_ALIGN_CENTER);
    self.Abort:SetTextColor(SublimeUI.Red);
    self.Abort.DoClick = function()
        self:Remove();

        SublimeGov.StopViewing()
    end
end

function panel:Init()
    self.Children   = {};
    self.Approach   = math.Approach;
    self.Player     = LocalPlayer();
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

        SublimeGov.StopViewing()
    end

    self.LoginFrame = self:Add("DPanel");
    self.LoginFrame.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        SublimeUI.DrawTextOutlined(SublimeUI.textWrap(self.L("ui_login_please"), "SublimeUI.16", w - 10), "SublimeUI.16", w / 2, 15, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        SublimeUI.DrawTextOutlined(self.L("ui_login_or"), "SublimeUI.16", (w / 2) - 1, h - 30, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    self.LoginFrame.PerformLayout = function(s, w, h)
        local width = (w / 2) - 28;

        self.Login:SetPos(7, h - 37);
        self.Login:SetSize(width, 30);

        self.Disconnect:SetPos(w - width - 7, h - 37);
        self.Disconnect:SetSize(width, 30);
    end

    self.Login = self.LoginFrame:Add("Sublime.Button");
    self.Login:SetText(self.L("ui_login_login"));
    self.Login:SetTextPos(TEXT_ALIGN_CENTER);
    self.Login:SetTextColor(SublimeUI.Green);
    self.Login.DoClick = function()
        if (IsValid(self.LoginFrame)) then
            self.LoginFrame:Remove();
        end

        if (LocalPlayer()["SublimeGov.Settings.stay_logged_in"]) then
            self:Remove();
            
            local connected = vgui.Create("SublimeGov.Connected.Frame");
            connected:SetPos(0, 0);
            connected:SetSize(ScrW(), ScrH());
            connected:MakePopup();
        else
            self:DoLogin();
        end
    end

    self.Disconnect = self.LoginFrame:Add("Sublime.Button");
    self.Disconnect:SetText(self.L("ui_exit"));
    self.Disconnect:SetTextPos(TEXT_ALIGN_CENTER);
    self.Disconnect:SetTextColor(SublimeUI.Red);
    self.Disconnect.DoClick = function()
        self:Remove();

        SublimeGov.StopViewing()
    end
end

function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    if (IsValid(self.LoginFrame)) then
        local width, tall = 450, 150;

        self.LoginFrame:SetPos((w / 2) - width / 2, (h / 2) - tall / 2);
        self.LoginFrame:SetSize(width, tall);
    end

    if (IsValid(self.LoginPanel) and self.CanModifyLoginPanel ~= false) then
        local width, tall = 450, 254;

        self.LoginPanel:SetPos((w / 2) - width / 2, (h / 2) - tall / 2);
        self.LoginPanel:SetSize(width, tall);
    end
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

    surface.SetDrawColor(255, 255, 255);
    surface.SetMaterial(SublimeUI.Materials["Monument"]);
    surface.DrawTexturedRect((w / 2) - 32, 100, 64, 64);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawRect(((w / 2) - 32) - 250, 140, 200, 1)
    surface.DrawRect(((w / 2) - 32) + 114, 140, 200, 1)

    -- Header
    SublimeUI.DrawTextOutlined(self.L("ui_login_header"), "SublimeUI.32", w / 2, 180, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);

    -- Footer
    SublimeUI.DrawTextOutlined(self.L("ui_login_footer"), "SublimeUI.16", w / 2, h - 100, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);

    -- Title
    surface.SetFont("SublimeUI.16");
    local width = surface.GetTextSize(self.L("ui_login_title"));

    SublimeUI.DrawTextOutlined(self.L("ui_login_title"), "SublimeUI.16", 7, 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined(self.L("ui_login_not_logged_in"), "SublimeUI.16", 7 + width, 9, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Login.Frame", panel, "EditablePanel");