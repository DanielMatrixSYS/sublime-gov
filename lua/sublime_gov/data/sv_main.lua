--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path      = SublimeUI.GetCurrentPath();
local SQL       = {};
local queries   = {};

function SQL:CreateTables()
    if (not sql.TableExists("SublimeGov_PoliceData")) then
        sql.Query([[CREATE TABLE SublimeGov_PoliceData (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            SteamID VARCHAR(17),
            kills INTEGER,
            teamkills INTEGER,
            deaths INTEGER,
            wanted_count INTEGER,
            warranted_count INTEGER,
            confiscated_count INTEGER,
            arrested_count INTEGER,
            released_count INTEGER,
            ram_count INTEGER,
            salary_total INTEGER,
            seconds_on_duty INTEGER,
            damage_dealt INTEGER,
            Data TEXT,
            Unique(SteamID)
        );]]);
    end

    if (not sql.TableExists("SublimeGov_CriminalData")) then
        sql.Query([[CREATE TABLE SublimeGov_CriminalData (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            SteamID VARCHAR(17),
            wanted_count INTEGER,
            warranted_count INTEGER,
            confiscated_count INTEGER,
            arrested_count INTEGER,
            notes TEXT,
            Data TEXT,
            Unique(SteamID)
        );]]);
    end

    if (not sql.TableExists("SublimeGov_Computers")) then
        sql.Query([[CREATE TABLE SublimeGov_Computers (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            position VARCHAR(255),
            angle VARCHAR(255),
            map VARCHAR(255),
            Unique(ID)
        );]]);
    end
end

function SQL:FormatSQL(formatString, ...)
	local repacked 	= {};
	local args		= {...};
	
	for _, arg in ipairs(args) do 
		table.insert(repacked, sql.SQLStr(arg, true));
	end

	return string.format(formatString, unpack(repacked));
end

hook.Add("Initialize", path, function()
    SQL:CreateTables();
end);

hook.Add("PlayerInitialSpawn", path, function(ply)
    if (not IsValid(ply) or ply:IsBot()) then
        return;
    end

    sql.Query(SQL:FormatSQL([[INSERT OR IGNORE INTO SublimeGov_PoliceData 
    (SteamID, kills, teamkills, deaths, wanted_count, warranted_count, confiscated_count, arrested_count, released_count, ram_count, salary_total, seconds_on_duty, damage_dealt, Data)
    VALUES('%s', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '[]')]], ply:SteamID64()));

    sql.Query(SQL:FormatSQL([[INSERT OR IGNORE INTO SublimeGov_CriminalData 
    (SteamID, wanted_count, warranted_count, confiscated_count, arrested_count, notes, Data)
    VALUES('%s', '0', '0', '0', '0', '[]', '[]')]], ply:SteamID64()));
end);

hook.Add("Tick", path, function()
    for i = 1, #queries do
        local query_data = queries[i];
        local time       = query_data.time; 

        if (time < CurTime()) then
            local steamid = query_data.steamid;
            local data    = query_data.data;
            local id      = query_data.id;
            local value   = query_data.value;

            if (data == "police_records") then
                sql.Query(SQL:FormatSQL("UPDATE SublimeGov_PoliceData SET %s = %s + '%i' WHERE SteamID = '%s'", id, id, value, steamid));
            else
                sql.Query(SQL:FormatSQL("UPDATE SublimeGov_CriminalData SET %s = %s + '%i' WHERE SteamID = '%s'", id, id, value, steamid));
            end

            table.remove(queries, i);

            return;
        end
    end
end);

function SublimeGov.GetSQL()
    return SQL;
end

local function query(steamid, data, id, value)
    table.insert(queries, {steamid = steamid, data = data, id = id, value = value, time = CurTime() + 0.1});
end

function SublimeGov.Player:sGovData_AddInt(...)
    if (self:IsBot()) then
        return false;
    end

    local args  = {...};
    local data  = args[1];
    local id    = args[2];
    local value = args[3];
    
    if (value <= 0) then
        return false;
    end

    query(self:SteamID64(), data, id, value);
end