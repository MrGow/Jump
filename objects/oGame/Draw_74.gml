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
// OUTLINED TELEPORT DATA TRANSMISSION
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

    var outline =
        max(
            1,
            round(
                teleport_static_outline_px
            )
        );


    // =================================================
    // DETERMINISTIC HASH
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
    // SLOW EARLY BUILD CURVES
    // =================================================

    var coarse_progress =
        power(
            p,
            max(
                1,
                teleport_static_coarse_curve
            )
        );

    var fine_progress =
        power(
            p,
            max(
                1,
                teleport_static_fine_curve
            )
        );


    // =================================================
    // LATE FULL-SCREEN FIELD
    //
    // IMPORTANT:
    // There is NO full-screen blue veil at the start.
    // You first see individual outlined blocks.
    // The field only closes the remaining gaps late.
    // =================================================

    var base_start =
        clamp(
            teleport_static_base_start,
            0,
            0.99
        );

    var base_field_t =
        clamp(
            (p - base_start)
            /
            max(
                0.001,
                1 - base_start
            ),
            0,
            1
        );

    if (base_field_t > 0)
    {
        draw_set_alpha(
            base_field_t
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
    // LARGE OUTLINED DATA BLOCKS
    // =================================================

    var cw =
        max(
            8,
            round(
                teleport_static_coarse_w
            )
        );

    var ch =
        max(
            8,
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

    // Very sparse at the beginning.
    var coarse_threshold =
        lerp(
            0.012,
            0.97,
            coarse_progress
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

            var h2 =
                __static_hash(
                    gx + 5,
                    gy + 113,
                    phase + 8
                );

            var h3 =
                __static_hash(
                    gx + 149,
                    gy + 47,
                    phase + 21
                );


            // -----------------------------------------
            // Colour
            // -----------------------------------------

            var col =
                teleport_static_col_blue;

            if (h1 < 0.14)
            {
                col =
                    teleport_static_col_deep;
            }
            else if (h1 < 0.43)
            {
                col =
                    teleport_static_col_blue;
            }
            else if (h1 < 0.73)
            {
                col =
                    teleport_static_col_cyan;
            }
            else if (h1 < 0.92)
            {
                col =
                    teleport_static_col_pale;
            }
            else
            {
                col =
                    teleport_static_col_white;
            }


            // -----------------------------------------
            // Shape variation
            // -----------------------------------------

            var block_w =
                cw;

            var block_h =
                ch;

            if (h2 > 0.90)
            {
                block_w =
                    cw * 3;
            }
            else if (h2 > 0.72)
            {
                block_w =
                    cw * 2;
            }

            if (h3 > 0.88)
            {
                block_h =
                    ch * 2;
            }
            else if (h3 < 0.12)
            {
                block_h =
                    max(
                        7,
                        floor(
                            ch * 0.55
                        )
                    );
            }


            var bx1 =
                gx * cw;

            var by1 =
                gy * ch;

            var bx2 =
                min(
                    bw,
                    bx1 + block_w
                );

            var by2 =
                min(
                    bh,
                    by1 + block_h
                );


            var block_alpha =
                clamp(
                    0.72
                    +
                    (p * 0.28),
                    0,
                    1
                );


            // =========================================
            // BLACK OUTLINE
            // =========================================

            draw_set_alpha(
                block_alpha
            );

            draw_set_color(
                c_black
            );

            draw_rectangle(
                bx1,
                by1,
                bx2,
                by2,
                false
            );


            // =========================================
            // COLOURED INTERIOR
            // =========================================

            var ix1 =
                bx1 + outline;

            var iy1 =
                by1 + outline;

            var ix2 =
                bx2 - outline;

            var iy2 =
                by2 - outline;

            if (
                ix2 > ix1
                &&
                iy2 > iy1
            )
            {
                draw_set_color(
                    col
                );

                draw_rectangle(
                    ix1,
                    iy1,
                    ix2,
                    iy2,
                    false
                );
            }
        }
    }


    // =================================================
    // SMALL OUTLINED DATA FRAGMENTS
    // =================================================

    var fw =
        max(
            5,
            round(
                teleport_static_fine_w
            )
        );

    var fh =
        max(
            5,
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

    // Starts effectively at zero.
    var fine_threshold =
        clamp(
            teleport_static_fine_density
            *
            fine_progress,
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

            var hd =
                __static_hash(
                    fx + 401,
                    fy + 103,
                    phase + 41
                );

            var fcol =
                teleport_static_col_cyan;

            if (hc < 0.52)
            {
                fcol =
                    teleport_static_col_cyan;
            }
            else if (hc < 0.82)
            {
                fcol =
                    teleport_static_col_pale;
            }
            else
            {
                fcol =
                    teleport_static_col_white;
            }


            var frag_w =
                fw;

            if (hd > 0.94)
            {
                frag_w =
                    fw * 3;
            }
            else if (hd > 0.84)
            {
                frag_w =
                    fw * 2;
            }


            var fx1 =
                fx * fw;

            var fy1 =
                fy * fh;

            var fx2 =
                min(
                    bw,
                    fx1 + frag_w
                );

            var fy2 =
                min(
                    bh,
                    fy1 + fh
                );


            var frag_alpha =
                clamp(
                    0.52
                    +
                    (p * 0.48),
                    0,
                    1
                );


            // -----------------------------------------
            // Black outline
            // -----------------------------------------

            draw_set_alpha(
                frag_alpha
            );

            draw_set_color(
                c_black
            );

            draw_rectangle(
                fx1,
                fy1,
                fx2,
                fy2,
                false
            );


            // -----------------------------------------
            // Coloured interior
            // -----------------------------------------

            var fix1 =
                fx1 + outline;

            var fiy1 =
                fy1 + outline;

            var fix2 =
                fx2 - outline;

            var fiy2 =
                fy2 - outline;

            if (
                fix2 > fix1
                &&
                fiy2 > fiy1
            )
            {
                draw_set_color(
                    fcol
                );

                draw_rectangle(
                    fix1,
                    fiy1,
                    fix2,
                    fiy2,
                    false
                );
            }
        }
    }


    // =================================================
    // OUTLINED ANALOG TEAR BANDS
    //
    // Delayed so the opening still reads as separate
    // squares and data packets.
    // =================================================

    var band_progress =
        power(
            p,
            1.65
        );

    for (var band = 0; band < 5; band++)
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

        if (hb1 > band_progress)
        {
            continue;
        }

        var by =
            floor(
                hb0 * bh
            );

        var band_h =
            4
            +
            floor(
                hb1 * 7
            );

        var band_w =
            lerp(
                bw * 0.28,
                bw,
                hb1
            );

        var band_x =
            floor(
                __static_hash(
                    band + 201,
                    phase + 9,
                    61
                )
                *
                max(
                    0,
                    bw - band_w
                )
            );

        var band_col =
            hb1 > 0.82
            ? teleport_static_col_white
            : teleport_static_col_cyan;


        draw_set_alpha(
            clamp(
                0.40
                +
                (p * 0.45),
                0,
                0.85
            )
        );


        // Outline
        draw_set_color(
            c_black
        );

        draw_rectangle(
            band_x,
            by,
            min(
                bw,
                band_x + band_w
            ),
            min(
                bh,
                by + band_h
            ),
            false
        );


        // Interior
        var band_ix1 =
            band_x + outline;

        var band_iy1 =
            by + outline;

        var band_ix2 =
            min(
                bw,
                band_x + band_w
            )
            - outline;

        var band_iy2 =
            min(
                bh,
                by + band_h
            )
            - outline;

        if (
            band_ix2 > band_ix1
            &&
            band_iy2 > band_iy1
        )
        {
            draw_set_color(
                band_col
            );

            draw_rectangle(
                band_ix1,
                band_iy1,
                band_ix2,
                band_iy2,
                false
            );
        }
    }


    // =================================================
    // SUBTLE ANALOG SCANLINES
    // =================================================

    var scan_gap =
        max(
            2,
            round(
                teleport_static_scanline_gap
            )
        );

    draw_set_alpha(
        power(
            p,
            1.7
        )
        *
        0.08
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
    // VERY LATE CYAN/WHITE ENERGY VEIL
    // =================================================

    var veil =
        clamp(
            (p - 0.90)
            /
            0.10,
            0,
            1
        );

    if (veil > 0)
    {
        draw_set_alpha(
            veil * 0.23
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
    // ROOM-SWAP WHITE DATA PULSE
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