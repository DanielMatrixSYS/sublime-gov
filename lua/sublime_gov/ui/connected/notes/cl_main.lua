--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "Notes", "Notes");
AccessorFunc(panel, "SteamID", "SteamID");

surface.CreateFont("SublimeUI.16.Italic", 
{
    font    = "Roboto", 
    size    = 16, 
    weight  = 400,
    italic  = true
});

function panel:Init()
    self.Approach   = math.Approach;
    self.Time       = SysTime();
    self.L          = SublimeGov.L;

    self.CreatedNotes = {};

    self.ScrollPanel = self:Add("DScrollPanel");
    local vBar = self.ScrollPanel:GetVBar();

    vBar:SetWidth(0);

    vBar.Paint = function()
        return true;
    end

    vBar.btnUp.Paint = function()
        return true;
    end

    vBar.btnDown.Paint = function()
        return true;
    end

    vBar.btnGrip.Paint = function()
        return true;
    end

    self.Exit = self:Add("DButton");
    self.Exit:SetText("");
    self.Exit:SetCursor("arrow");

    self.Exit.Alpha = 200;

    self.Exit.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 0);
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(ColorAlpha(SublimeUI.Grey, s.Alpha));
        surface.SetMaterial(SublimeUI.Materials["Exit"]);
        surface.DrawTexturedRect(0, 0, 12, 12);

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 150, 2)
        else
            s.Alpha = self.Approach(s.Alpha, 200, 2);
        end
    end

    self.Exit.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end

    self.Exit.DoClick = function()
        if (IsValid(self)) then
            self:Remove();
        end
    end

    self.CreateNote = self:Add("Sublime.Button");
    self.CreateNote:SetTextPos(TEXT_ALIGN_CENTER);
    self.CreateNote:SetText(self.L("ui_create_notes"));

    self.CreateNote.DoClick = function(s, w, h)
        local frame = vgui.Create("SublimeGov.Notification");
        frame.SteamID = self.SteamID
        frame:SetSize(500, 190);
        frame:Center();
        frame:MakePopup();
        frame:SetDisplayDecline(true);
        frame:SetUseTextEdit(true);
        frame:SetTitle(self.L("ui_add_note"));
        frame:SetDescription(self.L("ui_add_note_desc"));

        frame.DoAcceptClick = function(s)
            local text = s:GetTextEntryValue();

            if (not text or text == "") then
                return;
            end

            if (#text > 300) then
                SublimeGov.CreateNotification(self.L("ui_add_woah"), self.L("ui_add_max", #text), false);

                return false;
            end

            local cd = LocalPlayer().sublime_gov_notes_cooldown
            if (cd and cd > CurTime()) then
                SublimeGov.CreateNotification(self.L("ui_add_notes_cd"), self.L("ui_add_note_post_new", string.NiceTime(cd - CurTime())), false);

                return false;
            end

            net.Start("SublimeGov.AddNote");
                net.WriteString(text);
                net.WriteString(s.SteamID);
            net.SendToServer();

            LocalPlayer().sublime_gov_notes_cooldown = CurTime() + 60;
        end

        frame.PaintOver = function(s, w, h)
            local count = #s:GetTextEntryValue();
            local color = count < 301 and SublimeUI.White or SublimeUI.Red;

            SublimeUI.DrawTextOutlined(#s:GetTextEntryValue() .. "/300", "SublimeUI.16", w / 2, h - 61, color, SublimeUI.Black, TEXT_ALIGN_CENTER);
        end
    end
end

function panel:AddNote(data)
    local nextNote = #self.CreatedNotes + 1;

    self.CreatedNotes[nextNote] = self.ScrollPanel:Add("DButton");
    local note = self.CreatedNotes[nextNote];

    note:SetText("");

    note.Alpha = 0;

    note.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(SublimeUI.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            if (s.Alpha ~= 0) then
                s.Alpha = self.Approach(s.Alpha, 0, 2);
            end
        end
    
        SublimeUI.DrawTextOutlined(data.writer, "SublimeUI.16", 7, 7, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);
        SublimeUI.DrawTextOutlined(string.NiceTime(os.time() - data.writer_time) .. " " .. self.L("ui_connected_ago"), "SublimeUI.16", w - 7, 7, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_RIGHT);
        
        note.TextHeight = SublimeUI.DrawTextOutlined(SublimeUI.textWrap("\"" .. data.writer_wrote .. "\"", "SublimeUI.16.Italic", w - 40), "SublimeUI.16.Italic", w / 2, h / 2, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER, true);
        note:SetTall(note.TextHeight);
    end

    note.OnCursorEntered = function()
        surface.PlaySound("sublimeui/button.mp3");
    end
end

function panel:PostInit()
    for i = 1, #self.Notes do
        local data = self.Notes[i];

        self:AddNote(data);
    end
end

function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.ScrollPanel:SetPos(7, 38);
    self.ScrollPanel:SetSize(w - 14, h - 80);

    self.CreateNote:SetPos(7, h - 37);
    self.CreateNote:SetSize(w - 14, 30);

    local nextPos = 0;
    for i = 1, #self.CreatedNotes do
        local note = self.CreatedNotes[i];

        if (IsValid(note) && note.TextHeight) then
            local width = self.ScrollPanel:GetWide();

            note:SetPos(0, nextPos);
            note:SetSize(width, note.TextHeight + 50);

            nextPos = nextPos + note:GetTall() + 5
        end
    end
end

function panel:Think()
    if (self.Notes and not self.HasCalledPostInit) then
        self:PostInit();

        self.HasCalledPostInit = true;
    end
end

function panel:OnFocusChanged(gained)
    if (not gained) then
        self:Remove();
    end
end

function panel:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.Time);

    surface.SetDrawColor(255, 255, 255, 255);
    surface.SetMaterial(SublimeUI.Materials["Background"]);
    surface.DrawTexturedRect(0, 0, w, h);
    surface.DrawTexturedRect(2, 2, w - 4, 30);

    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(SublimeUI.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 32, w - 4, 1)

    SublimeUI.DrawTextOutlined(self.L("ui_note_title"), "SublimeUI.16", 7, 9, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_LEFT);

    if (#self.CreatedNotes < 1) then
        SublimeUI.DrawTextOutlined(self.L("ui_note_zero"), "SublimeUI.18", w / 2, h / 2, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    end
end
vgui.Register("SublimeGov.Connected.Notes", panel, "EditablePanel");