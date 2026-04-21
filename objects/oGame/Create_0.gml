/// oGame — Create

// Make sure only one exists
if (instance_exists(oGame) && id != instance_find(oGame, 0)) {
    instance_destroy();
    exit;
}

persistent = true;

// --- Pixel-perfect / filtering (SAFE FOR ALL RUNTIMES) ---
gpu_set_texfilter(false);

// --- Core resolution setup ---
global.GAME_W = 640;
global.GAME_H = 360;

// Lock GUI coordinates to game resolution
display_set_gui_size(global.GAME_W, global.GAME_H);

// Windowed scale (2x by default)
global.window_scale = 2;

// Application surface + window
if (surface_exists(application_surface)) {
    surface_resize(application_surface, global.GAME_W, global.GAME_H);
}
window_set_size(global.GAME_W * global.window_scale, global.GAME_H * global.window_scale);
window_center();

// --- Fullscreen state ---
if (!variable_global_exists("fullscreen")) global.fullscreen = false;

// Remember last windowed size so we can restore it
global.windowed_w = global.GAME_W * global.window_scale;
global.windowed_h = global.GAME_H * global.window_scale;

// Helper: apply fullscreen/windowed
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

    // Re-assert fixed GUI space after mode change
    display_set_gui_size(global.GAME_W, global.GAME_H);
};

apply_fullscreen(global.fullscreen);

// --- Global phase / meta state ---
if (!variable_global_exists("game_phase")) global.game_phase = "playing";

// Camera shake globals
if (!variable_global_exists("shake_mag"))  global.shake_mag  = 0;
if (!variable_global_exists("shake_time")) global.shake_time = 0;
if (!variable_global_exists("death_shake_strength")) global.death_shake_strength = 10;
if (!variable_global_exists("death_shake_frames"))   global.death_shake_frames   = 14;
// Debounce pause toggle to prevent key-repeat instantly unpausing
pause_toggle_cooldown = 0;