AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Colt M1911"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "materials/entities/robotnik_waw_1911"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_wawbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL

SWEP.Primary.Recoil        = 2
SWEP.Primary.Damage        = 25
SWEP.Primary.Delay         = 0.27
SWEP.Primary.Cone          = 0.028
SWEP.Primary.ClipSize      = 8
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.ClipMax       = 64
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "waw_1911.Single" )

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_waw_colt45.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_coltm1911.mdl"

SWEP.WorldHandBoneOffset   = Vector(0.6, -3.4, 1.8)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(3, 17, -1)

SWEP.IronSightsPos         = Vector(-3.2, -4, 2.6)
SWEP.IronSightsAng         = Vector(-0.1, -0.05, 0)

SWEP.DropOffRanges = {
    [0]   = 40,
    [240] = 36,
    [460] = 34,
    [560] = 26,
    [640] = 24,
    [800] = 20
}