--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

SublimeUI.Fonts = {};

local prefix = "SublimeUI.";

local function fontExists(font)
    for k, v in ipairs(SublimeUI.Fonts) do
        if (v.font == font) then
            return true;
        end
    end

    return false;
end

local function removeFont(font)
    for k, v in ipairs(SublimeUI.Fonts) do
        if (v.font == font) then
            table.remove(SublimeUI.Fonts, k)

            return true;
        end
    end

    return false;
end

local function createFont(name, size, weight)
    table.insert(SublimeUI.Fonts, {font = name, size = size});
    surface.CreateFont(name, {font = "Roboto", size = size, weight = (weight or 300)});
end

local function addFont(name, size, weight)
    createFont(name, size, weight);

    return true;
end

for i = 12, 52, 2 do
    addFont(prefix .. i, i);
end