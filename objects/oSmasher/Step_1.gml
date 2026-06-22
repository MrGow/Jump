/// oSmasher — Begin Step

if (!enabled) exit;

// Hot-reload safety
if (!variable_instance_exists(id, "snd_smasher_down"))      snd_smasher_down      = asset_get_index("SmasherDown1");
if (!variable_instance_exists(id, "snd_smasher_lift"))      snd_smasher_lift      = asset_get_index("SmasherLift1");
if (!variable_instance_exists(id, "snd_smasher_floor_hit")) snd_smasher_floor_hit = asset_get_index("SmasherFloorHit1");

if (!variable_instance_exists(id, "smasher_down_gain"))      smasher_down_gain = 0.55;
if (!variable_instance_exists(id, "smasher_lift_gain"))      smasher_lift_gain = 0.35;
if (!variable_instance_exists(id, "smasher_floor_hit_gain")) smasher_floor_hit_gain = 0.80;

if (!variable_instance_exists(id, "smasher_cycle_started")) smasher_cycle_started = false;
if (!variable_instance_exists(id, "smasher_floor_sfx_played")) smasher_floor_sfx_played = false;
if (!variable_instance_exists(id, "smasher_lift_sfx_played")) smasher_lift_sfx_played = false;
if (!variable_instance_exists(id, "smasher_player_hit_sfx_lock")) smasher_player_hit_sfx_lock = false;

if (!variable_instance_exists(id, "smasher_sfx_inner_dist")) smasher_sfx_inner_dist = 100;
if (!variable_instance_exists(id, "smasher_sfx_outer_dist")) smasher_sfx_outer_dist = 300;

function __smasher_play_dist_sfx(_snd, _gain)
{
    if (_snd == -1) return;

    var _p = instance_find(oPlayer, 0);
    if (_p == noone) return;

    // Origin is top-middle, so use the active smasher body/plate area instead.
    var _sx = (bbox_left + bbox_right) * 0.5;
    var _sy = bbox_bottom;

    var _px = _p.x;
    var _py = (_p.bbox_top + _p.bbox_bottom) * 0.5;

    var _d = point_distance(_sx, _sy, _px, _py);

    if (_d >= smasher_sfx_outer_dist) return;

    var _dist_gain = 1;

    if (_d > smasher_sfx_inner_dist)
    {
        var _t = (_d - smasher_sfx_inner_dist) / max(1, smasher_sfx_outer_dist - smasher_sfx_inner_dist);
        _dist_gain = 1 - clamp(_t, 0, 1);
    }

    scr_play_sfx(_snd, _gain * _dist_gain, random_range(0.97, 1.03));
}

x = base_x;
y = base_y;

// Pause while raised
if (smasher_pause_timer > 0)
{
    smasher_pause_timer--;

    image_speed = 0;
    image_index = 0;

    active = false;
    mask_index = mask_body;

    smasher_cycle_started = false;
    smasher_floor_sfx_played = false;
    smasher_lift_sfx_played = false;
    smasher_player_hit_sfx_lock = false;

    exit;
}

// First moving frame = starts going down
if (!smasher_cycle_started)
{
    __smasher_play_dist_sfx(snd_smasher_down, smasher_down_gain);

    smasher_cycle_started = true;
    smasher_floor_sfx_played = false;
    smasher_lift_sfx_played = false;
    smasher_player_hit_sfx_lock = false;
}

image_speed = 0;
image_index += smasher_anim_speed;

// Floor hit when it reaches dangerous frames
if (!smasher_floor_sfx_played && image_index >= active_from)
{
    __smasher_play_dist_sfx(snd_smasher_floor_hit, smasher_floor_hit_gain);
    smasher_floor_sfx_played = true;
}

// Lift sound when it starts leaving dangerous frames
if (!smasher_lift_sfx_played && image_index > active_to)
{
    __smasher_play_dist_sfx(snd_smasher_lift, smasher_lift_gain);
    smasher_lift_sfx_played = true;
}

// Reset cycle
if (image_index >= image_number - 1)
{
    image_index = 0;

    active = false;
    mask_index = mask_body;

    smasher_cycle_started = false;
    smasher_floor_sfx_played = false;
    smasher_lift_sfx_played = false;
    smasher_player_hit_sfx_lock = false;

    if (smasher_pause_frames > 0)
    {
        smasher_pause_timer = smasher_pause_frames;
    }

    exit;
}

// Active window before collision
var fr = floor(image_index);

if (use_active_frames)
{
    active = (fr >= active_from && fr <= active_to);
}
else
{
    active = true;
}

mask_index = active ? mask_full : mask_body;