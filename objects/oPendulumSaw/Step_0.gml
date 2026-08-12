/// oPendulumSaw — Step


// ====================================================
// FREEZE / PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    active = false;
    exit;
}

active = true;


// ====================================================
// VALIDATE SETTINGS
// ====================================================

chain_length =
    max(
        8,
        chain_length
    );

swing_arc =
    clamp(
        swing_arc,
        0,
        89
    );

saw_hit_radius =
    max(
        1,
        saw_hit_radius
    );

rail_distance =
    max(
        0,
        rail_distance
    );


// ====================================================
// ADVANCE SWING
// ====================================================

swing_phase +=
    swing_phase_speed *
    swing_speed;


// Keep phase bounded.
if (swing_phase > pi * 2)
{
    swing_phase -=
        pi * 2;
}


// ====================================================
// ADVANCE OPTIONAL RAIL
// ====================================================

if (rail_enabled)
{
    rail_phase +=
        rail_phase_speed *
        rail_speed;

    if (rail_phase > pi * 2)
    {
        rail_phase -=
            pi * 2;
    }
}


// ====================================================
// ANCHOR POSITION
// ====================================================

anchor_y =
    origin_y;


if (rail_enabled)
{
    // rail_distance is total width,
    // so divide by 2 for left/right extent.
    anchor_x =
        origin_x +
        sin(rail_phase) *
        (rail_distance * 0.5);
}
else
{
    anchor_x =
        origin_x;
}


// ====================================================
// PENDULUM ANGLE
// ====================================================

swing_angle =
    sin(swing_phase) *
    swing_arc;


// Straight down in GameMaker = 270 degrees.
var pendulum_dir =
    270 +
    swing_angle;


// ====================================================
// SAW POSITION
// ====================================================

saw_x =
    anchor_x +
    lengthdir_x(
        chain_length,
        pendulum_dir
    );

saw_y =
    anchor_y +
    lengthdir_y(
        chain_length,
        pendulum_dir
    );


// ====================================================
// SAW ANIMATION
// ====================================================

if (saw_sprite != -1)
{
    var saw_frames =
        max(
            1,
            sprite_get_number(
                saw_sprite
            )
        );

    saw_image_index +=
        saw_anim_speed;

    if (saw_image_index >= saw_frames)
    {
        saw_image_index -=
            saw_frames;
    }
}


// ====================================================
// PLAYER COLLISION
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    exit;
}


if (
    variable_instance_exists(
        p,
        "state"
    )
    &&
    p.state == "dead"
)
{
    exit;
}


// ----------------------------------------------------
// Circle vs player rectangle.
//
// Clamp the saw centre to the player's bbox and check
// the distance to that closest point.
// ----------------------------------------------------

var closest_x =
    clamp(
        saw_x,
        p.bbox_left,
        p.bbox_right
    );

var closest_y =
    clamp(
        saw_y,
        p.bbox_top,
        p.bbox_bottom
    );


var hit_dist =
    point_distance(
        saw_x,
        saw_y,
        closest_x,
        closest_y
    );


if (hit_dist <= saw_hit_radius)
{
    with (p)
    {
        scr_player_died();
    }
}