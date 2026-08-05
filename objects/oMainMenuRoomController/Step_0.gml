/// oMainMenuRoomController — Step

global.game_phase = "main_menu";
global.menu_demo_active = true;

scr_settings_apply_audio_gains();


// ====================================================
// KEEP CAMERA FIXED
// ====================================================

var cam =
    view_camera[0];

camera_set_view_size(
    cam,
    640,
    360
);

camera_set_view_pos(
    cam,
    0,
    0
);


// ====================================================
// REMOVE DEATH MENU
// ====================================================

if (instance_exists(oDeathMenu))
{
    with (oDeathMenu)
    {
        instance_destroy();
    }
}


// ====================================================
// DEFAULT DEMO INPUT
// ====================================================

global.menu_demo_left      = false;
global.menu_demo_right     = false;
global.menu_demo_jump_held = false;


// ====================================================
// FIND DEMO PLAYER
// ====================================================

if (!instance_exists(oPlayer))
{
    exit;
}

var p =
    instance_find(
        oPlayer,
        0
    );

p.debug_draw = false;


// ====================================================
// DEAD PLAYER
// ====================================================

if (p.state == "dead")
{
    demo_state = 2;

    demo_death_timer++;

    if (
        demo_death_timer >=
        demo_death_wait_frames
    )
    {
        demo_reset_player();
    }

    exit;
}


// ====================================================
// RUNNING DEMO
// ====================================================

if (demo_state == 0)
{
    demo_timer++;

    // Continually travel toward the right edge.
    global.menu_demo_right = true;


    // ------------------------------------------------
    // Detect whether the player is grounded
    // ------------------------------------------------

    var player_grounded = false;

    if (
        variable_instance_exists(
            p,
            "standing_platform"
        ) &&
        instance_exists(
            p.standing_platform
        )
    )
    {
        player_grounded = true;
    }
    else if (
        variable_instance_exists(
            p,
            "prev_on_ground"
        ) &&
        p.prev_on_ground
    )
    {
        player_grounded = true;
    }


    // ------------------------------------------------
    // Currently charging a demo jump
    // ------------------------------------------------

    if (demo_jump_hold_timer > 0)
    {
        global.menu_demo_jump_held = true;

        demo_jump_hold_timer--;

        if (demo_jump_hold_timer <= 0)
        {
            // Releasing the input causes the actual jump.
            global.menu_demo_jump_held = false;
            demo_jump_releasing = true;
        }
    }


    // ------------------------------------------------
    // One-frame release period
    // ------------------------------------------------

    else if (demo_jump_releasing)
    {
        global.menu_demo_jump_held = false;

        demo_jump_releasing = false;

        // Advance to the next jump type.
        demo_jump_pattern_index =
            (
                demo_jump_pattern_index +
                1
            )
            mod
            array_length(
                demo_jump_holds
            );

        demo_jump_wait =
            demo_jump_delays[
                demo_jump_pattern_index
            ];
    }


    // ------------------------------------------------
    // Wait before the next jump
    // ------------------------------------------------

    else
    {
        if (demo_jump_wait > 0)
        {
            demo_jump_wait--;
        }

        // Only begin charging while genuinely grounded.
        if (
            demo_jump_wait <= 0 &&
            player_grounded
        )
        {
            demo_jump_hold_timer =
                demo_jump_holds[
                    demo_jump_pattern_index
                ];

            global.menu_demo_jump_held = true;
        }
    }


    // ------------------------------------------------
    // Player has moved fully offscreen
    // ------------------------------------------------

    var camera_right =
        camera_get_view_x(cam) +
        camera_get_view_width(cam);

    if (
        p.bbox_left >
        camera_right +
        demo_offscreen_margin
    )
    {
        demo_state = 1;

        demo_offscreen_timer = 0;

        global.menu_demo_right     = false;
        global.menu_demo_jump_held = false;
    }


    // ------------------------------------------------
    // Emergency reset if blocked or stuck
    // ------------------------------------------------

    if (demo_timer >= demo_max_time)
    {
        demo_reset_player();
    }
}


// ====================================================
// PLAYER IS OFFSCREEN
// ====================================================

else if (demo_state == 1)
{
    // No input while waiting beyond the screen.
    global.menu_demo_left      = false;
    global.menu_demo_right     = false;
    global.menu_demo_jump_held = false;

    demo_offscreen_timer++;

    if (
        demo_offscreen_timer >=
        demo_offscreen_wait_frames
    )
    {
        demo_reset_player();
    }
}