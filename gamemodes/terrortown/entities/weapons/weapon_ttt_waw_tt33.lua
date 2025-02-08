AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Tokarev TT-33"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "materials/entities/robotnik_waw_tok"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_wawbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL

SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Damage        = 24
SWEP.Primary.Delay         = 0.23
SWEP.Primary.Cone          = 0.03
SWEP.Primary.ClipSize      = 8
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "waw_tokarev.Single" )

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_waw_tokarevtt33.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_tokarev.mdl"

SWEP.WorldHandBoneOffset   = Vector(0.7, 1.3, 1)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(3, 17, -1)

SWEP.IronSightsPos         = Vector(-3.2, -4, 2.5)
SWEP.IronSightsAng         = Vector(0, -0.0085, 0)

SWEP.DropOffRanges = {
   [0]   = 40,
   [240] = 35,
   [440] = 28,
   [560] = 24,
   [800] = 20
}