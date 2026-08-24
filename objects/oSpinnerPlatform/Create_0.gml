/// oSpinnerPlatform — Create

event_inherited();


// ====================================================
// VARIANT SPRITE
// ====================================================

var _platform_sprite =
    spriteSpinnerPlatform;


if (
    variable_instance_exists(
        id,
        "platform_sprite_override"
    )
)
{
    _platform_sprite =
        platform_sprite_override;
}


platform_sprite =
    _platform_sprite;


// ====================================================
// SPRITE / MASK
// ====================================================

sprite_index =
    platform_sprite;


mask_index =
    platform_sprite;


visible =
    true;


enabled =
    true;


active =
    true;


// ====================================================
// SOLID BEHAVIOUR
// ====================================================

solid_body =
    true;


solid_only_when_active =
    true;


// ====================================================
// VISUAL
// ====================================================

image_speed =
    0;

image_index =
    0;

image_angle =
    0;


depth =
    -201;


// ====================================================
// OWNER / ORBIT
// ====================================================

owner_spinner =
    noone;

orbit_angle =
    0;

orbit_radius =
    42;

platform_index =
    0;


// ====================================================
// FLOOR SURFACE
// ====================================================

surface_inset_left =
    0;

surface_inset_right =
    0;

surface_y_offset =
    0;

surface_y =
    bbox_top
    +
    surface_y_offset;


// ====================================================
// MOVEMENT DELTA
// ====================================================

dx =
    0;

dy =
    0;