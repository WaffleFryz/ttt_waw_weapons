AddCSLuaFile()

if CLIENT then 
	ENT.PrintName			= "Springfield Plant"
	ENT.TargetIDHint = {
		name = "Springfield Plant",
		hint = "Springfield Plant2",
		fmt  = function(ent)
				  return "Health: "..ent:Health()
			   end
	};
end
ENT.Type				= "anim"
ENT.Base				= "base_anim"

//spawnable
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.AdminSpawnable		= false
ENT.CanPickup 			= false
ENT.MaxHealth			= 20

function ENT:Initialize()
	
	self:SetModel("models/props/cs_office/plant01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PrecacheGibs()
		self.Entity:SetHealth(self.MaxHealth)
	end
end

function SpringfieldPlantDamage(target, dmginfo)
	if !target:IsValid() or !SERVER or target:GetClass() != "springfield_plant"  then return end
	target:SetHealth( target:Health() - dmginfo:GetDamage() )
	if target:Health() <= 0 then
		target:GibBreakClient(VectorRand())
		target:Remove()
	end
end

hook.Add( "EntityTakeDamage", "Springfield Plant Damage", SpringfieldPlantDamage )