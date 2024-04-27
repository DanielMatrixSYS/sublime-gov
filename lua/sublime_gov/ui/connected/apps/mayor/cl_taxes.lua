--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local propertyTax   = math.Round(SublimeGov.Config.PropertyTax[2] / 2);
local salaryTax     = math.Round(SublimeGov.Config.SalaryTax[2] / 2);
local salesTax      = math.Round(SublimeGov.Config.SalesTax[2] / 2);

local propertyDefault   = propertyTax
local salaryDefault     = salaryTax;
local salesDefault      = salesTax;

local round  = math.Round;
local to     = tonumber;

local taxMoney = 0;

local extraSalariesEnabled = SublimeGov.Config.MayorCanAdjustSalaries;

local path = SublimeUI.GetCurrentPath();

local panel = {};

function panel:Init()
    self.L = SublimeGov.L;

    self.Sliders    = {};
    self.Approach   = math.Approach;

    self.ArcSize    = 150;
    self.ArcColor   = ColorAlpha(SublimeUI.White, 50);
end

function panel:CreateSlider(tax, id, minmax, current)
    local nextSlider = #self.Sliders + 1;

    self.Sliders[nextSlider] = self:Add("DSlider");
    local slider = self.Sliders[nextSlider];
    slider.Paint = function(s, w, h)
        local num = w / 7;
	    local space = w / num

        surface.SetDrawColor(255, 255, 255, 100)
        for i = 0, num do
            surface.DrawRect(i * space, h - 5, 1, 5);
        end

        surface.SetDrawColor(255, 255, 255, 100);
        surface.DrawRect(0, h / 2 - 1, w, 1);

        SublimeUI.DrawTextOutlined(minmax[1], "SublimeUI.16", 0, -4, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(minmax[2], "SublimeUI.16", w, -4, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_RIGHT);
    end

    local fracToVal = function(val)
        return round(minmax[1] + (val * (minmax[2] - minmax[1])));
    end

    slider.OnValueChanged = function(s, frac)
        if (id == "property") then
            propertyTax = fracToVal(frac);
        elseif(id == "sales") then
            salesTax = fracToVal(frac);
        else
            salaryTax = fracToVal(frac);
        end
    end

    slider.TranslateValues = function(slider, x, y)
        slider:OnValueChanged(x);
        return x, y;
    end

    local old = slider.Knob.OnMouseReleased;
    slider.Knob.OnMouseReleased = function(s)
        net.Start("SublimeGov.TaxAdjusted");
            net.WriteUInt(propertyTax, 32);
            net.WriteUInt(salesTax, 32);
            net.WriteUInt(salaryTax, 32);
        net.SendToServer();

        old(s);
    end

    slider:SetSlideX(current / minmax[2]);
end

function panel:PostInit()
    self:CreateSlider(propertyTax, "property", SublimeGov.Config.PropertyTax, propertyTax);
    self:CreateSlider(salesTax, "sales", SublimeGov.Config.SalesTax, salesTax);
    self:CreateSlider(salaryTax, "salary", SublimeGov.Config.SalaryTax, salaryTax);
    
    local text = extraSalariesEnabled and self.L("ui_mayor_taxes_change_dis") or self.L("ui_mayor_taxes_change_ena");
    local desc = extraSalariesEnabled and self.L("ui_mayor_taxes_change_dis_desc") or self.L("ui_mayor_taxes_change_ena_desc");

    self.ChangeTax = self:Add("Sublime.Button");
    self.ChangeTax:SetText(text);
    self.ChangeTax:SetTextPos(TEXT_ALIGN_CENTER);
    self.ChangeTax.DoClick = function()
        net.Start("SublimeGov.TaxChange");
            net.WriteBool(not extraSalariesEnabled);
        net.SendToServer();

        SublimeGov.CreateNotification(self.L("ui_mayor_taxes_save_success"), desc, false);
        extraSalariesEnabled = not extraSalariesEnabled;

        text = extraSalariesEnabled and self.L("ui_mayor_taxes_change_dis") or self.L("ui_mayor_taxes_change_ena");
        desc = extraSalariesEnabled and self.L("ui_mayor_taxes_change_dis_desc") or self.L("ui_mayor_taxes_change_ena_desc");

        self.ChangeTax:SetText(text);
    end

    self.Default = self:Add("Sublime.Button");
    self.Default:SetText(self.L("ui_mayor_taxes_default"));
    self.Default:SetTextPos(TEXT_ALIGN_CENTER);
    self.Default.DoClick = function()
        net.Start("SublimeGov.TaxAdjusted");
            net.WriteUInt(propertyDefault, 32);
            net.WriteUInt(salesDefault, 32);
            net.WriteUInt(salaryDefault, 32);
        net.SendToServer();

        propertyTax   = propertyDefault;
        salaryTax     = salaryDefault;
        salesTax      = salesDefault;

        SublimeGov.CreateNotification(self.L("ui_mayor_taxes_save_success"), self.L("ui_mayor_taxes_default_success_desc"), false);
    end

    self.Disable = self:Add("Sublime.Button");
    self.Disable:SetText(self.L("ui_mayor_taxes_disable"));
    self.Disable:SetTextPos(TEXT_ALIGN_CENTER);
    self.Disable.DoClick = function()
        net.Start("SublimeGov.MayorChangedTaxes");
            net.WriteBool(false);
        net.SendToServer();

        SublimeGov.CreateNotification(self.L("ui_mayor_taxes_save_success"), self.L("ui_mayor_taxes_disable_success_desc"), false);

        self:Remove();
    end
end

function panel:Think()
    if (GAMEMODE.Config.propertytax and not self.HasCalledPostInit) then
        self:PostInit();

        self.HasCalledPostInit = true;
    end
end

function panel:PerformLayout(w, h)

    local padding = 63;
    local size = (w / 3) - padding;

    for i = 1, #self.Sliders do
        local slider = self.Sliders[i];
        
        slider:SetPos((padding * i) + ((i - 1) * size), size + padding * 2);
        slider:SetSize(size - padding, 30)
    end

    if (IsValid(self.ChangeTax)) then
        self.ChangeTax:SetPos(7, h - 107);
        self.ChangeTax:SetSize(w - 14, 30);
    end

    if (IsValid(self.Default)) then
        self.Default:SetPos(7, h - 72);
        self.Default:SetSize(w - 14, 30);
    end

    if (IsValid(self.Disable)) then
        self.Disable:SetPos(7, h - 37);
        self.Disable:SetSize(w - 14, 30);
    end
end

function panel:DrawBackground(w, h)
    draw.NoTexture();

    local padding = 63;
    local size = (w / 3) - padding;

    -- Property
    SublimeUI.Arc((w / 3) * 0.5, padding + size * 0.5, size / 2, 5, 0, 362, 360, self.ArcColor);
    SublimeUI.Arc((w / 3) * 0.5, padding + size * 0.5, (size / 2), 5, 0, round((propertyTax / SublimeGov.Config.PropertyTax[2]) * 362), 0, Color((1 - propertyTax / SublimeGov.Config.PropertyTax[2]) * 255, propertyTax / SublimeGov.Config.PropertyTax[2] * 255, 0));
    SublimeUI.DrawTextOutlined(self.L("ui_mayor_taxes_property", propertyTax), "SublimeUI.26", (w / 3) * 0.5, size / 2 + padding, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER, true);

    -- Sales
    SublimeUI.Arc((w / 3) * 1.5, padding + size * 0.5, size / 2, 5, 0, 362, 0, self.ArcColor);
    SublimeUI.Arc((w / 3) * 1.5, padding + size * 0.5, (size / 2), 5, 0, round((salesTax / SublimeGov.Config.SalesTax[2]) * 362), 0, Color((1 - salesTax / SublimeGov.Config.SalesTax[2]) * 255, salesTax / SublimeGov.Config.SalesTax[2] * 255, 0));
    SublimeUI.DrawTextOutlined(self.L("ui_mayor_taxes_sales", salesTax), "SublimeUI.26", (w / 3) * 1.5, size / 2 + padding, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER, true);

    -- Salary
    SublimeUI.Arc((w / 3) * 2.5, padding + size * 0.5, size / 2, 5, 0, 362, 0, self.ArcColor);
    SublimeUI.Arc((w / 3) * 2.5, padding + size * 0.5, (size / 2), 5, 0, round((salaryTax / SublimeGov.Config.SalaryTax[2]) * 362), 0, Color((1 - salaryTax / SublimeGov.Config.SalaryTax[2]) * 255, salaryTax / SublimeGov.Config.SalaryTax[2] * 255, 0));
    SublimeUI.DrawTextOutlined(self.L("ui_mayor_taxes_salary", salaryTax), "SublimeUI.26", (w / 3) * 2.5, size / 2 + padding, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER, true);

    SublimeUI.DrawTextOutlined(self.L("ui_mayor_tax_fund", DarkRP.formatMoney(taxMoney)), "SublimeUI.16", w - 7, 8, SublimeUI.Green, SublimeUI.Black, TEXT_ALIGN_RIGHT);
end

function panel:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);
    surface.DrawRect(2, 31, w - 4, 1);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 30, w - 4, 1);

    SublimeUI.DrawTextOutlined(self.L("ui_mayor_taxes"), "SublimeUI.16", 7, 8, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

    if (not GAMEMODE.Config.propertytax) then
        if (not SublimeGov.Config.MayorCanDecide) then
            SublimeUI.DrawTextOutlined(self.L("ui_mayor_taxes_disabled"), "SublimeUI.18", w / 2, h / 2, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
        end
    else
        self:DrawBackground(w, h);
    end
end

function panel:OnRemove()
    net.Start("SublimeGov.CheckForTaxChange")
    net.SendToServer();
end

vgui.Register("SublimeGov.Connected.Apps.Mayor.Taxes", panel, "EditablePanel");

hook.Add("SublimeGov.TaxUpdated", path, function(amount)
    taxMoney = amount;
end);

net.Receive("SublimeGov.TaxChangeUpdate", function()
    extraSalariesEnabled = net.ReadBool();

    if (extraSalariesEnabled) then
        SublimeGov.Config.MayorCanAdjustSalaries = true;
        SublimeGov.Config.MayorGetsMoney = false;
    else
        SublimeGov.Config.MayorCanAdjustSalaries = false;
        SublimeGov.Config.MayorGetsMoney = true;
    end
end);

net.Receive("SublimeGov.UpdateTaxesStatus", function()
    local salary = net.ReadBool();
    local mayorGetsMoney = net.ReadBool();

    SublimeGov.Config.MayorCanAdjustSalaries = salary;
    SublimeGov.Config.MayorGetsMoney = mayorGetsMoney;
end);