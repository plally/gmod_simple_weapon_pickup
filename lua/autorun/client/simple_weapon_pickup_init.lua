surface.CreateFont( "CFC_WeaponPickupPrompt", {
    font = "Marlett",
    extended = false,
    size = 20,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = false,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
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
    if not LocalPlayer():Alive() then return end
    if LocalPlayer():GetObserverMode() ~= OBS_MODE_NONE then return end
    local ent = GetEyeWeapon(LocalPlayer())
    if not ent then return end

    if EyePos():Distance(ent:GetPos()) > pickupDistance then return end
    halo.Add( {ent}, Color( 143, 158, 255 ))
end
hook.Add( "PreDrawHalos", "SimpleWeaponPickup_DrawHalos", drawHalos )

local text = {
    {text="[E]", color=Color(255,0,0)},
    {text=" ",  color=Color(255,255,255)},
    {text="to pick up", color=Color(255,255,255)},
    {text=" ",  color=Color(255,255,255)},
    {text="weapon_name", color=Color(0,95,212)}
}

local function doHUDPaint() 
    if not LocalPlayer():Alive() then return end
    if LocalPlayer():GetObserverMode() ~= OBS_MODE_NONE then return end
    local ent = GetEyeWeapon(LocalPlayer())
    if not ent then return end

    if EyePos():Distance(ent:GetPos()) > pickupDistance then return end
    local printName = LANG.TryTranslation(ent:GetPrintName() or ent.PrintName or "...")

    surface.SetFont( "CFC_WeaponPickupPrompt" )
    local totalWidth = 0
    text[5].text = printName
    for  _, v in ipairs(text) do
        local width, height = surface.GetTextSize( v.text )
        v.width = width
        totalWidth = totalWidth + width
    end

    local y = ScrH()/2 +50
    local x = ScrW()/2 - totalWidth/2
    for  _, v in ipairs(text) do
        draw.SimpleText(v.text, "CFC_WeaponPickupPrompt", x+1, y+1, COLOR_BLACK, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(v.text, "CFC_WeaponPickupPrompt", x, y, v.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        x = x + v.width
    end
end

hook.Add( "HUDPaint", "SimpleWeaponPickup_PaintHud", doHUDPaint)
