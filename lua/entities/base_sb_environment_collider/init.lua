AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local SB = CAF.GetAddon("Spacebuild")

function ENT:Initialize()
	self:BasePhysInit()
	self:DrawShadow(false)
	self:SetNoDraw(true)
end

function ENT:BasePhysInit()
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetTrigger(true)
	self:PhysWake()
end

function ENT:SetEnvironment(env)
	self:SetPos(env:GetPos())
	self:SetParent(env)
	self.sbenv = env
	env:SBEnvPhysics(self)
	self:BasePhysInit()
end

function ENT:StartTouch(ent)
	if ent.SkipSBChecks or not self.sbenv then
		return
	end

	if not ent.SBInEnvironments then
		ent.SBInEnvironments = {}
	end

	ent.SBInEnvironments[self.sbenv] = true
	SB.PerformEnvironmentCheckOnEnt(ent)
end

function ENT:EndTouch(ent)
	if ent.SkipSBChecks or not self.sbenv then
		return
	end

	if not ent.SBInEnvironments then
		ent.SBInEnvironments = {}
	end

	ent.SBInEnvironments[self.sbenv] = nil
	SB.PerformEnvironmentCheckOnEnt(ent)
end
