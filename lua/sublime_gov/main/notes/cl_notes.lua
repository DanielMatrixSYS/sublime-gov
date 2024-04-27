--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("SublimeGov.RequestNoteDataAccepted", function()
    local count = net.ReadUInt(32);
    local data  = {};

    for i = 1, count do
        local writer            = net.ReadString();
        local writer_steamid    = net.ReadString();
        local writer_time       = net.ReadUInt(32);
        local writer_likes      = net.ReadUInt(16);
        local writer_dislikes   = net.ReadUInt(16);
        local writer_wrote      = net.ReadString();

        table.insert(data, {
            writer              = writer,
            writer_steamid      = writer_steamid,
            writer_time         = writer_time,
            writer_likes        = writer_likes,
            writer_dislikes     = writer_dislikes,
            writer_wrote        = writer_wrote
        });
    end

    hook.Run("SublimeGov.NoteDataUpdated", data);
end);