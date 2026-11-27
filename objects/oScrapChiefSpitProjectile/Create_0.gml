/// oScrapChiefSpitProjectile — Create

// ====================================================
// SPRITE
// ====================================================

sprite_index = choose(
    spriteFallingScrap2,
    spriteFallingScrap4,
    spriteFallingScrap5
);

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

image_angle = 0;
image_alpha = 1;
image_blend = c_white;

depth = -115;


// ====================================================
// SPAWN POP ANIMATION
//
// Visual scaling only.
// Does not affect the collision mask.
// ====================================================

pop_start_scale = 0.15;
pop_peak_scale = 1.10;

pop_expand_frames = 6;
pop_settle_frames = 4;

pop_timer = 0;
pop_scale = pop_start_scale;


// ====================================================
// REFERENCES
// ====================================================

controller = noone;
platform = noone;


// ====================================================
// PROJECTILE STATE
// ====================================================

initialized = false;
dangerous = false;

age = 0;

lifetime = room_speed * 5;


// ====================================================
// MOVEMENT
// ====================================================

velocity_x = 0;
velocity_y = 0;

gravity_amount = 0.25;

rotation_speed = choose(-4, 4);

prev_x = x;
prev_y = y;


// ====================================================
// INITIALIZE AIMED PROJECTILE
//
// Target coordinates are relative to the elevator.
//
// Horizontal elevator movement is inherited throughout
// the projectile's flight, so it remains accurate
// while the elevator travels.
// ====================================================

initialize_aimed_spit = function(
    _controller,
    _target_x,
    _target_y,
    _flight_seconds,
    _arc_height,
    _rotation_speed
)
{
    controller = _controller;

    if (!instance_exists(controller))
    {
        instance_destroy();
        return;
    }

    platform = controller.platform;

    if (!instance_exists(platform))
    {
        instance_destroy();
        return;
    }


    // --------------------------------------------
    // Flight duration
    // --------------------------------------------

    var flight_frames = max(
        2,
        round(_flight_seconds * room_speed)
    );


    // --------------------------------------------
    // Target displacement
    // --------------------------------------------

    var distance_x = _target_x - x;
    var distance_y = _target_y - y;

    velocity_x =
        distance_x / flight_frames;


    // --------------------------------------------
    // Calculate upward arc
    //
    // Begin with an upward velocity and calculate
    // gravity to reach the intended target.
    // --------------------------------------------

    var arc_height = max(
        1,
        _arc_height
    );

    var downward_distance = max(
        0,
        distance_y
    );

    var arc_ratio =
        sqrt(arc_height) /
        (
            sqrt(arc_height) +
            sqrt(arc_height + downward_distance)
        );

    var apex_frames = max(
        1,
        flight_frames * arc_ratio
    );

    velocity_y =
        -(2 * arc_height) /
        apex_frames;

    gravity_amount =
        2 *
        (
            distance_y -
            velocity_y * flight_frames
        ) /
        (
            flight_frames *
            (flight_frames + 1)
        );


    // --------------------------------------------
    // Rotation
    // --------------------------------------------

    rotation_speed =
        abs(_rotation_speed) *
        choose(-1, 1);


    // --------------------------------------------
    // Reset spawn pop
    // --------------------------------------------

    pop_timer = 0;
    pop_scale = pop_start_scale;


    // --------------------------------------------
    // Activate
    // --------------------------------------------

    age = 0;

    lifetime =
        flight_frames +
        room_speed * 2;

    initialized = true;
    dangerous = true;
};