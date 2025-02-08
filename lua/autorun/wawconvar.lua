if GetConVar("ttt_waw_damage_scale") == nil then
    print("ttt_waw_damage_scale not set. Making convar")
    CreateConVar("ttt_waw_damage_scale", 1.0, FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED, "Damage scaling for the TTT WaW weapons")
end