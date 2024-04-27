--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

SublimeGov.SpawnedComputers = SublimeGov.SpawnedComputers or {};

function SublimeGov.SpawnComputers()
    local computers = sql.Query("SELECT position, angle, map, ID FROM SublimeGov_Computers");

    if (not computers) then
        return;
    end

    for i = 1, #computers do
        local data  = computers[i];
        local pos   = data.position;
        local ang   = data.angle;
        local map   = data.map;
        local id    = data.ID;

        if (map == game.GetMap()) then
            local computer = ents.Create("sgov_computer");
            computer:SetPos(Vector(pos));
            computer:SetAngles(Angle(ang));
            computer:SetComputerID(id);
            computer:Spawn();

            local phys = computer:GetPhysicsObject();
            if (IsValid(phys)) then
                phys:EnableMotion(false);
            end

            table.insert(SublimeGov.SpawnedComputers, computer);
        end
    end
end

function SublimeGov.ReloadComputers()
    for i = 1, #SublimeGov.SpawnedComputers do
        local computer = SublimeGov.SpawnedComputers[i];

        if (IsValid(computer)) then
            computer.IsBeingReloaded = true;
            computer:Remove();
        end
    end

    table.Empty(SublimeGov.SpawnedComputers);
    SublimeGov.SpawnComputers();
end

function SublimeGov.SaveComputer(ply, computer)
    if (not IsValid(computer)) then
        return false;
    end

    local SQL   = SublimeGov.GetSQL();
    local id    = computer:GetComputerID();

    local saved_computer = sql.Query("SELECT * FROM SublimeGov_Computers WHERE ID = '" .. id .. "'");
    if (saved_computer == nil) then
        sql.Query(SQL:FormatSQL("INSERT INTO SublimeGov_Computers (position, angle, map, ID) VALUES('%s', '%s', '%s', '%s')", computer:GetPos(), computer:GetAngles(), game.GetMap(), id));

        DarkRP.notify(ply, 2, 8, "You have saved this computer to the database.");
    else
        sql.Query(SQL:FormatSQL("UPDATE SublimeGov_Computers SET position = '%s', angle = '%s' WHERE ID = '%s'", computer:GetPos(), computer:GetAngles(), id));

        DarkRP.notify(ply, 2, 8, "You have updated the positions of this computer with new ones.");
    end
end

function SublimeGov.RemoveComputer(ply, computer)
    if (not IsValid(computer)) then
        return false;
    end

    for i = 1, #SublimeGov.SpawnedComputers do
        local spawned_computer = SublimeGov.SpawnedComputers[i];

        if (IsValid(spawned_computer) and spawned_computer == computer) then
            table.remove(SublimeGov.SpawnedComputers, i);

            break;
        end
    end

    local id = computer:GetComputerID();
    sql.Query("DELETE FROM SublimeGov_Computers WHERE ID = '" .. id .. "'");

    computer:Remove();

    DarkRP.notify(ply, 1, 8, "You have deleted this computer from the database.");
end

hook.Add("InitPostEntity", path, function()
    SublimeGov.SpawnComputers();
end);