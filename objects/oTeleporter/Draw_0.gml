/// oTeleporter — Draw

draw_self();


// ====================================================
// KEY REQUIRED
// ====================================================

if (
    show_key_required
    &&
    key_required_pop > 0
)
{
    var bob_y =
        sin(
            key_required_bob_phase
        )
        *
        key_required_bob_amount;


    var text_x =
        x +
        key_required_offset_x;

    var text_y =
        y +
        key_required_offset_y +
        bob_y;


    var pop_t =
        clamp(
            key_required_pop,
            0,
            1
        );


    var pop_wave =
        sin(
            pop_t * pi
        )
        *
        0.08;


    var text_scale =
        lerp(
            0.75,
            1,
            pop_t
        )
        +
        pop_wave;


    var font_warning =
        asset_get_index(
            "PIXELOPERATORBOLD14"
        );


    if (font_warning != -1)
    {
        draw_set_font(
            font_warning
        );
    }


    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);


    // Shadow
    draw_set_alpha(0.65);
    draw_set_color(c_black);


    draw_text_transformed(
        round(text_x + 1),
        round(text_y + 1),
        "- KEY REQUIRED",
        text_scale,
        text_scale,
        key_required_angle
    );


    // Error red
    draw_set_alpha(1);

    draw_set_color(
        make_color_rgb(
            255,
            75,
            75
        )
    );


    draw_text_transformed(
        round(text_x),
        round(text_y),
        "- KEY REQUIRED",
        text_scale,
        text_scale,
        key_required_angle
    );


    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_font(-1);
}


// ====================================================
// TELEPORTER UNLOCKED
// ====================================================

if (
    unlock_world_timer > 0
    &&
    unlock_world_pop > 0
)
{
    var unlock_bob_y =
        sin(
            unlock_world_bob_phase
        )
        *
        unlock_world_bob_amount;


    var unlock_x =
        x +
        unlock_world_offset_x;

    var unlock_y =
        y +
        unlock_world_offset_y +
        unlock_bob_y;


    var unlock_t =
        clamp(
            unlock_world_pop,
            0,
            1
        );


    var unlock_wave =
        sin(
            unlock_t * pi
        )
        *
        0.08;


    var unlock_scale =
        lerp(
            0.75,
            1,
            unlock_t
        )
        +
        unlock_wave;


    var font_unlock =
        asset_get_index(
            "PIXELOPERATORBOLD14"
        );


    if (font_unlock != -1)
    {
        draw_set_font(
            font_unlock
        );
    }


    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);


    // Shadow
    draw_set_alpha(0.65);
    draw_set_color(c_black);


    draw_text_transformed(
        round(unlock_x + 1),
        round(unlock_y + 1),
        "+ TELEPORTER UNLOCKED",
        unlock_scale,
        unlock_scale,
        unlock_world_angle
    );


    // Pale cyan / mint
    draw_set_alpha(1);

    draw_set_color(
        make_color_rgb(
            100,
            245,
            225
        )
    );


    draw_text_transformed(
        round(unlock_x),
        round(unlock_y),
        "+ TELEPORTER UNLOCKED",
        unlock_scale,
        unlock_scale,
        unlock_world_angle
    );


    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_font(-1);
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // ------------------------------------------------
    // Key-required range
    // ------------------------------------------------

    draw_set_alpha(0.12);
    draw_set_color(c_red);


    draw_circle(
        x,
        y,
        key_required_distance,
        false
    );


    // ------------------------------------------------
    // Key-accept range
    // ------------------------------------------------

    draw_set_alpha(0.16);
    draw_set_color(c_lime);


    draw_circle(
        x,
        y,
        key_accept_distance,
        false
    );


    // ------------------------------------------------
    // REAL TELEPORT ACTIVATION POINT
    //
    // Completely independent of sprite bbox.
    // ------------------------------------------------

    var pad_surface_y =
        y +
        teleport_surface_offset_y;


    draw_set_alpha(0.35);
    draw_set_color(c_yellow);


    draw_rectangle(
        x - teleport_center_tolerance,
        pad_surface_y - teleport_feet_tolerance,
        x + teleport_center_tolerance,
        pad_surface_y + teleport_feet_tolerance,
        false
    );


    // Centre marker
    draw_set_alpha(1);
    draw_set_color(c_yellow);


    draw_line(
        x - 10,
        pad_surface_y,
        x + 10,
        pad_surface_y
    );


    draw_line(
        x,
        pad_surface_y - 5,
        x,
        pad_surface_y + 5
    );


    // ------------------------------------------------
    // Info
    // ------------------------------------------------

    draw_set_color(c_white);


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
        "\nsurface offset: "
        +
        string(
            teleport_surface_offset_y
        )
    );


    draw_set_alpha(1);
    draw_set_color(c_white);
}