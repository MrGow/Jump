/// oMechaSoldierBodyPart — Create

depth = -10001;


// ====================================================
// BODY PART
//
// Each instance displays exactly ONE subimage from
// spriteMechaSoldierBodyParts.
// ====================================================

if (!variable_instance_exists(id, "part_sprite"))
{
    part_sprite =
        spriteMechaSoldierBodyParts;
}


if (!variable_instance_exists(id, "part_frame"))
{
    part_frame = 0;
}


// ====================================================
// MOTION
//
// Normally supplied by oMechaSoldier when spawned.
// ====================================================

if (!variable_instance_exists(id, "hsp"))
{
    hsp = 0;
}


if (!variable_instance_exists(id, "vsp"))
{
    vsp = 0;
}


gravity_amount = 0.22;

maximum_fall_speed = 8;

horizontal_drag = 0.995;


// ====================================================
// ROTATION
// ====================================================

if (!variable_instance_exists(id, "spin_speed"))
{
    spin_speed = 0;
}


if (!variable_instance_exists(id, "start_angle"))
{
    start_angle =
        random_range(
            0,
            359
        );
}


image_angle =
    start_angle;


// ====================================================
// BOUNCE BEHAVIOUR
// ====================================================

bounce_amount = 0.42;

horizontal_bounce_amount = 0.55;

minimum_bounce_speed = 0.75;

bounce_count = 0;

maximum_bounces = 3;

settled = false;


// ====================================================
// LIFETIME
// ====================================================

life_timer =
    room_speed * 5;


// ====================================================
// APPEARANCE
// ====================================================

sprite_index =
    part_sprite;


image_index =
    clamp(
        round(part_frame),
        0,
        sprite_get_number(part_sprite) - 1
    );


image_speed = 0;

image_alpha = 1;


// ====================================================
// TILEMAP
// ====================================================

solid_tilemap = -1;


if (layer_exists("Solids"))
{
    var solid_layer =
        layer_get_id(
            "Solids"
        );


    if (solid_layer != -1)
    {
        solid_tilemap =
            layer_tilemap_get_id(
                solid_layer
            );
    }
}


// ====================================================
// SOLID CHECK
// ====================================================

death_part_solid_at =
function(_x, _y)
{
    // ------------------------------------------------
    // DYNAMIC SOLIDS
    // ------------------------------------------------

    var dynamic_solid =
        asset_get_index(
            "oSolidDyn"
        );


    if (dynamic_solid != -1)
    {
        if (
            instance_position(
                _x,
                _y,
                dynamic_solid
            )
            != noone
        )
        {
            return true;
        }
    }


    // ------------------------------------------------
    // MAIN SOLID TILEMAP
    // ------------------------------------------------

    if (solid_tilemap != -1)
    {
        if (
            tilemap_get_at_pixel(
                solid_tilemap,
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