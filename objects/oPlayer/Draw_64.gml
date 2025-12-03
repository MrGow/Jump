/// oPlayer — Draw GUI (DEBUG)

draw_set_color(c_white);

var _line = 16;

// --- 1) Check ground via same logic as Step (if function exists) ---
var _on_ground_rect = 0;
if (is_undefined(__rect_hits_solid) == false) {
    _on_ground_rect = __rect_hits_solid(0, 1);
}
draw_text(16, _line, "on_ground (rect_hits_solid): " + string(_on_ground_rect));
_line += 16;

// --- 2) Inspect tile directly under feet on 'Solids' layer ---
var _tile_index = -999;
if (layer_exists("Solids")) {
    var _lid = layer_get_id("Solids");
    var _tm  = -1;

    var _elems = layer_get_all_elements(_lid);
    for (var i = 0; i < array_length(_elems); i++) {
        var el = _elems[i];
        if (layer_get_element_type(el) == layerelementtype_tilemap) {
            _tm = el;
            break;
        }
    }

    if (_tm != -1) {
        // sample just below bbox_bottom
        var _feet_y = bbox_bottom + 1;
        var _data   = tilemap_get_at_pixel(_tm, x, _feet_y);
        _tile_index = tile_get_index(_data); // -1 = no tile, 0+ = real tile
    }
}

draw_text(16, _line, "tile index under feet: " + string(_tile_index));
_line += 16;

// --- 3) Raw keyboard jump input (this frame) ---
var _kb_jump_press = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up);
var _kb_jump_hold  = keyboard_check(vk_space)         || keyboard_check(vk_up);

draw_text(16, _line, "kb jump_press (Space/Up): " + string(_kb_jump_press));
_line += 16;
draw_text(16, _line, "kb jump_hold  (Space/Up): " + string(_kb_jump_hold));
_line += 16;

// --- 4) oInput globals (if present) ---
var _inp_jump_press  = variable_global_exists("inp_jump_press")  ? global.inp_jump_press  : -1;
var _inp_jump_held   = variable_global_exists("inp_jump_held")   ? global.inp_jump_held   : -1;
var _inp_move        = variable_global_exists("inp_move")        ? global.inp_move        : 0;

draw_text(16, _line, "global.inp_move:       " + string(_inp_move));
_line += 16;
draw_text(16, _line, "global.inp_jump_press: " + string(_inp_jump_press));
_line += 16;
draw_text(16, _line, "global.inp_jump_held:  " + string(_inp_jump_held));
_line += 16;

// --- 5) Current vsp (for sanity) ---
draw_text(16, _line, "vsp: " + string(vsp));
_line += 16;
