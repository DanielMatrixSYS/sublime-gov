--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("SublimeGov.AddNote");
util.AddNetworkString("SublimeGov.RequestNoteData");
util.AddNetworkString("SublimeGov.RequestNoteDataAccepted");

net.Receive("SublimeGov.AddNote", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply) or not ply:sGov_IsConnected()) then
        return;
    end

    local note      = net.ReadString();
    local steamid   = net.ReadString();

    if (not note or note == "" or (ply.sublime_gov_notes_cooldown and ply.sublime_gov_notes_cooldown > CurTime())) then
        return;
    end

    local noteData      = sql.QueryValue("SELECT notes FROM SublimeGov_CriminalData WHERE SteamID = '" .. steamid .. "'");
    local noteConverted = util.JSONToTable(noteData);

    table.insert(noteConverted, {
        writer = ply:Nick(),
        writer_steamid = ply:SteamID64(),
        writer_time = os.time(),
        writer_likes = 0,
        writer_dislikes = 0,
        writer_wrote = note
    });

    local SQL = SublimeGov.GetSQL();

    sql.Query(SQL:FormatSQL("UPDATE SublimeGov_CriminalData SET notes = '%s' WHERE SteamID = '%s'", util.TableToJSON(noteConverted), steamid));

    ply.sublime_gov_notes_cooldown = CurTime() + 60;
end);

net.Receive("SublimeGov.RequestNoteData", function(_, ply)
    if (not IsValid(ply) or not SublimeGov.IsJobCP(ply) or not ply:sGov_IsConnected()) then
        return;
    end

    if (ply.sublime_gov_request_note_cd and ply.sublime_gov_request_note_cd > CurTime()) then
        return;
    end

    local steamid       = net.ReadString();
    local noteData      = sql.QueryValue("SELECT notes FROM SublimeGov_CriminalData WHERE SteamID = '" .. steamid .. "'");
    local noteConverted = util.JSONToTable(noteData);

    net.Start("SublimeGov.RequestNoteDataAccepted");
        net.WriteUInt(#noteConverted, 32);

        for i = 1, #noteConverted do
            local data = noteConverted[i];

            local writer            = data.writer;
            local writer_steamid    = data.writer_steamid;
            local writer_time       = data.writer_time;
            local writer_likes      = data.writer_likes;
            local writer_dislikes   = data.writer_dislikes;
            local writer_wrote      = data.writer_wrote;

            net.WriteString(writer);
            net.WriteString(writer_steamid);
            net.WriteUInt(writer_time, 32);
            net.WriteUInt(writer_likes, 16);
            net.WriteUInt(writer_dislikes, 16);
            net.WriteString(writer_wrote);
        end
    net.Send(ply);

    ply.sublime_gov_request_note_cd = CurTime() + 1;
end);