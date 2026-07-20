/// oDeathExplosion — Create

depth = -10002;

sprite_index =
    spriteDeathExplosion;

image_index = 0;
image_speed = 0.6;

image_xscale = 1;
image_yscale = 1;

parts_spawned = false;


// ====================================================
// SPAWN ONE BODY PART
// ====================================================

spawn_death_part = function(
    _sprite,
    _offset_x,
    _offset_y,
    _hsp,
    _vsp,
    _spin
)
{
    if (_sprite == -1)
    {
        return noone;
    }

    var facing_direction =
        sign(image_xscale);

    if (facing_direction == 0)
    {
        facing_direction = 1;
    }

    var part =
        instance_create_layer(
            x +
            _offset_x *
            facing_direction,
            y +
            _offset_y,
            "Instances",
            oBotDeathPart
        );

    if (part == noone)
    {
        return noone;
    }

    part.sprite_index =
        _sprite;

    part.image_index = 0;
    part.image_speed = 0;

    part.image_xscale =
        facing_direction;

    part.image_yscale = 1;

    part.hsp =
        _hsp *
        facing_direction +
        random_range(
            -0.75,
             0.75
        );

    part.vsp =
        _vsp +
        random_range(
            -0.65,
             0.65
        );

    part.spin_speed =
        _spin *
        facing_direction +
        random_range(
            -1.5,
             1.5
        );

    part.image_angle =
        random_range(
            -15,
             15
        );

    part.death_facing =
        facing_direction;

    return part;
};


// ====================================================
// SPAWN COMPLETE BOT
// ====================================================

spawn_all_parts = function()
{
    if (parts_spawned)
    {
        return;
    }

    parts_spawned = true;


    // ------------------------------------------------
    // Central body pieces
    // ------------------------------------------------

    spawn_death_part(
        spriteBody,
        0,
        0,
        random_range(-1.4, 1.4),
        -5.2,
        random_range(-4, 4)
    );

    spawn_death_part(
        spriteBodyPart,
        0,
        8,
        random_range(-2.2, 2.2),
        -3.8,
        random_range(-7, 7)
    );


    // ------------------------------------------------
    // Head
    // ------------------------------------------------

    spawn_death_part(
        spriteHead,
        0,
        -16,
        random_range(-2.2, 2.2),
        -7.2,
        random_range(-8, 8)
    );


    // ------------------------------------------------
    // Left side
    // ------------------------------------------------

    spawn_death_part(
        spriteLeftArm,
        -8,
        -2,
        -4.8,
        -5.5,
        -10
    );

    spawn_death_part(
        spriteLeftArm2,
        -11,
        2,
        -5.5,
        -4.4,
        -13
    );

    spawn_death_part(
        spriteLeftForearm,
        -14,
        5,
        -6.2,
        -3.8,
        -16
    );


    // ------------------------------------------------
    // Right side
    // ------------------------------------------------

    spawn_death_part(
        spriteRightArm,
        8,
        -2,
        4.8,
        -5.5,
        10
    );

    spawn_death_part(
        spriteRightForearm,
        14,
        5,
        6.2,
        -3.8,
        16
    );


    // ------------------------------------------------
    // Wheels
    // ------------------------------------------------

    spawn_death_part(
        spriteWheel1,
        -9,
        13,
        -4.4,
        -3.2,
        -18
    );

    spawn_death_part(
        spriteWheel2,
        0,
        14,
        random_range(-2, 2),
        -4.5,
        random_range(-18, 18)
    );

    spawn_death_part(
        spriteWheel3,
        9,
        13,
        4.4,
        -3.2,
        18
    );
};