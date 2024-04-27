--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

SublimeGov.Config = SublimeGov.Config or {};

-- General stuff for Sublime Government
-- What usergroups can edit columns, player data and in general just database things?
-- Be careful of what usergroups you add here as they'll have access to the entire system.
SublimeGov.Config.Administrators = {
    ["superadmin"] = true,
}

-- This is used for the "Arrests & Releasd Records" application.
-- If you are experiencing errors after you have edited literally anything in here then please un-do what you did.
-- The values below hold no real value and is ONLY used to add more realism in the database.
-- The values are stored on the player on their initial spawn which means that if they reconnect,
-- they might have different values.
    --
    -- This is the minmum and max heigh the player can "have".
    -- These numbers are in centimeters, and can not be changed to feet.
    -- These numbers are also randomly selected, if you want one specific to be chosen then do this instead:
    -- SublimeGov.Config.MinMaxHeight = {180, 180}; or SublimeGov.Config.MinMaxHeight = {165, 165};
    SublimeGov.Config.MinMaxHeight = {150, 200};

    -- this is just to have more realistic information about the "person" in the police database.
    -- This is randomly selected, if you only want one specific to be chosen then just change it to:
    -- SublimeGov.Config.AgeTypes = {"Adult"}; or SublimeGov.Config.AgeTypes = {"Middle aged"};
    SublimeGov.Config.AgeTypes = {"Young", "Young Adult", "Adult", "Middle aged", "Old", "Elderly"};

    -- these are also randomly selected, if you want one specific to be chosen then just change it to:
    -- SublimeGov.Config.Race = {"Black"}; or SublimeGov.Config.Race = {"Hispanic"};
    SublimeGov.Config.Race = {"American Indian", "Asian", "Black", "Hispanic", "Other Pacific Islander", "White"};
    
    -- These numbers and strings have actual values.
    --
    -- Let me explain how it works:
    -- If the money in the players wallet is less or equal to the number below then their
    -- wealth status becomes whatever is set here.
    --
    -- So for example, let's say you have $100,000,
    -- Then you will be put in the "Poor" category,
    -- But if you have $400,000 then you will also still be put in the "Poor" category.
    -- If you have more than $500,000 then you'll be put into the "Average" category.
    --
    -- If you want to add your own value then just copy and paste then change the values.
    -- 
    -- Example:
    --
    -- SublimeGov.Config.Wealth = {
        --{1000000, "Rich"},
        --{500000, "Average"},
        --{100000, "Poor"},
    -- };
    -- Becomes:
    -- SublimeGov.Config.Wealth = {
        --{2000000, "Super Rich"},
        --{1000000, "Rich"},
        --{500000, "Average"},
        --{100000, "Poor"},
        --{50000, "Homeless"},
    -- };
    -- 
    SublimeGov.Config.Wealth = {
        {1000000,   "Rich"},
        {500000,    "Average"},
        {100000,    "Poor"},
    };

    SublimeGov.Config.Health = {
        {100,   "Healthy"},
        {50,    "Average"},
        {25,    "Dying"},
    };
--

-- This variable decides whether or not the mayor can decide if the taxes should be enabled or not.
-- If you, as a server owner wants to decide instead then set this to false, like so:
-- SublimeGov.Config.MayorCanDecide = false;
SublimeGov.Config.MayorCanDecide = true;

-- Both the property tax and sales tax can be modified by the mayor and hold a value between 0, 100. The numbers are in percentage.
-- So if the property tax is set to 100% and a door costs 40 to buy then the cost would be 80 instead.
-- However, if the property tax is set to 50% then the door would cost 60.
-- The numbers are displayed like so the minimum number is the first value, aka the one on the left,
-- and the max is the one on the right. The default values for both of the tables are:
-- Minumum: 0.
-- Maximum: 100.
--
-- You can also set the max to be even higher, like 200%.
-- However that could lead to negative effects, and you don't want that.
-- 
-- There is a slider in game that lets you choose what the current tax should be.
-- If you only want there to be one tax then simple change it to:
-- SublimeGov.Config.PropertyTax = {100, 100};
-- OR
-- SublimeGov.Config.SalaryTax   = {0, 0};
-- 
-- There always has to be two numbers here, {1, 2};
SublimeGov.Config.PropertyTax       = {0, 100};
SublimeGov.Config.SalaryTax         = {0, 100};
SublimeGov.Config.SalesTax          = {0, 100};

-- You can disable each section of the taxes as you like.
-- The player will still be able to interact with the user interface in game
-- however, the taxes won't do anything.
SublimeGov.Config.SalesTaxEnabled       = true;
SublimeGov.Config.PropertyTaxEnabled    = true;
SublimeGov.Config.SalaryTaxEnabled      = true;

-- The mayor can choose if he wants to get the tax money or not.
--
-- If he chooses to not get the tax money then the tax money goes back into the governments paychecks.
SublimeGov.Config.MayorGetsMoney = true;
SublimeGov.Config.MayorCanAdjustSalaries = false;

-- This is how much EXTRA the salaries will be if the mayor is allowed to adjust it.
--
-- For example, if the mayor salary is $85 and he sets his own salary to 200 then,
-- the salary would be 85 + 200 = 285.
-- 
-- After the mayor gets an extra $200 on his paycheck then the tax funds gets reduced by $200.
--
-- If there is $0 in the tax fund or LESS than what the mayor has set his tax to then he will not receive anything until
-- the tax funds increase.
--
-- If you want to have a fixed salary then just change the min and max number to the same number like so.
-- SublimeGov.Config.Salaries = {100, 100}; or SublimeGov.Config.Salaries = {50, 250};
--
-- The players get their extra salary every paycheck day.
SublimeGov.Config.Salaries = {0, 200};

-- Every five minutes the mayer will get the tax cut money if it is enabled.
SublimeGov.Config.MayorTaxCooldown = 600;

-- Should we use a text header above our government computer?
-- This can be used a signal towards new players who are not familiar to the system
-- to show that this computer is useable.
SublimeGov.Config.UsePCHeader   = true;
SublimeGov.Config.PCHeader      = "Government Computer";

-- When should the text above the computer activate?
-- This is based on the players position.
-- The higher this number goes the further away the player can see the distance.
-- You should increment this in the thousands instead of hundreds.
-- E.g, go from 1000 -> 2000 instead of 1000 -> 1100.
-- The changes are not so significant.
SublimeGov.Config.TextDistance  = 1000;

-- The higher the number the lower the text goes.
-- You can even go minus if you want to, like -150.
-- Default is 200.
SublimeGov.Config.TextPosition  = 200;

-- If this is set to true then we will use the table beneath it to determine if the player is a cop or not.
-- If it is set to false then we will just use DarkRP's way.
--
-- NOTE, PLEASE READ:
-- THIS IS THE TEAM NAMES, THE WAY THAT ITS WRITTEN IN GAME NOT TEAM_CP ITS CIVIL PROTECTION.
--
-- Default is: false.
SublimeGov.Config.TeamOverride = false;
SublimeGov.Config.JobsAllowed = {
    ["Civil Protection"] = true,
    ["Civil Protection Chief"] = true,
    ["Mayor"] = true,
}