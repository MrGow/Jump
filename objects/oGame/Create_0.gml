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
// TELEPORT VORTEX TRANSITION
// ====================================================

teleport_vortex_sprite =
    asset_get_index(
        "spriteTeleporterVortex"
    );


// State:
//
// "none"
// "fade_in"
// "hold"
// "fade_out"
teleport_vortex_state =
    "none";


teleport_vortex_alpha =
    0;


// Manual animation frame.
teleport_vortex_frame =
    0;


// ----------------------------------------------------
// Animation speed
//
// Uses the sprite's own FPS.
// ----------------------------------------------------

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


// ----------------------------------------------------
// Timing
//
// About:
// 0.30 sec fade in
// 2.00 sec full vortex
// 0.40 sec fade out
// ----------------------------------------------------

teleport_vortex_fade_in_frames =
    18;

teleport_vortex_hold_frames =
    120;

teleport_vortex_fade_out_frames =
    24;


teleport_vortex_hold_timer =
    0;


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