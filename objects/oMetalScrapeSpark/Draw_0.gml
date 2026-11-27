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
// HEAVY DEMOLITION BALL SPARKS
// ====================================================

if (heavy_scrape)
{
    var _xx = round(x);
    var _yy = round(y);

    var _speed = max(
        0.001,
        point_distance(0, 0, spark_vx, spark_vy)
    );

    var _length = max(
        2,
        round(spark_size * _t)
    );


    // --------------------------------------------
    // Calculate diagonal trailing streak
    // --------------------------------------------

    var _tail_x = round(
        x - spark_vx / _speed * _length
    );

    var _tail_y = round(
        y - spark_vy / _speed * _length
    );


    // --------------------------------------------
    // Cool white-blue colour transition
    // --------------------------------------------

    var _colour = merge_colour(
        make_colour_rgb(130, 180, 235),
        spark_colour,
        _t
    );

    draw_set_colour(_colour);

    draw_set_alpha(
        min(1, _t * 3)
    );


    // --------------------------------------------
    // Bright diagonal streak
    // --------------------------------------------

    draw_line(
        _tail_x,
        _tail_y,
        _xx,
        _yy
    );


    // --------------------------------------------
    // Thicker white-hot core
    // --------------------------------------------

    if (_t > 0.4)
    {
        draw_set_colour(c_white);

        draw_rectangle(
            _xx,
            _yy,
            _xx + 1,
            _yy + 1,
            false
        );
    }


    // --------------------------------------------
    // Restore draw settings
    // --------------------------------------------

    draw_set_colour(_old_colour);
    draw_set_alpha(_old_alpha);

    exit;
}


// ====================================================
// ORIGINAL PLAYER SCRAPE SPARKS
// ====================================================

var _colour = merge_colour(
    make_colour_rgb(255, 110, 20),
    spark_colour,
    _t
);

draw_set_colour(_colour);

draw_set_alpha(min(1, _t * 2.5));


// ====================================================
// ORIGINAL PIXEL STREAK
// ====================================================

var _xx = round(x);
var _yy = round(y);

var _length = max(
    1,
    round(spark_size * _t)
);

var _dir = sign(spark_vx);

if (_dir == 0)
{
    _dir = 1;
}

var _tail_x =
    _xx - ((_length - 1) * _dir);

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