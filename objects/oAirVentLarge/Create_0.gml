/// oAirVentLarge — Create

depth = -15000;
sprite_index = spriteAirVentLarge;
visible = true;

// EDITOR VARIABLES
// wind_dir is optional. Existing direction overrides remain supported.
// GameMaker may normalize a legacy direction of -1 to 359 degrees.
if (!variable_instance_exists(id, "wind_dir"))
{
    wind_dir = (direction < 0 || direction == 359 || direction == 180) ? -1 : 1;
}
wind_dir = (wind_dir < 0) ? -1 : 1;

if (!variable_instance_exists(id, "air_repeats")) air_repeats = 4;
if (!variable_instance_exists(id, "on_time_s")) on_time_s = 2.5;
if (!variable_instance_exists(id, "off_time_s")) off_time_s = 2.0;
if (!variable_instance_exists(id, "start_on")) start_on = false;
if (!variable_instance_exists(id, "opening_speed")) opening_speed = 0.15;
if (!variable_instance_exists(id, "closing_speed")) closing_speed = 0.15;
if (!variable_instance_exists(id, "air_repeat_delay")) air_repeat_delay = 0.08;
if (!variable_instance_exists(id, "wind_strength")) wind_strength = 0.28;
if (!variable_instance_exists(id, "wind_max_speed")) wind_max_speed = 9.0;
if (!variable_instance_exists(id, "against_wind_mult")) against_wind_mult = 0.20;
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;

// VALUE SAFETY
air_repeats = max(1, round(air_repeats));
on_time_s = max(0, on_time_s);
off_time_s = max(0, off_time_s);
opening_speed = max(0.01, opening_speed);
closing_speed = max(0.01, closing_speed);
air_repeat_delay = max(0, air_repeat_delay);
wind_strength = max(0, wind_strength);
wind_max_speed = max(0, wind_max_speed);
against_wind_mult = clamp(against_wind_mult, 0, 1);

// SPRITE FRAMES
open_frame = 2;
closed_frame = 4;

// STATE
VENT_CLOSED = 0;
VENT_OPENING = 1;
VENT_OPEN = 2;
VENT_CLOSING = 3;

// TIMING
on_frames = max(1, round(on_time_s * room_speed));
off_frames = max(1, round(off_time_s * room_speed));
state_timer = 0;

// MANUAL ANIMATION
image_speed = 0;
vent_anim_position = closed_frame;
wind_frame_position = 0;
wind_animation_speed = 0.22;

// WIND GEOMETRY
air_tile_gap = -2;
wind_collision_height_scale = 0.78;

// INITIAL STATE
if (start_on)
{
    vent_state = VENT_OPEN;
    vent_anim_position = open_frame;
    image_index = open_frame;
    state_timer = on_frames;
}
else
{
    vent_state = VENT_CLOSED;
    vent_anim_position = closed_frame;
    image_index = closed_frame;
    state_timer = off_frames;
}

// GROUNDED WIND / METAL SCRAPE
if (!variable_instance_exists(id, "ground_push_enabled")) ground_push_enabled = true;
if (!variable_instance_exists(id, "ground_push_speed")) ground_push_speed = 0.35;
if (!variable_instance_exists(id, "ground_sparks_enabled")) ground_sparks_enabled = true;
if (!variable_instance_exists(id, "ground_spark_interval")) ground_spark_interval = 4;
if (!variable_instance_exists(id, "ground_spark_y_offset")) ground_spark_y_offset = 6;

ground_push_speed = max(0, ground_push_speed);
ground_spark_interval = max(1, round(ground_spark_interval));
