/// oScrapChiefRailCarriage — Create

// ====================================================
// SPRITE
// ====================================================

sprite_index = spriteScrapChiefRailCarriage;

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

image_angle = 0;
image_alpha = 1;
image_blend = c_white;

depth = -120;


// ====================================================
// ORIGINAL POSITION
// ====================================================

start_x = x;
start_y = y;

prev_x = x;
prev_y = y;

dx = 0;
dy = 0;


// ====================================================
// CONTROLLER
// ====================================================

controller = noone;


// ====================================================
// CONFIGURATION
//
// Configurable values are supplied through
// GameMaker Variable Definitions.
//
// payload_type:
// 0 = Demolition ball
// 1 = Scrap Chief
// ====================================================


// ====================================================
// CHAIN ATTACHMENT CONFIGURATION
// ====================================================

chain_offset_x = sprite_width * 0.5;
chain_offset_y = sprite_height - 10;


// ====================================================
// STATE
//
// 0 = Waiting
// 1 = Entrance delay
// 2 = Entering
// 3 = Following elevator
// 4 = Moving to world position
// 5 = Holding position
// ====================================================

carriage_state = 0;

activated = false;
entrance_complete = false;

entrance_timer = 0;

current_speed = 0;
target_x = x;

visible = false;


// ====================================================
// CHAIN ATTACHMENT
// ====================================================

chain = noone;

attachment_x = x + chain_offset_x;
attachment_y = y + chain_offset_y;


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;


// ====================================================
// GET ELEVATOR TARGET
// ====================================================

get_elevator_target = function()
{
    if (instance_exists(controller))
    {
        if (instance_exists(controller.platform))
        {
            var p = controller.platform;

            return
                (p.bbox_left + p.bbox_right) * 0.5
                + elevator_offset_x
                - chain_offset_x;
        }
    }

    return target_x;
};


// ====================================================
// CREATE ATTACHED CHAIN
// ====================================================

create_attached_chain = function()
{
    // --------------------------------------------
    // Prevent duplicate chains
    // --------------------------------------------

    if (instance_exists(chain))
    {
        return;
    }


    // --------------------------------------------
    // Find matching payload
    // --------------------------------------------

    var attached_payload = noone;


    // --------------------------------------------
    // DEMOLITION BALL
    // --------------------------------------------

    if (payload_type == 0)
    {
        var count = instance_number(
            oScrapChiefDemolitionBall
        );

        for (var i = 0; i < count; i++)
        {
            var candidate = instance_find(
                oScrapChiefDemolitionBall,
                i
            );

            if (candidate.ball_id == carriage_id)
            {
                attached_payload = candidate;

                break;
            }
        }
    }


    // --------------------------------------------
    // SCRAP CHIEF
    // --------------------------------------------

    else if (payload_type == 1)
    {
        var count = instance_number(
            oScrapChief
        );

        for (var i = 0; i < count; i++)
        {
            var candidate = instance_find(
                oScrapChief,
                i
            );

            if (candidate.chief_id == carriage_id)
            {
                attached_payload = candidate;

                break;
            }
        }
    }


    // --------------------------------------------
    // Payload safety
    // --------------------------------------------

    if (!instance_exists(attached_payload))
    {
        show_debug_message(
            "Scrap Chief: No payload found for carriage " +
            string(carriage_id)
            + " | Payload type: "
            + string(payload_type)
        );

        return;
    }


    // --------------------------------------------
    // Prevent duplicate payload attachments
    // --------------------------------------------

    if (instance_exists(attached_payload.chain))
    {
        show_debug_message(
            "Scrap Chief: Payload already attached for carriage " +
            string(carriage_id)
        );

        return;
    }


    // --------------------------------------------
    // Create chain
    // --------------------------------------------

    chain = instance_create_depth(
        attachment_x,
        attachment_y,
        -125,
        oScrapChiefChain
    );


    // --------------------------------------------
    // Apply chain configuration
    // --------------------------------------------

    chain.retract_speed =
        chain_retract_speed;

    chain.extend_speed =
        chain_extend_speed;


    // --------------------------------------------
    // Initialize chain and attach payload
    // --------------------------------------------

    chain.initialize_chain(
        id,
        attached_payload,
        starting_chain_length
    );
};


// ====================================================
// BEGIN ENTRANCE
// ====================================================

begin_entrance = function()
{
    if (activated)
    {
        return;
    }

    activated = true;
    entrance_complete = false;

    var camera_left = camera_get_view_x(
        view_camera[0]
    );

    x =
        camera_left
        - sprite_width
        - entrance_offscreen_distance
        - entrance_spacing;

    y = start_y;

    prev_x = x;
    prev_y = y;

    dx = 0;
    dy = 0;

    current_speed = 0;

    entrance_timer = max(
        0,
        round(entrance_delay * room_speed)
    );

    attachment_x = x + chain_offset_x;
    attachment_y = y + chain_offset_y;

    target_x = get_elevator_target();

    carriage_state = 1;

    visible = false;


    // --------------------------------------------
    // Create chain and attach payload
    // --------------------------------------------

    create_attached_chain();
};


// ====================================================
// MOVE TO WORLD POSITION
//
// Position refers to centre of chain attachment.
// ====================================================

move_to_position = function(_target_x)
{
    target_x = _target_x - chain_offset_x;

    carriage_state = 4;
};


// ====================================================
// FOLLOW ELEVATOR
// ====================================================

follow_elevator = function(_offset_x)
{
    elevator_offset_x = _offset_x;

    carriage_state = 3;
};


// ====================================================
// HOLD POSITION
// ====================================================

hold_position = function()
{
    target_x = x;

    current_speed = 0;

    carriage_state = 5;
};


// ====================================================
// RESET CARRIAGE
// ====================================================

reset_carriage = function()
{
    // --------------------------------------------
    // Reset Chief if this carriage is carrying him.
    // --------------------------------------------

    if (payload_type == 1)
    {
        if (instance_exists(chain))
        {
            var attached_chief = chain.payload;

            if (instance_exists(attached_chief))
            {
                attached_chief.reset_chief();
            }
        }
    }


    // --------------------------------------------
    // Destroy attached chain
    // --------------------------------------------

    if (instance_exists(chain))
    {
        with (chain)
        {
            instance_destroy();
        }
    }

    chain = noone;


    // --------------------------------------------
    // Reset activation
    // --------------------------------------------

    activated = false;
    entrance_complete = false;

    carriage_state = 0;

    entrance_timer = 0;


    // --------------------------------------------
    // Reset position
    // --------------------------------------------

    x = start_x;
    y = start_y;

    prev_x = x;
    prev_y = y;

    dx = 0;
    dy = 0;


    // --------------------------------------------
    // Reset movement
    // --------------------------------------------

    current_speed = 0;
    target_x = x;


    // --------------------------------------------
    // Reset attachment position
    // --------------------------------------------

    attachment_x = x + chain_offset_x;
    attachment_y = y + chain_offset_y;


    // --------------------------------------------
    // Reset visuals
    // --------------------------------------------

    image_index = 0;

    visible = false;
};