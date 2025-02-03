AddCSLuaFile()

---- TTT SPECIAL EQUIPMENT FIELDS

-- This must be set to one of the WEAPON_ types in TTT weapons for weapon
-- carrying limits to work properly. See /gamemode/shared.lua for all possible
-- weapon categories.
SWEP.Kind = WEAPON_NONE

-- If CanBuy is a table that contains ROLE_TRAITOR and/or ROLE_DETECTIVE, those
-- players are allowed to purchase it and it will appear in their Equipment Menu
-- for that purpose. If CanBuy is nil this weapon cannot be bought.
--   Example: SWEP.CanBuy = { ROLE_TRAITOR }
-- (just setting to nil here to document its existence, don't make this buyable)
SWEP.CanBuy = nil

if CLIENT then
   -- If this is a buyable weapon (ie. CanBuy is not nil) EquipMenuData must be
   -- a table containing some information to show in the Equipment Menu. See
   -- default equipment weapons for real-world examples.
   SWEP.EquipMenuData = nil

   -- Example data:
   -- SWEP.EquipMenuData = {
   --
   ---- Type tells players if it's a weapon or item
   --     type = "Weapon",
   --
   ---- Desc is the description in the menu. Needs manual linebreaks (via \n).
   --     desc = "Text."
   -- };

   -- This sets the icon shown for the weapon in the DNA sampler, search window,
   -- equipment menu (if buyable), etc.
   SWEP.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess

   -- You can make your own weapon icon using the template in:
   --   /garrysmod/gamemodes/terrortown/template/

   -- Open one of TTT's icons with VTFEdit to see what kind of settings to use
   -- when exporting to VTF. Once you have a VTF and VMT, you can
   -- resource.AddFile("materials/vgui/...") them here. GIVE YOUR ICON A UNIQUE
   -- FILENAME, or it WILL be overwritten by other servers! Gmod does not check
   -- if the files are different, it only looks at the name. I recommend you
   -- create your own directory so that this does not happen,
   -- eg. /materials/vgui/ttt/mycoolserver/mygun.vmt
end

---- MISC TTT-SPECIFIC BEHAVIOUR CONFIGURATION

-- ALL weapons in TTT must have weapon_tttbase as their SWEP.Base. It provides
-- some functions that TTT expects, and you will get errors without them.
-- Of course this is weapon_tttbase itself, so I comment this out here.
--  SWEP.Base = "weapon_tttbase"

-- If true AND SWEP.Kind is not WEAPON_EQUIP, then this gun can be spawned as
-- random weapon by a ttt_random_weapon entity.
SWEP.AutoSpawnable = false

-- Set to true if weapon can be manually dropped by players (with Q)
SWEP.AllowDrop = true

-- Set to true if weapon kills silently (no death scream)
SWEP.IsSilent = false

-- If this weapon should be given to players upon spawning, set a table of the
-- roles this should happen for here
--  SWEP.InLoadoutFor = { ROLE_TRAITOR, ROLE_DETECTIVE, ROLE_INNOCENT }

-- DO NOT set SWEP.WeaponID. Only the standard TTT weapons can have it. Custom
-- SWEPs do not need it for anything.
--  SWEP.WeaponID = nil

---- YE OLDE SWEP STUFF

SWEP.Base = "weapon_tttbase"

SWEP.Category               = "TTT"
SWEP.Spawnable              = false
SWEP.WorldHandBoneOffset    = Vector(0,0,0)
SWEP.WorldHandBoneAngles    = Vector(0,0,0)
SWEP.VOffset                = Vector(0,0,0)

SWEP.HeadshotMultiplier    = 1.4

SWEP.HitgroupMultipliers = {
    [HitgroupToFlags(HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG)] = 0.85
}

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()
    
    if IsValid(owner) then
        local pos, ang = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_R_Hand"))
        local offset = self.WorldHandBoneOffset
        local angles = self.WorldHandBoneAngles

        if pos and ang then
            pos = pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z  -- Adjust offsets
            ang:RotateAroundAxis(ang:Right(), angles.x)
            ang:RotateAroundAxis(ang:Up(), angles.y)
            ang:RotateAroundAxis(ang:Forward(), angles.z)

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

function SWEP:GetViewModelPosition( pos, ang )
    local offset = self.VOffset
    pos = pos + offset.x * ang:Right()
    pos = pos + offset.y * ang:Forward()
    pos = pos + offset.z * ang:Up()
    return self.BaseClass.BaseClass.GetViewModelPosition(self, pos, ang)
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
    
        if self.DropOffRanges then
            local dist = tr.Entity:GetPos():Distance(attacker:GetPos())
            local highest = 0
            for d, dmg in pairs(self.DropOffRanges) do
                if d <= dist and d >= highest then
                    highest = d
                end
            end
            dmginfo:SetDamage(self.DropOffRanges[highest])
        end
    end
 
    local bullet = {}
    bullet.Num    = numbul
    bullet.Src    = self:GetOwner():GetShootPos()
    bullet.Dir    = self:GetOwner():GetAimVector()
    bullet.Spread = Vector( cone, cone, 0 )
    bullet.Tracer = 4
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