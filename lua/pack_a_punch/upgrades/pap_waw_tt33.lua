local UPGRADE = {}
UPGRADE.id = "weapon_ttt_waw_jokergun"
UPGRADE.class = "weapon_ttt_waw_tt33"
UPGRADE.name = "Tkachev"
UPGRADE.desc = "Faster firerate. Less range"
UPGRADE.ammoMult = 20/12

function UPGRADE:Apply(SWEP)
    SWEP.DropOffRanges = {
        [0]   = 40,
        [80]  = 35,
        [160] = 30,
        [240] = 25,
        [560] = 20
    }

    SWEP.recoilsStart = {
        Angle(2, 2.25, 0),
        Angle(3, 1.25, 0),
        Angle(3, 3.0, 0),
        Angle(0.75, -5.5, 0),
        Angle(0.5, -4.75, 0),
        Angle(1.5, 1.75, 0)
    }

    SWEP.recoilsLoop = {
        Angle(0.25, 1.5, 0),
        Angle(0.12, 1.5, 0),
        Angle(-0.25, 1.5, 0),
        Angle(-0.25, -1.5, 0),
        Angle(-0.12, -1.5, 0)
    }

    SWEP.Primary.Delay         = 0.08
end

TTTPAP:Register(UPGRADE)