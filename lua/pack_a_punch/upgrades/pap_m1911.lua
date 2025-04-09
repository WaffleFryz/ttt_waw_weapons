local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_c3k"
UPGRADE.class = "weapon_ttt_waw_m1911"
UPGRADE.name = "C-3000 b1at-ch35"
UPGRADE.desc = "Fires grenades. Reduced firerate"

function UPGRADE:Apply(SWEP)

    SWEP.Primary.Delay = 0.6

    function SWEP:PrimaryAttack(worldsnd)

        self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
        self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
     
        if not self:CanPrimaryAttack() then return end
     
        self:SendWeaponAnim(self.PrimaryAnim)
     
        self.Owner:MuzzleFlash()
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
     
        if not worldsnd then
           self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
        elseif SERVER then
           sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
        end
     
        if SERVER then
           local ply = self.Owner
           if not IsValid(ply) then return end
     
           local ang = ply:EyeAngles()
     
           -- don't even know what this bit is for, but SDK has it
           -- probably to make it throw upward a bit
           if ang.p < 90 then
              ang.p = -10 + ang.p * ((90 + 10) / 90)
           else
              ang.p = 360 - ang.p
              ang.p = -10 + ang.p * -((90 + 10) / 90)
           end
     
           local vel = math.min(800, (90 - ang.p) * 7)
     
           local vfw = ang:Forward()
           local vrt = ang:Right()
           --      local vup = ang:Up()
     
           local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
           src = src + (vfw * 8) + (vrt * 10)
     
           local thr = vfw * vel + ply:GetVelocity()
     
           self:CreateGrenade(src, Angle(0,0,0), thr, Vector(600, math.random(-1200, 1200), 0), ply)
        end
     
        self:TakePrimaryAmmo( 1 )
     
        local owner = self.Owner
        if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end
     
        owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
     end

     function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
        local gren = ents.Create("ent_waw_grenade")
        if not IsValid(gren) then return end
     
        gren:SetPos(src)
        gren:SetAngles(ang)
     
        --   gren:SetVelocity(vel)
        gren:SetOwner(ply)
        gren:SetThrower(ply)
     
        gren:SetGravity(0.4)
        gren:SetFriction(0.2)
        gren:SetElasticity(0.45)
     
        gren:Spawn()
     
        gren:PhysWake()
     
        local phys = gren:GetPhysicsObject()
        if IsValid(phys) then
           phys:SetVelocity(vel)
           phys:AddAngleVelocity(angimp)
        end
     
        -- This has to happen AFTER Spawn() calls gren's Initialize()
        -- gren:SetDetonateExact(CurTime() + self.detonate_timer)
     
        return gren
     end
end

TTTPAP:Register(UPGRADE)