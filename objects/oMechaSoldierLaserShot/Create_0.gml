/// oMechaSoldierLaserShot — Create


// ====================================================
// SPRITE
//
// Middle Centre origin.
// ====================================================

sprite_index =
    spriteMechaSoldierLaserShot;

image_index = 0;
image_speed = 1;


// ====================================================
// MOVEMENT
//
// These may be overwritten immediately after creation
// by oMechaSoldier.
// ====================================================

move_angle = 0;
move_speed = 6.0;

owner = noone;


// ====================================================
// LIFETIME
// ====================================================

if (!variable_instance_exists(id, "life_seconds"))
{
    life_seconds = 5.0;
}


life_frames =
    max(
        1,
        round(
            life_seconds *
            room_speed
        )
    );


// ====================================================
// COLLISION
// ====================================================

// Small substeps prevent fast shots tunnelling through
// thin walls or the player.
max_move_substep = 1;


// ====================================================
// SETUP
//
// Called by oMechaSoldier after move_angle,
// move_speed and owner have been assigned.
// ====================================================

setup_projectile =
function()
{
    image_angle =
        move_angle;


    image_index = 0;
    image_speed = 1;
};


// ====================================================
// SOLIDS TILEMAP
// ====================================================

get_solids_tilemap =
function()
{
    var _layer =
        layer_get_id(
            "Solids"
        );


    if (_layer == -1)
    {
        return -1;
    }


    return
        layer_tilemap_get_id(
            _layer
        );
};


// ====================================================
// POINT HITS LEVEL SOLID
// ====================================================

laser_solid_at =
function(_x, _y)
{
    // ------------------------------------------------
    // DYNAMIC SOLIDS
    // ------------------------------------------------

    var _solid_obj =
        asset_get_index(
            "oSolidDyn"
        );


    if (_solid_obj != -1)
    {
        if (
            instance_position(
                _x,
                _y,
                _solid_obj
            )
            != noone
        )
        {
            return true;
        }
    }


    // ------------------------------------------------
    // SOLIDS TILEMAP
    // ------------------------------------------------

    var _tm =
        get_solids_tilemap();


    if (_tm != -1)
    {
        if (
            tilemap_get_at_pixel(
                _tm,
                _x,
                _y
            )
            != 0
        )
        {
            return true;
        }
    }


    return false;
};


// ====================================================
// INITIAL ROTATION
// ====================================================

image_angle =
    move_angle;