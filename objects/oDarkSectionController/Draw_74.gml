/// oDarkSectionController — Draw GUI Begin

// ====================================================
// GET ACTIVE CAMERA
// ====================================================

var cam = view_camera[0];

if (cam == -1)
{
    exit;
}

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);


// ====================================================
// SURFACE MANAGEMENT
// ====================================================

if (surface_exists(dark_surface))
{
    if (
        surface_get_width(dark_surface) != cam_w
        ||
        surface_get_height(dark_surface) != cam_h
    )
    {
        surface_free(dark_surface);
        dark_surface = -1;
    }
}

if (!surface_exists(dark_surface))
{
    dark_surface = surface_create(cam_w, cam_h);
}

if (!surface_exists(dark_surface))
{
    exit;
}


// ====================================================
// DRAW DARKNESS TO SURFACE
// ====================================================

surface_set_target(dark_surface);

// Fill with nearly opaque black
draw_clear_alpha(
    darkness_colour,
    darkness_alpha
);


// ====================================================
// CUT OUT GHOST BOT LIGHT
// ====================================================

// Subtract light alpha from darkness alpha
gpu_set_blendmode_ext(
    bm_zero,
    bm_inv_src_alpha
);

draw_set_color(c_white);

// Draw each Ghost Bot's light
with (oGhostBot)
{
    if (light_enabled)
    {
        // Convert room position to camera position
        var lx = x - cam_x;
        var ly = y - cam_y;

        // Current pulsing radius
        var radius = light_visual_radius;

        // Inner radius remains fully illuminated
        var inner_radius =
            max(0, radius - light_softness);

        // ====================================================
        // SOFT OUTER EDGE
        // ====================================================

        // Draw outer rings first.
        // Each ring removes progressively more darkness
        // as we move toward the centre.

        var ring_count = 16;

        for (var i = 0; i < ring_count; i++)
        {
            var t = i / ring_count;

            // Outer to inner
            var ring_radius =
                radius
                - t * light_softness;

            // Increasing opacity toward centre
            var ring_alpha =
                0.04 + t * 0.20;

            draw_set_alpha(ring_alpha);

            draw_circle(
                lx,
                ly,
                ring_radius,
                false
            );
        }

        // ====================================================
        // FULLY ILLUMINATED CENTRE
        // ====================================================

        draw_set_alpha(1);

        draw_circle(
            lx,
            ly,
            inner_radius,
            false
        );
    }
}


// ====================================================
// RESTORE DRAWING STATE
// ====================================================

gpu_set_blendmode(bm_normal);

draw_set_alpha(1);
draw_set_color(c_white);

surface_reset_target();


// ====================================================
// APPLY DARKNESS OVER CAMERA
// ====================================================

draw_surface_stretched(
    dark_surface,
    0,
    0,
    display_get_gui_width(),
    display_get_gui_height()
);