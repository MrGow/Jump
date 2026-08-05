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

// How far beyond the camera the player must travel
// before being considered completely gone.
demo_offscreen_margin = 64;

// Hold briefly after moving offscreen so the reset
// itself is never visible.
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
//
// The player waits between jumps, then holds jump for
// the selected number of frames.
//
// Small holds produce small jumps.
// Medium holds produce medium jumps.
// ====================================================

// Delay before each upcoming jump.
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

// Charge duration for each jump.
//
// With your six-frames-per-charge-level setup:
//
// 7–10 frames  = small jump
// 11–17 frames = medium jump
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
    // Stop demo input before repositioning.
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

    // Reset demo sequence.
    demo_state = 0;
    demo_timer = 0;

    demo_offscreen_timer = 0;
    demo_death_timer     = 0;

    demo_jump_pattern_index = 0;

    demo_jump_wait =
        demo_jump_delays[0];

    demo_jump_hold_timer = 0;
    demo_jump_releasing  = false;

    // Remove any death interface created by hazards.
    if (instance_exists(oDeathMenu))
    {
        with (oDeathMenu)
        {
            instance_destroy();
        }
    }

    global.game_phase = "main_menu";
};