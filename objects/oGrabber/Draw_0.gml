/// oGrabber — Draw

var connector_sprite = spriteGrabberLoopableConnector;
var base_sprite = spriteGrabberBase;
var visual_claw_y = round(machine_visual_y);

if (connector_sprite != -1 && connector_segments > 0)
{
    var connector_height = sprite_get_height(connector_sprite);
    var claw_half_height = sprite_get_height(sprite_index) * 0.5;
    var claw_top = y + visual_claw_y - claw_half_height;
    var base_y = claw_top - connector_segments * connector_height;

    for (var connector_index = 0; connector_index < connector_segments; connector_index++)
    {
        draw_sprite(
            connector_sprite,
            0,
            x,
            base_y + connector_index * connector_height
        );
    }

    if (base_sprite != -1)
    {
        // Keep the rail-mounted base rigid. The connector overlap
        // hides the claw's subtle one-pixel vibration.
        draw_sprite(base_sprite, 0, x, base_y - visual_claw_y);
    }
}
else if (base_sprite != -1)
{
    draw_sprite(
        base_sprite,
        0,
        x,
        y - sprite_get_height(sprite_index) * 0.5
    );
}

draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y + visual_claw_y,
    image_xscale,
    image_yscale,
    image_angle,
    image_blend,
    image_alpha
);

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