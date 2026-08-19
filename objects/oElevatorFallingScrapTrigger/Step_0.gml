/// oElevatorFallingScrapTrigger — Step

// ====================================================
// DEATH RESET
//
// Same-room respawns do not recreate room instances, so
// clear this one-shot state while the death flow is active.
// This must run before scr_game_frozen() exits the event.
// ====================================================

if (
    variable_global_exists("game_phase") &&
    (
        global.game_phase == "death_delay" ||
        global.game_phase == "death_menu"
    )
)
{
    activated = false;
    exit;
}


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ALREADY USED
// ====================================================

if (activated)
{
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
    exit;
}


if (
    variable_instance_exists(
        p,
        "state"
    ) &&
    p.state == "dead"
)
{
    exit;
}


// ====================================================
// PLAYER ENTERED TRIGGER
//
// Use full bbox overlap.
//
// This works correctly with stretched rectangular
// trigger sprites and does NOT depend on player origin.
// ====================================================

var player_inside =
    p.bbox_right >
    bbox_left
    &&
    p.bbox_left <
    bbox_right
    &&
    p.bbox_bottom >
    bbox_top
    &&
    p.bbox_top <
    bbox_bottom;


if (!player_inside)
{
    exit;
}


// Trigger immediately.
activated = true;


// ====================================================
// CHOOSE AUTHORED SCRAP SPRITE
//
// 1 = spriteFallingScrap1
// 2 = spriteFallingScrap2
// 3 = spriteFallingScrap3
// 4 = spriteFallingScrap4
// 5 = spriteFallingScrap5
// ====================================================

var chosen_sprite =
    spriteFallingScrap1;


switch (round(scrap_type))
{
    case 1:
        chosen_sprite =
            spriteFallingScrap1;
        break;


    case 2:
        chosen_sprite =
            spriteFallingScrap2;
        break;


    case 3:
        chosen_sprite =
            spriteFallingScrap3;
        break;


    case 4:
        chosen_sprite =
            spriteFallingScrap4;
        break;


    case 5:
        chosen_sprite =
            spriteFallingScrap5;
        break;
}


// ====================================================
// SPAWN POSITION
// ====================================================

var spawn_x =
    x +
    spawn_offset_x;


var cam =
    view_camera[0];


var spawn_y =
    y -
    spawn_height;


// Spawn above current camera so the scrap always enters
// from above the player's visible area.
if (cam != -1)
{
    spawn_y =
        camera_get_view_y(
            cam
        ) -
        spawn_height;
}


// ====================================================
// CREATE SCRAP
// ====================================================

var layer_name =
    layer_exists("Instances")
    ? "Instances"
    : layer_get_name(layer);


var scrap =
    instance_create_layer(
        spawn_x,
        spawn_y,
        layer_name,
        oElevatorFallingScrap
    );


if (scrap != noone)
{
    scrap.sprite_index =
        chosen_sprite;

    scrap.image_index = 0;
    scrap.image_speed = 0;


    scrap.fall_speed =
        initial_fall_speed;

    scrap.fall_acceleration =
        fall_acceleration;

    scrap.max_fall_speed =
        max_fall_speed;

    scrap.rotation_speed =
        rotation_speed;
}