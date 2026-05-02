/// oPlayer - Draw GUI (surface-ground safe)

if (!variable_instance_exists(id, "debug_draw")) debug_draw = true;
if (!debug_draw) exit;

// Safety
if (!variable_instance_exists(id, "jump_charge"))             jump_charge = 0;
if (!variable_instance_exists(id, "jump_charge_level"))       jump_charge_level = 0;
if (!variable_instance_exists(id, "jump_charge_frame_steps")) jump_charge_frame_steps = 6;
if (!variable_instance_exists(id, "jump_charging"))           jump_charging = false;
if (!variable_instance_exists(id, "vsp"))                     vsp = 0;
if (!variable_instance_exists(id, "hsp"))                     hsp = 0;
if (!variable_instance_exists(id, "prev_on_ground"))          prev_on_ground = false;
if (!variable_instance_exists(id, "state"))                   state = "idle";
if (!variable_instance_exists(id, "standing_platform"))       standing_platform = noone;

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x  = 16;
var _y  = 16;
var _sx = 0.6;
var _sy = 0.6;
var _lh = 10;

function __dbg(_txt, _dx, _dy, _sx, _sy) {
    draw_text_transformed(_dx, _dy, _txt, _sx, _sy, 0);
}

var _tm_ok = (variable_global_exists("tm_solids") && !is_undefined(global.tm_solids) && global.tm_solids != -1);

var _data = -999;
if (_tm_ok) {
    var _feet_y = bbox_bottom + 1;
    _data = tilemap_get_at_pixel(global.tm_solids, x, _feet_y);
}

var sprCharge = asset_get_index("spriteBotJumpCharge");
var max_level = 3;
if (sprCharge != -1) {
    max_level = max(0, sprite_get_number(sprCharge) - 1);
}

var mult = 1.0 + (0.25 * jump_charge_level);

__dbg("Solids tilemap bound: " + string(_tm_ok), _x, _y, _sx, _sy); _y += _lh;
__dbg("global.tm_solids: " + string(_tm_ok ? global.tm_solids : "undefined"), _x, _y, _sx, _sy); _y += _lh;
__dbg("Layer 'Solids' exists: " + string(layer_exists("Solids")), _x, _y, _sx, _sy); _y += _lh;
__dbg("grounded(prev step): " + string(prev_on_ground), _x, _y, _sx, _sy); _y += _lh;
__dbg("state: " + string(state), _x, _y, _sx, _sy); _y += _lh;
__dbg("tile data under feet (SOLIDS): " + string(_data) + "  (EMPTY should be 0)", _x, _y, _sx, _sy); _y += _lh;
__dbg("jump_charging: " + string(jump_charging), _x, _y, _sx, _sy); _y += _lh;
__dbg("jump_charge_steps: " + string(jump_charge) + "  (steps_per_frame=" + string(jump_charge_frame_steps) + ")", _x, _y, _sx, _sy); _y += _lh;
__dbg("jump_charge_level: " + string(jump_charge_level) + " / " + string(max_level), _x, _y, _sx, _sy); _y += _lh;
__dbg("jump_mult (release): " + string(mult), _x, _y, _sx, _sy); _y += _lh;
__dbg("standing_platform: " + string(standing_platform), _x, _y, _sx, _sy); _y += _lh;
__dbg("hsp: " + string(hsp), _x, _y, _sx, _sy); _y += _lh;
__dbg("vsp: " + string(vsp), _x, _y, _sx, _sy); _y += _lh;