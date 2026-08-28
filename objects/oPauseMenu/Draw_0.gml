/// oPauseMenu — Draw

scr_settings_init();

var cam = view_camera[0];

var vx = 0;
var vy = 0;
var vw = display_get_gui_width();
var vh = display_get_gui_height();

if (
    is_real(cam) &&
    cam >= 0
)
{
    vx = camera_get_view_x(cam);
    vy = camera_get_view_y(cam);
    vw = camera_get_view_width(cam);
    vh = camera_get_view_height(cam);
}

var cx = vx + vw * 0.5;
var cy = vy + vh * 0.5;


// ====================================================
// SCREEN DARKENING
// ====================================================

draw_set_alpha(0.75);
draw_set_color(c_black);

draw_rectangle(
    vx,
    vy,
    vx + vw,
    vy + vh,
    false
);


// ====================================================
// PAUSE PANEL
// ====================================================

var pause_ui_sprite =
    asset_get_index("spritePauseUI");

var px;
var py;
var panel_w;
var panel_h;

if (pause_ui_sprite != -1)
{
    panel_w =
        sprite_get_width(pause_ui_sprite);

    panel_h =
        sprite_get_height(pause_ui_sprite);

    px =
        floor(cx - panel_w * 0.5);

    py =
        floor(cy - panel_h * 0.5);

    draw_set_alpha(1);

    draw_sprite(
        pause_ui_sprite,
        0,
        px,
        py
    );
}
else
{
    panel_w = 260;
    panel_h = 150;

    px =
        floor(cx - panel_w * 0.5);

    py =
        floor(cy - panel_h * 0.5);

    draw_set_alpha(1);

    draw_set_color(
        make_color_rgb(
            40,
            40,
            55
        )
    );

    draw_rectangle(
        px,
        py,
        px + panel_w,
        py + panel_h,
        false
    );

    draw_set_color(c_white);

    draw_rectangle(
        px,
        py,
        px + panel_w,
        py + panel_h,
        true
    );
}


// ====================================================
// PANEL HEADING
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

draw_set_color(
    make_color_rgb(
        230,
        235,
        235
    )
);

var panel_heading =
    "SYSTEM PAUSED";

if (menu_mode == "settings")
{
    panel_heading =
        "SYSTEM SETTINGS";
}
else if (menu_mode == "controls")
{
    panel_heading =
        "SYSTEM CONTROLS";
}

draw_text(
    cx,
    py + 16,
    panel_heading
);


// ====================================================
// MAIN PAUSE MENU
// ====================================================

if (menu_mode == "main")
{
    // ------------------------------------------------
    // Terminal prompt
    // ------------------------------------------------

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_top
    );

    draw_set_color(
        make_color_rgb(
            165,
            200,
            165
        )
    );

    draw_text(
        px + 52,
        py + 48,
        "jumpbot@factory:~$ menu"
    );

    draw_set_color(
        make_color_rgb(
            90,
            140,
            90
        )
    );

    draw_line(
        px + 52,
        py + 63,
        px + panel_w - 58,
        py + 63
    );


    // ------------------------------------------------
    // Menu options
    // ------------------------------------------------

    draw_set_font(
        PIXELOPERATORBOLD18
    );

    var yy =
        py + 68;

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

        if (i == selected_index)
        {
            draw_set_color(
                make_color_rgb(
                    255,
                    220,
                    80
                )
            );

            draw_text(
                px + 34,
                yy,
                "> " + txt
            );
        }
        else
        {
            draw_set_color(
                make_color_rgb(
                    200,
                    200,
                    200
                )
            );

            draw_text(
                px + 54,
                yy,
                txt
            );
        }

        yy += 20;
    }
}


// ====================================================
// SETTINGS MENU
// ====================================================

else if (menu_mode == "settings")
{
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

    var label_x =
        px + 46;

    var value_x =
        px + 176;

    var yy =
        py + 48;

    var gap =
        17;

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
            (
                item == "resolution" &&
                !scr_settings_resolution_enabled()
            );

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


        // --------------------------------------------
        // Settings labels
        // --------------------------------------------

        var label = "";

        switch (item)
        {
            case "master_volume":
                label = "Master Volume";
                break;

            case "music_volume":
                label = "Music Volume";
                break;

            case "sfx_volume":
                label = "SFX Volume";
                break;

            case "brightness":
                label = "Brightness";
                break;

            case "contrast":
                label = "Contrast";
                break;

            case "display_mode":
                label = "Display Mode";
                break;

            case "resolution":
                label = "Resolution";
                break;

            case "back":
                label = "Back";
                break;

            default:
                label =
                    scr_settings_label(item);
                break;
        }

        if (is_sel)
        {
            draw_text(
                label_x - 16,
                yy,
                ">"
            );
        }

        draw_text(
            label_x,
            yy,
            label
        );


        // --------------------------------------------
        // SLIDER SETTINGS
        // --------------------------------------------

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
                    bar_w * val
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


        // --------------------------------------------
        // CYCLING SETTINGS
        // --------------------------------------------

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
                value_x + 40;

            var lx =
                tx - 34;

            var rx =
                tx + 34;

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

        yy += gap;
    }
}


// ====================================================
// CONTROLS MENU
// ====================================================

else if (menu_mode == "controls")
{
    scr_controls_ensure_defaults();


    // ------------------------------------------------
    // FONT
    //
    // REGULAR10 fits the available panel width while
    // remaining comfortably readable.
    // ------------------------------------------------

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );


    // =================================================
    // COLUMN LAYOUT
    //
    // Controller column has been pulled left so longer
    // names such as "D-Pad Right" stay comfortably
    // inside the panel.
    // =================================================

    var label_x =
        px + 54;

    var keyboard_x =
        px + 166;

    var controller_x =
        px + 228;


    var heading_y =
        py + 49;

    var row_y =
        py + 70;

    var row_gap =
        20;


    // ------------------------------------------------
    // COLUMN HEADINGS
    // ------------------------------------------------

    draw_set_color(
        make_color_rgb(
            165,
            200,
            165
        )
    );

    draw_text(
        keyboard_x,
        heading_y,
        "Keyboard"
    );

    draw_text(
        controller_x,
        heading_y,
        "Controller"
    );

    // ------------------------------------------------
    // DIVIDER
    // ------------------------------------------------

    draw_set_color(
        make_color_rgb(
            90,
            140,
            90
        )
    );

    draw_line(
        px + 46,
        py + 60,
        px + panel_w - 46,
        py + 60
    );


    // =================================================
    // ACTION ROWS
    // =================================================

    var action_labels = [
        "Jump",
        "Left",
        "Right"
    ];

    var keyboard_values = [
        scr_controls_keyboard_name(
            global.control_key_jump
        ),

        scr_controls_keyboard_name(
            global.control_key_left
        ),

        scr_controls_keyboard_name(
            global.control_key_right
        )
    ];

    var controller_values = [
        scr_controls_gamepad_name(
            global.control_pad_jump
        ),

        scr_controls_gamepad_name(
            global.control_pad_left
        ),

        scr_controls_gamepad_name(
            global.control_pad_right
        )
    ];


    for (
        var ci = 0;
        ci < 3;
        ci++
    )
    {
        var yy =
            row_y +
            ci * row_gap;


        // --------------------------------------------
        // ACTION NAME
        // --------------------------------------------

        draw_set_halign(
            fa_left
        );

        draw_set_color(
            make_color_rgb(
                200,
                200,
                200
            )
        );

        draw_text(
            label_x,
            yy,
            action_labels[ci]
        );


        // --------------------------------------------
        // SELECTION STATE
        // --------------------------------------------

        var keyboard_selected =
            controls_row == ci &&
            controls_column == 0;

        var controller_selected =
            controls_row == ci &&
            controls_column == 1;


        var keyboard_text =
            keyboard_values[ci];

        var controller_text =
            controller_values[ci];


        if (
            controls_rebinding &&
            controls_row == ci
        )
        {
            if (
                controls_rebind_device ==
                "keyboard"
            )
            {
                keyboard_text =
                    "Press Key";
            }
            else
            {
                controller_text =
                    "Press Button";
            }
        }


        // --------------------------------------------
        // KEYBOARD VALUE
        // --------------------------------------------

        draw_set_halign(
            fa_center
        );

        draw_set_color(
            keyboard_selected
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
            keyboard_x,
            yy,
            keyboard_text
        );


        // --------------------------------------------
        // CONTROLLER VALUE
        // --------------------------------------------

        draw_set_color(
            controller_selected
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
            controller_x,
            yy,
            controller_text
        );


        // --------------------------------------------
        // SELECTION ARROW
        // --------------------------------------------

        if (
            controls_row == ci &&
            !controls_rebinding
        )
        {
            draw_set_color(
                make_color_rgb(
                    255,
                    220,
                    80
                )
            );

            draw_text(
                controls_column == 0
                    ? keyboard_x - 31
                    : controller_x - 42,
                yy,
                ">"
            );
        }
    }


    // =================================================
    // RESTORE DEFAULTS / BACK
    // =================================================

    draw_set_halign(
        fa_left
    );

    var restore_y =
        py + 135;

    var back_y =
        py + 153;


    draw_set_color(
        controls_row == 3
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
        px + 54,
        restore_y,
        (
            controls_row == 3
            ? "> "
            : ""
        )
        +
        "Restore Defaults"
    );


    draw_set_color(
        controls_row == 4
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
        px + 54,
        back_y,
        (
            controls_row == 4
            ? "> "
            : ""
        )
        +
        "Back"
    );


    // =================================================
    // PERMANENT CONTROL / STATUS MESSAGE
    //
    // Only ONE bottom line now.
    // =================================================

    draw_set_halign(
        fa_center
    );

    draw_set_color(
        make_color_rgb(
            130,
            165,
            150
        )
    );

    var info_text =
        "Arrow Keys / Left Stick Always Active";


    if (controls_rebinding)
    {
        info_text =
            controls_rebind_device ==
            "keyboard"
            ? "Press Esc to Cancel"
            : "Press B to Cancel";
    }
    else if (
        controls_message_timer > 0 &&
        controls_message != ""
    )
    {
        info_text =
            controls_message;
    }


    // Moved slightly upward and now sits comfortably
    // above the bottom hazard stripe.
    draw_text(
        cx,
        py + 174,
        info_text
    );
}


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_font(
    -1
);

draw_set_halign(
    fa_left
);

draw_set_valign(
    fa_top
);

draw_set_alpha(
    1
);

draw_set_color(
    c_white
);