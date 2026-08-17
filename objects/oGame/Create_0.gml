// ============================================================================
// oGame — Create
// ============================================================================

/// oGame — Create

if (instance_number(oGame) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;
visible = true;

gpu_set_texfilter(false);
display_set_timing_method(tm_sleep);

global.GAME_W = 640;
global.GAME_H = 360;

display_set_gui_size(
    global.GAME_W,
    global.GAME_H
);

if (surface_exists(application_surface))
{
    surface_resize(
        application_surface,
        global.GAME_W,
        global.GAME_H
    );
}

application_surface_draw_enable(false);

scr_settings_init();
scr_settings_apply_display_mode();

alarm[0] = 2;

window_set_cursor(cr_none);


// ====================================================
// BRIGHTNESS / CONTRAST
// ====================================================

bc_shader =
    asset_get_index(
        "shd_brightness_contrast"
    );

bc_u_brightness = -1;
bc_u_contrast   = -1;

if (bc_shader != -1)
{
    bc_u_brightness =
        shader_get_uniform(
            bc_shader,
            "u_brightness"
        );

    bc_u_contrast =
        shader_get_uniform(
            bc_shader,
            "u_contrast"
        );
}


// ====================================================
// GENERAL GLOBALS
// ====================================================

if (!variable_global_exists("game_phase"))
{
    global.game_phase =
        "playing";
}

if (!variable_global_exists("shake_mag"))
{
    global.shake_mag = 0;
}

if (!variable_global_exists("shake_time"))
{
    global.shake_time = 0;
}

if (!variable_global_exists("death_shake_strength"))
{
    global.death_shake_strength = 10;
}

if (!variable_global_exists("death_shake_frames"))
{
    global.death_shake_frames = 14;
}


pause_toggle_cooldown =
    0;


// ====================================================
// SAVE GLOBALS
// ====================================================

if (!variable_global_exists("save_slot"))
{
    global.save_slot = 1;
}


// ====================================================
// CHECKPOINT GLOBALS
// ====================================================

if (!variable_global_exists("checkpoint_set"))
{
    global.checkpoint_set = false;
}

if (!variable_global_exists("checkpoint_room"))
{
    global.checkpoint_room = -1;
}

if (!variable_global_exists("checkpoint_x"))
{
    global.checkpoint_x = 0;
}

if (!variable_global_exists("checkpoint_y"))
{
    global.checkpoint_y = 0;
}

if (!variable_global_exists("checkpoint_id"))
{
    global.checkpoint_id = "";
}


if (!variable_global_exists("pending_respawn"))
{
    global.pending_respawn = false;
}

if (!variable_global_exists("pending_respawn_room"))
{
    global.pending_respawn_room = -1;
}

if (!variable_global_exists("pending_respawn_x"))
{
    global.pending_respawn_x = 0;
}

if (!variable_global_exists("pending_respawn_y"))
{
    global.pending_respawn_y = 0;
}


// ====================================================
// CHIP COLLECTABLES
// ====================================================

if (!variable_global_exists("chips_collected"))
{
    global.chips_collected = 0;
}

if (!variable_global_exists("chips_carried"))
{
    global.chips_carried = 0;
}

if (!variable_global_exists("chips_total"))
{
    global.chips_total = 21;
}

if (!variable_global_exists("chips_found"))
{
    global.chips_found =
        ds_map_create();
}

if (!variable_global_exists("chips_carried_ids"))
{
    global.chips_carried_ids =
        ds_map_create();
}


// ====================================================
// DEATH STATS
// ====================================================

if (!variable_global_exists("deaths_total"))
{
    global.deaths_total = 0;
}


// ====================================================
// TELEPORT DATA-TRANSMISSION TRANSITION
//
// No external sprite required.
//
// State:
//     "none"
//     "fade_in"
//     "hold"
//     "fade_out"
// ====================================================

teleport_static_state =
    "none";


// 0 = world fully visible
// 1 = transmission fully covering screen
teleport_static_progress =
    0;


// Pattern refresh.
// Incrementing the phase changes the deterministic
// static pattern without touching GameMaker's random
// state, so gameplay RNG is unaffected.
teleport_static_phase =
    0;

teleport_static_refresh_frames =
    2;

teleport_static_refresh_timer =
    teleport_static_refresh_frames;


// ----------------------------------------------------
// Timing
// ----------------------------------------------------

// Static rapidly takes over the screen.
teleport_static_fade_in_frames =
    70;

// Full transmission churn after destination is ready.
// 60 frames = ~1 second at 60 FPS.
teleport_static_hold_frames =
    60;

// Destination reconstructs through breaking static.
teleport_static_fade_out_frames =
    60;

teleport_static_hold_timer =
    0;


// ----------------------------------------------------
// Visual tuning
// ----------------------------------------------------

// Big digital blocks.
teleport_static_coarse_w =
    25;

teleport_static_coarse_h =
    15;


// Smaller sparkling/data fragments.
teleport_static_fine_w =
    6;

teleport_static_fine_h =
    5;


// How much fine noise is allowed at full transmission.
teleport_static_fine_density =
    0.34;


// Scanline spacing.
teleport_static_scanline_gap =
    4;


// Room-change white transmission pulse.
teleport_static_flash_alpha =
    0;

teleport_static_flash_decay =
    0.10;


// ----------------------------------------------------
// Teleporter / Area 4 palette
//
// Deep transmission blue
// Electric blue
// Teleporter cyan
// Pale ion cyan
// White
// ----------------------------------------------------

teleport_static_col_deep =
    make_color_rgb(
        8,
        35,
        90
    );

teleport_static_col_blue =
    make_color_rgb(
        20,
        100,
        205
    );

teleport_static_col_cyan =
    make_color_rgb(
        45,
        220,
        255
    );

teleport_static_col_pale =
    make_color_rgb(
        170,
        245,
        255
    );

teleport_static_col_white =
    c_white;


// ----------------------------------------------------
// Room transition data
// ----------------------------------------------------

teleport_room_change_done =
    false;

teleport_transition_room =
    -1;

teleport_transition_arrival =
    "";


// ====================================================
// TELEPORT REQUEST GLOBALS
// ====================================================

if (!variable_global_exists("teleport_transition_request"))
{
    global.teleport_transition_request =
        false;
}

if (!variable_global_exists("teleport_transition_target_room"))
{
    global.teleport_transition_target_room =
        -1;
}

if (!variable_global_exists("teleport_transition_arrival_id"))
{
    global.teleport_transition_arrival_id =
        "";
}


// ====================================================
// DESTINATION ARRIVAL GLOBALS
// ====================================================

if (!variable_global_exists("teleport_arrival_pending"))
{
    global.teleport_arrival_pending =
        false;
}

if (!variable_global_exists("teleport_target_room"))
{
    global.teleport_target_room =
        -1;
}

if (!variable_global_exists("teleport_target_arrival_id"))
{
    global.teleport_target_arrival_id =
        "";
}

if (!variable_global_exists("teleport_arrival_ready"))
{
    global.teleport_arrival_ready =
        false;
}