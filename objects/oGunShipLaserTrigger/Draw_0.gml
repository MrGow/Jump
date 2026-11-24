
/// oGunShipLaserTrigger — Draw

if (!debug_draw)
{
    exit;
}


// ====================================================
// SAVE DRAW STATE
// ====================================================

var old_colour = draw_get_color();
var old_alpha = draw_get_alpha();


// ====================================================
// TARGET COORDINATES
// ====================================================

var tx = target_x;
var ty = target_y;

if (!use_absolute_position)
{
    tx = x + target_offset_x;
    ty = y + target_offset_y;
}


// ====================================================
// TRIGGER RECTANGLE
// ====================================================

var trigger_colour =
    make_color_rgb(60, 170, 255);

if (completed)
{
    trigger_colour =
        make_color_rgb(70, 220, 110);
}
else if (requested)
{
    trigger_colour =
        make_color_rgb(255, 175, 50);
}

draw_set_color(trigger_colour);
draw_set_alpha(0.15);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    false
);

draw_set_alpha(1);

draw_rectangle(
    bbox_left,
    bbox_top,
    bbox_right,
    bbox_bottom,
    true
);


// ====================================================
// DESTINATION MARKER
// ====================================================

draw_set_color(
    make_color_rgb(255, 210, 70)
);

draw_circle(
    tx,
    ty,
    7,
    true
);

draw_line(
    tx - 11,
    ty,
    tx + 11,
    ty
);

draw_line(
    tx,
    ty - 11,
    tx,
    ty + 11
);


// ====================================================
// CONNECTION TO TRIGGER
// ====================================================

draw_set_alpha(0.65);

draw_line(
    x,
    y,
    tx,
    ty
);

draw_set_alpha(1);


// ====================================================
// FIRING DIRECTION
// ====================================================

var dir = (fire_direction < 0) ? -1 : 1;

var arrow_start_x = tx + 18 * dir;
var arrow_end_x = tx + 75 * dir;

draw_set_color(
    make_color_rgb(255, 85, 65)
);

draw_line_width(
    arrow_start_x,
    ty,
    arrow_end_x,
    ty,
    2
);

draw_line(
    arrow_end_x,
    ty,
    arrow_end_x - 9 * dir,
    ty - 6
);

draw_line(
    arrow_end_x,
    ty,
    arrow_end_x - 9 * dir,
    ty + 6
);


// ====================================================
// STATUS TEXT
// ====================================================

draw_set_color(c_white);

var status = "READY";

if (requested)
{
    status = "REQUESTED";
}

if (accepted)
{
    status = "ACTIVE";
}

if (completed)
{
    status = "COMPLETE";
}

draw_text(
    bbox_left,
    bbox_top - 18,
    "LASER TRIGGER: " + status
);


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_color(old_colour);
draw_set_alpha(old_alpha);
