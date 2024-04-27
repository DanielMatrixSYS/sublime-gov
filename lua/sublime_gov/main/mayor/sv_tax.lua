--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.MayorChangedTaxes");
util.AddNetworkString("SublimeGov.TaxesChanged");
util.AddNetworkString("SublimeGov.TaxAdjusted");
util.AddNetworkString("SublimeGov.TaxDefault");
util.AddNetworkString("SublimeGov.TaxChangeUpdate");
util.AddNetworkString("SublimeGov.TaxChange");
util.AddNetworkString("SublimeGov.CheckForTaxChange");

local path = SublimeUI.GetCurrentPath();

local propertyTax   = math.Round(SublimeGov.Config.PropertyTax[2] / 2);
local salaryTax     = math.Round(SublimeGov.Config.SalaryTax[2] / 2);
local salesTax      = math.Round(SublimeGov.Config.SalesTax[2] / 2);
local hasChanged    = false;

SublimeGov.TaxMoney = SublimeGov.TaxMoney or 0;

local function changeTaxing(bool, ply)
    GAMEMODE.Config.propertytax = bool;

    if (not IsValid(ply)) then
        net.Start("SublimeGov.TaxesChanged");
            net.WriteBool(bool);
        net.Broadcast();
    else
        net.Start("SublimeGov.TaxesChanged");
            net.WriteBool(bool);
        net.Send(ply);
    end

    if (not bool) then
        DarkRP.notify(player.GetAll(), 1, 4, "The mayor has disabled taxes.");
    else
        DarkRP.notify(player.GetAll(), 2, 4, "The mayor has enabled taxes.");
    end
end

local function addTaxMoney(amount)
    SublimeGov.TaxMoney = SublimeGov.TaxMoney + amount;

    hook.Run("SublimeGov.TaxMoneyChanged", SublimeGov.TaxMoney - amount, SublimeGov.TaxMoney);
end

local function resetTaxMoney()
    local old = SublimeGov.TaxMoney;
    SublimeGov.TaxMoney = 0;

    hook.Run("SublimeGov.TaxMoneyChanged", old, SublimeGov.TaxMoney);
end

net.Receive("SublimeGov.MayorChangedTaxes", function(_, ply)
    if (not IsValid(ply) or not ply:isMayor() or not ply:sGov_IsConnected()) then
        return;
    end

    if (not SublimeGov.Config.MayorCanDecide) then
        return;
    end

    local change = net.ReadBool();

    changeTaxing(change);
end);

net.Receive("SublimeGov.TaxAdjusted", function(_, ply)
    if (not IsValid(ply) or not ply:isMayor() or not ply:sGov_IsConnected()) then
        return;
    end

    if (not GAMEMODE.Config.propertytax) then
        return;
    end

    local property  = net.ReadUInt(32);
    local sales     = net.ReadUInt(32);
    local wallet    = net.ReadUInt(32);

    local prop_min, prop_max     = SublimeGov.Config.PropertyTax[1], SublimeGov.Config.PropertyTax[2];
    local sales_min, sales_max   = SublimeGov.Config.SalesTax[1], SublimeGov.Config.SalesTax[2];
    local wallet_min, wallet_max = SublimeGov.Config.SalaryTax[1], SublimeGov.Config.SalaryTax[2];

    if (SublimeGov.Config.PropertyTaxEnabled) then
        if (property < prop_min or property > prop_max) then
            return;
        end

        propertyTax = property;
    end

    if (SublimeGov.Config.SalesTaxEnabled) then
        if (sales < sales_min or sales > sales_max) then
            return;
        end

        salesTax = sales;
    end

    if (SublimeGov.Config.SalaryTaxEnabled) then
        if (wallet < wallet_min or wallet > wallet_max) then
            return;
        end

        salaryTax = wallet;
    end
    
    hasChanged = true
end);

net.Receive("SublimeGov.TaxChange", function(_, ply)
    if (not IsValid(ply) or not ply:isMayor() or not ply:sGov_IsConnected()) then
        return;
    end

    local bool = net.ReadBool();

    if (bool) then
        SublimeGov.Config.MayorCanAdjustSalaries = true;
        SublimeGov.Config.MayorGetsMoney = false;
    
        local players = player.GetAll();

        for i = 1, #players do
            local player = players[i];

            if (SublimeGov.IsJobCP(player)) then
                DarkRP.notify(player, 2, 8, "The mayor has enabled extra paychecks.");
            end

            if (player:isMayor()) then
                net.Start("SublimeGov.TaxChangeUpdate");
                    net.WriteBool(bool);
                net.Send(player);
            end
        end
    else
        SublimeGov.Config.MayorCanAdjustSalaries = false;
        SublimeGov.Config.MayorGetsMoney = true;

        local players = player.GetAll();

        for i = 1, #players do
            local player = players[i];

            if (SublimeGov.IsJobCP(player)) then
                DarkRP.notify(player, 1, 8, "The mayor has disabled extra paychecks.");
            end

            if (player:isMayor()) then
                net.Start("SublimeGov.TaxChangeUpdate");
                    net.WriteBool(bool);
                net.Send(player);
            end
        end
    end
end);

hook.Add("canPropertyTax", path, function(ply, tax)
    if (not GAMEMODE.Config.propertytax or not SublimeGov.Config.PropertyTaxEnabled) then
        return;
    end

    local totalCost = 0

    -- yoinked mate
    for entIndex, ent in pairs(ply.Ownedz or {}) do
        if not IsValid(ent) or not ent:isKeysOwnable() then ply.Ownedz[entIndex] = nil continue end
        local isAllowed = hook.Call("canTaxEntity", nil, ply, ent)
        if isAllowed == false then continue end

        totalCost = totalCost + hook.Run("getDoorCost", ply, ent);
    end

    -- co-owned doors
    for _, v in ipairs(player.GetAll()) do
        if v == ply then continue end

        for _, ent in pairs(v.Ownedz or {}) do
            if not IsValid(ent) or not ent:isKeysOwnedBy(ply) then continue end

            local isAllowed = hook.Call("canTaxEntity", nil, ply, ent)
            if isAllowed == false then continue end

            totalCost = totalCost + hook.Run("getDoorCost", ply, ent);
        end
    end

    local shouldTax = totalCost * (propertyTax / 100);

    if (not ply:canAfford(shouldTax)) then
        return;
    end

    addTaxMoney(shouldTax);

    return true, shouldTax;
end);

hook.Add("OnPlayerChangedTeam", path, function(ply, before, after)
    if (not IsValid(ply)) then
        return;
    end

    for i = 1, #RPExtraTeams do
        local data = RPExtraTeams[i];

        if (data.mayor and i == before and GAMEMODE.Config.propertytax) then
            changeTaxing(false);

            return;
        end
    end
end);

hook.Add("PlayerInitialSpawn", path, function(ply)
    timer.Simple(2, function()
        if (IsValid(ply) and GAMEMODE.Config.propertytax) then
            changeTaxing(GAMEMODE.Config.propertytax, ply);
        end
    end);
end);

hook.Add("PlayerDisconnected", path, function(ply)
    if (ply:isMayor() and GAMEMODE.Config.propertytax) then
        changeTaxing(false);
    end
end);

hook.Add("playerGetSalary", path, function(ply, salary)
    if (not GAMEMODE.Config.propertytax or salaryTax <= 0 or not SublimeGov.Config.SalaryTaxEnabled) then
        return;
    end

    local shouldTax = salary * (salaryTax / 100);
    local rest      = salary - shouldTax;

    addTaxMoney(shouldTax);

    if (not rest) then
        rest = salary;
    end

    DarkRP.notify(ply, 4, 4, DarkRP.getPhrase("payday_message", DarkRP.formatMoney(rest)) .. " Tax included");

    return true, "", rest;
end);

local cooldown = CurTime() + SublimeGov.Config.MayorTaxCooldown;

hook.Add("Tick", path, function()
    if (cooldown > CurTime() or not SublimeGov.Config.MayorGetsMoney) then
        return;
    end

    if (SublimeGov.Config.MayorGetsMoney) then
        local players = player.GetAll();

        for i = 1, #players do
            local player = players[i];

            if (IsValid(player) and player:isMayor()) then
                player:addMoney(SublimeGov.TaxMoney);
                DarkRP.notify(player, 2, 10, "You received an extra " .. DarkRP.formatMoney(SublimeGov.TaxMoney) .. " from the taxes you've collected.");
            
                resetTaxMoney();

                break;
            end
        end
    end

    cooldown = CurTime() + SublimeGov.Config.MayorTaxCooldown;
end);

local hooks = {
    "Ammo",
    "CustomEntity",
    "Pistol",
    "Shipment",
}

for i = 1, #hooks do
    hook.Add("playerBought" .. hooks[i], path, function(ply, data, ent, cost)
        if (not IsValid(ply) or salesTax < 0 or not SublimeGov.Config.SalesTaxEnabled or not GAMEMODE.Config.propertytax) then
            return;
        end

        local shouldTax = cost * (salesTax / 100);

        if (ply:canAfford(cost + shouldTax)) then
            ply:addMoney(-shouldTax);
            addTaxMoney(shouldTax);

            DarkRP.notify(ply, 2, 4, "You were taxed an extra " .. DarkRP.formatMoney(shouldTax) .. " for your purchase");
        end
    end);
end

net.Receive("SublimeGov.CheckForTaxChange", function()
    if (hasChanged) then
        SublimeGov.GlobalNotify("The taxes have been adjusted! Property tax: " .. propertyTax .. "% Sales tax: " .. salesTax .. "% Salary tax: " .. salaryTax .. "%");
        hasChanged = false;
    end
end);