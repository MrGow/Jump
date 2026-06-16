/// oSpinner — Create

sprite_index = spriteSpinner;
image_speed  = 0;
image_index  = 0;

visible = true;
enabled = true;

// Keep disc in front of crane/background layer
depth = -200;

// Fixed centre position. The spinner disc never moves from this point.
base_x = x;
base_y = y;

// ----------------------------------------------------
// Rotation speed
// Editor variable:
// spinner_speed_level = 1..5
// ----------------------------------------------------
if (!variable_instance_exists(id, "spinner_speed_level")) spinner_speed_level = 3;

if (spinner_speed_level == 1)      spin_speed = 0.35;
else if (spinner_speed_level == 2) spin_speed = 0.65;
else if (spinner_speed_level == 3) spin_speed = 1.00;
else if (spinner_speed_level == 4) spin_speed = 1.50;
else if (spinner_speed_level == 5) spin_speed = 2.25;
else                               spin_speed = 1.00;

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