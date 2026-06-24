/// oConveyorLeft - Step

// Hot reload safety
if (!variable_instance_exists(id, "conveyor_speed"))
{
    conveyor_speed = 5;
}

conveyor_speed = clamp(conveyor_speed, 1, 10);

// Update belt force from speed setting
belt_speed = -lerp(0.35, 2.5, (conveyor_speed - 1) / 9);

// Update animation speed too
image_speed = lerp(0.25, 2.0, (conveyor_speed - 1) / 9);

surface_y = bbox_top + surface_offset;

dx = belt_speed;
dy = 0;