/// oGame — Create

if (instance_number(oGame) > 1) {
    instance_destroy();
    exit;
}

persistent = true;
visible = true;

gpu_set_texfilter(false);
display_set_timing_method(tm_sleep);

global.GAME_W = 640;
global.GAME_H = 360;

display_set_gui_size(global.GAME_W, global.GAME_H);

if (surface_exists(application_surface)) {
    surface_resize(application_surface, global.GAME_W, global.GAME_H);
}

application_surface_draw_enable(false);

scr_settings_init();
scr_settings_apply_display_mode();

alarm[0] = 2;

window_set_cursor(cr_none);

bc_shader = asset_get_index("shd_brightness_contrast");
bc_u_brightness = -1;
bc_u_contrast = -1;

if (bc_shader != -1) {
    bc_u_brightness = shader_get_uniform(bc_shader, "u_brightness");
    bc_u_contrast   = shader_get_uniform(bc_shader, "u_contrast");
}

if (!variable_global_exists("game_phase")) global.game_phase = "playing";

if (!variable_global_exists("shake_mag"))  global.shake_mag  = 0;
if (!variable_global_exists("shake_time")) global.shake_time = 0;
if (!variable_global_exists("death_shake_strength")) global.death_shake_strength = 10;
if (!variable_global_exists("death_shake_frames"))   global.death_shake_frames   = 14;

pause_toggle_cooldown = 0;

// Checkpoint globals
if (!variable_global_exists("checkpoint_set"))  global.checkpoint_set  = false;
if (!variable_global_exists("checkpoint_room")) global.checkpoint_room = -1;
if (!variable_global_exists("checkpoint_x"))    global.checkpoint_x    = 0;
if (!variable_global_exists("checkpoint_y"))    global.checkpoint_y    = 0;
if (!variable_global_exists("checkpoint_id"))   global.checkpoint_id   = "";

if (!variable_global_exists("pending_respawn"))      global.pending_respawn      = false;
if (!variable_global_exists("pending_respawn_room")) global.pending_respawn_room = -1;
if (!variable_global_exists("pending_respawn_x"))    global.pending_respawn_x    = 0;
if (!variable_global_exists("pending_respawn_y"))    global.pending_respawn_y    = 0;

// ----------------------------------------------------
// Chip Collectables
// ----------------------------------------------------
if (!variable_global_exists("chips_collected")) global.chips_collected = 0;
if (!variable_global_exists("chips_carried"))   global.chips_carried   = 0;

if (!variable_global_exists("chips_total")) {
    global.chips_total = 21; // CHANGE this to your final chip total
}

// Permanently banked chip IDs
if (!variable_global_exists("chips_found")) {
    global.chips_found = ds_map_create();
}

// Picked up, but not yet banked at checkpoint
if (!variable_global_exists("chips_carried_ids")) {
    global.chips_carried_ids = ds_map_create();
}