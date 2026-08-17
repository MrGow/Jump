/// oGrabber — Draw

var connector_sprite =
    spriteGrabberLoopableConnector;

var base_sprite =
    spriteGrabberBase;


// ====================================================
// DRAW CONNECTOR AND BASE
// ====================================================

if (
    connector_sprite != -1 &&
    connector_segments > 0
)
{
    var connector_height =
        sprite_get_height(
            connector_sprite
        );

    var claw_half_height =
        sprite_get_height(
            sprite_index
        ) * 0.5;

    var claw_top =
        y - claw_half_height;

    var base_y =
        claw_top -
        connector_segments *
        connector_height;


    // ------------------------------------------------
    // REPEATED CONNECTOR PIECES
    // ------------------------------------------------

    for (
        var connector_index = 0;
        connector_index < connector_segments;
        connector_index++
    )
    {
        draw_sprite(
            connector_sprite,
            0,
            x,
            base_y +
            connector_index *
            connector_height
        );
    }


    // ------------------------------------------------
    // MOVING RAIL BASE
    // ------------------------------------------------

    if (base_sprite != -1)
    {
        draw_sprite(
            base_sprite,
            0,
            x,
            base_y
        );
    }
}
else
{
    // Base-only fallback.
    if (base_sprite != -1)
    {
        draw_sprite(
            base_sprite,
            0,
            x,
            y -
            sprite_get_height(
                sprite_index
            ) * 0.5
        );
    }
}


// ====================================================
// DRAW CLAW
// ====================================================

draw_self();


// ====================================================
// DEBUG CAPTURE RECTANGLE
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.35);
    draw_set_color(c_lime);

    draw_rectangle(
        x - capture_half_width,
        y + capture_top_offset,
        x + capture_half_width,
        y + capture_bottom_offset,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}