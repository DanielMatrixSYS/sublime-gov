--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

SublimeUI.Materials = SublimeUI.Materials or {};

local mat       = Material;
local folder    = "sublimeui/";
local materials = {
    {
        name = "Background",
        material = mat(folder .. "main_background.png")
    },

    {
        name = "Exit",
        material = mat(folder .. "x.png", "noclamp smooth")
    },

    {
        name = "Monument",
        material = mat(folder .. "monument.png", "noclamp smooth")
    },

    {
        name = "Check Mark",
        material = mat(folder .. "check_mark.png", "noclamp smooth")
    },

    {
        name = "Cross",
        material = mat(folder .. "cross.png", "noclamp smooth")
    },

    {
        name = "Bullet",
        material = mat(folder .. "bullet.png", "noclamp smooth")
    },

    {
        name = "Developer",
        material = mat(folder .. "coding.png", "noclamp smooth")
    },

    {
        name = "Home",
        material = mat(folder .. "home.png", "noclamp smooth")
    },

    {
        name = "Arrested",
        material = mat(folder .. "jail.png", "noclamp smooth")
    },

    {
        name = "Database",
        material = mat(folder .. "key.png", "noclamp smooth")
    },

    {
        name = "Wanted",
        material = mat(folder .. "poster.png", "noclamp smooth")
    },

    {
        name = "Leaderboards",
        material = mat(folder .. "rank.png", "noclamp smooth")
    },

    {
        name = "Statistics",
        material = mat(folder .. "search.png", "noclamp smooth")
    },

    {
        name = "Settings",
        material = mat(folder .. "wrench.png", "noclamp smooth")
    },

    {
        name = "Other",
        material = mat(folder .. "recycling.png", "noclamp smooth")
    },

    {
        name = "General",
        material = mat(folder .. "book.png", "noclamp smooth")
    },

    {
        name = "Combat",
        material = mat(folder .. "knife.png", "noclamp smooth")
    },

    {
        name = "Lottery",
        material = mat(folder .. "bingo.png", "noclamp smooth")
    },

    {
        name = "Document",
        material = mat(folder .. "document.png", "noclamp smooth")
    },

    {
        name = "Employees",
        material = mat(folder .. "employee.png", "noclamp smooth")
    },

    {
        name = "Credits",
        material = mat(folder .. "helper.png", "noclamp smooth")
    },

    {
        name = "Right Arrow",
        material = mat(folder .. "next.png", "noclamp smooth")
    },

    {
        name = "Tax",
        material = mat(folder .. "percent.png", "noclamp smooth")
    },

    {
        name = "Circle",
        material = mat(folder .. "circle.png", "noclamp smooth")
    },

    {
        name = "Dollar",
        material = mat(folder .. "dollar.png", "noclamp smooth")
    }
}

for _, v in ipairs(materials) do
    SublimeUI.Materials[v.name] = v.material;
end