AddCSLuaFile()

if CLIENT then
    SWEP.PrintName            = "M1 Garand"
    SWEP.Slot                 = 2
 
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFlip        = false
    SWEP.ViewModelFOV         = 54
end

SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_tttbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 0.27
SWEP.Primary.Damage          = 34
SWEP.Primary.Recoil          = 3
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 8
SWEP.Primary.ClipMax         = 24
SWEP.Primary.DefaultClip     = 8
SWEP.Primary.Cone            = 0.005
SWEP.Primary.Ammo            = "357"
SWEP.Primary.Sound           = Sound("waw_garand.Single")

SWEP.HeadshotMultiplier    = 1.4

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_m1garand.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_m1garand.mdl"

SWEP.IronSightsPos         = Vector(-5.02, -2, 0)
SWEP.IronSightsAng         = Vector(2.65, -0.5, -1)

-- WAW Notes:
-- 444 rpm, 3.4 tac, 45-35 dmg, 1500m to 2000m

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

-- Do empty reload on clip == 0
function SWEP:Reload()
    if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
    if self:Clip1() == 0 then
        self:DefaultReload(ACT_VM_RELOAD_EMPTY)
    else
        self:DefaultReload(self.ReloadAnim)
    end
    self:SetIronsights(false)
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
            pos = pos + ang:Forward() * 1 + ang:Right() * 0.6 + ang:Up() * 0.5  -- Adjust offsets
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

function SWEP:Deploy()
    self:SetIronsights(false)
    if self:Clip1() == 0 then
        self:SendWeaponAnim(ACT_VM_DRAW_EMPTY)
    end
    return true
end