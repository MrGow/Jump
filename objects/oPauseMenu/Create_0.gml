/// oPauseMenu — Create

depth = -100000;
persistent = false;
visible = true;

menu_mode = "main";

menu_items = [
    "Resume",
    "Settings",
    "Controls",
    "Quit to Menu",
    "Quit to Desktop"
];

settings_items = [
    "master_volume",
    "music_volume",
    "sfx_volume",
    "brightness",
    "contrast",
    "display_mode",
    "resolution",
    "back"
];

selected_index = 0;
settings_index = 0;


// ====================================================
// CONTROLS MENU
//
// Rows:
// 0 = Jump
// 1 = Left
// 2 = Right
// 3 = Restore Defaults
// 4 = Back
//
// Columns:
// 0 = Keyboard
// 1 = Controller
// ====================================================

controls_row = 0;
controls_column = 0;

controls_rebinding = false;
controls_rebind_device = "";
controls_rebind_action = "";
controls_rebind_ignore_frames = 0;

controls_message = "";
controls_message_timer = 0;


global.game_phase = "paused";

scr_settings_init();
scr_controls_ensure_defaults();
scr_settings_apply_audio_gains();


// ====================================================
// UI SOUNDS
// ====================================================

snd_ui_navigation =
    asset_get_index("UIMenuNavigation1");

snd_ui_dial =
    asset_get_index("UIDialMovement1");

snd_ui_confirm =
    asset_get_index("UIConfirmation1");

snd_ui_settings_cycle =
    asset_get_index("UISettingsCycle");

ui_navigation_gain = 1.0;
ui_dial_gain = 1.0;
ui_confirm_gain = 1.0;
ui_settings_cycle_gain = 1.0;

ui_navigation_pitch_low  = 0.97;
ui_navigation_pitch_high = 1.03;


// ====================================================
// SAFELY INTERRUPT ANIMATIONS PAUSE CAN FREEZE
// ====================================================

if (instance_exists(oPlayer))
{
    with (oPlayer)
    {
        respawn_input_lock = 12;
        prev_jump_h = true;

        jump_charging     = false;
        jump_charge       = 0;
        jump_charge_level = 0;

        if (variable_instance_exists(id, "jump_charge_sfx_last"))
        {
            jump_charge_sfx_last = 0;
        }

        if (variable_instance_exists(id, "charge_grace"))
        {
            charge_grace = 0;
        }

        if (variable_instance_exists(id, "support_grace"))
        {
            support_grace = 0;
        }

        if (variable_instance_exists(id, "charge_start_lock"))
        {
            charge_start_lock = 0;
        }

        if (variable_instance_exists(id, "edge_charge_fail"))
        {
            edge_charge_fail = 0;
        }

        if (
            state == "jump_charge" ||
            state == "landing"
        )
        {
            state = "idle";

            if (variable_instance_exists(id, "jump_pose_timer"))
            {
                jump_pose_timer = 0;
            }
        }
    }
}
