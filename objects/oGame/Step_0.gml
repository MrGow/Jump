/// oGame — Step

scr_settings_init();

// Re-apply borderless for a few frames because GameMaker can resize late
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

// F11 cycles between windowed and fullscreen only
if (keyboard_check_pressed(vk_f11))
{
    if (global.display_mode_labels[global.display_mode_index] == "fullscreen") {
        global.display_mode_index = 0;
    } else {
        global.display_mode_index = 1;
    }

    scr_settings_apply_display_mode();
}

var alt_down = keyboard_check(vk_alt);

if (alt_down && keyboard_check_pressed(vk_enter))
{
    if (global.display_mode_labels[global.display_mode_index] == "fullscreen") {
        global.display_mode_index = 0;
    } else {
        global.display_mode_index = 1;
    }

    scr_settings_apply_display_mode();
}

var kb_pause_pressed = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
var inp_pause_pressed = variable_global_exists("inp_pause_press") && global.inp_pause_press;
var pause_pressed = kb_pause_pressed || inp_pause_pressed;

if (pause_toggle_cooldown > 0) pause_toggle_cooldown--;

if (pause_pressed && pause_toggle_cooldown <= 0)
{
    if (!variable_global_exists("game_phase")) global.game_phase = "playing";

    if (global.game_phase == "playing")
    {
        if (!instance_exists(oPauseMenu))
        {
            instance_create_depth(0, 0, -1000000, oPauseMenu);
            pause_toggle_cooldown = 15;
        }
    }
    else if (global.game_phase == "paused")
    {
        if (instance_exists(oPauseMenu)) {
            with (oPauseMenu) instance_destroy();
        }

        global.game_phase = "playing";
        pause_toggle_cooldown = 15;
    }
}