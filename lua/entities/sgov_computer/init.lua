--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

local path = SublimeUI.GetCurrentPath();

---
--- Initialize
----
function ENT:Initialize()
	self:SetModel("models/2rek/sgov/sgov_screen.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
end

function ENT:SetComputerID(id)
	self.ComputerID = id;
end

function ENT:GetComputerID()
	return self.ComputerID;
end

function ENT:OnTakeDamage()
	return 0;
end

function ENT:Use(activator)
    if (IsValid(activator) && activator:IsPlayer()) then
        SublimeGov.SendView(activator, self);
    end
end

hook.Add("PhysgunPickup", path, function(ply, ent)
	if (ent:GetClass() == "sgov_computer" and ply:IsSuperAdmin()) then
		return true;
	end
end);