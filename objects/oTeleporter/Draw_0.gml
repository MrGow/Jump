// ============================================================================
// oTeleporter — Draw
// ============================================================================

draw_self();


// ====================================================
// FONT
//
// Actual status text is handled by oTeleporterText
// on the front layer.
// ====================================================

var teleporter_font =
    asset_get_index(
        "PIXELOPERATORBOLD14"
    );


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // ------------------------------------------------
    // Whole sprite trigger
    // ------------------------------------------------

    draw_set_alpha(
        0.18
    );

    draw_set_color(
        c_yellow
    );


    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        false
    );


    // ------------------------------------------------
    // Magnet destination
    // ------------------------------------------------

    var target_x =
        x;

    var target_y =
        y +
        teleport_magnet_y_offset;


    draw_set_alpha(
        1
    );

    draw_set_color(
        c_lime
    );


    draw_circle(
        target_x,
        target_y,
        4,
        false
    );


    draw_line(
        target_x - 8,
        target_y,
        target_x + 8,
        target_y
    );


    draw_line(
        target_x,
        target_y - 8,
        target_x,
        target_y + 8
    );


    // ------------------------------------------------
    // Key-required range
    // ------------------------------------------------

    draw_set_alpha(
        0.10
    );

    draw_set_color(
        c_red
    );


    draw_circle(
        x,
        y,
        key_required_distance,
        false
    );


    // ------------------------------------------------
    // Key accept range
    // ------------------------------------------------

    draw_set_alpha(
        0.12
    );

    draw_set_color(
        c_aqua
    );


    draw_circle(
        x,
        y,
        key_accept_distance,
        false
    );


    // ------------------------------------------------
    // Info
    // ------------------------------------------------

    draw_set_alpha(
        1
    );

    draw_set_color(
        c_white
    );


    draw_text(
        x + 12,
        y + 12,

        "state: "
        +
        teleporter_state
        +
        "\nID: "
        +
        link_id
        +
        "\nmagnet Y: "
        +
        string(
            teleport_magnet_y_offset
        )
        +
        "\nmagnet timer: "
        +
        string(
            magnet_timer
        )
        +
        "\npost hold: "
        +
        string(
            post_anim_hold_timer
        )
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}

