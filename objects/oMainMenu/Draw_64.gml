/// oMainMenu — Draw GUI

scr_settings_init();

var gw = 640;
var gh = 360;
var cx = round(gw * 0.5);


// ====================================================
// CRT CLOCK
// ====================================================

if (!variable_instance_exists(id, "crt_time"))
{
    crt_time = 0;
}

crt_time++;


// ====================================================
// BACKGROUND DARKENING
// ====================================================

draw_set_alpha(0.55);
draw_set_color(c_black);

draw_rectangle(
    0,
    0,
    gw,
    gh,
    false
);

draw_set_alpha(1);


// ====================================================
// LOGO
// ====================================================

if (logo_sprite != -1)
{
    draw_sprite_ext(
        logo_sprite,
        0,
        cx,
        86,
        logo_scale,
        logo_scale,
        0,
        c_white,
        1
    );
}


// ====================================================
// MAIN MENU
// ====================================================

if (menu_mode == "main")
{
    draw_set_font(
        PIXELOPERATORBOLD18
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );


    var yy = 185;
    var line_gap = 36;


    for (
        var i = 0;
        i < array_length(menu_items);
        i++
    )
    {
        var txt =
            string(
                menu_items[i]
            );


        var is_sel =
            i == selected_index;


        draw_set_color(
            is_sel
            ? make_color_rgb(
                255,
                220,
                80
            )
            : make_color_rgb(
                200,
                200,
                200
            )
        );


        draw_text(
            cx,
            round(yy),
            txt
        );


        if (is_sel)
        {
            var tw =
                string_width(
                    txt
                );


            draw_set_halign(
                fa_left
            );


            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_text(
                round(
                    cx -
                    tw * 0.5 -
                    26
                ),
                round(yy),
                ">"
            );


            draw_set_halign(
                fa_center
            );
        }


        yy +=
            line_gap;
    }


    // =================================================
    // DYNAMIC CONFIRM PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        gh - 12;

    var prompt_right =
        gw - 12;

    var prompt_gap =
        6;

    var prompt_scale =
        0.75;

    var prompt_text =
        "SELECT";


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    var prompt_text_w =
        string_width(
            prompt_text
        );

    var prompt_icon_slot_w =
        34;

    var prompt_total_w =
        prompt_icon_slot_w +
        prompt_gap +
        prompt_text_w;

    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var icon_x =
                prompt_left +
                prompt_icon_slot_w * 0.5;


            ipc.draw_prompt(
                "confirm",
                round(icon_x),
                round(prompt_y),
                prompt_scale
            );
        }
    }


    draw_set_halign(
        fa_left
    );


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(
            prompt_left +
            prompt_icon_slot_w +
            prompt_gap
        ),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// SAVE SLOT SELECT
// ====================================================

else if (
    menu_mode == "new_slot_select" ||
    menu_mode == "continue_slot_select"
)
{
    var is_continue =
        menu_mode ==
        "continue_slot_select";


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
        make_color_rgb(
            230,
            235,
            235
        )
    );


    draw_text(
        cx,
        170,
        is_continue
        ? "LOAD SAVE SLOT"
        : "SELECT SAVE SLOT"
    );


    draw_set_font(
        PIXELOPERATORBOLD14
    );


    var yy = 210;
    var line_gap = 26;


    for (
        var i = 0;
        i < array_length(slot_items);
        i++
    )
    {
        var is_sel =
            is_continue
            ? i == continue_slot_index
            : i == slot_index;


        var txt = "";
        var disabled = false;


        if (i < 3)
        {
            var slot_num =
                i + 1;


            if (scr_save_exists(slot_num))
            {
                var chip_count =
                    scr_save_get_chip_count(
                        slot_num
                    );


                txt =
                    "SLOT " +
                    string(slot_num) +
                    "  -  CHIPS " +
                    string(chip_count) +
                    " / " +
                    string(global.chips_total);
            }
            else
            {
                txt =
                    "SLOT " +
                    string(slot_num) +
                    "  -  EMPTY";


                if (is_continue)
                {
                    disabled = true;
                }
            }
        }
        else
        {
            txt = "BACK";
        }


        var col;


        if (disabled)
        {
            col =
                make_color_rgb(
                    95,
                    100,
                    105
                );
        }
        else if (is_sel)
        {
            col =
                make_color_rgb(
                    255,
                    220,
                    80
                );
        }
        else
        {
            col =
                make_color_rgb(
                    200,
                    200,
                    200
                );
        }


        draw_set_color(
            col
        );


        draw_text(
            cx,
            yy,
            txt
        );


        // Keep the pointer visible on empty Continue slots.
        if (is_sel)
        {
            var tw =
                string_width(
                    txt
                );


            draw_set_halign(
                fa_left
            );


            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_text(
                round(
                    cx -
                    tw * 0.5 -
                    24
                ),
                yy,
                ">"
            );


            draw_set_halign(
                fa_center
            );
        }


        yy +=
            line_gap;
    }


    // =================================================
    // DYNAMIC BACK PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        gh - 12;

    var prompt_right =
        gw - 12;

    var prompt_gap =
        6;

    var prompt_scale =
        0.75;

    var prompt_text =
        "BACK";

    var prompt_text_w =
        string_width(
            prompt_text
        );

    var prompt_icon_slot_w =
        34;

    var prompt_total_w =
        prompt_icon_slot_w +
        prompt_gap +
        prompt_text_w;

    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var icon_x =
                prompt_left +
                prompt_icon_slot_w * 0.5;


            ipc.draw_prompt(
                "back",
                round(icon_x),
                round(prompt_y),
                prompt_scale
            );
        }
    }


    draw_set_halign(
        fa_left
    );


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(
            prompt_left +
            prompt_icon_slot_w +
            prompt_gap
        ),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// OVERWRITE CONFIRM
// ====================================================

else if (
    menu_mode ==
    "overwrite_confirm"
)
{
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
        make_color_rgb(
            255,
            220,
            80
        )
    );


    draw_text(
        cx,
        170,
        "OVERWRITE SLOT " +
        string(pending_new_slot) +
        "?"
    );


    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_color(
        make_color_rgb(
            200,
            200,
            200
        )
    );


    draw_text(
        cx,
        198,
        "Existing progress will be lost."
    );


    draw_set_font(
        PIXELOPERATORBOLD18
    );


    var yy = 240;
    var line_gap = 32;


    for (
        var i = 0;
        i < array_length(overwrite_items);
        i++
    )
    {
        var txt =
            overwrite_items[i];

        var is_sel =
            i == overwrite_index;


        draw_set_color(
            is_sel
            ? make_color_rgb(
                255,
                220,
                80
            )
            : make_color_rgb(
                200,
                200,
                200
            )
        );


        draw_text(
            cx,
            yy,
            txt
        );


        if (is_sel)
        {
            var tw =
                string_width(
                    txt
                );


            draw_set_halign(
                fa_left
            );


            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_text(
                round(
                    cx -
                    tw * 0.5 -
                    24
                ),
                yy,
                ">"
            );


            draw_set_halign(
                fa_center
            );
        }


        yy +=
            line_gap;
    }


    // =================================================
    // DYNAMIC BACK PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        gh - 12;

    var prompt_right =
        gw - 12;

    var prompt_gap =
        6;

    var prompt_scale =
        0.75;

    var prompt_text =
        "BACK";

    var prompt_text_w =
        string_width(
            prompt_text
        );

    var prompt_icon_slot_w =
        34;

    var prompt_total_w =
        prompt_icon_slot_w +
        prompt_gap +
        prompt_text_w;

    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var icon_x =
                prompt_left +
                prompt_icon_slot_w * 0.5;


            ipc.draw_prompt(
                "back",
                round(icon_x),
                round(prompt_y),
                prompt_scale
            );
        }
    }


    draw_set_halign(
        fa_left
    );


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(
            prompt_left +
            prompt_icon_slot_w +
            prompt_gap
        ),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// SETTINGS
// ====================================================

else if (
    menu_mode ==
    "settings"
)
{
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
        make_color_rgb(
            230,
            235,
            235
        )
    );


    draw_text(
        cx,
        170,
        "SYSTEM SETTINGS"
    );


    var spr_left =
        asset_get_index(
            "spritePauseUILeftNavigator"
        );

    var spr_right =
        asset_get_index(
            "spritePauseUIRightNavigator"
        );

    var spr_bar =
        asset_get_index(
            "spritePauseUIEmptyDialBox"
        );

    var spr_dial =
        asset_get_index(
            "spritePauseUIDial"
        );


    var widget_scale =
        0.62;

    var arrow_scale =
        widget_scale * 0.5;


    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_middle
    );


    var label_x = 180;
    var value_x = 390;

    var yy = 205;
    var gap = 17;


    for (
        var i = 0;
        i < array_length(settings_items);
        i++
    )
    {
        var item =
            settings_items[i];

        var is_sel =
            i == settings_index;

        var disabled =
            item == "resolution" &&
            !scr_settings_resolution_enabled();


        var col_text;


        if (disabled)
        {
            col_text =
                make_color_rgb(
                    95,
                    100,
                    105
                );
        }
        else if (is_sel)
        {
            col_text =
                make_color_rgb(
                    255,
                    220,
                    80
                );
        }
        else
        {
            col_text =
                make_color_rgb(
                    200,
                    200,
                    200
                );
        }


        draw_set_color(
            col_text
        );


        var label =
            scr_settings_label(
                item
            );


        // Pointer remains bright when Window Size is disabled.
        if (is_sel)
        {
            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_text(
                label_x - 16,
                yy,
                ">"
            );


            draw_set_color(
                col_text
            );
        }


        draw_text(
            label_x,
            yy,
            label
        );


        // ---------------------------------------------
        // SLIDERS
        // ---------------------------------------------

        if (
            item == "master_volume" ||
            item == "music_volume" ||
            item == "sfx_volume" ||
            item == "brightness" ||
            item == "contrast"
        )
        {
            var val =
                scr_settings_value01(
                    item
                );

            var bx =
                value_x;

            var by =
                yy;

            var bar_w =
                70;

            var bar_h =
                8;


            if (spr_bar != -1)
            {
                bar_w =
                    sprite_get_width(
                        spr_bar
                    )
                    *
                    widget_scale;

                bar_h =
                    sprite_get_height(
                        spr_bar
                    )
                    *
                    widget_scale;


                draw_sprite_ext(
                    spr_bar,
                    0,
                    bx,
                    by - bar_h * 0.5,
                    widget_scale,
                    widget_scale,
                    0,
                    c_white,
                    1
                );
            }


            var dial_x =
                bx +
                round(
                    bar_w *
                    val
                );


            if (spr_dial != -1)
            {
                draw_sprite_ext(
                    spr_dial,
                    0,
                    dial_x,
                    by,
                    widget_scale,
                    widget_scale,
                    0,
                    c_white,
                    1
                );
            }
        }


        // ---------------------------------------------
        // CYCLING SETTINGS
        // ---------------------------------------------

        if (
            item == "display_mode" ||
            item == "resolution"
        )
        {
            draw_set_halign(
                fa_center
            );

            draw_set_color(
                col_text
            );


            var out_txt = "";


            if (item == "display_mode")
            {
                out_txt =
                    global.display_mode_labels[
                        global.display_mode_index
                    ];
            }
            else
            {
                out_txt =
                    global.resolution_labels[
                        global.resolution_index
                    ];
            }


            var tx =
                value_x + 70;

            var lx =
                tx - 62;

            var rx =
                tx + 62;


            var arrow_col =
                disabled
                ? make_color_rgb(
                    80,
                    85,
                    90
                )
                : c_white;


            if (spr_left != -1)
            {
                draw_sprite_ext(
                    spr_left,
                    0,
                    lx,
                    yy,
                    arrow_scale,
                    arrow_scale,
                    0,
                    arrow_col,
                    1
                );
            }


            draw_text(
                tx,
                yy,
                out_txt
            );


            if (spr_right != -1)
            {
                draw_sprite_ext(
                    spr_right,
                    0,
                    rx,
                    yy,
                    arrow_scale,
                    arrow_scale,
                    0,
                    arrow_col,
                    1
                );
            }


            draw_set_halign(
                fa_left
            );
        }


        yy +=
            gap;
    }


    // =================================================
    // DYNAMIC CHANGE PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        gh - 12;

    var prompt_right =
        gw - 12;

    var prompt_scale =
        0.75;

    var icon_gap =
        4;

    var text_gap =
        6;

    var prompt_text =
        "CHANGE";

    var prompt_text_w =
        string_width(
            prompt_text
        );

    var icon_slot_w =
        20;

    var icons_w =
        icon_slot_w * 2 +
        icon_gap;

    var prompt_total_w =
        icons_w +
        text_gap +
        prompt_text_w;

    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var left_icon_x =
                prompt_left +
                icon_slot_w * 0.5;

            var right_icon_x =
                prompt_left +
                icon_slot_w +
                icon_gap +
                icon_slot_w * 0.5;


            if (ipc.using_keyboard())
            {
                var frame_a =
                    ipc.get_letter_frame(
                        "A"
                    );

                var frame_d =
                    ipc.get_letter_frame(
                        "D"
                    );


                if (frame_a >= 0)
                {
                    ipc.draw_keyboard_all(
                        frame_a,
                        round(left_icon_x),
                        round(prompt_y),
                        prompt_scale
                    );
                }


                if (frame_d >= 0)
                {
                    ipc.draw_keyboard_all(
                        frame_d,
                        round(right_icon_x),
                        round(prompt_y),
                        prompt_scale
                    );
                }
            }
            else
            {
                ipc.draw_controller_sprite(
                    ipc.spr_controller_left,
                    round(left_icon_x),
                    round(prompt_y),
                    prompt_scale
                );

                ipc.draw_controller_sprite(
                    ipc.spr_controller_right,
                    round(right_icon_x),
                    round(prompt_y),
                    prompt_scale
                );
            }
        }
    }


    var change_text_x =
        prompt_left +
        icons_w +
        text_gap;


    draw_set_halign(
        fa_left
    );

    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(change_text_x),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// VERSION NUMBER
// ====================================================

draw_set_font(
    PIXELOPERATORREGULAR10
);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_bottom
);

draw_set_color(
    make_color_rgb(
        140,
        150,
        160
    )
);


draw_text(
    12,
    gh - 10,
    "v1.0.0"
);


// ============================================================================
// CRT DISPLAY OVERLAY
// ============================================================================

if (
    variable_instance_exists(id, "crt_enabled") &&
    crt_enabled
)
{
    var sx1 =
        crt_inset;

    var sy1 =
        crt_inset;

    var sx2 =
        gw -
        crt_inset;

    var sy2 =
        gh -
        crt_inset;


    var flicker_wave =
        (
            sin(crt_time * 0.21) +
            sin(crt_time * 0.073)
        )
        *
        0.5;


    var flicker_amount =
        crt_flicker_alpha *
        (
            0.45 +
            0.55 *
            abs(flicker_wave)
        );


    draw_set_alpha(
        flicker_amount
    );

    draw_set_color(
        c_black
    );

    draw_rectangle(
        sx1,
        sy1,
        sx2,
        sy2,
        false
    );


    var scan_gap =
        max(
            2,
            round(
                crt_scan_gap
            )
        );

    var scan_offset =
        floor(
            crt_time *
            crt_scan_drift
        )
        mod
        scan_gap;


    draw_set_alpha(
        crt_scan_alpha
    );

    draw_set_color(
        c_black
    );


    for (
        var scan_y =
            sy1 +
            scan_offset;

        scan_y <
            sy2;

        scan_y +=
            scan_gap
    )
    {
        draw_line(
            sx1,
            scan_y,
            sx2,
            scan_y
        );
    }


    if (crt_roll_enabled)
    {
        var roll_range =
            sy2 -
            sy1 +
            crt_roll_height * 2;

        var roll_y =
            sy1 -
            crt_roll_height +
            (
                crt_time *
                crt_roll_speed
            )
            mod
            roll_range;


        draw_set_alpha(
            crt_roll_alpha
        );

        draw_set_color(
            c_white
        );


        draw_rectangle(
            sx1,
            roll_y,
            sx2,
            roll_y +
            crt_roll_height,
            false
        );


        draw_set_alpha(
            crt_roll_alpha *
            0.75
        );

        draw_set_color(
            c_black
        );


        draw_line(
            sx1,
            roll_y +
            crt_roll_height +
            1,
            sx2,
            roll_y +
            crt_roll_height +
            1
        );
    }


    if (
        crt_glitch_enabled &&
        crt_glitch_interval > 0
    )
    {
        var glitch_phase =
            crt_time
            mod
            crt_glitch_interval;


        if (
            glitch_phase <
            crt_glitch_frames
        )
        {
            var glitch_y =
                sy1 +
                28 +
                (
                    (
                        floor(
                            crt_time /
                            max(
                                1,
                                crt_glitch_interval
                            )
                        )
                        *
                        97
                    )
                    mod
                    max(
                        1,
                        sy2 -
                        sy1 -
                        56
                    )
                );


            var glitch_h =
                2 +
                floor(glitch_phase)
                mod
                3;


            draw_set_alpha(
                crt_glitch_alpha
            );

            draw_set_color(
                c_black
            );


            draw_rectangle(
                sx1,
                glitch_y,
                sx2,
                glitch_y +
                glitch_h,
                false
            );


            draw_set_alpha(
                crt_glitch_alpha *
                0.55
            );

            draw_set_color(
                make_color_rgb(
                    90,
                    220,
                    235
                )
            );


            draw_line(
                sx1,
                glitch_y - 1,
                sx2,
                glitch_y - 1
            );


            draw_set_alpha(
                crt_glitch_alpha *
                0.28
            );

            draw_set_color(
                c_white
            );


            draw_line(
                sx1,
                glitch_y +
                glitch_h +
                2,
                sx2,
                glitch_y +
                glitch_h +
                2
            );
        }
    }


    var edge =
        max(
            1,
            round(
                crt_edge_size
            )
        );


    draw_set_color(
        c_black
    );

    draw_set_alpha(
        crt_edge_alpha
    );


    draw_rectangle(
        sx1,
        sy1,
        sx2,
        sy1 + edge,
        false
    );

    draw_rectangle(
        sx1,
        sy2 - edge,
        sx2,
        sy2,
        false
    );

    draw_rectangle(
        sx1,
        sy1,
        sx1 + edge,
        sy2,
        false
    );

    draw_rectangle(
        sx2 - edge,
        sy1,
        sx2,
        sy2,
        false
    );


    draw_set_alpha(
        crt_edge_alpha *
        0.45
    );


    draw_rectangle(
        sx1 + edge,
        sy1 + edge,
        sx2 - edge,
        sy1 + edge + 2,
        false
    );

    draw_rectangle(
        sx1 + edge,
        sy2 - edge - 2,
        sx2 - edge,
        sy2 - edge,
        false
    );
}


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_font(-1);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);

draw_set_alpha(1);

draw_set_color(
    c_white
);