/// oGame — Draw GUI Begin
// Draws the application surface with brightness/contrast
// and overlays the unique death-screen flash.

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
// DRAW APPLICATION SURFACE
// ====================================================

if (bc_shader != -1)
{
    shader_set(bc_shader);

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
//
// scr_player_died() sets:
//     global.death_flash_alpha
//     global.death_flash_colour
//     global.death_flash_fade_speed
//
// This event draws and fades the flash even while the
// rest of the world is frozen during death_delay.
// ====================================================

if (!variable_global_exists("death_flash_alpha"))
{
    global.death_flash_alpha = 0;
}

if (!variable_global_exists("death_flash_colour"))
{
    global.death_flash_colour = c_white;
}

if (!variable_global_exists("death_flash_fade_speed"))
{
    global.death_flash_fade_speed = 0.12;
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
    draw_set_color(c_white);

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