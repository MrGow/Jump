/// oHoloPlatformController — Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "holo_layer_name"))
{
    holo_layer_name = "HoloTiles";
}

if (!variable_instance_exists(id, "hidden_alpha"))
{
    hidden_alpha = 0;
}

if (!variable_instance_exists(id, "holo_surface"))
{
    holo_surface = -1;
}

if (!variable_instance_exists(id, "holo_surface_needs_redraw"))
{
    holo_surface_needs_redraw = true;
}

if (!variable_instance_exists(id, "snd_holo_disappear"))
{
    snd_holo_disappear =
        asset_get_index("HoloTilesDisappear1");
}

if (!variable_instance_exists(id, "holo_disappear_gain"))
{
    holo_disappear_gain = 1.0;
}

if (!variable_instance_exists(id, "holo_disappear_pitch"))
{
    holo_disappear_pitch = 1.0;
}

if (!variable_instance_exists(id, "holo_disappear_sfx_played"))
{
    holo_disappear_sfx_played = false;
}


// ====================================================
// REACQUIRE TILE LAYER
// ====================================================

if (
    !variable_instance_exists(id, "holo_layer_id") ||
    holo_layer_id == -1
)
{
    holo_layer_id =
        layer_get_id(
            holo_layer_name
        );
}

if (
    !variable_instance_exists(id, "holo_tilemap_id") ||
    holo_tilemap_id == -1
)
{
    if (holo_layer_id != -1)
    {
        holo_tilemap_id =
            layer_tilemap_get_id(
                holo_layer_id
            );

        layer_set_visible(
            holo_layer_id,
            false
        );

        depth =
            layer_get_depth(
                holo_layer_id
            );

        holo_surface_needs_redraw = true;
    }
}


// ====================================================
// PAUSE OUTSIDE ACTIVE GAMEPLAY
// ====================================================

if (!variable_global_exists("game_phase"))
{
    global.game_phase = "playing";
}

if (global.game_phase != "playing")
{
    exit;
}


// ====================================================
// STATE MACHINE
// ====================================================

switch (state)
{
    // ------------------------------------------------
    // Fully visible, waiting for trigger
    // ------------------------------------------------
    case "waiting":
    {
        apply_holo_alpha(1);
    }
    break;


    // ------------------------------------------------
    // Fully visible memorisation period
    // ------------------------------------------------
    case "studying":
    {
        apply_holo_alpha(1);

        study_timer--;

        if (study_timer <= 0)
        {
            begin_holo_fade();
        }
    }
    break;


    // ------------------------------------------------
    // Gradually fade from 1 to hidden_alpha
    // ------------------------------------------------
    case "fading":
    {
        var fade_progress =
            1 -
            (
                fade_timer /
                max(
                    1,
                    fade_frames
                )
            );

        fade_progress =
            clamp(
                fade_progress,
                0,
                1
            );

        // Smoothstep fade curve.
        var smooth_progress =
            fade_progress *
            fade_progress *
            (
                3 -
                2 * fade_progress
            );

        apply_holo_alpha(
            lerp(
                1,
                hidden_alpha,
                smooth_progress
            )
        );

        fade_timer--;

        if (fade_timer <= 0)
        {
            fade_timer = 0;

            state = "hidden";

            apply_holo_alpha(
                hidden_alpha
            );
        }
    }
    break;


    // ------------------------------------------------
    // Remain at final alpha
    // ------------------------------------------------
    case "hidden":
    {
        apply_holo_alpha(
            hidden_alpha
        );
    }
    break;
}