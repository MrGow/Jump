/// oPlayer - Draw GUI (safe globals)

if (!variable_instance_exists(id, "debug_draw") || !debug_draw) exit;

// Safe checks for globals
var _has_tm = variable_global_exists("tm_solids");
var _tm_ok  = (_has_tm && global.tm_solids != -1);

var _inp_jump = false;
if (variable_global_exists("inp_jump_held")) _inp_jump = global.inp_jump_held;

// Debug text
var _x = 16;
var _y = 16;
var _lh = 18;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

draw_text(_x, _y, "on_ground_check(): " + string(on_ground_check())); _y += _lh;
draw_text(_x, _y, "tile data under feet (SOLIDS): " + string(_tm_ok)); _y += _lh;
draw_text(_x, _y, "jump_charging: " + string(jump_charging)); _y += _lh;
draw_text(_x, _y, "jump_charge_steps: " + string(jump_charge)); _y += _lh;
draw_text(_x, _y, "jump_charge_level: " + string(jump_charge_level)); _y += _lh;
draw_text(_x, _y, "jump_input (held): " + string(_inp_jump)); _y += _lh;
draw_text(_x, _y, "hsp: " + string(hsp)); _y += _lh;
draw_text(_x, _y, "vsp: " + string(vsp)); _y += _lh;