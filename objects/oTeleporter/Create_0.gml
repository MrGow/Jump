/// oTeleporter — Create

enabled = true;

sprite_index = spriteTeleporter;
image_speed  = 0;
image_index  = 0;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// Matching key ID
if (!variable_instance_exists(id, "link_id"))
{
    link_id = "A";
}


// Destination room
if (!variable_instance_exists(id, "target_room"))
{
    target_room = -1;
}


// Arrival marker in destination room
if (!variable_instance_exists(id, "arrival_id"))
{
    arrival_id = "A";
}


// ====================================================
// LOCKED WARNING
// ====================================================

if (!variable_instance_exists(id, "key_required_distance"))
{
    key_required_distance = 95;
}

if (!variable_instance_exists(id, "key_required_offset_x"))
{
    key_required_offset_x = 26;
}

if (!variable_instance_exists(id, "key_required_offset_y"))
{
    key_required_offset_y = -25;
}

if (!variable_instance_exists(id, "key_required_angle"))
{
    key_required_angle = 25;
}

if (!variable_instance_exists(id, "key_required_bob_amount"))
{
    key_required_bob_amount = 2;
}

if (!variable_instance_exists(id, "key_required_bob_speed"))
{
    key_required_bob_speed = 0.09;
}

if (!variable_instance_exists(id, "key_required_pop_speed"))
{
    key_required_pop_speed = 0.18;
}


// ====================================================
// KEY ACCEPT RANGE
// ====================================================

if (!variable_instance_exists(id, "key_accept_distance"))
{
    key_accept_distance = 110;
}


// ====================================================
// UNLOCKED MESSAGE
// ====================================================

if (!variable_instance_exists(id, "unlock_world_frames"))
{
    unlock_world_frames =
        round(room_speed * 1.35);
}

if (!variable_instance_exists(id, "unlock_world_offset_x"))
{
    unlock_world_offset_x = 26;
}

if (!variable_instance_exists(id, "unlock_world_offset_y"))
{
    unlock_world_offset_y = -28;
}

if (!variable_instance_exists(id, "unlock_world_angle"))
{
    unlock_world_angle = 25;
}

if (!variable_instance_exists(id, "unlock_world_bob_amount"))
{
    unlock_world_bob_amount = 2;
}

if (!variable_instance_exists(id, "unlock_world_bob_speed"))
{
    unlock_world_bob_speed = 0.09;
}

if (!variable_instance_exists(id, "unlock_world_pop_speed"))
{
    unlock_world_pop_speed = 0.18;
}


// ====================================================
// PAD ACTIVATION
//
// IMPORTANT:
//
// spriteTeleporter has a large frame canvas because the
// teleport effect extends far upward.
//
// Therefore activation does NOT use bbox_top/bbox_bottom.
//
// spriteTeleporter should use:
//     Origin = Middle Bottom
//
// The activation surface is:
//     y + teleport_surface_offset_y
// ====================================================

// Horizontal precision.
// Player origin must be within this many pixels of the
// teleporter's centre.
if (!variable_instance_exists(id, "teleport_center_tolerance"))
{
    teleport_center_tolerance = 7;
}


// Vertical precision.
// Player feet must be within this many pixels of the
// pad's standing surface.
if (!variable_instance_exists(id, "teleport_feet_tolerance"))
{
    teleport_feet_tolerance = 3;
}


// Distance upward from Middle Bottom origin to the
// actual top surface of the physical teleporter pad.
//
// Start at -6 and tune visually with debug_draw.
if (!variable_instance_exists(id, "teleport_surface_offset_y"))
{
    teleport_surface_offset_y = -6;
}


// ====================================================
// TELEPORTER ANIMATION
// ====================================================

if (!variable_instance_exists(id, "inactive_frame"))
{
    inactive_frame = 0;
}

if (!variable_instance_exists(id, "activation_start_frame"))
{
    activation_start_frame = 1;
}

if (!variable_instance_exists(id, "activation_end_frame"))
{
    activation_end_frame = 13;
}

if (!variable_instance_exists(id, "player_hide_frame"))
{
    player_hide_frame = 7;
}

if (!variable_instance_exists(id, "activation_anim_speed"))
{
    activation_anim_speed = 0.28;
}


// ====================================================
// DEBUG
// ====================================================

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// VALIDATE ANIMATION
// ====================================================

var last_frame =
    max(
        0,
        image_number - 1
    );

inactive_frame =
    clamp(
        round(inactive_frame),
        0,
        last_frame
    );

activation_start_frame =
    clamp(
        round(activation_start_frame),
        0,
        last_frame
    );

activation_end_frame =
    clamp(
        round(activation_end_frame),
        activation_start_frame,
        last_frame
    );

player_hide_frame =
    clamp(
        round(player_hide_frame),
        activation_start_frame,
        activation_end_frame
    );


// ====================================================
// STATE
// ====================================================

teleporter_state =
    "inactive";

key_arrived =
    false;

sequence_player =
    noone;

lock_player_x =
    0;

lock_player_y =
    0;

player_hidden =
    false;

room_change_started =
    false;


// ====================================================
// LOCKED MESSAGE STATE
// ====================================================

show_key_required =
    false;

key_required_was_showing =
    false;

key_required_triggered =
    false;

key_required_bob_phase =
    0;

key_required_pop =
    0;


// ====================================================
// UNLOCK MESSAGE STATE
// ====================================================

unlock_world_timer =
    0;

unlock_world_bob_phase =
    0;

unlock_world_pop =
    0;


// ====================================================
// ROOM-LOCAL KEY DATA
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
// FIND MATCHING KEY
// ====================================================

find_matching_key = function(_required_state)
{
    var count =
        instance_number(
            oTeleportKey
        );

    for (var i = 0; i < count; i++)
    {
        var k =
            instance_find(
                oTeleportKey,
                i
            );

        if (k == noone)
        {
            continue;
        }

        if (
            !variable_instance_exists(
                k,
                "link_id"
            )
            ||
            k.link_id != link_id
        )
        {
            continue;
        }

        if (!is_undefined(_required_state))
        {
            if (
                !variable_instance_exists(
                    k,
                    "key_state"
                )
                ||
                k.key_state !=
                    _required_state
            )
            {
                continue;
            }
        }

        return k;
    }

    return noone;
};


// ====================================================
// RESET PUZZLE
// ====================================================

reset_teleporter_puzzle = function()
{
    teleporter_state =
        "inactive";

    key_arrived =
        false;

    sequence_player =
        noone;

    player_hidden =
        false;

    room_change_started =
        false;


    show_key_required =
        false;

    key_required_was_showing =
        false;

    key_required_triggered =
        false;

    key_required_pop =
        0;


    unlock_world_timer =
        0;

    unlock_world_pop =
        0;


    sprite_index =
        spriteTeleporter;

    image_index =
        inactive_frame;

    image_speed =
        0;


    variable_struct_set(
        global.teleport_room_keys,
        link_id,
        false
    );


    var k =
        find_matching_key(
            undefined
        );


    if (
        k != noone
        &&
        variable_instance_exists(
            k,
            "reset_key"
        )
        &&
        is_callable(
            k.reset_key
        )
    )
    {
        k.reset_key();
    }
};


// ====================================================
// BEGIN KEY ABSORPTION
// ====================================================

begin_unlock = function()
{
    if (teleporter_state != "inactive")
    {
        return;
    }


    var matching_key =
        find_matching_key(
            "carried"
        );


    if (matching_key == noone)
    {
        return;
    }


    teleporter_state =
        "unlocking";

    key_arrived =
        false;


    show_key_required =
        false;

    key_required_was_showing =
        false;

    key_required_pop =
        0;


    matching_key.key_state =
        "to_teleporter";

    matching_key.target_teleporter =
        id;

    matching_key.carrier =
        noone;
};


// ====================================================
// KEY ARRIVED
// ====================================================

complete_unlock = function()
{
    teleporter_state =
        "unlocked";

    key_arrived =
        true;


    variable_struct_set(
        global.teleport_room_keys,
        link_id,
        false
    );


    unlock_world_timer =
        unlock_world_frames;

    unlock_world_bob_phase =
        0;

    unlock_world_pop =
        0;


    sprite_index =
        spriteTeleporter;

    image_index =
        inactive_frame;

    image_speed =
        0;
};


// ====================================================
// BEGIN TELEPORT
// ====================================================

begin_teleport = function(_player)
{
    if (_player == noone)
    {
        return;
    }


    if (teleporter_state != "unlocked")
    {
        return;
    }


    teleporter_state =
        "activating";

    sequence_player =
        _player;


    lock_player_x =
        x;

    lock_player_y =
        _player.y;


    _player.x =
        lock_player_x;

    _player.y =
        lock_player_y;


    if (variable_instance_exists(_player, "hsp"))
    {
        _player.hsp = 0;
    }

    if (variable_instance_exists(_player, "vsp"))
    {
        _player.vsp = 0;
    }


    player_hidden =
        false;

    room_change_started =
        false;


    unlock_world_timer =
        0;

    unlock_world_pop =
        0;


    sprite_index =
        spriteTeleporter;

    image_index =
        activation_start_frame;

    image_speed =
        0;
};


// ====================================================
// REQUEST FADE
// ====================================================

request_teleport_fade = function()
{
    if (room_change_started)
    {
        return;
    }


    if (target_room == -1)
    {
        show_debug_message(
            "oTeleporter ERROR: target_room not set for "
            +
            string(link_id)
        );

        return;
    }


    room_change_started =
        true;

    teleporter_state =
        "waiting_for_fade";


    global.teleport_transition_request =
        true;

    global.teleport_transition_target_room =
        target_room;

    global.teleport_transition_arrival_id =
        arrival_id;
};


// ====================================================
// INITIAL VISUAL
// ====================================================

sprite_index =
    spriteTeleporter;

image_index =
    inactive_frame;

image_speed =
    0;