/// oGame — Create

if (instance_number(oGame) > 1) {
    instance_destroy();
    exit;
}

persistent = true;

gpu_set_texfilter(false);
display_set_timing_method(tm_sleep);

global.GAME_W = 640;
global.GAME_H = 360;

display_set_gui_size(global.GAME_W, global.GAME_H);

global.window_scale = 2;

if (surface_exists(application_surface)) {
    surface_resize(application_surface, global.GAME_W, global.GAME_H);
}

// We draw this manually in oGame Post Draw
application_surface_draw_enable(false);

window_set_size(global.GAME_W * global.window_scale, global.GAME_H * global.window_scale);
window_center();

// Re-assert window/surface setup after GameMaker settles
alarm[0] = 2;

if (!variable_global_exists("fullscreen")) global.fullscreen = false;

global.windowed_w = global.GAME_W * global.window_scale;
global.windowed_h = global.GAME_H * global.window_scale;

apply_fullscreen = function(_on) {
    global.fullscreen = _on;

    if (_on) {
        global.windowed_w = window_get_width();
        global.windowed_h = window_get_height();
        window_set_fullscreen(true);
    } else {
        window_set_fullscreen(false);
        window_set_size(global.windowed_w, global.windowed_h);
        window_center();
    }

    gpu_set_texfilter(false);
    display_set_gui_size(global.GAME_W, global.GAME_H);

    if (surface_exists(application_surface)) {
        surface_resize(application_surface, global.GAME_W, global.GAME_H);
    }

    application_surface_draw_enable(false);
};

apply_fullscreen(global.fullscreen);

if (!variable_global_exists("game_phase")) global.game_phase = "playing";

if (!variable_global_exists("shake_mag"))  global.shake_mag  = 0;
if (!variable_global_exists("shake_time")) global.shake_time = 0;
if (!variable_global_exists("death_shake_strength")) global.death_shake_strength = 10;
if (!variable_global_exists("death_shake_frames"))   global.death_shake_frames   = 14;

pause_toggle_cooldown = 0;

if (!variable_global_exists("checkpoint_set"))  global.checkpoint_set  = false;
if (!variable_global_exists("checkpoint_room")) global.checkpoint_room = -1;
if (!variable_global_exists("checkpoint_x"))    global.checkpoint_x    = 0;
if (!variable_global_exists("checkpoint_y"))    global.checkpoint_y    = 0;
if (!variable_global_exists("checkpoint_id"))   global.checkpoint_id   = "";

if (!variable_global_exists("pending_respawn"))      global.pending_respawn      = false;
if (!variable_global_exists("pending_respawn_room")) global.pending_respawn_room = -1;
if (!variable_global_exists("pending_respawn_x"))    global.pending_respawn_x    = 0;
if (!variable_global_exists("pending_respawn_y"))    global.pending_respawn_y    = 0;