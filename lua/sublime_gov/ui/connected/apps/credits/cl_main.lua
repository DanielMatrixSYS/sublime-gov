--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
 *
 * If you edit this then you are officialy gay, just saying..
--]]------------------------------------------------------------------------------

local panel = {};

function panel:Init()
    self.L = SublimeGov.L;

    self.Credits    = {};
    self.Approach   = math.Approach;

    local size = self:AddCategory("DEVELOPED BY", 400);
    self:AddCredit("Fluffy", "Coder", size);
    self:AddCredit("Oubliette", "Computer Entity", size);

    self:AddSplit();

    self:AddCategory("TRANSLATIONS BY", size);
    self:AddCredit("Fluffy", "English", size);
    self:AddCredit("Yam", "French", size);
    self:AddCredit("ashibot", "German", size);
    self:AddCredit("MatStef132", "Polish", size);

    self:AddSplit();

    self:AddCategory("SPECIAL THANKS TO", size);
    self:AddCredit("2REK", "Computer Model", size);
    self:AddCredit("Adi", "Gmodstore Banner", size);
    self:AddCredit("Covid-Kim", "Great Sacrifice", size);

    self:AddSplit();
    
    self:AddCategory("ICONS BY", size);
    self:AddCredit("Flaticon.com", "And its creators", size);
end

function panel:AddCredit(player, description, size)
    local nextSetting = #self.Credits + 1

    self.Credits[nextSetting] = self:Add("DPanel");
    local panel = self.Credits[nextSetting];

    panel.Size = size;

    panel.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        SublimeUI.DrawTextOutlined(player, "SublimeUI.16", 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(description, "SublimeUI.16", w - 7, (h / 2) - 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
    end
end

function panel:AddSplit()
    local nextSetting = #self.Credits + 1
    
    self.Credits[nextSetting] = self:Add("DPanel");
    local panel = self.Credits[nextSetting];

    panel.Paint = function(s, w, h)
        return true;
    end
end

function panel:AddCategory(title, size)
    local nextSetting = #self.Credits + 1

    self.Credits[nextSetting] = self:Add("DPanel");
    local panel = self.Credits[nextSetting];

    panel.Size = size == nil and surface.GetTextSize(title) or size;

    panel.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        SublimeUI.DrawTextOutlined(title, "SublimeUI.16", w / 2, (h / 2) - 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end

    return panel.Size;
end

function panel:PerformLayout(w, h)
    for i = 1, #self.Credits do
        local setting = self.Credits[i];

        if (IsValid(setting)) then
            local size  = setting.Size and setting.Size or 202;

            setting:SetPos((w / 2) - (size / 2), 37 + 35 * (i - 1));
            setting:SetSize(size + 14, 30);
        end
    end
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined("Credits", "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("SublimeGov.Connected.Apps.Credits", panel, "EditablePanel");