AddCSLuaFile()

if CLIENT then
    SWEP.PrintName            = "BAR"
    SWEP.Slot                 = 2
 
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFlip        = false
    SWEP.ViewModelFOV         = 54
end

SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_wawbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 0.16
SWEP.Primary.Damage          = 34
SWEP.Primary.Recoil          = 2.5
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 20
SWEP.Primary.ClipMax         = 60
SWEP.Primary.DefaultClip     = 20
SWEP.Primary.Cone            = 0.025
SWEP.Primary.Ammo            = "Pistol"
SWEP.Primary.Sound           = Sound("waw_bar.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_bar.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_bar.mdl"

SWEP.WorldHandBoneOffset   = Vector(2.9, 0.6, 0.7)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(3, 13, -2)

SWEP.IronSightsPos         = Vector(-2.69, -1.3, 2.55)
SWEP.IronSightsAng         = Vector(-2.5, -0.125, 0)
SWEP.ZoomFOV               = 70
SWEP.ZoomTime              = 0.35

SWEP.DropOffRanges = {
    [0] = 35,
    [480] = 30,
    [960] = 25
}

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end
 
    local bIronsights = not self:GetIronsights()
 
    self:SetIronsights( bIronsights )
 
    self:SetZoom( bIronsights )
 
    self:SetNextSecondaryFire( CurTime() + 0.3 )
end

function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end