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

global.window_scale = 2;

if (surface_exists(application_surface)) {
    surface_resize(application_surface, global.GAME_W, global.GAME_H);
}

// IMPORTANT: we now draw the application surface manually with shader
application_surface_draw_enable(false);

window_set_size(global.GAME_W * global.window_scale, global.GAME_H * global.window_scale);
window_center();

alarm[0] = 2;

if (!variable_global_exists("fullscreen")) global.fullscreen = false;

global.windowed_w = global.GAME_W * global.window_scale;
global.windowed_h = global.GAME_H * global.window_scale;

// Brightness / contrast settings
if (!variable_global_exists("brightness")) global.brightness = 1.0;
if (!variable_global_exists("contrast"))   global.contrast   = 1.0;

// Shader
bc_shader = asset_get_index("shd_brightness_contrast");
bc_u_brightness = -1;
bc_u_contrast = -1;

if (bc_shader != -1) {
    bc_u_brightness = shader_get_uniform(bc_shader, "u_brightness");
    bc_u_contrast   = shader_get_uniform(bc_shader, "u_contrast");
}

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

scr_settings_init();
// ----------------------------------------------------
// Shared settings source of truth
// ----------------------------------------------------
if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
if (!variable_global_exists("vol_music"))  global.vol_music  = 0.8;
if (!variable_global_exists("vol_sfx"))    global.vol_sfx    = 1.0;

if (!variable_global_exists("brightness")) global.brightness = 1.0;
if (!variable_global_exists("contrast"))   global.contrast   = 1.0;

global.display_mode_labels = ["windowed", "fullscreen", "borderless"];
if (!variable_global_exists("display_mode_index")) global.display_mode_index = 0;
global.display_mode_index = clamp(global.display_mode_index, 0, array_length(global.display_mode_labels) - 1);

global.resolution_labels = ["640x360", "1280x720", "1920x1080"];
global.resolution_scales = [1, 2, 3];

if (!variable_global_exists("resolution_index")) global.resolution_index = 1;
global.resolution_index = clamp(global.resolution_index, 0, array_length(global.resolution_labels) - 1);

apply_window_resolution = function()
{
    var sc = global.resolution_scales[global.resolution_index];

    window_set_fullscreen(false);
    window_set_showborder(true);
    window_set_size(global.GAME_W * sc, global.GAME_H * sc);
    window_center();

    global.fullscreen = false;

    display_set_gui_size(global.GAME_W, global.GAME_H);
};

apply_display_mode = function()
{
    var mode = global.display_mode_labels[global.display_mode_index];

    if (mode == "windowed")
    {
        apply_window_resolution();
    }
    else if (mode == "fullscreen")
    {
        window_set_showborder(true);
        window_set_fullscreen(true);
        global.fullscreen = true;
    }
    else if (mode == "borderless")
    {
        window_set_fullscreen(false);
        window_set_showborder(false);
        window_set_position(0, 0);
        window_set_size(display_get_width(), display_get_height());
        global.fullscreen = false;
    }

    gpu_set_texfilter(false);
    display_set_gui_size(global.GAME_W, global.GAME_H);
};