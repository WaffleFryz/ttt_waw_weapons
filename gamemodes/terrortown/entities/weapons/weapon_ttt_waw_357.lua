AddCSLuaFile()

SWEP.HoldType              = "revolver"

if CLIENT then
   SWEP.PrintName          = ".357 Magnum"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 65

   SWEP.Icon               = "materials/entities/robotnik_waw_mgm"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = 6.3
SWEP.Primary.Damage        = 40
SWEP.Primary.Delay         = 0.6
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 6
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 6
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound( "waw_magnum.Single" )

SWEP.HeadshotMultiplier    = 1.4

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_waw_magnum.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_magnum.mdl"

SWEP.IronSightsPos         = Vector(-3.391, -1.701, 3.15)
SWEP.IronSightsAng         = Vector(0, 0, 0)

function SWEP:GetViewModelPosition( pos, ang )
    local offset = Vector(0, 2, 0)
    pos = pos + offset.x * ang:Right()
    pos = pos + offset.y * ang:Forward()
    pos = pos + offset.z * ang:Up()
    return self.BaseClass.GetViewModelPosition(self, pos, ang)
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
        self:SetRenderOrigin(nil)
        self:SetRenderAngles(nil)
        self:DrawModel()
    end
end