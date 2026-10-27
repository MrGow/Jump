
/// oFirstSpawnSparks — Draw

if (!effect_started)
    exit;

if (!instance_exists(player_ref))
    exit;


// ====================================================
// PLAYER POSITION
// ====================================================

var px = round(player_ref.x);

var py = round(
    player_ref.y +
    player_draw_y_offset -
    5
);


// ====================================================
// DRAW ELECTRICAL SPARKS
// ====================================================

for (var i = 0; i < array_length(sparks); i++)
{
    var s = sparks[i];

    var life_alpha =
        clamp(
            s.life / max(1, s.max_life),
            0,
            1
        );

    draw_set_alpha(life_alpha);
    draw_set_color(s.colour);

    var sx = round(px + s.x);
    var sy = round(py + s.y);

    // Zigzag made from three short pixel segments.
    var dx = lengthdir_x(s.length, s.angle);
    var dy = lengthdir_y(s.length, s.angle);

    var ex = round(sx + dx);
    var ey = round(sy + dy);

    var mx = round(sx + dx * 0.45);
    var my = round(sy + dy * 0.45);

    var bend_x = round(
        lengthdir_x(2, s.angle + 90)
    );

    var bend_y = round(
        lengthdir_y(2, s.angle + 90)
    );

    draw_line(
        sx,
        sy,
        mx + bend_x,
        my + bend_y
    );

    draw_line(
        mx + bend_x,
        my + bend_y,
        ex,
        ey
    );

    // Occasional bright electrical pixel.
    if (s.colour == spark_bright)
    {
        draw_rectangle(
            sx,
            sy,
            sx + 1,
            sy + 1,
            false
        );
    }
}


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);
