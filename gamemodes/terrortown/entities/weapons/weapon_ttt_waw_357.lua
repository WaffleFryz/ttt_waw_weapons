AddCSLuaFile()

SWEP.HoldType              = "revolver"

if CLIENT then
   SWEP.PrintName          = ".357 Magnum"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 65

   SWEP.Icon               = "materials/entities/robotnik_waw_mgm"
end

SWEP.Base                  = "weapon_wawbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = 6.3
SWEP.Primary.Damage        = 50
SWEP.Primary.Delay         = 0.5
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 6
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound( "waw_magnum.Single" )

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_waw_magnum.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_magnum.mdl"

SWEP.WorldHandBoneOffset   = Vector(-1, 0.6, 0.43)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(3, 5, -1)

-- SWEP.IronSightsPos         = Vector(-6.45, -1.701, 2.8)
-- bai lu borked
SWEP.IronSightsPos         = Vector(-3.391, -1.701, 3.15)
SWEP.IronSightsAng         = Vector(0, 0, 0)

SWEP.DropOffRanges = {
   [0]   = 50,
   [440] = 40,
   [640] = 35,
   [800] = 30
}