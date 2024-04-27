--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};
local main  = nil;

function panel:Init()
    self.L = SublimeGov.L;

    self.Approach = math.Approach;

    self.DefaultColumnSize  = 100;

    self.PlayerList = self:Add("DPanel");

    self.PlayerList.Columns = {};
    self.PlayerList.NextColumnPosition = 2;

    self.PlayerList.Rows = {};

    self.PlayerList.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.DrawRect(2, 31, w - 4, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        surface.DrawRect(2, 30, w - 4, 1);
    end

    self.PlayerList.PerformLayout = function(s, w, h)
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
                panel:SetPos(0, 30 * (i - 1));
                panel:SetSize(w, 30);
            end
        end

        if (IsValid(self.ScrollPanel)) then
            self.ScrollPanel:SetPos(2, 32);
            self.ScrollPanel:SetSize(w - 4, h - 34);
        end
    end

    self.ScrollPanel = self.PlayerList:Add("DScrollPanel");
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

    main = self;
end

function panel:Clear()
   for i = 1, #self.PlayerList.Rows do
        local panel = self.PlayerList.Rows[i];

        if (IsValid(panel)) then
            panel:Remove();
        end
    end

    table.Empty(self.PlayerList.Rows);
end

function panel:PostInit(clear)
    if (clear) then
        self:Clear();
    end

    local maxWidth      = self.PlayerList:GetWide();
    local columns       = 3;
    local columnWidth   = maxWidth / columns;

    self:AddColumn(self.L("ui_connected_name"), columnWidth, _, "name");
    self:AddColumn(self.L("ui_license_occupation"), columnWidth, _, "occupation");
    self:AddColumn(self.L("ui_mayor_salary"), columnWidth - 3, true, "salary");

    local players = player.GetAll();

    for i = 1, #players do
        local player = players[i];

        if (IsValid(player) and SublimeGov.IsJobCP(player)) then
            local row = self:AddRow(player, columnWidth);
        end
    end
end

function panel:AddColumn(name, size, last, sort_type, func)
    local board         = self.PlayerList;
    local nextColumn    = #board.Columns + 1;

    board.Columns[nextColumn] = board:Add("DButton");
    local column = board.Columns[nextColumn];

    column:SetText("");
    column:SetCursor("arrow");

    column.ColumnPosition   = board.NextColumnPosition;
    column.GivenSize        = size;
    column.Alpha            = 0;
    column.Descending       = false;

    column.Paint = function(s, w, h)
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

        SublimeUI.DrawTextOutlined(name, "SublimeUI.16", 5, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    end

    column.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end

    board.NextColumnPosition = board.NextColumnPosition + size;
end

function panel:AddRow(player, pos)
    local board      = self.PlayerList;
    local nextRow    = #board.Rows + 1;

    board.Rows[nextRow] = self.ScrollPanel:Add("DButton");
    local row = board.Rows[nextRow];

    row:SetCursor("arrow");
    row:SetText("");

    row.Alpha       = 0;
    row.Owner       = player:SteamID64() or "BOT";

    local pName     = player:Nick();
    local pTeam     = team.GetName(player:Team());
    local pSalary   = DarkRP.formatMoney(RPExtraTeams[player:Team()].salary or 0);
    local pColor    = team.GetColor(player:Team());

    row.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawRect(0, h - 1, w, 1);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawRect(0, h - 2, w, 1);

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            if (s.Alpha ~= 0) then
                s.Alpha = self.Approach(s.Alpha, 0, 2);
            end
        end

        SublimeUI.DrawTextOutlined(pName, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(pTeam, "SublimeUI.16", pos + 4, (h / 2) - 8, pColor, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(pSalary, "SublimeUI.16", (pos * 2) + 4, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_LEFT);
    end

    row.DoClick = function()
        SublimeGov.CreateNotification(self.L("ui_database_are_you_sure"), self.L("ui_mayor_demote", pName), true, function()
            net.Start("SublimeGov.ForceADemote");
                net.WriteString(row.Owner);
            net.SendToServer();

            if (IsValid(row)) then
                row:Remove();

                timer.Simple(.4, function()
                    self:PostInit(true);
                end);
            end
        end);
    end

    return row;
end

function panel:Think()
    if (self.PlayerList:GetWide() > 64 and not self.HasCalledPostInit) then
        self:PostInit()

        self.HasCalledPostInit = true;
    end
end

function panel:PerformLayout(w, h)
    self.PlayerList:SetPos(7, 37);
    self.PlayerList:SetSize(w - 14, h - 44);
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_mayor_employees"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined(self.L("ui_mayor_employees_desc"), "SublimeUI.16", w - 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
end
vgui.Register("SublimeGov.Connected.Apps.Mayor.Employees", panel, "EditablePanel");