/// oScrapChiefChain — Draw

// ====================================================
// SAFETY
// ====================================================

if (!initialized)
{
    exit;
}

if (!instance_exists(carriage))
{
    exit;
}

if (!carriage.visible)
{
    exit;
}


// ====================================================
// DRAW CONFIGURATION
// ====================================================

var tile_width = chain_sprite_width;
var tile_height = max(1, chain_sprite_height);

var half_width = tile_width * 0.5;


// ====================================================
// CALCULATE TOTAL SIMULATED CHAIN LENGTH
// ====================================================

var path_length = 0;

var path_distances = [];

path_distances[0] = 0;

for (var i = 0; i < segment_count; i++)
{
    path_length += point_distance(
        point_x[i],
        point_y[i],

        point_x[i + 1],
        point_y[i + 1]
    );

    path_distances[i + 1] = path_length;
}

if (path_length <= 0.001)
{
    exit;
}


// ====================================================
// CALCULATE VISUAL TILE COUNT
//
// Independent of the physics segment count.
// Preserve the original sprite proportions as closely
// as possible.
// ====================================================

var tile_count = max(
    1,
    round(path_length / tile_height)
);

var tile_length =
    path_length / tile_count;


// ====================================================
// SAMPLE POSITION ALONG SIMULATED CHAIN
// ====================================================

var sample_path = function(_distance, _distances)
{
    _distance = clamp(
        _distance,
        0,
        _distances[segment_count]
    );

    for (var s = 0; s < segment_count; s++)
    {
        if (_distance <= _distances[s + 1])
        {
            var segment_length =
                _distances[s + 1] -
                _distances[s];

            var t = 0;

            if (segment_length > 0.001)
            {
                t =
                    (_distance - _distances[s]) /
                    segment_length;
            }

            return [
                lerp(point_x[s], point_x[s + 1], t),
                lerp(point_y[s], point_y[s + 1], t)
            ];
        }
    }

    return [
        point_x[segment_count],
        point_y[segment_count]
    ];
};


// ====================================================
// DRAW CHAIN TILES
// ====================================================

for (var i = 0; i < tile_count; i++)
{
    var distance_start =
        i * tile_length;

    var distance_end =
        (i + 1) * tile_length;


    // --------------------------------------------
    // Sample tile endpoints
    // --------------------------------------------

    var start_point = sample_path(
        distance_start,
        path_distances
    );

    var end_point = sample_path(
        distance_end,
        path_distances
    );

    var ax = start_point[0];
    var ay = start_point[1];

    var bx = end_point[0];
    var by = end_point[1];


    // --------------------------------------------
    // Tile direction
    // --------------------------------------------

    var distance = point_distance(
        ax, ay,
        bx, by
    );

    if (distance <= 0.001)
    {
        continue;
    }

    var ux = (bx - ax) / distance;
    var uy = (by - ay) / distance;


    // --------------------------------------------
    // Preserve original chain width
    // --------------------------------------------

    var nx = uy * half_width;
    var ny = -ux * half_width;


    // --------------------------------------------
    // Draw complete chain tile
    // --------------------------------------------

    draw_sprite_pos(
        chain_sprite,
        0,

        ax - nx,
        ay - ny,

        ax + nx,
        ay + ny,

        bx + nx,
        by + ny,

        bx - nx,
        by - ny,

        1
    );
}


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    draw_set_color(c_lime);

    for (var i = 0; i <= segment_count; i++)
    {
        draw_circle(
            point_x[i],
            point_y[i],
            2,
            false
        );
    }

    draw_set_color(c_white);
}