AddCSLuaFile()

SWEP.HoldType              = "shotgun"

if CLIENT then
   SWEP.PrintName          = "Model 11 DB"
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
SWEP.Primary.Cone          = 0.11
SWEP.Primary.Delay         = 0.283018867925
SWEP.Primary.ClipSize      = 2
SWEP.Primary.ClipMax       = 24
SWEP.Primary.DefaultClip   = 2
SWEP.Primary.Automatic     = true
SWEP.Primary.NumShots      = 8
SWEP.Primary.Sound         = Sound( "waw_db_new.Single" )
SWEP.Primary.Recoil        = 18
SWEP.Primary.Blowback      = 175

SWEP.Secondary.Sound       = Sound( "waw_db_new.Double")
SWEP.Secondary.Recoil      = 36
SWEP.Secondary.Blowback    = 325

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_box_buckshot_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_waw_doublebar_new.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_doublebar_new.mdl"


SWEP.WorldHandBoneOffset   = Vector(1.4, 0.6, 1)
SWEP.WorldHandBoneAngles   = Vector(-8, 1, 180)
SWEP.VOffset               = Vector(0, 7, -1)

SWEP.IronSightsPos         = Vector(-2.5, 0, 3.4)
SWEP.IronSightsAng         = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 1.0

SWEP.DropOffRanges = {
   [0]    = 35,
   [80]   = 30,
   [160]  = 25,
   [240]  = 20,
   [320]  = 15,
   [480]  = 10
}

function SWEP:PrimaryAttack()
   if self:Clip1() >= 1 then
      self:BlastOwner(self.Primary.Blowback)
   end
   self.BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if self:Clip1() >= 2 then
      if not worldsnd then
         self:EmitSound( self.Secondary.Sound, self.Primary.SoundLevel )
      elseif SERVER then
         sound.Play(self.Secondary.Sound, self:GetPos(), self.Primary.SoundLevel)
      end
      self:ShootBullet( self.Primary.Damage, self.Secondary.Recoil, self.Primary.NumShots*2, self:GetPrimaryCone()*2 )
      self:TakePrimaryAmmo( 2 )
      self:BlastOwner(self.Secondary.Blowback)
   else
      self:PrimaryAttack()
   end
end

function SWEP:BlastOwner(velocity)
   local owner = self:GetOwner()
   owner:SetVelocity(owner:GetAimVector() * -1 * velocity)
end