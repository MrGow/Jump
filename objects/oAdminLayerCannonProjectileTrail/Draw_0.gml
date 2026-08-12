/// oAdminLayerCannonProjectileTrail — Draw


// ====================================================
// LIFE / FADE
// ====================================================

var life_t =
    clamp(
        life_timer /
        max(1, life_total),
        0,
        1
    );


// ====================================================
// SIZE
//
// Starts as a small bright energy speck,
// then shrinks as it disappears.
// ====================================================

var draw_scale =
    lerp(
        0.35,
        1.0,
        life_t
    );

var radius =
    trail_radius *
    draw_scale;


// ====================================================
// SOFT OUTER GLOW
// ====================================================

draw_set_alpha(
    life_t * 0.30
);

draw_set_color(
    trail_colour
);

draw_circle(
    x,
    y,
    radius * 1.8,
    false
);


// ====================================================
// BRIGHT ENERGY DOT
// ====================================================

draw_set_alpha(
    life_t * 0.9
);

draw_set_color(
    trail_colour
);

draw_circle(
    x,
    y,
    radius,
    false
);


// ====================================================
// WHITE HOT CENTRE
// ====================================================

draw_set_alpha(
    life_t
);

draw_set_color(
    c_white
);

draw_circle(
    x,
    y,
    max(
        0.4,
        radius * 0.35
    ),
    false
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);