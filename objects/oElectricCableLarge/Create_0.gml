/// oElectricCableLarge — Create

event_inherited();

var spr_large = asset_get_index("spriteHazardElectricCableLarge");
var mask_large = asset_get_index("spriteHazardElectricCableLargeMask");

if (spr_large != -1) sprite_index = spr_large;
if (mask_large != -1) mask_index = mask_large;
else mask_index = sprite_index;

enabled = true;
active  = true;

solid_body = false;
solid_only_when_active = false;

image_speed = 0.35;

// Snap to 90-degree angle
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

// Large local hurtbox for default angle 0
// angle 0 = floor cable, electricity goes upward
if (!variable_instance_exists(id, "hurt_left"))   hurt_left   = -10;
if (!variable_instance_exists(id, "hurt_right"))  hurt_right  =  10;
if (!variable_instance_exists(id, "hurt_top"))    hurt_top    = -112;
if (!variable_instance_exists(id, "hurt_bottom")) hurt_bottom = -4;

if (!variable_instance_exists(id, "hurt_inset")) hurt_inset = 1;

debug_draw = false;

player_hit_lock_frames = 6;

// Returns [l, t, r, b]
get_hurt_rect = function()
{
    var hl = hurt_left   + hurt_inset;
    var hr = hurt_right  - hurt_inset;
    var ht = hurt_top    + hurt_inset;
    var hb = hurt_bottom - hurt_inset;

    var ang = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

    var l, r, t, b;

    switch (ang)
    {
        case 0:
            l = x + hl;
            r = x + hr;
            t = y + ht;
            b = y + hb;
        break;

        case 90:
            l = x - hb;
            r = x - ht;
            t = y + hl;
            b = y + hr;
        break;

        case 180:
            l = x - hr;
            r = x - hl;
            t = y - hb;
            b = y - ht;
        break;

        case 270:
            l = x + ht;
            r = x + hb;
            t = y - hr;
            b = y - hl;
        break;

        default:
            l = x + hl;
            r = x + hr;
            t = y + ht;
            b = y + hb;
        break;
    }

    if (l > r) { var tmp = l; l = r; r = tmp; }
    if (t > b) { var tmp2 = t; t = b; b = tmp2; }

    return [l, t, r, b];
};