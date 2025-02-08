AddCSLuaFile()

if CLIENT then
    SWEP.PrintName            = "Springfield"
    SWEP.Slot                 = 2
 
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFlip        = false
    SWEP.ViewModelFOV         = 54
end

SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_wawbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 1.2
SWEP.Primary.Damage          = 50
SWEP.Primary.Recoil          = 7
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 5
SWEP.Primary.ClipMax         = 15
SWEP.Primary.DefaultClip     = 5
SWEP.Primary.Cone            = 0.005
SWEP.Primary.Ammo            = "357"
SWEP.Primary.Sound           = Sound("waw_springfield.Single")

SWEP.HeadshotMultiplier    = 2

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_springfield_irons.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_springfield_irons.mdl"

SWEP.WorldHandBoneOffset   = Vector(4, 0.6, 0.43)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(1.5, 15, -2)

SWEP.IronSightsPos         = Vector(-3.55, 0, 3.85)
SWEP.IronSightsAng         = Vector(0.59, -0.05, -0.25)
SWEP.ZoomFOV               = 40

SWEP.DropOffRanges = {
    [0]    = 50,
    [1240] = 40
}

SWEP.HitgroupMultipliers = {
    [HitgroupToFlags(HITGROUP_CHEST, HITGROUP_LEFTARM, HITGROUP_RIGHTARM)] = 1.5,
    [HitgroupToFlags(HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG)] = 0.85
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