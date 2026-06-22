/// oElectricCable — Create

event_inherited();

mask_index = spriteHazardElectricCableMask;

enabled = true;
active  = true;

solid_body = false;
solid_only_when_active = false;

sprite_index = spriteHazardElectricCable;
image_speed  = 0.35;

// Snap to 90-degree angle
image_angle = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

// Small electric cable loop SFX
snd_electric_small_loop = asset_get_index("SmallEelectricCable1");
electric_small_loop_instance = noone;
electric_small_loop_gain = 0.22;
electric_small_loop_pitch = 1.0;

electric_small_loop_inner_dist = 80;
electric_small_loop_outer_dist = 260;

// Local hurtbox for default angle 0
hurt_left   = -8;
hurt_right  =  8;
hurt_top    = -22;
hurt_bottom = -4;

hurt_inset = 1;

debug_draw = true;

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