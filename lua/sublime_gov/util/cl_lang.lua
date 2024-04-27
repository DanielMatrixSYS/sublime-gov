--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local lformat   = string.format;
local gmatch    = string.gmatch;
local replace   = string.Replace;
local lang      = GetConVar("gmod_language"):GetString();

--
-- Language.
--
function SublimeGov.L(key, ...)
    local curLang = SublimeGov.Languages[lang] or SublimeGov.Languages["en"];

    for m in gmatch(key, "%{%a+%}") do
        key = replace(key, m, SublimeGov.L(m:sub(2, m:len() - 1)));
    end

    if (curLang[key]) then 
        return lformat(curLang[key], ...);
    else 
        return lformat(key, ...);
    end
end