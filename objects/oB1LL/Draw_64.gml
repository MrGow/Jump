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

    draw_set_color(c_black);

    draw_rectangle(
        0,
        0,
        gui_w,
        gui_h,
        false
    );

    draw_set_alpha(1);
}


// ====================================================
// LETTERBOX BARS
// ====================================================

if (letterbox_current > 0)
{
    var bar_h =
        round(
            letterbox_current
        );

    draw_set_alpha(1);
    draw_set_color(c_black);

    // Top
    draw_rectangle(
        0,
        0,
        gui_w,
        bar_h,
        false
    );

    // Bottom
    draw_rectangle(
        0,
        gui_h - bar_h,
        gui_w,
        gui_h,
        false
    );
}


// ====================================================
// NO DIALOGUE TEXT
// ====================================================

if (!dialogue_active)
{
    draw_set_color(c_white);
    draw_set_alpha(1);

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
// WORLD → GUI POSITION
// ====================================================

var cam =
    view_camera[0];

if (cam == -1)
{
    exit;
}

var cam_x =
    camera_get_view_x(cam);

var cam_y =
    camera_get_view_y(cam);

var cam_w =
    camera_get_view_width(cam);

var cam_h =
    camera_get_view_height(cam);

var gui_x =
    (
        (x - cam_x) /
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

var txt =
    string(
        dialogue_lines[
            dialogue_line
        ]
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
    draw_set_font(font);
}

draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);


// ====================================================
// BOX
// ====================================================

var padding_x = 12;
var padding_y = 8;

var text_w =
    min(
        dialogue_width,
        string_width(txt)
    );

var text_h =
    string_height(txt);

var box_w =
    max(
        100,
        text_w + padding_x * 2
    );

var box_h =
    max(
        32,
        text_h + padding_y * 2
    );


// Keep away from letterbox bars.
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
// ====================================================

draw_set_alpha(
    0.82 *
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
// OUTLINE
// ====================================================

draw_set_alpha(
    dialogue_alpha
);

draw_set_color(
    make_color_rgb(
        180,
        190,
        200
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
// TEXT
// ====================================================

draw_set_color(c_white);

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

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);