/// oTeleporterText — Draw

if (
    owner_teleporter == noone
    ||
    !instance_exists(owner_teleporter)
)
{
    exit;
}


var tp =
    owner_teleporter;


var teleporter_font =
    asset_get_index(
        "PIXELOPERATORBOLD14"
    );


// ====================================================
// KEY REQUIRED
// ====================================================

if (
    tp.show_key_required
    &&
    tp.key_required_pop > 0
)
{
    var pop_t =
        clamp(
            tp.key_required_pop,
            0,
            1
        );


    var bob_y =
        round(
            sin(
                tp.key_required_bob_phase
            )
            *
            tp.key_required_bob_amount
        );


    var intro_x =
        round(
            lerp(
                tp.key_required_intro_x,
                0,
                pop_t
            )
        );


    var intro_y =
        round(
            lerp(
                tp.key_required_intro_y,
                0,
                pop_t
            )
        );


    var base_x =
        round(
            tp.x +
            tp.key_required_offset_x +
            intro_x
        );


    var base_y =
        round(
            tp.y +
            tp.key_required_offset_y +
            bob_y +
            intro_y
        );


    var upper_x =
        base_x +
        round(
            tp.key_required_step_x
        );


    var upper_y =
        base_y +
        round(
            tp.key_required_step_y
        );


    var text_alpha =
        pop_t;


    if (teleporter_font != -1)
    {
        draw_set_font(
            teleporter_font
        );
    }


    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_middle
    );


    // Shadow
    draw_set_alpha(
        0.65 *
        text_alpha
    );

    draw_set_color(
        c_black
    );


    draw_text(
        base_x + 1,
        base_y + 1,
        "- REQUIRED"
    );


    draw_text(
        upper_x + 1,
        upper_y + 1,
        "KEY"
    );


    // Red text
    draw_set_alpha(
        text_alpha
    );

    draw_set_color(
        make_color_rgb(
            255,
            75,
            75
        )
    );


    draw_text(
        base_x,
        base_y,
        "- REQUIRED"
    );


    draw_text(
        upper_x,
        upper_y,
        "KEY"
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
    tp.unlock_world_timer > 0
    &&
    tp.unlock_world_pop > 0
)
{
    var unlock_t =
        clamp(
            tp.unlock_world_pop,
            0,
            1
        );


    var unlock_bob_y =
        round(
            sin(
                tp.unlock_world_bob_phase
            )
            *
            tp.unlock_world_bob_amount
        );


    var unlock_intro_x =
        round(
            lerp(
                tp.unlock_world_intro_x,
                0,
                unlock_t
            )
        );


    var unlock_intro_y =
        round(
            lerp(
                tp.unlock_world_intro_y,
                0,
                unlock_t
            )
        );


    var unlock_base_x =
        round(
            tp.x +
            tp.unlock_world_offset_x +
            unlock_intro_x
        );


    var unlock_base_y =
        round(
            tp.y +
            tp.unlock_world_offset_y +
            unlock_bob_y +
            unlock_intro_y
        );


    var unlock_upper_x =
        unlock_base_x +
        round(
            tp.unlock_world_step_x
        );


    var unlock_upper_y =
        unlock_base_y +
        round(
            tp.unlock_world_step_y
        );


    if (teleporter_font != -1)
    {
        draw_set_font(
            teleporter_font
        );
    }


    draw_set_halign(
        fa_left
    );

    draw_set_valign(
        fa_middle
    );


    // Shadow
    draw_set_alpha(
        0.65 *
        unlock_t
    );

    draw_set_color(
        c_black
    );


    draw_text(
        unlock_base_x + 1,
        unlock_base_y + 1,
        "+ TELEPORTER"
    );


    draw_text(
        unlock_upper_x + 1,
        unlock_upper_y + 1,
        "UNLOCKED"
    );


    // Success text
    draw_set_alpha(
        unlock_t
    );

    draw_set_color(
        make_color_rgb(
            100,
            245,
            225
        )
    );


    draw_text(
        unlock_base_x,
        unlock_base_y,
        "+ TELEPORTER"
    );


    draw_text(
        unlock_upper_x,
        unlock_upper_y,
        "UNLOCKED"
    );


    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_font(-1);
}