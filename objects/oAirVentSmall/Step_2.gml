/// oAirVentSmall — End Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}

// ----------------------------------------------------
// Resume animation
// ----------------------------------------------------
if (enabled)
{
    image_speed = fan_animation_speed;
    wind_animation_position += wind_animation_speed;
}
else
{
    image_speed = 0;
    exit;
}

// ====================================================
// FIND PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);

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

// Confirm this vent detected the player during Begin Step.
if (
    !variable_instance_exists(p, "air_vent_source") ||
    p.air_vent_source != id
)
{
    exit;
}

if (
    !variable_instance_exists(p, "air_vent_active_until") ||
    current_time > p.air_vent_active_until
)
{
    exit;
}

// ====================================================
// CAPTURE DOWNWARD MOMENTUM
// ====================================================

if (p.vsp > 0)
{
    p.vsp =
        max(
            0,
            p.vsp - capture_strength
        );
}

if (
    p.vsp >= 0 &&
    p.vsp <= capture_strength
)
{
    p.vsp = -capture_rise_speed;
}

// ====================================================
// CONTINUOUS UPDRAFT
// ====================================================

var target_vsp = -maximum_rise_speed;

if (p.vsp > target_vsp)
{
    p.vsp =
        max(
            target_vsp,
            p.vsp - updraft_acceleration
        );
}

// ====================================================
// HORIZONTAL BIAS
// ====================================================

var target_hsp =
    horizontal_bias *
    bias_max_speed;

if (p.hsp < target_hsp)
{
    p.hsp =
        min(
            target_hsp,
            p.hsp + horizontal_acceleration
        );
}
else if (p.hsp > target_hsp)
{
    p.hsp =
        max(
            target_hsp,
            p.hsp - horizontal_acceleration
        );
}

// ====================================================
// CANCEL PLAYER CONTROL STATES
// ====================================================

if (variable_instance_exists(p, "jump_charging"))
{
    p.jump_charging = false;
}

if (variable_instance_exists(p, "jump_charge"))
{
    p.jump_charge = 0;
}

if (variable_instance_exists(p, "jump_charge_level"))
{
    p.jump_charge_level = 0;
}

if (variable_instance_exists(p, "jump_charge_sfx_last"))
{
    p.jump_charge_sfx_last = 0;
}

if (variable_instance_exists(p, "charge_grace"))
{
    p.charge_grace = 0;
}

if (variable_instance_exists(p, "charge_start_lock"))
{
    p.charge_start_lock = 0;
}

if (variable_instance_exists(p, "support_grace"))
{
    p.support_grace = 0;
}

if (variable_instance_exists(p, "support_stable_frames"))
{
    p.support_stable_frames = 0;
}

if (variable_instance_exists(p, "standing_platform"))
{
    p.standing_platform = noone;
}

if (variable_instance_exists(p, "bounce_pending"))
{
    p.bounce_pending = false;
}

if (variable_instance_exists(p, "bounce_timer"))
{
    p.bounce_timer = 0;
}

if (variable_instance_exists(p, "bounce_v"))
{
    p.bounce_v = 0;
}

if (variable_instance_exists(p, "coyote_timer"))
{
    p.coyote_timer = 0;
}

if (variable_instance_exists(p, "state"))
{
    p.state = "glide";
}