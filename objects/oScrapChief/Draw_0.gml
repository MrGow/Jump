
/// oScrapChief — Draw

// ====================================================
// VISIBILITY
// ====================================================

if (!visible)
{
    exit;
}


// ====================================================
// DRAW POSITION
//
// Original physical payload position.
// ====================================================

var draw_x = round(x);
var draw_y = round(y);


// ====================================================
// HEAD ANIMATION ALIGNMENT
//
// Only affects the visible head and roar FX.
// The connector remains attached to the chain.
// ====================================================

var head_alignment_y =
    get_head_alignment_y();

var head_draw_x = draw_x;

var head_draw_y = round(
    draw_y + head_alignment_y
);


// ====================================================
// DRAW CONNECTOR
//
// Preserve the original physical attachment and
// configured connector overlap.
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
//
// Use the corrected animation position.
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
// DRAW ROAR FX
//
// Apply the same alignment correction as the head
// so the FX remains aligned with Chief's mouth.
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

        chain_attached ?
        "ATTACHED" :
        "DETACHED"
    );


    // Chief state.

    draw_text(
        x,
        y + chief_height + 28,

        "STATE: " + string(chief_state)
    );


    // Intro roar status.

    draw_text(
        x,
        y + chief_height + 40,

        intro_roar_complete ?
        "INTRO COMPLETE" :
        "INTRO INCOMPLETE"
    );


    // Current visual alignment correction.

    draw_text(
        x,
        y + chief_height + 52,

        "HEAD OFFSET: " +
        string(head_alignment_y)
    );
}
