/// oGame — Step

scr_settings_init();


// ====================================================
// RECEIVE TELEPORT FADE REQUEST
// ====================================================

if (
    teleport_fade_state == "none"
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


    teleport_fade_state =
        "fade_out";

    teleport_fade_alpha =
        0;

    teleport_room_change_done =
        false;


    // Your current oPlayer freezes during "menu".
    // This keeps the player frozen across both rooms.
    global.game_phase =
        "menu";
}


// ====================================================
// FADE OUT
// ====================================================

if (teleport_fade_state == "fade_out")
{
    teleport_fade_alpha +=
        1 /
        max(
            1,
            teleport_fade_out_frames
        );


    if (teleport_fade_alpha >= 1)
    {
        teleport_fade_alpha =
            1;


        teleport_fade_state =
            "black_hold";


        teleport_black_timer =
            teleport_black_hold_frames;


        // --------------------------------------------
        // CHANGE ROOM ONLY UNDER FULL BLACK
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
    }
}


// ====================================================
// FULL BLACK
// ====================================================

else if (teleport_fade_state == "black_hold")
{
    teleport_fade_alpha =
        1;


    // Don't reveal destination until its arrival object
    // has actually positioned the player.
    if (global.teleport_arrival_ready)
    {
        teleport_black_timer--;


        if (teleport_black_timer <= 0)
        {
            teleport_fade_state =
                "fade_in";
        }
    }
}


// ====================================================
// FADE INTO DESTINATION
// ====================================================

else if (teleport_fade_state == "fade_in")
{
    teleport_fade_alpha -=
        1 /
        max(
            1,
            teleport_fade_in_frames
        );


    if (teleport_fade_alpha <= 0)
    {
        teleport_fade_alpha =
            0;


        teleport_fade_state =
            "none";


        teleport_room_change_done =
            false;


        teleport_transition_room =
            -1;

        teleport_transition_arrival =
            "";


        global.teleport_arrival_ready =
            false;


        // Restore gameplay only after fully visible.
        global.game_phase =
            "playing";
    }
}


// ====================================================
// BORDERLESS RE-APPLY
// ====================================================

if (global.borderless_reapply_frames > 0)
{
    if (global.display_mode_labels[global.display_mode_index] == "borderless")
    {
        var dx = 0;
        var dy = 0;
        var dw = display_get_width();
        var dh = display_get_height();

        window_set_fullscreen(false);
        window_set_showborder(false);
        window_set_position(dx, dy);
        window_set_size(dw, dh);
    }

    global.borderless_reapply_frames--;
}


// ====================================================
// F11
// ====================================================

if (keyboard_check_pressed(vk_f11))
{
    if (global.display_mode_labels[global.display_mode_index] == "fullscreen") {
        global.display_mode_index = 0;
    } else {
        global.display_mode_index = 1;
    }

    scr_settings_apply_display_mode();
}


// ====================================================
// ALT + ENTER
// ====================================================

var alt_down =
    keyboard_check(vk_alt);

if (
    alt_down
    &&
    keyboard_check_pressed(vk_enter)
)
{
    if (global.display_mode_labels[global.display_mode_index] == "fullscreen") {
        global.display_mode_index = 0;
    } else {
        global.display_mode_index = 1;
    }

    scr_settings_apply_display_mode();
}


// ====================================================
// PAUSE
//
// Disabled during teleporter transition.
// ====================================================

if (teleport_fade_state == "none")
{
    var kb_pause_pressed =
        keyboard_check_pressed(vk_escape)
        ||
        keyboard_check_pressed(ord("P"));


    var inp_pause_pressed =
        variable_global_exists("inp_pause_press")
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
            global.game_phase = "playing";
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
    // Prevent a stored pause press firing immediately
    // after fade completes.
    pause_toggle_cooldown =
        max(
            pause_toggle_cooldown,
            2
        );
}