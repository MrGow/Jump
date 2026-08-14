/// oGame — Step

scr_settings_init();


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "teleport_vortex_sprite"))
{
    teleport_vortex_sprite =
        asset_get_index(
            "spriteTeleportVortex"
        );
}

if (!variable_instance_exists(id, "teleport_vortex_state"))
{
    teleport_vortex_state =
        "none";
}

if (!variable_instance_exists(id, "teleport_vortex_alpha"))
{
    teleport_vortex_alpha =
        0;
}

if (!variable_instance_exists(id, "teleport_vortex_frame"))
{
    teleport_vortex_frame =
        0;
}

if (!variable_instance_exists(id, "teleport_vortex_fade_in_frames"))
{
    teleport_vortex_fade_in_frames =
        18;
}

if (!variable_instance_exists(id, "teleport_vortex_hold_frames"))
{
    teleport_vortex_hold_frames =
        120;
}

if (!variable_instance_exists(id, "teleport_vortex_fade_out_frames"))
{
    teleport_vortex_fade_out_frames =
        24;
}

if (!variable_instance_exists(id, "teleport_vortex_hold_timer"))
{
    teleport_vortex_hold_timer =
        0;
}

if (!variable_instance_exists(id, "teleport_room_change_done"))
{
    teleport_room_change_done =
        false;
}

if (!variable_instance_exists(id, "teleport_transition_room"))
{
    teleport_transition_room =
        -1;
}

if (!variable_instance_exists(id, "teleport_transition_arrival"))
{
    teleport_transition_arrival =
        "";
}


// ====================================================
// KEEP VORTEX ANIMATION SPEED CURRENT
// ====================================================

teleport_vortex_anim_speed =
    0;

if (teleport_vortex_sprite != -1)
{
    teleport_vortex_anim_speed =
        sprite_get_speed(
            teleport_vortex_sprite
        )
        /
        room_speed;
}


// ====================================================
// RECEIVE TELEPORT REQUEST
// ====================================================

if (
    teleport_vortex_state == "none"
    &&
    variable_global_exists(
        "teleport_transition_request"
    )
    &&
    global.teleport_transition_request
)
{
    global.teleport_transition_request =
        false;


    teleport_transition_room =
        global.teleport_transition_target_room;


    teleport_transition_arrival =
        global.teleport_transition_arrival_id;


    global.teleport_transition_target_room =
        -1;


    global.teleport_transition_arrival_id =
        "";


    global.teleport_arrival_ready =
        false;


    teleport_room_change_done =
        false;


    teleport_vortex_frame =
        0;


    teleport_vortex_alpha =
        0;


    teleport_vortex_state =
        "fade_in";


    // Freeze gameplay throughout transition.
    global.game_phase =
        "menu";
}


// ====================================================
// ADVANCE VORTEX ANIMATION
// ====================================================

if (
    teleport_vortex_state != "none"
    &&
    teleport_vortex_sprite != -1
)
{
    teleport_vortex_frame +=
        teleport_vortex_anim_speed;


    var vortex_frames =
        sprite_get_number(
            teleport_vortex_sprite
        );


    if (vortex_frames > 0)
    {
        while (
            teleport_vortex_frame >=
            vortex_frames
        )
        {
            teleport_vortex_frame -=
                vortex_frames;
        }
    }
}


// ====================================================
// VORTEX FADE IN
// ====================================================

if (teleport_vortex_state == "fade_in")
{
    teleport_vortex_alpha +=
        1
        /
        max(
            1,
            teleport_vortex_fade_in_frames
        );


    if (teleport_vortex_alpha >= 1)
    {
        teleport_vortex_alpha =
            1;


        // --------------------------------------------
        // CHANGE ROOM UNDER FULL VORTEX
        // --------------------------------------------

        if (
            !teleport_room_change_done
            &&
            teleport_transition_room != -1
        )
        {
            teleport_room_change_done =
                true;


            global.teleport_arrival_pending =
                true;


            global.teleport_target_room =
                teleport_transition_room;


            global.teleport_target_arrival_id =
                teleport_transition_arrival;


            room_goto(
                teleport_transition_room
            );
        }


        teleport_vortex_state =
            "hold";


        teleport_vortex_hold_timer =
            teleport_vortex_hold_frames;
    }
}


// ====================================================
// FULL VORTEX HOLD
// ====================================================

else if (teleport_vortex_state == "hold")
{
    teleport_vortex_alpha =
        1;


    // Don't start counting down until destination
    // arrival object has placed the player.
    if (
        variable_global_exists(
            "teleport_arrival_ready"
        )
        &&
        global.teleport_arrival_ready
    )
    {
        teleport_vortex_hold_timer--;


        if (
            teleport_vortex_hold_timer <= 0
        )
        {
            teleport_vortex_state =
                "fade_out";
        }
    }
}


// ====================================================
// VORTEX FADE OUT
// ====================================================

else if (teleport_vortex_state == "fade_out")
{
    teleport_vortex_alpha -=
        1
        /
        max(
            1,
            teleport_vortex_fade_out_frames
        );


    if (teleport_vortex_alpha <= 0)
    {
        teleport_vortex_alpha =
            0;


        teleport_vortex_state =
            "none";


        teleport_room_change_done =
            false;


        teleport_transition_room =
            -1;


        teleport_transition_arrival =
            "";


        global.teleport_arrival_ready =
            false;


        // Destination is fully visible.
        global.game_phase =
            "playing";
    }
}


// ====================================================
// BORDERLESS RE-APPLY
// ====================================================

if (global.borderless_reapply_frames > 0)
{
    if (
        global.display_mode_labels[
            global.display_mode_index
        ]
        ==
        "borderless"
    )
    {
        var dx = 0;
        var dy = 0;

        var dw =
            display_get_width();

        var dh =
            display_get_height();


        window_set_fullscreen(false);

        window_set_showborder(false);

        window_set_position(
            dx,
            dy
        );

        window_set_size(
            dw,
            dh
        );
    }


    global.borderless_reapply_frames--;
}


// ====================================================
// F11
// ====================================================

if (keyboard_check_pressed(vk_f11))
{
    if (
        global.display_mode_labels[
            global.display_mode_index
        ]
        ==
        "fullscreen"
    )
    {
        global.display_mode_index =
            0;
    }
    else
    {
        global.display_mode_index =
            1;
    }


    scr_settings_apply_display_mode();
}


// ====================================================
// ALT + ENTER
// ====================================================

var alt_down =
    keyboard_check(
        vk_alt
    );


if (
    alt_down
    &&
    keyboard_check_pressed(
        vk_enter
    )
)
{
    if (
        global.display_mode_labels[
            global.display_mode_index
        ]
        ==
        "fullscreen"
    )
    {
        global.display_mode_index =
            0;
    }
    else
    {
        global.display_mode_index =
            1;
    }


    scr_settings_apply_display_mode();
}


// ====================================================
// PAUSE
//
// Disabled during vortex transition.
// ====================================================

if (teleport_vortex_state == "none")
{
    var kb_pause_pressed =
        keyboard_check_pressed(
            vk_escape
        )
        ||
        keyboard_check_pressed(
            ord("P")
        );


    var inp_pause_pressed =
        variable_global_exists(
            "inp_pause_press"
        )
        &&
        global.inp_pause_press;


    var pause_pressed =
        kb_pause_pressed
        ||
        inp_pause_pressed;


    if (pause_toggle_cooldown > 0)
    {
        pause_toggle_cooldown--;
    }


    if (
        pause_pressed
        &&
        pause_toggle_cooldown <= 0
    )
    {
        if (!variable_global_exists("game_phase"))
        {
            global.game_phase =
                "playing";
        }


        if (global.game_phase == "playing")
        {
            if (!instance_exists(oPauseMenu))
            {
                instance_create_depth(
                    0,
                    0,
                    -1000000,
                    oPauseMenu
                );


                pause_toggle_cooldown =
                    15;
            }
        }


        else if (global.game_phase == "paused")
        {
            if (instance_exists(oPauseMenu))
            {
                with (oPauseMenu)
                {
                    instance_destroy();
                }
            }


            global.game_phase =
                "playing";


            pause_toggle_cooldown =
                15;
        }
    }
}
else
{
    pause_toggle_cooldown =
        max(
            pause_toggle_cooldown,
            2
        );
}