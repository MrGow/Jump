/// oConveyorStripFast — End Step

// ----------------------------------------------------
// Freeze during pause/death
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}

image_speed = normal_image_speed;


// ----------------------------------------------------
// Direction safety
// ----------------------------------------------------
flow_direction =
    ((round(flow_direction) mod 8) + 8) mod 8;

var move_angle = flow_direction * 45;

if (auto_rotate_sprite)
{
    // Source sprite sends the player right at 0 degrees.
    image_angle = move_angle;
}


// ----------------------------------------------------
// Disabled
// ----------------------------------------------------
if (!enabled)
{
    player_inside_previous = false;
    exit;
}


// ----------------------------------------------------
// Find living player
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);

if (p == noone)
{
    player_inside_previous = false;
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    player_inside_previous = false;
    exit;
}


// ----------------------------------------------------
// Player overlap
// ----------------------------------------------------
var hit =
    p.bbox_right  > bbox_left   &&
    p.bbox_left   < bbox_right  &&
    p.bbox_bottom > bbox_top    &&
    p.bbox_top    < bbox_bottom;

if (!hit)
{
    player_inside_previous = false;
    exit;
}


// ----------------------------------------------------
// Direction vectors
// ----------------------------------------------------
var dir_x = lengthdir_x(1, move_angle);
var dir_y = lengthdir_y(1, move_angle);

var side_x = -dir_y;
var side_y =  dir_x;


// ----------------------------------------------------
// Split velocity into forward and sideways components
// ----------------------------------------------------
var forward_speed =
    p.hsp * dir_x +
    p.vsp * dir_y;

var side_speed =
    p.hsp * side_x +
    p.vsp * side_y;


// ----------------------------------------------------
// First frame entering this strip
// ----------------------------------------------------
if (!player_inside_previous)
{
    forward_speed += entry_kick;

    // ------------------------------------------------
    // Controlled entry sound
    // ------------------------------------------------
    if (
        snd_entry != -1 &&
        global.green_strip_sfx_cooldown <= 0
    )
    {
        var free_slot = -1;

        for (
            var i = 0;
            i < array_length(global.green_strip_sfx_ids);
            i++
        )
        {
            var old_sound_id =
                global.green_strip_sfx_ids[i];

            if (
                old_sound_id == -1 ||
                !audio_is_playing(old_sound_id)
            )
            {
                free_slot = i;
                break;
            }
        }

        if (free_slot != -1)
        {
            var new_sound_id =
                audio_play_sound(
                    snd_entry,
                    0,
                    false
                );

            audio_sound_gain(
                new_sound_id,
                sfx_gain,
                0
            );

            audio_sound_pitch(
                new_sound_id,
                random_range(
                    sfx_pitch_min,
                    sfx_pitch_max
                )
            );

            global.green_strip_sfx_ids[free_slot] =
                new_sound_id;

            global.green_strip_sfx_cooldown =
                sfx_global_cooldown_frames;
        }
    }
}


// ----------------------------------------------------
// Continuous acceleration
// ----------------------------------------------------
forward_speed += push_accel;

forward_speed = min(
    forward_speed,
    max_forward_speed
);


// ----------------------------------------------------
// Align player with conveyor direction
// ----------------------------------------------------
side_speed *= side_damping;


// ----------------------------------------------------
// Rebuild velocity
// ----------------------------------------------------
p.hsp =
    dir_x  * forward_speed +
    side_x * side_speed;

p.vsp =
    dir_y  * forward_speed +
    side_y * side_speed;

player_inside_previous = true;