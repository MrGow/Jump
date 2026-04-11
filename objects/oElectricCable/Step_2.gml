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
// Start the same death flow style as your normal lethal hazards
// ----------------------------------------------------
with (p)
{
    if (state == "dead") exit;

    // enter death state
    state = "dead";

    hsp = 0;
    vsp = 0;

    if (variable_instance_exists(id, "death_fall")) death_fall = false;

    if (variable_instance_exists(id, "jump_charging"))         jump_charging = false;
    if (variable_instance_exists(id, "jump_charge"))           jump_charge = 0;
    if (variable_instance_exists(id, "jump_charge_level"))     jump_charge_level = 0;
    if (variable_instance_exists(id, "charge_grace"))          charge_grace = 0;
    if (variable_instance_exists(id, "support_grace"))         support_grace = 0;
    if (variable_instance_exists(id, "charge_start_lock"))     charge_start_lock = 0;
    if (variable_instance_exists(id, "ground_stick"))          ground_stick = 0;
    if (variable_instance_exists(id, "ground_frames"))         ground_frames = 0;
    if (variable_instance_exists(id, "bounce_pending"))        bounce_pending = false;
    if (variable_instance_exists(id, "bounce_timer"))          bounce_timer = 0;
    if (variable_instance_exists(id, "support_stable_frames")) support_stable_frames = 0;
    if (variable_instance_exists(id, "edge_charge_fail"))      edge_charge_fail = 0;
    if (variable_instance_exists(id, "prev_on_ground"))        prev_on_ground = false;

    var sprDeath = asset_get_index("spriteBotDeath");
    if (sprDeath != -1) {
        sprite_index = sprDeath;
        image_index  = 0;
        image_speed  = 0.60;
        image_xscale = facing;
    }

    if (!variable_global_exists("scrap_total")) global.scrap_total = 0;
    if (!variable_global_exists("scrap_run"))   global.scrap_run   = 0;

    global.scrap_total += global.scrap_run;
    global.scrap_run = 0;

    global.game_phase = "death_menu";

    if (!instance_exists(oDeathMenu))
    {
        var layer_name = layer_exists("GUI") ? "GUI" : "Instances";
        instance_create_layer(x, y, layer_name, oDeathMenu);
    }

    electric_hit_lock = other.player_hit_lock_frames;
}