/// oScrapChief — Create

// ====================================================
// CONFIGURATION SAFETY
//
// Only supply defaults if the variables do not exist.
// Never overwrite Variable Definitions.
// ====================================================

if (!variable_instance_exists(id, "chief_id"))
{
    chief_id = 2;
}

if (!variable_instance_exists(id, "chief_mass"))
{
    chief_mass = 16;
}

if (!variable_instance_exists(id, "chief_gravity"))
{
    chief_gravity = 0.35;
}

if (!variable_instance_exists(id, "connector_offset_x"))
{
    connector_offset_x = 0;
}

if (!variable_instance_exists(id, "connector_offset_y"))
{
    connector_offset_y = 0;
}

if (!variable_instance_exists(id, "connector_overlap"))
{
    connector_overlap = 4;
}

if (!variable_instance_exists(id, "idle_animation_speed"))
{
    idle_animation_speed = 1;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// SPRITE
// ====================================================

sprite_index = spriteScrapChiefIdle;

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
// ORIGINAL POSITION
// ====================================================

start_x = x;
start_y = y;

prev_x = x;
prev_y = y;


// ====================================================
// DIMENSIONS
// ====================================================

chief_width = sprite_get_width(
    spriteScrapChiefIdle
);

chief_height = sprite_get_height(
    spriteScrapChiefIdle
);

connector_sprite = spriteScrapChiefConnector;

connector_width = sprite_get_width(
    connector_sprite
);

connector_height = sprite_get_height(
    connector_sprite
);


// ====================================================
// CONNECTOR POSITION
//
// Relative to Chief's top-left origin.
// ====================================================

connector_local_x =
    chief_width * 0.5
    - connector_width * 0.5
    + connector_offset_x;

connector_local_y =
    -connector_height
    + connector_overlap
    + connector_offset_y;


// ====================================================
// SHARED CHAIN PAYLOAD INTERFACE
//
// These names match the existing demolition ball
// interface so the chain requires no changes.
// ====================================================

ball_mass = chief_mass;
ball_gravity = chief_gravity;

ball_attach_offset_x =
    connector_local_x
    + connector_width * 0.5;

ball_attach_offset_y =
    connector_local_y;


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


// ====================================================
// STATE
// ====================================================

active = false;

dangerous = false;

chain_attached = false;


// ====================================================
// ANIMATION
// ====================================================

animation_frame = 0;


// ====================================================
// UPDATE ATTACHMENT
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
// RESET CHIEF
// ====================================================

reset_chief = function()
{
    x = start_x;
    y = start_y;

    prev_x = x;
    prev_y = y;

    velocity_x = 0;
    velocity_y = 0;

    dx = 0;
    dy = 0;

    active = false;
    dangerous = false;

    visible = false;

    carriage = noone;
    chain = noone;

    chain_attached = false;

    sprite_index = spriteScrapChiefIdle;

    animation_frame = 0;

    image_index = 0;
    image_speed = 0;

    update_attachment();
};