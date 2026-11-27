
/// oScrapChiefDemolitionBall — Create

// ====================================================
// SPRITE
// ====================================================

sprite_index = spriteScrapChiefDemolitionBall;

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

image_angle = 0;
image_alpha = 1;
image_blend = c_white;

depth = -110;

visible = false;


// ====================================================
// REFERENCES
// ====================================================

controller = noone;

carriage = noone;
chain = noone;


// ====================================================
// CONFIGURATION
//
// Existing configurable values are supplied through
// GameMaker Variable Definitions.
// ====================================================


// ====================================================
// SLAM CONFIGURATION SAFETY
// ====================================================

if (!variable_instance_exists(id, "slam_windup_seconds"))
{
    slam_windup_seconds = 1.5;
}

if (!variable_instance_exists(id, "slam_windup_retract"))
{
    slam_windup_retract = 12;
}

if (!variable_instance_exists(id, "slam_extend_speed"))
{
    slam_extend_speed = 14;
}

if (!variable_instance_exists(id, "slam_retract_speed"))
{
    slam_retract_speed = 5;
}

if (!variable_instance_exists(id, "slam_ground_seconds"))
{
    slam_ground_seconds = 0.5;
}

if (!variable_instance_exists(id, "slam_extra_chain"))
{
    slam_extra_chain = 16;
}

if (!variable_instance_exists(id, "slam_gravity"))
{
    slam_gravity = 2.5;
}

if (!variable_instance_exists(id, "slam_jolt_strength"))
{
    slam_jolt_strength = 4;
}

if (!variable_instance_exists(id, "slam_jolt_frames"))
{
    slam_jolt_frames = 12;
}

if (!variable_instance_exists(id, "slam_test_enabled"))
{
    slam_test_enabled = false;
}


// ====================================================
// START POSITION
// ====================================================

start_x = x;
start_y = y;

prev_x = x;
prev_y = y;


// ====================================================
// DIMENSIONS
// ====================================================

ball_width = sprite_get_width(
    spriteScrapChiefDemolitionBall
);

ball_height = sprite_get_height(
    spriteScrapChiefDemolitionBall
);


// ====================================================
// ATTACHMENT CONFIGURATION
// ====================================================

ball_attach_offset_x = ball_width * 0.5;
ball_attach_offset_y = 4;


// ====================================================
// ATTACHMENT POSITIONS
// ====================================================

ball_attach_x = x + ball_attach_offset_x;
ball_attach_y = y + ball_attach_offset_y;

chain_attach_x = ball_attach_x;
chain_attach_y = ball_attach_y;


// ====================================================
// MOVEMENT
// ====================================================

velocity_x = 0;
velocity_y = 0;

dx = 0;
dy = 0;

ball_angle = 0;

grounded = false;


// ====================================================
// PHYSICS CONFIGURATION
//
// Supplied through Variable Definitions.
// ====================================================


// ====================================================
// ANIMATION
// ====================================================

animation_frame = 0;


// ====================================================
// STATE
// ====================================================

active = false;

dangerous = false;

chain_attached = false;


// ====================================================
// SLAM STATE
//
// 0 = Idle
// 1 = Wind-up
// 2 = Descending
// 3 = Ground hold
// 4 = Retracting
// ====================================================

slam_state = 0;
slam_timer = 0;

slam_complete = true;

slam_original_length = 0;

slam_original_extend_speed = 0;
slam_original_retract_speed = 0;
slam_original_gravity = ball_gravity;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;


// ====================================================
// UPDATE ATTACHMENT POSITIONS
// ====================================================

update_attachment = function()
{
    ball_attach_x =
        x + ball_attach_offset_x;

    ball_attach_y =
        y + ball_attach_offset_y;

    chain_attach_x = ball_attach_x;
    chain_attach_y = ball_attach_y;
};


// ====================================================
// BEGIN SLAM
// ====================================================

begin_slam = function()
{
    if (
        !active ||
        !visible ||
        !chain_attached ||
        slam_state != 0
    )
    {
        return false;
    }

    if (
        !instance_exists(chain) ||
        !instance_exists(carriage) ||
        !instance_exists(controller)
    )
    {
        return false;
    }

    if (!instance_exists(controller.platform))
    {
        return false;
    }


    // --------------------------------------------
    // Save normal chain settings
    // --------------------------------------------

    slam_original_length =
        chain.target_length;

    slam_original_extend_speed =
        chain.extend_speed;

    slam_original_retract_speed =
        chain.retract_speed;

    slam_original_gravity =
        chain.payload_gravity;


    // --------------------------------------------
    // Begin wind-up
    // --------------------------------------------

    slam_state = 1;

    slam_complete = false;

    slam_timer = max(
        1,
        round(slam_windup_seconds * room_speed)
    );

    dangerous = false;

    grounded = false;


    // --------------------------------------------
    // Retract slightly as a visual warning
    // --------------------------------------------

    chain.set_chain_length(
        slam_original_length -
        slam_windup_retract
    );

    return true;
};


// ====================================================
// BEGIN DESCENT
// ====================================================

begin_slam_descent = function()
{
    if (
        !instance_exists(chain) ||
        !instance_exists(controller) ||
        !instance_exists(carriage)
    )
    {
        return false;
    }

    if (!instance_exists(controller.platform))
    {
        return false;
    }

    var p = controller.platform;


    // --------------------------------------------
    // Calculate chain length required to reach floor
    // --------------------------------------------

    var floor_attachment_y =
		p.surface_y
		+ ground_inset_y
		- ball_height
		+ ball_attach_offset_y;

    var required_length = max(
        chain.minimum_length,
        floor_attachment_y -
        carriage.attachment_y
    );


    // --------------------------------------------
    // Begin rapid descent
    // --------------------------------------------

    slam_state = 2;

    // Safety timeout if the ball misses the platform.
    slam_timer = max(1, round(2 * room_speed));

    dangerous = true;

    grounded = false;

    chain.extend_speed =
        slam_extend_speed;

    chain.payload_gravity =
        slam_gravity;

    chain.set_chain_length(
        required_length + slam_extra_chain
    );

    return true;
};


// ====================================================
// SLAM IMPACT
// ====================================================

slam_impact = function()
{
    if (slam_state != 2)
    {
        return;
    }

    slam_state = 3;

    slam_timer = max(
        1,
        round(slam_ground_seconds * room_speed)
    );

    grounded = true;
	
	// --------------------------------------------
	// Heavy impact screen shake
	// --------------------------------------------

	if (!variable_global_exists("shake_mag"))
	{
		global.shake_mag = 0;
	}

	if (!variable_global_exists("shake_time"))
	{
		global.shake_time = 0;
	}

	global.shake_mag = max(global.shake_mag, 8);
	global.shake_time = max(global.shake_time, 14);


    // --------------------------------------------
    // Elevator impact jolt
    // --------------------------------------------

    if (instance_exists(controller))
    {
        if (instance_exists(controller.platform))
        {
            var p = controller.platform;

            p.jolt_strength =
                slam_jolt_strength;

            p.jolt_timer =
                slam_jolt_frames;
        }
    }
};


// ====================================================
// BEGIN RETRACTION
// ====================================================

begin_slam_retraction = function()
{
    if (!instance_exists(chain))
    {
        slam_state = 0;
        slam_complete = true;
        dangerous = false;

        return;
    }

    slam_state = 4;

    dangerous = false;

    chain.payload_gravity =
        slam_original_gravity;

    chain.retract_speed =
        slam_retract_speed;

    chain.set_chain_length(
        slam_original_length
    );
};


// ====================================================
// FINISH SLAM
// ====================================================

finish_slam = function()
{
    if (instance_exists(chain))
    {
        chain.extend_speed =
            slam_original_extend_speed;

        chain.retract_speed =
            slam_original_retract_speed;

        chain.payload_gravity =
            slam_original_gravity;
    }

    slam_state = 0;
    slam_timer = 0;

    slam_complete = true;

    dangerous = false;
};


// ====================================================
// RESET BALL
// ====================================================

reset_ball = function()
{
    x = start_x;
    y = start_y;

    prev_x = x;
    prev_y = y;

    dx = 0;
    dy = 0;

    velocity_x = 0;
    velocity_y = 0;

    ball_angle = 0;

    grounded = false;

    active = false;
    dangerous = false;

    visible = false;

    carriage = noone;
    chain = noone;

    chain_attached = false;

    animation_frame = 0;
    image_index = 0;


    // --------------------------------------------
    // Reset slam
    // --------------------------------------------

    slam_state = 0;
    slam_timer = 0;

    slam_complete = true;

    slam_original_length = 0;

    slam_original_extend_speed = 0;
    slam_original_retract_speed = 0;

    slam_original_gravity = ball_gravity;

    update_attachment();
};
