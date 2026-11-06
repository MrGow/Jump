/// oScrapChiefController — Draw GUI

if (!debug_elevator)
{
    exit;
}

var state_text =
    state_names[elevator_state];

var elapsed_seconds =
    total_timer / room_speed;

var remaining = 0;

if (instance_exists(platform))
{
    remaining = max(
        0,
        end_platform_x - platform.x
    );
}


// ====================================================
// BACKGROUND
// ====================================================

draw_set_alpha(0.75);
draw_set_color(c_black);

draw_rectangle(
    8, 8,
    270, 110,
    false
);

draw_set_alpha(1);
draw_set_color(c_white);


// ====================================================
// TEXT
// ====================================================

draw_text(
    16, 14,
    "SCRAP CHIEF ELEVATOR TEST"
);

draw_text(
    16, 34,
    "STATE: " + state_text
);

draw_text(
    16, 54,
    "TIME: " +
    string_format(elapsed_seconds, 0, 1) +
    " s"
);

draw_text(
    16, 74,
    "DISTANCE LEFT: " +
    string(round(remaining)) +
    " px"
);

draw_text(
    16, 94,
    "SPEED: " +
    string_format(current_speed, 0, 2)
);