--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

function panel:CanEdit()
    if (IsValid(self.Player) and self.Player:getAgendaTable() ~= nil) then
        if (self.Player:getAgendaTable()["ManagersByKey"] and self.Player:getAgendaTable()["ManagersByKey"][self.Player:Team()]) then
            return true;
        end
    end

    return false;
end

function panel:Init()
    self.Player = LocalPlayer();
    self.L      = SublimeGov.L;

    -- If he has permission to edit the agenda.

    if (self:CanEdit()) then
        self.EditAgenda = self:Add("Sublime.Button");
        self.EditAgenda:SetTextPos(TEXT_ALIGN_CENTER);
        self.EditAgenda:SetText(self.L("ui_agenda_edit_agenda"));

        self.EditAgenda.DoClick = function()
            local agenda = (self.Player:getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n");

            local frame = vgui.Create("SublimeGov.Notification");
            frame:SetSize(500, 180);
            frame:Center();
            frame:MakePopup();
            frame:SetDisplayDecline(true);
            frame:SetUseTextEdit(true);
            frame:SetTitle(self.L("ui_agenda_edit_agenda"));
            frame:SetDescription(self.L("ui_agenda_edit_description", self.Player:Nick()));
            frame:SetTextEditTemp(agenda);

            frame.DoAcceptClick = function(s)
                self.Player:ConCommand("say /agenda " .. s:GetTextEntryValue());
            end
        end
    end
end

function panel:PerformLayout(w, h)
    if (IsValid(self.EditAgenda)) then
        self.EditAgenda:SetPos(7, h - 37);
        self.EditAgenda:SetSize(w - 14, 30);
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    local agendaData = self.Player:getAgendaTable();

    if (not agendaData) then
        SublimeUI.DrawTextOutlined(self.L("ui_agenda_empty"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        
        return;
    end

    SublimeUI.DrawTextOutlined(agendaData.Title, "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

    local agenda = SublimeUI.textWrap((self.Player:getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "SublimeUI.16", w - 7)
    SublimeUI.DrawTextOutlined(agenda, "SublimeUI.16", 7, 37, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

    if (not agenda or agenda == "") then
        SublimeUI.DrawTextOutlined(self.L("ui_agenda_empty"), "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end
end
vgui.Register("SublimeGov.Connected.Apps.Home.Agenda", panel, "EditablePanel");