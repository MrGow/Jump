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
// ====================================================

var draw_x = round(x);
var draw_y = round(y);


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

    draw_x,
    draw_y,

    1,
    1,

    0,

    c_white,
    1
);


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // Chief bounds.

    draw_set_color(c_yellow);

    draw_rectangle(
        x,
        y,
        x + chief_width - 1,
        y + chief_height - 1,
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
}