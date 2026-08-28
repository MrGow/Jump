/// oTeleportKey — Create

enabled = true;

sprite_index =
    spriteTeleporterKey;

image_index = 0;
image_speed = 1;


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "link_id"))
{
    link_id = "A";
}


if (!variable_instance_exists(id, "pickup_pad"))
{
    pickup_pad = 4;
}


if (!variable_instance_exists(id, "carry_offset_x"))
{
    carry_offset_x = 24;
}

if (!variable_instance_exists(id, "carry_offset_y"))
{
    carry_offset_y = -18;
}


if (!variable_instance_exists(id, "bob_amount"))
{
    bob_amount = 3;
}

if (!variable_instance_exists(id, "bob_speed"))
{
    bob_speed = 0.08;
}


if (!variable_instance_exists(id, "unlock_fly_speed"))
{
    unlock_fly_speed = 0.22;
}


if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// KEY AUDIO
// ====================================================

if (!variable_instance_exists(id, "key_loop_gain"))
{
    key_loop_gain = 0.42;
}

if (!variable_instance_exists(id, "key_pickup_gain"))
{
    key_pickup_gain = 0.90;
}

if (!variable_instance_exists(id, "key_sound_inner_dist"))
{
    key_sound_inner_dist = 80;
}

if (!variable_instance_exists(id, "key_sound_outer_dist"))
{
    key_sound_outer_dist = 430;
}

if (!variable_instance_exists(id, "key_sound_falloff_curve"))
{
    key_sound_falloff_curve = 1.35;
}

if (!variable_instance_exists(id, "key_loop_gain_lerp"))
{
    key_loop_gain_lerp = 0.90;
}


snd_key_loop =
    asset_get_index(
        "TeleporterKeyLoop"
    );

snd_key_pickup =
    asset_get_index(
        "TeleporterKeyPickup"
    );


key_audio_emitter =
    audio_emitter_create();

key_loop_instance =
    -1;

key_loop_current_gain =
    0;


if (key_audio_emitter >= 0)
{
    audio_emitter_falloff(
        key_audio_emitter,
        1,
        100000,
        0
    );

    audio_emitter_gain(
        key_audio_emitter,
        1
    );
}


// ====================================================
// AUDIO HELPERS
// ====================================================

key_distance_gain =
function(_player)
{
    if (_player == noone)
    {
        return 0;
    }

    var _dist =
        point_distance(
            x,
            y,
            _player.x,
            _player.y
        );

    if (_dist >= key_sound_outer_dist)
    {
        return 0;
    }

    if (_dist <= key_sound_inner_dist)
    {
        return 1;
    }

    var _t =
        clamp(
            (_dist - key_sound_inner_dist)
            /
            max(
                1,
                key_sound_outer_dist -
                key_sound_inner_dist
            ),
            0,
            1
        );

    return power(
        1 - _t,
        key_sound_falloff_curve
    );
};


key_update_emitter =
function(_player)
{
    if (
        key_audio_emitter < 0
        ||
        _player == noone
    )
    {
        return;
    }

    audio_emitter_position(
        key_audio_emitter,
        x - _player.x,
        y - _player.y,
        0
    );
};


key_stop_loop =
function()
{
    if (
        key_loop_instance != -1
        &&
        audio_is_playing(
            key_loop_instance
        )
    )
    {
        audio_stop_sound(
            key_loop_instance
        );
    }

    key_loop_instance =
        -1;

    key_loop_current_gain =
        0;
};


key_play_pickup =
function()
{
    if (snd_key_pickup == -1)
    {
        return;
    }

    if (!audio_group_is_loaded(audiogroupsfx))
    {
        return;
    }

    var _p =
        instance_find(
            oPlayer,
            0
        );

    if (_p == noone)
    {
        return;
    }

    var _dist_gain =
        key_distance_gain(
            _p
        );

    if (_dist_gain <= 0)
    {
        return;
    }

    key_update_emitter(
        _p
    );

    var _inst =
        audio_play_sound_on(
            key_audio_emitter,
            snd_key_pickup,
            false,
            0
        );

    if (_inst != -1)
    {
        audio_sound_gain(
            _inst,
            key_pickup_gain * _dist_gain,
            0
        );
    }
};


// ====================================================
// ORIGINAL POSITION
// ====================================================

home_x = x;
home_y = y;


// ====================================================
// STATE
//
// waiting
// carried
// to_teleporter
// consumed
// ====================================================

key_state = "waiting";

carrier = noone;

target_teleporter = noone;

bob_phase =
    random_range(
        0,
        pi * 2
    );


// ====================================================
// ROOM-LOCAL KEY STATE
// ====================================================

if (!variable_global_exists("teleport_key_room"))
{
    global.teleport_key_room = -1;
}

if (!variable_global_exists("teleport_room_keys"))
{
    global.teleport_room_keys = {};
}


if (global.teleport_key_room != room)
{
    global.teleport_key_room =
        room;

    global.teleport_room_keys =
        {};
}


if (
    !variable_struct_exists(
        global.teleport_room_keys,
        link_id
    )
)
{
    variable_struct_set(
        global.teleport_room_keys,
        link_id,
        false
    );
}


// ====================================================
// RESET FUNCTION
// ====================================================

reset_key = function()
{
    key_stop_loop();

    key_state =
        "waiting";

    carrier =
        noone;

    target_teleporter =
        noone;

    x =
        home_x;

    y =
        home_y;

    visible =
        true;

    image_alpha =
        1;

    image_index =
        0;

    image_speed =
        0.18;


    if (
        variable_global_exists(
            "teleport_room_keys"
        )
    )
    {
        variable_struct_set(
            global.teleport_room_keys,
            link_id,
            false
        );
    }
};
