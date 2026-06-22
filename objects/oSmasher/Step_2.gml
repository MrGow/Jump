/// oSmasher — End Step

if (!enabled) exit;
if (!active)  exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

if (kill_only_when_falling)
{
    var pv = variable_instance_exists(p, "vsp") ? p.vsp : 0;
    if (pv < 0) exit;
}

if (!(p.bbox_right > bbox_left && p.bbox_left < bbox_right)) exit;

var band = variable_instance_exists(id, "kill_band_h") ? kill_band_h : 8;
var plate_t = bbox_bottom - band;
var plate_b = bbox_bottom;

var head_y   = p.bbox_top;
var head_hit = (head_y >= plate_t && head_y <= plate_b);

var intersects_line = (p.bbox_top < bbox_bottom && p.bbox_bottom > bbox_bottom - 1);

var supported = false;

if (variable_instance_exists(p, "tile_any_solid_at"))
{
    supported = p.tile_any_solid_at(p.x, p.bbox_bottom + 1);
}
else
{
    supported = variable_instance_exists(p, "vsp") && p.vsp == 0;
}

var crushed = intersects_line && supported;

if (head_hit || crushed)
{
    var sink = variable_instance_exists(id, "sink_px") ? sink_px : 6;
    var lock_y = p.bbox_bottom + sink;

    // Player crush impact: full volume because player is directly under it
    scr_play_sfx(
        snd_smasher_floor_hit,
        smasher_floor_hit_gain,
        random_range(0.96, 1.02)
    );

    with (p)
    {
        if (script_exists(asset_get_index("scr_player_died")))
        {
            scr_player_died(lock_y);
        }
        else
        {
            state = "dead";
        }
    }
}