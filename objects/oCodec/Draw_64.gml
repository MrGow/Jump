/// oCodec — Draw GUI


var gw =
    display_get_gui_width();

var gh =
    display_get_gui_height();

var cx =
    gw * 0.5;

var cy =
    gh * 0.5;


// ====================================================
// INCOMING CALL
// ====================================================

if (codec_state == 0)
{
    if (call_visible)
    {
        draw_set_alpha(1);

        draw_set_font(
            PIXELOPERATORBOLD18
        );

        draw_set_halign(
            fa_center
        );

        draw_set_valign(
            fa_middle
        );

        draw_set_color(
            call_colour
        );


        draw_text(
            cx,
            cy,
            "[ CALL ]"
        );
    }


    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    exit;
}


// ====================================================
// BACKGROUND DARKEN
// ====================================================

draw_set_alpha(
    0.82 *
    ui_alpha
);

draw_set_color(
    c_black
);


draw_rectangle(
    0,
    0,
    gw,
    gh,
    false
);


// ====================================================
// MAIN PANEL
// ====================================================

var panel_x = 28;
var panel_y = 28;

var panel_w =
    gw - 56;

var panel_h =
    gh - 56;


draw_set_alpha(
    ui_alpha
);

draw_set_color(
    codec_bg
);


draw_rectangle(
    panel_x,
    panel_y,

    panel_x +
    panel_w,

    panel_y +
    panel_h,

    false
);


// ====================================================
// MAIN BORDER
// ====================================================

draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    panel_x,
    panel_y,

    panel_x +
    panel_w,

    panel_y +
    panel_h,

    true
);


// ====================================================
// PORTRAIT GEOMETRY
// ====================================================

var portrait_y =
    panel_y + 42;

var portrait_w = 136;
var portrait_h = 126;


var left_x =
    panel_x + 14;


var right_x =
    panel_x +
    panel_w -
    portrait_w -
    14;


// ====================================================
// PORTRAIT OPENING GEOMETRY
// ====================================================

var portrait_visible_h =
    portrait_h *
    portrait_open;


var portrait_open_top =
    portrait_y +
    (
        portrait_h -
        portrait_visible_h
    ) *
    0.5;


var portrait_open_bottom =
    portrait_open_top +
    portrait_visible_h;


// ====================================================
// PORTRAIT DARK BACKGROUNDS
// ====================================================

draw_set_color(
    make_color_rgb(
        3,
        13,
        11
    )
);


draw_rectangle(
    left_x,
    portrait_open_top,

    left_x +
    portrait_w,

    portrait_open_bottom,

    false
);


draw_rectangle(
    right_x,
    portrait_open_top,

    right_x +
    portrait_w,

    portrait_open_bottom,

    false
);


// ====================================================
// JUMPBOT PORTRAIT
// ====================================================

if (jumpbot_sprite != -1)
{
    var portrait_inner_left =
        left_x +
        jumpbot_portrait_padding_x;

    var portrait_inner_right =
        left_x +
        portrait_w -
        jumpbot_portrait_padding_x;

    var portrait_inner_top =
        portrait_y +
        jumpbot_portrait_padding_y;

    var portrait_inner_bottom =
        portrait_y +
        portrait_h -
        jumpbot_portrait_padding_y;


    var portrait_inner_w =
        portrait_inner_right -
        portrait_inner_left;

    var portrait_inner_h =
        portrait_inner_bottom -
        portrait_inner_top;


    var jb_xoff =
        sprite_get_xoffset(
            jumpbot_sprite
        );

    var jb_yoff =
        sprite_get_yoffset(
            jumpbot_sprite
        );


    var jb_bbox_l =
        sprite_get_bbox_left(
            jumpbot_sprite
        );

    var jb_bbox_r =
        sprite_get_bbox_right(
            jumpbot_sprite
        );

    var jb_bbox_t =
        sprite_get_bbox_top(
            jumpbot_sprite
        );

    var jb_bbox_b =
        sprite_get_bbox_bottom(
            jumpbot_sprite
        );


    var jb_visible_w =
        max(
            1,
            jb_bbox_r -
            jb_bbox_l +
            1
        );

    var jb_visible_h =
        max(
            1,
            jb_bbox_b -
            jb_bbox_t +
            1
        );


    var jb_scale_x =
        portrait_inner_w /
        jb_visible_w;

    var jb_scale_y =
        portrait_inner_h /
        jb_visible_h;


    var jb_scale =
        min(
            jb_scale_x,
            jb_scale_y
        );


    var jb_local_cx =
        (
            (
                jb_bbox_l +
                jb_bbox_r
            ) *
            0.5
        ) -
        jb_xoff;


    var jb_local_cy =
        (
            (
                jb_bbox_t +
                jb_bbox_b
            ) *
            0.5
        ) -
        jb_yoff;


    var jb_visible_centre_x =
        left_x +
        portrait_w *
        0.5;


    var jb_visible_centre_y =
        portrait_y +
        portrait_h *
        0.5;


    var jb_draw_x =
        jb_visible_centre_x -
        jb_local_cx *
        jb_scale;


    var jb_draw_y =
        jb_visible_centre_y -
        jb_local_cy *
        jb_scale;


    draw_sprite_ext(
        jumpbot_sprite,
        jumpbot_portrait_frame,

        round(jb_draw_x),
        round(jb_draw_y),

        jb_scale,
        jb_scale,

        0,

        make_color_rgb(
            145,
            235,
            185
        ),

        ui_alpha
    );


    // =================================================
    // BIRD
    // =================================================

    if (bird_portrait_sprite != -1)
    {
        var jb_local_top =
            jb_bbox_t -
            jb_yoff;


        var jb_codec_top =
            jb_draw_y +
            jb_local_top *
            jb_scale;


        var bird_anchor_x =
            jb_visible_centre_x +
            bird_codec_perch_x *
            jb_scale;


        var bird_anchor_y =
            jb_codec_top +
            bird_codec_perch_y *
            jb_scale;


        var bird_xoff =
            sprite_get_xoffset(
                bird_portrait_sprite
            );

        var bird_yoff =
            sprite_get_yoffset(
                bird_portrait_sprite
            );


        var bird_bbox_l =
            sprite_get_bbox_left(
                bird_portrait_sprite
            );

        var bird_bbox_r =
            sprite_get_bbox_right(
                bird_portrait_sprite
            );

        var bird_bbox_b =
            sprite_get_bbox_bottom(
                bird_portrait_sprite
            );


        var bird_local_cx =
            (
                (
                    bird_bbox_l +
                    bird_bbox_r
                ) *
                0.5
            ) -
            bird_xoff;


        var bird_local_bottom =
            bird_bbox_b -
            bird_yoff;


        var bird_draw_x =
            bird_anchor_x -
            bird_local_cx *
            jb_scale;


        var bird_draw_y =
            bird_anchor_y -
            bird_local_bottom *
            jb_scale;


        draw_sprite_ext(
            bird_portrait_sprite,
            bird_portrait_frame,

            round(bird_draw_x),
            round(bird_draw_y),

            jb_scale,
            jb_scale,

            0,

            make_color_rgb(
                145,
                235,
                185
            ),

            ui_alpha
        );
    }
}


// ====================================================
// B1LL-E PORTRAIT / PLACEHOLDER
// ====================================================

var bill_cx =
    right_x +
    portrait_w *
    0.5;


var bill_cy =
    portrait_y +
    portrait_h *
    0.5;


if (bille_sprite != -1)
{
    draw_sprite_ext(
        bille_sprite,
        0,

        bill_cx,
        bill_cy,

        1,
        1,

        0,

        make_color_rgb(
            145,
            235,
            185
        ),

        ui_alpha
    );
}
else
{
    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );

    draw_set_font(
        PIXELOPERATORBOLD14
    );

    draw_set_color(
        codec_colour_dim
    );


    draw_text(
        bill_cx,
        bill_cy,
        "B1LL-E#SIGNAL"
    );
}


// ====================================================
// PERMANENT PORTRAIT CROP
//
// Anything drawn outside the actual portrait rectangle
// is covered.
//
// This contains JumpBot, B1LL-E and especially the bird.
// ====================================================

draw_set_alpha(
    ui_alpha
);

draw_set_color(
    codec_bg
);


// ----------------------------------------------------
// LEFT PORTRAIT CROP
// ----------------------------------------------------

// Above.
draw_rectangle(
    left_x - 8,
    portrait_y - 40,

    left_x +
    portrait_w + 8,

    portrait_y,

    false
);


// Below.
draw_rectangle(
    left_x - 8,
    portrait_y +
    portrait_h,

    left_x +
    portrait_w + 8,

    portrait_y +
    portrait_h +
    40,

    false
);


// Left.
draw_rectangle(
    left_x - 40,
    portrait_y,

    left_x,
    portrait_y +
    portrait_h,

    false
);


// Right.
draw_rectangle(
    left_x +
    portrait_w,
    portrait_y,

    left_x +
    portrait_w +
    40,

    portrait_y +
    portrait_h,

    false
);


// ----------------------------------------------------
// RIGHT PORTRAIT CROP
// ----------------------------------------------------

// Above.
draw_rectangle(
    right_x - 8,
    portrait_y - 40,

    right_x +
    portrait_w + 8,

    portrait_y,

    false
);


// Below.
draw_rectangle(
    right_x - 8,
    portrait_y +
    portrait_h,

    right_x +
    portrait_w + 8,

    portrait_y +
    portrait_h +
    40,

    false
);


// Left.
draw_rectangle(
    right_x - 40,
    portrait_y,

    right_x,
    portrait_y +
    portrait_h,

    false
);


// Right.
draw_rectangle(
    right_x +
    portrait_w,
    portrait_y,

    right_x +
    portrait_w +
    40,

    portrait_y +
    portrait_h,

    false
);


// ====================================================
// PORTRAIT OPENING MASK
//
// Also crop the currently closed portion of each
// portrait during the opening transition.
// ====================================================

if (portrait_open < 1)
{
    draw_set_alpha(
        ui_alpha
    );

    draw_set_color(
        codec_bg
    );


    // LEFT TOP
    draw_rectangle(
        left_x,
        portrait_y,

        left_x +
        portrait_w,

        portrait_open_top,

        false
    );


    // LEFT BOTTOM
    draw_rectangle(
        left_x,
        portrait_open_bottom,

        left_x +
        portrait_w,

        portrait_y +
        portrait_h,

        false
    );


    // RIGHT TOP
    draw_rectangle(
        right_x,
        portrait_y,

        right_x +
        portrait_w,

        portrait_open_top,

        false
    );


    // RIGHT BOTTOM
    draw_rectangle(
        right_x,
        portrait_open_bottom,

        right_x +
        portrait_w,

        portrait_y +
        portrait_h,

        false
    );
}


// ====================================================
// GREEN PORTRAIT MONITOR OVERLAY
// ====================================================

draw_set_alpha(
    0.13 *
    ui_alpha
);

draw_set_color(
    make_color_rgb(
        70,
        255,
        145
    )
);


draw_rectangle(
    left_x,
    portrait_open_top,

    left_x +
    portrait_w,

    portrait_open_bottom,

    false
);


draw_rectangle(
    right_x,
    portrait_open_top,

    right_x +
    portrait_w,

    portrait_open_bottom,

    false
);


// ====================================================
// DARKEN PORTRAIT FEEDS
// ====================================================

draw_set_alpha(
    0.16 *
    ui_alpha
);

draw_set_color(
    c_black
);


draw_rectangle(
    left_x,
    portrait_open_top,

    left_x +
    portrait_w,

    portrait_open_bottom,

    false
);


draw_rectangle(
    right_x,
    portrait_open_top,

    right_x +
    portrait_w,

    portrait_open_bottom,

    false
);


// ====================================================
// PORTRAIT FINE SCANLINES
// ====================================================

draw_set_alpha(
    0.10 *
    ui_alpha
);

draw_set_color(
    c_black
);


var portrait_scan_spacing = 3;


for (
    var sy =
        portrait_open_top + 1;

    sy <
        portrait_open_bottom;

    sy +=
        portrait_scan_spacing
)
{
    draw_line(
        left_x,
        sy,

        left_x +
        portrait_w,

        sy
    );


    draw_line(
        right_x,
        sy,

        right_x +
        portrait_w,

        sy
    );
}


// ====================================================
// MOVING PORTRAIT SCAN BAND
// ====================================================

var scan_cycle_ms =
    2800;


var scan_progress =
    (
        current_time
        mod
        scan_cycle_ms
    )
    /
    scan_cycle_ms;


var moving_scan_y =
    portrait_y +
    scan_progress *
    portrait_h;


var moving_scan_h =
    10;


if (
    moving_scan_y >=
    portrait_open_top &&
    moving_scan_y <=
    portrait_open_bottom
)
{
    draw_set_alpha(
        0.10 *
        ui_alpha
    );

    draw_set_color(
        make_color_rgb(
            155,
            255,
            200
        )
    );


    draw_rectangle(
        left_x,
        max(
            portrait_open_top,
            moving_scan_y -
            moving_scan_h * 0.5
        ),

        left_x +
        portrait_w,

        min(
            portrait_open_bottom,
            moving_scan_y +
            moving_scan_h * 0.5
        ),

        false
    );


    draw_rectangle(
        right_x,
        max(
            portrait_open_top,
            moving_scan_y -
            moving_scan_h * 0.5
        ),

        right_x +
        portrait_w,

        min(
            portrait_open_bottom,
            moving_scan_y +
            moving_scan_h * 0.5
        ),

        false
    );


    draw_set_alpha(
        0.18 *
        ui_alpha
    );

    draw_set_color(
        make_color_rgb(
            190,
            255,
            220
        )
    );


    draw_line(
        left_x,
        moving_scan_y,

        left_x +
        portrait_w,

        moving_scan_y
    );


    draw_line(
        right_x,
        moving_scan_y,

        right_x +
        portrait_w,

        moving_scan_y
    );
}


// ====================================================
// ANIMATED PORTRAIT BORDERS
// ====================================================

draw_set_alpha(
    ui_alpha
);

draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    left_x,
    portrait_open_top,

    left_x +
    portrait_w,

    portrait_open_bottom,

    true
);


draw_rectangle(
    right_x,
    portrait_open_top,

    right_x +
    portrait_w,

    portrait_open_bottom,

    true
);


// ====================================================
// PORTRAIT NAMES
//
// Raised slightly so they no longer touch the portrait.
// Was portrait_y - 14.
// ====================================================

draw_set_font(
    PIXELOPERATORBOLD14
);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);

draw_set_color(
    codec_colour
);


draw_text(
    left_x,
    portrait_y - 18,
    "JUMPBOT"
);


draw_text(
    right_x,
    portrait_y - 18,
    "B1LL-E"
);


// ====================================================
// CENTRE MODULE
// ====================================================

var freq_left =
    left_x +
    portrait_w +
    14;


var freq_right =
    right_x -
    14;


var freq_top =
    portrait_y;


var freq_bottom =
    portrait_y +
    portrait_h;


draw_set_alpha(
    ui_alpha
);

draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    freq_left,
    freq_top,

    freq_right,
    freq_bottom,

    true
);


// ====================================================
// PTT HEADER
// ====================================================

var ptt_w = 74;
var ptt_h = 18;

var ptt_x =
    (
        freq_left +
        freq_right
    ) *
    0.5;


var ptt_y =
    freq_top -
    28;


draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    ptt_x -
    ptt_w * 0.5,

    ptt_y,

    ptt_x +
    ptt_w * 0.5,

    ptt_y +
    ptt_h,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    ptt_x -
    ptt_w * 0.5,

    ptt_y,

    ptt_x +
    ptt_w * 0.5,

    ptt_y +
    ptt_h,

    true
);


draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);

draw_set_font(
    PIXELOPERATORBOLD14
);

draw_set_color(
    codec_colour
);


draw_text(
    ptt_x,
    ptt_y +
    ptt_h * 0.5,
    "PTT"
);


// ====================================================
// CENTRE CONTENT
// ====================================================

var centre_mid_x =
    (
        freq_left +
        freq_right
    ) *
    0.5;


// ====================================================
// ARROWS
//
// These now sit INSIDE the centre module.
//
// Previous positions put the centre of each arrow box
// partly inside the portrait.
// ====================================================

var arrow_box_w = 18;
var arrow_box_h = 24;

var arrow_y =
    freq_top + 62;


var arrow_left_x =
    freq_left + 11;


var arrow_right_x =
    freq_right - 11;


// ----------------------------------------------------
// LEFT
// ----------------------------------------------------

draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    arrow_left_x -
    arrow_box_w * 0.5,

    arrow_y -
    arrow_box_h * 0.5,

    arrow_left_x +
    arrow_box_w * 0.5,

    arrow_y +
    arrow_box_h * 0.5,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    arrow_left_x -
    arrow_box_w * 0.5,

    arrow_y -
    arrow_box_h * 0.5,

    arrow_left_x +
    arrow_box_w * 0.5,

    arrow_y +
    arrow_box_h * 0.5,

    true
);


// ----------------------------------------------------
// RIGHT
// ----------------------------------------------------

draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    arrow_right_x -
    arrow_box_w * 0.5,

    arrow_y -
    arrow_box_h * 0.5,

    arrow_right_x +
    arrow_box_w * 0.5,

    arrow_y +
    arrow_box_h * 0.5,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    arrow_right_x -
    arrow_box_w * 0.5,

    arrow_y -
    arrow_box_h * 0.5,

    arrow_right_x +
    arrow_box_w * 0.5,

    arrow_y +
    arrow_box_h * 0.5,

    true
);


// ----------------------------------------------------
// SYMBOLS
// ----------------------------------------------------

draw_set_font(
    PIXELOPERATORBOLD14
);

draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);

draw_set_color(
    codec_colour
);


draw_text(
    arrow_left_x,
    arrow_y,
    "<"
);


draw_text(
    arrow_right_x,
    arrow_y,
    ">"
);


// ====================================================
// VOICE METER
// ====================================================

var meter_width = 42;

var meter_x =
    centre_mid_x -
    58;


var meter_bottom =
    freq_top + 91;


var bar_count = 7;


for (
    var i = 0;
    i < bar_count;
    i++
)
{
    var bar_width =
        meter_width -
        i * 4;


    var bar_y =
        meter_bottom -
        i * 9;


    if (
        i <
        voice_meter_level
    )
    {
        draw_set_color(
            codec_colour_bright
        );
    }
    else
    {
        draw_set_color(
            codec_colour_dim
        );
    }


    draw_rectangle(
        meter_x,
        bar_y,

        meter_x +
        bar_width,

        bar_y + 4,

        false
    );
}


// ====================================================
// FREQUENCY
// ====================================================

var frequency_x =
    centre_mid_x +
    34;


var frequency_y =
    freq_top + 62;


draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);

draw_set_font(
    codec_frequency_font
);

draw_set_color(
    codec_colour_bright
);


draw_text(
    frequency_x,
    frequency_y,
    codec_frequency
);


// ====================================================
// MEMORY
// ====================================================

draw_set_font(
    PIXELOPERATORBOLD14
);

draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);


var memory_w = 82;
var memory_h = 17;

var memory_x =
    centre_mid_x;


var memory_y =
    freq_bottom -
    22;


draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    memory_x -
    memory_w * 0.5,

    memory_y,

    memory_x +
    memory_w * 0.5,

    memory_y +
    memory_h,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    memory_x -
    memory_w * 0.5,

    memory_y,

    memory_x +
    memory_w * 0.5,

    memory_y +
    memory_h,

    true
);


draw_set_color(
    codec_colour
);


draw_text(
    memory_x,
    memory_y +
    memory_h * 0.5,
    "MEMORY"
);


// ====================================================
// DIALOGUE BOX
// ====================================================

var text_x =
    panel_x + 14;


var text_y =
    portrait_y +
    portrait_h +
    15;


var text_w =
    panel_w - 28;


var text_h =
    panel_y +
    panel_h -
    text_y -
    14;


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    text_x,
    text_y,

    text_x +
    text_w,

    text_y +
    text_h,

    true
);


// ====================================================
// SPEAKER
// ====================================================

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);

draw_set_font(
    PIXELOPERATORBOLD14
);

draw_set_color(
    codec_colour
);


draw_text(
    text_x + 12,
    text_y + 10,
    current_speaker
);


// ====================================================
// DIALOGUE
// ====================================================

draw_set_font(
    PIXELOPERATORBOLD14
);


draw_set_color(
    make_color_rgb(
        175,
        225,
        205
    )
);


draw_text_ext(
    text_x + 12,
    text_y + 31,

    display_text,

    4,
    text_w - 24
);


// ====================================================
// ADVANCE PROMPT
// ====================================================

if (
    codec_state == 2 &&
    line_finished
)
{
    var blink =
        (
            (
                current_time div 350
            )
            mod 2
        )
        == 0;


    if (blink)
    {
        draw_set_halign(
            fa_right
        );

        draw_set_font(
            PIXELOPERATORREGULAR10
        );

        draw_set_color(
            codec_colour
        );


        draw_text(
            text_x +
            text_w -
            10,

            text_y +
            text_h -
            14,

            "[SPACE]"
        );
    }
}


// ====================================================
// SUBTLE WHOLE-CODEC SCANLINES
// ====================================================

draw_set_alpha(
    0.025 *
    ui_alpha
);

draw_set_color(
    c_black
);


for (
    var gui_scan_y =
        panel_y;

    gui_scan_y <
        panel_y +
        panel_h;

    gui_scan_y += 4
)
{
    draw_line(
        panel_x,
        gui_scan_y,

        panel_x +
        panel_w,

        gui_scan_y
    );
}


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);

draw_set_color(c_white);

draw_set_font(-1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);