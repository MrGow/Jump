/// oGame — Create

// Make sure only one exists
if (instance_exists(oGame) && id != instance_find(oGame, 0)) {
    instance_destroy();
    exit;
}

persistent = true;

// --- Core resolution setup ---
global.GAME_W = 640;
global.GAME_H = 360;

// Application surface + window
surface_resize(application_surface, global.GAME_W, global.GAME_H);
window_set_size(global.GAME_W * 2, global.GAME_H * 2); // or *3, etc.

// --- Global phase / meta state ---

// Overall game phase (playing, death_menu, pause, etc.)
if (!variable_global_exists("game_phase")) {
    global.game_phase = "playing";
}

// Run meta
if (!variable_global_exists("run_number")) {
    global.run_number = 0;
}
if (!variable_global_exists("meta_currency")) {
    global.meta_currency = 0;
}

// Unlocked upgrades map (for later, separate from the menu list)
if (!variable_global_exists("unlocked_upgrades")) {
    global.unlocked_upgrades = ds_map_create();
}

// --- Currency ---

// Scrap picked up this climb (lost/converted on death)
if (!variable_global_exists("scrap_run")) {
    global.scrap_run = 0;
}

// Banked scrap you can spend on upgrades in the death menu
if (!variable_global_exists("scrap_total")) {
    global.scrap_total = 0;
}

// --- Upgrade definitions for the death menu ---

if (!variable_global_exists("upgrades")) {
    global.upgrades = [
        {
            id: "jump_power",
            name: "Stronger Springs",
            desc: "Jump a little higher.",
            level: 0,
            max_level: 3,
            base_cost: 10
        },
        {
            id: "shock_absorbers",
            name: "Shock Absorbers",
            desc: "Less bounce on bad landings.",
            level: 0,
            max_level: 2,
            base_cost: 15
        },
        {
            id: "scrap_magnet",
            name: "Scrap Magnet",
            desc: "Pull nearby scrap towards you.",
            level: 0,
            max_level: 3,
            base_cost: 12
        }
    ];
}
