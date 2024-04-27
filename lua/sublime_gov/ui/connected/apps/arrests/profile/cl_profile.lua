--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path  = SublimeUI.GetCurrentPath();
local panel = {};
local main  = nil;

AccessorFunc(panel, "Name", "Name", FORCE_STRING);
AccessorFunc(panel, "Desc", "Desc", FORCE_STRING);
AccessorFunc(panel, "SteamID", "SteamID", FORCE_STRING);

function panel:AddData(parent, id, value, func)
    if (not IsValid(parent)) then
        return false;
    end

    if (not func) then
        func = function()
            SetClipboardText(id .. " " .. value);
        end
    end

    local nextChild = #parent.Children + 1

    parent.Children[nextChild] = parent:Add("DButton");
    local child = parent.Children[nextChild];

    child:SetCursor("arrow");
    child:SetText("");

    child.Alpha = 0;

    child.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        SublimeUI.DrawTextOutlined(id, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(value, "SublimeUI.16", w - 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
    end

    child.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end

    child.DoClick = func;
end

function panel:Init()
    self.L = SublimeGov.L;

    self.Approach = math.Approach;

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

    self.CriminalRecord = self:Add("DPanel");
    
    self.CriminalRecord.Children = {};

    self.CriminalRecord.PerformLayout = function(s, w, h)
        for i = 1, #s.Children do
            local child = s.Children[i];

            if (IsValid(child)) then
                child:SetPos(7, 37 + (35 * (i - 1)));
                child:SetSize(w - 14, 30);
            end
        end
    end

    self.CriminalRecord.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, 31);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, 29)

        SublimeUI.DrawTextOutlined(self.L("ui_connected_criminal"), "SublimeUI.16", w / 2, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
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

        SublimeUI.DrawTextOutlined(self.L("Actions"), "SublimeUI.16", w / 2, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    main = self;
end

function panel:PostInit()
    self:AddData(self.PersonalData, self.L("ui_connected_name"), self.Name);

    local player = player.GetBySteamID64(self.SteamID);

    if (IsValid(player)) then
        local job   = team.GetName(player:Team());

        self:AddData(self.PersonalData, self.L("ui_connected_occupation"),  job);
        self:AddData(self.PersonalData, self.L("ui_connected_age_type"),    player:sGov_GetString("player_age", "unkonwn"));
        self:AddData(self.PersonalData, self.L("ui_connected_race"),        player:sGov_GetString("player_race", "unknown"));
        self:AddData(self.PersonalData, self.L("ui_connected_height"),      player:sGov_GetInt("player_height", "180") .. " cm");

        local status = SublimeGov.Config.Health[#SublimeGov.Config.Health][2];
        for k, v in pairs(SublimeGov.Config.Health) do
            if (player:Health() >= v[1]) then
                status = v[2];

                break;
            end
        end

        self:AddData(self.PersonalData, self.L("ui_connected_health_status"), status);

        local status = SublimeGov.Config.Wealth[#SublimeGov.Config.Wealth][2];
        for k, v in pairs(SublimeGov.Config.Wealth) do
            if (player:getDarkRPVar("money") >= v[1]) then
                status = v[2];

                break;
            end
        end

        self:AddData(self.PersonalData, self.L("ui_connected_wealth_status"), status);

        self:AddData(self.CriminalRecord, "How many times this player has been arrested today", player:sGov_GetInt("todays_arrested_count", 0));
        self:AddData(self.CriminalRecord, "How many times this player has been wanted today", player:sGov_GetInt("todays_wanted_count", 0));
        self:AddData(self.CriminalRecord, "How many times this player has been warranted today", player:sGov_GetInt("todays_warranted_count", 0));

        self:AddData(self.OtherInformation, "Extend Jail Sentence", "", function()
            if (not IsValid(player)) then
                SublimeGov.CreateNotification("Player Disconnected", "It seems that this player has disconnected from the server", false);

                return false;
            end

            SublimeGov.CreateNotification("Are you sure?", "Are you sure you want to extend " .. self.Name .. "'s sentence?", true, function()
                if (not IsValid(player)) then
                    SublimeGov.CreateNotification("Player Disconnected", "It seems that this player has disconnected from the server", false);

                    return false;
                end

                net.Start("SublimeGov.AdjustSentence");
                    net.WriteBool(false);
                    net.WriteString(self.SteamID);
                net.SendToServer();
            end);
        end);

        self:AddData(self.OtherInformation, "Release From Jail", "", function()
            if (not IsValid(player)) then
                SublimeGov.CreateNotification("Player Disconnected", "It seems that this player has disconnected from the server", false);

                return false;
            end

            SublimeGov.CreateNotification("Are you sure?", "Are you sure you want to release " .. self.Name .. " from jail?", true, function()
                if (not IsValid(player)) then
                    SublimeGov.CreateNotification("Player Disconnected", "It seems that this player has disconnected from the server", false);

                    return false;
                end

                net.Start("SublimeGov.AdjustSentence");
                    net.WriteBool(true);
                    net.WriteString(self.SteamID);
                net.SendToServer();
            end);
        end);

        self:AddData(self.OtherInformation, "Add Player Note", "", function()
            local frame = vgui.Create("SublimeGov.Notification");
            frame:SetSize(500, 190);
            frame:Center();
            frame:MakePopup();
            frame:SetDisplayDecline(true);
            frame:SetUseTextEdit(true);
            frame:SetTitle("Add Note");
            frame:SetDescription("Add a small note on this player's profile for other government employees to see. The note can only hold 300 characters.");

            frame.DoAcceptClick = function(s)
                local text = s:GetTextEntryValue();

                if (not text or text == "") then
                    return;
                end

                if (#text > 300) then
                    SublimeGov.CreateNotification("Woah", "Notes can only hold a maximum of 300 characters, yours is currently at " .. #text, false);

                    return false;
                end

                local cd = LocalPlayer().sublime_gov_notes_cooldown
                if (cd and cd > CurTime()) then
                    SublimeGov.CreateNotification("Notes Cooldown", "You can post a new note in " .. string.NiceTime(cd - CurTime()), false);

                    return false;
                end

                net.Start("SublimeGov.AddNote");
                    net.WriteString(text);
                    net.WriteString(self.SteamID);
                net.SendToServer();

                LocalPlayer().sublime_gov_notes_cooldown = CurTime() + 60;
            end

            frame.PaintOver = function(s, w, h)
                local count = #s:GetTextEntryValue();
                local color = count < 301 and SublimeUI.White or SublimeUI.Red;

                SublimeUI.DrawTextOutlined(#s:GetTextEntryValue() .. "/300", "SublimeUI.16", w / 2, h - 61, color, SublimeUI.Black, TEXT_ALIGN_CENTER);
            end
        end);

        self:AddData(self.OtherInformation, "View Player Notes", "", function()
            net.Start("SublimeGov.RequestNoteData");
                net.WriteString(self.SteamID);
            net.SendToServer();
        end);
    end
end

function panel:PerformLayout(w, h)
    self.PersonalData:SetPos(7, 37);
    self.PersonalData:SetSize(w / 3.1, h - 45);

    self.CriminalRecord:SetPos(7 + (w / 3.1) + 5, 37);
    self.CriminalRecord:SetSize((w / 3) + 2, h - 45);

    self.OtherInformation:SetPos(w - (w / 3.1) - 7, 37);
    self.OtherInformation:SetSize(w / 3.1, h - 45);
end

function panel:Think()
    if (not self.HasCalledPostInit and self.SteamID) then
        self:PostInit();

        self.HasCalledPostInit = true;
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1)

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.Name, "SublimeUI.16", 7, 8, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
    local width = surface.GetTextSize(self.Name or "");

    SublimeUI.DrawTextOutlined(self.Desc, "SublimeUI.16", 7 + width, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Arrests.Profile", panel, "EditablePanel");

hook.Add("SublimeGov.CriminalRecordWasUpdated", path, function(data)
    if (not IsValid(main)) then
        return;
    end

    main:AddData(main.CriminalRecord, "How many times this player has been arrested",   data.arrested_count);
    main:AddData(main.CriminalRecord, "How many weapons the police have confiscated",   data.confiscated_count);
    main:AddData(main.CriminalRecord, "How many times this player has been wanted",     data.wanted_count);
    main:AddData(main.CriminalRecord, "How many times this player has been warranted",  data.warranted_count);
end);

hook.Add("SublimeGov.NoteDataUpdated", path, function(data)
    if (not IsValid(main)) then
        return;
    end
    
    local frame = vgui.Create("SublimeGov.Connected.Notes");
    frame:SetSize(500, 600);
    frame:Center();
    frame:SetNotes(data);
    frame:SetSteamID(main.SteamID);
    frame:MakePopup();
end);