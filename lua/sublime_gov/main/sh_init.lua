--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

-- A little helper function to recognize government teams.
function SublimeGov.IsJobCP(job)
    if (SublimeGov.Config.TeamOverride) then
        if (isnumber(job)) then
            local name = RPExtraTeams[job].name;

            return SublimeGov.Config.JobsAllowed[name];
        elseif (isstring(job)) then
            return SublimeGov.Config.JobsAllowed[job];
        else
            return SublimeGov.Config.JobsAllowed[team.GetName(job:Team())];
        end

        return false;
    end
    
    local realJob;
    if (isnumber(job)) then
        realJob = job;
    elseif(isstring(job)) then
        for i = 1, #RPExtraTeams do
            local data = RPExtraTeams[i];

            if (data and data.name:lower() == job:lower()) then
                realJob = data.team;

                break;
            end
        end
    else
        realJob = job:Team();
    end

    return GAMEMODE.CivilProtection[realJob] or false;
end

