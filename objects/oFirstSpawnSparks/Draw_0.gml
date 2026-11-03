
/// oFirstSpawnSparks — Draw

if (!effect_started)
    exit;

// ====================================================
// DRAW PARTICLES
// ====================================================

for (var i = 0; i < array_length(sparks); i++)
{
    var s = sparks[i];

    var life_ratio = clamp(
        s.life / max(1, s.max_life),
        0,
        1
    );

    // Keep particles solid for most of their life,
    // then fade rapidly near the end.
    var alpha = clamp(life_ratio * 3, 0, 1);

    draw_set_alpha(alpha);
    draw_set_color(s.colour);

    var sx = round(s.x);
    var sy = round(s.y);

    // Tiny pixel particle.
    draw_rectangle(
        sx,
        sy,
        sx + s.size - 1,
        sy + s.size - 1,
        false
    );
}

// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);
