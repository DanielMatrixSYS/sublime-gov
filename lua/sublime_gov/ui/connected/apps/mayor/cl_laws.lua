--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};
local main  = nil;

function panel:Init()
    self.L = SublimeGov.L;

    self.Approach   = math.Approach;
    self.Format     = string.format;
    self.Player     = LocalPlayer();

    self.Laws       = DarkRP.getLaws();
    self.AddedLaws  = {};

    self.Reset = self:Add("Sublime.Button");
    self.Reset:SetTextPos(TEXT_ALIGN_CENTER);
    self.Reset:SetText(self.L("ui_mayor_laws_reset_laws"));
    self.Reset.DoClick = function()
        SublimeGov.CreateNotification(self.L("ui_mayor_reset"), self.L("ui_mayor_are_you_sure"), true, function()
            self.Player:ConCommand("say /resetlaws");

            timer.Simple(.3, function()
                if (IsValid(self)) then
                    self.Laws = DarkRP.getLaws();
                    self:AddAllLaws();
                end
            end);
        end);
    end

    self.AddLaws = self:Add("Sublime.Button");
    self.AddLaws:SetTextPos(TEXT_ALIGN_CENTER);
    self.AddLaws:SetText(self.L("ui_mayor_law_add"));
    self.AddLaws.DoClick = function()
        local frame = vgui.Create("SublimeGov.Notification");
        frame:SetSize(500, 190);
        frame:Center();
        frame:MakePopup();
        frame:SetDisplayDecline(true);
        frame:SetUseTextEdit(true);
        frame:SetTitle(self.L("ui_mayor_law_create"));
        frame:SetDescription(self.L("ui_mayor_what"));
        frame:SetTextEditTemp("");

        frame.DoAcceptClick = function(s)
            self.Player:ConCommand("say /addlaw " .. s:GetTextEntryValue());

            timer.Simple(.2, function()
                if (IsValid(self)) then
                    self:AddAllLaws();
                end
            end);
        end
    end

    self:AddAllLaws();
end

function panel:AddAllLaws()
    for i = 1, #self.AddedLaws do
        local law = self.AddedLaws[i];

        if (IsValid(law)) then
            law:Remove();
        end
    end

    table.Empty(self.AddedLaws);

    for i = 1, #self.Laws do
        self.AddedLaws[i] = self:Add("Sublime.Button");
        self.AddedLaws[i]:SetText(self.Format("%i. %s", i, self.Laws[i]));
        self.AddedLaws[i].CanChange = i >= 4 and true or false;

        self.AddedLaws[i].DoClick = function(s, w, h)   
            if (s.CanChange) then
                local notify = SublimeGov.CreateNotification(self.L("ui_mayor_change_or"), self.L("ui_mayor_change_or_decs"), true);
                notify:SetAcceptText(self.L("ui_mayor_change"));
                notify:SetDeclineText(self.L("ui_mayor_remove"));

                notify.DoAcceptClick = function()
                    local frame = vgui.Create("SublimeGov.Notification");
                    frame:SetSize(500, 190);
                    frame:Center();
                    frame:MakePopup();
                    frame:SetDisplayDecline(true);
                    frame:SetUseTextEdit(true);
                    frame:SetTitle(self.L("ui_mayor_edit", i));
                    frame:SetDescription(self.L("ui_mayor_what_change"));
                    frame:SetTextEditTemp(self.Laws[i]);

                    frame.DoAcceptClick = function(s)
                        self.Player:ConCommand("say /removelaw " .. i);
                        local law = s:GetTextEntryValue();

                        timer.Simple(.8, function()
                            if (IsValid(self.Player)) then
                                self.Player:ConCommand("say /addlaw " .. law);
                            end
                        end);

                        self.AddedLaws[i]:SetText(self.Format("%i. %s", i, law));
                    end
                end

                notify.DoDeclineClick = function()
                    self.Player:ConCommand("say /removelaw " .. i);

                    timer.Simple(.4, function()
                        if (IsValid(self)) then
                            self:AddAllLaws();
                        end
                    end);
                end
            else
                SublimeGov.CreateNotification(self.L("ui_mayor_cant_edit"), self.L("ui_mayor_cant_edit_desc"));
            end
        end
    end
end

function panel:Think()
end

function panel:PerformLayout(w, h)
    for i = 1, #self.AddedLaws do
        local button = self.AddedLaws[i];

        if (IsValid(button)) then
            button:SetPos(7, 37 + (35 * (i - 1)));
            button:SetSize(w - 14, 30);
        end
    end

    self.Reset:SetPos(7, h - 37);
    self.Reset:SetSize(w - 14, 30);

    self.AddLaws:SetPos(7, h - 72);
    self.AddLaws:SetSize(w - 14, 30);
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_mayor_laws"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Mayor.Laws", panel, "EditablePanel");