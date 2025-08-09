AddCSLuaFile()

if CLIENT then
    SWEP.PrintName            = "M1 Garand"
    SWEP.Slot                 = 2
 
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFlip        = false
    SWEP.ViewModelFOV         = 54
end

SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_wawbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 0.27
SWEP.Primary.Damage          = 34
SWEP.Primary.Recoil          = 3.1
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 8
SWEP.Primary.ClipMax         = 24
SWEP.Primary.DefaultClip     = 8
SWEP.Primary.Cone            = 0.018
SWEP.Primary.Ammo            = "357"
SWEP.Primary.Sound           = Sound("waw_garand.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_m1garand.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_m1garand.mdl"

SWEP.DeploySpeed           = 0.7

SWEP.WorldHandBoneOffset   = Vector(2.5, 0.6, 0.64)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(3, 13, -2)

SWEP.IronSightsPos         = Vector(-2.68, -4.5, 2.65)
SWEP.IronSightsAng         = Vector(-1.0, 0, 0)
SWEP.ZoomFOV               = 70

SWEP.DropOffRanges = {
    [0] = 45,
    [480] = 40,
    [960] = 35
}

-- WAW Notes:
-- 444 rpm, 3.4 tac, 45-35 dmg, 1500m to 2000m

-- Ping on last bullet
-- Shooting functions largely copied from weapon_cs_base
function SWEP:PrimaryAttack(worldsnd)

    self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
    if not self:CanPrimaryAttack() then return end
 
    if not worldsnd then
       self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
    elseif SERVER then
       sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
    end
 
    self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )
 
    self:DoFireAnim()

    self:TakePrimaryAmmo( 1 )
 
    local owner = self:GetOwner()
    if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
 
    owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
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

-- Eject clip on last bullet
function SWEP:DoFireAnim()
    if self:Clip1() == 1 then
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_EMPTY)
    else
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    end
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

function SWEP:Deploy()
    self:SetIronsights(false)
    if self:Clip1() == 0 then
        self:SendWeaponAnim(ACT_VM_DRAW_EMPTY)
    end
    return true
end