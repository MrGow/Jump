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
// Configurable values are supplied through
// GameMaker Variable Definitions.
//
// Do not overwrite them here.
// ====================================================


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
//
// Chain attaches directly to the ball's metal ring.
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
// ball_gravity, ball_mass, ball_bounce and
// ground_friction are supplied through
// GameMaker Variable Definitions.
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

    update_attachment();
};