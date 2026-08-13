/// oTeleportArrival — Room Start


// ====================================================
// NOTHING PENDING
// ====================================================

if (
    !variable_global_exists(
        "teleport_arrival_pending"
    )
    ||
    !global.teleport_arrival_pending
)
{
    exit;
}


if (
    !variable_global_exists(
        "teleport_target_room"
    )
    ||
    global.teleport_target_room != room
)
{
    exit;
}


if (
    !variable_global_exists(
        "teleport_target_arrival_id"
    )
)
{
    exit;
}


if (
    global.teleport_target_arrival_id
    !=
    arrival_id
)
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


if (p == noone)
{
    exit;
}


// ====================================================
// POSITION PLAYER
// ====================================================

p.x =
    x +
    arrival_offset_x;

p.y =
    y +
    arrival_offset_y;


if (variable_instance_exists(p, "hsp"))
{
    p.hsp = 0;
}

if (variable_instance_exists(p, "vsp"))
{
    p.vsp = 0;
}

if (variable_instance_exists(p, "state"))
{
    p.state = "idle";
}


if (
    arrival_facing != 0
    &&
    variable_instance_exists(
        p,
        "facing"
    )
)
{
    p.facing =
        sign(arrival_facing);

    p.image_xscale =
        p.facing;
}


// Screen is still completely black here.
p.image_alpha =
    1;


// ====================================================
// RESET MOVEMENT LEFTOVERS
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

if (variable_instance_exists(p, "bounce_pending"))
{
    p.bounce_pending = false;
}

if (variable_instance_exists(p, "bounce_timer"))
{
    p.bounce_timer = 0;
}

if (variable_instance_exists(p, "standing_platform"))
{
    p.standing_platform = noone;
}

if (variable_instance_exists(p, "coyote_timer"))
{
    p.coyote_timer = 0;
}

if (variable_instance_exists(p, "respawn_input_lock"))
{
    p.respawn_input_lock = 8;
}


// ====================================================
// SHORT ARRIVAL I-FRAMES
// ====================================================

if (variable_instance_exists(p, "invincible"))
{
    p.invincible =
        true;
}

if (variable_instance_exists(p, "invincible_timer"))
{
    p.invincible_timer =
        round(
            room_speed * 0.5
        );
}


// ====================================================
// UPDATE RUN CONTROLLER SPAWN
// ====================================================

if (instance_exists(oRunController))
{
    var rc =
        instance_find(
            oRunController,
            0
        );


    if (rc != noone)
    {
        rc.spawn_x =
            p.x;

        rc.spawn_y =
            p.y;
    }
}


// ====================================================
// ARRIVAL COMPLETE
// ====================================================

global.teleport_arrival_pending =
    false;

global.teleport_target_room =
    -1;

global.teleport_target_arrival_id =
    "";


// Tell persistent oGame that the destination is ready.
global.teleport_arrival_ready =
    true;


// ====================================================
// NEW ROOM = NEW KEY PUZZLE
// ====================================================

global.teleport_key_room =
    room;

global.teleport_room_keys =
    {};