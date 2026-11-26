
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
// FORMATION TRANSITION SAFETY
// ====================================================

if (!variable_instance_exists(id, "formation_was_active"))
{
    formation_was_active = false;
}

if (!variable_instance_exists(id, "formation_blend_offset"))
{
    formation_blend_offset = 0;
}

if (!variable_instance_exists(id, "formation_blend_frame"))
{
    formation_blend_frame = 0;
}

if (!variable_instance_exists(id, "formation_blend_seconds"))
{
    formation_blend_seconds = 0.4;
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

if (!controller.boss_active)
{
    formation_was_active = false;
    formation_blend_offset = 0;
    formation_blend_frame = 0;

    exit;
}


// ====================================================
// BEGIN ENTRANCE
// ====================================================

if (!activated)
{
    formation_was_active = false;
    formation_blend_offset = 0;
    formation_blend_frame = 0;

    begin_entrance();
}


// ====================================================
// ENTRANCE DELAY
// ====================================================

if (carriage_state == 1)
{
    entrance_timer--;

    if (entrance_timer > 0)
    {
        exit;
    }

    carriage_state = 2;

    visible = true;
}


// ====================================================
// SHARED FORMATION MOVEMENT
//
// Smoothly transition from independent movement
// into the controller's shared formation.
// ====================================================

if (
    carriage_state == 3 &&
    entrance_complete &&
    controller.formation_active &&
    instance_exists(controller.platform)
)
{
    target_x =
        get_elevator_target() +
        controller.formation_offset_x;


    // --------------------------------------------
    // Capture initial positional difference.
    //
    // This prevents snapping on the first frame
    // of shared formation movement.
    // --------------------------------------------

    if (!formation_was_active)
    {
        formation_was_active = true;

        formation_blend_offset =
            x - target_x;

        formation_blend_frame = 0;
    }


    // --------------------------------------------
    // Smooth formation handover
    // --------------------------------------------

    var blend_frames = max(
        1,
        round(
            formation_blend_seconds *
            room_speed
        )
    );

    var blend_t = clamp(
        formation_blend_frame /
        blend_frames,
        0,
        1
    );

    var blend_eased =
        blend_t *
        blend_t *
        (3 - 2 * blend_t);

    var remaining_offset = lerp(
        formation_blend_offset,
        0,
        blend_eased
    );


    // --------------------------------------------
    // Apply shared movement with temporary offset
    // --------------------------------------------

    x =
        target_x +
        remaining_offset;

    if (formation_blend_frame < blend_frames)
    {
        formation_blend_frame++;
    }
    else
    {
        formation_blend_offset = 0;
    }


    // --------------------------------------------
    // Update position and movement
    // --------------------------------------------

    y = start_y;

    dx = x - prev_x;
    dy = y - prev_y;

    current_speed = dx;


    // --------------------------------------------
    // Update chain attachment
    // --------------------------------------------

    attachment_x =
        x + chain_offset_x;

    attachment_y =
        y + chain_offset_y;

    exit;
}


// ====================================================
// RESET FORMATION HANDOVER
// ====================================================

formation_was_active = false;
formation_blend_offset = 0;
formation_blend_frame = 0;


// ====================================================
// UPDATE NORMAL ELEVATOR TARGET
// ====================================================

if (
    carriage_state == 2 ||
    carriage_state == 3
)
{
    target_x =
        get_elevator_target();
}


// ====================================================
// NORMAL CARRIAGE MOVEMENT
// ====================================================

if (
    carriage_state == 2 ||
    carriage_state == 3 ||
    carriage_state == 4
)
{
    var distance_x =
        target_x - x;

    var speed_limit =
        movement_speed;

    if (carriage_state == 2)
    {
        speed_limit =
            entrance_speed;
    }


    // --------------------------------------------
    // Calculate braking speed
    // --------------------------------------------

    var braking_speed = sqrt(
        2 *
        deceleration *
        abs(distance_x)
    );

    var desired_speed =
        sign(distance_x) *
        min(
            speed_limit,
            braking_speed
        );


    // --------------------------------------------
    // Acceleration / deceleration
    // --------------------------------------------

    var speed_change =
        acceleration;

    if (
        abs(desired_speed) <
        abs(current_speed) ||

        desired_speed *
        current_speed < 0
    )
    {
        speed_change =
            deceleration;
    }

    current_speed += clamp(
        desired_speed - current_speed,
        -speed_change,
        speed_change
    );


    // --------------------------------------------
    // Apply movement
    // --------------------------------------------

    if (
        abs(distance_x) <= 0.1 ||

        (
            sign(current_speed) ==
            sign(distance_x) &&

            abs(current_speed) >=
            abs(distance_x)
        )
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
    // Entrance completion
    //
    // Preserve the previous 8-pixel tolerance.
    // --------------------------------------------

    if (carriage_state == 2)
    {
        if (
            abs(target_x - x) <= 8
        )
        {
            entrance_complete = true;

            carriage_state = 3;

            show_debug_message(
                "Scrap Chief: Carriage " +
                string(carriage_id) +
                " entrance complete."
            );
        }
    }
    else if (carriage_state == 4)
    {
        if (
            abs(target_x - x) <= 0.1
        )
        {
            carriage_state = 5;
        }
    }
}


// ====================================================
// VERTICAL POSITION
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

attachment_x =
    x + chain_offset_x;

attachment_y =
    y + chain_offset_y;
