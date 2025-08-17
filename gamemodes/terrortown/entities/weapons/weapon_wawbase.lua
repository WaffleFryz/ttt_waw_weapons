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
SWEP.ZoomFOV                = 0
SWEP.ZoomTime               = 0.25

SWEP.HeadshotMultiplier     = 1.4
SWEP.DamageScale            = GetConVar("ttt_waw_damage_scale")

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
    if self.recoilOffset then
        ang = ang + (self.recoilOffset / 2)
    end
    return self.BaseClass.BaseClass.GetViewModelPosition(self, pos, ang)
end

function SWEP:GetCurrentRecoil()
    if not self.recoilCycle then
        self.recoilCycle = 1
    end
    local startPadding = 0
    if self.recoilsStart then
        startPadding = #self.recoilsStart
    end
    if self.recoilsLoop and self.recoilCycle > startPadding then
        -- we have to -1 and +1 because 1-indexing of tables but 0-indexing of modulus
        return self.recoilsLoop[((self.recoilCycle - startPadding - 1) % #self.recoilsLoop) + 1]
    elseif self.recoilsStart then
        return self.recoilsStart[((self.recoilCycle - 1) % #self.recoilsLoop) + 1]
    end
    return angle_zero
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
            dmginfo:SetDamage(self.DropOffRanges[highest] * self.DamageScale:GetFloat())
        end
    end

    if not self.bulletList then
        self.bulletList = {angle_zero}
    end

    self.recoilOffset = (self.recoilOffset or angle_zero)
    
    for _, angle in ipairs(self.bulletList) do
        local bullet = {}
        bullet.Num    = 1
        bullet.Src    = self:GetOwner():GetShootPos()
        bullet.Dir    = self:GetOwner():GetAimVector()
        if self.recoilOffset then
            local bulletAngle = bullet.Dir:Angle()
            bulletAngle:RotateAroundAxis(bulletAngle:Up(), self.recoilOffset.yaw + angle.yaw)
            bulletAngle:RotateAroundAxis(bulletAngle:Right(), self.recoilOffset.pitch + angle.pitch)
            bullet.Dir = bulletAngle:Forward()
        end
        bullet.Spread = Vector( cone, cone, 0 )
        bullet.Tracer = 4
        bullet.TracerName = self.Tracer or "Tracer"
        bullet.Force  = 10
        bullet.Damage = dmg
        bullet.Callback = self.bulletCallback or bulletCallback
    
        self:GetOwner():FireBullets( bullet )
    end

    
    self.recoilOffset = (self.recoilOffset or angle_zero) + self:GetCurrentRecoil()
    self.recoilCycle = self.recoilCycle + 1
 
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

function SWEP:SetZoom(state)
    if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
       if state then
          self:GetOwner():SetFOV(self.ZoomFOV, self.ZoomTime)
       else
          self:GetOwner():SetFOV(0, 0.2)
       end
    end
end

function SWEP:Reload()
    if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
    local hasEmptyReload = self:GetOwner():GetViewModel():SelectWeightedSequence(ACT_VM_RELOAD_EMPTY)
    if hasEmptyReload != -1 and self:Clip1() == 0 then
        self:DefaultReload(ACT_VM_RELOAD_EMPTY)
    else
        self:DefaultReload(self.ReloadAnim)
    end
    self:SetIronsights(false)
    self:SetZoom(false)
    self.recoilOffset = angel_zero
    self.recoilCycle = 1
end

function SWEP:Think()
    if (self:GetNextPrimaryFire() < CurTime()) and self.recoilOffset then
        self.recoilOffset = LerpAngle(FrameTime() * (self.recoilResetSpeed or 5), self.recoilOffset, angle_zero)
    end
    if self.recoilOffset then
        if math.abs(self.recoilOffset.pitch) <= 0.25 and math.abs(self.recoilOffset.yaw) <= 0.25 then
            self.recoilCycle = 1
        end
    end
    self:CalcViewModel()
end

if CLIENT then
    local sights_opacity = CreateConVar("ttt_ironsights_crosshair_opacity", "0.8", FCVAR_ARCHIVE)
    local crosshair_brightness = CreateConVar("ttt_crosshair_brightness", "1.0", FCVAR_ARCHIVE)
    local crosshair_size = CreateConVar("ttt_crosshair_size", "1.0", FCVAR_ARCHIVE)
    local disable_crosshair = CreateConVar("ttt_disable_crosshair", "0", FCVAR_ARCHIVE)

    local enable_color_crosshair = CreateConVar("ttt_crosshair_color_enable", "0", FCVAR_ARCHIVE)
    local crosshair_color_r = CreateConVar("ttt_crosshair_color_r", "255", FCVAR_ARCHIVE)
    local crosshair_color_g = CreateConVar("ttt_crosshair_color_g", "255", FCVAR_ARCHIVE)
    local crosshair_color_b = CreateConVar("ttt_crosshair_color_b", "255", FCVAR_ARCHIVE)

    local crosshair_opacity = CreateConVar("ttt_crosshair_opacity", "1", FCVAR_ARCHIVE)
    local crosshair_thickness = CreateConVar("ttt_crosshair_thickness", "1", FCVAR_ARCHIVE)
    local crosshair_outlinethickness = CreateConVar("ttt_crosshair_outlinethickness", "0", FCVAR_ARCHIVE)

    local mat_antialias = GetConVar("mat_antialias")

    function SWEP:DrawHUD(static, gap)
        if self.HUDHelp then
            self:DrawHelp()
        end

        local client = LocalPlayer()
        if disable_crosshair:GetBool() or (not IsValid(client)) then return end

        local sights = (not self.NoSights) and self:GetIronsights()

        local aspect = ScrW() / ScrH()
        local vFOV = client:GetFOV()
        local hFOV = math.deg( 2 * math.atan( math.tan( math.rad(vFOV) / 2 ) * aspect ) )

        local x = math.floor(ScrW() / 2.0)
        local y = math.floor(ScrH() / 2.0)
        if self.recoilOffset then
            x = x - (self.recoilOffset.yaw / hFOV * ScrW() / 2)
            y = y - (self.recoilOffset.pitch / vFOV * ScrH() / 2)
        end
        local scale = math.max(0.2, 10 * self:GetPrimaryCone())

        if not static then
            local LastShootTime = self:LastShootTime()
            scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
        end

        local alpha = sights and sights_opacity:GetFloat() or crosshair_opacity:GetFloat()
        local bright = crosshair_brightness:GetFloat() or 1

        gap = gap or math.floor(20 * scale * (sights and 0.8 or 1))
        local length = math.floor(gap + (25 * crosshair_size:GetFloat()) * scale)

        local thickness = math.max(1, crosshair_thickness:GetInt())
        local rect = thickness > 1

        -- lines are drawn with antialiasing when MSAA is enabled which makes them 1 pixel longer
        local antialias = not rect and mat_antialias:GetInt() > 1

        local offset, odd_offset = 0, 0
        if rect then
            offset = math.floor(thickness / 2)

            -- ensures that high thickness levels don't cause the crosshair to overlap itself
            gap = gap + offset
            length = length + offset

            -- prevents the distance between crosshair prongs from becoming uneven with odd thickness levels
            odd_offset = thickness % 2
        elseif not antialias then
            odd_offset = 1
        end

      local outline = crosshair_outlinethickness:GetInt()
      if outline > 0 then
        surface.SetDrawColor(0, 0, 0, 255 * alpha)

        local out_thick = thickness + outline * 2
        local out_length = antialias and length + 1 or length
        out_length = out_length - gap + outline * 2

        local out_offset = offset + outline

        local out_topleft = length + outline
        local out_bottomright = gap - outline + odd_offset

        surface.DrawRect( x - out_topleft, y - out_offset, out_length, out_thick )
        surface.DrawRect( x + out_bottomright, y - out_offset, out_length, out_thick )
        surface.DrawRect( x - out_offset, y - out_topleft, out_thick, out_length )
        surface.DrawRect( x - out_offset, y + out_bottomright, out_thick, out_length )
      end

        if enable_color_crosshair:GetBool() then
            surface.SetDrawColor(crosshair_color_r:GetInt() * bright,
                                crosshair_color_g:GetInt() * bright,
                                crosshair_color_b:GetInt() * bright,
                                255 * alpha)
        elseif client.IsTraitor and client:IsTraitor() then -- somehow it seems this can be called before my player metatable additions have loaded
            surface.SetDrawColor(255 * bright,
                                50 * bright,
                                50 * bright,
                                255 * alpha)
        else
            surface.SetDrawColor(0,
                                255 * bright,
                                0,
                                255 * alpha)
        end

        if rect then
            local rect_length = length - gap
            gap = gap + odd_offset

            surface.DrawRect( x - length, y - offset, rect_length, thickness )
            surface.DrawRect( x + gap, y - offset, rect_length, thickness )
            surface.DrawRect( x - offset, y - length, thickness, rect_length )
            surface.DrawRect( x - offset, y + gap, thickness, rect_length )
        else
            surface.DrawLine( x - length, y, x - gap, y )
            surface.DrawLine( x + length, y, x + gap, y )
            surface.DrawLine( x, y - length, x, y - gap )
            surface.DrawLine( x, y + length, x, y + gap )
        end
    end
end