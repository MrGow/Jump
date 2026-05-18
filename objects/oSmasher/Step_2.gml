/// oSmasher — End Step (FULL)
if (!enabled) exit;
if (!active)  exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;
if (variable_instance_exists(p, "state") && p.state == "dead") exit;

if (kill_only_when_falling) {
    var pv = (variable_instance_exists(p, "vsp")) ? p.vsp : 0;
    if (pv < 0) exit;
}

// IMPORTANT:
// bbox_* here comes from the CURRENT mask_index (spriteSmasherMaskSolid),
// which is what we want for “solid body” + frame-accurate blocking.

if (!(p.bbox_right > bbox_left && p.bbox_left < bbox_right)) exit;

// Plate underside band (from solid mask bbox)
var band = (variable_instance_exists(id,"kill_band_h")) ? kill_band_h : 8;
var plate_t = bbox_bottom - band;
var plate_b = bbox_bottom;

// 1) head enters underside band
var head_y   = p.bbox_top;
var head_hit = (head_y >= plate_t && head_y <= plate_b);

// 2) crushed: intersects underside line while supported below
var intersects_line = (p.bbox_top < bbox_bottom && p.bbox_bottom > bbox_bottom - 1);

var supported = false;
if (variable_instance_exists(p, "tile_any_solid_at")) {
    supported = p.tile_any_solid_at(p.x, p.bbox_bottom + 1);
} else {
    supported = (variable_instance_exists(p, "vsp") && p.vsp == 0);
}

var crushed = intersects_line && supported;

if (head_hit || crushed)
{
    var sink = (variable_instance_exists(id,"sink_px")) ? sink_px : 6;

    // FIX: lock relative to the PLAYER'S current feet so we never snap upward
    var lock_y = p.bbox_bottom + sink;

    // (Optional safety: if you still see tiny pops, use this instead)
    // var lock_y = max(p.bbox_bottom, bbox_bottom) + sink;

    with (p) {
        if (script_exists(asset_get_index("scr_player_died"))) {
            scr_player_died(lock_y);
        } else {
            state = "dead";
        }
    }
}
