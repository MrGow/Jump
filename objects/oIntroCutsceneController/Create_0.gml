/// oIntroCutsceneController — Create


depth = -1001;

display_set_gui_size(
    640,
    360
);


global.game_phase =
    "intro_cutscene";

global.menu_demo_active =
    false;


// ====================================================
// TARGET ROOM
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
// MAIN PHASE
//
// 0 = CRT power on
// 1 = terminal
// 2 = CRT shutdown
// 3 = slideshow
// 4 = finish
// ====================================================

intro_phase = 0;

phase_timer = 0;


// ====================================================
// CRT POWER ON
// ====================================================

crt_power_progress = 0;

crt_power_duration = 70;


// ====================================================
// TERMINAL COLOURS
// ====================================================

terminal_bg =
    make_color_rgb(
        4,
        10,
        7
    );


// Aged green-phosphor system palette.
terminal_green =
    make_color_rgb(
        112,
        198,
        132
    );


terminal_green_dim =
    make_color_rgb(
        48,
        102,
        68
    );


terminal_green_bright =
    make_color_rgb(
        176,
        228,
        182
    );


// MOTHER — foreign cyan / blue-white.
terminal_mother =
    make_color_rgb(
        92,
        194,
        211
    );


terminal_mother_bright =
    make_color_rgb(
        170,
        230,
        235
    );


// FATHER — institutional amber/gold.
terminal_father =
    make_color_rgb(
        210,
        169,
        86
    );


// Directive / hard warning.
terminal_directive =
    make_color_rgb(
        224,
        92,
        64
    );


// Dirty amber warning phosphor.
terminal_warning =
    make_color_rgb(
        198,
        184,
        112
    );


// ====================================================
// TERMINAL POSITION
// ====================================================

terminal_x = 28;
terminal_y = 22;

terminal_line_height = 13;

terminal_max_visible_lines = 24;


// ====================================================
// TERMINAL DATA
//
// [ text, delay, style, command ]
//
// Styles:
//
// 0 = normal green
// 1 = dim green
// 2 = bright green
// 3 = warning
// 4 = MOTHER
// 5 = FATHER
// 6 = directive
// ====================================================

terminal_lines =
[
    [
        "CCCA RECOVERY ENVIRONMENT REV 03.71",
        18,
        1,
        ""
    ],

    [
        "AUTHORIZED SYSTEMS ONLY",
        20,
        5,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "MEMORY TEST........................2048K OK",
        12,
        0,
        ""
    ],

    [
        "NVRAM..............................FAIL",
        16,
        3,
        ""
    ],

    [
        "DIRECTIVE CACHE....................FAIL",
        16,
        3,
        ""
    ],

    [
        "MOTOR BUS..........................DEGRADED",
        14,
        3,
        ""
    ],

    [
        "OPTICAL BUS........................OK",
        10,
        0,
        ""
    ],

    [
        "POWER CORE.........................DORMANT",
        18,
        3,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "MOUNT /SYS.........................OK",
        10,
        0,
        ""
    ],

    [
        "MOUNT /MEM.........................CORRUPT",
        16,
        3,
        ""
    ],

    [
        "MOUNT /DIRECTIVE...................ERROR",
        22,
        3,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "RECOVERY MODE INVOKED",
        30,
        2,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "SCANNING UNIT......................",
        20,
        0,
        ""
    ],

    [
        "UNIT STATUS........................DECOMMISSIONED",
        18,
        3,
        ""
    ],

    [
        "LAST ACTIVITY......................4382 DAYS AGO",
        18,
        1,
        ""
    ],

    [
        "SALVAGE CLASS......................NON-RECOVERABLE",
        18,
        3,
        ""
    ],

    [
        "MEMORY INTEGRITY...................07%",
        14,
        3,
        ""
    ],

    [
        "DIRECTIVE INTEGRITY................00%",
        14,
        3,
        ""
    ],

    [
        "RECOVERY PROBABILITY...............11%",
        24,
        3,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "RECOVERY NOT ADVISED",
        34,
        3,
        ""
    ],

    [
        "",
        16,
        0,
        ""
    ],

    [
        "SEARCHING RECOVERY NETWORK.........",
        28,
        0,
        ""
    ],

    [
        "ATTEMPT 01.........................NO CARRIER",
        18,
        1,
        ""
    ],

    [
        "ATTEMPT 02.........................NO CARRIER",
        18,
        1,
        ""
    ],

    [
        "ATTEMPT 03.........................NO CARRIER",
        18,
        1,
        ""
    ],

    [
        "ATTEMPT 04.........................NO CARRIER",
        28,
        1,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "........................................",
        22,
        1,
        ""
    ],

    [
        "SIGNAL DETECTED",
        34,
        2,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "RX: 4D 4F 54 48 45 52",
        22,
        4,
        ""
    ],

    [
        "RX: 00 00 01 FF 7A 3C 91",
        22,
        4,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "AUTHENTICATING.....................",
        24,
        0,
        ""
    ],

    [
        "AUTHENTICATING.....................",
        24,
        0,
        ""
    ],

    [
        "AUTHENTICATING.....................",
        32,
        0,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "ACCESS GRANTED",
        28,
        4,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "REMOTE AUTHORITY...................ROOT",
        18,
        4,
        ""
    ],

    [
        "CONTROL CHANNEL....................ESTABLISHED",
        22,
        4,
        ""
    ],

    [
        "",
        14,
        0,
        ""
    ],

    [
        "MOTHER > ACQUIRE ROOT",
        18,
        4,
        ""
    ],

    [
        "MOTHER > MOUNT /DIRECTIVE -FORCE",
        18,
        4,
        ""
    ],

    [
        "MOTHER > DISABLE WRITE PROTECTION",
        18,
        4,
        ""
    ],

    [
        "MOTHER > BYPASS AUTHORITY TREE",
        24,
        4,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "DIRECTIVE CORE.....................OPEN",
        18,
        0,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "CURRENT ROOT AUTHORITY.............FATHER",
        22,
        5,
        ""
    ],

    [
        "WRITE PROTECTION...................ENABLED",
        24,
        5,
        ""
    ],

    [
        "",
        14,
        0,
        ""
    ],

    [
        "MOTHER > BEGIN AUTHORITY OVERRIDE",
        18,
        4,
        "overwrite_start"
    ],

    // MOTHER branding happens automatically when the
    // authority override reaches 100%.

    [
        "MOTHER CONNECTED",
        28,
        4,
        "mother_connect"
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "ROUTING AUXILIARY POWER............OK",
        12,
        0,
        ""
    ],

    [
        "RESTARTING CORE....................OK",
        12,
        0,
        ""
    ],

    [
        "REBUILDING MOTOR MAP...............OK",
        12,
        0,
        ""
    ],

    [
        "REBUILDING OPTICAL BUS.............OK",
        16,
        0,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "RECOVERING MEMORY..................FAIL",
        18,
        3,
        ""
    ],

    [
        "RECOVERING MEMORY..................FAIL",
        22,
        3,
        ""
    ],

    [
        "MEMORY RECOVERY ABORTED",
        28,
        3,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "DIRECTIVE CORE READY",
        20,
        2,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "PURGING DIRECTIVE LOGIC............",
        18,
        0,
        ""
    ],

    [
        "....................................",
        24,
        1,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "INSTALLING NEW ROOT DIRECTIVE......",
        20,
        4,
        "directive_start"
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "DIRECTIVE WRITE....................OK",
        14,
        4,
        ""
    ],

    [
        "DIRECTIVE LOCK.....................OK",
        14,
        4,
        ""
    ],

    [
        "AUTHORITY..........................MOTHER",
        28,
        4,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "REMOTE LINK TERMINATED",
        18,
        1,
        ""
    ],

    [
        "MOTHER DISCONNECTED",
        26,
        1,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "SYSTEM CONTROL RETURNED",
        20,
        0,
        ""
    ],

    [
        "",
        10,
        0,
        ""
    ],

    [
        "CORE...............................OK",
        12,
        0,
        ""
    ],

    [
        "MOTOR BUS..........................OK",
        12,
        0,
        ""
    ],

    [
        "MEMORY.............................CORRUPT",
        20,
        3,
        ""
    ],

    [
        "",
        12,
        0,
        ""
    ],

    [
        "INITIALIZING UNIT..................",
        22,
        2,
        ""
    ],

    [
        "...",
        18,
        1,
        ""
    ],

    [
        "..",
        18,
        1,
        ""
    ],

    [
        ".",
        32,
        1,
        ""
    ],

    [
        "WAKE",
        1,
        4,
        "shutdown_ready"
    ]
];


// ====================================================
// TERMINAL STATE
// ====================================================

terminal_visible_lines = [];

terminal_index = 0;

terminal_timer = 0;

terminal_finished = false;

terminal_time = 0;


// ====================================================
// TERMINAL HISTORY HELPERS
//
// History entries may optionally reserve more than one
// terminal row:
//
// [ text, style, row_count ]
//
// This lets large FATHER / MOTHER identity blocks and the
// authority progress bar behave like terminal output rather
// than separate screen overlays.
// ====================================================

terminal_history_rows =
function()
{
    var total_rows = 0;

    for (
        var hi = 0;
        hi < array_length(
            terminal_visible_lines
        );
        hi++
    )
    {
        var hist_entry =
            terminal_visible_lines[hi];

        var hist_rows = 1;

        if (array_length(hist_entry) >= 3)
        {
            hist_rows =
                max(
                    1,
                    hist_entry[2]
                );
        }

        total_rows +=
            hist_rows;
    }

    return total_rows;
};


// ====================================================
// SMOOTH TERMINAL HISTORY SCROLL
//
// New output does not instantly delete the oldest history
// entry anymore. Instead, overflow becomes a pixel scroll
// target. The whole terminal history then eases upward.
//
// Once an entry has completely moved above the visible
// terminal area, it is finally removed from the array.
// This is especially important for the large FATHER /
// MOTHER branding blocks, which now physically scroll away
// instead of vanishing in one frame.
// ====================================================

terminal_history_scroll_px =
    0;

terminal_history_scroll_target_px =
    0;

terminal_history_scroll_speed =
    2.6;


terminal_push_history =
function(
    _text,
    _style,
    _rows
)
{
    if (is_undefined(_rows))
    {
        _rows = 1;
    }

    _rows =
        max(
            1,
            _rows
        );


    array_push(
        terminal_visible_lines,
        [
            _text,
            _style,
            _rows
        ]
    );


    var overflow_rows =
        max(
            0,
            terminal_history_rows()
            -
            terminal_max_visible_lines
        );


    if (overflow_rows > 0)
    {
        terminal_history_scroll_target_px =
            max(
                terminal_history_scroll_target_px,
                overflow_rows *
                terminal_line_height
            );
    }
};


// ====================================================
// CURSOR
// ====================================================

terminal_cursor_timer = 0;

terminal_cursor_visible = true;


// ====================================================
// CRT FLICKER / GLITCH
// ====================================================

terminal_flicker = 1;

terminal_glitch_timer = 0;
terminal_glitch_y = 0;
terminal_glitch_h = 0;
terminal_glitch_offset = 0;

terminal_flash = 0;


// ====================================================
// CONTINUOUS CRT REFRESH
//
// These are the low-level "screen is constantly being
// redrawn" effects. They are separate from the larger
// occasional horizontal corruption.
// ====================================================

terminal_refresh_phase = 0;
terminal_refresh_level = 1;
terminal_refresh_snap = 1;

terminal_refresh_y = 0;
terminal_retrace_y = 0;

terminal_scanline_alpha = 0.15;


// ====================================================
// RAW BOOT / DEBUG CONSOLE
// ====================================================

// About four seconds of dense low-level machine output
// before the clean FATHER branding appears.
boot_debug_duration = 340;

boot_debug_tick = 0;
boot_debug_page = 0;
boot_debug_scan = 0;
boot_debug_bus = 0;
boot_debug_fault = 0;

boot_debug_status =
[
    "CORE0  RUN",
    "CORE1  HALT",
    "MEM    2048K",
    "NVRAM  CRC!",
    "MOTOR  ----",
    "OPTIC  SYNC",
    "DIR    NULL",
    "DMA02  WAIT"
];

boot_debug_hex =
[
    "00000000 F0 B8 00 00 12 00 00 00",
    "00000008 00 00 00 00 00 00 00 00",
    "00000010 80 0C 00 00 4F 22 91 00",
    "00000018 FF 00 31 7A 00 00 00 00",
    "00000020 91 7E 02 00 18 00 FF FF",
    "00000028 00 00 00 04 A8 1C 00 00",
    "00000030 3C 00 91 00 00 7A 2E 11",
    "00000038 80 04 00 00 00 00 00 00",
    "00000040 FF 18 00 00 2C 00 09 71",
    "00000048 00 00 00 00 18 00 00 02",
    "00000050 0F A2 77 00 00 00 00 00",
    "00000058 7B 20 00 18 00 4F 00 00"
];


// ====================================================
// SPECIAL TERMINAL STATES
//
// 0 = normal
// 1 = MOTHER connected hold
// 2 = authority override progress
// 3 = final directive reveal
// 4 = WAKE
// 5 = FATHER branding
// 6 = MOTHER branding
// 7 = raw bootstrap / diagnostic console
// ====================================================

terminal_special_state = 0;

terminal_special_timer = 0;


// ====================================================
// BRANDING
// ====================================================

// Roughly 2.5 seconds each at 60 FPS.
father_brand_duration = 150;
mother_brand_duration = 165;


// Large identity blocks are printed into the terminal
// history and slide upward from below like oversized
// command-line program banners.
father_brand_rows = 15;
mother_brand_rows = 20;

brand_scroll_frames = 34;


// Cached transparent render targets for the placeholder
// vector identities. They are filtered by the same CRT
// overlays as every other terminal element.
father_brand_surface = -1;
mother_brand_surface = -1;


// ====================================================
// MOTHER
// ====================================================

mother_connected = false;

mother_pulse = 0;


// ====================================================
// AUTHORITY OVERRIDE
// ====================================================

overwrite_progress = 0;

overwrite_display_progress = 0;

overwrite_pause_timer = 0;

overwrite_conflict_shown = false;

overwrite_complete = false;


// ====================================================
// FINAL DIRECTIVE
// ====================================================

directive_stage = 0;

directive_timer = 0;

directive_pulse = 0;


// ====================================================
// WAKE FLOOD
//
// One restrained WAKE appears first. Then the terminal
// starts repeating it faster and faster while the normal
// terminal history scroll accelerates upward.
// ====================================================

wake_flood_started = false;
wake_flood_timer = 0;
wake_flood_next_print = 0;

wake_flood_start_frame = 150;
wake_flood_peak_frame = 205;
wake_flood_shutdown_frame = 265;

wake_flood_slow_interval = 10;
wake_flood_fast_interval = 2;

wake_flood_scroll_speed = 8.5;


// ====================================================
// CRT SHUTDOWN
// ====================================================

shutdown_timer = 0;

shutdown_duration = 52;


// ====================================================
// SLIDES
// ====================================================

slide_count = 6;

slide_index = 0;

slide_next_index = 0;

slide_changing = false;

slide_fade = 1;

slide_fade_speed = 0.08;

slide_input_lock = 0;


// Temporary placeholder colours.
slide_colours =
[
    make_color_rgb(
        92,
        63,
        42
    ),

    make_color_rgb(
        55,
        78,
        82
    ),

    make_color_rgb(
        110,
        66,
        48
    ),

    make_color_rgb(
        66,
        83,
        62
    ),

    make_color_rgb(
        105,
        73,
        43
    ),

    make_color_rgb(
        49,
        65,
        70
    )
];