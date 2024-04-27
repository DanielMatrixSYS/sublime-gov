--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};
local path  = SublimeUI.GetCurrentPath();
local main  = nil;

function panel:Init()
    self.L = SublimeGov.L;

    self.Data       = {};
    self.Categories = {};
    self.Player     = LocalPlayer();

    self.Comma      = string.Comma;
    self.Approach   = math.Approach;

    self.Combat    = self:AddCategory(self.L("ui_stats_combat"), SublimeUI.Red, SublimeUI.Materials["Combat"]);
    self.General   = self:AddCategory(self.L("ui_stats_general"), SublimeUI.Blue, SublimeUI.Materials["General"]);
    self.Other     = self:AddCategory(self.L("ui_stats_other"), SublimeUI.Green, SublimeUI.Materials["Other"]);

    main = self;
end

function panel:Sort()
    for i = 1, #self.Data do
        local data  = self.Data[i];
        local id    = data.identifier:lower();

        if (id:find("kill") or id:find("death") or id:find("damage")) then
            self.Data[i].category = self.Combat;
        elseif(id:find("count")) then
            self.Data[i].category = self.General;
        else
            self.Data[i].category = self.Other;
        end
    end

    self:CreateStatistics();
end

function panel:CreateStatistics()
    for i = 1, #self.Data do
        local data          = self.Data[i];
        local id            = data.identifier;
        local value         = data.value;
        local category      = data.category;

        if (IsValid(category)) then
            category.AddStat(self.L("ui_statistics_" .. id), value);
        end
    end
end

function panel:AddCategory(name, color, mat)
    local nextCategory = #self.Categories + 1;

    self.Categories[nextCategory] = self:Add("DPanel");
    local panel = self.Categories[nextCategory];

    panel.Stats = {};

    panel.AddStat = function(name, value)
        local nextStat = #panel.Stats + 1;

        panel.Stats[nextStat] = panel:Add("DPanel");
        local child = panel.Stats[nextStat];

        child.Paint = function(s, w, h)
            surface.SetDrawColor(0, 0, 0, 255);
            surface.DrawOutlinedRect(0, 0, w, h);

            surface.SetDrawColor(SublimeUI.Outline);
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

            SublimeUI.DrawTextOutlined(name, "SublimeUI.16", 7, 7, color, SublimeUI.Black, TEXT_ALIGN_LEFT);

            local formatFunc    = name:lower():find(self.L("ui_statistics_salary_total"):lower()) and DarkRP.formatMoney or self.Comma;
            local value         = name:lower():find(self.L("ui_statistics_seconds_on_duty"):lower()) and math.Round(value / 60 / 60) or value;
            SublimeUI.DrawTextOutlined(formatFunc(value), "SublimeUI.16", w - 7, 7, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
        end
    end

    panel.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, 30);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, 28);

        surface.SetDrawColor(255, 255, 255);
        surface.SetMaterial(mat);
        surface.DrawTexturedRect(7, 7 , 16, 16);
        surface.DrawTexturedRect(w - 23, 7 , 16, 16);

        SublimeUI.DrawTextOutlined(name, "SublimeUI.16", w / 2, 7, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    panel.PerformLayout = function(s, w, h)
        for i = 1, #s.Stats do
            local stat = s.Stats[i];

            if (IsValid(stat)) then
                stat:SetPos(0, 35 + (35 * (i - 1)));
                stat:SetSize(w, 30);
            end
        end
    end

    return panel;
end

function panel:PerformLayout(w, h)
    for i = 1, #self.Categories do
        local panel = self.Categories[i];

        if (IsValid(panel)) then
            local pos           = 7;
            local totalCats     = 3;
            local padding       = 5;
            local size          = self:GetWide() / totalCats - (padding * (totalCats - 1)) + (pos / totalCats);

            panel:SetPos(pos + ((size + padding) * (i - 1)), 37);
            panel:SetSize(size, h - 42);
        end
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_stats_global"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined(self.L("ui_stats_together"), "SublimeUI.16", w - 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
end
vgui.Register("SublimeGov.Connected.Apps.Statistics", panel, "EditablePanel");

hook.Add("SublimeGov.StatisticsDataUpdated", path, function(data)
    if (IsValid(main)) then
        main.Data = data;
        main:Sort();
    end
end);