/// oGame — Step

scr_settings_init();


// ====================================================
// HOT-RELOAD SAFETY — DATA TRANSMISSION
// ====================================================

if (!variable_instance_exists(id, "teleport_static_state"))
{
    teleport_static_state =
        "none";
}

if (!variable_instance_exists(id, "teleport_static_progress"))
{
    teleport_static_progress =
        0;
}

if (!variable_instance_exists(id, "teleport_static_phase"))
{
    teleport_static_phase =
        0;
}

if (!variable_instance_exists(id, "teleport_static_refresh_frames"))
{
    teleport_static_refresh_frames =
        2;
}

if (!variable_instance_exists(id, "teleport_static_refresh_timer"))
{
    teleport_static_refresh_timer =
        teleport_static_refresh_frames;
}

if (!variable_instance_exists(id, "teleport_static_fade_in_frames"))
{
    teleport_static_fade_in_frames =
        60;
}

if (!variable_instance_exists(id, "teleport_static_hold_frames"))
{
    teleport_static_hold_frames =
        60;
}

if (!variable_instance_exists(id, "teleport_static_fade_out_frames"))
{
    teleport_static_fade_out_frames =
        44;
}

if (!variable_instance_exists(id, "teleport_static_hold_timer"))
{
    teleport_static_hold_timer =
        0;
}

if (!variable_instance_exists(id, "teleport_static_coarse_w"))
{
    teleport_static_coarse_w =
        20;
}

if (!variable_instance_exists(id, "teleport_static_coarse_h"))
{
    teleport_static_coarse_h =
        15;
}

if (!variable_instance_exists(id, "teleport_static_fine_w"))
{
    teleport_static_fine_w =
        8;
}

if (!variable_instance_exists(id, "teleport_static_fine_h"))
{
    teleport_static_fine_h =
        8;
}

if (!variable_instance_exists(id, "teleport_static_fine_density"))
{
    teleport_static_fine_density =
        0.30;
}

if (!variable_instance_exists(id, "teleport_static_outline_px"))
{
    teleport_static_outline_px =
        2;
}

if (!variable_instance_exists(id, "teleport_static_coarse_curve"))
{
    teleport_static_coarse_curve =
        2.10;
}

if (!variable_instance_exists(id, "teleport_static_fine_curve"))
{
    teleport_static_fine_curve =
        1.80;
}

if (!variable_instance_exists(id, "teleport_static_base_start"))
{
    teleport_static_base_start =
        0.78;
}

if (!variable_instance_exists(id, "teleport_static_scanline_gap"))
{
    teleport_static_scanline_gap =
        4;
}

if (!variable_instance_exists(id, "teleport_static_flash_alpha"))
{
    teleport_static_flash_alpha =
        0;
}

if (!variable_instance_exists(id, "teleport_static_flash_decay"))
{
    teleport_static_flash_decay =
        0.10;
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
// TELEPORT STATIC AUDIO — HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_teleporter_static_loop"))
{
    snd_teleporter_static_loop =
        asset_get_index(
            "TeleporterStaticLoop"
        );
}

if (!variable_instance_exists(id, "teleporter_static_loop_instance"))
{
    teleporter_static_loop_instance =
        -1;
}

if (!variable_instance_exists(id, "teleporter_static_loop_gain"))
{
    teleporter_static_loop_gain =
        0.62;
}


// ----------------------------------------------------
// Start / maintain helper
//
// IMPORTANT:
// Do NOT gate this behind audio_group_is_loaded().
// TeleporterStaticLoop may live in a different group,
// and the asset itself is all we need to validate.
// ----------------------------------------------------

teleporter_static_audio_start =
function()
{
    if (snd_teleporter_static_loop == -1)
    {
        return;
    }


    if (
        teleporter_static_loop_instance != -1
        &&
        audio_is_playing(
            teleporter_static_loop_instance
        )
    )
    {
        // Keep gain current in case settings changed.
        audio_sound_gain(
            teleporter_static_loop_instance,
            teleporter_static_loop_gain,
            0
        );

        return;
    }


    teleporter_static_loop_instance =
        audio_play_sound(
            snd_teleporter_static_loop,
            10,
            true
        );


    if (teleporter_static_loop_instance != -1)
    {
        audio_sound_gain(
            teleporter_static_loop_instance,
            teleporter_static_loop_gain,
            0
        );
    }
};


teleporter_static_audio_stop =
function()
{
    if (
        teleporter_static_loop_instance != -1
        &&
        audio_is_playing(
            teleporter_static_loop_instance
        )
    )
    {
        audio_stop_sound(
            teleporter_static_loop_instance
        );
    }


    teleporter_static_loop_instance =
        -1;
};


// Palette safety.
if (!variable_instance_exists(id, "teleport_static_col_deep"))
{
    teleport_static_col_deep =
        make_color_rgb(
            8,
            35,
            90
        );
}

if (!variable_instance_exists(id, "teleport_static_col_blue"))
{
    teleport_static_col_blue =
        make_color_rgb(
            20,
            100,
            205
        );
}

if (!variable_instance_exists(id, "teleport_static_col_cyan"))
{
    teleport_static_col_cyan =
        make_color_rgb(
            45,
            220,
            255
        );
}

if (!variable_instance_exists(id, "teleport_static_col_pale"))
{
    teleport_static_col_pale =
        make_color_rgb(
            170,
            245,
            255
        );
}

if (!variable_instance_exists(id, "teleport_static_col_white"))
{
    teleport_static_col_white =
        c_white;
}


// ====================================================
// RECEIVE TELEPORT REQUEST
// ====================================================

if (
    teleport_static_state == "none"
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


    teleport_static_progress =
        0;


    teleport_static_phase =
        0;


    teleport_static_refresh_timer =
        1;


    teleport_static_flash_alpha =
        0;


    teleport_static_state =
        "fade_in";


    // Start static loop at the exact moment the visual
    // transmission begins.
    teleporter_static_audio_start();


    // Freeze gameplay throughout transmission.
    global.game_phase =
        "menu";
}


// ====================================================
// KEEP STATIC AUDIO SYNCHRONIZED TO VISUAL STATE
// ====================================================

if (teleport_static_state != "none")
{
    teleporter_static_audio_start();
}
else
{
    teleporter_static_audio_stop();
}


// ====================================================
// REFRESH ANALOG/DIGITAL STATIC PATTERN
// ====================================================

if (teleport_static_state != "none")
{
    teleport_static_refresh_timer--;


    if (teleport_static_refresh_timer <= 0)
    {
        teleport_static_refresh_timer =
            max(
                1,
                teleport_static_refresh_frames
            );


        teleport_static_phase++;
    }
}


// ====================================================
// ROOM-SWAP FLASH DECAY
// ====================================================

if (teleport_static_flash_alpha > 0)
{
    teleport_static_flash_alpha =
        max(
            0,
            teleport_static_flash_alpha
            -
            teleport_static_flash_decay
        );
}


// ====================================================
// STATIC FADE IN
// ====================================================

if (teleport_static_state == "fade_in")
{
    teleport_static_progress +=
        1
        /
        max(
            1,
            teleport_static_fade_in_frames
        );


    if (teleport_static_progress >= 1)
    {
        teleport_static_progress =
            1;


        // --------------------------------------------
        // CHANGE ROOM ONLY WHEN TRANSMISSION COMPLETELY
        // COVERS THE OLD ROOM.
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


            // Bright data pulse exactly at transmission.
            teleport_static_flash_alpha =
                0.72;


            room_goto(
                teleport_transition_room
            );
        }


        teleport_static_state =
            "hold";


        teleport_static_hold_timer =
            teleport_static_hold_frames;
    }
}


// ====================================================
// FULL DATA TRANSMISSION HOLD
// ====================================================

else if (teleport_static_state == "hold")
{
    teleport_static_progress =
        1;


    // Do not consume the presentation hold until the
    // destination marker has actually placed JumpBot.
    if (
        variable_global_exists(
            "teleport_arrival_ready"
        )
        &&
        global.teleport_arrival_ready
    )
    {
        teleport_static_hold_timer--;


        if (teleport_static_hold_timer <= 0)
        {
            teleport_static_state =
                "fade_out";
        }
    }
}


// ====================================================
// DATA RECONSTRUCTION / FADE OUT
// ====================================================

else if (teleport_static_state == "fade_out")
{
    teleport_static_progress -=
        1
        /
        max(
            1,
            teleport_static_fade_out_frames
        );


    if (teleport_static_progress <= 0)
    {
        teleport_static_progress =
            0;


        teleport_static_state =
            "none";


        teleport_room_change_done =
            false;


        teleport_transition_room =
            -1;


        teleport_transition_arrival =
            "";


        global.teleport_arrival_ready =
            false;


        // Static is now completely gone.
        teleporter_static_audio_stop();


        // Destination is fully reconstructed.
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
// Disabled during:
//
// - data transmission
// - B1LL-E dialogue
// - codec
// - death/menu states
//
// Pause menu itself can still be closed normally.
// ====================================================

if (teleport_static_state == "none")
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


    // =================================================
    // CONTROLS REBIND SAFETY
    //
    // While listening for a binding, Escape/B belongs
    // to the Controls screen rather than the pause toggle.
    // ====================================================

    if (instance_exists(oPauseMenu))
    {
        var pause_menu_instance =
            instance_find(
                oPauseMenu,
                0
            );


        if (
            pause_menu_instance != noone &&
            variable_instance_exists(
                pause_menu_instance,
                "controls_rebinding"
            ) &&
            pause_menu_instance.controls_rebinding
        )
        {
            pause_pressed =
                false;
        }
    }


    // =================================================
    // COOLDOWN
    // ====================================================

    if (pause_toggle_cooldown > 0)
    {
        pause_toggle_cooldown--;
    }


    // =================================================
    // PAUSE TOGGLE
    // ====================================================

    if (
        pause_pressed &&
        pause_toggle_cooldown <= 0
    )
    {
        if (!variable_global_exists("game_phase"))
        {
            global.game_phase =
                "playing";
        }


        // =================================================
        // ALREADY PAUSED
        //
        // Closing an existing pause menu is always allowed.
        // ====================================================

        if (global.game_phase == "paused")
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


            scr_settings_apply_audio_gains();


            pause_toggle_cooldown =
                15;
        }


        // =================================================
        // OPEN PAUSE MENU
        //
        // Only allowed if no special scene currently owns
        // the player's input.
        // ====================================================

        else if (
            global.game_phase == "playing" &&
            !scr_pause_blocked()
        )
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


        // =================================================
        // BLOCKED
        //
        // Consume a tiny cooldown so holding/repeatedly
        // pressing pause cannot immediately trigger it on
        // the exact frame the dialogue finishes.
        // ====================================================

        else
        {
            pause_toggle_cooldown =
                max(
                    pause_toggle_cooldown,
                    2
                );
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

