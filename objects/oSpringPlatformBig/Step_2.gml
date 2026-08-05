/// oSpringPlatformBig — End Step
/// Forces the selected horizontal direction and launches
/// from the lowered oblique top surface.
/// Includes restrained heavy controller rumble.

if (!enabled)
{
    exit;
}

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
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}


// ----------------------------------------------------
// Per-player retrigger lock
// ----------------------------------------------------

if (!variable_instance_exists(p, "spring_retrigger_lock"))
{
    p.spring_retrigger_lock = 0;
}

if (p.spring_retrigger_lock > 0)
{
    p.spring_retrigger_lock--;
    exit;
}


// ----------------------------------------------------
// Lowered spring top surface
// ----------------------------------------------------

var spring_surf_y =
    bbox_top +
    surface_y_offset;

var surface_left =
    bbox_left +
    top_inset +
    surface_x_offset;

var surface_right =
    bbox_right -
    top_inset +
    surface_x_offset;

if (surface_right < surface_left)
{
    var surface_middle =
        (
            bbox_left +
            bbox_right
        )
        * 0.5 +
        surface_x_offset;

    surface_left  = surface_middle;
    surface_right = surface_middle;
}


// ----------------------------------------------------
// Horizontal overlap requirement
// ----------------------------------------------------

var overlap_left =
    max(
        p.bbox_left,
        surface_left
    );

var overlap_right =
    min(
        p.bbox_right,
        surface_right
    );

var overlap_width =
    overlap_right -
    overlap_left;

if (overlap_width < min_overlap_px)
{
    exit;
}


// ----------------------------------------------------
// Previous/current player feet
// ----------------------------------------------------

var feet_now =
    p.bbox_bottom;

var feet_previous;

if (variable_instance_exists(p, "crusher_prev_feet_y"))
{
    feet_previous =
        p.crusher_prev_feet_y;
}
else
{
    var fallback_vsp =
        variable_instance_exists(p, "vsp")
        ? p.vsp
        : 0;

    feet_previous =
        feet_now -
        fallback_vsp;
}

var previous_vsp = 0;

if (variable_instance_exists(p, "crusher_prev_vsp"))
{
    previous_vsp =
        p.crusher_prev_vsp;
}
else if (variable_instance_exists(p, "vsp"))
{
    previous_vsp =
        p.vsp;
}


// ----------------------------------------------------
// Landing tests
// ----------------------------------------------------

var standing_on_this =
    variable_instance_exists(p, "standing_platform") &&
    p.standing_platform == id;

var crossed_top =
    feet_previous <= spring_surf_y &&
    feet_now >= spring_surf_y - 1;

var near_top =
    feet_now >= spring_surf_y - 4 &&
    feet_now <= spring_surf_y + 5 &&
    (
        previous_vsp >= 0 ||
        p.vsp >= 0
    );

var blocked_down_on_top =
    previous_vsp > 0 &&
    variable_instance_exists(p, "vsp") &&
    p.vsp == 0 &&
    feet_now >= spring_surf_y - 4 &&
    feet_now <= spring_surf_y + 5;

if (
    !standing_on_this &&
    !crossed_top &&
    !near_top &&
    !blocked_down_on_top
)
{
    exit;
}


// ----------------------------------------------------
// Reject genuine upward movement
// ----------------------------------------------------

if (
    previous_vsp < 0 &&
    p.vsp < 0
)
{
    exit;
}


// ----------------------------------------------------
// Resolve forced horizontal direction
// ----------------------------------------------------

var direction_text =
    string_lower(
        string(spring_push_direction)
    );

var forced_direction = 1;

if (
    direction_text == "left" ||
    direction_text == "l" ||
    direction_text == "-1"
)
{
    forced_direction = -1;
}


// ----------------------------------------------------
// Convert push level 1–10 into horizontal speed
// ----------------------------------------------------

var push_level =
    clamp(
        real(spring_push_power),
        1,
        10
    );

var push_fraction =
    (push_level - 1) / 9;

var horizontal_speed =
    lerp(
        spring_push_speed_min,
        spring_push_speed_max,
        push_fraction
    );

launch_h =
    horizontal_speed *
    forced_direction;

launch_v =
    -spring_power;

launch_direction =
    forced_direction;


// ----------------------------------------------------
// Bounce sound
// ----------------------------------------------------

scr_play_sfx(
    snd_bounce_small,
    bounce_sfx_gain,
    random_range(
        0.97,
        1.03
    )
);


// ====================================================
// CONTROLLER RUMBLE
//
// Stronger and heavier than the normal spring, but
// deliberately below major hazard/death strengths.
// ====================================================

var spring_rumble_low  = 0.26;
var spring_rumble_high = 0.10;
var spring_rumble_time = 5;

var bounce_size_text =
    string_lower(
        string(bounce_size)
    );

if (bounce_size_text == "small")
{
    spring_rumble_low  = 0.21;
    spring_rumble_high = 0.08;
    spring_rumble_time = 4;
}
else if (bounce_size_text == "large")
{
    spring_rumble_low  = 0.32;
    spring_rumble_high = 0.13;
    spring_rumble_time = 6;
}

scr_rumble_play(
    spring_rumble_low,
    spring_rumble_high,
    spring_rumble_time,
    false
);


// ----------------------------------------------------
// Launch player
// ----------------------------------------------------

with (p)
{
    var snap_difference =
        (
            other.bbox_top +
            other.surface_y_offset
        )
        -
        bbox_bottom;

    y += snap_difference;


    if (variable_instance_exists(id, "jump_charging"))
    {
        jump_charging = false;
    }

    if (variable_instance_exists(id, "jump_charge"))
    {
        jump_charge = 0;
    }

    if (variable_instance_exists(id, "jump_charge_level"))
    {
        jump_charge_level = 0;
    }

    if (variable_instance_exists(id, "jump_charge_sfx_last"))
    {
        jump_charge_sfx_last = 0;
    }

    if (variable_instance_exists(id, "charge_grace"))
    {
        charge_grace = 0;
    }

    if (variable_instance_exists(id, "support_grace"))
    {
        support_grace = 0;
    }

    if (variable_instance_exists(id, "charge_start_lock"))
    {
        charge_start_lock = 0;
    }

    if (variable_instance_exists(id, "support_stable_frames"))
    {
        support_stable_frames = 0;
    }

    if (variable_instance_exists(id, "edge_charge_fail"))
    {
        edge_charge_fail = 0;
    }

    if (variable_instance_exists(id, "bounce_pending"))
    {
        bounce_pending = false;
    }

    if (variable_instance_exists(id, "bounce_timer"))
    {
        bounce_timer = 0;
    }

    if (variable_instance_exists(id, "bounce_v"))
    {
        bounce_v = 0;
    }

    if (variable_instance_exists(id, "prev_on_ground"))
    {
        prev_on_ground = false;
    }

    if (variable_instance_exists(id, "coyote_timer"))
    {
        coyote_timer = 0;
    }

    if (variable_instance_exists(id, "standing_platform"))
    {
        standing_platform = noone;
    }

    if (variable_instance_exists(id, "standing_platform_xoff"))
    {
        standing_platform_xoff = 0;
    }


    hsp = other.launch_h;
    vsp = other.launch_v;

    state  = "jumping";
    facing = other.launch_direction;

    spring_retrigger_lock =
        other.player_retrigger_lock_frames;
}


// ----------------------------------------------------
// Press animation
// ----------------------------------------------------

pressed_timer =
    pressed_frames;