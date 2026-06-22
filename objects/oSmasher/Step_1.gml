/// oSmasher — Begin Step

if (!enabled) exit;

// Hot-reload safety
if (!variable_instance_exists(id, "snd_smasher_down"))      snd_smasher_down      = asset_get_index("SmasherDown1");
if (!variable_instance_exists(id, "snd_smasher_lift"))      snd_smasher_lift      = asset_get_index("SmasherLift1");
if (!variable_instance_exists(id, "snd_smasher_floor_hit")) snd_smasher_floor_hit = asset_get_index("SmasherFloorHit");

if (!variable_instance_exists(id, "smasher_down_gain"))      smasher_down_gain = 0.85;
if (!variable_instance_exists(id, "smasher_lift_gain"))      smasher_lift_gain = 0.75;
if (!variable_instance_exists(id, "smasher_floor_hit_gain")) smasher_floor_hit_gain = 1.0;

if (!variable_instance_exists(id, "smasher_cycle_started")) smasher_cycle_started = false;
if (!variable_instance_exists(id, "smasher_player_hit_sfx_lock")) smasher_player_hit_sfx_lock = false;

if (!variable_instance_exists(id, "smasher_sfx_inner_dist")) smasher_sfx_inner_dist = 100;
if (!variable_instance_exists(id, "smasher_sfx_outer_dist")) smasher_sfx_outer_dist = 420;

function __smasher_play_dist_sfx(_snd, _gain)
{
    if (_snd == -1) return;

    var _p = instance_find(oPlayer, 0);
    if (_p == noone) return;

    var _d = point_distance(x, y, _p.x, _p.y);
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
    smasher_player_hit_sfx_lock = false;

    exit;
}

// First frame after pause = starts moving down
if (!smasher_cycle_started)
{
    __smasher_play_dist_sfx(snd_smasher_down, smasher_down_gain);
    smasher_cycle_started = true;
    smasher_player_hit_sfx_lock = false;
}

var old_frame = floor(image_index);

image_speed = 0;
image_index += smasher_anim_speed;

var new_frame = floor(image_index);

// Floor hit exactly when entering crush frames
if (old_frame < active_from && new_frame >= active_from)
{
    __smasher_play_dist_sfx(snd_smasher_floor_hit, smasher_floor_hit_gain);
}

// Lift sound exactly when leaving crush frames
if (old_frame <= active_to && new_frame > active_to)
{
    __smasher_play_dist_sfx(snd_smasher_lift, smasher_lift_gain);
}

// Reset cycle
if (image_index >= image_number - 1)
{
    image_index = 0;
    new_frame = 0;

    active = false;
    mask_index = mask_body;

    smasher_cycle_started = false;
    smasher_player_hit_sfx_lock = false;

    if (smasher_pause_frames > 0)
    {
        smasher_pause_timer = smasher_pause_frames;
    }

    exit;
}

// Active window before collision
if (use_active_frames)
{
    active = (new_frame >= active_from && new_frame <= active_to);
}
else
{
    active = true;
}

mask_index = active ? mask_full : mask_body;