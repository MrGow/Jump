/// oArea3ChasingCaterpillar — Create

// ----------------------------------------------------
// Store room-editor starting position
// ----------------------------------------------------
start_x = x;
start_y = y;

// ----------------------------------------------------
// Camera-relative position while active
// ----------------------------------------------------

// Horizontal placement within the camera.
screen_offset_x = 0;

// Placement relative to the camera's top edge.
//
// With a top-left sprite origin, this should normally be
// close to the bottom of the 360px camera.
//
// Tune this based on the caterpillar sprite height.
screen_offset_y = 260;

// ----------------------------------------------------
// Burst movement
//
// Positive burst_offset moves the caterpillar upward
// farther into the available screen space.
// ----------------------------------------------------
burst_offset = 0;

burst_active = false;
burst_speed  = 0;
burst_target = 0;

// ----------------------------------------------------
// Chase state
// ----------------------------------------------------
enabled = false;

// Visible and lethal while resting
visible = true;