--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path  = SublimeUI.GetCurrentPath();
local panel = {};
local main  = nil;

function panel:Init()
    self.L = SublimeGov.L;

    self.Approach   = math.Approach;
    self.Player     = LocalPlayer();

    self.DefaultColumnSize  = 100;
    self.CurrentPage        = 1;
    self.TotalPages         = 1;

    self.Leaderboards = self:Add("DPanel");

    self.Leaderboards.Columns = {};
    self.Leaderboards.NextColumnPosition = 2;

    self.Leaderboards.Rows = {};

    self.Leaderboards.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        surface.DrawRect(2, 30, w - 4, 1);
    end

    self.Leaderboards.PerformLayout = function(s, w, h)
        for i = 1, #s.Columns do
            local panel = s.Columns[i];

            if (IsValid(panel)) then
                panel:SetPos(panel.ColumnPosition, 2);
                panel:SetSize(panel.GivenSize, 28);
            end
        end

        for i = 1, #s.Rows do
            local panel = s.Rows[i];
            
            if (IsValid(panel)) then
                panel:SetPos(2, 32 + (30 * (i - 1)));
                panel:SetSize(w - 4, 30);
            end
        end
    end

    self.PageDisplay = self:Add("DPanel");
    self.PageDisplay.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        surface.DrawRect(2, 30, w - 4, 1);

        SublimeUI.DrawTextOutlined(self.L("ui_viewing_page", self.CurrentPage, self.TotalPages), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    self.NextPage = self:Add("Sublime.Button");

    self.NextPage:SetText("Next Page");
    self.NextPage:SetMaterial(SublimeUI.Materials["Right Arrow"]);

    self.NextPage.DoClick = function()
        if (self.CurrentPage >= self.TotalPages or (self.Cooldown and self.Cooldown > CurTime())) then
            return;
        else
            self.CurrentPage = self.CurrentPage + 1;
        end

        self:RequestNewData();
    end

    self.PreviousPage = self:Add("Sublime.Button");

    self.PreviousPage:SetText("Previous Page");
    self.PreviousPage:SetMaterial(SublimeUI.Materials["Right Arrow"]);
    self.PreviousPage:SetRotateMaterial(180);

    self.PreviousPage.DoClick = function()
        if (self.CurrentPage <= 1 or (self.Cooldown and self.Cooldown > CurTime())) then
            return;
        else
            self.CurrentPage = self.CurrentPage - 1;
        end

        self:RequestNewData();
    end

    main = self;
end

function panel:RequestNewData()
    net.Start("SublimeGov.RequestLeaderboardsData");
        net.WriteUInt(self.CurrentPage, 32);
    net.SendToServer();

    self.Cooldown = CurTime() + 1;
end

function panel:PostInit()
    local maxWidth      = self.Leaderboards:GetWide();
    local columns       = 9;
    local columnWidth   = maxWidth / columns;

    self:AddColumn("Position", columnWidth - 50, SublimeUI.White);
    self:AddColumn("Name", columnWidth + 100, SublimeUI.White);
    self:AddColumn("Kills", columnWidth, SublimeUI.Red);
    self:AddColumn("Deaths", columnWidth, SublimeUI.Red);
    self:AddColumn("Teamkills", columnWidth, SublimeUI.Red);
    self:AddColumn("Arrests", columnWidth, SublimeUI.Blue);
    self:AddColumn("Wanted", columnWidth, SublimeUI.Blue);
    self:AddColumn("Salary", columnWidth, SublimeUI.Green);
    self:AddColumn("Duty Hours", columnWidth - 3, SublimeUI.Green, true);
end

function panel:AddColumn(name, size, color, last)
    local board         = self.Leaderboards;
    local nextColumn    = #board.Columns + 1;

    board.Columns[nextColumn] = board:Add("DButton");
    local row = board.Columns[nextColumn];

    row:SetText("");
    row:SetCursor("arrow");

    row.ColumnPosition  = board.NextColumnPosition;
    row.GivenSize       = size;
    row.Alpha           = 0;

    row.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(0, 0, w, h);

        if (not last) then
            surface.SetDrawColor(SublimeUI.Black);
            surface.DrawRect(w - 1, 0, 1, h);

            surface.SetDrawColor(SublimeUI.Outline);
            surface.DrawRect(w - 2, 0, 1, h);
        end

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            if (s.Alpha ~= 0) then
                s.Alpha = self.Approach(s.Alpha, 0, 2);
            end
        end

        SublimeUI.DrawTextOutlined(name, "SublimeUI.16", 5, (h / 2) - 8, color, SublimeUI.Black, TEXT_ALIGN_LEFT);
    end

    row.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end

    board.NextColumnPosition = board.NextColumnPosition + size;
end

function panel:AddRow()
    local board      = self.Leaderboards;
    local nextRow    = #board.Rows + 1;

    board.Rows[nextRow] = board:Add("DPanel");
    local row = board.Rows[nextRow];

    row.Stats       = {};
    row.Position    = 0;

    row.AddPlayer = function(data)
        for i = 1, #data do
            local stat      = data[i];
            local size      = stat.size;
            local value     = stat.value;
            local avatar    = stat.avatar;
            local steamid   = stat.steamid;
            local id        = stat.id;
            local canEdit   = stat.canedit;

            row.Stats[i] = row:Add("DButton");
            local panel = row.Stats[i];
            
            panel:SetText("");

            panel.GivenSize = size;
            panel.Position  = row.Position;
            panel.Owner     = steamid;
            panel.Alpha     = 0;

            row.Position = row.Position + size;

            panel.Paint = function(s, w, h)
            surface.SetDrawColor(0, 0, 0, s.Alpha);
            surface.DrawRect(0, 0, w, h);
                if (s:IsHovered()) then
                    s.Alpha = self.Approach(s.Alpha, 100, 8);
                else
                    if (s.Alpha ~= 0) then
                        s.Alpha = self.Approach(s.Alpha, 0, 2);
                    end
                end

                if (avatar) then
                    SublimeUI.DrawTextOutlined(value, "SublimeUI.16", 28, (h / 2) - 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
                else
                    SublimeUI.DrawTextOutlined(value, "SublimeUI.16", 5, (h / 2) - 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
                end
            end

            panel.DoClick = function()
                if (not SublimeGov.Config.Administrators[self.Player:GetUserGroup()]) then
                    return;
                end
                
                if (canEdit == false) then
                    return;
                end

                local noti = SublimeGov.CreateNotification("Change or Reset?", "Do you want to make changes to the column you selected for this player or reset all of them completely?", true);

                noti:SetAcceptText("Change");
                noti:SetDeclineText("Reset");

                noti.DoAcceptClick = function()
                    local frame = vgui.Create("SublimeGov.Notification");
                    frame:SetSize(500, 190);
                    frame:Center();
                    frame:MakePopup();
                    frame:SetDisplayDecline(true);
                    frame:SetUseTextEdit(true);
                    frame:SetTitle(("Current value for %s is %s"):format(id, value));
                    frame:SetDescription("What should the new value for " .. id .. " to be?");
                    frame:SetTextEditTemp(value);

                    frame.DoAcceptClick = function(s)
                        local newValue = s:GetTextEntryValue():gsub("%,", "");
                        newValue = newValue:match("%d+");

                        net.Start("SublimeGov.AdminAdjustedData");
                            net.WriteString(row.Owner);
                            net.WriteString(id);
                            net.WriteUInt(tonumber(newValue), 32);
                        net.SendToServer();

                        self:RequestNewData();
                    end
                end

                noti.DoDeclineClick = function(s)
                    local newValue = s:GetTextEntryValue():gsub("%,", "");
                    newValue = newValue:match("%d+");

                    net.Start("SublimeGov.AdminResetData");
                        net.WriteString(row.Owner);
                    net.SendToServer();

                    self:RequestNewData();
                end
            end

            if (avatar) then
                row.Stats[i].Avatar = row.Stats[i]:Add("AvatarImage");
                row.Stats[i].Avatar:SetSteamID(steamid, 184);

                row.Owner = steamid;
            end
        end
    end

    row.PerformLayout = function(s, w, h)
        for i = 1, #s.Stats do
            local stat = s.Stats[i];

            if (IsValid(stat)) then
                stat:SetPos(stat.Position, 0);
                stat:SetSize(stat.GivenSize - 2, h - 2);

                if (stat.Avatar) then
                    stat.Avatar:SetPos(7, (h / 2) - 9);
                    stat.Avatar:SetSize(16, 16);
                end
            end
        end
    end

    row.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        --surface.DrawRect(0, 0, w, 1);
        surface.DrawRect(0, h - 1, w, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        --surface.DrawRect(0, 1, w, 1)
        surface.DrawRect(0, h - 2, w, 1)
    end

    return row;
end

function panel:Think()
    if (self.Leaderboards:GetWide() > 64 and not self.HasCalledPostInit) then
        self:PostInit()

        self.HasCalledPostInit = true;
    end
end

function panel:Clear()
    for i = 1, #self.Leaderboards.Rows do
        local row = self.Leaderboards.Rows[i];

        if (IsValid(row)) then
            row:Remove();
        end
    end

    table.Empty(self.Leaderboards.Rows);
end

function panel:PerformLayout(w, h)
    self.Leaderboards:SetPos(7, 37);
    self.Leaderboards:SetSize(w - 14, h - 88);

    surface.SetFont("SublimeUI.16");
    local width = surface.GetTextSize(self.L("ui_viewing_page", self.CurrentPage, self.TotalPages)) + 14;

    self.PageDisplay:SetPos((w / 2) - width / 2, h - 37);
    self.PageDisplay:SetSize(width, 30);

    local padding   = 100;
    local size      = 122
    self.NextPage:SetPos(w - (size + 7), h - 37);
    self.NextPage:SetSize(size, 30);

    self.PreviousPage:SetPos(7, h - 37);
    self.PreviousPage:SetSize(size, 30);
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_leaderboards_title"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined("The numbers shown is their all time total amount.", "SublimeUI.16", w - 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
end
vgui.Register("SublimeGov.Connected.Apps.Leaderboards", panel, "EditablePanel");

hook.Add("SublimeGov.LeaderboardsHasBeenUpdated", path, function(data, max)
    if (IsValid(main)) then
        main.TotalPages = max;

        main:Clear();

        local maxWidth      = main.Leaderboards:GetWide();
        local columns       = 9;
        local columnWidth   = maxWidth / columns;

        local comma = string.Comma;

        for i = 1, #data do
            local player_data = data[i];

            if (player_data) then
                local row = main:AddRow();
                row.AddPlayer({
                    {
                        size    = columnWidth - 50,
                        value   = player_data.position,
                        canedit = false
                    },
                    
                    {
                        size    = columnWidth + 100,
                        value   = steamworks.GetPlayerName(player_data.steamid),
                        steamid = player_data.steamid,
                        id      = "name",
                        canedit = false,
                        avatar  = true,
                    },

                    {
                        size    = columnWidth,
                        value   = comma(player_data.kills),
                        id      = "kills",
                    },

                    {
                        size    = columnWidth,
                        value   = comma(player_data.deaths),
                        id      = "deaths",
                    },

                    {
                        size    = columnWidth,
                        value   = comma(player_data.teamkills),
                        id      = "teamkills",
                    },

                    {
                        size    = columnWidth,
                        value   = comma(player_data.arrested_count),
                        id      = "arrested_count",
                    },

                    {
                        size    = columnWidth,
                        value   = comma(player_data.wanted_count),
                        id      = "wanted_count",
                    },

                    {
                        size    = columnWidth,
                        value   = DarkRP.formatMoney(player_data.salary_total),
                        id      = "salary_total",
                    },

                    {
                        size    = columnWidth - 3,
                        value   = string.NiceTime(player_data.seconds_on_duty),
                        id      = "seconds_on_duty",
                    }, 
                });
            end
        end
    end
end);