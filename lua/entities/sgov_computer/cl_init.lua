--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

include("shared.lua");

ENT.LocalTopLeft        = Vector(2.2, -16.3, 28)
ENT.LocalTopRight       = Vector(2.2, 16.3, 28)
ENT.LocalBottomLeft     = Vector(2.2, -16.3, 5.5)
ENT.LocalBottomRight    = Vector(2.2, 16.3, 5.5)
ENT.ViewPosition        = Vector(50, 0, 16.75);

ENT.LocalPlayer         = nil;

function ENT:Draw()
    self:DrawModel();

    self.LocalPlayer = self.LocalPlayer and IsValid(self.LocalPlayer) and self.LocalPlayer or LocalPlayer();

    if (SublimeGov.Config.UsePCHeader and IsValid(self) and IsValid(self.LocalPlayer)) then
        local pos = self:GetPos();

        if (self.LocalPlayer:GetPos():DistToSqr(pos) < SublimeGov.Config.TextDistance ^ 2) then
            local offset    = Vector(0, 0, 42);
            local ang       = self.LocalPlayer:EyeAngles();
            local center    = self:OBBCenter();
            local pos       = (self:LocalToWorld(center) + offset + ang:Up());

            ang:RotateAroundAxis(ang:Forward(), 90);
            ang:RotateAroundAxis(ang:Right(), 90);

            cam.IgnoreZ(false);
            cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1);
                SublimeUI.DrawTextOutlined(SublimeGov.Config.PCHeader, "SublimeUI.52", 0, SublimeGov.Config.TextPosition, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
            cam.End3D2D();
        end
    end
    
    -- render.SetColorMaterial();
    -- render.DrawSphere(self:LocalToWorld(self.LocalTopLeft), 1, 10, 10, Color(255, 0, 0))
    -- render.DrawSphere(self:LocalToWorld(self.LocalTopRight), 1, 10, 10, Color(255, 0, 0))
    -- render.DrawSphere(self:LocalToWorld(self.LocalBottomLeft), 1, 10, 10, Color(255, 0, 0))
    -- render.DrawSphere(self:LocalToWorld(self.LocalBottomRight), 1, 10, 10, Color(255, 0, 0))
    -- render.DrawSphere(self:LocalToWorld(self.ViewPosition), 1, 10, 10, Color(0, 255, 0))
end

function ENT:GetStartViewPosition()
    return self:LocalToWorld(self.ViewPosition)
end

function ENT:GetViewAngle()
    return self:LocalToWorldAngles(Angle(0, 180, 0));
end

function ENT:GetViewWidth()
    return math.max(self.LocalTopRight.y, self.LocalTopLeft.y) - math.min(self.LocalTopRight.y, self.LocalTopLeft.y)
end

function ENT:GetViewDistance()
    local maxX = math.max(self.LocalTopLeft.x, self.LocalTopRight.x, self.LocalBottomLeft.x, self.LocalBottomRight.x);

    return math.max(maxX, self.ViewPosition.x) - math.min(maxX, self.ViewPosition.x)
end

