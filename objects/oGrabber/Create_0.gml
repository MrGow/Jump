/// oGrabber — Create

if (!variable_instance_exists(id, "route_id")) route_id = 0;
if (!variable_instance_exists(id, "move_speed")) move_speed = 2.0;
if (!variable_instance_exists(id, "close_animation_speed")) close_animation_speed = 0.25;
if (!variable_instance_exists(id, "open_animation_speed")) open_animation_speed = 0.25;
if (!variable_instance_exists(id, "connector_segments")) connector_segments = 2;
if (!variable_instance_exists(id, "capture_half_width")) capture_half_width = 16;
if (!variable_instance_exists(id, "capture_top_offset")) capture_top_offset = 0;
if (!variable_instance_exists(id, "capture_bottom_offset")) capture_bottom_offset = 28;
if (!variable_instance_exists(id, "player_hold_top_offset")) player_hold_top_offset = 10;
if (!variable_instance_exists(id, "release_momentum")) release_momentum = 1.0;
if (!variable_instance_exists(id, "release_vsp")) release_vsp = 0;
if (!variable_instance_exists(id, "release_input_lock_frames")) release_input_lock_frames = 6;
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;

connector_segments = max(0, round(connector_segments));

// Hanging-motion tuning
if (!variable_instance_exists(id, "sway_length")) sway_length = 24;
if (!variable_instance_exists(id, "sway_move_lean")) sway_move_lean = 5.0;
if (!variable_instance_exists(id, "sway_idle_amount")) sway_idle_amount = 1.1;
if (!variable_instance_exists(id, "sway_idle_speed")) sway_idle_speed = 0.075;
if (!variable_instance_exists(id, "sway_spring")) sway_spring = 0.075;
if (!variable_instance_exists(id, "sway_damping")) sway_damping = 0.88;
if (!variable_instance_exists(id, "sway_stop_kick")) sway_stop_kick = 1.6;
if (!variable_instance_exists(id, "sway_release_kick")) sway_release_kick = 0.22;
if (!variable_instance_exists(id, "catch_jerk_pixels")) catch_jerk_pixels = 2.0;
if (!variable_instance_exists(id, "machine_vibration_amount")) machine_vibration_amount = 0.65;


// ====================================================
// AUDIO TUNING
// ====================================================

if (!variable_instance_exists(id, "grabber_grab_gain")) grabber_grab_gain = 0.85;
if (!variable_instance_exists(id, "grabber_release_gain")) grabber_release_gain = 0.85;
if (!variable_instance_exists(id, "grabber_move_gain")) grabber_move_gain = 0.48;

if (!variable_instance_exists(id, "grabber_sound_inner_dist")) grabber_sound_inner_dist = 90;
if (!variable_instance_exists(id, "grabber_sound_outer_dist")) grabber_sound_outer_dist = 520;
if (!variable_instance_exists(id, "grabber_sound_falloff_curve")) grabber_sound_falloff_curve = 1.35;

if (!variable_instance_exists(id, "grabber_move_sound_max_simultaneous"))
    grabber_move_sound_max_simultaneous = 3;

if (!variable_instance_exists(id, "grabber_move_gain_lerp"))
    grabber_move_gain_lerp = 0.18;


// ====================================================
// CORE STATE
// ====================================================

start_x = x;
start_y = y;
destination = noone;
grabbed_player = noone;
grab_state = "idle";
dx = 0;
dy = 0;
last_dx = 0;
release_armed = false;
release_input_lock = 0;
claw_opening = false;


// ====================================================
// VISUAL-ONLY SECONDARY MOTION
// ====================================================

sway_angle = 0;
sway_velocity = 0;
sway_phase = random(100);
catch_jerk = 0;
player_visual_offset_x = 0;
player_visual_offset_y = 0;
player_visual_angle = 0;
machine_visual_y = 0;


// ====================================================
// AUDIO DATA
// ====================================================

snd_grabber_grab = asset_get_index("GrabberGrab");
snd_grabber_move_loop = asset_get_index("GrabberMovementLoop");
snd_grabber_release = asset_get_index("GrabberRelease");

grabber_audio_emitter = audio_emitter_create();
grabber_move_loop_instance = -1;
grabber_move_current_gain = 0;
grabber_move_audio_allowed = false;

if (grabber_audio_emitter >= 0)
{
    audio_emitter_falloff(
        grabber_audio_emitter,
        1,
        100000,
        0
    );

    audio_emitter_gain(
        grabber_audio_emitter,
        1
    );
}


// ====================================================
// AUDIO HELPERS
// ====================================================

grabber_distance_gain =
function(_player)
{
    if (_player == noone) return 0;

    var _d =
        point_distance(
            x,
            y,
            _player.x,
            _player.y
        );

    if (_d >= grabber_sound_outer_dist) return 0;
    if (_d <= grabber_sound_inner_dist) return 1;

    var _t =
        clamp(
            (_d - grabber_sound_inner_dist)
            /
            max(
                1,
                grabber_sound_outer_dist -
                grabber_sound_inner_dist
            ),
            0,
            1
        );

    return power(
        1 - _t,
        grabber_sound_falloff_curve
    );
};


grabber_update_audio_position =
function(_player)
{
    if (
        grabber_audio_emitter < 0
        ||
        _player == noone
    )
    {
        return;
    }

    audio_emitter_position(
        grabber_audio_emitter,
        x - _player.x,
        y - _player.y,
        0
    );
};


grabber_play_one_shot =
function(_sound, _base_gain)
{
    if (_sound == -1) return;
    if (!audio_group_is_loaded(audiogroupsfx)) return;

    var _player = instance_find(oPlayer, 0);
    if (_player == noone) return;

    var _dist_gain = grabber_distance_gain(_player);
    if (_dist_gain <= 0) return;

    grabber_update_audio_position(_player);

    var _inst =
        audio_play_sound_on(
            grabber_audio_emitter,
            _sound,
            false,
            0
        );

    if (_inst != -1)
    {
        audio_sound_gain(
            _inst,
            _base_gain * _dist_gain,
            0
        );
    }
};


grabber_is_move_audio_candidate =
function(_player)
{
    if (_player == noone) return false;
    if (grab_state != "moving") return false;

    var _my_dist =
        point_distance(
            x,
            y,
            _player.x,
            _player.y
        );

    if (_my_dist >= grabber_sound_outer_dist) return false;

    var _closer_count = 0;
    var _count = instance_number(oGrabber);

    for (var _i = 0; _i < _count; _i++)
    {
        var _grabber = instance_find(oGrabber, _i);

        if (
            _grabber == noone
            ||
            _grabber == id
        )
        {
            continue;
        }

        if (
            variable_instance_exists(_grabber, "grab_state")
            &&
            _grabber.grab_state != "moving"
        )
        {
            continue;
        }

        var _other_outer =
            variable_instance_exists(
                _grabber,
                "grabber_sound_outer_dist"
            )
            ?
            _grabber.grabber_sound_outer_dist
            :
            grabber_sound_outer_dist;

        var _other_dist =
            point_distance(
                _grabber.x,
                _grabber.y,
                _player.x,
                _player.y
            );

        if (_other_dist >= _other_outer) continue;

        var _closer =
            _other_dist <
            _my_dist - 0.001;

        var _tie_winner =
            abs(
                _other_dist -
                _my_dist
            )
            <= 0.001
            &&
            _grabber.id < id;

        if (_closer || _tie_winner)
        {
            _closer_count++;

            if (
                _closer_count >=
                grabber_move_sound_max_simultaneous
            )
            {
                return false;
            }
        }
    }

    return true;
};


grabber_stop_move_loop =
function()
{
    if (
        grabber_move_loop_instance != -1
        &&
        audio_is_playing(
            grabber_move_loop_instance
        )
    )
    {
        audio_stop_sound(
            grabber_move_loop_instance
        );
    }

    grabber_move_loop_instance = -1;
    grabber_move_current_gain = 0;
    grabber_move_audio_allowed = false;
};


image_speed = 0;
image_index = max(0, image_number - 1);