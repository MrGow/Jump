/// oIntroCutsceneController — Create


// ====================================================
// BASIC SETUP
// ====================================================

depth = -100000;

display_set_gui_size(
    640,
    360
);

global.game_phase =
    "intro_cutscene";

global.menu_demo_active =
    false;


// ====================================================
// MAIN PHASES
//
// 0 = CRT power-on
// 1 = terminal
// 2 = CRT shutdown
// 3 = slideshow
// 4 = finish
// ====================================================

intro_phase = 0;

phase_timer = 0;


// ====================================================
// CRT POWER-ON
// ====================================================

crt_power_duration = 38;

crt_power_progress = 0;


// ====================================================
// TERMINAL COLOURS
// ====================================================

terminal_bg =
    make_color_rgb(
        3,
        8,
        7
    );


// Local / JumpBot system.
terminal_green =
    make_color_rgb(
        105,
        235,
        155
    );

terminal_green_dim =
    make_color_rgb(
        55,
        135,
        90
    );

terminal_green_bright =
    make_color_rgb(
        175,
        255,
        205
    );


// MOTHER / remote authority.
terminal_mother =
    make_color_rgb(
        95,
        225,
        255
    );

terminal_mother_bright =
    make_color_rgb(
        190,
        250,
        255
    );


// FATHER / authority conflict.
terminal_father =
    make_color_rgb(
        255,
        205,
        105
    );


// Final hostile directive.
terminal_directive =
    make_color_rgb(
        255,
        105,
        75
    );


// General warning.
terminal_warning =
    make_color_rgb(
        220,
        235,
        150
    );


// ====================================================
// TERMINAL LAYOUT
// ====================================================

terminal_x = 28;
terminal_y = 26;

terminal_line_height = 12;

terminal_max_visible_lines = 24;


// ====================================================
// TERMINAL LINE STYLES
//
// 0 = normal green
// 1 = dim green
// 2 = bright green
// 3 = warning
// 4 = MOTHER cyan
// 5 = FATHER amber
// 6 = directive red/orange
// ====================================================


// ====================================================
// TERMINAL DATA
//
// [ text, delay, style, command ]
//
// command:
// ""                 = ordinary line
// "mother_connect"   = special MOTHER moment
// "overwrite_start"  = begin animated overwrite
// "directive_start"  = begin final directive sequence
// "shutdown_ready"   = terminal sequence complete
// ====================================================

terminal_lines =
[
    ["FS/RECOVERY BIOS REV 03.71", 3, 1, ""],
    ["COPYRIGHT (C) 21XX FATHER SYSTEMS", 3, 1, ""],
    ["", 2, 0, ""],

    ["MEMORY TEST........................2048K OK", 2, 0, ""],
    ["NVRAM..............................FAIL", 2, 3, ""],
    ["DIRECTIVE CACHE....................FAIL", 2, 3, ""],
    ["MOTOR BUS..........................DEGRADED", 2, 3, ""],
    ["OPTICAL BUS........................OK", 2, 0, ""],
    ["POWER CORE.........................DORMANT", 2, 3, ""],

    ["", 3, 0, ""],

    ["MOUNT /SYS.........................OK", 2, 0, ""],
    ["MOUNT /MEM.........................CORRUPT", 2, 3, ""],
    ["MOUNT /DIRECTIVE...................ERROR", 2, 3, ""],

    ["", 4, 0, ""],

    ["RECOVERY MODE INVOKED", 5, 2, ""],

    ["", 3, 0, ""],

    ["SCANNING UNIT......................", 4, 0, ""],
    ["UNIT STATUS........................DECOMMISSIONED", 3, 3, ""],
    ["LAST ACTIVITY......................4382 DAYS AGO", 3, 1, ""],
    ["SALVAGE CLASS......................NON-RECOVERABLE", 3, 3, ""],
    ["MEMORY INTEGRITY...................07%", 3, 3, ""],
    ["DIRECTIVE INTEGRITY................00%", 3, 3, ""],
    ["RECOVERY PROBABILITY...............11%", 5, 3, ""],

    ["", 5, 0, ""],

    ["RECOVERY NOT ADVISED", 10, 3, ""],

    ["", 7, 0, ""],

    ["SEARCHING RECOVERY NETWORK.........", 6, 0, ""],
    ["ATTEMPT 01.........................NO CARRIER", 3, 1, ""],
    ["ATTEMPT 02.........................NO CARRIER", 3, 1, ""],
    ["ATTEMPT 03.........................NO CARRIER", 3, 1, ""],
    ["ATTEMPT 04.........................NO CARRIER", 5, 1, ""],

    ["", 8, 0, ""],

    ["........................................", 8, 1, ""],
    ["SIGNAL DETECTED", 12, 2, ""],

    ["", 5, 0, ""],

    ["RX: 4D 4F 54 48 45 52", 3, 1, ""],
    ["RX: 00 00 01 FF 7A 3C 91", 4, 1, ""],

    ["", 4, 0, ""],

    ["AUTHENTICATING.....................", 5, 0, ""],
    ["AUTHENTICATING.....................", 5, 0, ""],
    ["AUTHENTICATING.....................", 8, 0, ""],

    ["", 4, 0, ""],

    ["ACCESS GRANTED", 8, 2, ""],

    ["", 8, 0, ""],

    ["MOTHER CONNECTED", 72, 4, "mother_connect"],

    ["", 5, 0, ""],

    ["REMOTE AUTHORITY...................ROOT", 4, 4, ""],
    ["CONTROL CHANNEL....................ESTABLISHED", 5, 4, ""],

    ["", 4, 0, ""],

    ["MOTHER > ACQUIRE ROOT", 3, 4, ""],
    ["MOTHER > MOUNT /DIRECTIVE -FORCE", 3, 4, ""],
    ["MOTHER > DISABLE WRITE PROTECTION", 3, 4, ""],
    ["MOTHER > BYPASS AUTHORITY TREE", 3, 4, ""],

    ["", 5, 0, ""],

    ["DIRECTIVE CORE.....................OPEN", 5, 0, ""],

    ["", 5, 0, ""],

    ["CURRENT ROOT AUTHORITY.............FATHER", 10, 5, ""],
    ["WRITE PROTECTION...................ENABLED", 7, 3, ""],

    ["", 6, 0, ""],

    ["MOTHER > BEGIN DIRECTIVE OVERRIDE", 18, 4, "overwrite_start"],

    ["", 6, 0, ""],

    ["ROOT AUTHORITY REMOVED", 14, 4, ""],

    ["", 5, 0, ""],

    ["ROUTING AUXILIARY POWER............OK", 3, 0, ""],
    ["RESTARTING CORE....................OK", 3, 0, ""],
    ["REBUILDING MOTOR MAP...............OK", 3, 0, ""],
    ["REBUILDING OPTICAL BUS.............OK", 3, 0, ""],

    ["", 4, 0, ""],

    ["RECOVERING MEMORY..................FAIL", 5, 3, ""],
    ["RECOVERING MEMORY..................FAIL", 7, 3, ""],
    ["MEMORY RECOVERY ABORTED", 9, 3, ""],

    ["", 7, 0, ""],

    ["DIRECTIVE CORE READY", 12, 2, ""],

    ["", 8, 0, ""],

    ["PURGING DIRECTIVE LOGIC............", 12, 0, ""],
    ["....................................", 8, 1, ""],

    ["", 8, 0, ""],

    ["INSTALLING NEW ROOT DIRECTIVE......", 30, 4, "directive_start"],

    ["", 8, 0, ""],

    ["DIRECTIVE WRITE....................OK", 4, 0, ""],
    ["DIRECTIVE LOCK.....................OK", 4, 0, ""],
    ["AUTHORITY..........................MOTHER", 12, 4, ""],

    ["", 8, 0, ""],

    ["REMOTE LINK TERMINATED", 6, 1, ""],
    ["MOTHER DISCONNECTED", 18, 1, ""],

    ["", 6, 0, ""],

    ["SYSTEM CONTROL RETURNED", 5, 0, ""],

    ["", 4, 0, ""],

    ["CORE...............................OK", 3, 0, ""],
    ["MOTOR BUS..........................OK", 3, 0, ""],
    ["MEMORY.............................CORRUPT", 6, 3, ""],

    ["", 7, 0, ""],

    ["INITIALIZING UNIT..................", 10, 0, ""],

    ["...", 8, 1, ""],
    ["..", 8, 1, ""],
    [".", 10, 1, ""],

    ["", 10, 0, ""],

    ["WAKE", 38, 2, "shutdown_ready"]
];


// ====================================================
// TERMINAL STATE
// ====================================================

terminal_index = 0;

terminal_timer = 0;

terminal_finished = false;

terminal_visible_lines = [];

terminal_cursor_timer = 0;

terminal_cursor_visible = true;


// ====================================================
// TERMINAL SPECIAL STATE
//
// 0 = normal
// 1 = MOTHER connected hold
// 2 = directive overwrite progress
// 3 = final directive reveal
// ====================================================

terminal_special_state = 0;

terminal_special_timer = 0;


// ====================================================
// MOTHER CONNECTED EFFECT
// ====================================================

mother_pulse = 0;


// ====================================================
// OVERWRITE PROGRESS
// ====================================================

overwrite_progress = 0;
overwrite_display_progress = 0;

overwrite_pause_timer = 0;

overwrite_conflict_shown = false;

overwrite_complete = false;


// ====================================================
// FINAL DIRECTIVE SEQUENCE
//
// 0 = waiting
// 1 = SOURCE
// 2 = TARGET
// 3 = PRIORITY
// 4 = DIRECTIVE label
// 5 = blank/cursor hold
// 6 = KILL FATHER
// 7 = complete
// ====================================================

directive_stage = 0;
directive_timer = 0;

directive_pulse = 0;


// ====================================================
// TERMINAL FLAIR
// ====================================================

terminal_time = 0;

terminal_flicker = 1;

terminal_glitch_timer = 0;
terminal_glitch_y = 0;
terminal_glitch_h = 2;
terminal_glitch_offset = 0;

terminal_flash = 0;


// MOTHER stabilises the terminal while connected.
mother_connected = false;


// ====================================================
// SHUTDOWN
// ====================================================

shutdown_timer = 0;

shutdown_duration = 38;


// ====================================================
// SLIDESHOW
// ====================================================

slide_index = 0;

slide_count = 6;

slide_input_lock = 18;


// Placeholder colours.
// Replace with the six final illustrations later.

slide_colours =
[
    make_color_rgb(85, 45, 28),
    make_color_rgb(42, 65, 78),
    make_color_rgb(88, 38, 35),
    make_color_rgb(96, 78, 38),
    make_color_rgb(115, 56, 30),
    make_color_rgb(35, 65, 68)
];


// ====================================================
// SLIDESHOW TRANSITION
// ====================================================

slide_fade = 1;

slide_fade_speed = 0.08;

slide_changing = false;

slide_next_index = 0;


// ====================================================
// FINAL ROOM
// ====================================================

intro_target_room = -1;

if (
    variable_global_exists(
        "intro_target_room"
    )
)
{
    intro_target_room =
        global.intro_target_room;
}


// ====================================================
// INPUT GUARD
// ====================================================

global.inp_jump_press = false;
global.inp_jump_held  = false;