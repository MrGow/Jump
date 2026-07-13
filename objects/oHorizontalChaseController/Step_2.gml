/// oHorizontalChaseController — End Step

if (!chase_active) exit;

// Smooth acceleration
chase_speed = lerp(
    chase_speed,
    target_chase_speed,
    speed_lerp
);

// Move camera
cam_x += chase_speed;

// Room boundary
cam_x = clamp(cam_x, 0, cam_x_max);

// Apply
camera_set_view_pos(
    cam,
    round(cam_x),
    round(cam_y)
);