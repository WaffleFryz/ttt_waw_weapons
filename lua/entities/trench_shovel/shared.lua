AddCSLuaFile()

ENT.PrintName			= "TrenchShovel"
ENT.Type				= "anim"
ENT.Base				= "base_anim"

//spawnable
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.AdminSpawnable		= false
ENT.CanPickup 			= false
ENT.HasHitEnt           = false

function ENT:Initialize()
	
	self:SetModel("models/props_junk/shovel01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
    if SERVER and IsValid(self) then
        timer.Simple(10, function()
            self.Entity:Dissolve()
        end)
    end
end

if SERVER then

	function ENT:PhysicsCollide(data, phys)
		
		local attacker
		if IsValid(self.Owner) then
			attacker = self.Owner
		else
			attacker = self.Entity
			return
		end
		
		local target = data.HitEntity

		if target:IsPlayer() and !self.HasHitEnt then
			target:TakeDamage(11, attacker, self.Entity)
            self.HasHitEnt = true
        elseif target:IsWorld() then
            self.HasHitEnt = true
        end
	end
end