/// oSpinner — Begin Step

if (!enabled) exit;

// Hard-lock the disc to its original centre
x = base_x;
y = base_y;

// Rotate disc visually only
image_angle += spin_speed;

// Move attached platforms around the fixed centre
for (var i = 0; i < array_length(platforms); i++)
{
    var p = platforms[i];

    if (!instance_exists(p)) continue;

    var old_x = p.x;
    var old_y = p.y;

    p.orbit_angle += spin_speed;

    p.x = base_x + lengthdir_x(p.orbit_radius, p.orbit_angle);
    p.y = base_y + lengthdir_y(p.orbit_radius, p.orbit_angle);

    // For player carry system
    p.dx = p.x - old_x;
    p.dy = p.y - old_y;

    // Keep platform horizontal
    p.image_angle = 0;
}