/// oLaserGun — Step

// Hot-reload safety
if (!variable_instance_exists(id, "snd_laser_shoot")) snd_laser_shoot = asset_get_index("LaserGunShoot1");
if (!variable_instance_exists(id, "laser_shoot_gain")) laser_shoot_gain = 0.9;
if (!variable_instance_exists(id, "laser_sfx_inner_dist")) laser_sfx_inner_dist = 100;
if (!variable_instance_exists(id, "laser_sfx_outer_dist")) laser_sfx_outer_dist = 420;
if (!variable_instance_exists(id, "laser_shot_sfx_played")) laser_shot_sfx_played = false;
if (!variable_instance_exists(id, "anim_speed")) anim_speed = 0.35;

// ----------------------------------------------------
// Pause freeze
// ----------------------------------------------------
if (scr_game_frozen())
{
    image_speed = 0;

    if (instance_exists(solid_inst))
    {
        solid_inst.x = x;
        solid_inst.y = y;
        solid_inst.image_angle = image_angle;
        solid_inst.enabled = enabled;
        solid_inst.active = true;
    }

    exit;
}

function __laser_play_dist_sfx(_snd, _gain)
{
    if (_snd == -1) return;

    var _p = instance_find(oPlayer, 0);
    if (_p == noone) return;

    var _d = point_distance(x, y, _p.x, _p.y);

    if (_d >= laser_sfx_outer_dist) return;

    var _dist_gain = 1;

    if (_d > laser_sfx_inner_dist)
    {
        var _t = (_d - laser_sfx_inner_dist) / max(1, laser_sfx_outer_dist - laser_sfx_inner_dist);
        _dist_gain = 1 - clamp(_t, 0, 1);
    }

    scr_play_sfx(
        _snd,
        _gain * _dist_gain,
        random_range(0.98, 1.02)
    );
}

// Keep solid base attached
if (instance_exists(solid_inst))
{
    solid_inst.x = x;
    solid_inst.y = y;
    solid_inst.image_angle = image_angle;
    solid_inst.enabled = enabled;
    solid_inst.active = true;
}

active = false;

if (!enabled)
{
    image_speed = 0;
    exit;
}

if (state == "waiting")
{
    image_speed = 0;
    image_index = 0;

    laser_fx_frame = 0;
    laser_shot_sfx_played = false;

    timer--;

    if (timer <= 0)
    {
        state = "windup";
        image_index = 0;
    }
}
else if (state == "windup")
{
    image_speed = 0;
    image_index += anim_speed;

    laser_fx_frame = 0;

    if (image_index >= fire_frame)
    {
        image_index = fire_frame;
        state = "firing";
        fire_timer = fire_hold_frames;

        if (!laser_shot_sfx_played)
        {
            __laser_play_dist_sfx(snd_laser_shoot, laser_shoot_gain);
            laser_shot_sfx_played = true;
        }
    }
}
else if (state == "firing")
{
    active = true;

    laser_fx_frame += sprite_get_speed(spriteLaserGunRepeatingRay) / room_speed;

    image_speed = 0;
    image_index += anim_speed;

    if (image_index > image_number - 1)
    {
        image_index = fire_frame;
    }

    fire_timer--;

    if (fire_timer <= 0)
    {
        active = false;
        state = "waiting";
        timer = wait_frames;

        image_index = 0;
        image_speed = 0;
        laser_shot_sfx_played = false;
    }
}

if (!active) exit;

var sx = x + lengthdir_x(laser_start_dist, laser_dir);
var sy = y + lengthdir_y(laser_start_dist, laser_dir);

laser_start_x = sx;
laser_start_y = sy;

var dx = lengthdir_x(1, laser_dir);
var dy = lengthdir_y(1, laser_dir);

var hit_x = sx + dx * max_laser_length;
var hit_y = sy + dy * max_laser_length;

var dist_hit = max_laser_length;
var hit_player = noone;
var hit_solid = false;

// ----------------------------------------------------
// Stop on solid tiles / solid objects
// ----------------------------------------------------
for (var d = 0; d <= max_laser_length; d += ray_step)
{
    var tx = sx + dx * d;
    var ty = sy + dy * d;

    var solid_hit = false;

    if (layer_exists("Solids"))
    {
        var lid = layer_get_id("Solids");
        var tm = layer_tilemap_get_id(lid);

        if (tm != -1) {
            solid_hit = (tilemap_get_at_pixel(tm, tx, ty) != 0);
        }
    }

    if (!solid_hit && asset_get_index("oSolidDyn") != -1) {
        if (instance_position(tx, ty, oSolidDyn) != noone) solid_hit = true;
    }

    if (!solid_hit && asset_get_index("oSpinnerPlatform") != -1)
    {
        var sp = instance_position(tx, ty, oSpinnerPlatform);

        if (sp != noone)
        {
            if ((!variable_instance_exists(sp, "enabled") || sp.enabled) &&
                (!variable_instance_exists(sp, "active")  || sp.active))
            {
                solid_hit = true;
            }
        }
    }

    if (!solid_hit && asset_get_index("oBreakingPlatform") != -1)
    {
        var bp = instance_position(tx, ty, oBreakingPlatform);

        if (bp != noone)
        {
            if ((!variable_instance_exists(bp, "enabled") || bp.enabled) &&
                (!variable_instance_exists(bp, "active")  || bp.active))
            {
                solid_hit = true;
            }
        }
    }

    if (solid_hit)
    {
        hit_solid = true;
        dist_hit = d;
        hit_x = sx + dx * dist_hit;
        hit_y = sy + dy * dist_hit;
        break;
    }
}

// ----------------------------------------------------
// Stop on player if player is closer than wall hit
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);

if (p != noone)
{
    if (!(variable_instance_exists(p, "state") && p.state == "dead"))
    {
        var start_pd = -laser_hit_start_back;

        for (var pd = start_pd; pd <= dist_hit; pd += ray_step)
        {
            var px = sx + dx * pd;
            var py = sy + dy * pd;

            var pad = laser_hit_pad;

            if (rectangle_in_rectangle(
                px - pad,
                py - pad,
                px + pad,
                py + pad,
                p.bbox_left,
                p.bbox_top,
                p.bbox_right,
                p.bbox_bottom
            ))
            {
                dist_hit = max(0, pd);
                hit_x = sx + dx * dist_hit;
                hit_y = sy + dy * dist_hit;
                hit_player = p;
                break;
            }
        }
    }
}

if (!hit_solid && hit_player == noone)
{
    dist_hit = max(0, dist_hit - 4);
    hit_x = sx + dx * dist_hit;
    hit_y = sy + dy * dist_hit;
}

laser_end_x = hit_x;
laser_end_y = hit_y;
laser_len   = dist_hit;

if (hit_player != noone)
{
    with (hit_player)
    {
        scr_player_died();
    }
}