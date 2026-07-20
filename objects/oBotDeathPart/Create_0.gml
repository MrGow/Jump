/// oBotDeathPart — Create

depth = -10001;

// ----------------------------------------------------
// Motion
// ----------------------------------------------------
hsp = 0;
vsp = 0;

gravity_amount = 0.22;
maximum_fall_speed = 8;

spin_speed = 0;

horizontal_drag = 0.995;

// ----------------------------------------------------
// Bounce behaviour
// ----------------------------------------------------
bounce_amount = 0.42;
horizontal_bounce_amount = 0.55;

minimum_bounce_speed = 0.75;

bounce_count = 0;
maximum_bounces = 3;

settled = false;

// ----------------------------------------------------
// Lifetime
//
// The death menu will normally appear before this ends.
// ----------------------------------------------------
life_timer = room_speed * 5;

// ----------------------------------------------------
// Appearance
// ----------------------------------------------------
image_speed = 0;
image_index = 0;

image_angle = random_range(0, 359);

// The death explosion sets this to the player's facing.
death_facing = 1;

// ----------------------------------------------------
// Tilemap
// ----------------------------------------------------
solid_tilemap = -1;

if (layer_exists("Solids"))
{
    var solid_layer = layer_get_id("Solids");

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

death_part_solid_at = function(_x, _y)
{
    // Dynamic solid objects.
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

    // Main solid tilemap.
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