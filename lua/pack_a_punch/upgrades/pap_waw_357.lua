local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_big_iron"
UPGRADE.class = "weapon_ttt_waw_357"
UPGRADE.name = ".357 Plus 1 K1L-u"
UPGRADE.desc = "Uncapped firerate"

function UPGRADE:Apply(SWEP)
    SWEP.Primary.Automatic     = false
    SWEP.Primary.Delay         = 0.05
end

TTTPAP:Register(UPGRADE)