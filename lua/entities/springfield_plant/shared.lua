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
ENT.CanPickup 			= true
ENT.MaxHealth			= CreateConVar("springfield_plant_health", "20", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Springfield plant health") 

local radius 			= CreateConVar("springfield_plant_radius", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "How much the far plants heal in meters") 
local plantHeal         = CreateConVar("springfield_plant_heal", "2", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "How much the plants heal per second")
local radiusInMeters    = radius:GetFloat() * 39.37
local plantRadiusSqr    = radiusInMeters * radiusInMeters

function ENT:Initialize()
	self:SetModel("models/props/cs_office/plant01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PrecacheGibs()
		self.Entity:SetHealth(self.MaxHealth:GetFloat())
	end
end

function DoHeal()
	for _, ply in player.Iterator() do
		for _, ent in ents.Iterator() do
			local dist = ply:GetPos():DistToSqr(ent:GetPos())
			if ent:GetClass() == "springfield_plant" and dist <= plantRadiusSqr and ply:Health() < ply:GetMaxHealth() then
				local health = math.min(ply:GetMaxHealth(), ply:Health() + plantHeal:GetFloat())
				ply:SetHealth(health)
				ent:TakeDamage(plantHeal:GetFloat(), ply, ply)
			end
		end
	end
end

function SpringfieldPlantDamage(target, dmginfo)
	if SERVER then
		if !target:IsValid() or target:GetClass() != "springfield_plant" then return end
		target:SetHealth( target:Health() - math.abs(dmginfo:GetDamage()) )
		if target:Health() <= 0 then
			target:GibBreakClient(VectorRand())
			target:Remove()
		end
	end
end

function DestoryTimer(result)
	if timer.Exists("springfieldHeal") then 
		timer.Remove("springfieldHeal")
		print("PLANT TIMERS DESTROYED")
	end
end

hook.Add("EntityTakeDamage", "Springfield Plant Damage", SpringfieldPlantDamage )

if SERVER then
	timer.Create("springfieldHeal", 1, 0, DoHeal)
end