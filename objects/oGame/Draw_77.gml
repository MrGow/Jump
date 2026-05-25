/// oGame — Post Draw

if (!surface_exists(application_surface)) exit;

var sw = global.GAME_W;
var sh = global.GAME_H;

// Use display size in fullscreen, window size in windowed
var ww = window_get_width();
var wh = window_get_height();

if (window_get_fullscreen()) {
    ww = display_get_width();
    wh = display_get_height();
}

// Integer scale only
var scale = floor(min(ww / sw, wh / sh));
scale = max(1, scale);

var draw_w = sw * scale;
var draw_h = sh * scale;

var draw_x = floor((ww - draw_w) * 0.5);
var draw_y = floor((wh - draw_h) * 0.5);

draw_clear(c_black);

draw_surface_ext(
    application_surface,
    draw_x,
    draw_y,
    scale,
    scale,
    0,
    c_white,
    1
);