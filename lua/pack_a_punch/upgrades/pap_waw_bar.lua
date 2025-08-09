local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_widowmaker"
UPGRADE.class = "weapon_ttt_waw_bar"
UPGRADE.name = "BAR-pod"
UPGRADE.desc = "Shoot faster when crouched still"
UPGRADE.noSound = true

function UPGRADE:Apply(SWEP)
	function SWEP:Think()
		local ply = self:GetOwner()
		if ply:Crouching() then
			self.Primary.Delay = 0.16
		else
			self.Primary.Delay = 0.11
		end
	end
end

TTTPAP:Register(UPGRADE)