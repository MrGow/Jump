/// oRoomTeleportController — Draw GUI

if (fade_alpha > 0)
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    var is_cable_hell = (string_upper(string(area_name)) == "CABLE HELL");

    // Recreate overlay surface if missing/wrong size
    if (!surface_exists(overlay_surface))
    {
        overlay_surface = surface_create(gw, gh);
    }
    else if (surface_get_width(overlay_surface) != gw || surface_get_height(overlay_surface) != gh)
    {
        surface_free(overlay_surface);
        overlay_surface = surface_create(gw, gh);
    }

    surface_set_target(overlay_surface);
    draw_clear_alpha(c_black, 0);

    // Draw black fade onto overlay surface
    draw_set_alpha(fade_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);

    if (show_area_name && area_name != "" && title_alpha > 0)
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        var tx = gw * 0.5;
        var enter_y = gh * 0.5 - 52;
        var area_y  = gh * 0.5 + 18;

        // ----------------------------------------------------
        // Cable Hell only: yellow electric glow around cut-out text
        // ----------------------------------------------------
        if (is_cable_hell)
        {
            var glow_col = make_color_rgb(255, 220, 35);
            var glow_a = title_alpha * fade_alpha;

            draw_set_color(glow_col);

            // Outer glow
            draw_set_alpha(0.16 * glow_a);

            draw_set_font(PIXELOPERATORREGULAR24);
            draw_text(tx - 3, enter_y, "ENTERING");
            draw_text(tx + 3, enter_y, "ENTERING");
            draw_text(tx, enter_y - 3, "ENTERING");
            draw_text(tx, enter_y + 3, "ENTERING");

            draw_set_font(PIXELOPERATORBOLD48);
            draw_text(tx - 4, area_y, area_name);
            draw_text(tx + 4, area_y, area_name);
            draw_text(tx, area_y - 4, area_name);
            draw_text(tx, area_y + 4, area_name);

            // Inner glow
            draw_set_alpha(0.38 * glow_a);

            draw_set_font(PIXELOPERATORREGULAR24);
            draw_text(tx - 1, enter_y, "ENTERING");
            draw_text(tx + 1, enter_y, "ENTERING");
            draw_text(tx, enter_y - 1, "ENTERING");
            draw_text(tx, enter_y + 1, "ENTERING");

            draw_set_font(PIXELOPERATORBOLD48);
            draw_text(tx - 2, area_y, area_name);
            draw_text(tx + 2, area_y, area_name);
            draw_text(tx, area_y - 2, area_name);
            draw_text(tx, area_y + 2, area_name);
        }

        // ----------------------------------------------------
        // Cut area-name text out of the black overlay
        // ----------------------------------------------------
        gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);

        draw_set_alpha(title_alpha);
        draw_set_color(c_white);

        draw_set_font(PIXELOPERATORREGULAR24);
        draw_text(tx, enter_y, "ENTERING");

        draw_set_font(PIXELOPERATORBOLD48);
        draw_text(tx, area_y, area_name);

        gpu_set_blendmode(bm_normal);
    }

    surface_reset_target();

    // Draw final overlay to screen
    draw_set_alpha(1);
    draw_surface(overlay_surface, 0, 0);

    // Reset
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}