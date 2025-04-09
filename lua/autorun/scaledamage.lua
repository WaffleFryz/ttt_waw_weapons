function HitgroupToFlags( ... )
    local flags = 0
    for _, hitgroup in ipairs({ ... }) do
        flags = flags + bit.lshift(1, hitgroup)
    end
    return flags
end

local tttReducedDamage = HitgroupToFlags(HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG, HITGROUP_GEAR) --taken from ttt's player.lua

-- hook.Add("EntityTakeDamage", "SetDamageWawGuns", function(ent, dmginfo)
--     local att = dmginfo:GetAttacker()
--     if not IsValid(att) or not IsValid(ent) then return end
--     local infl = att:GetActiveWeapon()

--     if infl.DropOffRanges then
--         local dist = ent:GetPos():Distance(dmginfo:GetAttacker():GetPos())
--         local highest = 0
--         print(dist)
--         for d, dmg in pairs(infl.DropOffRanges) do
--             if d <= dist and d >= highest then
--                 highest = d
--             end
--         end
--         dmginfo:SetDamage(infl.DropOffRanges[highest])
--     end
-- end)

hook.Add("ScalePlayerDamage", "ScaleDamageWawGuns", function(ply, hitgroup, dmginfo)
    local att = dmginfo:GetAttacker()
    if not IsValid(ply) or not IsValid(att) then return end
    local infl = att:GetActiveWeapon()
    if not IsValid(infl) then return end

    if infl.HitgroupMultipliers then
        local multiplier = 1
        for flags, mult in pairs(infl.HitgroupMultipliers) do
            if type(flags) == "number" and bit.band(flags, bit.lshift(1, hitgroup)) ~= 0 then
                multiplier = mult
                break
            end
        end
        if bit.band(tttReducedDamage, bit.lshift(1,hitgroup)) ~= 0 then
            dmginfo:ScaleDamage(1 / 0.55) -- taken from player.lua again
        end
        dmginfo:ScaleDamage(multiplier)
    end
end)