--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

local function AddReleasedData(victim, officer, released)
    if (#SublimeGov.Unarrests + 1 > 10) then
        table.remove(SublimeGov.Unarrests, 1);
    end

    table.insert(SublimeGov.Unarrests, {
        victim_nick = victim,
        officer_nick = officer,
        released = released
    });
end

net.Receive("SublimeGov.SendArrestData", function()
    local send_last = net.ReadBool();
    
    if (not send_last) then
        table.Empty(SublimeGov.Unarrests);

        local count = net.ReadUInt(32);
        for i = 1, count do
            local victim_nick   = net.ReadString();
            local officer_nick  = net.ReadString();
            local released      = net.ReadUInt(32);

            AddReleasedData(victim_nick, officer_nick, released);
        end

        hook.Run("SublimeGov.ReleasedDataWasUpdated", SublimeGov.Unarrests);
    else
        local victim_nick   = net.ReadString();
        local officer_nick  = net.ReadString();
        local released      = net.ReadUInt(32);

        AddReleasedData(victim_nick, officer_nick, released);

        hook.Run("SublimeGov.ReleasedDataWasUpdated", {{
            victim_nick = victim_nick,
            officer_nick = officer_nick,
            released = released
        }});
    end
end);

--
-- DarkRP doesn't have a hook for when the player gets arrested for the clients,
-- like it does for the server.. So we made our own.
-- 
-- We do some verifications when the hook is ran, to make sure no duplicates are added.
--
gameevent.Listen("player_spawn");
hook.Add("player_spawn", path, function(data)
    local id        = data.userid;
    local player    = Player(id);

    if (not IsValid(player)) then
        return;
    end

    if (player:isArrested()) then
        hook.Run("SublimeGov.PlayerWasArrested", player);
    end
end);