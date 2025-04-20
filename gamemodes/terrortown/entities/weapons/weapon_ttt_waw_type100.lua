AddCSLuaFile()

if CLIENT then
    SWEP.PrintName          = "Type 100"
    SWEP.Slot               = 2
 
    SWEP.ViewModelFlip      = false
    SWEP.ViewModelFOV       = 54
    SWEP.IconLetter         = "w"
end

SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_wawbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 0.08
SWEP.Primary.Damage          = 20
SWEP.Primary.Recoil          = 1.5
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 30
SWEP.Primary.ClipMax         = 60
SWEP.Primary.DefaultClip     = 30
SWEP.Primary.Cone            = 0.06
SWEP.Primary.Ammo            = "SMG1"
SWEP.Primary.Sound           = Sound("waw_type100_new.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_type100_new.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_type100_new.mdl"

SWEP.DeploySpeed           = 0.8

SWEP.WorldHandBoneOffset   = Vector(1, 0.6 , 0.8)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(-2, 12, -1)

SWEP.IronSightsPos         = Vector(-2.07, -5, 3.55)
SWEP.IronSightsAng         = Vector(-1.3, 0.725, 3)

SWEP.DropOffRanges = {
    [0]   = 40,
    [80]  = 35,
    [160] = 30,
    [240] = 25,
    [560] = 20
}