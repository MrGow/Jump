/// @func scr_player_meeting_solid(_x, _y)
/// @desc Returns true if the player's bbox hits a non-empty tile
///       on the "Solids" tile layer when the player is at (_x, _y).

function scr_player_meeting_solid(_x, _y)
{
    // Make sure the Solids layer exists
    if (!layer_exists("Solids"))
    {
        return false;
    }

    var _layer_id = layer_get_id("Solids");
    var _tm = layer_tilemap_get_id(_layer_id);

    if (_tm <= 0)
    {
        return false;
    }

    // Offsets of this player's collision bounds from its origin
    var _off_l = bbox_left   - x;
    var _off_r = bbox_right  - x - 1;
    var _off_t = bbox_top    - y;
    var _off_b = bbox_bottom - y - 1;

    // Collision bounds at the requested test position
    var _l = _x + _off_l;
    var _r = _x + _off_r;
    var _t = _y + _off_t;
    var _b = _y + _off_b;

    var _data;

    // Top-left corner
    _data = tilemap_get_at_pixel(
        _tm,
        _l,
        _t
    );

    if (_data != 0)
    {
        return true;
    }

    // Top-right corner
    _data = tilemap_get_at_pixel(
        _tm,
        _r,
        _t
    );

    if (_data != 0)
    {
        return true;
    }

    // Bottom-left corner
    _data = tilemap_get_at_pixel(
        _tm,
        _l,
        _b
    );

    if (_data != 0)
    {
        return true;
    }

    // Bottom-right corner
    _data = tilemap_get_at_pixel(
        _tm,
        _r,
        _b
    );

    if (_data != 0)
    {
        return true;
    }

    return false;
}


/// @func scr_player_respawn_floor_y(_x, _y, [_max_drop])
/// @desc Finds a safe standing Y on the solid tiles below a respawn point.
///       This must be called in the player's instance context so that the
///       player's collision mask is used.
function scr_player_respawn_floor_y(
    _x,
    _y,
    _max_drop = 96
)
{
    var _original_y = _y;
    var _safe_y = _y;

    // If the checkpoint position is accidentally inside a tile,
    // search upward until the player's collision mask is clear.
    var _rise = 0;

    while (
        scr_player_meeting_solid(
            _x,
            _safe_y
        )
        &&
        _rise < _max_drop
    )
    {
        _safe_y--;
        _rise++;
    }

    // If the player could not be moved out of the solid area,
    // retain the original checkpoint position.
    if (
        scr_player_meeting_solid(
            _x,
            _safe_y
        )
    )
    {
        return _original_y;
    }

    // Search downward one pixel at a time.
    //
    // Return the current safe position when moving one additional
    // pixel would place the player inside the floor.
    for (
        var _drop = 0;
        _drop <= _max_drop;
        _drop++
    )
    {
        if (
            scr_player_meeting_solid(
                _x,
                _safe_y + 1
            )
        )
        {
            return _safe_y;
        }

        _safe_y++;
    }

    // No floor was found within the allowed search distance.
    return _original_y;
}