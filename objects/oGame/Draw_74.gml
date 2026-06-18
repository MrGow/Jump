/// oGame — Draw GUI Begin

if (!surface_exists(application_surface)) exit;

gpu_set_texfilter(false);

var bw = display_get_gui_width();
var bh = display_get_gui_height();

if (bc_shader != -1)
{
    shader_set(bc_shader);

    shader_set_uniform_f(bc_u_brightness, global.brightness);
    shader_set_uniform_f(bc_u_contrast, global.contrast);

    draw_surface_stretched(application_surface, 0, 0, bw, bh);

    shader_reset();
}
else
{
    draw_surface_stretched(application_surface, 0, 0, bw, bh);
}