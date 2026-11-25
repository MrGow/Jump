/// oScrapChiefRailCarriage — Step

// ====================================================
// PREVIOUS POSITION
// ====================================================

prev_x = x;
prev_y = y;

dx = 0;
dy = 0;


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// FIND CONTROLLER
// ====================================================

if (!instance_exists(controller))
{
    controller = instance_find(
        oScrapChiefController,
        0
    );
}

if (!instance_exists(controller))
{
    exit;
}


// ====================================================
// WAIT FOR BOSS ACTIVATION
// ====================================================

if (!controller.boss_active)
{
    exit;
}


// ====================================================
// BEGIN ENTRANCE
// ====================================================

if (!activated)
{
    begin_entrance();
}


// ====================================================
// ENTRANCE DELAY
// ====================================================

if (carriage_state == 1)
{
    if (entrance_timer > 0)
    {
        entrance_timer--;

        exit;
    }

    carriage_state = 2;

    visible = true;
}


// ====================================================
// UPDATE TARGET POSITION
// ====================================================

if (
    carriage_state == 2 ||
    carriage_state == 3
)
{
    target_x = get_elevator_target();
}


// ====================================================
// MOVEMENT
// ====================================================

if (
    carriage_state == 2 ||
    carriage_state == 3 ||
    carriage_state == 4
)
{
    var distance_x = target_x - x;

    var speed_limit = movement_speed;

    if (carriage_state == 2)
    {
        speed_limit = entrance_speed;
    }


    // --------------------------------------------
    // Calculate braking speed
    // --------------------------------------------

    var braking_speed = sqrt(
        2 * deceleration * abs(distance_x)
    );

    var desired_speed =
        sign(distance_x) *
        min(speed_limit, braking_speed);


    // --------------------------------------------
    // Acceleration / deceleration
    // --------------------------------------------

    var speed_change = acceleration;

    if (
        abs(desired_speed) < abs(current_speed) ||
        current_speed * desired_speed < 0
    )
    {
        speed_change = deceleration;
    }

    current_speed += clamp(
        desired_speed - current_speed,
        -speed_change,
        speed_change
    );


    // --------------------------------------------
    // Prevent overshooting
    // --------------------------------------------

    if (abs(distance_x) <= 0.1)
    {
        x = target_x;

        current_speed = 0;
    }
    else if (
        sign(current_speed) == sign(distance_x) &&
        abs(current_speed) >= abs(distance_x)
    )
    {
        x = target_x;

        current_speed = 0;
    }
    else
    {
        x += current_speed;
    }


    // --------------------------------------------
    // Arrival
    // --------------------------------------------

    if (abs(target_x - x) <= 0.1)
    {
        if (carriage_state == 2)
        {
            entrance_complete = true;

            carriage_state = 3;
        }
        else if (carriage_state == 4)
        {
            carriage_state = 5;
        }
    }
}


// ====================================================
// LOCK VERTICAL POSITION TO RAIL
// ====================================================

y = start_y;


// ====================================================
// MOVEMENT DELTAS
// ====================================================

dx = x - prev_x;
dy = y - prev_y;


// ====================================================
// UPDATE CHAIN ATTACHMENT
// ====================================================

attachment_x = x + chain_offset_x;
attachment_y = y + chain_offset_y;