/// oSpringPlatform — End Step
/// Launches the player vertically and forces the selected
/// horizontal direction.
/// Includes restrained controller rumble on activation.

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


// ----------------------------------------------------
// Do not trigger a dead player
// ----------------------------------------------------

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
// Spring top surface
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
// Player horizontal overlap
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
// Player previous/current feet
// ----------------------------------------------------

var feet_now =
    p.bbox_bottom;

var feet_prev;

if (variable_instance_exists(p, "crusher_prev_feet_y"))
{
    feet_prev =
        p.crusher_prev_feet_y;
}
else
{
    var fallback_vsp =
        variable_instance_exists(p, "vsp")
        ? p.vsp
        : 0;

    feet_prev =
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
    feet_prev <= spring_surf_y &&
    feet_now  >= spring_surf_y - 1;

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
// Resolve the forced horizontal direction
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
// Convert power 1–10 into horizontal speed
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


// ----------------------------------------------------
// Absolute forced launch
// ----------------------------------------------------

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
// Mostly low motor because this is a mechanical shove.
// The configured bounce size affects the strength.
// Minor interaction rumble does not replace stronger
// rumble already playing.
// ====================================================

var spring_rumble_low  = 0.18;
var spring_rumble_high = 0.08;
var spring_rumble_time = 4;

var bounce_size_text =
    string_lower(
        string(bounce_size)
    );

if (bounce_size_text == "small")
{
    spring_rumble_low  = 0.14;
    spring_rumble_high = 0.06;
    spring_rumble_time = 3;
}
else if (bounce_size_text == "large")
{
    spring_rumble_low  = 0.23;
    spring_rumble_high = 0.10;
    spring_rumble_time = 5;
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
    // Snap player feet to the spring top.
    var snap_dy =
        (
            other.bbox_top +
            other.surface_y_offset
        ) -
        bbox_bottom;

    y += snap_dy;


    // Cancel jump-charge state.
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


    // Cancel ordinary landing bounce.
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


    // Detach from standing surface.
    if (variable_instance_exists(id, "standing_platform"))
    {
        standing_platform = noone;
    }

    if (variable_instance_exists(id, "standing_platform_xoff"))
    {
        standing_platform_xoff = 0;
    }


    // Apply absolute spring launch.
    hsp = other.launch_h;
    vsp = other.launch_v;

    state  = "jumping";
    facing = other.launch_direction;

    spring_retrigger_lock =
        other.player_retrigger_lock_frames;
}


// ----------------------------------------------------
// Play spring press/recover animation
// ----------------------------------------------------

pressed_timer =
    pressed_frames;