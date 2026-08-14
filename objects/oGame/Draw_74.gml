/// oGame — Draw GUI Begin
//
// Draw order:
//
// 1. game surface
// 2. brightness / contrast
// 3. death flash
// 4. teleport vortex
//
// Vortex MUST be last.

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
// TELEPORT VORTEX
// ====================================================

if (
    teleport_vortex_state != "none"
    &&
    teleport_vortex_sprite != -1
    &&
    teleport_vortex_alpha > 0
)
{
    var vortex_frame =
        floor(
            teleport_vortex_frame
        );


    var vortex_count =
        sprite_get_number(
            teleport_vortex_sprite
        );


    if (vortex_count > 0)
    {
        vortex_frame =
            vortex_frame
            mod
            vortex_count;
    }


    // ------------------------------------------------
    // Draw fullscreen
    // ------------------------------------------------

    draw_set_alpha(
        clamp(
            teleport_vortex_alpha,
            0,
            1
        )
    );


    draw_set_color(
        c_white
    );


    draw_sprite_stretched(
        teleport_vortex_sprite,
        vortex_frame,
        0,
        0,
        bw,
        bh
    );


    // ------------------------------------------------
    // Restore
    // ------------------------------------------------

    draw_set_alpha(1);

    draw_set_color(
        c_white
    );
}