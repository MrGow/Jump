/// oMainMenuRoomController — Create

persistent = false;
visible    = false;

global.game_phase = "main_menu";
global.menu_demo_active = true;

global.menu_demo_left      = false;
global.menu_demo_right     = false;
global.menu_demo_jump_held = false;


// ====================================================
// SETTINGS
// ====================================================

scr_settings_init();
scr_settings_apply_audio_gains();

display_set_gui_size(640, 360);


// ====================================================
// MAIN MENU THEME
//
// Starts shortly after entering the menu so the initial
// CRT/static burst gets a brief moment on its own.
// ====================================================

menu_theme_sound =
    asset_get_index(
        "MainMenuThemeSound"
    );

menu_theme_voice =
    noone;

menu_theme_start_timer =
    10;

menu_theme_started =
    false;

menu_theme_intro_gain =
    0.18;

menu_theme_fade_ms =
    500;


// ====================================================
// FIXED MENU CAMERA
// ====================================================

view_enabled = true;
view_visible[0] = true;

if (view_camera[0] == -1)
{
    view_camera[0] =
        camera_create_view(
            0,
            0,
            640,
            360,
            0,
            noone,
            -1,
            -1,
            -1,
            -1
        );
}

camera_set_view_size(
    view_camera[0],
    640,
    360
);

camera_set_view_pos(
    view_camera[0],
    0,
    0
);


// ====================================================
// DEMO STATE
//
// 0 = running through the room
// 1 = player has moved offscreen
// 2 = player died
// ====================================================

demo_state = 0;

demo_timer = 0;

// Emergency reset only.
// The normal reset happens after the player leaves
// the right side of the screen.
demo_max_time =
    room_speed * 45;


// ====================================================
// OFFSCREEN RESET
// ====================================================

demo_offscreen_margin = 64;

demo_offscreen_wait_frames =
    round(room_speed * 10.5);

demo_offscreen_timer = 0;


// ====================================================
// DEATH RESET
// ====================================================

demo_death_wait_frames =
    round(room_speed * 0.75);

demo_death_timer = 0;


// ====================================================
// JUMP SEQUENCE
// ====================================================

demo_jump_delays =
[
    round(room_speed * 0.55),
    round(room_speed * 0.80),
    round(room_speed * 0.65),
    round(room_speed * 1.00),
    round(room_speed * 0.70),
    round(room_speed * 0.90),
    round(room_speed * 0.60),
    round(room_speed * 1.10)
];

demo_jump_holds =
[
    8,
    13,
    10,
    16,
    9,
    14,
    11,
    17
];

demo_jump_pattern_index = 0;

demo_jump_wait =
    demo_jump_delays[0];

demo_jump_hold_timer = 0;

demo_jump_releasing = false;


// ====================================================
// PLAYER START POSITION
// ====================================================

if (instance_exists(oPlayer))
{
    var p =
        instance_find(
            oPlayer,
            0
        );

    demo_spawn_x = p.x;
    demo_spawn_y = p.y;

    p.debug_draw = false;
}
else
{
    demo_spawn_x = 64;
    demo_spawn_y = 64;
}


// ====================================================
// RESET FUNCTION
// ====================================================

demo_reset_player = function()
{
    global.menu_demo_left      = false;
    global.menu_demo_right     = false;
    global.menu_demo_jump_held = false;

    if (!instance_exists(oPlayer))
    {
        return;
    }

    var player =
        instance_find(
            oPlayer,
            0
        );

    player.x = demo_spawn_x;
    player.y = demo_spawn_y;

    player.hsp = 0;
    player.vsp = 0;

    player.state = "idle";

    player.death_fall = false;

    player.jump_charging     = false;
    player.jump_charge       = 0;
    player.jump_charge_level = 0;

    player.prev_jump_h = false;

    if (
        variable_instance_exists(
            player,
            "bounce_pending"
        )
    )
    {
        player.bounce_pending = false;
    }

    if (
        variable_instance_exists(
            player,
            "bounce_timer"
        )
    )
    {
        player.bounce_timer = 0;
    }

    if (
        variable_instance_exists(
            player,
            "standing_platform"
        )
    )
    {
        player.standing_platform = noone;
    }

    if (
        variable_instance_exists(
            player,
            "standing_platform_xoff"
        )
    )
    {
        player.standing_platform_xoff = 0;
    }

    if (
        variable_instance_exists(
            player,
            "coyote_timer"
        )
    )
    {
        player.coyote_timer = 0;
    }

    if (
        variable_instance_exists(
            player,
            "spring_retrigger_lock"
        )
    )
    {
        player.spring_retrigger_lock = 0;
    }

    if (
        variable_instance_exists(
            player,
            "pinball_next_hit_time"
        )
    )
    {
        player.pinball_next_hit_time = 0;
    }

    player.debug_draw = false;

    var idle_sprite =
        asset_get_index(
            "spriteBotIdle"
        );

    if (idle_sprite != -1)
    {
        player.sprite_index =
            idle_sprite;

        player.image_index = 0;
        player.image_speed = 1;
    }

    demo_state = 0;
    demo_timer = 0;

    demo_offscreen_timer = 0;
    demo_death_timer     = 0;

    demo_jump_pattern_index = 0;

    demo_jump_wait =
        demo_jump_delays[0];

    demo_jump_hold_timer = 0;
    demo_jump_releasing  = false;

    if (instance_exists(oDeathMenu))
    {
        with (oDeathMenu)
        {
            instance_destroy();
        }
    }

    global.game_phase = "main_menu";
};