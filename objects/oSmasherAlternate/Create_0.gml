/// oSmasherAlternate — Create

event_inherited();

// SPRITES
spr_top = asset_get_index("spriteSmasherTop");
spr_bottom = asset_get_index("spriteSmasherBottom");
spr_hydraulic = asset_get_index("spriteTilingHydraulic");
sprite_index = -1;
mask_index = -1;
solid = false;

// POSITION
base_x = x;
base_y = y;
top_w = sprite_get_width(spr_top);
top_h = sprite_get_height(spr_top);
bottom_w = sprite_get_width(spr_bottom);
bottom_h = sprite_get_height(spr_bottom);
hydraulic_w = sprite_get_width(spr_hydraulic);
center_x = base_x + top_w * 0.5;
bottom_x = round(center_x - bottom_w * 0.5);
hydraulic_x = round(center_x - hydraulic_w * 0.5) + 1;
if (!variable_instance_exists(id, "head_overlap")) head_overlap = 4;
if (!variable_instance_exists(id, "windup_distance")) windup_distance = 6;
windup_distance = max(0, windup_distance);
// Keep a visible hydraulic gap even at the highest wind-up point.
// This replaces the former overlap-based resting position.
if (!variable_instance_exists(id, "minimum_hydraulic_gap")) minimum_hydraulic_gap = 8;
minimum_hydraulic_gap = max(0, round(minimum_hydraulic_gap));
head_raised_y = base_y + top_h + minimum_hydraulic_gap + windup_distance;

// MOVEMENT CONFIGURATION
if (!variable_instance_exists(id, "smash_distance")) smash_distance = 96;
if (!variable_instance_exists(id, "wait_frames")) wait_frames = 60;
if (!variable_instance_exists(id, "warning_frames")) warning_frames = 12;
if (!variable_instance_exists(id, "drop_frames")) drop_frames = 10;
if (!variable_instance_exists(id, "impact_hold_frames")) impact_hold_frames = 12;
if (!variable_instance_exists(id, "retract_frames")) retract_frames = 28;
smash_distance = max(1, round(smash_distance));
wait_frames = max(0, round(wait_frames));
warning_frames = max(0, round(warning_frames));
drop_frames = max(1, round(drop_frames));
impact_hold_frames = max(0, round(impact_hold_frames));
retract_frames = max(1, round(retract_frames));
cycle_frames = wait_frames + warning_frames + drop_frames + impact_hold_frames + retract_frames;

// SHARED TIMING
if (!variable_instance_exists(id, "use_shared_timing")) use_shared_timing = false;
if (!variable_instance_exists(id, "timing_group")) timing_group = "default";
if (!variable_instance_exists(id, "timing_offset_frames")) timing_offset_frames = 0;
if (!variable_instance_exists(id, "timing_initial_delay")) timing_initial_delay = 0;
timing_controller = noone;
timing_seen_generation = -1;
local_clock = -1;
cycle_initialized = false;

// RUNTIME MOVEMENT
head_offset = 0;
head_y = head_raised_y;
head_previous_y = head_y;
head_move_y = 0;
smash_state = "raised";
previous_smash_state = "raised";
active = false;
descending = false;

// COLLISION SETTINGS
if (!variable_instance_exists(id, "enabled")) enabled = true;
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;
if (!variable_instance_exists(id, "crush_inset_x")) crush_inset_x = 4;
if (!variable_instance_exists(id, "smasher_death_type")) smasher_death_type = "crush";
if (!variable_instance_exists(id, "smasher_death_shake_strength")) smasher_death_shake_strength = -1;
if (!variable_instance_exists(id, "smasher_death_shake_frames")) smasher_death_shake_frames = -1;
if (!variable_instance_exists(id, "sink_px")) sink_px = 6;
// Start the collision rod at the housing's lower edge so the
// newly exposed hydraulic section is solid as well.
collision_rod_start_y = base_y + top_h;
collision_rod_overlap = 8;

// INVISIBLE PHYSICAL PROXIES
collision_body = instance_create_depth(base_x, base_y, depth, oSmasherAlternateBody);
collision_hydraulic = instance_create_depth(hydraulic_x, collision_rod_start_y, depth, oSmasherAlternateHydraulic);
collision_head = instance_create_depth(bottom_x, head_raised_y, depth, oSmasherAlternateHead);
collision_body.owner = id;
collision_hydraulic.owner = id;
collision_head.owner = id;
collision_body.visible = false;
collision_hydraulic.visible = false;
collision_head.visible = false;
collision_body.mask_index = spr_top;
collision_hydraulic.mask_index = spr_hydraulic;
collision_head.mask_index = spr_bottom;
collision_head.enabled = enabled;
collision_head.active = enabled;
collision_head.surface_inset_left = 4;
collision_head.surface_inset_right = 4;
collision_head.dx = 0;
collision_head.dy = 0;
collision_hydraulic.image_yscale = max(1, head_y + collision_rod_overlap - collision_rod_start_y) / max(1, sprite_get_height(spr_hydraulic));

// SOUNDS
snd_smasher_down = asset_get_index("SmasherDown1");
snd_smasher_lift = asset_get_index("SmasherLift1");
snd_smasher_floor_hit = asset_get_index("SmasherFloorHit1");
smasher_down_gain = 0.55;
smasher_lift_gain = 0.35;
smasher_floor_hit_gain = 0.80;
smasher_sfx_inner_dist = 250;
smasher_sfx_outer_dist = 400;

smasher_play_sound = function(_sound, _gain)
{
    if (_sound == -1) return;
    var _player = instance_find(oPlayer, 0);
    if (_player == noone) return;
    var _sound_x = center_x;
    var _sound_y = head_y + bottom_h * 0.5;
    var _player_y = (_player.bbox_top + _player.bbox_bottom) * 0.5;
    var _distance = point_distance(_sound_x, _sound_y, _player.x, _player_y);
    if (_distance >= smasher_sfx_outer_dist) return;
    var _gain_factor = 1;
    if (_distance > smasher_sfx_inner_dist)
    {
        _gain_factor = 1 - clamp((_distance - smasher_sfx_inner_dist) / max(1, smasher_sfx_outer_dist - smasher_sfx_inner_dist), 0, 1);
    }
    scr_play_sfx(_sound, _gain * _gain_factor, random_range(0.97, 1.03));
};

find_timing_controller = function()
{
    var _count = instance_number(oHazardTimingController);
    for (var i = 0; i < _count; i++)
    {
        var _controller = instance_find(oHazardTimingController, i);
        if (!instance_exists(_controller)) continue;
        if (string(_controller.timing_group) == string(timing_group)) return _controller;
    }
    return noone;
};

sync_smasher_collision = function()
{
    if (instance_exists(collision_body))
    {
        collision_body.x = base_x;
        collision_body.y = base_y;
    }
    if (instance_exists(collision_head))
    {
        collision_head.x = bottom_x;
        collision_head.y = head_y;
        collision_head.dx = 0;
        collision_head.dy = head_move_y;
        collision_head.enabled = enabled;
        collision_head.active = enabled;
    }
    if (instance_exists(collision_hydraulic))
    {
        var _rod_height = max(1, round(head_y + collision_rod_overlap - collision_rod_start_y));
        collision_hydraulic.x = hydraulic_x;
        collision_hydraulic.y = collision_rod_start_y;
        collision_hydraulic.image_yscale = _rod_height / max(1, sprite_get_height(spr_hydraulic));
    }
};

sync_smasher_collision();
