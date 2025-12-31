/// oPlayer — Draw GUI (DEBUG)

draw_set_color(c_white);

var _line = 16;

// ---- Safety (so debug never crashes on hot reload) ----
if (!variable_instance_exists(id, "jump_charge"))            jump_charge = 0;
if (!variable_instance_exists(id, "jump_charge_level"))      jump_charge_level = 0;
if (!variable_instance_exists(id, "jump_charge_frame_steps")) jump_charge_frame_steps = 6;
if (!variable_instance_exists(id, "jump_charging"))          jump_charging = false;
if (!variable_instance_exists(id, "vsp"))                    vsp = 0;
if (!variable_instance_exists(id, "hsp"))                    hsp = 0;

// ---- Tilemap binding status (from your strict solids setup) ----
var _tm_ok = (!is_undefined(global.tm_solids) && global.tm_solids != -1);
draw_text(16, _line, "Solids tilemap bound: " + string(_tm_ok));
_line += 16;

draw_text(16, _line, "global.tm_solids: " + string(is_undefined(global.tm_solids) ? "undefined" : global.tm_solids));
_line += 16;

draw_text(16, _line, "Layer 'Solids' exists: " + string(layer_exists("Solids")));
_line += 16;

// Ground check using your instance method
var _g = on_ground_check();
draw_text(16, _line, "on_ground_check(): " + string(_g));
_line += 16;

// Sample SOLIDS tile under feet
var _data = -999;
if (_tm_ok) {
    var _feet_y = bbox_bottom + 1;
    _data = tilemap_get_at_pixel(global.tm_solids, x, _feet_y);
}
draw_text(16, _line, "tile data under feet (SOLIDS): " + string(_data) + "  (EMPTY should be 0)");
_line += 16;

// ---- Charge sprite info ----
var sprCharge = asset_get_index("spriteBotJumpCharge");
var max_level = 3; // fallback if sprite missing
if (sprCharge != -1) {
    max_level = max(0, sprite_get_number(sprCharge) - 1);
}

draw_text(16, _line, "jump_charging: " + string(jump_charging));
_line += 16;

draw_text(16, _line, "jump_charge_steps: " + string(jump_charge) + "  (steps_per_frame=" + string(jump_charge_frame_steps) + ")");
_line += 16;

draw_text(16, _line, "jump_charge_level: " + string(jump_charge_level) + " / " + string(max_level));
_line += 16;

// Show resulting multiplier (+25% per level)
var mult = 1.0 + (0.25 * jump_charge_level);
draw_text(16, _line, "jump_mult (release): " + string(mult));
_line += 16;

// ---- Speeds ----
draw_text(16, _line, "hsp: " + string(hsp));
_line += 16;

draw_text(16, _line, "vsp: " + string(vsp));
_line += 16;
