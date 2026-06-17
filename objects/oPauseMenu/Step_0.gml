/// oPauseMenu — Step

var up    = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var left  = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var right = keyboard_check_pressed(vk_right)|| keyboard_check_pressed(ord("D"));

var kb_confirm = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
var inp_confirm = variable_global_exists("inp_jump_press") && global.inp_jump_press;
var confirm = kb_confirm || inp_confirm;

function __apply_window_resolution()
{
    if (global.fullscreen) exit;

    var sc = 2;
    if (variable_global_exists("resolution_index")) {
        sc = other.resolution_scales[| global.resolution_index];
    }

    window_set_size(640 * sc, 360 * sc);
    window_center();
}

function __apply_fullscreen_toggle()
{
    if (instance_exists(oGame)) {
        with (oGame) {
            if (is_callable(apply_fullscreen)) {
                apply_fullscreen(global.fullscreen);
            } else {
                window_set_fullscreen(global.fullscreen);
            }
        }
    } else {
        window_set_fullscreen(global.fullscreen);
    }
}

if (menu_mode == "main")
{
    var count = array_length(menu_items);

    if (up)   selected_index = (selected_index - 1 + count) mod count;
    if (down) selected_index = (selected_index + 1) mod count;

    if (confirm)
    {
        switch (selected_index)
        {
            case 0:
                if (instance_exists(oPlayer)) {
                    with (oPlayer) {
                        respawn_input_lock = 12;
                        prev_jump_h = true;
                    }
                }

                global.game_phase = "playing";
                instance_destroy();
            break;

            case 1: // Settings
                menu_mode = "settings";
                settings_index = 0;
            break;

            case 2: // Controls
            break;

            case 3: // Quit to Menu
                global.game_phase = "menu";
                instance_destroy();
                room_goto(MainMenuBackground);
            break;

            case 4:
                game_end();
            break;
        }
    }
}
else if (menu_mode == "settings")
{
    var scount = array_length(settings_items);

    if (up)   settings_index = (settings_index - 1 + scount) mod scount;
    if (down) settings_index = (settings_index + 1) mod scount;

    var item = settings_items[settings_index];

    var change = 0;
    if (left)  change = -1;
    if (right) change =  1;

    if (change != 0)
    {
        switch (item)
        {
            case "master_volume":
                global.vol_master = clamp(global.vol_master + change * 0.1, 0, 1);
            break;

            case "music_volume":
                global.vol_music = clamp(global.vol_music + change * 0.1, 0, 1);
                if (variable_global_exists("music_instance") && global.music_instance != noone) {
                    audio_sound_gain(global.music_instance, global.vol_master * global.vol_music, 0);
                }
            break;

            case "sfx_volume":
                global.vol_sfx = clamp(global.vol_sfx + change * 0.1, 0, 1);
            break;

            case "resolution":
                global.resolution_index = clamp(
                    global.resolution_index + change,
                    0,
                    array_length(resolution_labels) - 1
                );
                __apply_window_resolution();
            break;
        }
    }

    if (confirm)
    {
        switch (item)
        {
            case "fullscreen":
                global.fullscreen = !global.fullscreen;
                __apply_fullscreen_toggle();
            break;

            case "screen_shake":
                global.screen_shake_enabled = !global.screen_shake_enabled;
            break;

            case "button_prompts":
                global.button_prompts = !global.button_prompts;
            break;

            case "back":
                menu_mode = "main";
                selected_index = 1;
            break;
        }
    }
}