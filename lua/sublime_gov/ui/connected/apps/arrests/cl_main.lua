--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

local panel = {};
local arrestPanel = nil;
local unArrestPanel = nil;

function panel:Init()
    self.L = SublimeGov.L;

    self.Arrests = self:Add("DPanel");
    self.Arrests.Children = {};

    self.Arrests.RemoveButton = function(button)
        if (IsValid(button)) then
            for i = 1, #self.Arrests.Children do
                local stored_buttons = self.Arrests.Children[i];

                if (IsValid(stored_buttons) and stored_buttons == button) then
                    button:Remove();
                    table.remove(self.Arrests.Children, i);

                    break;
                end
            end

            self.Arrests:InvalidateLayout(true);
        end
    end

    self.Arrests.AddChild = function(player)
        local main      = self.Arrests;
        local nextChild = #main.Children + 1;

        if (not IsValid(main.ScrollPanel)) then
            return;
        end

        main.Children[nextChild] = main.ScrollPanel:Add("Sublime.Button");
        local button = main.Children[nextChild];

        button:SetText("");
        button.Owner = player:SteamID64()

        button.PaintOver = function(s, w, h)
            if (not IsValid(player)) then
                return;
            end
            
            local size  = surface.GetTextSize;
            local width = 0;

            local name = player:Nick();
            SublimeUI.DrawTextOutlined(name, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(name);
            
            local arrested_by = " " .. self.L("ui_connected_arrested_by") .. " ";
            SublimeUI.DrawTextOutlined(arrested_by, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(arrested_by);

            local actor = player:sGov_GetString("arrested_actor", "Console");
            SublimeUI.DrawTextOutlined(actor, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Blue, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(actor);

            local released_in = " " .. self.L("ui_connected_released_in") .. " ";
            SublimeUI.DrawTextOutlined(released_in, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(released_in);

            SublimeUI.DrawTextOutlined(string.NiceTime(player:sGov_GetInt("arrested_for") - os.time()), "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_LEFT);
        end

        button.CanContinue = function()
            if (not IsValid(player)) then
                SublimeGov.CreateNotification("Disconnected", "This player has left the server.", false);

                return false;
            end

            return true;
        end

        button.Think = function()
            if (not IsValid(player) and IsValid(button)) then
                self.Arrests.RemoveButton(button);

                return true;
            end

            if (player:sGov_GetInt("arrested_for", 0) - os.time() < 1) then
                self.Arrests.RemoveButton(button);

                return true;
            end

            if (not player:isArrested()) then
                self.Arrests.RemoveButton(button);
            end
        end

        button.DoClick = function()
            local localplayer = LocalPlayer();
            if (localplayer.sgov_criminal_req_cd and localplayer.sgov_criminal_req_cd > CurTime()) then
                return;
            end

            if (not IsValid(player)) then
                local notification = vgui.Create("SublimeGov.Notification");
                notification:SetSize(500, 225);
                notification:Center();
                notification:MakePopup();
                notification:SetDisplayDecline(false);
                notification:SetTitle(self.L("ui_connected_disconnected"));
                notification:SetDescription(self.L("ui_connected_disconnected_description"));

                return false;
            end

            if (IsValid(self.Profile)) then
                local profile_steamid = self.Profile:GetSteamID();

                if (profile_steamid and profile_steamid ~= "") then
                    if (profile_steamid == player:SteamID64()) then
                        return false;
                    end
                end

                self.Profile:Remove();
            end

            if (not player:IsBot()) then
                net.Start("SublimeGov.RequestCriminalRecord");
                    net.WriteString(player:SteamID64());
                net.SendToServer();
            end

            self.Profile = self:Add("SublimeGov.Connected.Apps.Arrests.Profile");
            self.Profile:SetName(player:Nick());
            self.Profile:SetDesc(self.L("ui_connected_profile"));
            self.Profile:SetSteamID(player:SteamID64());

            localplayer.sgov_criminal_req_cd = CurTime() + 2;

            return true;
        end
    end

    self.Arrests.PerformLayout = function(s, w, h)
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

    self.Arrests.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        surface.DrawRect(2, 30, w - 4, 1);

        if (#s.Children < 1) then
            SublimeUI.DrawTextOutlined(self.L("ui_connected_jail_empty"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        end

        SublimeUI.DrawTextOutlined(self.L("ui_connected_arrested_criminals"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    end

    self.Arrests.ScrollPanel = self.Arrests:Add("DScrollPanel");
    local vBar = self.Arrests.ScrollPanel:GetVBar();

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

    self.Unarrests = self:Add("DPanel");
    self.Unarrests.Children = {};

    self.Unarrests.AddChild = function(victim, officer, released)
        local main      = self.Unarrests;
        local nextChild = #main.Children + 1;

        main.Children[nextChild] = main:Add("Sublime.Button");
        local child = main.Children[nextChild];

        child:SetText("");

        child.PaintOver = function(s, w, h)
            SublimeUI.DrawTextOutlined(victim, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
            local size = surface.GetTextSize;
            local width = size(victim);

            local was_released = " " .. self.L("ui_connected_was_released") .. " ";
            SublimeUI.DrawTextOutlined(was_released, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
            width = width + size(was_released);

            local time = string.NiceTime(os.time() - released) .. " " .. self.L("ui_connected_ago");
            SublimeUI.DrawTextOutlined(time, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_LEFT);

            -- The officers name, or identify can be "unknown".
            -- the reason why their name can be unknown is because,
            -- administrators or the server owner might unarrest people through console,
            -- or code.
            if (officer and officer:lower() ~= "unknown") then
                width = width + size(time);

                local by = " " .. self.L("ui_connected_by") .. " ";
                SublimeUI.DrawTextOutlined(by, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
                width = width + size(by);

                SublimeUI.DrawTextOutlined(officer, "SublimeUI.16", 7 + width, (h / 2) - 8, SublimeUI.Blue, SublimeUI.Black, TEXT_ALIGN_LEFT);
            end
        end
    end

    self.Unarrests.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local child = s.Children[i];

            if (IsValid(child)) then
                child:SetPos(7, 37 + (35 * (i - 1)));
                child:SetSize(w - 14, 30);
            end
        end
    end

    self.Unarrests.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        surface.DrawRect(2, 30, w - 4, 1);

        if (#s.Children < 1) then
            SublimeUI.DrawTextOutlined(self.L("ui_connected_none_recently_released"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        end

        SublimeUI.DrawTextOutlined(self.L("ui_connected_recently_released"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    end

    local players   = player.GetAll();
    local arrested  = {};
    for i = 1, player.GetCount() do
        local player = players[i];

        if (IsValid(player) and player:isArrested()) then
            table.insert(arrested, {player = player, time = player:sGov_GetInt("arrested_for")});
        end
    end

    table.SortByMember(arrested, "time", true);
    for i = 1, #arrested do
        local data      = arrested[i];
        local victim    = data.player;
        
        if (IsValid(victim)) then
            self.Arrests.AddChild(victim);
        end
    end

    -- So we can interact with the panels in the hooks.
    arrestPanel     = self.Arrests;
    unArrestPanel   = self.Unarrests;
end

function panel:PerformLayout(w, h)
    self.Arrests:SetPos(7, 37);
    self.Arrests:SetSize((w / 2) - 14, (h / 2) - 16);

    self.Unarrests:SetPos((w / 2) - 2, 37);
    self.Unarrests:SetSize((w / 2) - 4, (h / 2) - 16);

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

    SublimeUI.DrawTextOutlined(self.L("ui_app_arrests_and_release"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Arrests", panel, "EditablePanel");

hook.Add("SublimeGov.PlayerWasArrested", path, function(player)
    if (not IsValid(arrestPanel)) then
        return;
    end

    -- SteamID64 returns nothing for bots client side, so theres no need to check for anything.
    if (player:IsBot()) then
        arrestPanel.AddChild(player);

        return;
    end
    
    local steamid = player:SteamID64();
    for i = 1, #arrestPanel.Children do
        local button = arrestPanel.Children[i];

        if (IsValid(button)) then
            if (button.Owner == steamid) then
                return;
            end
        end
    end

    arrestPanel.AddChild(player);
end);

hook.Add("SublimeGov.ReleasedDataWasUpdated", path, function(updated_data)
    if (not IsValid(unArrestPanel)) then
        return;
    end

    table.SortByMember(updated_data, "released");

    for i = 1, #updated_data do
        local data          = updated_data[i];
        local victim_nick   = data.victim_nick;
        local officer_nick  = data.officer_nick;
        local released      = data.released;

        unArrestPanel.AddChild(victim_nick, officer_nick, released);
    end
end);