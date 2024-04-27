--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "Title", "Title", FORCE_STRING);
AccessorFunc(panel, "PreDescription", "PreDescription", FORCE_STRING);
AccessorFunc(panel, "Description", "Description", FORCE_STRING);
AccessorFunc(panel, "Function", "Function", FORCE_STRING);

local L;

local functions = {
    ["add_wanted"] = function(criminal, actor)
        if (not IsValid(criminal)) then
            SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))

            return;
        end
        
        local reason = vgui.Create("SublimeGov.Notification");
        reason:SetSize(500, 180);
        reason:Center();
        reason:MakePopup();
        reason:SetDisplayDecline(true);
        reason:SetUseTextEdit(true);
        reason:SetTitle(L("ui_connected_wanted_title"));
        reason:SetDescription(L("ui_connected_wanted_reason", criminal:Nick()));
        reason:SetUseTextEdit(true);

        reason.DoAcceptClick = function(s)
            if (not IsValid(criminal)) then
                SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))

                return true;
            end

            local reasonText = s:GetTextEntryValue();

            if (not reasonText or reasonText == "") then
                return false;
            end

            actor:ConCommand("say /wanted \"" .. criminal:Nick() .. "\" " .. reasonText);
        end
    end,

    ["remove_wanted"] = function(criminal, actor)
        if (not IsValid(criminal)) then
            SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))

            return;
        end
        
        actor:ConCommand("say /unwanted " .. criminal:Nick());
    end,

    ["add_warrant"] = function(criminal, actor)
        if (not IsValid(criminal)) then
            SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))

            return;
        end
        
        local reason = vgui.Create("SublimeGov.Notification");
        reason:SetSize(500, 180);
        reason:Center();
        reason:MakePopup();
        reason:SetDisplayDecline(true);
        reason:SetUseTextEdit(true);
        reason:SetTitle(L("ui_connected_warrant_title"));
        reason:SetDescription(L("ui_connected_warrant_reason", criminal:Nick()));
        reason:SetUseTextEdit(true);

        reason.DoAcceptClick = function(s)
            if (not IsValid(criminal)) then
                SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))
                
                return true;
            end

            local reasonText = s:GetTextEntryValue();

            if (not reasonText or reasonText == "") then
                return false;
            end

            actor:ConCommand("say /warrant \"" .. criminal:Nick() .. "\" " .. reasonText);
        end
    end,

    ["remove_warrant"] = function(criminal, actor)
        if (not IsValid(criminal)) then
            SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))

            return;
        end
        
        actor:ConCommand("say /unwarrant " .. criminal:Nick());
    end,

    ["add_license"] = function(criminal, actor)
        if (not IsValid(criminal)) then
            SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))

            return;
        end
        
        net.Start("SublimeGov.AdjustedGunLicense");
            net.WriteBool(true);
            net.WriteString(criminal:SteamID64());
        net.SendToServer();
    end,

    ["remove_license"] = function(criminal, actor)
        if (not IsValid(criminal)) then
            SublimeGov.CreateNotification(L("ui_player_disconnect"), L("ui_player_disconnect_desc"))

            return;
        end
        
        net.Start("SublimeGov.AdjustedGunLicense");
            net.WriteBool(false);
            net.WriteString(criminal:SteamID64());
        net.SendToServer();
    end,
}

function panel:Init()
    self.L = SublimeGov.L;
    L = self.L;

    self.SysTime    = SysTime();
    self.Approach   = math.Approach;
    self.Player     = LocalPlayer();
    
    self.HasSelected = nil;

    self.TextEntry = self:Add("DTextEntry");
    self.TextEntry:SetValue(self.L("ui_player_search"));
    self.TextEntry:SetDrawLanguageID(false);
    self.TextEntry.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        s:DrawTextEntryText(SublimeUI.White, SublimeUI.Black, SublimeUI.White);
    end

    self.TextEntry.OnChange = function(s)
        local new = s:GetValue();

        self:AddPlayers(new);
    end

    self.ScrollPanel = self:Add("DScrollPanel");
    self.ScrollPanel.Entries = {};

    local vBar = self.ScrollPanel:GetVBar();

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
        if (IsValid(self.HasSelected)) then
            if (not self.HasSelected.Owner) then
                SublimeGov.CreateNotification(self.L("ui_player_invalid"), self.L("ui_player_is_bot"));
            
                return false;
            end

            local criminal = player.GetBySteamID64(self.HasSelected.Owner);
            functions[self.Function](criminal, self.Player);
        end

        self:Remove()
    end

    self.Decline = self:Add("Sublime.Button");
    self.Decline:SetText(self.L("ui_notification_decline"));
    self.Decline:SetTextPos(TEXT_ALIGN_CENTER);
    self.Decline:SetTextColor(SublimeUI.White);
    self.Decline.DoClick = function()
        self:Remove();
    end
end

function panel:Think()
    if (IsValid(self.ScrollPanel) and self.ScrollPanel:GetWide() > 64 and not self.HasAddedPlayers) then
        self:AddPlayers();

        self.HasAddedPlayers = true;
    end
end

function panel:ClearPlayers()
    for i = 1, #self.ScrollPanel.Entries do
        local panel = self.ScrollPanel.Entries[i];

        if (IsValid(panel)) then
            panel:Remove();
        end
    end

    table.Empty(self.ScrollPanel.Entries);
end

function panel:AddPlayers(sort)
    self:ClearPlayers();

    local players   = player.GetAll();
    local w, h      = self.ScrollPanel:GetWide(), self.ScrollPanel:GetTall();

    for i = 1, #players do
        local player = players[i];
        local button;
        local nextPlayer;
        
        if (sort and sort ~= "") then
            sort = sort:lower();

            if (player:Nick():lower():find(sort) or
                player:SteamID():lower():find(sort) or
                (not player:IsBot() and player:SteamID64():find(sort))) then

                nextPlayer = #self.ScrollPanel.Entries + 1;

                self.ScrollPanel.Entries[nextPlayer] = self.ScrollPanel:Add("Sublime.Button");
                button = self.ScrollPanel.Entries[nextPlayer];
                button.Owner = player:SteamID64();
            end
        else
            nextPlayer = i;

            self.ScrollPanel.Entries[i] = self.ScrollPanel:Add("Sublime.Button");
            button = self.ScrollPanel.Entries[i];
            button.Owner = player:SteamID64();
        end

        if (IsValid(button)) then
            button:SetPos(5, 5 + 35 * (nextPlayer - 1));
            button:SetSize(w - 10, 30);
            button:SetText(player:Nick());
            button.Checked = false;

            button.DoClick = function()
                button.Checked = not button.Checked;

                if (IsValid(self.HasSelected)) then
                    self.HasSelected.Checked = false;

                    if (self.HasSelected == button) then
                        self.HasSelected = nil;

                        return;
                    end
                end

                self.HasSelected = button;
            end

            button.PaintOver = function(s, w, h)
                if (s.Checked) then
                    surface.SetDrawColor(255, 255, 255);
                    surface.SetMaterial(SublimeUI.Materials["Check Mark"]);
                    surface.DrawTexturedRect(w - 21, (h / 2) - 8, 16, 16)
                end
            end
        end
    end
end

function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.ScrollPanel:SetPos(7, 38);
    self.ScrollPanel:SetSize(w - 14, h - 116);

    self.TextEntry:SetPos(7, h - 73);
    self.TextEntry:SetSize(w - 14, 30);

    self.Accept:SetPos(7, h - 37);
    self.Accept:SetSize((w / 2) - 14, 30);

    self.Decline:SetPos((w / 2) + 7, h - 37);
    self.Decline:SetSize((w / 2) - 14, 30);
end

function panel:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.SysTime);

    surface.SetDrawColor(255, 255, 255, 255);
    surface.SetMaterial(SublimeUI.Materials["Background"]);
    surface.DrawTexturedRect(0, 0, w, h);
    surface.DrawTexturedRect(2, 2, w - 4, 30);

    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2);
    surface.DrawRect(2, 32, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.Title or "", "SublimeUI.16", 7, 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.TaskHelper", panel, "EditablePanel");