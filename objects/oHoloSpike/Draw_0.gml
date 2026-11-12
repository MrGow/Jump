
/// oHoloSpikes — Draw

// ====================================================
// DIRECTION
// ====================================================

var _dir =
    ((round(spike_direction) mod 4) + 4) mod 4;

var _dx = 0;
var _dy = -1;
var _angle = 0;

var _side_x = 1;
var _side_y = 0;

switch (_dir)
{
    case 0:
        _dx = 0;
        _dy = -1;
        _angle = 0;
        _side_x = 1;
        _side_y = 0;
    break;

    case 1:
        _dx = 1;
        _dy = 0;
        _angle = 270;
        _side_x = 0;
        _side_y = 1;
    break;

    case 2:
        _dx = 0;
        _dy = 1;
        _angle = 180;
        _side_x = -1;
        _side_y = 0;
    break;

    case 3:
        _dx = -1;
        _dy = 0;
        _angle = 90;
        _side_x = 0;
        _side_y = -1;
    break;
}


// ====================================================
// ALIGNMENT SETTINGS
// ====================================================

// Sideways offset from the base centre.
// Positive = right when facing upward.

var _side =
    spike_side_offset;


// How far the shaft begins INSIDE the base.
// Positive means farther into the housing.

var _inside = 2;


// How far the pointed end projects beyond
// the final shaft section.

var _tip_forward = 7;


// ====================================================
// SHAFT CENTRELINE
// ====================================================

var _cx =
    x + _side_x * _side;

var _cy =
    y + _side_y * _side;


// Pixel-aligned movement.

var _length =
    round(max(0, extension));


// ====================================================
// 1. DRAW BASE FIRST
//
// Shaft and tip will be drawn IN FRONT of it.
// ====================================================

draw_sprite_ext(
    spriteHoloSpikeBase,
    0,
    x,
    y,
    1,
    1,
    _angle,
    c_white,
    image_alpha
);


// ====================================================
// 2. DRAW TILING MIDDLE
//
// Starts inside the base.
//
// Repeats every 2 pixels.
// The middle sprite is 10 x 2.
//
// The shaft ends at the extension distance.
// ====================================================

if (_length > 0)
{
    for (
        var _d = -_inside;
        _d <= _length;
        _d += 2
    )
    {
        draw_sprite_ext(
            spriteHoloSpikeTilingMiddle,
            0,

            round(_cx + _dx * _d) - 1,
			round(_cy + _dy * _d) - 1,

            1,
            1,

            _angle,

            c_white,
            image_alpha
        );
    }


    // =================================================
    // 3. DRAW POINTED END
    //
    // The pointed end sits FORWARD of the shaft.
    //
    // Drawn last so it is not buried underneath
    // the repeating middle sections.
    // =================================================

    var _tip_distance =
        _length + _tip_forward;


    draw_sprite_ext(
        spriteHoloSpikePointedEnd,
        0,

        round(_cx + _dx * _tip_distance),
		round(_cy + _dy * _tip_distance),

        1,
        1,

        _angle,

        c_white,
        image_alpha
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_alpha(0.5);

    draw_set_color(
        active ? c_red : c_aqua
    );

    draw_line(
        _cx,
        _cy,
        _cx + _dx * extension,
        _cy + _dy * extension
    );

    draw_set_alpha(1);

    draw_set_color(c_white);

    draw_text(
        x + 12,
        y + 12,

        "state: " + string(state) +

        "\nactive: " + string(active) +

        "\ndir: " + string(_dir) +

        "\nextension: " +
        string_format(extension, 1, 1) +

        "\nside offset: " +
        string(_side) +

        "\ntimer: " +
        string(state_timer)
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}
