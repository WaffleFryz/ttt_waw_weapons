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
SWEP.Primary.Recoil          = 2
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 20
SWEP.Primary.ClipMax         = 60
SWEP.Primary.DefaultClip     = 20
SWEP.Primary.Cone            = 0.018
SWEP.Primary.Ammo            = "Pistol"
SWEP.Primary.Sound           = Sound("waw_bar.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_bar.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_bar.mdl"

SWEP.WorldHandBoneOffset   = Vector(-1, 0.6, 0.43)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(3, 13, -2)

SWEP.IronSightsPos         = Vector(-2.845, 0, 0.15)
SWEP.IronSightsAng         = Vector(2.599, -0.5, -1)

SWEP.DropOffRanges = {
    [0] = 45,
    [840] = 40,
    [1200] = 35
}

function SWEP:SetZoom(state)
    if not (IsValid(self:GetOwner()) and self:GetOwner():IsPlayer()) then return end
    if state then
       self:GetOwner():SetFOV(35, 0.5)
    else
       self:GetOwner():SetFOV(0, 0.2)
    end
end

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

function SWEP:Reload()
    if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
    if self:Clip1() <= 0 then
        self:DefaultReload(ACT_VM_RELOAD_EMPTY)        
    else
        self:DefaultReload(self.ReloadAnim)
    end
    self:SetIronsights( false )
    self:SetZoom(false)
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end