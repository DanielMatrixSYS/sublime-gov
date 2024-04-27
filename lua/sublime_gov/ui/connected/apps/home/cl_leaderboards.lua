--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path  = SublimeUI.GetCurrentPath();
local panel = {};

function panel:Init()
    self.L = SublimeGov.L;

    self.Employees      = {};
    self.Leaderboards   = {};

    self.Color = Color;
    self.EmployeeColor = {
        self.Color(200, 200, 0, 50),
        self.Color(192, 192, 192, 25),
        self.Color(80, 50, 20, 25)
    }

    local players = player.GetAll();
    for i = 1, #players do
        local player = players[i];

        if (IsValid(player)) then
            if (player:sGov_GetInt("seconds_on_duty") and SublimeGov.IsJobCP(player)) then
                table.insert(self.Leaderboards, {nick = player:Nick(), time = player:sGov_GetInt("seconds_on_duty")});
            end
        end
    end

    table.SortByMember(self.Leaderboards, "time");

    for i = 1, #self.Leaderboards do
        if (i > 10) then
            return true;
        end
        
        local data = self.Leaderboards[i];
        local nick = data.nick;
        local time = data.time;

        self:AddEmployee(nick, time);
    end
end

function panel:AddEmployee(name, time)
    local nextEmployee = #self.Employees + 1;

    self.Employees[nextEmployee] = self:Add("Sublime.EmptyFrame");
    local employee = self.Employees[nextEmployee];

    employee.PaintOver = function(s, w, h)
        if (self.EmployeeColor[nextEmployee]) then
            local x, y = s:LocalToScreen(0, 0);

            SublimeUI.LinearGradient(x + 2, y + 2, w - 4, h - 4, 
            {
                {offset = 0,    color = self.EmployeeColor[nextEmployee]}, 
                {offset = 0.75, color = self.Color(0, 0, 0, 0)}
            }, true);
        end

        SublimeUI.DrawTextOutlined(nextEmployee .. ".", "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

        local width     = surface.GetTextSize(nextEmployee .. ".");
        local padding   = 2;

        SublimeUI.DrawTextOutlined(name, "SublimeUI.16", 7 + (width + padding), (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        
        local width = surface.GetTextSize(string.NiceTime(time) .. ".");
        SublimeUI.DrawTextOutlined(string.NiceTime(time) .. ".", "SublimeUI.16", w - 7, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_RIGHT);
        SublimeUI.DrawTextOutlined(self.L("ui_leaderboards_tota_time_spent") .. " ", "SublimeUI.16", w - 7 - width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
    end
end

function panel:PerformLayout(w, h)
    for i = 1, #self.Employees do
        local panel = self.Employees[i];

        panel:SetPos(7, 37 + (35 * (i - 1)));
        panel:SetSize(w - 14, 30);
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_leaderboards_top_10"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

    if (#self.Employees < 1) then
        SublimeUI.DrawTextOutlined(SublimeUI.textWrap(self.L("ui_leaderboards_empty"), "SublimeUI.16", w - 50), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end
end
vgui.Register("SublimeGov.Connected.Apps.Home.Leaderboards", panel, "EditablePanel");