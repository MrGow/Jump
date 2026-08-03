/// oHoloPlatformController — Draw

// ====================================================
// CREATE OR RECREATE TILEMAP SURFACE
// ====================================================

if (!surface_exists(holo_surface))
{
    holo_surface =
        surface_create(
            room_width,
            room_height
        );

    holo_surface_needs_redraw = true;
}


// ====================================================
// DRAW TILEMAP INTO SURFACE
//
// The holographic tilemap is static, so this only needs
// to happen after the surface is created or lost.
// ====================================================

if (
    surface_exists(holo_surface) &&
    holo_surface_needs_redraw
)
{
    surface_set_target(
        holo_surface
    );

    draw_clear_alpha(
        c_black,
        0
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    if (holo_tilemap_id != -1)
    {
        draw_tilemap(
            holo_tilemap_id,
            0,
            0
        );
    }

    surface_reset_target();

    holo_surface_needs_redraw = false;
}


// ====================================================
// DRAW CACHED HOLOGRAMS WITH TRUE ALPHA
// ====================================================

if (
    surface_exists(holo_surface) &&
    current_alpha > 0
)
{
    draw_surface_ext(
        holo_surface,
        0,
        0,
        1,
        1,
        0,
        c_white,
        current_alpha
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_alpha(1);
    draw_set_color(c_aqua);

    draw_text(
        x,
        y,

        "HOLO LAYER: " +
        string(holo_layer_name) +

        "\nLAYER ID: " +
        string(holo_layer_id) +

        "\nTILEMAP ID: " +
        string(holo_tilemap_id) +

        "\nSTATE: " +
        string(state) +

        "\nALPHA: " +
        string_format(
            current_alpha,
            1,
            3
        ) +

        "\nSTUDY TIMER: " +
        string(study_timer) +

        "\nFADE TIMER: " +
        string(fade_timer) +

        " / " +
        string(fade_frames) +

        "\nSURFACE: " +
        string(
            surface_exists(
                holo_surface
            )
        )
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}