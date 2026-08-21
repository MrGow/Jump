/// oB1LL — Draw GUI

var gui_w =
    display_get_gui_width();

var gui_h =
    display_get_gui_height();


// ====================================================
// SLIGHT SCREEN DIM
// ====================================================

if (
    dialogue_active &&
    dialogue_dim_alpha > 0
)
{
    draw_set_alpha(
        dialogue_dim_alpha *
        dialogue_alpha
    );

    draw_set_color(
        c_black
    );

    draw_rectangle(
        0,
        0,
        gui_w,
        gui_h,
        false
    );

    draw_set_alpha(
        1
    );
}


// ====================================================
// LETTERBOX
// ====================================================

if (letterbox_current > 0)
{
    var bar_h =
        round(
            letterbox_current
        );

    draw_set_alpha(
        1
    );

    draw_set_color(
        c_black
    );


    // Top bar
    draw_rectangle(
        0,
        0,
        gui_w,
        bar_h,
        false
    );


    // Bottom bar
    draw_rectangle(
        0,
        gui_h - bar_h,
        gui_w,
        gui_h,
        false
    );
}


// ====================================================
// NO ACTIVE DIALOGUE
// ====================================================

if (!dialogue_active)
{
    draw_set_alpha(
        1
    );

    draw_set_color(
        c_white
    );

    exit;
}


if (
    dialogue_line < 0 ||
    dialogue_line >=
    array_length(
        dialogue_lines
    )
)
{
    exit;
}


// ====================================================
// CAMERA
// ====================================================

var cam =
    view_camera[0];

if (cam == -1)
{
    exit;
}


var cam_x =
    camera_get_view_x(
        cam
    );

var cam_y =
    camera_get_view_y(
        cam
    );

var cam_w =
    camera_get_view_width(
        cam
    );

var cam_h =
    camera_get_view_height(
        cam
    );


// ====================================================
// WORLD → GUI
// ====================================================

var gui_x =
    (
        (x - cam_x)
        /
        cam_w
    )
    *
    gui_w;

var gui_y =
    (
        (
            y +
            dialogue_offset_y -
            cam_y
        )
        /
        cam_h
    )
    *
    gui_h;


// ====================================================
// CURRENT LINE
// ====================================================

var full_txt =
    string(
        dialogue_lines[
            dialogue_line
        ]
    );


// Only reveal currently typed characters.
var txt =
    string_copy(
        full_txt,
        1,
        clamp(
            floor(
                text_visible_chars
            ),
            0,
            string_length(
                full_txt
            )
        )
    );


// ====================================================
// FONT
// ====================================================

var font =
    asset_get_index(
        "PIXELOPERATORREGULAR16"
    );

if (font != -1)
{
    draw_set_font(
        font
    );
}

draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);


// ====================================================
// TEXT / BOX SIZE
//
// Size is calculated from the FULL line so the box
// remains stable while the typewriter effect runs.
// ====================================================

var padding_x =
    16;

var padding_y =
    8;


var text_w =
    min(
        dialogue_width,
        string_width(
            full_txt
        )
    );

var text_h =
    string_height_ext(
        full_txt,
        -1,
        dialogue_width
    );


var box_w =
    max(
        100,
        text_w +
        padding_x * 2
    );

var box_h =
    max(
        32,
        text_h +
        padding_y * 2
    );


// ====================================================
// KEEP BOX INSIDE SAFE AREA
// ====================================================

var safe_top =
    letterbox_current +
    box_h * 0.5 +
    8;

var safe_bottom =
    gui_h -
    letterbox_current -
    box_h * 0.5 -
    8;


gui_x =
    clamp(
        gui_x,
        box_w * 0.5 + 8,
        gui_w - box_w * 0.5 - 8
    );

gui_y =
    clamp(
        gui_y,
        safe_top,
        safe_bottom
    );


// ====================================================
// BOX BACKGROUND
//
// Slightly more opaque than before so bright areas
// such as the Scrapyard don't bleed through as much.
// ====================================================

draw_set_alpha(
    0.93 *
    dialogue_alpha
);

draw_set_color(
    make_color_rgb(
        8,
        12,
        20
    )
);

draw_rectangle(
    round(
        gui_x -
        box_w * 0.5
    ),
    round(
        gui_y -
        box_h * 0.5
    ),
    round(
        gui_x +
        box_w * 0.5
    ),
    round(
        gui_y +
        box_h * 0.5
    ),
    false
);


// ====================================================
// BOX OUTLINE
//
// Darker / more subdued than before so the text is
// always the brightest element.
// ====================================================

draw_set_alpha(
    dialogue_alpha
);

draw_set_color(
    make_color_rgb(
        140,
        155,
        165
    )
);

draw_rectangle(
    round(
        gui_x -
        box_w * 0.5
    ),
    round(
        gui_y -
        box_h * 0.5
    ),
    round(
        gui_x +
        box_w * 0.5
    ),
    round(
        gui_y +
        box_h * 0.5
    ),
    true
);


// ====================================================
// TYPEWRITER TEXT
//
// Slight cool-grey rather than pure white.
// ====================================================

draw_set_color(
    make_color_rgb(
        225,
        232,
        235
    )
);

draw_text_ext(
    round(gui_x),
    round(gui_y),
    txt,
    -1,
    dialogue_width
);


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_alpha(
    1
);

draw_set_color(
    c_white
);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);

draw_set_font(
    -1
);