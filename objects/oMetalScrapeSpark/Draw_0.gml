/// oMetalScrapeSpark — Draw

// ====================================================
// SAVE DRAW SETTINGS
// ====================================================

var _old_colour = draw_get_colour();
var _old_alpha = draw_get_alpha();

// ====================================================
// LIFETIME RATIO
// ====================================================

var _t = clamp(
    spark_life / spark_life_max,
    0,
    1
);

// ====================================================
// COLOUR
// ====================================================

// Gradually transition towards dark orange.

var _colour = merge_colour(
    make_colour_rgb(255, 110, 20),
    spark_colour,
    _t
);

draw_set_colour(_colour);

// Remain bright initially, then quickly fade.
draw_set_alpha(min(1, _t * 2.5));

// ====================================================
// PIXEL STREAK
// ====================================================

var _xx = round(x);
var _yy = round(y);

var _length = max(
    1,
    round(spark_size * _t)
);

// Streak extends behind the travelling spark.
var _dir = sign(spark_vx);

if (_dir == 0)
{
    _dir = 1;
}

var _tail_x =
    _xx - ((_length - 1) * _dir);

// Draw a thin, one-pixel-high streak.
draw_rectangle(
    min(_xx, _tail_x),
    _yy,
    max(_xx, _tail_x),
    _yy,
    false
);

// ====================================================
// RESTORE DRAW SETTINGS
// ====================================================

draw_set_colour(_old_colour);
draw_set_alpha(_old_alpha);