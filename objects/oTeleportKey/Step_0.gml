/// oTeleportKey — Step


// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


// ====================================================
// DEATH RESET
//
// IMPORTANT:
// This is BEFORE scr_game_frozen(), so death/menu
// freezing cannot prevent the puzzle from resetting.
// ====================================================

if (p != noone)
{
    var player_dead =
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead";


    if (
        player_dead
        &&
        (
            key_state == "carried"
            ||
            key_state == "to_teleporter"
        )
    )
    {
        reset_key();
        exit;
    }
}


// ====================================================
// PAUSE / FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}


if (!enabled)
{
    image_speed = 0;
    exit;
}


// ====================================================
// WAITING FOR PICKUP
// ====================================================

if (key_state == "waiting")
{
    visible =
        true;

    image_alpha =
        1;

    image_speed =
        0.18;


    if (p == noone)
    {
        exit;
    }


    var player_dead =
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead";


    if (player_dead)
    {
        exit;
    }


    // ------------------------------------------------
    // Pickup overlap
    // ------------------------------------------------

    var overlap =
        p.bbox_right >
            bbox_left - pickup_pad
        &&
        p.bbox_left <
            bbox_right + pickup_pad
        &&
        p.bbox_bottom >
            bbox_top - pickup_pad
        &&
        p.bbox_top <
            bbox_bottom + pickup_pad;


    if (overlap)
    {
        key_state =
            "carried";

        carrier =
            p;


        variable_struct_set(
            global.teleport_room_keys,
            link_id,
            true
        );


        // Start bob cleanly.
        bob_phase = 0;
    }

    exit;
}


// ====================================================
// CARRIED
// ====================================================

if (key_state == "carried")
{
    if (!instance_exists(carrier))
    {
        reset_key();
        exit;
    }


    bob_phase +=
        bob_speed;


    var carrier_facing =
        variable_instance_exists(
            carrier,
            "facing"
        )
        ? carrier.facing
        : 1;


    // ------------------------------------------------
    // Float beside/above player
    // ------------------------------------------------

    x =
        carrier.x
        +
        (
            carry_offset_x
            *
            carrier_facing
        );


    y =
        carrier.bbox_top
        +
        carry_offset_y
        +
        sin(bob_phase)
        *
        bob_amount;


    visible =
        true;

    image_alpha =
        1;

    image_speed =
        0.18;


    exit;
}


// ====================================================
// FLY INTO TELEPORTER
// ====================================================

if (key_state == "to_teleporter")
{
    if (!instance_exists(target_teleporter))
    {
        reset_key();
        exit;
    }


    image_speed =
        0.25;


    var target_x =
        target_teleporter.x;

    var target_y =
        target_teleporter.y;


    x =
        lerp(
            x,
            target_x,
            unlock_fly_speed
        );

    y =
        lerp(
            y,
            target_y,
            unlock_fly_speed
        );


    // ------------------------------------------------
    // Arrived
    // ------------------------------------------------

    if (
        point_distance(
            x,
            y,
            target_x,
            target_y
        )
        <= 3
    )
    {
        x =
            target_x;

        y =
            target_y;

        key_state =
            "consumed";

        visible =
            false;

        image_alpha =
            0;

        image_speed =
            0;


        variable_struct_set(
            global.teleport_room_keys,
            link_id,
            false
        );


        // Tell teleporter that the key reached it.
        if (
            variable_instance_exists(
                target_teleporter,
                "key_arrived"
            )
        )
        {
            target_teleporter.key_arrived =
                true;
        }
    }


    exit;
}


// ====================================================
// CONSUMED
// ====================================================

if (key_state == "consumed")
{
    visible =
        false;

    image_speed =
        0;

    exit;
}