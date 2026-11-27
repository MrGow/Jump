/// oGame — End Step

// ====================================================
// DETERMINE WHETHER HIGH-RESOLUTION RENDERING IS NEEDED
// ====================================================

var use_highres = false;

if (boss_highres_enabled)
{
    var ctrl = instance_find(
        oScrapChiefController,
        0
    );

    if (instance_exists(ctrl))
    {
        if (ctrl.camera_override_active)
        {
            if (
                ctrl.boss_active &&
                !ctrl.sequence_complete
            )
            {
                use_highres = true;
            }

            // Maintain high-resolution rendering
            // until the zoom-in has finished.
            if (
                variable_instance_exists(
                    ctrl,
                    "camera_zoom_progress"
                )
            )
            {
                if (ctrl.camera_zoom_progress > 0)
                {
                    use_highres = true;
                }
            }
        }
    }
}


// ====================================================
// ROOM CHANGE SAFETY
// ====================================================

if (
    boss_highres_active &&
    boss_render_room != room
)
{
    boss_highres_active = false;

    global.boss_highres_rendering = false;

    boss_render_room = -1;

    if (surface_exists(application_surface))
    {
        surface_resize(
            application_surface,
            global.GAME_W,
            global.GAME_H
        );
    }
}


// ====================================================
// ENTER HIGH-RESOLUTION MODE
// ====================================================

if (use_highres && !boss_highres_active)
{
    boss_original_port_w = view_wport[0];
    boss_original_port_h = view_hport[0];

    boss_highres_active = true;

    boss_render_room = room;

    global.boss_highres_rendering = true;

    show_debug_message(
        "RENDER: High-resolution boss mode enabled."
    );
}


// ====================================================
// MAINTAIN HIGH-RESOLUTION MODE
// ====================================================

if (use_highres && boss_highres_active)
{
    var render_w =
        global.GAME_W * boss_render_scale;

    var render_h =
        global.GAME_H * boss_render_scale;


    // ------------------------------------------------
    // Rendering viewport
    // ------------------------------------------------

    if (view_wport[0] != render_w)
    {
        view_wport[0] = render_w;
    }

    if (view_hport[0] != render_h)
    {
        view_hport[0] = render_h;
    }


    // ------------------------------------------------
    // Application surface
    // ------------------------------------------------

    if (surface_exists(application_surface))
    {
        if (
            surface_get_width(application_surface)
                != render_w ||
            surface_get_height(application_surface)
                != render_h
        )
        {
            surface_resize(
                application_surface,
                render_w,
                render_h
            );
        }
    }
}


// ====================================================
// RETURN TO NORMAL RENDERING
// ====================================================

else if (boss_highres_active)
{
    boss_highres_active = false;

    global.boss_highres_rendering = false;

    boss_render_room = -1;


    // ------------------------------------------------
    // Restore original viewport
    // ------------------------------------------------

    view_wport[0] = boss_original_port_w;
    view_hport[0] = boss_original_port_h;


    // ------------------------------------------------
    // Restore original application surface
    // ------------------------------------------------

    if (surface_exists(application_surface))
    {
        surface_resize(
            application_surface,
            global.GAME_W,
            global.GAME_H
        );
    }

    show_debug_message(
        "RENDER: Normal pixel-perfect mode restored."
    );
}