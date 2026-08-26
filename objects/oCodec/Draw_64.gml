/// oCodec — Draw GUI


// ====================================================
// INITIALIZATION SAFETY
// ====================================================

if (
    !variable_instance_exists(
        id,
        "codec_initialized"
    ) ||
    !codec_initialized
)
{
    exit;
}


// ====================================================
// GUI SIZE
// ====================================================

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
// GUI -> BACKBUFFER SCALE
// ====================================================

var backbuffer_w =
    window_get_width();

var backbuffer_h =
    window_get_height();


var gui_to_screen_x =
    backbuffer_w /
    max(
        1,
        gw
    );


var gui_to_screen_y =
    backbuffer_h /
    max(
        1,
        gh
    );


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
    panel_x + panel_w,
    panel_y + panel_h,
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
    panel_x + panel_w,
    panel_y + panel_h,
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
// PORTRAIT OPENING
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
// PORTRAIT BACKGROUNDS
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
    left_x + portrait_w,
    portrait_open_bottom,
    false
);


draw_rectangle(
    right_x,
    portrait_open_top,
    right_x + portrait_w,
    portrait_open_bottom,
    false
);


// ====================================================
// SAVE SCISSOR
// ====================================================

var original_scissor =
    gpu_get_scissor();


// ====================================================
// LEFT SCISSOR
// ====================================================

var left_scissor_x =
    round(
        left_x *
        gui_to_screen_x
    );

var left_scissor_y =
    round(
        portrait_open_top *
        gui_to_screen_y
    );

var left_scissor_w =
    max(
        1,
        round(
            portrait_w *
            gui_to_screen_x
        )
    );

var left_scissor_h =
    max(
        1,
        round(
            portrait_visible_h *
            gui_to_screen_y
        )
    );


gpu_set_scissor(
    left_scissor_x,
    left_scissor_y,
    left_scissor_w,
    left_scissor_h
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


    var jb_base_scale =
        min(
            portrait_inner_w /
                jb_visible_w,

            portrait_inner_h /
                jb_visible_h
        );


    var jb_scale =
        jb_base_scale *
        lerp(
            1,
            jumpbot_zoom_max,
            jumpbot_zoom_amount
        );


    var jb_normal_local_x =
        (
            (
                jb_bbox_l +
                jb_bbox_r
            ) *
            0.5
        ) -
        jb_xoff;


    var jb_normal_local_y =
        (
            (
                jb_bbox_t +
                jb_bbox_b
            ) *
            0.5
        ) -
        jb_yoff;


    var jb_face_sprite_y =
        jb_bbox_t +
        (
            jb_bbox_b -
            jb_bbox_t
        ) *
        jumpbot_zoom_face_y;


    var jb_face_local_y =
        jb_face_sprite_y -
        jb_yoff;


    var jb_focus_local_x =
        jb_normal_local_x;


    var jb_focus_local_y =
        lerp(
            jb_normal_local_y,
            jb_face_local_y,
            jumpbot_zoom_amount
        );


    var jb_focus_screen_x =
        left_x +
        portrait_w *
        0.5;


    var jb_focus_screen_y =
        lerp(
            portrait_y +
                portrait_h *
                0.5,

            portrait_y +
                portrait_h *
                jumpbot_zoom_screen_y,

            jumpbot_zoom_amount
        );


    var jb_draw_x =
        jb_focus_screen_x -
        jb_focus_local_x *
        jb_scale;


    var jb_draw_y =
        jb_focus_screen_y -
        jb_focus_local_y *
        jb_scale;


    // ------------------------------------------------
    // NORMAL IMAGE
    // ------------------------------------------------

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


    // ------------------------------------------------
    // TRANSMISSION TEAR
    // ------------------------------------------------

    if (
        jumpbot_tear_active &&
        portrait_open >= 1
    )
    {
        var jb_tear_top =
            portrait_y +
            jumpbot_tear_y;


        var jb_tear_bottom =
            min(
                portrait_y +
                portrait_h,

                jb_tear_top +
                jumpbot_tear_h
            );


        gpu_set_scissor(
            round(
                left_x *
                gui_to_screen_x
            ),

            round(
                jb_tear_top *
                gui_to_screen_y
            ),

            max(
                1,
                round(
                    portrait_w *
                    gui_to_screen_x
                )
            ),

            max(
                1,
                round(
                    (
                        jb_tear_bottom -
                        jb_tear_top
                    )
                    *
                    gui_to_screen_y
                )
            )
        );


        draw_sprite_ext(
            jumpbot_sprite,
            jumpbot_portrait_frame,
            round(
                jb_draw_x +
                jumpbot_tear_xoff
            ),
            round(jb_draw_y),
            jb_scale,
            jb_scale,
            0,
            make_color_rgb(
                160,
                245,
                200
            ),
            ui_alpha
        );


        gpu_set_scissor(
            left_scissor_x,
            left_scissor_y,
            left_scissor_w,
            left_scissor_h
        );
    }


    // ------------------------------------------------
    // BIRD
    // ------------------------------------------------

    if (bird_portrait_sprite != -1)
    {
        var jb_local_top =
            jb_bbox_t -
            jb_yoff;


        var jb_codec_top =
            jb_draw_y +
            jb_local_top *
            jb_scale;


        var jb_visible_centre_sprite_x =
            (
                (
                    jb_bbox_l +
                    jb_bbox_r
                ) *
                0.5
            ) -
            jb_xoff;


        var jb_codec_centre_x =
            jb_draw_x +
            jb_visible_centre_sprite_x *
            jb_scale;


        var bird_anchor_x =
            jb_codec_centre_x +
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
// RESTORE LEFT
// ====================================================

gpu_set_scissor(
    original_scissor
);


// ====================================================
// RIGHT SCISSOR
// ====================================================

var right_scissor_x =
    round(
        right_x *
        gui_to_screen_x
    );

var right_scissor_y =
    round(
        portrait_open_top *
        gui_to_screen_y
    );

var right_scissor_w =
    max(
        1,
        round(
            portrait_w *
            gui_to_screen_x
        )
    );

var right_scissor_h =
    max(
        1,
        round(
            portrait_visible_h *
            gui_to_screen_y
        )
    );


gpu_set_scissor(
    right_scissor_x,
    right_scissor_y,
    right_scissor_w,
    right_scissor_h
);


// ====================================================
// B1LL-E PORTRAIT
// ====================================================

if (bille_active_sprite != -1)
{
    var bill_inner_w =
        portrait_w -
        bille_portrait_padding_x *
        2;


    var bill_inner_h =
        portrait_h -
        bille_portrait_padding_y *
        2;


    var bill_xoff =
        sprite_get_xoffset(
            bille_active_sprite
        );

    var bill_yoff =
        sprite_get_yoffset(
            bille_active_sprite
        );


    var bill_bbox_l =
        sprite_get_bbox_left(
            bille_active_sprite
        );

    var bill_bbox_r =
        sprite_get_bbox_right(
            bille_active_sprite
        );

    var bill_bbox_t =
        sprite_get_bbox_top(
            bille_active_sprite
        );

    var bill_bbox_b =
        sprite_get_bbox_bottom(
            bille_active_sprite
        );


    var bill_visible_w =
        max(
            1,
            bill_bbox_r -
            bill_bbox_l +
            1
        );


    var bill_visible_h =
        max(
            1,
            bill_bbox_b -
            bill_bbox_t +
            1
        );


    var bill_base_scale =
        min(
            bill_inner_w /
                bill_visible_w,

            bill_inner_h /
                bill_visible_h
        );


    var bill_scale =
        bill_base_scale *
        lerp(
            1,
            bille_zoom_max,
            bille_zoom_amount
        );


    var bill_normal_local_x =
        (
            (
                bill_bbox_l +
                bill_bbox_r
            ) *
            0.5
        ) -
        bill_xoff;


    var bill_normal_local_y =
        (
            (
                bill_bbox_t +
                bill_bbox_b
            ) *
            0.5
        ) -
        bill_yoff;


    var bill_face_sprite_y =
        bill_bbox_t +
        (
            bill_bbox_b -
            bill_bbox_t
        ) *
        bille_zoom_face_y;


    var bill_face_local_y =
        bill_face_sprite_y -
        bill_yoff;


    var bill_focus_local_x =
        bill_normal_local_x;


    var bill_focus_local_y =
        lerp(
            bill_normal_local_y,
            bill_face_local_y,
            bille_zoom_amount
        );


    var bill_focus_screen_x =
        right_x +
        portrait_w *
        0.5;


    var bill_focus_screen_y =
        lerp(
            portrait_y +
                portrait_h *
                0.5,

            portrait_y +
                portrait_h *
                bille_zoom_screen_y,

            bille_zoom_amount
        );


    var bill_draw_x =
        bill_focus_screen_x -
        bill_focus_local_x *
        bill_scale;


    var bill_draw_y =
        bill_focus_screen_y -
        bill_focus_local_y *
        bill_scale;


    // ------------------------------------------------
    // NORMAL IMAGE
    // ------------------------------------------------

    draw_sprite_ext(
        bille_active_sprite,
        bille_portrait_frame,
        round(bill_draw_x),
        round(bill_draw_y),
        bill_scale,
        bill_scale,
        0,
        make_color_rgb(
            145,
            235,
            185
        ),
        ui_alpha
    );


    // ------------------------------------------------
    // TRANSMISSION TEAR
    // ------------------------------------------------

    if (
        bille_tear_active &&
        portrait_open >= 1
    )
    {
        var bill_tear_top =
            portrait_y +
            bille_tear_y;


        var bill_tear_bottom =
            min(
                portrait_y +
                portrait_h,

                bill_tear_top +
                bille_tear_h
            );


        gpu_set_scissor(
            round(
                right_x *
                gui_to_screen_x
            ),

            round(
                bill_tear_top *
                gui_to_screen_y
            ),

            max(
                1,
                round(
                    portrait_w *
                    gui_to_screen_x
                )
            ),

            max(
                1,
                round(
                    (
                        bill_tear_bottom -
                        bill_tear_top
                    )
                    *
                    gui_to_screen_y
                )
            )
        );


        draw_sprite_ext(
            bille_active_sprite,
            bille_portrait_frame,
            round(
                bill_draw_x +
                bille_tear_xoff
            ),
            round(bill_draw_y),
            bill_scale,
            bill_scale,
            0,
            make_color_rgb(
                160,
                245,
                200
            ),
            ui_alpha
        );


        gpu_set_scissor(
            right_scissor_x,
            right_scissor_y,
            right_scissor_w,
            right_scissor_h
        );
    }
}


// ====================================================
// RESTORE RIGHT
// ====================================================

gpu_set_scissor(
    original_scissor
);


// ====================================================
// GREEN MONITOR OVERLAY
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
    left_x + portrait_w,
    portrait_open_bottom,
    false
);


draw_rectangle(
    right_x,
    portrait_open_top,
    right_x + portrait_w,
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
    left_x + portrait_w,
    portrait_open_bottom,
    false
);


draw_rectangle(
    right_x,
    portrait_open_top,
    right_x + portrait_w,
    portrait_open_bottom,
    false
);


// ====================================================
// PORTRAIT SCANLINES
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
        left_x + portrait_w,
        sy
    );


    draw_line(
        right_x,
        sy,
        right_x + portrait_w,
        sy
    );
}


// ====================================================
// MOVING SCAN BAND
// ====================================================

var scan_cycle_ms = 2800;


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


var moving_scan_h = 10;


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
                moving_scan_h *
                0.5
        ),
        left_x + portrait_w,
        min(
            portrait_open_bottom,
            moving_scan_y +
                moving_scan_h *
                0.5
        ),
        false
    );


    draw_rectangle(
        right_x,
        max(
            portrait_open_top,
            moving_scan_y -
                moving_scan_h *
                0.5
        ),
        right_x + portrait_w,
        min(
            portrait_open_bottom,
            moving_scan_y +
                moving_scan_h *
                0.5
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
        left_x + portrait_w,
        moving_scan_y
    );


    draw_line(
        right_x,
        moving_scan_y,
        right_x + portrait_w,
        moving_scan_y
    );
}


// ====================================================
// PORTRAIT BORDERS
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
    left_x + portrait_w,
    portrait_open_bottom,
    true
);


draw_rectangle(
    right_x,
    portrait_open_top,
    right_x + portrait_w,
    portrait_open_bottom,
    true
);


// ====================================================
// PORTRAIT NAMES
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
    freq_top - 28;


draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    ptt_x -
        ptt_w *
        0.5,

    ptt_y,

    ptt_x +
        ptt_w *
        0.5,

    ptt_y +
        ptt_h,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    ptt_x -
        ptt_w *
        0.5,

    ptt_y,

    ptt_x +
        ptt_w *
        0.5,

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
        ptt_h *
        0.5,
    "PTT"
);


// ====================================================
// CENTRE
// ====================================================

var centre_mid_x =
    (
        freq_left +
        freq_right
    ) *
    0.5;


// ====================================================
// ARROWS
// ====================================================

var arrow_box_w = 18;
var arrow_box_h = 24;

var arrow_y =
    freq_top + 62;


var arrow_left_x =
    freq_left + 11;


var arrow_right_x =
    freq_right - 11;


draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    arrow_left_x -
        arrow_box_w *
        0.5,

    arrow_y -
        arrow_box_h *
        0.5,

    arrow_left_x +
        arrow_box_w *
        0.5,

    arrow_y +
        arrow_box_h *
        0.5,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    arrow_left_x -
        arrow_box_w *
        0.5,

    arrow_y -
        arrow_box_h *
        0.5,

    arrow_left_x +
        arrow_box_w *
        0.5,

    arrow_y +
        arrow_box_h *
        0.5,

    true
);


draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    arrow_right_x -
        arrow_box_w *
        0.5,

    arrow_y -
        arrow_box_h *
        0.5,

    arrow_right_x +
        arrow_box_w *
        0.5,

    arrow_y +
        arrow_box_h *
        0.5,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    arrow_right_x -
        arrow_box_w *
        0.5,

    arrow_y -
        arrow_box_h *
        0.5,

    arrow_right_x +
        arrow_box_w *
        0.5,

    arrow_y +
        arrow_box_h *
        0.5,

    true
);


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
// LED GROUP
// ====================================================

draw_set_font(
    DIGITAL7MONO
);


var frequency_display_w =
    max(
        string_width(
            "888.88"
        ),
        string_width(
            codec_frequency
        )
    );


var meter_min_width = 18;

var meter_max_width = 48;

var meter_frequency_gap = 18;


var led_group_w =
    meter_max_width +
    meter_frequency_gap +
    frequency_display_w;


var led_group_left =
    centre_mid_x -
    led_group_w *
    0.5;


// ====================================================
// VOICE METER
// ====================================================

var meter_x =
    led_group_left;


var meter_bottom =
    freq_top + 91;


var bar_count = 7;


for (
    var i = 0;
    i < bar_count;
    i++
)
{
    var meter_t =
        i /
        max(
            1,
            bar_count - 1
        );


    var meter_curve =
        power(
            meter_t,
            0.70
        );


    var bar_width =
        lerp(
            meter_min_width,
            meter_max_width,
            meter_curve
        );


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
        meter_x + bar_width,
        bar_y + 4,
        false
    );
}


// ====================================================
// FREQUENCY
// ====================================================

var frequency_x =
    led_group_left +
    meter_max_width +
    meter_frequency_gap +
    frequency_display_w *
    0.5;


var frequency_y =
    freq_top + 62;


draw_set_halign(
    fa_center
);

draw_set_valign(
    fa_middle
);

draw_set_font(
    DIGITAL7MONO
);


draw_set_alpha(
    0.52 *
    ui_alpha
);

draw_set_color(
    make_color_rgb(
        24,
        55,
        49
    )
);


draw_text(
    frequency_x,
    frequency_y,
    "888.88"
);


draw_set_alpha(
    ui_alpha
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
    freq_bottom - 22;


draw_set_color(
    codec_colour_dark
);


draw_rectangle(
    memory_x -
        memory_w *
        0.5,

    memory_y,

    memory_x +
        memory_w *
        0.5,

    memory_y +
        memory_h,

    false
);


draw_set_color(
    codec_colour_dim
);


draw_rectangle(
    memory_x -
        memory_w *
        0.5,

    memory_y,

    memory_x +
        memory_w *
        0.5,

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
        memory_h *
        0.5,
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
    text_x + text_w,
    text_y + text_h,
    true
);


// ====================================================
// DIALOGUE WIDTH
// ====================================================

var dialogue_max_w =
    min(
        500,
        text_w - 80
    );


draw_set_font(
    PIXELOPERATORBOLD14
);


var dialogue_measured_w =
    string_width_ext(
        current_text,
        12,
        dialogue_max_w
    );


var dialogue_draw_w =
    clamp(
        dialogue_measured_w,
        80,
        dialogue_max_w
    );


var dialogue_draw_x =
    text_x +
    (
        text_w -
        dialogue_draw_w
    ) *
    0.5;


// ====================================================
// DIALOGUE
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
    make_color_rgb(
        175,
        225,
        205
    )
);


draw_text_ext(
    dialogue_draw_x,
    text_y + 28,
    display_text,
    12,
    dialogue_draw_w
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
                current_time
                div
                350
            )
            mod
            2
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
                42,

            text_y +
                text_h -
                14,

            "[SPACE]"
        );
    }
}


// ====================================================
// WHOLE-CODEC SCANLINES
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
        panel_x + panel_w,
        gui_scan_y
    );
}


// ====================================================
// FINAL SCISSOR SAFETY
// ====================================================

gpu_set_scissor(
    original_scissor
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);

draw_set_color(c_white);

draw_set_font(-1);

draw_set_halign(fa_left);

draw_set_valign(fa_top);