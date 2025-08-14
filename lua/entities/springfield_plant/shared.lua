AddCSLuaFile()

ENT.PrintName			= "SpringfieldPlant"
ENT.Type				= "anim"
ENT.Base				= "base_anim"

//spawnable
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.AdminSpawnable		= false
ENT.CanPickup 			= false

function ENT:Initialize()
	
	self:SetModel("models/props/cs_office/plant01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
end