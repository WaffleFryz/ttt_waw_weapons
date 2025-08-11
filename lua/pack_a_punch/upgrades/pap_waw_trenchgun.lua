local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_slamfire"
UPGRADE.class = "weapon_ttt_waw_tg"
UPGRADE.name = "Slamfire M1897"
UPGRADE.desc = "Faster firerate. Larger mag"
UPGRADE.ammoMult = 10/6
UPGRADE.firerateMult = 1.5
UPGRADE.noSound = true

function UPGRADE:Apply(SWEP)

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