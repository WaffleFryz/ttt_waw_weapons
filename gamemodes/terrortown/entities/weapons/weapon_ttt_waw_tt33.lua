AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Tokarev TT-33"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "materials/entities/robotnik_waw_tok"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL

SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Damage        = 25
SWEP.Primary.Delay         = 0.125
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 8
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "waw_tokarev.Fire" )

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/v_waw_tokarevtt33.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_tokarev.mdl"

SWEP.IronSightsPos         = Vector(-3.2, -4, 3.799)
SWEP.IronSightsAng         = Vector(0, 0, 0)

function SWEP:GetViewModelPosition( pos, ang )
    local offset = Vector(3, 17, -1)
    pos = pos + offset.x * ang:Right()
    pos = pos + offset.y * ang:Forward()
    pos = pos + offset.z * ang:Up()
    return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

-- function SWEP:DryFire(setnext)
--     if CLIENT and LocalPlayer() == self:GetOwner() then
--         self:SendWeaponAnim(ACT_VM_DRYFIRE)
--      end
--     self.BaseClass.DryFire(self, setnext)
-- end

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()
    
    if IsValid(owner) then
        local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))

        if pos and ang then
            pos = pos + ang:Forward() * 1.3 + ang:Right() * 0.7 + ang:Up() * 1  -- Adjust offsets
            ang:RotateAroundAxis(ang:Right(), -10)
            ang:RotateAroundAxis(ang:Up(), -13)
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