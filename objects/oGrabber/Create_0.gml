/// oGrabber — Create

// ====================================================
// ROUTE SETTINGS
// ====================================================

if (!variable_instance_exists(id, "route_id"))
{
    route_id = 0;
}

if (!variable_instance_exists(id, "move_speed"))
{
    move_speed = 2.0;
}


// ====================================================
// ANIMATION SETTINGS
// ====================================================

if (!variable_instance_exists(id, "close_animation_speed"))
{
    close_animation_speed = 0.25;
}

if (!variable_instance_exists(id, "open_animation_speed"))
{
    open_animation_speed = 0.25;
}


// ====================================================
// VISUAL CONSTRUCTION
// ====================================================

if (!variable_instance_exists(id, "connector_segments"))
{
    connector_segments = 2;
}

connector_segments =
    max(
        0,
        round(connector_segments)
    );


// ====================================================
// CAPTURE AREA
// ====================================================

if (!variable_instance_exists(id, "capture_half_width"))
{
    capture_half_width = 16;
}

if (!variable_instance_exists(id, "capture_top_offset"))
{
    capture_top_offset = 0;
}

if (!variable_instance_exists(id, "capture_bottom_offset"))
{
    capture_bottom_offset = 28;
}


// Position of the top of the player's collision mask
// while hanging beneath the claw.
if (!variable_instance_exists(id, "player_hold_top_offset"))
{
    player_hold_top_offset = 10;
}


// ====================================================
// RELEASE SETTINGS
// ====================================================

if (!variable_instance_exists(id, "release_momentum"))
{
    release_momentum = 1.0;
}


// Use 0 for a natural fall.
// Use a negative value for a small upward release hop.
if (!variable_instance_exists(id, "release_vsp"))
{
    release_vsp = 0;
}


// ====================================================
// DEBUG
// ====================================================

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// INITIAL POSITION
// ====================================================

start_x = x;
start_y = y;


// ====================================================
// RUNTIME STATE
// ====================================================

destination = noone;
grabbed_player = noone;

grab_state = "idle";

dx = 0;
dy = 0;

last_dx = 0;

release_armed = false;
claw_opening = false;


// ====================================================
// INITIAL ANIMATION
//
// Frame 0 is fully closed.
// The final frame is fully open.
// ====================================================

image_speed = 0;

image_index =
    max(
        0,
        image_number - 1
    );