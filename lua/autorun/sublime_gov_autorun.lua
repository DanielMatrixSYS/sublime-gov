--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

SublimeGov = SublimeGov or {};

SublimeGov.Languages = SublimeGov.Languages or {};

SublimeGov.Player = FindMetaTable("Player");

function SublimeGov:LoadFile(path)
    local filename = path:GetFileFromFilename();
    filename = filename ~= "" and filename or path;

    local flagCL    = filename:StartWith("cl_");
    local flagSV    = filename:StartWith("sv_");
    local flagSH    = filename:StartWith("sh_");

    if (SERVER) then
        if (flagCL or flagSH) then
            AddCSLuaFile(path);
        end

        if (flagSV or flagSH) then 
            include(path);
        end
    elseif (flagCL or flagSH) then
        include(path);
    end
end

function SublimeGov:LoadDirectory(dir)
    local files, folders = file.Find(dir .. "/*", "LUA");

    for _, v in ipairs(files) do 
        self:LoadFile(dir .. "/" .. v);
    end

    for _, v in ipairs(folders) do 
        self:LoadDirectory(dir .. "/" .. v);
    end
end

SublimeGov:LoadDirectory("sublime_gov");