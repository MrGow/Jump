/// oCamZone - Create (JumpBot: tile-snap only, NEVER view-snap)

if (!variable_instance_exists(id, "zone_name")) zone_name = "";

// JumpBot: zones should NEVER snap to view screens
snap_to_tile = true;

// Grid sizes
tile_w = 32; tile_h = 32;

// Rect placeholders
left   = 0;
top    = 0;
right  = 0;
bottom = 0;

// ------------------------------------------------------------
// Helper: recompute world-space rect using sprite origin/scale
// ------------------------------------------------------------
update_rect = function() {
    var spr = sprite_index;

    var sw = (spr != -1) ? sprite_get_width(spr)  : 640;
    var sh = (spr != -1) ? sprite_get_height(spr) : 360;

    var xo = (spr != -1) ? sprite_get_xoffset(spr) : 0;
    var yo = (spr != -1) ? sprite_get_yoffset(spr) : 0;

    var sx = image_xscale;
    var sy = image_yscale;

    var l = x - xo * sx;
    var t = y - yo * sy;
    var r = l + sw * sx;
    var b = t + sh * sy;

    left   = round(min(l, r));
    right  = round(max(l, r));
    top    = round(min(t, b));
    bottom = round(max(t, b));
};

// ------------------------------------------------------------
// Helper: snap the ZONE RECT to tile grid, origin-safe
// ------------------------------------------------------------
snap_transform = function() {

    var spr = sprite_index;

    var sw = (spr != -1) ? sprite_get_width(spr)  : 640;
    var sh = (spr != -1) ? sprite_get_height(spr) : 360;

    var xo = (spr != -1) ? sprite_get_xoffset(spr) : 0;
    var yo = (spr != -1) ? sprite_get_yoffset(spr) : 0;

    update_rect();

    var gx = tile_w;
    var gy = tile_h;

    var cur_w = right - left;
    var cur_h = bottom - top;

    var snap_l = floor(left / gx) * gx;
    var snap_t = floor(top  / gy) * gy;

    var snap_w = max(gx, round(cur_w / gx) * gx);
    var snap_h = max(gy, round(cur_h / gy) * gy);

    image_xscale = abs(snap_w / sw);
    image_yscale = abs(snap_h / sh);

    x = snap_l + xo * image_xscale;
    y = snap_t + yo * image_yscale;

    update_rect();
};

// Make sure rect is valid immediately
update_rect();
