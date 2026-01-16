/// oCamZone - Create (stable bounds; optional snap)

// --- OPTIONAL snapping (OFF by default because it moves your placed rectangles) ---
if (!variable_instance_exists(id, "snap_enable")) snap_enable = false;

// Choose snap mode if enabled
if (!variable_instance_exists(id, "snap_to_tile")) snap_to_tile = true;
if (!variable_instance_exists(id, "snap_to_view")) snap_to_view = false;

// Grid sizes
if (!variable_instance_exists(id, "tile_w")) tile_w = 32;
if (!variable_instance_exists(id, "tile_h")) tile_h = 32;
if (!variable_instance_exists(id, "view_w")) view_w = 640;
if (!variable_instance_exists(id, "view_h")) view_h = 360;

// Rect placeholders
left   = 0;
top    = 0;
right  = 0;
bottom = 0;

// ------------------------------------------------------------
// Recompute world-space rect using sprite origin/scale
// ------------------------------------------------------------
update_rect = function() {
    var spr = sprite_index;

    var sw = (spr != -1) ? sprite_get_width(spr)  : view_w;
    var sh = (spr != -1) ? sprite_get_height(spr) : view_h;

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
// OPTIONAL snap: adjusts x/y & scale so rect aligns to grid
// ------------------------------------------------------------
snap_transform = function() {

    var spr = sprite_index;

    var sw = (spr != -1) ? sprite_get_width(spr)  : view_w;
    var sh = (spr != -1) ? sprite_get_height(spr) : view_h;

    var xo = (spr != -1) ? sprite_get_xoffset(spr) : 0;
    var yo = (spr != -1) ? sprite_get_yoffset(spr) : 0;

    // Work from rect first
    update_rect();

    var gx = snap_to_view ? view_w : tile_w;
    var gy = snap_to_view ? view_h : tile_h;

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

// Init rect immediately
update_rect();
