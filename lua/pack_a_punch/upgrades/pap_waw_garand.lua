local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_garand_grenade"
UPGRADE.class = "weapon_ttt_waw_garand"
UPGRADE.name = "M7 Grenade Launcher"
UPGRADE.desc = "Explosive shots. Reload after every shot"
UPGRADE.ammoMult = 1/8

function UPGRADE:Apply(SWEP)

   SWEP.DropOffRanges = {
      [0] = 1
   }

   SWEP.HeadshotMultiplier = 20

   function SWEP:ShootBullet( dmg, recoil, numbul, cone )

      self:SendWeaponAnim(self.PrimaryAnim)
   
      self:GetOwner():MuzzleFlash()
      self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
   
      local sights = self:GetIronsights()
   
      numbul = numbul or 1
      cone   = cone   or 0.01
  
      local function bulletCallback(attacker, tr, dmginfo)
         if not IsValid(attacker) then return end

         util.BlastDamage(self,attacker,tr.HitPos, 256, 25)
         local fx = EffectData()
         fx:SetOrigin(tr.HitPos)
         fx:SetNormal(tr.Normal)
         util.Effect("Explosion",fx)

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