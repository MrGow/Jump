/// oPlayer — Draw GUI (DEBUG)

draw_set_color(c_white);

var _x = 16;
var _line = 16;

// Smaller debug text scale
var _sx = 0.6;
var _sy = 0.6;

// Tighter line spacing for smaller text
var _line_h = 10;

// Helper
function __dbg(_txt, _x, _y, _sx, _sy) {
    draw_text_transformed(_x, _y, _txt, _sx, _sy, 0);
}

// ---- Safety (so debug never crashes on hot reload) ----
if (!variable_instance_exists(id, "jump_charge"))             jump_charge = 0;
if (!variable_instance_exists(id, "jump_charge_level"))       jump_charge_level = 0;
if (!variable_instance_exists(id, "jump_charge_frame_steps")) jump_charge_frame_steps = 6;
if (!variable_instance_exists(id, "jump_charging"))           jump_charging = false;
if (!variable_instance_exists(id, "vsp"))                     vsp = 0;
if (!variable_instance_exists(id, "hsp"))                     hsp = 0;

// ---- Tilemap binding status (from your strict solids setup) ----
var _tm_ok = (!is_undefined(global.tm_solids) && global.tm_solids != -1);
__dbg("Solids tilemap bound: " + string(_tm_ok), _x, _line, _sx, _sy);
_line += _line_h;

__dbg("global.tm_solids: " + string(is_undefined(global.tm_solids) ? "undefined" : global.tm_solids), _x, _line, _sx, _sy);
_line += _line_h;

__dbg("Layer 'Solids' exists: " + string(layer_exists("Solids")), _x, _line, _sx, _sy);
_line += _line_h;

// Ground check using your instance method
var _g = on_ground_check();
__dbg("on_ground_check(): " + string(_g), _x, _line, _sx, _sy);
_line += _line_h;

// Sample SOLIDS tile under feet
var _data = -999;
if (_tm_ok) {
    var _feet_y = bbox_bottom + 1;
    _data = tilemap_get_at_pixel(global.tm_solids, x, _feet_y);
}
__dbg("tile data under feet (SOLIDS): " + string(_data) + "  (EMPTY should be 0)", _x, _line, _sx, _sy);
_line += _line_h;

// ---- Charge sprite info ----
var sprCharge = asset_get_index("spriteBotJumpCharge");
var max_level = 3; // fallback if sprite missing
if (sprCharge != -1) {
    max_level = max(0, sprite_get_number(sprCharge) - 1);
}

__dbg("jump_charging: " + string(jump_charging), _x, _line, _sx, _sy);
_line += _line_h;

__dbg("jump_charge_steps: " + string(jump_charge) + "  (steps_per_frame=" + string(jump_charge_frame_steps) + ")", _x, _line, _sx, _sy);
_line += _line_h;

__dbg("jump_charge_level: " + string(jump_charge_level) + " / " + string(max_level), _x, _line, _sx, _sy);
_line += _line_h;

// Show resulting multiplier (+25% per level)
var mult = 1.0 + (0.25 * jump_charge_level);
__dbg("jump_mult (release): " + string(mult), _x, _line, _sx, _sy);
_line += _line_h;

// ---- Speeds ----
__dbg("hsp: " + string(hsp), _x, _line, _sx, _sy);
_line += _line_h;

__dbg("vsp: " + string(vsp), _x, _line, _sx, _sy);
_line += _line_h;