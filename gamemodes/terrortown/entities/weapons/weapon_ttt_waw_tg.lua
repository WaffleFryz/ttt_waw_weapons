AddCSLuaFile()

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType              = "shotgun"

if CLIENT then
   SWEP.PrintName          = "Trench Gun"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 64

   SWEP.Icon               = "materials/entities/robotnik_waw_tg"
   SWEP.IconLetter         = "B"
end

SWEP.Base                  = "weapon_wawbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_SHOTGUN

SWEP.Primary.Ammo          = "Buckshot"
SWEP.Primary.Damage        = 11
SWEP.Primary.Cone          = 0.09
SWEP.Primary.Delay         = 0.92
SWEP.Primary.ClipSize      = 6
SWEP.Primary.ClipMax       = 24
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.Automatic     = true
SWEP.Primary.NumShots      = 8
SWEP.Primary.Sound         = Sound( "waw_trenchgun_new.Single" )
SWEP.Primary.Recoil        = 11

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_box_buckshot_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_waw_trenchgun_new.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_trenchgun_new.mdl"

SWEP.DeploySpeed           = 0.85

SWEP.WorldHandBoneOffset   = Vector(1.4, 0.6, 1)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(2, 7, -3)

SWEP.IronSightsPos         = Vector(-2.5, 0, 3.4)
SWEP.IronSightsAng         = Vector(0, 0, 0)

SWEP.DropOffRanges = {
   [0]    = 25,
   [80]   = 20,
   [120]  = 18,
   [160]  = 15,
   [200]  = 13,
   [240]  = 11
}

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 0, "Reloading")
   self:NetworkVar("Float", 0, "ReloadTimer")

   return BaseClass.SetupDataTables(self)
end

function SWEP:Reload()

   if self:GetReloading() then return end

   if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount( self.Primary.Ammo ) > 0 then

      if self:StartReload() then
         return
      end
   end

end

function SWEP:StartReload()
   if self:GetReloading() then
      return false
   end

   self:SetIronsights( false )

   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   local ply = self:GetOwner()

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then
      return false
   end

   local wep = self

   if wep:Clip1() >= self.Primary.ClipSize then
      return false
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self:SetReloadTimer(CurTime() + wep:SequenceDuration())

   self:SetReloading(true)

   return true
end

function SWEP:PerformReload()
   local ply = self:GetOwner()

   -- prevent normal shooting in between reloads
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

   if self:Clip1() >= self.Primary.ClipSize then return end

   self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
   self:SetClip1( self:Clip1() + 1 )

   self:SendWeaponAnim(ACT_VM_RELOAD)

   self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:FinishReload()
   self:SetReloading(false)
   self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

   self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:CanPrimaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   BaseClass.Think(self)
   if self:GetReloading() then
      if self:GetOwner():KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end

      if self:GetReloadTimer() <= CurTime() then

         if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
            self:FinishReload()
         elseif self:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return
      end
   end
end

function SWEP:Deploy()
   self:SetReloading(false)
   self:SetReloadTimer(0)
   return BaseClass.Deploy(self)
end

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 140)

   -- Decay from 2 to 1 slowly as distance increases. Note that this used to be
   -- 3+, but at that time shotgun bullets were treated like in HL2 where half
   -- of them were hull traces that could not headshot.
   return 1 + math.max(0, (1.0 - 0.002 * (d ^ 1.25)))
end

function SWEP:SecondaryAttack()
   if self.NoSights or (not self.IronSightsPos) or self:GetReloading() then return end

   self:SetIronsights(not self:GetIronsights())

   self:SetNextSecondaryFire(CurTime() + 0.3)
end