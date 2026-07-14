/// oArea2ChasingSawsHorizontal — Create

// ----------------------------------------------------
// Store room-editor starting position
// ----------------------------------------------------
start_x = x;
start_y = y;

// ----------------------------------------------------
// Base camera-relative position
// ----------------------------------------------------
screen_offset_x = 0;
screen_offset_y = 0;

// ----------------------------------------------------
// Burst movement
//
// Positive Y moves the top saw downward
// into the player's available space.
// ----------------------------------------------------
burst_offset = 0;

burst_active = false;
burst_speed  = 0;
burst_target = 0;

// ----------------------------------------------------
// Chase state
// ----------------------------------------------------
enabled = false;
visible = true;