/// oSmasher — End Step
///
/// Position-based crushing using the measured plate
/// position.

if (scr_game_frozen())
{
    exit;
}

if (!enabled)
{
    exit;
}

if (!active)
{
    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

var player =
    instance_find(
        oPlayer,
        0
    );

if (player == noone)
{
    exit;
}


// Do not retrigger an existing death.
if (
    variable_instance_exists(player, "state") &&
    player.state == "dead"
)
{
    exit;
}


// ====================================================
// OPTIONAL FALLING-PLAYER REQUIREMENT
// ====================================================

if (kill_only_when_falling)
{
    var player_vsp =
        variable_instance_exists(
            player,
            "vsp"
        )
        ? player.vsp
        : 0;

    if (player_vsp < 0)
    {
        exit;
    }
}


// A retracting plate should not kill.
if (plate_direction < 0)
{
    exit;
}


// ====================================================
// HORIZONTAL OVERLAP BENEATH PLATE
// ====================================================

var inset_x =
    variable_instance_exists(
        id,
        "crush_inset_x"
    )
    ? crush_inset_x
    : 5;

var plate_left =
    bbox_left +
    inset_x;

var plate_right =
    bbox_right -
    inset_x;


if (plate_right < plate_left)
{
    var plate_mid =
        (
            bbox_left +
            bbox_right
        )
        *
        0.5;

    plate_left = plate_mid;
    plate_right = plate_mid;
}


var player_side_inset =
    variable_instance_exists(
        id,
        "crush_player_side_inset"
    )
    ? crush_player_side_inset
    : 5;

var player_kill_left =
    player.bbox_left +
    player_side_inset;

var player_kill_right =
    player.bbox_right -
    player_side_inset;


if (player_kill_right < player_kill_left)
{
    var player_mid =
        (
            player.bbox_left +
            player.bbox_right
        )
        *
        0.5;

    player_kill_left = player_mid;
    player_kill_right = player_mid;
}


var horizontal_overlap =
    player_kill_right > plate_left &&
    player_kill_left < plate_right;

if (!horizontal_overlap)
{
    exit;
}


// ====================================================
// PLATE-TO-PLAYER CONTACT
// ====================================================

var tolerance =
    variable_instance_exists(
        id,
        "crush_contact_tolerance"
    )
    ? crush_contact_tolerance
    : 4;

var player_head =
    player.bbox_top;

var player_bottom =
    player.bbox_bottom;

var plate_now =
    plate_y_current;

var plate_prev =
    plate_y_previous;


// Crossed the player's head between measurements.
var crossed_head =
    plate_prev <
        player_head -
        tolerance
    &&
    plate_now >=
        player_head -
        tolerance;


// Currently touching the player.
//
// This handles the player's collision system stopping
// them a few pixels beneath the solid plate.
var touching_head =
    plate_now >=
        player_head -
        tolerance
    &&
    plate_now <=
        player_bottom +
        tolerance;


if (!(crossed_head || touching_head))
{
    exit;
}


// ====================================================
// PREPARE CRUSH DEATH
// ====================================================

var sink =
    variable_instance_exists(
        id,
        "sink_px"
    )
    ? sink_px
    : 6;


// scr_player_died() locks the player's bbox bottom to
// this point before applying spriteBotDeathCrush.
var lock_y =
    player.bbox_bottom +
    sink;


// Use central profile defaults unless this smasher or
// one of its children provides explicit overrides.
var death_shake_strength =
    variable_instance_exists(
        id,
        "smasher_death_shake_strength"
    )
    ? smasher_death_shake_strength
    : -1;

var death_shake_frames =
    variable_instance_exists(
        id,
        "smasher_death_shake_frames"
    )
    ? smasher_death_shake_frames
    : -1;

var death_type =
    variable_instance_exists(
        id,
        "smasher_death_type"
    )
    ? smasher_death_type
    : "crush";


var shake_strength_argument =
    death_shake_strength >= 0
    ? death_shake_strength
    : undefined;

var shake_frames_argument =
    death_shake_frames >= 0
    ? death_shake_frames
    : undefined;


// ====================================================
// MECHANICAL IMPACT LAYER
//
// This remains separate from CrushDeath1. It represents
// the machine plate physically striking the player.
// ====================================================

if (!smasher_player_hit_sfx_lock)
{
    if (snd_smasher_floor_hit != -1)
    {
        scr_play_sfx(
            snd_smasher_floor_hit,
            smasher_floor_hit_gain,
            random_range(0.96, 1.02)
        );
    }

    smasher_player_hit_sfx_lock =
        true;
}


// ====================================================
// KILL PLAYER WITH CRUSH PROFILE
// ====================================================

with (player)
{
    if (
        script_exists(
            asset_get_index("scr_player_died")
        )
    )
    {
        scr_player_died(
            lock_y,
            false,
            shake_strength_argument,
            shake_frames_argument,
            death_type
        );
    }
    else
    {
        state = "dead";
    }
}