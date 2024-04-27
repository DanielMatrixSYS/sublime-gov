--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

function panel:AddApplication(name, mat, ui, last, func)
    local index = #self.Buttons + 1;

    self.Buttons[index] = self:Add("Sublime.Button");
    local button    = self.Buttons[index];

    button:SetText(name);
    button:SetTextPos(TEXT_ALIGN_LEFT);
    button:SetMaterial(mat);

    button.MySize       = 30;
    button.MyPadding    = 5;
    button.MyPosition   = self.NextButtonPosition;
    button.IsLast       = last;

    button.DoClick = function()
        if (self.Cooldown > CurTime()) then
            return;
        end

        if (IsValid(self.Main) and IsValid(self.Main.Viewing)) then
            self.Main.Viewing:Remove();
        end

        if (func) then
            func();
        end

        self.Main.Viewing = self.Main:Add(ui);

        if (ui:find(self.L("ui_app_home"))) then
            self.Main.Viewing:SetShouldInsertNews(true);
        end

        self.Cooldown = CurTime() + 1;
    end

    self.NextButtonPosition = self.NextButtonPosition + (button.MySize + button.MyPadding);
    self.NextButtonPosition = self.NextButtonPosition + (button.IsLast and 20 or 0);
end

function panel:Init()
    self.L = SublimeGov.L;

    self.Player     = LocalPlayer(); 
    self.Buttons    = {};
    self.Viewing    = nil;
    self.Main       = self:GetParent(); 
    self.Cooldown   = CurTime();
    self.Approach   = math.Approach;

    self.NextButtonPosition = 38;

    self.Applications = {
        {
            name    = self.L("ui_app_home"),
            ui      = "SublimeGov.Connected.Apps.Home",
            mat     = SublimeUI.Materials["Home"],
            func    = function()
                net.Start("SublimeGov.RequestPersonalPoliceData");
                net.SendToServer();
            end
        },

        {
            name    = self.L("ui_app_arrests_and_release"),
            ui      = "SublimeGov.Connected.Apps.Arrests",
            mat     = SublimeUI.Materials["Arrested"],
            func    = function()
                net.Start("SublimeGov.RequestArrestsData");
                net.SendToServer();
            end
        },

        {
            name    = self.L("ui_app_wanted_warrants"),
            ui      = "SublimeGov.Connected.Apps.Wanted",
            mat     = SublimeUI.Materials["Wanted"]
        },

        {
            name    = self.L("ui_app_licenses"),
            ui      = "SublimeGov.Connected.Apps.Licenses",
            mat     = SublimeUI.Materials["Bullet"]
        },

        {
            name    = self.L("ui_app_police"),
            ui      = "SublimeGov.Connected.Apps.Leaderboards",
            mat     = SublimeUI.Materials["Leaderboards"],
            func = function()
                net.Start("SublimeGov.RequestLeaderboardsData");
                    net.WriteUInt(1, 8);
                    net.WriteUInt(0, 32);
                net.SendToServer();
            end
        },

        {
            name    = self.L("ui_app_statistics"),
            ui      = "SublimeGov.Connected.Apps.Statistics",
            mat     = SublimeUI.Materials["Statistics"],
            func = function()
                net.Start("SublimeGov.RequestStatisticsData");
                net.SendToServer();
            end
        },
    }

    self:Split(self.L("ui_app_main_apps"), true);

    for i = 1, #self.Applications do
        local data  = self.Applications[i];
        local name  = data.name;
        local ui    = data.ui;
        local mat   = data.mat;
        local func  = data.func;
        local last  = i == #self.Applications;

        self:AddApplication(name, mat, ui, last, func);
    end

    -- When this is first called we'll create the home panel
    self.Main.Viewing = self.Main:Add("SublimeGov.Connected.Apps.Home");
    self.Main.Viewing:SetShouldInsertNews(false);

    net.Start("SublimeGov.RequestPersonalPoliceData");
    net.SendToServer();

    if (self.Player:isMayor()) then
        self:Split(self.L("ui_app_mayor"));

        self:AddApplication(self.L("ui_app_mayor_employees"), SublimeUI.Materials["Employees"], "SublimeGov.Connected.Apps.Mayor.Employees", false);
        self:AddApplication(self.L("ui_app_mayor_lottery"), SublimeUI.Materials["Lottery"], "SublimeGov.Connected.Apps.Mayor.Lottery", false);
        self:AddApplication(self.L("ui_app_mayor_laws"), SublimeUI.Materials["Document"], "SublimeGov.Connected.Apps.Mayor.Laws", false);
        self:AddApplication(self.L("ui_app_mayor_salaries"), SublimeUI.Materials["Dollar"], "SublimeGov.Connected.Apps.Mayor.Salaries", false, function()
            if (GAMEMODE.Config.propertytax) then
                if (not SublimeGov.Config.MayorGetsMoney) then
                    if (not SublimeGov.Config.MayorCanAdjustSalaries) then
                        SublimeGov.CreateNotification(self.L("ui_mayor_salary_disabled_config"), self.L("ui_mayor_salary_disabled_config_desc"), false);
                    else
                        net.Start("SublimeGov.RequestTaxFund");
                        net.SendToServer();
                    end
                else
                    SublimeGov.CreateNotification(self.L("ui_mayor_salary_disabled_config"), self.L("ui_mayor_salary_mayor_gets_money"), false);
                end
            else
                SublimeGov.CreateNotification(self.L("ui_mayor_taxes_disabled"), self.L("ui_mayor_salary_disabled_noti"), false);
            end
        end);

        self:AddApplication(self.L("ui_app_mayor_taxes"), SublimeUI.Materials["Tax"], "SublimeGov.Connected.Apps.Mayor.Taxes", true, function()
            if (not GAMEMODE.Config.propertytax) then
                if (SublimeGov.Config.MayorCanDecide) then
                    local noti = SublimeGov.CreateNotification(self.L("ui_app_mayor_taxes_disabled"), self.L("ui_app_mayor_taxes_disabled_desc"), true);

                    noti.DoAcceptClick = function()
                        net.Start("SublimeGov.MayorChangedTaxes");
                            net.WriteBool(true);
                        net.SendToServer();
                    end

                    noti.DoDeclineClick = function()
                        if (IsValid(self.Main) and IsValid(self.Main.Viewing)) then
                            self.Main.Viewing:Remove();
                        end
                    end

                    net.Start("SublimeGov.RequestTaxFund");
                    net.SendToServer();
                else
                    SublimeGov.CreateNotification(self.L("ui_app_mayor_taxes_disabled"), self.L("ui_app_mayor_taxes_disabled_admin_desc"), false);
                end
            else
                net.Start("SublimeGov.RequestTaxFund");
                net.SendToServer();
            end
        end);
    end

    if (self.Player:IsSuperAdmin()) then
        self:Split(self.L("ui_app_admin"));

        self:AddApplication(self.L("ui_app_admin_database"), SublimeUI.Materials["Developer"], "SublimeGov.Connected.Apps.Database", false);
        self:AddApplication(self.L("ui_app_admin_credits"), SublimeUI.Materials["Credits"], "SublimeGov.Connected.Apps.Credits", true);
    end

    self.Exit = self:Add("DButton");
    
    self.Exit:SetText("");
    self.Exit:SetCursor("arrow");

    self.Exit.Alpha = 0;

    self.Exit.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            if (s.Alpha ~= 0) then
                s.Alpha = self.Approach(s.Alpha, 0, 2);
            end
        end

        SublimeUI.DrawTextOutlined(self.L("ui_app_exit"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    self.Exit.DoClick = function()
        local main = self:GetParent();
        
        if (IsValid(main)) then
            main:Remove();
        end

        SublimeGov.StopViewing();
    end

    self.Exit.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end
end

function panel:Split(str, first)
    local nextButton = #self.Buttons + 1;

    self.Buttons[nextButton] = self:Add("DPanel");
    local button = self.Buttons[nextButton];

    button.MySize       = 16;
    button.MyPadding    = 2;
    button.MyPosition   = self.NextButtonPosition;

    button.Paint = function(s, w, h)
        surface.SetFont("SublimeUI.16");
        local strWidth  = surface.GetTextSize(str);
        local padding   = 10;

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawRect(0, h / 2, (w / 2) - strWidth / 2 - padding, 1);
        surface.DrawRect((w / 2) + strWidth / 2 + padding, h / 2, (w / 2) - strWidth / 2 - padding, 1);

        SublimeUI.DrawTextOutlined(str, "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    self.NextButtonPosition = self.NextButtonPosition + (button.MySize + button.MyPadding);
end

function panel:PerformLayout(w, h)
    for i = 1, #self.Buttons do
        local button = self.Buttons[i];

        if (IsValid(button)) then
            button:SetPos(7, button.MyPosition);
            button:SetSize(w - 14, button.MySize);
        end
    end

    self.Exit:SetPos(7, h - 37);
    self.Exit:SetSize(w - 14, 30);
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_app_applications"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Main", panel, "EditablePanel");