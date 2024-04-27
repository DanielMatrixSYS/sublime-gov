TOOL.Category   = "Sublime Tools";
TOOL.Name       = "sGov Computer Spawner";
TOOL.Command    = nil;
TOOL.ConfigName = "";
TOOL.Model      = "models/2rek/sgov/sgov_screen.mdl";
TOOL.Ang 		= Angle(0, 0, 0);

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}

local L = SublimeGov.L;

if (CLIENT) then
	language.Add("tool.sgov_tool.name", "Sublime Computer Tool");
	language.Add("tool.sgov_tool.desc", "A helper tool for Sublime Government.");
	language.Add("tool.sgov_tool.left", "Left click to spawn.");
	language.Add("tool.sgov_tool.right", "Right click to remove.");
	language.Add("tool.sgov_tool.reload", "Reload to save.");
end

function TOOL:LeftClick(trace)
	if (SERVER) then
		local owner = self:GetOwner();

		if (IsValid(owner) and SublimeGov.Config.Administrators[owner:GetUserGroup()]) then
			self:SpawnComputer(trace.HitPos);
		end
	end

	return true;
end
 
function TOOL:RightClick(trace)
	if (SERVER) then
		local owner = self:GetOwner();

		if (IsValid(owner) and SublimeGov.Config.Administrators[owner:GetUserGroup()]) then
			self:RemoveComputer(trace);
		end
	end

	return true;
end

function TOOL:Reload()
	if (SERVER) then
		local owner = self:GetOwner();

		if (IsValid(owner) and SublimeGov.Config.Administrators[owner:GetUserGroup()]) then
			local trace = owner:GetEyeTrace();

			self:SaveComputer(trace);
		end
	end

	return true;
end

if (SERVER) then
	function TOOL:SpawnComputer(pos)
		local computer = ents.Create("sgov_computer");
		computer:SetPos(pos);
		computer:SetAngles(self.Ang);
		computer:Spawn();
		
		if (FPP) then
			computer:CPPISetOwner(self:GetOwner());
		end


		math.randomseed(os.time());

		local id = math.random(1, 999999999999);
		computer:SetComputerID(id);

		table.insert(SublimeGov.SpawnedComputers, computer);
	end

	function TOOL:RemoveComputer(trace)
		local ent 	= trace.Entity;
		local owner = self:GetOwner();

		if (not IsValid(owner)) then
			return;
		end

		if (IsValid(ent) and ent:GetClass() == "sgov_computer") then
			SublimeGov.RemoveComputer(owner, ent);
		else
			DarkRP.notify(owner, 1, 4, "Either the entity is not valid or it's not a Sublime Computer");
		end
	end

	function TOOL:SaveComputer(trace)
		local ent 	= trace.Entity;
		local owner = self:GetOwner();
		local cd 	= ent.sgov_save_cooldown;
		if (not IsValid(owner) or (cd and cd > CurTime())) then
			return;
		end
		
		if (IsValid(ent) and ent:GetClass() == "sgov_computer") then
			SublimeGov.SaveComputer(owner, ent);

			ent.sgov_save_cooldown = CurTime() + 1;
		else
			DarkRP.notify(owner, 1, 4, "Either the entity is not valid or it's not a Government Computer");
		end
	end
end


function TOOL:DrawToolScreen(w, h)
    surface.SetDrawColor(0, 0, 0);
    surface.DrawRect(0, 0, w, h);

    SublimeUI.DrawTextOutlined(SublimeUI.textWrap(L("tool_spawn"), "SublimeUI.34", w - 20), "SublimeUI.34", w / 2, 7, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    SublimeUI.DrawTextOutlined(SublimeUI.textWrap(L("tool_delete"), "SublimeUI.34", w - 20), "SublimeUI.34", w / 2, (h / 2) - 17, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
    SublimeUI.DrawTextOutlined(SublimeUI.textWrap(L("tool_save"), "SublimeUI.34", w - 20), "SublimeUI.34", w / 2, (h - 7) - 34, SublimeUI.White, SublimeUI.Black, TEXT_ALIGN_CENTER);
end

function TOOL:UpdateGhostComputer(ent, ply)
	if (not IsValid(ent)) then
        return;
    end

	local trace = ply:GetEyeTrace();
	if (not trace.Hit or IsValid(trace.Entity) and (trace.Entity:GetClass() == "sgov_computer" or trace.Entity:IsPlayer())) then
		ent:SetNoDraw(true);

		return
	end

	local pAng = ply:GetAngles();
	local ang = trace.HitNormal:Angle();
	ang.pitch = ang.pitch + 90;

	local min = ent:OBBMins();
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z);
	ent:SetAngles(ang);
	ent:SetNoDraw(false);

	self.Ang = ang;
end

function TOOL:Think()
	local mdl = self.Model;

	if (not IsValid(self.GhostEntity) or self.GhostEntity:GetModel() ~= mdl) then
		self:MakeGhostEntity(mdl, Vector(0, 0, 0), Angle(0, 0, 0));
	end

	self:UpdateGhostComputer(self.GhostEntity, self:GetOwner());
end