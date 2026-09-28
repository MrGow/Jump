/// oMissileLauncher — Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// UPDATE AUTHORED POSITIONS
//
// Allows the launcher to be moved in the room editor
// without baking world coordinates into Create.
// ====================================================

plate_x =
    x +
    direction *
    plate_offset_x;

plate_y =
    y;


// ====================================================
// FIND PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


// ====================================================
// PRESSURE PLATE TRIGGER
// ====================================================

player_on_plate = false;

if (instance_exists(p))
{
    var _player_alive =
        true;

    if (
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead"
    )
    {
        _player_alive =
            false;
    }


    if (_player_alive)
    {
        var _trigger_half_width =
            (
                plate_width *
                plate_trigger_width_scale
            )
            * 0.5;

        var _trigger_left =
            plate_x -
            _trigger_half_width;

        var _trigger_right =
            plate_x +
            _trigger_half_width;


        // Plate's gameplay surface remains fixed even
        // though the artwork moves down 3 pixels.
        var _plate_top =
            plate_y -
            plate_height * 0.5;

        var _trigger_top =
            _plate_top -
            plate_trigger_height;

        var _trigger_bottom =
            _plate_top +
            3;


        var _horizontal_overlap =
            p.bbox_right >
                _trigger_left
            &&
            p.bbox_left <
                _trigger_right;


        var _feet_inside =
            p.bbox_bottom >=
                _trigger_top
            &&
            p.bbox_bottom <=
                _trigger_bottom;


        player_on_plate =
            _horizontal_overlap
            &&
            _feet_inside;
    }
}


// ====================================================
// REARM RELEASE
// ====================================================

if (
    needs_plate_release &&
    !player_on_plate
)
{
    needs_plate_release =
        false;
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
    plate_visual_target =
        0;
}


// ====================================================
// SMOOTH 3PX PRESS
// ====================================================

plate_visual_offset =
    lerp(
        plate_visual_offset,
        plate_visual_target,
        plate_visual_lerp
    );

if (
    abs(
        plate_visual_offset -
        plate_visual_target
    )
    < 0.05
)
{
    plate_visual_offset =
        plate_visual_target;
}


// ====================================================
// PRESSURE PLATE SPRITE ANIMATION
// ====================================================

var _plate_last_frame =
    max(
        0,
        sprite_get_number(
            spritePressurePlate
        )
        - 1
    );

if (
    player_on_plate &&
    !needs_plate_release
)
{
    plate_anim_position =
        min(
            _plate_last_frame,
            plate_anim_position +
            plate_anim_speed
        );
}
else
{
    plate_anim_position =
        max(
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

    show_launch_bar =
        false;


    if (
        player_on_plate &&
        !needs_plate_release
    )
    {
        missile_state =
            MISSILE_CHARGING;

        show_launch_bar =
            true;
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


    // ------------------------------------------------
    // PLAYER REMAINS ON PLATE
    // ------------------------------------------------

    if (
        player_on_plate &&
        !needs_plate_release
    )
    {
        launch_progress =
            min(
                1,
                launch_progress +
                charge_per_frame
            );


        // ============================================
        // FULLY CHARGED
        // ============================================

        if (launch_progress >= 1)
        {
            launch_progress = 1;

            show_launch_bar =
                false;

            missile_state =
                MISSILE_OPENING;

            launcher_anim_position =
                launcher_closed_frame;

            missile_fired =
                false;

            // From this point onward the launch is
            // committed. Player may leave.
            needs_plate_release =
                true;
        }
    }


    // ------------------------------------------------
    // PLAYER STEPPED OFF
    // ------------------------------------------------

    else
    {
        show_launch_bar =
            false;

        launch_progress =
            max(
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

        open_hold_timer =
            max(
                1,
                round(
                    launcher_open_hold_s *
                    room_speed
                )
            );

        missile_fired =
            false;
    }
    else
    {
        image_index =
            floor(
                launcher_anim_position
            );
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


    // ------------------------------------------------
    // SPAWN MISSILE ONCE
    // ------------------------------------------------

    if (!missile_fired)
    {
        missile_fired =
            true;


        // Missile begins inside / just above silo.
        var _missile_spawn_x =
            x;

        var _missile_spawn_y =
            y -
            launcher_height * 0.20;


        var _missile =
            instance_create_layer(
                _missile_spawn_x,
                _missile_spawn_y,
                "Instances",
                oMissile
            );

        if (instance_exists(_missile))
        {
            _missile.launch_speed =
                missile_speed;

            _missile.owner_launcher =
                id;
        }
    }


    // ------------------------------------------------
    // HOLD OPEN BRIEFLY
    // ------------------------------------------------

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

        reset_timer =
            max(
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
            floor(
                launcher_anim_position
            );
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


    // ------------------------------------------------
    // DRAIN CABLE AFTER FIRING
    // ------------------------------------------------

    launch_progress =
        max(
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

        // Return to the initial closed frame for the
        // next opening sequence.
        launcher_anim_position =
            launcher_closed_frame;

        image_index =
            launcher_closed_frame;

        missile_fired =
            false;
    }

    exit;
}