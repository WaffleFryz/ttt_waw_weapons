local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_widowmaker"
UPGRADE.class = "weapon_ttt_waw_bar"
UPGRADE.name = "BAR-pod"
UPGRADE.desc = "Shoot faster when Crouched STILL"
UPGRADE.ammoMult = 30/20
UPGRADE.noSound = true

function UPGRADE:Apply(SWEP)

	for _, angle in ipairs(SWEP.recoilsStart) do
		angle = angle / 2
	end
	for _, angle in ipairs(SWEP.recoilsLoop) do
		angle = angle / 2
	end

	local oldRecoil = SWEP.Primary.Recoil
	
	function SWEP:Think()
		local ply = self:GetOwner()
		if ply:Crouching() and ply:GetVelocity():LengthSqr() <= 4^2 then
			self.Primary.Delay = 0.11
			self.Primary.Recoil = oldRecoil * 0.5
		else
			self.Primary.Delay = 0.16
			self.Primary.Recoil = oldRecoil
		end
		SWEP.BaseClass.Think(SWEP)
	end
end

TTTPAP:Register(UPGRADE)