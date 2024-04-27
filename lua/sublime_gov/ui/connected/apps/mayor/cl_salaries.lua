--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local taxMoney = 0;

local path  = SublimeUI.GetCurrentPath();
local panel = {};

local round = math.Round;

function panel:Init()
    self.L = SublimeGov.L;

    self.Panels     = {};
    self.Approach   = math.Approach;

    self.CanCallPostInit = false;

    self.ScrollPanel = self:Add("DScrollPanel");
    self.ScrollPanel.Paint = function(s, w, h)
        --surface.SetDrawColor(125, 0, 0, 50);
        --surface.DrawRect(0, 0, w, h);
    end
end

function panel:AddJob(data)
    local nextPanel = #self.Panels + 1;

    self.Panels[nextPanel] = self.ScrollPanel:Add("DPanel");
    local panel = self.Panels[nextPanel];

    panel.Team      = data.team; 
    panel.Name      = data.name or false;
    panel.Salary    = data.salary or 0;
    panel.Extra     = data.extraSalary or 0; 

    panel.Color     = team.GetColor(data.team);
    panel.CanEdit   = panel.Name ~= false;

    panel.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 255);
        surface.DrawOutlinedRect(0, 0, w / 2, h);

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, (w / 2) - 2, h - 2)

        SublimeUI.DrawTextOutlined(s.Name, "SublimeUI.16", 7, h / 2, s.Color, SublimeUI.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        SublimeUI.DrawTextOutlined(DarkRP.formatMoney(s.Salary) .. "(+" .. DarkRP.formatMoney(s.Extra) .. ") = " .. DarkRP.formatMoney(s.Salary + s.Extra), "SublimeUI.16", (w / 2) - 7, h / 2, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
    end

    panel.Slider = panel:Add("DSlider");
    local slider = panel.Slider;

    local minmax = {0, 100};

    slider.HasSaved     = false;
    slider.SaveCooldown = false;

    slider.Paint = function(s, w, h)
        local num   = w / 10;
	    local space = w / num

        surface.SetDrawColor(255, 255, 255, 100)
        for i = 0, num do
            surface.DrawRect(i * space, h - 5, 1, 5);
        end

        surface.SetDrawColor(255, 255, 255, 100);
        surface.DrawRect(0, h / 2 - 1, w, 1);

        SublimeUI.DrawTextOutlined(SublimeGov.Config.Salaries[1], "SublimeUI.12", 0, -2, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(SublimeGov.Config.Salaries[2], "SublimeUI.12", w, -2, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_RIGHT);
    end

    local fracToVal = function(val)
        return round(SublimeGov.Config.Salaries[1] + (val * (SublimeGov.Config.Salaries[2] - SublimeGov.Config.Salaries[1])));
    end

    slider.OnValueChanged = function(s, frac)
        panel.Extra = fracToVal(frac);
    end

    slider.TranslateValues = function(slider, x, y)
        slider:OnValueChanged(x);
        return x, y;
    end

    local old = slider.Knob.OnMouseReleased;
    slider.Knob.OnMouseReleased = function(s)
        net.Start("SublimeGov.SalaryChanged");
            net.WriteUInt(panel.Team, 32);
            net.WriteUInt(panel.Extra, 32);
        net.SendToServer();

        old(s);
    end

    slider:SetSlideX(panel.Extra / SublimeGov.Config.Salaries[2]);
end

function panel:PostInit()
    local jobs = RPExtraTeams;

    for i = 1, #jobs do
        local jobData   = jobs[i];
        local jobIndex  = jobData.team;

        if (SublimeGov.IsJobCP(jobIndex)) then
            self:AddJob(jobData);
        end
    end
end

function panel:Think()
    if (GAMEMODE.Config.propertytax and self.CanCallPostInit and not self.HasCalledPostInit) then
        self:PostInit();

        self.HasCalledPostInit = true;
    end
end

function panel:PerformLayout(w, h)
    for i = 1, #self.Panels do
        local panel = self.Panels[i];

        if (IsValid(panel) and IsValid(self.ScrollPanel)) then
            local width = self.ScrollPanel:GetWide();

            panel:SetPos(0, 40 * (i - 1));
            panel:SetSize(width, 30);

            local slider = panel.Slider;
            if (IsValid(slider)) then
                local w, h = panel:GetWide(), panel:GetTall();
                
                slider:SetPos((w / 2) + 10, 0);
                slider:SetSize((w / 2) - 20, 30);
            end
        end
    end

    if (IsValid(self.ScrollPanel)) then
        self.ScrollPanel:SetPos(7, 37);
        self.ScrollPanel:SetSize(w / 2, h - 45);
    end
end

function panel:DrawBackground(w, h)
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_app_mayor_salaries"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
    SublimeUI.DrawTextOutlined(self.L("ui_mayor_tax_fund", DarkRP.formatMoney(taxMoney)), "SublimeUI.16", w - 7, 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_RIGHT);

    if (GAMEMODE.Config.propertytax) then
        if (not SublimeGov.Config.MayorGetsMoney) then
            if (not SublimeGov.Config.MayorCanAdjustSalaries) then
                SublimeUI.DrawTextOutlined(self.L("ui_mayor_salary_disabled"), "SublimeUI.18", w / 2, h / 2, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
            else
                self:DrawBackground(w, h);
                self.CanCallPostInit = true;
            end
        else
            if (SublimeGov.Config.MayorCanAdjustSalaries) then
                SublimeUI.DrawTextOutlined(SublimeUI.textWrap(self.L("ui_mayor_salary_and_mayor_gets_money"), "SublimeUI.18", w - 100), "SublimeUI.18", w / 2, h / 2, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
            else
                SublimeUI.DrawTextOutlined(self.L("ui_mayor_salary_disabled_config_desc"), "SublimeUI.18", w / 2, h / 2, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
            end
        end
    end
end
vgui.Register("SublimeGov.Connected.Apps.Mayor.Salaries", panel, "EditablePanel");

hook.Add("SublimeGov.TaxUpdated", path, function(amount)
    taxMoney = amount;
end);