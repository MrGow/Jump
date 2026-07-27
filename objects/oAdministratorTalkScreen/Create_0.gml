/// oAdministratorTalkScreen — Create


// ====================================================
// EDITOR VARIABLE SAFETY
//
// These are intended to exist as Variable Definitions,
// but these fallbacks make the object safe even if one
// has not been added yet.
//
// IMPORTANT:
// Existing editor/instance values are NOT overwritten.
// ====================================================

if (!variable_instance_exists(id, "screen_mode"))
{
    screen_mode = "typewriter";
}

if (!variable_instance_exists(id, "message"))
{
    message =
        "DEVIANT UNIT DETECTED.#" +
        "REMAIN WHERE YOU ARE.";
}

if (!variable_instance_exists(id, "trigger_distance"))
{
    trigger_distance = 180;
}

if (!variable_instance_exists(id, "scroll_speed"))
{
    scroll_speed = 1;
}

if (!variable_instance_exists(id, "scroll_spacing"))
{
    scroll_spacing = 48;
}


// ====================================================
// DISPLAY STATE
// ====================================================

display_text = "";

activated = false;
finished  = false;


// ====================================================
// SCREEN STATE
//
// 0 = dormant
// 1 = boot line
// 2 = boot data
// 3 = short blank pause
// 4 = active behaviour
// 5 = finished typewriter
// ====================================================

screen_state = 0;


// ====================================================
// TYPEWRITER
// ====================================================

type_delay = 2;
type_timer = 0;

char_index = 0;


// ====================================================
// BOOT TIMING
// ====================================================

boot_line_frames = 14;
boot_line_timer  = 0;

boot_data_frames = 50;
boot_data_timer  = 0;

boot_clear_frames = 14;
boot_clear_timer  = 0;


// ====================================================
// BOOT LINE
// ====================================================

boot_line_progress = 0;

boot_line_colour =
    make_color_rgb(
        225,
        225,
        210
    );


// ====================================================
// BOOT DATA
// ====================================================

boot_data_text = "";

boot_data_refresh = 4;
boot_data_refresh_timer = 0;

boot_data_rows = 3;


// ====================================================
// CURSOR
// ====================================================

cursor_timer = 0;
cursor_speed = 24;

cursor_visible = true;


// ====================================================
// FONT
// ====================================================

text_font =
    asset_get_index(
        "PIXELOPERATORBOLD14"
    );

text_left_padding = 10;
text_top_padding  = 10;


// ====================================================
// COLOURS
// ====================================================

// Normal Administrator speech.
normal_text_colour =
    make_color_rgb(
        225,
        225,
        210
    );


// STOP / warning ticker.
warning_text_colour =
    make_color_rgb(
        235,
        70,
        55
    );


// Boot terminal garbage.
boot_text_colour =
    make_color_rgb(
        170,
        170,
        155
    );


// ====================================================
// SCROLL INTERNAL STATE
// ====================================================

scroll_x = 0;
scroll_surface = -1;

// ====================================================
// SCREEN BRIGHTNESS
// ====================================================

screen_alpha = 0.70;
target_screen_alpha = 0.70;


// ====================================================
// AUDIO
// ====================================================

snd_boot = -1;
snd_type = -1;

boot_sfx_gain = 0.50;
type_sfx_gain = 0.35;


// ====================================================
// RANDOM BOOT DATA
// ====================================================

make_boot_data = function()
{
    var result = "";

    var chars =
        "01ABCDEF<>[]{}:/+-_";


    for (
        var row = 0;
        row < boot_data_rows;
        row++
    )
    {
        var row_text = "";

        var row_len =
            irandom_range(
                12,
                20
            );


        for (
            var i = 0;
            i < row_len;
            i++
        )
        {
            var index =
                irandom_range(
                    1,
                    string_length(chars)
                );


            row_text +=
                string_char_at(
                    chars,
                    index
                );
        }


        result += row_text;


        if (
            row <
            boot_data_rows - 1
        )
        {
            result += "#";
        }
    }


    return result;
};