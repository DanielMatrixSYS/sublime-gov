--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
 *
 * If you edit this then you are officialy gay, just saying..
--]]------------------------------------------------------------------------------

local panel = {};

local RESET_DATABASE_POLICE     = 0x1;
local RESET_DATABASE_CRIMINAL   = 0x2;
local RESET_DATABASE_COMPUTER   = 0x3;
local RESET_DATABASE_EVERYTHING = 0x4;

function panel:Init()
    self.L = SublimeGov.L;

    self.Options    = {};
    self.Approach   = math.Approach;

    self:AddOption(self.L("ui_database_wipe_police_database"), function()
        SublimeGov.CreateNotification(self.L("ui_database_are_you_sure"), self.L("ui_database_wipe_police_desc"), true, function()
            net.Start("SublimeGov.UpdateDatabase");
                net.WriteUInt(RESET_DATABASE_POLICE, 4);
            net.SendToServer();
        end);
    end);

    self:AddOption(self.L("ui_database_wipe_criminal_database"), function()
        SublimeGov.CreateNotification(self.L("ui_database_are_you_sure"), self.L("ui_database_wipe_criminal_database_desc"), true, function()
            net.Start("SublimeGov.UpdateDatabase");
                net.WriteUInt(RESET_DATABASE_CRIMINAL, 4);
            net.SendToServer();
        end);
    end);

    self:AddOption(self.L("ui_database_wipe_computers"), function()
        SublimeGov.CreateNotification(self.L("ui_database_are_you_sure"), self.L("ui_database_wipe_computers_desc"), true, function()
            net.Start("SublimeGov.UpdateDatabase");
                net.WriteUInt(RESET_DATABASE_COMPUTER, 4);
            net.SendToServer();
        end);
    end);

    self:AddOption(self.L("ui_database_wipe_everything"), function()
        SublimeGov.CreateNotification(self.L("ui_database_are_you_sure"), self.L("ui_database_wipe_everything_desc"), true, function()
            net.Start("SublimeGov.UpdateDatabase");
                net.WriteUInt(RESET_DATABASE_EVERYTHING, 4);
            net.SendToServer();
        end);
    end);
end

function panel:AddOption(text, func)
    local nextOption = #self.Options + 1;

    self.Options[nextOption] = self:Add("Sublime.Button");
    local button = self.Options[nextOption];

    button:SetText(text);

    button.DoClick = func;
end

function panel:PerformLayout(w, h)
    for i = 1, #self.Options do
        local button = self.Options[i];

        button:SetPos(7, 37 + (35 * (i - 1)));
        button:SetSize(300, 30);
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_database"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Database", panel, "EditablePanel");