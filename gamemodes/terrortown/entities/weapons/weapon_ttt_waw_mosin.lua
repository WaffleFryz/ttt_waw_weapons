AddCSLuaFile()

if CLIENT then
    SWEP.PrintName            = "Mosin-Nagant"
    SWEP.Slot                 = 2
 
    SWEP.DrawCrosshair        = false
    SWEP.ViewModelFlip        = false
    SWEP.ViewModelFOV         = 54
end

SWEP.HoldType                = "ar2"

SWEP.Base                    = "weapon_wawbase"
SWEP.Kind                    = WEAPON_HEAVY

SWEP.Primary.Delay           = 1.4
SWEP.Primary.Damage          = 70
SWEP.Primary.Recoil          = 7
SWEP.Primary.Automatic       = true
SWEP.Primary.ClipSize        = 5
SWEP.Primary.ClipMax         = 15
SWEP.Primary.DefaultClip     = 5
SWEP.Primary.Cone            = 0.005
SWEP.Primary.Ammo            = "357"
SWEP.Primary.Sound           = Sound("waw_mosin.Sniper")

SWEP.Secondary.Sound       = Sound("Default.Zoom")

SWEP.HeadshotMultiplier    = 2

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.UseHands			      = true
SWEP.ViewModel             = "models/weapons/v_waw_mosin_scoped.mdl"
SWEP.WorldModel            = "models/weapons/w_waw_mosin_irons.mdl"

SWEP.WorldHandBoneOffset   = Vector(-1, 0.6, 0.43)
SWEP.WorldHandBoneAngles   = Vector(-10, -5, 180)
SWEP.VOffset               = Vector(1, 9, -3)

SWEP.IronSightsPos         = Vector( 5, -15, -2 )
SWEP.IronSightsAng         = Vector( 2.6, 1.37, 3.5 )
SWEP.ZoomFOV               = 20
SWEP.ZoomTime              = 0.4

SWEP.DropOffRanges = {
   [0]    = 50,
   [1240] = 70,
   [2480] = 9999
}

SWEP.HitgroupMultipliers = {
   [HitgroupToFlags(HITGROUP_CHEST, HITGROUP_LEFTARM, HITGROUP_RIGHTARM)] = 1.5,
   [HitgroupToFlags(HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG)] = 0.85
}

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Reloading")
    self:NetworkVar("Float", 0, "ReloadTimer")
 
    return self.BaseClass.SetupDataTables(self)
end

 -- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos or self:GetReloadTimer() > CurTime() then return end
    if self:GetNextSecondaryFire() > CurTime() then return end
 
    local bIronsights = not self:GetIronsights()
 
    self:SetIronsights( bIronsights )
 
    self:SetZoom(bIronsights)
    if (CLIENT) then
       self:EmitSound(self.Secondary.Sound)
    end
 
    self:SetNextSecondaryFire( CurTime() + 0.3)
end
 
function SWEP:Reload()
    if self:GetReloading() then return end
    if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount( self.Primary.Ammo ) > 0 then
       if self:StartReload() then
          return
       end
    end
end

function SWEP:StartReload()
    if self:GetReloading() then
       return false
    end
 
    self:SetIronsights( false )
    self:SetZoom( false )
 
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
    local ply = self:GetOwner()
 
    if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then
       return false
    end
 
    local wep = self
 
    if wep:Clip1() >= self.Primary.ClipSize then
       return false
    end
 
    wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
 
    self:SetReloadTimer(CurTime() + wep:SequenceDuration())
 
    self:SetReloading(true)
 
    return true
 end

function SWEP:PerformReload()
    local ply = self:GetOwner()
 
    -- prevent normal shooting in between reloads
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
 
    if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
 
    if self:Clip1() >= self.Primary.ClipSize then return end
 
    self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
    self:SetClip1( self:Clip1() + 1 )
 
    self:SendWeaponAnim(ACT_VM_RELOAD)
 
    self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:FinishReload()
    self:SetReloading(false)
    self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
 
    self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

function SWEP:CanPrimaryAttack()
   if self:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
    self.BaseClass.Think(self)
    if self:GetReloading() then
       if self:GetOwner():KeyDown(IN_ATTACK) or self:GetOwner():KeyDown(IN_ATTACK2) then
          self:FinishReload()
          return
       end
 
       if self:GetReloadTimer() <= CurTime() then
 
          if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
             self:FinishReload()
          elseif self:Clip1() < self.Primary.ClipSize then
             self:PerformReload()
          else
             self:FinishReload()
          end
          return
       end
    end
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
 end

function SWEP:Deploy()
    self:SetReloading(false)
    self:SetReloadTimer(0)
    return self.BaseClass.Deploy(self)
 end

function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
   local scope_mat = Material("scope/mosinscope2.png","unlitgeneric")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         -- scope
         surface.SetMaterial(scope_mat)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end
 
	function SWEP:AdjustMouseSensitivity()
       return (self:GetIronsights() and 0.2) or nil
    end
end