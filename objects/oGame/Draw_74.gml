// ============================================================================
// oGame — Draw GUI Begin
// ============================================================================

/// oGame — Draw GUI Begin
//
// Draw order:
//
// 1. application surface
// 2. brightness / contrast
// 3. death flash
// 4. procedural teleport data transmission
//
// Transmission MUST be last.

if (!surface_exists(application_surface))
{
    exit;
}


gpu_set_texfilter(false);


var bw =
    display_get_gui_width();

var bh =
    display_get_gui_height();


// ====================================================
// APPLICATION SURFACE
// ====================================================

if (bc_shader != -1)
{
    shader_set(
        bc_shader
    );


    shader_set_uniform_f(
        bc_u_brightness,
        global.brightness
    );


    shader_set_uniform_f(
        bc_u_contrast,
        global.contrast
    );


    draw_surface_stretched(
        application_surface,
        0,
        0,
        bw,
        bh
    );


    shader_reset();
}
else
{
    draw_surface_stretched(
        application_surface,
        0,
        0,
        bw,
        bh
    );
}


// ====================================================
// DEATH SCREEN FLASH
// ====================================================

if (!variable_global_exists("death_flash_alpha"))
{
    global.death_flash_alpha =
        0;
}

if (!variable_global_exists("death_flash_colour"))
{
    global.death_flash_colour =
        c_white;
}

if (!variable_global_exists("death_flash_fade_speed"))
{
    global.death_flash_fade_speed =
        0.12;
}


if (global.death_flash_alpha > 0)
{
    draw_set_alpha(
        clamp(
            global.death_flash_alpha,
            0,
            1
        )
    );


    draw_set_color(
        global.death_flash_colour
    );


    draw_rectangle(
        0,
        0,
        bw,
        bh,
        false
    );


    draw_set_alpha(1);

    draw_set_color(
        c_white
    );


    global.death_flash_alpha =
        max(
            0,
            global.death_flash_alpha
            -
            max(
                0.001,
                global.death_flash_fade_speed
            )
        );
}


// ====================================================
// TELEPORT DATA TRANSMISSION
// ====================================================

if (
    teleport_static_state != "none"
    &&
    teleport_static_progress > 0
)
{
    var p =
        clamp(
            teleport_static_progress,
            0,
            1
        );


    var phase =
        teleport_static_phase;


    // =================================================
    // HASH HELPER
    //
    // Deterministic pseudo-random value from 0..1.
    // Does NOT touch GameMaker's random seed.
    // =================================================

    var __static_hash = function(_a, _b, _c)
    {
        return frac(
            abs(
                sin(
                    (_a * 12.9898)
                    +
                    (_b * 78.233)
                    +
                    (_c * 37.719)
                )
                *
                43758.5453
            )
        );
    };


    // =================================================
// BASE TRANSMISSION FIELD
//
// IMPORTANT:
// Do not cover the whole screen early.
//
// First we let individual corruption blocks build.
// The solid transmission field only begins appearing
// once the screen is already heavily corrupted.
// =================================================

var base_field_t =
    clamp(
        (p - 0.68)
        /
        0.32,
        0,
        1
    );

if (base_field_t > 0)
{
    draw_set_alpha(
        base_field_t * 0.88
    );

    draw_set_color(
        teleport_static_col_deep
    );

    draw_rectangle(
        0,
        0,
        bw,
        bh,
        false
    );
}


    // =================================================
    // LARGE DIGITAL BLOCKS
    //
    // These create the big mosaic/data-breakup shapes.
    // Coverage increases with transition progress.
    // =================================================

    var cw =
        max(
            4,
            round(
                teleport_static_coarse_w
            )
        );


    var ch =
        max(
            4,
            round(
                teleport_static_coarse_h
            )
        );


    var cols =
        ceil(
            bw / cw
        );


    var rows =
        ceil(
            bh / ch
        );


    var coarse_threshold =
        lerp(
            0.08,
            0.92,
            p
        );


    for (var gy = 0; gy < rows; gy++)
    {
        for (var gx = 0; gx < cols; gx++)
        {
            var h0 =
                __static_hash(
                    gx,
                    gy,
                    phase
                );


            if (h0 > coarse_threshold)
            {
                continue;
            }


            var h1 =
                __static_hash(
                    gx + 71,
                    gy + 19,
                    phase + 3
                );


            var col =
                teleport_static_col_blue;


            if (h1 < 0.18)
            {
                col =
                    teleport_static_col_deep;
            }
            else if (h1 < 0.48)
            {
                col =
                    teleport_static_col_blue;
            }
            else if (h1 < 0.76)
            {
                col =
                    teleport_static_col_cyan;
            }
            else if (h1 < 0.93)
            {
                col =
                    teleport_static_col_pale;
            }
            else
            {
                col =
                    teleport_static_col_white;
            }


            // Give blocks slight width/height corruption.
            var h2 =
                __static_hash(
                    gx + 5,
                    gy + 113,
                    phase + 8
                );


            var block_w =
                cw;


            var block_h =
                ch;


            if (h2 > 0.82)
            {
                block_w =
                    min(
                        bw - (gx * cw),
                        cw * 2
                    );
            }


            if (h2 < 0.12)
            {
                block_h =
                    max(
                        2,
                        floor(
                            ch * 0.45
                        )
                    );
            }


            draw_set_alpha(
                clamp(
                    0.28
                    +
                    (p * 0.62)
                    +
                    (h1 * 0.10),
                    0,
                    1
                )
            );


            draw_set_color(
                col
            );


            draw_rectangle(
                gx * cw,
                gy * ch,
                min(
                    bw,
                    (gx * cw)
                    +
                    block_w
                ),
                min(
                    bh,
                    (gy * ch)
                    +
                    block_h
                ),
                false
            );
        }
    }


    // =================================================
    // FINE DATA FRAGMENTS
    //
    // Smaller cyan/white pixels that make it feel like
    // transmission noise rather than a simple mosaic.
    // =================================================

    var fw =
        max(
            2,
            round(
                teleport_static_fine_w
            )
        );


    var fh =
        max(
            2,
            round(
                teleport_static_fine_h
            )
        );


    var fcols =
        ceil(
            bw / fw
        );


    var frows =
        ceil(
            bh / fh
        );


    var fine_threshold =
        clamp(
            teleport_static_fine_density
            *
            (
                0.30
                +
                (p * 0.70)
            ),
            0,
            1
        );


    for (var fy = 0; fy < frows; fy++)
    {
        for (var fx = 0; fx < fcols; fx++)
        {
            var hf =
                __static_hash(
                    fx + 221,
                    fy + 337,
                    phase + 17
                );


            if (hf > fine_threshold)
            {
                continue;
            }


            var hc =
                __static_hash(
                    fx + 29,
                    fy + 61,
                    phase + 23
                );


            var fcol =
                teleport_static_col_cyan;


            if (hc < 0.58)
            {
                fcol =
                    teleport_static_col_cyan;
            }
            else if (hc < 0.83)
            {
                fcol =
                    teleport_static_col_pale;
            }
            else
            {
                fcol =
                    teleport_static_col_white;
            }


            draw_set_alpha(
                clamp(
                    p
                    *
                    lerp(
                        0.35,
                        0.95,
                        hc
                    ),
                    0,
                    1
                )
            );


            draw_set_color(
                fcol
            );


            // Most are tiny squares.
            // A few become short horizontal data dashes.
            var dash =
                __static_hash(
                    fx + 401,
                    fy + 103,
                    phase + 41
                );


            var fwidth =
                fw;


            if (dash > 0.92)
            {
                fwidth =
                    fw * 3;
            }
            else if (dash > 0.80)
            {
                fwidth =
                    fw * 2;
            }


            draw_rectangle(
                fx * fw,
                fy * fh,
                min(
                    bw,
                    (fx * fw)
                    +
                    fwidth
                ),
                min(
                    bh,
                    (fy * fh)
                    +
                    fh
                ),
                false
            );
        }
    }


    // =================================================
    // HORIZONTAL ANALOG TEAR BANDS
    //
    // A few unstable transmission strips that jump
    // around whenever the static phase refreshes.
    // =================================================

    for (var band = 0; band < 7; band++)
    {
        var hb0 =
            __static_hash(
                band + 17,
                phase + 53,
                91
            );


        var hb1 =
            __static_hash(
                band + 83,
                phase + 11,
                137
            );


        var by =
            floor(
                hb0 * bh
            );


        var band_h =
            1
            +
            floor(
                hb1 * 6
            );


        var band_col =
            hb1 > 0.82
            ? teleport_static_col_white
            : teleport_static_col_cyan;


        draw_set_alpha(
            p
            *
            lerp(
                0.10,
                0.38,
                hb1
            )
        );


        draw_set_color(
            band_col
        );


        draw_rectangle(
            0,
            by,
            bw,
            min(
                bh,
                by + band_h
            ),
            false
        );
    }


    // =================================================
    // ANALOG SCANLINES
    // =================================================

    var scan_gap =
        max(
            2,
            round(
                teleport_static_scanline_gap
            )
        );


    draw_set_alpha(
        p * 0.10
    );


    draw_set_color(
        teleport_static_col_white
    );


    for (
        var sy = phase mod scan_gap;
        sy < bh;
        sy += scan_gap
    )
    {
        draw_line(
            0,
            sy,
            bw,
            sy
        );
    }


    // =================================================
    // FULL-TRANSMISSION CYAN/WHITE VEIL
    //
    // At high progress this gives the transition the
    // bright teleporter-energy wash from the Area 4 FX.
    // =================================================

    var veil =
        clamp(
            (p - 0.72)
            /
            0.28,
            0,
            1
        );


    if (veil > 0)
    {
        draw_set_alpha(
            veil * 0.30
        );


        draw_set_color(
            teleport_static_col_pale
        );


        draw_rectangle(
            0,
            0,
            bw,
            bh,
            false
        );
    }


    // =================================================
    // ROOM-SWAP WHITE PULSE
    // =================================================

    if (teleport_static_flash_alpha > 0)
    {
        draw_set_alpha(
            clamp(
                teleport_static_flash_alpha,
                0,
                1
            )
        );


        draw_set_color(
            teleport_static_col_white
        );


        draw_rectangle(
            0,
            0,
            bw,
            bh,
            false
        );
    }


    // =================================================
    // RESTORE DRAW STATE
    // =================================================

    draw_set_alpha(1);

    draw_set_color(
        c_white
    );
}