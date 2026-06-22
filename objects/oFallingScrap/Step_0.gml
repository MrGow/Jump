/// oFallingScrap — Step

if (!enabled) exit;

// Hot-reload safety
if (!variable_instance_exists(id, "snd_falling_scrap")) snd_falling_scrap = asset_get_index("FallingScrap1");
if (!variable_instance_exists(id, "snd_scrap_impact"))  snd_scrap_impact  = asset_get_index("FallingScrapImpact1");

if (!variable_instance_exists(id, "falling_scrap_fall_gain"))   falling_scrap_fall_gain = 0.55;
if (!variable_instance_exists(id, "falling_scrap_impact_gain")) falling_scrap_impact_gain = 0.95;

if (!variable_instance_exists(id, "falling_scrap_inner_dist")) falling_scrap_inner_dist = 220;
if (!variable_instance_exists(id, "falling_scrap_outer_dist")) falling_scrap_outer_dist = 640;
if (!variable_instance_exists(id, "falling_scrap_sound_played")) falling_scrap_sound_played = false;

// ----------------------------------------------------
// Distance gain
// ----------------------------------------------------
var p_audio = instance_find(oPlayer, 0);
var dist_gain = 0;

if (p_audio != noone)
{
    var d = point_distance(x, y, p_audio.x, p_audio.y);

    if (d <= falling_scrap_inner_dist)
    {
        dist_gain = 1;
    }
    else if (d < falling_scrap_outer_dist)
    {
        var tdist = (d - falling_scrap_inner_dist) / max(1, falling_scrap_outer_dist - falling_scrap_inner_dist);
        dist_gain = 1 - clamp(tdist, 0, 1);
    }
}

// Play falling warning once when close enough
if (!falling_scrap_sound_played && dist_gain > 0)
{
    scr_play_sfx(
        snd_falling_scrap,
        falling_scrap_fall_gain * dist_gain,
        random_range(0.96, 1.04)
    );

    falling_scrap_sound_played = true;
}

// ----------------------------------------------------
// Movement
// ----------------------------------------------------
x += hsp;
y += fall_speed;
image_angle += spin_speed;

// ----------------------------------------------------
// Lifetime despawn
// ----------------------------------------------------
life_timer--;
if (life_timer <= 0)
{
    instance_destroy();
    exit;
}

// ----------------------------------------------------
// Kill player on touch
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (variable_instance_exists(p, "state") && p.state == "dead") exit;

var l = bbox_left   + kill_inset_x;
var r = bbox_right  - kill_inset_x;
var t = bbox_top    + kill_inset_y;
var b = bbox_bottom - kill_inset_y;

var hit =
    (p.bbox_right  > l) &&
    (p.bbox_left   < r) &&
    (p.bbox_bottom > t) &&
    (p.bbox_top    < b);

if (hit)
{
    scr_play_sfx(
        snd_scrap_impact,
        falling_scrap_impact_gain,
        random_range(0.96, 1.04)
    );

    with (p)
    {
        scr_player_died();
    }

    instance_destroy();
}