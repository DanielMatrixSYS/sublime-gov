--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path  = SublimeUI.GetCurrentPath();
local panel = {};
local main  = nil;

AccessorFunc(panel, "ShouldInsertNews", "ShouldInsertNews", FORCE_BOOL);

function panel:Init()
    self.L = SublimeGov.L;

    self.NewsCount  = 0;
    
    self.Leaderboards   = self:Add("SublimeGov.Connected.Apps.Home.Leaderboards");
    self.Agenda         = self:Add("SublimeGov.Connected.Apps.Home.Agenda");
    self.Profile        = self:Add("SublimeGov.Connected.Apps.Home.Profile");
    self.Recent         = self:Add("DPanel");

    self.Recent.Children = {};

    self.Recent.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local panel = s.Children[i];

            if (IsValid(panel)) then
                panel:SetPos(7, 37 + 35 * (i - 1));
                panel:SetSize(w - 14, 30);
            end
        end
    end

    self.Recent.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        surface.DrawRect(2, 30, w - 4, 1);

        SublimeUI.DrawTextOutlined(self.L("ui_recent_news"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

        if (#s.Children < 1) then
            SublimeUI.DrawTextOutlined(self.L("ui_no_recent_news"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        end
    end

    main = self;
end

function panel:AddNews(victim, officer, result, time, color)
    if (IsValid(self.Recent)) then
        if (self.NewsCount + 1 > SublimeGov.MaxNewsEntries) then
            self.Recent.Children[1]:Remove();
            table.remove(self.Recent.Children, 1); 
        end

        local recent    = self.Recent;
        local nextChild = #recent.Children + 1

        recent.Children[nextChild] = recent:Add("DPanel");
        local panel = recent.Children[nextChild];

        panel.textOffset = 0;

        panel.Paint = function(s, w, h)
            surface.SetDrawColor(0, 0, 0, 255);
            surface.DrawOutlinedRect(0, 0, w, h);

            surface.SetDrawColor(SublimeUI.Outline);
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
            surface.DrawRect(2, 32, w - 4, 1)

            surface.SetFont("SublimeUI.16");
            s.textOffset = surface.GetTextSize(victim .. " ");

            SublimeUI.DrawTextOutlined(victim, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            SublimeUI.DrawTextOutlined(result, "SublimeUI.16", 7 + s.textOffset, (h / 2) - 8, color, SublimeUI.Black, TEXT_ALIGN_LEFT);
            
            if (officer ~= "") then
                s.textOffset = s.textOffset + surface.GetTextSize(result .. " ");
                SublimeUI.DrawTextOutlined(officer, "SublimeUI.16", 7 + s.textOffset, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            end

            SublimeUI.DrawTextOutlined(string.NiceTime(os.time() - time) .. " " .. self.L("ui_connected_ago") .. ".", "SublimeUI.16", w - 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
        end

        self.NewsCount = self.NewsCount + 1;
    end
end

function panel:Think()
    if (self.ShouldInsertNews and not self.HasAddedNews) then
        for i = 1, #SublimeGov.News do
            local data      = SublimeGov.News[i];
            local victim    = data.victim;
            local officer   = data.officer;
            local result    = data.result;
            local time      = data.time;
            local color     = data.color;

            self:AddNews(victim, officer, result, time, color);
        end

        self.HasAddedNews = true;
    end
end

function panel:PerformLayout(w, h)
    local size = 400;
    local tall = 389;

    self.Recent:SetPos(w - (size + 7), 37);
    self.Recent:SetSize(size, tall);

    self.Leaderboards:SetPos(7, 37);
    self.Leaderboards:SetSize(w - (size + 19), tall);

    self.Agenda:SetPos(w - (size + 7), 42 + tall);
    self.Agenda:SetSize(size, h - (tall + 49));

    self.Profile:SetPos(7, 42 + tall);
    self.Profile:SetSize(w - (size + 19), h - (tall + 49));
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_home"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Home", panel, "EditablePanel");

hook.Add("SublimeGov.NewsHaveBeenUpdated", path, function(news)
    table.SortByMember(news, "time");

    if (IsValid(main)) then
        for i = 1, #news do
            local data      = news[i];
            local victim    = data.victim;
            local officer   = data.officer;
            local result    = data.result;
            local time      = data.time;
            local color     = data.color;

            main:AddNews(victim, officer, result, time, color);
        end
    end
end);