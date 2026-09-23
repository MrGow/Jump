/// oScrapSweeper — Draw


if (!enabled)
{
    exit;
}


// ====================================================
// DRAW SETTINGS
// ====================================================

var _flip =
    facing;


// ====================================================
// 1. BASE BACK
//
// Rear layer of the wall mounting.
// ====================================================

draw_sprite_ext(
    spriteScrapSweepBaseBack,
    0,
    x +
    facing *
    offset_base_back,
    y,
    _flip,
    1,
    0,
    c_white,
    1
);


// ====================================================
// 2. FIRST POLE BASE
//
// Drawn before BaseFront so the pole appears to emerge
// from inside the wall mounting.
// ====================================================

draw_sprite_ext(
    spriteScrapSweepFirstPoleBase,
    0,
    x +
    facing *
    offset_first_base,
    y,
    _flip,
    1,
    0,
    c_white,
    1
);


// ====================================================
// 3. FIRST / THICK POLE
// ====================================================

draw_sprite_ext(
    spriteScrapSweepFirstPoleMid,
    0,
    x +
    facing *
    offset_first_mid,
    y,
    _flip,
    1,
    0,
    c_white,
    1
);


// ====================================================
// 4. CENTRAL COLLAR
// ====================================================

draw_sprite_ext(
    spriteScrapSweepFirstPoleEnd,
    0,
    x +
    facing *
    offset_first_end,
    y,
    _flip,
    1,
    0,
    c_white,
    1
);


// ====================================================
// 5. REPEATABLE SECOND / THIN POLE
//
// second_pole_repeats controls the total extension.
// ====================================================

for (
    var i = 0;
    i < second_pole_repeats;
    i++
)
{
    var _repeat_offset =
        offset_second_start
        +
        second_mid_width * 0.5
        +
        i *
        second_mid_width;

    draw_sprite_ext(
        spriteScrapSweepSecondPoleMid,
        0,
        x +
        facing *
        _repeat_offset,
        y,
        _flip,
        1,
        0,
        c_white,
        1
    );
}


// ====================================================
// 6. SPIKES
//
// Attach directly to the end of the second pole.
// ====================================================

var _spike_cx =
    x +
    facing *
    offset_spikes;

draw_sprite_ext(
    spriteScrapSweepSpikes,
    0,
    _spike_cx,
    y,
    _flip,
    1,
    0,
    c_white,
    1
);


// ====================================================
// 7. BASE FRONT
//
// SAME POSITION as BaseBack.
//
// Drawn after the pole so it covers the connection and
// completes the wall-mounted base.
// ====================================================

draw_sprite_ext(
    spriteScrapSweepBaseFront,
    0,
    x +
    facing *
    offset_base_front,
    y,
    _flip,
    1,
    0,
    c_white,
    1
);


// ====================================================
// DEBUG
// ====================================================

if (debug_draw)
{
    // ------------------------------------------------
    // SOLID BODY
    // ------------------------------------------------

    var _body_left;
    var _body_right;

    if (facing > 0)
    {
        _body_left =
            x +
            body_start_offset;

        _body_right =
            x +
            body_end_offset;
    }
    else
    {
        _body_left =
            x -
            body_end_offset;

        _body_right =
            x -
            body_start_offset;
    }

    var _body_top =
        y -
        pole_height * 0.5;

    var _body_bottom =
        y +
        pole_height * 0.5;


    draw_set_alpha(
        0.20
    );

    draw_set_color(
        c_lime
    );

    draw_rectangle(
        _body_left,
        _body_top,
        _body_right,
        _body_bottom,
        false
    );


    // ------------------------------------------------
    // LETHAL SPIKES
    // ------------------------------------------------

    var _spike_left =
        _spike_cx -
        spike_width * 0.5 +
        spike_hitbox_inset_x;

    var _spike_right =
        _spike_cx +
        spike_width * 0.5 -
        spike_hitbox_inset_x;

    var _spike_top =
        y -
        spike_height * 0.5 +
        spike_hitbox_inset_y;

    var _spike_bottom =
        y +
        spike_height * 0.5 -
        spike_hitbox_inset_y;


    draw_set_color(
        c_red
    );

    draw_rectangle(
        _spike_left,
        _spike_top,
        _spike_right,
        _spike_bottom,
        false
    );


    // ------------------------------------------------
    // WALL ANCHOR
    // ------------------------------------------------

    draw_set_alpha(1);

    draw_set_color(
        c_yellow
    );

    draw_circle(
        x,
        y,
        3,
        false
    );


    // ------------------------------------------------
    // DEBUG TEXT
    // ------------------------------------------------

    draw_set_color(
        c_white
    );

    draw_text(
        x - 24,
        y - 58,
        "REPEATS: "
        +
        string(
            second_pole_repeats
        )
    );
}