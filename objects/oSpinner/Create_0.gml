/// oSpinner — Create

sprite_index = spriteSpinner;
image_speed  = 0;
image_index  = 0;

visible = true;
enabled = true;

// Fixed centre position. The spinner disc never moves from this point.
base_x = x;
base_y = y;

// Depth: visible behind platforms/player
depth = -200;

// Visual spin
image_angle = 0;
spin_speed = 1.0; // degrees per frame. Negative reverses direction.

// Platform orbit
platform_count = 2;
orbit_radius   = 42;
start_angle    = 0;

// Created platforms
platforms = array_create(platform_count, noone);

for (var i = 0; i < platform_count; i++)
{
    var ang = start_angle + (360 / platform_count) * i;
    var px = base_x + lengthdir_x(orbit_radius, ang);
    var py = base_y + lengthdir_y(orbit_radius, ang);

    var inst = instance_create_layer(px, py, "Instances", oSpinnerPlatform);

    inst.owner_spinner  = id;
    inst.orbit_angle    = ang;
    inst.orbit_radius   = orbit_radius;
    inst.platform_index = i;

    platforms[i] = inst;
}