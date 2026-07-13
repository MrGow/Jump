/// oHorizontalChaseController — Draw GUI

draw_set_color(c_white);
draw_text(20, 20, "CHASE ACTIVE: " + string(chase_active));
draw_text(20, 40, "CHASE SPEED: " + string(chase_speed));
draw_text(20, 60, "CAM X: " + string(cam_x));