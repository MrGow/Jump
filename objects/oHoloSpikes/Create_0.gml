/// oHoloSpike — Create

event_inherited();

enabled = true;
active  = false;

solid_body = false;
solid_only_when_active = false;


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    spriteHoloSpike;

image_speed = 0;
image_index = 0;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// ----------------------------------------------------
// Direction
//
// Source sprite points UP.
//
// 0 = up
// 1 = right
// 2 = down
// 3 = left
// ----------------------------------------------------
if (!variable_instance_exists(id, "spike_direction"))
{
    spike_direction = 0;
}


// ----------------------------------------------------
// Time spent fully retracted / safe
// ----------------------------------------------------
if (!variable_instance_exists(id, "retracted_time_s"))
{
    retracted_time_s = 1.5;
}


// ----------------------------------------------------
// Time spent fully extended / lethal
// ----------------------------------------------------
if (!variable_instance_exists(id, "up_time_s"))
{
    up_time_s = 1.0;
}


// ----------------------------------------------------
// Animation speed
//
// Used both extending and retracting.
// ----------------------------------------------------
if (!variable_instance_exists(id, "spike_anim_speed"))
{
    spike_anim_speed = 0.35;
}


// ----------------------------------------------------
// Player hitbox padding
//
// Positive = slightly more forgiving detection.
// ----------------------------------------------------
if (!variable_instance_exists(id, "hit_pad"))
{
    hit_pad = 2;
}


// ----------------------------------------------------
// Debug
// ----------------------------------------------------
if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// ROTATION
// ====================================================

update_spike_rotation = function()
{
    spike_direction =
        ((round(spike_direction) mod 4) + 4) mod 4;

    switch (spike_direction)
    {
        // Up
        case 0:
            image_angle = 0;
        break;

        // Right
        case 1:
            image_angle = 270;
        break;

        // Down
        case 2:
            image_angle = 180;
        break;

        // Left
        case 3:
            image_angle = 90;
        break;
    }
};

update_spike_rotation();


// ====================================================
// TIMING
// ====================================================

retracted_frames =
    max(
        0,
        round(
            retracted_time_s *
            room_speed
        )
    );

up_frames =
    max(
        0,
        round(
            up_time_s *
            room_speed
        )
    );

retracted_timer =
    retracted_frames;

up_timer =
    up_frames;


// ====================================================
// STATE
// ====================================================

state = "retracted";
// retracted
// extending
// extended
// retracting


// ====================================================
// FRAME LIMITS
// ====================================================

idle_frame = 0;

// Sixth animation frame = image_index 5.
up_hold_frame = 5;

// Safety in case the sprite ever has fewer frames.
up_hold_frame =
    clamp(
        up_hold_frame,
        0,
        image_number - 1
    );

// ====================================================
// INITIAL STATE
// ====================================================

image_index = idle_frame;
image_speed = 0;

active = false;