local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_reaper"
UPGRADE.class = "weapon_ttt_waw_ppsh"
UPGRADE.name = "The Reaper"
UPGRADE.desc = "Fuller auto"
UPGRADE.ammoMult = 2

function UPGRADE:Apply(SWEP)
	SWEP.Primary.Delay = 0.038
end

TTTPAP:Register(UPGRADE)