--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.RequestTaxFund");
util.AddNetworkString("SublimeGov.UpdateTaxFund");
util.AddNetworkString("SublimeGov.SalaryChanged");
util.AddNetworkString("SublimeGov.UpdateSalary");
util.AddNetworkString("SublimeGov.UpdateTaxesStatus");

local path = SublimeUI.GetCurrentPath();

function SublimeGov.ResetSalaries()
    local jobs = RPExtraTeams;
    
    for i = 1, #jobs do
        local data = jobs[i];

        if (data.team and data.extraSalary) then
            data.extraSalary = 0;
        end
    end

    return true;
end

net.Receive("SublimeGov.RequestTaxFund", function(_, ply)
    if (not IsValid(ply) or not ply:isMayor() or not ply:sGov_IsConnected()) then
        return;
    end

    net.Start("SublimeGov.UpdateTaxFund");
        net.WriteUInt(SublimeGov.TaxMoney, 32);
    net.Send(ply);
end);

net.Receive("SublimeGov.SalaryChanged", function(_, ply)
    if (not IsValid(ply) or not ply:isMayor() or not ply:sGov_IsConnected()) then
        return;
    end

    if (not GAMEMODE.Config.propertytax or SublimeGov.Config.MayorGetsMoney or not SublimeGov.Config.MayorCanAdjustSalaries) then
        return;
    end

    local job       = net.ReadUInt(32);
    local extra     = net.ReadUInt(32);
    local min, max  = SublimeGov.Config.Salaries[1], SublimeGov.Config.Salaries[2];

    if (extra < min or extra > max) then
        return;
    end

    local jobTable = RPExtraTeams[job]

    if (not jobTable or not SublimeGov.IsJobCP(job)) then
        return;
    end

    jobTable.extraSalary = extra;

    hook.Run("SublimeGov.SalaryAdjusted", job, extra);
end);

hook.Add("SublimeGov.TaxMoneyChanged", path, function(before, after)
    if (not GAMEMODE.Config.propertytax) then
        return;
    end

    local players = player.GetAll()

    for i = 1, #players do
        local player = players[i];

        if (IsValid(player) and player:isMayor()) then
            net.Start("SublimeGov.UpdateTaxFund");
                net.WriteUInt(after, 32);
            net.Send(player);
        end
    end
end);

hook.Add("PlayerDisconnected", path, function(ply)
    if (ply:isMayor() and GAMEMODE.Config.propertytax and SublimeGov.Config.MayorCanAdjustSalaries) then
        SublimeGov.ResetSalaries();
    end
end);

hook.Add("playerGetSalary", path, function(ply)
    if (not SublimeGov.IsJobCP(ply) or not GAMEMODE.Config.propertytax or not SublimeGov.Config.MayorCanAdjustSalaries) then
        return;
    end

    local job   = RPExtraTeams[ply:Team()];
    local extra = job.extraSalary;

    if (extra and extra > 0) then
        local taxFundAfter = SublimeGov.TaxMoney - extra;

        if (taxFundAfter <= 0 or SublimeGov.TaxMoney < extra) then
            return;
        end

        ply:addMoney(extra);
        SublimeGov.TaxMoney = SublimeGov.TaxMoney - extra;
        DarkRP.notify(ply, 2, 8, "You've received an extra paycheck of " .. DarkRP.formatMoney(extra) .. " because the mayor has increased your salary.");
        
        hook.Run("SublimeGov.TaxMoneyChanged", SublimeGov.TaxMoney - extra, SublimeGov.TaxMoney);
    end
end);

hook.Add("OnPlayerChangedTeam", path, function(ply, before, after)
    if (not IsValid(ply)) then
        return;
    end

    for i = 1, #RPExtraTeams do
        local data = RPExtraTeams[i];

        if (not data) then
            continue;
        end

        if (data.mayor and i == after) then
            net.Start("SublimeGov.UpdateTaxesStatus");
                net.WriteBool(SublimeGov.Config.MayorCanAdjustSalaries);
                net.WriteBool(SublimeGov.Config.MayorGetsMoney);
            net.Send(ply);
        end

        if (data.mayor and i == before and GAMEMODE.Config.propertytax and SublimeGov.Config.MayorCanAdjustSalaries) then
            SublimeGov.ResetSalaries();

            return;
        end
    end
end);

hook.Add("SublimeGov.SalaryAdjusted", path, function(job, extra)
    local players = player.GetAll();

    for i = 1, #players do
        local player = players[i];

        if (IsValid(player) and player:isMayor()) then
            net.Start("SublimeGov.UpdateSalary");
                net.WriteUInt(job, 32);
                net.WriteUInt(extra, 32);
            net.Send(player);
        end
    end
end);