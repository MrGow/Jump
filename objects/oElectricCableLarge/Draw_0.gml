/// oElectricCableLarge — Draw

draw_self();

// ----------------------------------------------------
// Debug hitbox
// ----------------------------------------------------
var col;

if (active)
    col = c_red;
else
    col = c_lime;

draw_set_alpha(0.35);
draw_set_color(col);

//draw_rectangle(
 //   bbox_left,
  //  bbox_top,
  //  bbox_right,
 //   bbox_bottom,
 //   false
//);

draw_set_alpha(1);
draw_set_color(c_white);

// Show current frame number
//draw_text(
//    x + 24,
//    y - 120,
//    string(floor(image_index))
//);