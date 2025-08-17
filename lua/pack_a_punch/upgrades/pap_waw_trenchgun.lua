local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_slamfire"
UPGRADE.class = "weapon_ttt_waw_tg"
UPGRADE.name = "Grave Digger"
UPGRADE.desc = "Spawns shovels above target"
UPGRADE.ammoMult = 10/6

function UPGRADE:Apply(SWEP)

	SWEP.DropOffRanges = {
		[0]    = 15,
		[160]  = 12,
		[240]  = 10,
		[320]  = 7,
		[480]  = 5
	}
	 

	function SWEP:MakeShovel(tr)
		if(tr.Entity:IsPlayer()) then
		   local gren = ents.Create("trench_shovel")
		   if not IsValid(gren) then return end
		   gren:SetOwner(self:GetOwner())
		   gren:SetPos(tr.HitPos + Vector(0, 0, 250))
		   gren:Spawn()
		   gren:GetPhysicsObject():SetVelocity(Vector(0, 0, -550))
		   gren:PhysWake()
		end
	  end
	  
	function SWEP:ShootBullet( dmg, recoil, numbul, cone )
	
		self:SendWeaponAnim(self.PrimaryAnim)
		
		self:GetOwner():MuzzleFlash()
		self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
		
		local sights = self:GetIronsights()
		
		numbul = numbul or 1
		cone   = cone   or 0.01
	
		local function bulletCallback(attacker, tr, dmginfo)
			if not IsValid(attacker) then return end
	
			if not IsValid(tr.Entity) then return end
	
		if SERVER then self:MakeShovel(tr) end
	
			if self.DropOffRanges and IsValid(tr.Entity) then
				local dist = tr.Entity:GetPos():Distance(attacker:GetPos())
				local highest = 0
				for d, dmg in pairs(self.DropOffRanges) do
					if d <= dist and d >= highest then
						highest = d
					end
				end
				dmginfo:SetDamage(self.DropOffRanges[highest] * self.DamageScale:GetFloat())
			end
		end
		
		local bullet = {}
		bullet.Num    = numbul
		bullet.Src    = self:GetOwner():GetShootPos()
		bullet.Dir    = self:GetOwner():GetAimVector()
		bullet.Spread = Vector( cone, cone, 0 )
		bullet.Tracer = 1
		bullet.TracerName = self.Tracer or "Tracer"
		bullet.Force  = 10
		bullet.Damage = dmg
		bullet.Callback = bulletCallback
		
		self:GetOwner():FireBullets( bullet )
		
		-- Owner can die after firebullets
		if (not IsValid(self:GetOwner())) or self:GetOwner():IsNPC() or (not self:GetOwner():Alive()) then return end
		
		if ((game.SinglePlayer() and SERVER) or
			((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then
		
			-- reduce recoil if ironsighting
			recoil = sights and (recoil * 0.6) or recoil
		
			local eyeang = self:GetOwner():EyeAngles()
			eyeang.pitch = eyeang.pitch - recoil
			self:GetOwner():SetEyeAngles( eyeang )
		end
	end

	-- Double shell reload
	function SWEP:PerformReload()
		local ply = self:GetOwner()
	 
		-- prevent normal shooting in between reloads
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	 
		if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
	 
		if self:Clip1() >= self.Primary.ClipSize then return end
	 
		if ply:GetAmmoCount(self.Primary.Ammo) >= 2 and self:Clip1() != 9 then
			self:GetOwner():RemoveAmmo( 2, self.Primary.Ammo, false )
			self:SetClip1( self:Clip1() + 2 )
		else 
			self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
			self:SetClip1( self:Clip1() + 1 )
		end
	 
		self:SendWeaponAnim(ACT_VM_RELOAD)
	 
		self:SetReloadTimer(CurTime() + self:SequenceDuration())
	end
end

TTTPAP:Register(UPGRADE)