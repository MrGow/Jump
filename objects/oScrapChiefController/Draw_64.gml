/// oScrapChiefController — Draw GUI

// ====================================================
// SAVE DRAW STATE
// ====================================================

var previous_font = draw_get_font();
var previous_halign = draw_get_halign();
var previous_valign = draw_get_valign();
var previous_colour = draw_get_color();
var previous_alpha = draw_get_alpha();


// ====================================================
// BOSS HEALTH BAR
// ====================================================

if (boss_active && !sequence_complete)
{
    // ================================================
    // POSITION — BOTTOM CENTRE
    // ================================================

    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var bar_w = boss_bar_width;
    var bar_h = boss_bar_height;

    var bar_x = round(
        (gui_w - bar_w) * 0.5
    );

    var bar_y = round(
        gui_h -
        boss_bar_margin -
        bar_h
    );


    // ================================================
    // COLOURS
    //
    // Same palette as Pursuer IX.
    // ================================================

    var frame_col =
        make_color_rgb(12, 18, 28);

    var empty_col =
        make_color_rgb(43, 49, 62);

    var fill_col =
        make_color_rgb(238, 69, 49);

    var edge_col =
        make_color_rgb(255, 161, 72);

    var name_col =
        make_color_rgb(225, 235, 240);

    var shadow_col =
        make_color_rgb(5, 8, 12);

    draw_set_alpha(1);


    // ================================================
    // BOSS NAME
    // ================================================

    if (boss_bar_show_name)
    {
        draw_set_font(PIXELOPERATORBOLD14);

        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);

        var name_x = round(
            bar_x + bar_w * 0.5
        );

        var name_y = bar_y - 5;


        // --------------------------------------------
        // Name shadow
        // --------------------------------------------

        draw_set_color(shadow_col);

        draw_text(
            name_x + 2,
            name_y + 2,
            "SCRAP CHIEF"
        );


        // --------------------------------------------
        // Black outline
        // --------------------------------------------

        draw_set_color(c_black);

        for (var ox = -1; ox <= 1; ox++)
        {
            for (var oy = -1; oy <= 1; oy++)
            {
                if (ox == 0 && oy == 0)
                {
                    continue;
                }

                draw_text(
                    name_x + ox,
                    name_y + oy,
                    "SCRAP CHIEF"
                );
            }
        }


        // --------------------------------------------
        // Main lettering
        // --------------------------------------------

        draw_set_color(name_col);

        draw_text(
            name_x,
            name_y,
            "SCRAP CHIEF"
        );
    }


    // ================================================
    // BAR SHADOW
    // ================================================

    draw_set_color(shadow_col);

    draw_rectangle(
        bar_x - 3 + 2,
        bar_y - 3 + 2,
        bar_x + bar_w + 3 + 2,
        bar_y + bar_h + 3 + 2,
        false
    );


    // ================================================
    // BAR FRAME
    // ================================================

    draw_set_color(c_black);

    draw_rectangle(
        bar_x - 4,
        bar_y - 4,
        bar_x + bar_w + 4,
        bar_y + bar_h + 4,
        false
    );

    draw_set_color(frame_col);

    draw_rectangle(
        bar_x - 3,
        bar_y - 3,
        bar_x + bar_w + 3,
        bar_y + bar_h + 3,
        false
    );


    // ================================================
    // EMPTY BAR
    // ================================================

    draw_set_color(empty_col);

    draw_rectangle(
        bar_x,
        bar_y,
        bar_x + bar_w,
        bar_y + bar_h,
        false
    );


    // ================================================
    // HP FILL
    //
    // Health depletes from right to left.
    // ================================================

    var hp_fraction = clamp(
        hp / max(1, max_hp),
        0,
        1
    );

    if (hp_fraction > 0)
    {
        var fill_width = round(
            bar_w * hp_fraction
        );

        draw_set_color(fill_col);

        draw_rectangle(
            bar_x,
            bar_y,
            bar_x + fill_width,
            bar_y + bar_h,
            false
        );
    }


    // ================================================
    // HP SEGMENTS
    // ================================================

    draw_set_color(frame_col);

    for (var i = 1; i < max_hp; i++)
    {
        var divider_x = round(
            bar_x +
            bar_w * i / max_hp
        );

        draw_rectangle(
            divider_x - 1,
            bar_y,
            divider_x + 1,
            bar_y + bar_h,
            false
        );
    }


    // ================================================
    // ORANGE EDGE
    // ================================================

    draw_set_color(edge_col);

    draw_rectangle(
        bar_x - 1,
        bar_y - 1,
        bar_x + bar_w + 1,
        bar_y + bar_h + 1,
        true
    );
}


// ====================================================
// EXISTING ELEVATOR DEBUG
// ====================================================

if (debug_elevator)
{
    draw_set_font(previous_font);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(c_white);
    draw_set_alpha(1);

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

    draw_text(
        16, 114,
        "HP: " +
        string(hp) +
        " / " +
        string(max_hp)
    );
}


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_font(previous_font);
draw_set_halign(previous_halign);
draw_set_valign(previous_valign);
draw_set_color(previous_colour);
draw_set_alpha(previous_alpha);