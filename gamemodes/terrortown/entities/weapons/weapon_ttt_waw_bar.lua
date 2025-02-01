AddCSLuaFile()

if CLIENT then
    SWEP.PrintName            = "BAR"
    SWEP.Slot                 = 2
 
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFlip        = false
    SWEP.ViewModelFOV         = 54
end

SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_tttbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 0.16
SWEP.Primary.Damage          = 34
SWEP.Primary.Recoil          = 1.6
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 20
SWEP.Primary.ClipMax         = 60
SWEP.Primary.DefaultClip     = 20
SWEP.Primary.Cone            = 0.018
SWEP.Primary.Ammo            = "Pistol"
SWEP.Primary.Sound           = Sound("waw_bar.Single")

SWEP.HeadshotMultiplier    = 1.4

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_bar.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_bar.mdl"

SWEP.IronSightsPos         = Vector(-2.845, 0, 0.15)
SWEP.IronSightsAng         = Vector(2.599, -0.5, -1)

-- 1500-2000 (MP), 45-35 (MP)

function SWEP:GetViewModelPosition( pos, ang )
    local offset = Vector(3, 13, -2)
    pos = pos + offset.x * ang:Right()
    pos = pos + offset.y * ang:Forward()
    pos = pos + offset.z * ang:Up()
    return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

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
    self:DefaultReload(self.ReloadAnim)
    self:SetIronsights( false )
    self:SetZoom(false)
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()
    
    if IsValid(owner) then
        local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))

        if pos and ang then
            pos = pos + ang:Forward() * -1 + ang:Right() * 0.6 + ang:Up() * 0.43  -- Adjust offsets
            ang:RotateAroundAxis(ang:Right(), -10)
            ang:RotateAroundAxis(ang:Up(), -5)
            ang:RotateAroundAxis(ang:Forward(), 180)

            self:SetRenderOrigin(pos)
            self:SetRenderAngles(ang)
            self:DrawModel()
        end
    else
        self:DrawModel()
    end
end