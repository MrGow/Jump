/// oSmasher — End Step
/// Position-based crushing using the measured plate position.

if (scr_game_frozen()) exit;

if (!enabled) exit;
if (!active)  exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}

if (kill_only_when_falling)
{
    var pv =
        variable_instance_exists(p, "vsp")
        ? p.vsp
        : 0;

    if (pv < 0) exit;
}

// A retracting plate should not kill.
if (plate_direction < 0) exit;

// ----------------------------------------------------
// Horizontal overlap beneath the plate
// ----------------------------------------------------
var inset_x =
    variable_instance_exists(id, "crush_inset_x")
    ? crush_inset_x
    : 5;

var plate_left  = bbox_left  + inset_x;
var plate_right = bbox_right - inset_x;

if (plate_right < plate_left)
{
    var plate_mid = (bbox_left + bbox_right) * 0.5;

    plate_left  = plate_mid;
    plate_right = plate_mid;
}

var player_side_inset =
    variable_instance_exists(id, "crush_player_side_inset")
    ? crush_player_side_inset
    : 5;

var player_kill_left  = p.bbox_left  + player_side_inset;
var player_kill_right = p.bbox_right - player_side_inset;

if (player_kill_right < player_kill_left)
{
    var player_mid = (p.bbox_left + p.bbox_right) * 0.5;
    player_kill_left  = player_mid;
    player_kill_right = player_mid;
}

var horizontal_overlap =
    (player_kill_right > plate_left) &&
    (player_kill_left  < plate_right);

if (!horizontal_overlap) exit;

// ----------------------------------------------------
// Plate-to-player contact
// ----------------------------------------------------
var tolerance =
    variable_instance_exists(id, "crush_contact_tolerance")
    ? crush_contact_tolerance
    : 4;

var player_head   = p.bbox_top;
var player_bottom = p.bbox_bottom;

var plate_now  = plate_y_current;
var plate_prev = plate_y_previous;

// Crossed the player's head between measurements.
var crossed_head =
    (plate_prev < player_head - tolerance) &&
    (plate_now  >= player_head - tolerance);

// Currently touching the player.
// This handles the player collision system stopping them
// a few pixels beneath the solid plate.
var touching_head =
    (plate_now >= player_head - tolerance) &&
    (plate_now <= player_bottom + tolerance);

if (!(crossed_head || touching_head)) exit;

// ----------------------------------------------------
// Kill player
// ----------------------------------------------------
var sink =
    variable_instance_exists(id, "sink_px")
    ? sink_px
    : 6;

var lock_y = p.bbox_bottom + sink;

if (!smasher_player_hit_sfx_lock)
{
    scr_play_sfx(
        snd_smasher_floor_hit,
        smasher_floor_hit_gain,
        random_range(0.96, 1.02)
    );

    smasher_player_hit_sfx_lock = true;
}

with (p)
{
    if (script_exists(asset_get_index("scr_player_died")))
    {
        scr_player_died(lock_y);
    }
    else
    {
        state = "dead";
    }
}