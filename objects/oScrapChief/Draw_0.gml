/// oScrapChief — Draw

// ====================================================
// VISIBILITY
// ====================================================

if (!visible)
{
    exit;
}


// ====================================================
// DRAW POSITION AND HEAD ALIGNMENT
// ====================================================

var draw_x = round(x);
var draw_y = round(y);

var head_alignment_y = get_head_alignment_y();

var head_draw_x = draw_x;
var head_draw_y = round(draw_y + head_alignment_y);


// ====================================================
// DRAW CONNECTOR
// ====================================================

draw_sprite_ext(
    connector_sprite,
    0,
    round(draw_x + connector_local_x),
    round(draw_y + connector_local_y),
    1,
    1,
    0,
    c_white,
    1
);


// ====================================================
// DRAW SCRAP CHIEF
// ====================================================

draw_sprite_ext(
    sprite_index,
    image_index,
    head_draw_x,
    head_draw_y,
    1,
    1,
    0,
    c_white,
    1
);


// ====================================================
// SUCCESSFUL HIT — WHITE FLASH
// ====================================================

if (eye_flash_timer > 0)
{
    var flash_alpha =
        0.70 *
        eye_flash_timer /
        max(
            1,
            round(eye_flash_seconds * room_speed)
        );

    gpu_set_blendmode(bm_add);

    draw_sprite_ext(
        sprite_index,
        image_index,
        head_draw_x,
        head_draw_y,
        1,
        1,
        0,
        c_white,
        flash_alpha
    );

    gpu_set_blendmode(bm_normal);
}


// ====================================================
// DRAW ROAR FX
// ====================================================

if (roar_fx_active)
{
    draw_sprite_ext(
        roar_fx_sprite,
        floor(roar_fx_frame),
        round(head_draw_x + roar_fx_offset_x),
        round(head_draw_y + roar_fx_offset_y),
        1,
        1,
        0,
        c_white,
        1
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // Chief visual bounds.

    draw_set_color(c_yellow);

    draw_rectangle(
        head_draw_x,
        head_draw_y,
        head_draw_x + chief_width - 1,
        head_draw_y + chief_height - 1,
        true
    );


    // Connector bounds.

    draw_set_color(c_aqua);

    draw_rectangle(
        x + connector_local_x,
        y + connector_local_y,
        x + connector_local_x + connector_width - 1,
        y + connector_local_y + connector_height - 1,
        true
    );


    // Chain attachment point.

    draw_set_color(c_lime);

    draw_circle(
        chain_attach_x,
        chain_attach_y,
        3,
        false
    );


    // Overheat ground contact marker.

    if (overheat_active)
    {
        draw_set_color(c_red);

        draw_line(
            x,
            y + overheat_ground_offset_y,
            x + chief_width,
            y + overheat_ground_offset_y
        );

        draw_circle(
            x + chief_width * 0.5,
            y + overheat_ground_offset_y,
            3,
            false
        );
    }


    // Information.

    draw_set_color(c_white);

    draw_text(
        x,
        y + chief_height + 4,
        "CHIEF " + string(chief_id)
    );

    draw_text(
        x,
        y + chief_height + 16,
        chain_attached ? "ATTACHED" : "DETACHED"
    );

    draw_text(
        x,
        y + chief_height + 28,
        "STATE: " + string(chief_state)
    );

    draw_text(
        x,
        y + chief_height + 40,
        intro_roar_complete ?
        "INTRO COMPLETE" : "INTRO INCOMPLETE"
    );

    draw_text(
        x,
        y + chief_height + 52,
        "HEAD OFFSET: " + string(head_alignment_y)
    );

    draw_text(
        x,
        y + chief_height + 64,
        "GROUNDED: " + string(grounded)
    );

    draw_text(
        x,
        y + chief_height + 76,
        "VULNERABLE: " + string(overheat_vulnerable)
    );

    draw_text(
        x,
        y + chief_height + 88,
        "OVERHEAT TIME: " +
        string(
            round(overheat_timer / room_speed * 10) / 10
        )
    );

    draw_text(
        x,
        y + chief_height + 100,
        "HIT SUCCESS: " + string(overheat_hit_success)
    );
}


// ====================================================
// EYE HITBOX DEBUG
//
// Only visible when the hitbox is actually active.
// ====================================================

if (
    eye_debug_draw &&
    chief_state == 10 &&
    overheat_vulnerable &&
    grounded
)
{
    var eye_x = get_eye_x();
    var eye_y = get_eye_y();

    draw_set_color(c_lime);

    draw_rectangle(
        eye_x - eye_half_w,
        eye_y - eye_half_h,
        eye_x + eye_half_w,
        eye_y + eye_half_h,
        true
    );

    draw_circle(
        eye_x,
        eye_y,
        2,
        false
    );
}

draw_set_color(c_white);
draw_set_alpha(1);