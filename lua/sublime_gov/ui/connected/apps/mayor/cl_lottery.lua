--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

function panel:Init()
    self.L = SublimeGov.L;

    self.Players    = {};
    self.Approach   = math.Approach;
    self.Format     = string.format;
    self.Size       = surface.GetTextSize;
    self.Everyone   = player.GetAll();

    for i = 1, #self.Everyone do
        local player = self.Everyone[i];

        if (player:sGov_GetBool("lottery_winner")) then
            local nextPlayer = #self.Players + 1;

            self.Players[nextPlayer] = self:Add("DButton");
            local button = self.Players[nextPlayer];

            button.Alpha = 0;

            button:SetText("");

            local nick      = player:Nick();
            local amount    = player:sGov_GetInt("lottery_amount");
            local time      = player:sGov_GetInt("lottery_time");

            self.Players[nextPlayer].Paint = function(s, w, h)
                surface.SetDrawColor(0, 0, 0, s.Alpha);
                surface.DrawRect(2, 2, w - 4, h - 4);

                surface.SetDrawColor(0, 0, 0);
                surface.DrawOutlinedRect(0, 0, w, h)

                surface.SetDrawColor(SublimeUI.Outline);
                surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

                if (s:IsHovered()) then
                    s.Alpha = self.Approach(s.Alpha, 100, 8);
                else
                    if (s.Alpha ~= 0) then
                        s.Alpha = self.Approach(s.Alpha, 0, 2);
                    end
                end

                local pos = 7;
                SublimeUI.DrawTextOutlined(nick, "SublimeUI.16", pos, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
                pos = pos + self.Size(nick .. " ");

                SublimeUI.DrawTextOutlined(self.L("ui_mayor_lottery_won"), "SublimeUI.16", pos, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
                pos = pos + self.Size(self.L("ui_mayor_lottery_won") .. " ");

                SublimeUI.DrawTextOutlined(string.NiceTime(os.time() - time) .. " " .. self.L("ui_connected_ago") "SublimeUI.16", pos, (h / 2) - 8, SublimeUI.Red, SublimeUI.Black, TEXT_ALIGN_LEFT);
                pos = pos + self.Size(string.NiceTime(os.time() - time) .. " " .. self.L("ui_connected_ago"));
                
                SublimeUI.DrawTextOutlined(self.L("ui_mayor_lottery_stunning"), "SublimeUI.16", pos, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
                pos = pos + self.Size(self.L("ui_mayor_lottery_stunning") .. " ");

                SublimeUI.DrawTextOutlined(DarkRP.formatMoney(amount) .. ".", "SublimeUI.16", pos, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_LEFT);
            end

            self.Players[nextPlayer].OnCursorEntered = function()
                surface.PlaySound("sublimeui/button.mp3");
            end
        end
    end
end

function panel:PerformLayout(w, h)
    for i = 1, #self.Players do
        local button = self.Players[i];

        button:SetPos(7, 37 + (35 * (i - 1)));
        button:SetSize(w - 14, 30);
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_mayor_lottery"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined(self.L("ui_mayor_lottery_desc"), "SublimeUI.16", w- 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);

    if (#self.Players <= 0) then
        SublimeUI.DrawTextOutlined(self.L("ui_mayor_lottery_noone"), "SublimeUI.24", w / 2, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end
end
vgui.Register("SublimeGov.Connected.Apps.Mayor.Lottery", panel, "EditablePanel");