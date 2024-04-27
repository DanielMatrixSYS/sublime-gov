--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

local panel = {};

function panel:Init()
    self.L = SublimeGov.L;

    self.WantedList = self:Add("DPanel");
    self.WantedList.Children = {};

    self.WantedList.RemoveButton = function(button)
        if (IsValid(button)) then
            for i = 1, #self.WantedList.Children do
                local stored_buttons = self.WantedList.Children[i];

                if (IsValid(stored_buttons) and stored_buttons == button) then
                    button:Remove();
                    table.remove(self.WantedList.Children, i);

                    break;
                end
            end

            self.WantedList:InvalidateLayout(true);
        end
    end

    self.WantedList.AddChild = function(player)
        local main      = self.WantedList;
        local nextChild = #main.Children + 1;

        if (not IsValid(main.ScrollPanel)) then
            return;
        end

        main.Children[nextChild] = main.ScrollPanel:Add("Sublime.Button");
        local button = main.Children[nextChild];

        button:SetText("");

        button.PaintOver = function(s, w, h)
            if (not IsValid(player)) then
                return;
            end
            
            local size  = surface.GetTextSize;
            local width = 0;

            local name = player:Nick();
            SublimeUI.DrawTextOutlined(name, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(name);
            
            local was_wanted_by = " " .. self.L("was wanted by") .. " ";
            SublimeUI.DrawTextOutlined(was_wanted_by, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(was_wanted_by);

            local actor = player:sGov_GetString("wanted_actor");
            if (not actor or actor == "") then
                actor = "Unknown";
            end

            SublimeUI.DrawTextOutlined(actor, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Blue, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(actor);

            local wanted_for = " for ";
            SublimeUI.DrawTextOutlined(wanted_for, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(wanted_for);

            local reason = player:sGov_GetString("wanted_reason");
            if (not reason or reason == "") then
                reason = "Unknown reasons";
            end

            SublimeUI.DrawTextOutlined(reason, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_LEFT);
        end

        button.Think = function()
            if (not IsValid(player) and IsValid(button)) then
                self.WantedList.RemoveButton(button);

                return true;
            end

            if (not player:isWanted()) then
                self.WantedList.RemoveButton(button);

                return true;
            end
        end

        button.DoClick = function()
            return true;
        end
    end

    self.WantedList.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local button = s.Children[i];

            if (IsValid(button)) then
                button:SetPos(0, 35 * (i - 1));
                button:SetSize(w - 14, 30);
            end
        end

        if (IsValid(s.ScrollPanel)) then
            s.ScrollPanel:SetPos(7, 37);
            s.ScrollPanel:SetSize(w - 14, h - 44);
        end
    end

    self.WantedList.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);
        surface.DrawRect(2, 30, w - 4, 1);

        if (#s.Children < 1) then
            SublimeUI.DrawTextOutlined(self.L("ui_wanted_noone"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        end

        SublimeUI.DrawTextOutlined(self.L("ui_wanted_current"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    end

    self.WantedList.ScrollPanel = self.WantedList:Add("DScrollPanel");
    local vBar = self.WantedList.ScrollPanel:GetVBar();

    vBar:SetWidth(0);

    vBar.Paint = function()
        return true;
    end

    vBar.btnUp.Paint = function()
        return true;
    end

    vBar.btnDown.Paint = function()
        return true;
    end

    vBar.btnGrip.Paint = function()
        return true;
    end

    self.WarrantList = self:Add("DPanel");
    self.WarrantList.Children = {};

    self.WarrantList.RemoveButton = function(button)
        if (IsValid(button)) then
            for i = 1, #self.WarrantList.Children do
                local stored_buttons = self.WarrantList.Children[i];

                if (IsValid(stored_buttons) and stored_buttons == button) then
                    button:Remove();
                    table.remove(self.WarrantList.Children, i);

                    break;
                end
            end

            self.WarrantList:InvalidateLayout(true);
        end
    end

    self.WarrantList.AddChild = function(player)
        local main      = self.WarrantList;
        local nextChild = #main.Children + 1;

        main.Children[nextChild] = main:Add("Sublime.Button");
        local child = main.Children[nextChild];

        child:SetText("");

        child.PaintOver = function(s, w, h)
            if (not IsValid(player)) then
                return;
            end
            
            local size  = surface.GetTextSize;
            local width = 0;

            local name = player:Nick();
            SublimeUI.DrawTextOutlined(name, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(name);
            
            local is_warranted_for = " " .. self.L("was warranted by") .. " ";
            SublimeUI.DrawTextOutlined(is_warranted_for, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(is_warranted_for);

            local actor = player:sGov_GetString("warrant_actor");
            if (not actor or actor == "") then
                actor = "Unknown";
            end

            SublimeUI.DrawTextOutlined(actor, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Blue, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(actor);

            local reason_for = " " .. "for" .. " ";
            SublimeUI.DrawTextOutlined(reason_for, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(reason_for);

            local reason = player:sGov_GetString("warranted_reason");
            if (not reason or reason == "") then
                reason = "Unknown reasons";
            end

            SublimeUI.DrawTextOutlined(reason, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_LEFT);
        end

        child.Think = function()
            if (not IsValid(player) and IsValid(child)) then
                self.WarrantList.RemoveButton(child);

                return true;
            end

            if (not player:sGov_GetBool("warranted", false)) then
                self.WarrantList.RemoveButton(child);

                return true;
            end
        end
    end

    self.WarrantList.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local child = s.Children[i];

            if (IsValid(child)) then
                child:SetPos(7, 37 + (35 * (i - 1)));
                child:SetSize(w - 14, 30);
            end
        end
    end

    self.WarrantList.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        surface.DrawRect(2, 30, w - 4, 1);

        if (#s.Children < 1) then
            SublimeUI.DrawTextOutlined(self.L("ui_warranted_noone"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        end

        SublimeUI.DrawTextOutlined(self.L("ui_warranted_current"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    end

    local players = player.GetAll();
    for i = 1, #players do
        local player = players[i];
        
        if (IsValid(player) and player:isWanted()) then
            self.WantedList.AddChild(player);
        end
    end

    for i = 1, #players do
        local player = players[i];
        
        if (IsValid(player) and player:sGov_GetBool("warranted", false)) then
            self.WarrantList.AddChild(player);
        end
    end
end

function panel:PerformLayout(w, h)
    self.WantedList:SetPos(7, 37);
    self.WantedList:SetSize((w / 2) - 14, (h / 2) - 16);

    self.WarrantList:SetPos((w / 2) - 2, 37);
    self.WarrantList:SetSize((w / 2) - 4, (h / 2) - 16);

    if (IsValid(self.Profile)) then
        self.Profile:SetPos(7, (h / 2) + 26);
        self.Profile:SetSize(w - 14, h - (h / 2) - 33);
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_wanted_and_warrants"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Wanted", panel, "EditablePanel");