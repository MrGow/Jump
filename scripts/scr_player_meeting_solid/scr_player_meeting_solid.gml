/// @func scr_player_meeting_solid(_x, _y)
/// @desc Returns true if the player's bbox hits a non-empty tile
///       on the "Solids" tile layer when the player is at (_x, _y).

function scr_player_meeting_solid(_x, _y)
{
    // 1) Make sure the Solids layer exists
    if (!layer_exists("Solids")) return false;

    var _layer_id = layer_get_id("Solids");
    var _tm       = layer_tilemap_get_id(_layer_id);

    if (_tm <= 0) return false; // no valid tilemap

    // 2) Offsets of this instance's bbox from its origin
    var _off_l = bbox_left   - x;
    var _off_r = bbox_right  - x - 1;
    var _off_t = bbox_top    - y;
    var _off_b = bbox_bottom - y - 1;

    // 3) Corners at the TEST position
    var _l = _x + _off_l;
    var _r = _x + _off_r;
    var _t = _y + _off_t;
    var _b = _y + _off_b;

    // 4) Check each corner
    var _data, _index;

    // TL
    _data  = tilemap_get_at_pixel(_tm, _l, _t);
    _index = tile_get_index(_data);   // -1 = no tile, 0+ = tile index
    if (_index != -1) return true;

    // TR
    _data  = tilemap_get_at_pixel(_tm, _r, _t);
    _index = tile_get_index(_data);
    if (_index != -1) return true;

    // BL
    _data  = tilemap_get_at_pixel(_tm, _l, _b);
    _index = tile_get_index(_data);
    if (_index != -1) return true;

    // BR
    _data  = tilemap_get_at_pixel(_tm, _r, _b);
    _index = tile_get_index(_data);
    if (_index != -1) return true;

    return false;
}

