local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_fan"
UPGRADE.class = "weapon_ttt_waw_db"
UPGRADE.name = "Force-A-Nature"
UPGRADE.desc = "Stronger knockback. No fall damage while equiped"
UPGRADE.noSound = true

function UPGRADE:Apply(SWEP)
    SWEP.Primary.Blowback      = 175 * 2.5
    SWEP.Secondary.Blowback    = 325 * 2.5

    -- local av,spos=attacker:GetAimVector(),attacker:GetShootPos()
    -- print(av.x,av.y,av.z)
    -- tr.Entity:SetVelocity(attacker:GetVelocity()+Vector(av.x,av.y,math.max(0.35,av.z))*500*1.3)

    SWEP.DB_PAP = true

    local function WawDbRemoveFallDamage(target, dmginfo)
        if not target:IsPlayer() then return end
        if target:GetActiveWeapon().DB_PAP == nil then return end
        if dmginfo:IsFallDamage() then 
            return true 
        end
    end

    hook.Add("EntityTakeDamage", "WawDbRemoveFallDamage", WawDbRemoveFallDamage)
end

TTTPAP:Register(UPGRADE)