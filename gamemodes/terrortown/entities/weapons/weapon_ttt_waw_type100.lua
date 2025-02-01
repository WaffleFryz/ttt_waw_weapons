AddCSLuaFile()

if CLIENT then
    SWEP.PrintName          = "Type 100"
    SWEP.Slot               = 2
 
    SWEP.ViewModelFlip      = false
    SWEP.ViewModelFOV       = 54
    SWEP.IconLetter         = "w"
end

 SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_tttbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 0.08
SWEP.Primary.Damage          = 20
SWEP.Primary.Recoil          = 1.5
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 30
SWEP.Primary.ClipMax         = 60
SWEP.Primary.DefaultClip     = 30
SWEP.Primary.Cone            = 0.03
SWEP.Primary.Ammo            = "SMG1"
SWEP.Primary.Sound           = Sound("waw_type100_new.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.UseHands			   = true
SWEP.ViewModel             = "models/weapons/v_waw_type100_new.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_type100_new.mdl"

SWEP.IronSightsPos         = Vector(-2.25, 0, 2.2)
SWEP.IronSightsAng         = Vector(2.599, -0.2, 3)

SWEP.HeadshotMultiplier = 1.4

function SWEP:GetViewModelPosition( pos, ang )
    local offset = Vector(-2, 12, -1)
    pos = pos + offset.x * ang:Right()
    pos = pos + offset.y * ang:Forward()
    pos = pos + offset.z * ang:Up()
    return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
    local att = dmginfo:GetAttacker()
    if not IsValid(att) then return 2 end
 
    local dist = victim:GetPos():Distance(att:GetPos())
    local d = math.max(0, dist - 150)
 
    -- decay from 3.2 to 1.7
    return 1.7 + math.max(0, (1.5 - 0.002 * (d ^ 1.25)))
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