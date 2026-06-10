/// oLaserGun — Step

if (!enabled) exit;

active = false;

if (state == "waiting")
{
    image_speed = 0;
    image_index = 0;

    laser_fx_frame = 0;

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
    }
}
else if (state == "firing")
{
    active = true;

    // One shared frame source keeps beam + end effect synced
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

var p = instance_find(oPlayer, 0);

if (p != noone)
{
    if (!(variable_instance_exists(p, "state") && p.state == "dead"))
    {
        for (var pd = 0; pd <= dist_hit; pd += ray_step)
        {
            var px = sx + dx * pd;
            var py = sy + dy * pd;

            if (point_in_rectangle(px, py, p.bbox_left, p.bbox_top, p.bbox_right, p.bbox_bottom))
            {
                dist_hit = pd;
                hit_x = px;
                hit_y = py;
                hit_player = p;
                break;
            }
        }
    }
}

// If the laser reaches max range without hitting anything,
// pull the end effect slightly inward to avoid a small visual gap.
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