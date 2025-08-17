local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_fmg"
UPGRADE.class = "weapon_ttt_waw_mosin"
UPGRADE.name = "Mosin-NaGenerator"
UPGRADE.desc = "Gifts them an Mosin-Nagant. Reduced bodyshot damage"

function UPGRADE:Apply(SWEP)

    SWEP.DropOffRanges = {
        [0]    = 25,
        [1240] = 35
    }

    SWEP.HeadshotMultiplier = 4

    function FmgTarget(att, path, dmginfo)
        local ent = path.Entity
        if not IsValid(ent) then return end
     
        if SERVER then
            if ent:IsPlayer() and (not GAMEMODE:AllowPVP()) then return end
            if ( IsValid(ent) and ent:IsPlayer() ) then
                SWEP:StripPrimary(ent)
                ent:Give( "weapon_ttt_waw_mosin" )
                local wep = ent:GetActiveWeapon()
                if not IsValid(wep) then return end
                wep.AllowDrop = true
                if IsValid(ent) then 
                    ent:ConCommand("+attack")
                    ent:ConCommand("-attack")
                end
            end
        end
    end

    function SWEP:StripPrimary(ply)
        for _, v in ipairs( ply:GetWeapons() ) do -- get all the weapons the player has and loop through them
            if v.Kind == WEAPON_HEAVY then
                ply:DropNamedWeapon(v:GetClass())
                return
            end
        end
    end

    function SWEP:ShootBullet( dmg, recoil, numbul, cone )

        self:SendWeaponAnim(self.PrimaryAnim)
   
        self:GetOwner():MuzzleFlash()
        self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
   
        local sights = self:GetIronsights()
    
        numbul = numbul or 1
        cone   = cone   or 0.01
    
        local function bulletCallback(attacker, tr, dmginfo)
            if not IsValid(attacker) then return end

            if not IsValid(tr.Entity) then return end

            FmgTarget(att, tr, dmginfo)

            if self.DropOffRanges then
                local dist = tr.Entity:GetPos():Distance(attacker:GetPos())
                local highest = 0
                for d, dmg in pairs(self.DropOffRanges) do
                    if d <= dist and d >= highest then
                        highest = d
                    end
                end
                dmginfo:SetDamage(self.DropOffRanges[highest] * self.DamageScale:GetFloat())
            end
        end
    
        local bullet = {}
        bullet.Num    = numbul
        bullet.Src    = self:GetOwner():GetShootPos()
        bullet.Dir    = self:GetOwner():GetAimVector()
        bullet.Spread = Vector( cone, cone, 0 )
        bullet.Tracer = 1
        bullet.TracerName = self.Tracer or "Tracer"
        bullet.Force  = 10
        bullet.Damage = dmg
        bullet.Callback = bulletCallback
    
        self:GetOwner():FireBullets( bullet )
    
        -- Owner can die after firebullets
        if (not IsValid(self:GetOwner())) or self:GetOwner():IsNPC() or (not self:GetOwner():Alive()) then return end
    
        if ((game.SinglePlayer() and SERVER) or
            ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then
    
            -- reduce recoil if ironsighting
            recoil = sights and (recoil * 0.6) or recoil
    
            local eyeang = self:GetOwner():EyeAngles()
            eyeang.pitch = eyeang.pitch - recoil
            self:GetOwner():SetEyeAngles( eyeang )
        end
    end
end

TTTPAP:Register(UPGRADE)