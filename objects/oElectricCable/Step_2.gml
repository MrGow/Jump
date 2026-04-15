/// oElectricCable — End Step
/// Kill player if they overlap the electric plume.

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

// Player-side short lock so multiple cables / same cable don't instantly re-fire
if (!variable_instance_exists(p, "electric_hit_lock")) p.electric_hit_lock = 0;
if (p.electric_hit_lock > 0) {
    p.electric_hit_lock--;
    exit;
}

if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// ----------------------------------------------------
// Build hurt rectangle based on orientation
// ----------------------------------------------------
var l, r, t, b;

var hl = hurt_left   + hurt_inset;
var hr = hurt_right  - hurt_inset;
var ht = hurt_top    + hurt_inset;
var hb = hurt_bottom - hurt_inset;

var ang = ((round(image_angle / 90) * 90) mod 360 + 360) mod 360;

switch (ang)
{
    case 0:
        l = x + hl; r = x + hr; t = y + ht; b = y + hb;
        break;

    case 90:
        l = x - hb; r = x - ht; t = y + hl; b = y + hr;
        break;

    case 180:
        l = x - hr; r = x - hl; t = y - hb; b = y - ht;
        break;

    case 270:
        l = x + ht; r = x + hb; t = y - hr; b = y - hl;
        break;

    default:
        l = x + hl; r = x + hr; t = y + ht; b = y + hb;
        break;
}

if (l > r) { var _tmp = l; l = r; r = _tmp; }
if (t > b) { var _tmp2 = t; t = b; b = _tmp2; }

// ----------------------------------------------------
// Check overlap with player bbox
// ----------------------------------------------------
var hit =
    (p.bbox_right  > l) &&
    (p.bbox_left   < r) &&
    (p.bbox_bottom > t) &&
    (p.bbox_top    < b);

if (!hit) exit;

// ----------------------------------------------------
// Use the shared death flow so all death side-effects stay in sync
// ----------------------------------------------------
with (p)
{
    if (state == "dead") exit;
    scr_player_died();
    electric_hit_lock = other.player_hit_lock_frames;
}