/// oGame — Create

// Make sure only one exists
if (instance_exists(oGame) && id != instance_find(oGame, 0)) {
    instance_destroy();
    exit;
}

persistent = true;

// --- Pixel-perfect / filtering (SAFE FOR ALL RUNTIMES) ---
gpu_set_texfilter(false); // disables texture smoothing

// --- Core resolution setup ---
global.GAME_W = 640;
global.GAME_H = 360;

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
};

apply_fullscreen(global.fullscreen);

// --- Global phase / meta state ---
if (!variable_global_exists("game_phase")) global.game_phase = "playing";
if (!variable_global_exists("run_number")) global.run_number = 0;
if (!variable_global_exists("meta_currency")) global.meta_currency = 0;

if (!variable_global_exists("unlocked_upgrades")) {
    global.unlocked_upgrades = ds_map_create();
}

if (!variable_global_exists("scrap_run")) global.scrap_run = 0;
if (!variable_global_exists("scrap_total")) global.scrap_total = 0;

if (!variable_global_exists("upgrades")) {
    global.upgrades = [
        { id:"jump_power",      name:"Stronger Springs", desc:"Jump a little higher.", level:0, max_level:3, base_cost:10 },
        { id:"shock_absorbers", name:"Shock Absorbers",  desc:"Less bounce on bad landings.", level:0, max_level:2, base_cost:15 },
        { id:"scrap_magnet",    name:"Scrap Magnet",     desc:"Pull nearby scrap towards you.", level:0, max_level:3, base_cost:12 }
    ];
}
