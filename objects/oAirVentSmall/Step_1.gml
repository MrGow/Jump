/// oAirVentSmall — Begin Step

if (!enabled)
{
    exit;
}

if (scr_game_frozen())
{
    exit;
}


var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}

if (wind_sprite == -1)
{
    exit;
}


// ====================================================
// CALCULATE WIND COLUMN
// ====================================================

var wind_width =
    sprite_get_width(wind_sprite);

var wind_height =
    sprite_get_height(wind_sprite);

var column_width =
    wind_width *
    wind_collision_width_scale *
    abs(image_xscale);

var column_height =
    wind_tiles *
    (
        wind_height +
        wind_tile_gap
    );


// The air begins at the top of the vent sprite.
var column_bottom =
    bbox_top;

var column_top =
    column_bottom -
    column_height;

var column_left =
    x -
    column_width * 0.5;

var column_right =
    x +
    column_width * 0.5;


// ====================================================
// PLAYER / WIND OVERLAP
// ====================================================

var inside_wind =
    p.bbox_right  > column_left &&
    p.bbox_left   < column_right &&
    p.bbox_bottom > column_top &&
    p.bbox_top    < column_bottom;

if (!inside_wind)
{
    exit;
}


// ====================================================
// MARK PLAYER AS INSIDE A VENT THIS FRAME
// ====================================================

p.air_vent_active_until =
    current_time + 40;

p.air_vent_source = id;

p.air_vent_up_accel =
    updraft_acceleration;

p.air_vent_max_rise_speed =
    maximum_rise_speed;

p.air_vent_bias =
    horizontal_bias;

p.air_vent_bias_max_speed =
    bias_max_speed;

p.air_vent_horizontal_accel =
    horizontal_acceleration;