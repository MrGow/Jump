/// oPinballSmacker — Step

// ====================================================
// FREEZE DURING PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}


// ----------------------------------------------------
// Animation state
// ----------------------------------------------------
if (hit_animating)
{
    image_speed = hit_animation_speed;
}
else
{
    image_index = 0;
    image_speed = 0;
}


// ----------------------------------------------------
// Flash timer
// ----------------------------------------------------
if (hit_flash > 0)
{
    hit_flash--;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    player_was_inside = false;
    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    player_was_inside = false;
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    player_was_inside = false;
    exit;
}


// ====================================================
// CIRCULAR COLLISION AGAINST PLAYER BOUNDING BOX
// ====================================================

var radius =
    min(
        sprite_get_width(sprite_index),
        sprite_get_height(sprite_index)
    )
    *
    collision_radius_scale
    *
    max(
        abs(image_xscale),
        abs(image_yscale)
    );

var closest_x =
    clamp(
        x,
        p.bbox_left,
        p.bbox_right
    );

var closest_y =
    clamp(
        y,
        p.bbox_top,
        p.bbox_bottom
    );

var collision_dx =
    closest_x - x;

var collision_dy =
    closest_y - y;

var player_inside =
    (
        collision_dx * collision_dx +
        collision_dy * collision_dy
    )
    <=
    (
        radius * radius
    );


// ----------------------------------------------------
// Rearm once the player leaves
// ----------------------------------------------------
if (!player_inside)
{
    player_was_inside = false;
    exit;
}


// ----------------------------------------------------
// Already triggered during this overlap
// ----------------------------------------------------
if (player_was_inside)
{
    exit;
}

player_was_inside = true;


// ====================================================
// SHARED PLAYER HIT GUARD
// ====================================================

if (!variable_instance_exists(p, "pinball_next_hit_time"))
{
    p.pinball_next_hit_time = 0;
}

if (current_time < p.pinball_next_hit_time)
{
    exit;
}

p.pinball_next_hit_time =
    current_time +
    max(
        0,
        hit_lock_ms
    );


// ====================================================
// READ INCOMING MOMENTUM
// ====================================================

if (!variable_instance_exists(p, "hsp"))
{
    p.hsp = 0;
}

if (!variable_instance_exists(p, "vsp"))
{
    p.vsp = 0;
}

var incoming_hsp =
    p.hsp;

var incoming_vsp =
    p.vsp;

var incoming_speed =
    point_distance(
        0,
        0,
        incoming_hsp,
        incoming_vsp
    );


// ====================================================
// DIRECTION AWAY FROM SMACKER CENTRE
// ====================================================

var away_x =
    p.x - x;

var away_y =
    p.y - y;

var away_length =
    point_distance(
        0,
        0,
        away_x,
        away_y
    );

if (away_length <= 0.05)
{
    // Fallback when both centres happen to overlap.
    if (incoming_speed > 0.05)
    {
        away_x = -incoming_hsp;
        away_y = -incoming_vsp;

        away_length =
            incoming_speed;
    }
    else
    {
        away_x = 0;
        away_y = -1;
        away_length = 1;
    }
}

away_x /= away_length;
away_y /= away_length;


// ====================================================
// REVERSE MOMENTUM
// ====================================================

var rebound_hsp;
var rebound_vsp;

if (incoming_speed > 0.05)
{
    var reversed_speed =
        clamp(
            incoming_speed *
            reverse_multiplier,
            minimum_launch_speed,
            maximum_launch_speed
        );

    rebound_hsp =
        (
            -incoming_hsp /
            incoming_speed
        )
        *
        reversed_speed;

    rebound_vsp =
        (
            -incoming_vsp /
            incoming_speed
        )
        *
        reversed_speed;
}
else
{
    rebound_hsp =
        away_x *
        minimum_launch_speed;

    rebound_vsp =
        away_y *
        minimum_launch_speed;
}


// ----------------------------------------------------
// Add small outward radial kick
// ----------------------------------------------------
rebound_hsp +=
    away_x *
    radial_kick;

rebound_vsp +=
    away_y *
    radial_kick;


// ----------------------------------------------------
// Clamp final combined velocity
// ----------------------------------------------------
var final_speed =
    point_distance(
        0,
        0,
        rebound_hsp,
        rebound_vsp
    );

if (final_speed > maximum_launch_speed)
{
    rebound_hsp =
        (
            rebound_hsp /
            final_speed
        )
        *
        maximum_launch_speed;

    rebound_vsp =
        (
            rebound_vsp /
            final_speed
        )
        *
        maximum_launch_speed;
}

p.hsp = rebound_hsp;
p.vsp = rebound_vsp;


// ====================================================
// RESET PLAYER MOVEMENT STATES
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

if (variable_instance_exists(p, "charge_start_lock"))
{
    p.charge_start_lock = 0;
}

if (variable_instance_exists(p, "charge_grace"))
{
    p.charge_grace = 0;
}

if (variable_instance_exists(p, "support_grace"))
{
    p.support_grace = 0;
}

if (variable_instance_exists(p, "support_stable_frames"))
{
    p.support_stable_frames = 0;
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

if (variable_instance_exists(p, "standing_platform"))
{
    p.standing_platform = noone;
}

if (variable_instance_exists(p, "coyote_timer"))
{
    p.coyote_timer = 0;
}

if (variable_instance_exists(p, "state"))
{
    p.state = "glide";
}

if (
    variable_instance_exists(p, "facing") &&
    abs(p.hsp) > 0.05
)
{
    p.facing =
        p.hsp > 0
        ? 1
        : -1;
}


// ----------------------------------------------------
// Clear old jump trail
// ----------------------------------------------------
if (variable_instance_exists(p, "jump_trail_points"))
{
    for (
        var trail_index = 0;
        trail_index <
            array_length(p.jump_trail_points);
        trail_index++
    )
    {
        p.jump_trail_points[trail_index] =
            undefined;
    }
}


// ====================================================
// PLAY IMPACT ANIMATION ONCE
// ====================================================

hit_animating = true;

image_index = 0;
image_speed = hit_animation_speed;

hit_flash = hit_flash_max;


// ====================================================
// CONTROLLED SHARED SOUND
// ====================================================

if (
    snd_hit != -1 &&
    current_time >= global.pinball_sfx_next_time
)
{
    if (
        !is_array(global.pinball_sfx_ids) ||
        array_length(global.pinball_sfx_ids) !=
            sfx_max_instances
    )
    {
        global.pinball_sfx_ids =
            array_create(
                sfx_max_instances,
                -1
            );
    }

    var free_slot = -1;

    for (
        var sound_index = 0;
        sound_index <
            array_length(global.pinball_sfx_ids);
        sound_index++
    )
    {
        var existing_sound =
            global.pinball_sfx_ids[
                sound_index
            ];

        if (
            existing_sound == -1 ||
            !audio_is_playing(existing_sound)
        )
        {
            free_slot =
                sound_index;

            break;
        }
    }

    if (free_slot != -1)
    {
        var new_sound =
            audio_play_sound(
                snd_hit,
                0,
                false
            );

        audio_sound_gain(
            new_sound,
            sfx_gain,
            0
        );

        audio_sound_pitch(
            new_sound,
            random_range(
                sfx_pitch_min,
                sfx_pitch_max
            )
        );

        global.pinball_sfx_ids[
            free_slot
        ] = new_sound;

        global.pinball_sfx_next_time =
            current_time +
            sfx_shared_gap_ms;
    }
}