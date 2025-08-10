AddCSLuaFile()

if CLIENT then
    SWEP.PrintName            = "PPSH-41"
    SWEP.Slot                 = 2
 
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFlip        = false
    SWEP.ViewModelFOV         = 54
end

SWEP.HoldType                = "crossbow"

SWEP.Base                    = "weapon_wawbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 0.048
SWEP.Primary.Damage          = 22
SWEP.Primary.Recoil          = 0.5
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 71
SWEP.Primary.ClipMax         = 142
SWEP.Primary.DefaultClip     = 71
SWEP.Primary.Cone            = 0.01
SWEP.Primary.Ammo            = "SMG1"
SWEP.Primary.Sound           = Sound("waw_ppsh_new.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_ppsh_new.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_ppsh_new.mdl"

SWEP.WorldHandBoneOffset   = Vector(1, 0.6, 0.5)
SWEP.WorldHandBoneAngles   = Vector(-3, 0, 180)
SWEP.VOffset               = Vector(5, 20, -1.5)

SWEP.IronSightsPos         = Vector(-4, -10, 2.5)
SWEP.IronSightsAng         = Vector(-0.6,-0.25, 0)

SWEP.DropOffRanges = {
    [0] = 20,
    [240] = 15,
    [640] = 10
}

SWEP.recoilsStart = {
    Angle(2, 2.49, 0),
    Angle(3, 1.5, 0),
    Angle(3, 3.25, 0),
    Angle(0.75, -5.75, 0),
    Angle(0.5, -5.1, 0),
    Angle(1.5, 8, 0)
}

SWEP.recoilsLoop = {
    Angle(0.5, 3, 0),
    Angle(0.25, 3, 0),
    Angle(-0.5, 3, 0),
    Angle(-0.5, -3, 0),
    Angle(-0.25, -3, 0),
    Angle(0.25, -3, 0),
    Angle(0.5, -3, 0)
}

SWEP.recoilResetSpeed = 1