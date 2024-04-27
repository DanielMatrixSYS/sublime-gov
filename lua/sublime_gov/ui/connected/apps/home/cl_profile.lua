--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path  = SublimeUI.GetCurrentPath();
local panel = {};
local main  = nil;

function panel:AddData(parent, id, value)
    if (not IsValid(parent)) then
        return false;
    end

    local nextChild = #parent.Children + 1

    parent.Children[nextChild] = parent:Add("DPanel");
    local child = parent.Children[nextChild];

    child.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        SublimeUI.DrawTextOutlined(id, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(value, "SublimeUI.16", w - 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
    end
end

function panel:Init()
    self.L      = SublimeGov.L;
    self.Player = LocalPlayer();

    self.PersonalData = self:Add("DPanel");
    
    self.PersonalData.Children = {};

    self.PersonalData.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local child = s.Children[i];

            if (IsValid(child)) then
                child:SetPos(7, 37 + (35 * (i - 1)));
                child:SetSize(w - 14, 30);
            end
        end
    end

    self.PersonalData.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, 31);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, 29)

        SublimeUI.DrawTextOutlined(self.L("ui_connected_personal"), "SublimeUI.16", w / 2, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    self.PoliceRecord = self:Add("DPanel");
    
    self.PoliceRecord.Children = {};

    self.PoliceRecord.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local child = s.Children[i];

            if (IsValid(child)) then
                child:SetPos(7, 37 + (35 * (i - 1)));
                child:SetSize(w - 14, 30);
            end
        end
    end

    self.PoliceRecord.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, 31);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, 29)

        SublimeUI.DrawTextOutlined(self.L("ui_connected_personal_police"), "SublimeUI.16", w / 2, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    self.OtherInformation = self:Add("DPanel");
    
    self.OtherInformation.Children = {};

    self.OtherInformation.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local child = s.Children[i];

            if (IsValid(child)) then
                child:SetPos(7, 37 + (35 * (i - 1)));
                child:SetSize(w - 14, 30);
            end
        end
    end

    self.OtherInformation.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, 31);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, 29)

        SublimeUI.DrawTextOutlined(self.L("ui_connected_other"), "SublimeUI.16", w / 2, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    main = self;
end

function panel:PostInit()
    if (IsValid(self.Player)) then
        local job = team.GetName(self.Player:Team());

        self:AddData(self.PersonalData, self.L("ui_connected_name"),        self.Player:Nick());
        self:AddData(self.PersonalData, self.L("ui_connected_occupation"),  job);
        self:AddData(self.PersonalData, self.L("ui_connected_age_type"),    self.Player:sGov_GetString("player_age", "unkonwn"));
        self:AddData(self.PersonalData, self.L("ui_connected_race"),        self.Player:sGov_GetString("player_race", "unknown"));
        self:AddData(self.PersonalData, self.L("ui_connected_height"),      self.Player:sGov_GetInt("player_height", "180") .. " cm");

        local status = SublimeGov.Config.Health[#SublimeGov.Config.Health][2];
        for k, v in pairs(SublimeGov.Config.Health) do
            if (self.Player:Health() >= v[1]) then
                status = v[2];

                break;
            end
        end

        self:AddData(self.PersonalData, self.L("ui_connected_health_status"), status);

        local status = SublimeGov.Config.Wealth[#SublimeGov.Config.Wealth][2];
        for k, v in pairs(SublimeGov.Config.Wealth) do
            if (self.Player:getDarkRPVar("money") >= v[1]) then
                status = v[2];

                break;
            end
        end

        self:AddData(self.PersonalData, self.L("ui_connected_wealth_status"), status);

        self:AddData(self.OtherInformation, "Currently lives in",       game.GetMap());
        self:AddData(self.OtherInformation, "Arrest count today",       self.Player:sGov_GetInt("police_todays_arrested_count", 0));
        self:AddData(self.OtherInformation, "Wanted count today",       self.Player:sGov_GetInt("police_todays_wanted_count", 0));
        self:AddData(self.OtherInformation, "Warranted count today",    self.Player:sGov_GetInt("police_todays_warranted_count", 0));
    end
end

function panel:PerformLayout(w, h)
    self.PersonalData:SetPos(7, 37);
    self.PersonalData:SetSize(w / 3.1, h - 45);

    self.PoliceRecord:SetPos(7 + (w / 3.1) + 5, 37);
    self.PoliceRecord:SetSize((w / 3.1) + 3, h - 45);

    self.OtherInformation:SetPos(w - (w / 3.1) - 7, 37);
    self.OtherInformation:SetSize(w / 3.1, h - 45);
end

function panel:Think()
    if (not self.HasCalledPostInit and self.Player) then
        self:PostInit();

        self.HasCalledPostInit = true;
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_profile_statistics"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Home.Profile", panel, "EditablePanel");

hook.Add("SublimeGov.PersonalPoliceDataUpdated", path, function(data)
    if (not IsValid(main)) then
        return;
    end

    main:AddData(main.PoliceRecord, "Kills", data.kills);
    main:AddData(main.PoliceRecord, "Deaths", data.deaths);
    main:AddData(main.PoliceRecord, "Teamkills", data.teamkills);
    main:AddData(main.PoliceRecord, "Arrested", data.arrested_count);
    main:AddData(main.PoliceRecord, "Salary earned", DarkRP.formatMoney(data.salary));
    main:AddData(main.PoliceRecord, "Hours on duty", string.NiceTime(data.seconds));
end);