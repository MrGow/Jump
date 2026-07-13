/// oArea2ChasingSaws — Create

// Store original room-editor position
start_x = x;
start_y = y;

// Position relative to chase camera once active
screen_offset_x = 0;
screen_offset_y = 0;

// Before chase begins, the saws should still be visible
// in their original resting position.
enabled = false;
visible = true;