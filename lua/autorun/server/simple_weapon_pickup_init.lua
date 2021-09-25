local pickupDistance = 110

function GetEyeWeapon(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ent then return end
    if not ent:IsWeapon() then return end
    return ent
end
    

hook.Add( "KeyPress", "SimpleWeaponPickup_HandleKeyPress", function( ply, key )
    if not ply:Alive() then return end
    if ply:GetObserverMode() ~= OBS_MODE_NONE then return end

    if key ~= IN_USE then return end
    local ent = GetEyeWeapon(ply)
    if not ent then return end

    if ply:EyePos():Distance(ent:GetPos()) > pickupDistance then return end

    for _, wep in pairs(ply:GetWeapons()) do
        if wep.Kind == ent.Kind then
            ply:DropWeapon(wep)
            break
        end
    end

    if hook.Run("PlayerCanPickupWeapon", ply, ent) == false then return end

    ply:PickupWeapon(ent)
    ply:SelectWeapon(ent:GetClass())
end )
