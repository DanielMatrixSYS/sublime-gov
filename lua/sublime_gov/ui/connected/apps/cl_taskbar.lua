--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path  = SublimeUI.GetCurrentPath();
local panel = {};
local frame;
local main;

function panel:Init()
    self.L = SublimeGov.L;

    self.Buttons    = {};
    self.Approach   = math.Approach;
    self.Player     = LocalPlayer();
    self.Lockdown   = GetGlobalBool("DarkRP_LockDown");

    self:CreateButtons();

    main = self;
end

function panel:CreateButtons()
    self:AddButton(self.L("ui_make_wanted"), self.L("ui_make_wanted_desc"), "add_wanted");
    self:AddButton(self.L("ui_remove_wanted"), self.L("ui_remove_wanted_desc"), "remove_wanted");
    self:AddButton(self.L("ui_make_warrant"), self.L("ui_make_warrant_desc"), "add_warrant");
    self:AddButton(self.L("ui_remove_warrant"), self.L("ui_remove_warrant_desc"), "remove_warrant");
    self:AddButton(self.L("ui_grant_license"), self.L("ui_grant_license_desc"), "add_license");
    self:AddButton(self.L("ui_revoke_license"), self.L("ui_revoke_license_desc"), "remove_license");

    if (self.Player:isMayor()) then
        self:AddButton(self.L("ui_quick_start_lottery"), _, "start_lottery");

        self:CreateLockdownButtons(self.Lockdown);
    end
end

function panel:CreateLockdownButtons(status)
    if (status) then
        self:AddButton(self.L("ui_quick_stop_lockdown"), _, "stop_lockdown");
    else
        self:AddButton(self.L("ui_quick_start_lockdown"), _, "start_lockdown");
    end
end

function panel:Refresh()
    for i = 1, #self.Buttons do
        local button = self.Buttons[i];

        if (IsValid(button)) then
            button:Remove();
        end
    end

    table.Empty(self.Buttons);

    self:CreateButtons();

    return true;
end

function panel:AddButton(text, desc, id, func)
    local nextButton = #self.Buttons + 1;

    func = func or function() return true; end

    self.Buttons[nextButton] = self:Add("DButton");
    local button = self.Buttons[nextButton];

    button:SetText("");

    button.Alpha = 0;

    button.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w, h);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            if (s.Alpha ~= 0) then
                s.Alpha = self.Approach(s.Alpha, 0, 2);
            end
        end

        SublimeUI.DrawTextOutlined(text, "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    button.DoClick = function(s, w, h)
        if (id == "start_lottery") then
            SublimeGov.CreateNotification(self.L("ui_mayor_lottery"), self.L("ui_are_you_sure_quick"), true, function()
                self.Player:ConCommand("say /lottery 250");
            end);
        elseif (id == "start_lockdown") then
            SublimeGov.CreateNotification(self.L("ui_lockdown"), self.L("ui_start_lockdown"), true, function()
                self.Player:ConCommand("say /lockdown");

                func(button);
            end);
        elseif (id == "stop_lockdown") then
            SublimeGov.CreateNotification(self.L("ui_lockdown"), self.L("ui_stop_lockdown"), true, function()
                self.Player:ConCommand("say /unlockdown");

                func(button);
            end);
        else
            if (IsValid(frame)) then
                frame:Remove();
            end

            frame = vgui.Create("SublimeGov.Connected.TaskHelper");
            frame:SetSize(500, 300);
            frame:Center();
            frame:MakePopup();
            frame:SetTitle(self.L("ui_select_a_player", text));
            frame:SetDescription(desc);
            frame:SetFunction(id);
        end
    end

    button.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end

    return button, nextButton;
end

function panel:PerformLayout(w, h)
    local totalWidth = w - (7 + #self.Buttons * 132);

    for i = 1, #self.Buttons do
        local button = self.Buttons[i];

        if (IsValid(button)) then
            button:SetPos(totalWidth / 2 + (7 + (132 * (i - 1))), 7);
            button:SetSize(125, h - 14);
        end
    end
end

function panel:OnRemove()
    if (IsValid(frame)) then
        frame:Remove();
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

    local date, time = os.date, os.time();

    SublimeUI.DrawTextOutlined(date("%X", time), "SublimeUI.16", w - 7, (h / 2) - 16, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
    SublimeUI.DrawTextOutlined(date("%x", time), "SublimeUI.12", w - 12, (h / 2) + 3, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
end
vgui.Register("SublimeGov.Connected.Taskbar", panel, "EditablePanel");

hook.Add("SublimeGov.LockdownStatus", path, function(status)
    if (IsValid(main)) then
        main.Lockdown = status;
        main:Refresh();
    end
end);