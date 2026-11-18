/// oAirVentLarge — Begin Step

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}

// CLOSED
if (vent_state == VENT_CLOSED)
{
    image_index = closed_frame;
    vent_anim_position = closed_frame;
    state_timer--;
    if (state_timer <= 0)
    {
        vent_state = VENT_OPENING;
        vent_anim_position = 0;
        image_index = 0;
    }
}
// OPENING
else if (vent_state == VENT_OPENING)
{
    vent_anim_position += opening_speed;
    if (vent_anim_position >= open_frame)
    {
        vent_anim_position = open_frame;
        image_index = open_frame;
        vent_state = VENT_OPEN;
        state_timer = on_frames;
    }
    else
    {
        image_index = floor(vent_anim_position);
    }
}
// OPEN
else if (vent_state == VENT_OPEN)
{
    image_index = open_frame;
    vent_anim_position = open_frame;
    state_timer--;
    if (state_timer <= 0)
    {
        vent_state = VENT_CLOSING;
        vent_anim_position = open_frame;
        image_index = open_frame;
    }
}
// CLOSING
else if (vent_state == VENT_CLOSING)
{
    vent_anim_position += closing_speed;
    if (vent_anim_position >= closed_frame)
    {
        vent_anim_position = closed_frame;
        image_index = closed_frame;
        vent_state = VENT_CLOSED;
        state_timer = off_frames;
    }
    else
    {
        image_index = floor(vent_anim_position);
    }
}

// Only animate air while fully open.
// Wind physics runs here, as in the original vent.
if (vent_state != VENT_OPEN) exit;
wind_frame_position += wind_animation_speed;


// WIND FORCE — restore the original Begin Step behaviour.
var _p = instance_find(oPlayer, 0);
if (_p == noone) exit;
if (variable_instance_exists(_p, "state") && _p.state == "dead") exit;

var _aw = sprite_get_width(spriteAirVentLargeAir);
var _ah = sprite_get_height(spriteAirVentLargeAir);
var _start = x + wind_dir * sprite_get_width(spriteAirVentLarge) * 0.5 * abs(image_xscale);
var _end = _start + wind_dir * air_repeats * (_aw + air_tile_gap);
var _hh = _ah * wind_collision_height_scale * 0.5;

if (_p.bbox_right <= min(_start, _end) ||
    _p.bbox_left >= max(_start, _end) ||
    _p.bbox_bottom <= y - _hh ||
    _p.bbox_top >= y + _hh) exit;

// Record contact so a jump released this frame receives wind too.
_p.large_vent_contact = id;

// Work in wind-relative coordinates, independent of player facing.
var _relative = _p.hsp * wind_dir;
if (_relative < 0)
    _relative *= against_wind_mult;

// Never slow a player already moving faster WITH the wind.
if (_relative < wind_max_speed)
    _relative = min(_relative + wind_strength, wind_max_speed);

_p.hsp = _relative * wind_dir;
