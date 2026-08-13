/// oTeleportKey — Create

enabled = true;

sprite_index =
    spriteTeleporterKey;

image_index = 0;
image_speed = 1;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// Must match the teleporter.
//
// Examples:
// "A"
// "B"
// "LAB_1"
if (!variable_instance_exists(id, "link_id"))
{
    link_id = "A";
}


// ----------------------------------------------------
// Pickup overlap padding
// ----------------------------------------------------
if (!variable_instance_exists(id, "pickup_pad"))
{
    pickup_pad = 4;
}


// ----------------------------------------------------
// Carried position
//
// Because the bird is already above JumpBot,
// put the key slightly off to one side.
// ----------------------------------------------------
if (!variable_instance_exists(id, "carry_offset_x"))
{
    carry_offset_x = 24;
}

if (!variable_instance_exists(id, "carry_offset_y"))
{
    carry_offset_y = -18;
}


// ----------------------------------------------------
// Floating bob
// ----------------------------------------------------
if (!variable_instance_exists(id, "bob_amount"))
{
    bob_amount = 3;
}

if (!variable_instance_exists(id, "bob_speed"))
{
    bob_speed = 0.08;
}


// ----------------------------------------------------
// Speed when flying into teleporter
// ----------------------------------------------------
if (!variable_instance_exists(id, "unlock_fly_speed"))
{
    unlock_fly_speed = 0.22;
}


// ----------------------------------------------------
// Debug
// ----------------------------------------------------
if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// ORIGINAL POSITION
// ====================================================

home_x = x;
home_y = y;


// ====================================================
// STATE
//
// "waiting"
// "carried"
// "to_teleporter"
// "consumed"
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
//
// Keys are intentionally NOT permanent inventory.
//
// Entering another room automatically gives that room
// a fresh key state.
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


// Ensure this ID exists.
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