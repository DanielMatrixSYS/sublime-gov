--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local path = SublimeUI.GetCurrentPath();

net.Receive("SublimeGov.ComputerView", function()
    local computer = net.ReadEntity();

    local view;
    local stage = 0;
    local hasCalledLastStage = false;
    local frame;
    local alpha = 0;

    hook.Add("CalcView", path, function(ply, origin, angles, fov, znear, zfar)
        if (!IsValid(computer)) then
            hook.Remove("CalcView", path)
            return view;
        end

        if (!view) then
            view = {}
            view.origin = origin;
            view.angles = angles;
            view.fov    = fov;
        end

        -- todo: ur mother
        local factor = math.Clamp(4.5 * FrameTime(), 0.0, 1.0);

        if (stage == 0) then 
            local targetPos = computer:GetStartViewPosition();
            local targetAng = computer:GetViewAngle();

            view.origin = LerpVector(factor, view.origin, targetPos);
            view.angles = LerpAngle(factor, view.angles, targetAng);

            local vecDist = view.origin:Distance(targetPos);
            local angDist = math.AngleDifference(view.angles.p, targetAng.p) + math.AngleDifference(view.angles.y, targetAng.y) 
                                    + math.AngleDifference(view.angles.r, targetAng.r)

            if (vecDist <= 2 && angDist <= 2) then
                stage = 1;
                view.origin = targetPos;
                view.angles = targetAng
            end
        elseif (stage == 1) then
            local targetAng = math.deg(math.atan(computer:GetViewDistance() / computer:GetViewWidth())) / 2;
            view.fov = Lerp(factor, view.fov, targetAng);

            if (math.AngleDifference(view.fov, targetAng) <= 0.5) then 
                view.fov = targetAng
                stage = 2;
            end
        else
            if (not hasCalledLastStage) then
                frame = vgui.Create("SublimeGov.Login.Frame");
                frame:SetPos(0, 0);
                frame:SetSize(ScrW(), ScrH());
                frame:MakePopup();
                frame:SetAlpha(0);

                hasCalledLastStage = true;
            end

            if (IsValid(frame)) then
                alpha = math.Approach(alpha, 255, 2);
                
                if (frame:GetAlpha() < 255) then
                    frame:SetAlpha(alpha);
                end
            end
        end

        return view;
    end);
end);

function SublimeGov.StopViewing()
    hook.Remove("CalcView", path);
end