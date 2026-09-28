/// oMissileLauncher — Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// 100% TEXT HOLD
// ====================================================

if (launch_ui_hold_timer > 0)
{
    launch_ui_hold_timer--;
}


// ====================================================
// UPDATE AUTHORED POSITIONS
// ====================================================

plate_x =
    x +
    direction * plate_offset_x;

plate_y = y;


// ====================================================
// POSITION THE PHYSICAL SOLIDS
// ====================================================

if (instance_exists(silo_solid))
{
    silo_solid.dx =
        x - silo_solid.x;

    silo_solid.dy =
        y - silo_solid.y;

    silo_solid.x = x;
    silo_solid.y = y;
}

if (instance_exists(plate_solid))
{
    var plate_target_x = plate_x;

    var plate_target_y =
        plate_y +
        plate_visual_offset;

    plate_solid.dx =
        plate_target_x -
        plate_solid.x;

    plate_solid.dy =
        plate_target_y -
        plate_solid.y;

    plate_solid.x =
        plate_target_x;

    plate_solid.y =
        plate_target_y;
}


// ====================================================
// FIND PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);


// ====================================================
// PRESSURE PLATE TRIGGER
//
// Read the physical plate's actual top. The helper and
// the artwork move together through the 3 px press.
// ====================================================

player_on_plate = false;

if (
    instance_exists(p) &&
    instance_exists(plate_solid)
)
{
    var player_alive = true;

    if (
        variable_instance_exists(p, "state") &&
        p.state == "dead"
    )
    {
        player_alive = false;
    }

    if (player_alive)
    {
        var trigger_half_width =
            plate_width
            *
            plate_trigger_width_scale
            *
            0.5;

        var trigger_left =
            plate_solid.x -
            trigger_half_width;

        var trigger_right =
            plate_solid.x +
            trigger_half_width;

        var surface_top =
            plate_solid.bbox_top;

        var trigger_top =
            surface_top -
            plate_trigger_height;

        // Small tolerance while player/plate Step events
        // run in their respective instance order.
        var trigger_bottom =
            surface_top +
            4;

        var horizontal_overlap =
            p.bbox_right >
                trigger_left
            &&
            p.bbox_left <
                trigger_right;

        var feet_on_surface =
            p.bbox_bottom >=
                trigger_top
            &&
            p.bbox_bottom <=
                trigger_bottom;

        player_on_plate =
            horizontal_overlap
            &&
            feet_on_surface
            &&
            p.vsp >= 0;
    }
}


// ====================================================
// REARM RELEASE
//
// Following a launch, the player must leave the plate
// before it can charge another missile.
// ====================================================

if (
    needs_plate_release &&
    !player_on_plate
)
{
    needs_plate_release = false;
}


// ====================================================
// PRESSURE PLATE VISUAL TARGET
// ====================================================

if (
    player_on_plate &&
    !needs_plate_release
)
{
    plate_visual_target =
        plate_press_depth;
}
else
{
    plate_visual_target = 0;
}


// ====================================================
// SMOOTH 3 PX PRESS
// ====================================================

plate_visual_offset = lerp(
    plate_visual_offset,
    plate_visual_target,
    plate_visual_lerp
);

if (
    abs(
        plate_visual_offset -
        plate_visual_target
    ) < 0.05
)
{
    plate_visual_offset =
        plate_visual_target;
}


// ----------------------------------------------------
// The target may have changed this frame. Move the
// solid to the artwork's NEW position and accumulate
// its movement for oPlayer's surface carry.
// ----------------------------------------------------

if (instance_exists(plate_solid))
{
    var new_plate_x =
        plate_x;

    var new_plate_y =
        plate_y +
        plate_visual_offset;

    plate_solid.dx +=
        new_plate_x -
        plate_solid.x;

    plate_solid.dy +=
        new_plate_y -
        plate_solid.y;

    plate_solid.x =
        new_plate_x;

    plate_solid.y =
        new_plate_y;
}


// ====================================================
// PRESSURE PLATE SPRITE ANIMATION
// ====================================================

var plate_last_frame = max(
    0,
    sprite_get_number(spritePressurePlate) - 1
);

if (
    player_on_plate &&
    !needs_plate_release
)
{
    plate_anim_position = min(
        plate_last_frame,
        plate_anim_position +
        plate_anim_speed
    );
}
else
{
    plate_anim_position = max(
        0,
        plate_anim_position -
        plate_anim_speed
    );
}


// ====================================================
// CABLE PULSE
// ====================================================

cable_power_pulse += 0.12;


// ====================================================
// READY
// ====================================================

if (missile_state == MISSILE_READY)
{
    image_index =
        launcher_closed_frame;

    launcher_anim_position =
        launcher_closed_frame;

    show_launch_bar = false;

    if (
        player_on_plate &&
        !needs_plate_release
    )
    {
        missile_state =
            MISSILE_CHARGING;

        show_launch_bar = true;
    }

    exit;
}


// ====================================================
// CHARGING
// ====================================================

if (missile_state == MISSILE_CHARGING)
{
    image_index =
        launcher_closed_frame;

    show_launch_bar =
        player_on_plate;

    if (
        player_on_plate &&
        !needs_plate_release
    )
    {
        launch_progress = min(
            1,
            launch_progress +
            charge_per_frame
        );

        if (launch_progress >= 1)
        {
            launch_progress = 1;
            show_launch_bar = false;

            // Draw GUI shows 100% while the silo opens.
            launch_ui_hold_timer =
                round(room_speed * 0.45);

            missile_state =
                MISSILE_OPENING;

            launcher_anim_position =
                launcher_closed_frame;

            missile_fired = false;

            // Launch is committed. Player can leave.
            needs_plate_release = true;
        }
    }
    else
    {
        show_launch_bar = false;

        launch_progress = max(
            0,
            launch_progress -
            drain_per_frame
        );

        if (launch_progress <= 0)
        {
            launch_progress = 0;

            missile_state =
                MISSILE_READY;
        }
    }

    exit;
}


// ====================================================
// OPENING
//
// Closed frame 0 -> open frame 2.
// ====================================================

if (missile_state == MISSILE_OPENING)
{
    launcher_anim_position +=
        launcher_anim_speed;

    if (
        launcher_anim_position >=
        launcher_open_frame
    )
    {
        launcher_anim_position =
            launcher_open_frame;

        image_index =
            launcher_open_frame;

        missile_state =
            MISSILE_FIRING;

        open_hold_timer = max(
            1,
            round(
                launcher_open_hold_s *
                room_speed
            )
        );

        missile_fired = false;
    }
    else
    {
        image_index =
            floor(launcher_anim_position);
    }

    exit;
}


// ====================================================
// OPEN / FIRE
// ====================================================

if (missile_state == MISSILE_FIRING)
{
    image_index =
        launcher_open_frame;

    if (!missile_fired)
    {
        missile_fired = true;

        var missile_spawn_x =
            x;

        var missile_spawn_y =
            y -
            launcher_height * 0.20;

        var missile = instance_create_layer(
            missile_spawn_x,
            missile_spawn_y,
            "Instances",
            oMissile
        );

        if (instance_exists(missile))
        {
            missile.launch_speed =
                missile_speed;

            missile.owner_launcher =
                id;
        }
    }

    open_hold_timer--;

    if (open_hold_timer <= 0)
    {
        missile_state =
            MISSILE_CLOSING;

        launcher_anim_position =
            launcher_open_frame;
    }

    exit;
}


// ====================================================
// CLOSING
//
// Open frame 2 -> frames 3 -> 4.
// ====================================================

if (missile_state == MISSILE_CLOSING)
{
    launcher_anim_position +=
        launcher_anim_speed;

    if (
        launcher_anim_position >=
        launcher_final_closed_frame
    )
    {
        launcher_anim_position =
            launcher_final_closed_frame;

        image_index =
            launcher_final_closed_frame;

        missile_state =
            MISSILE_RESET;

        reset_timer = max(
            1,
            round(
                reset_time_s *
                room_speed
            )
        );
    }
    else
    {
        image_index =
            floor(launcher_anim_position);
    }

    exit;
}


// ====================================================
// RESET
// ====================================================

if (missile_state == MISSILE_RESET)
{
    image_index =
        launcher_final_closed_frame;

    launch_progress = max(
        0,
        launch_progress -
        drain_per_frame
    );

    reset_timer--;

    if (
        reset_timer <= 0 &&
        launch_progress <= 0
    )
    {
        launch_progress = 0;

        missile_state =
            MISSILE_READY;

        launcher_anim_position =
            launcher_closed_frame;

        image_index =
            launcher_closed_frame;

        missile_fired = false;
    }

    exit;
}