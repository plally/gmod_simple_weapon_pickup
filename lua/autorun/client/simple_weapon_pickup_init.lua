surface.CreateFont( "CFC_WeaponPickupPrompt", {
    font = "Marlett",
    extended = false,
    size = 20,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = true,
    outline = true,
} )
local pickupDistance = 110

function GetEyeWeapon(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ent then return end
    if not ent:IsWeapon() then return end
    return ent
end
    
local function drawHalos()
    local ent = GetEyeWeapon(LocalPlayer())
    if not ent then return end

    if EyePos():Distance(ent:GetPos()) > pickupDistance then return end
    halo.Add( {ent}, Color( 143, 158, 255 ))
end
hook.Add( "PreDrawHalos", "SimpleWeaponPickup_DrawHalos", drawHalos )


local weaponTextMarkup = markup.Parse("<font=CFC_WeaponPickupPrompt><colour=255,0,0,255>[E]</colour> to pick up <colour=0,95,212,255>weapon_name</colour></font>")
local function doHUDPaint() 
    local ent = GetEyeWeapon(LocalPlayer())
    if not ent then return end

    if EyePos():Distance(ent:GetPos()) > pickupDistance then return end
    local printName = LANG.TryTranslation(ent:GetPrintName() or ent.PrintName or "...")
    
    surface.SetFont( "CFC_WeaponPickupPrompt" )
    local w, _ = surface.GetTextSize(printName)
    weaponTextMarkup.blocks[3].text = printName
    weaponTextMarkup.totalWidth = weaponTextMarkup.totalWidth + w - weaponTextMarkup.blocks[3].thisX 
    weaponTextMarkup.blocks[3].thisX = w
    
    weaponTextMarkup:Draw(ScrW()/2, ScrH()/2+50, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
hook.Add( "HUDPaint", "SimpleWeaponPickup_PaintHud", doHUDPaint)
