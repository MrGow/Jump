/// oHoloPlatformController — Clean Up


// ====================================================
// FREE CACHED SURFACE
// ====================================================

if (surface_exists(holo_surface))
{
    surface_free(holo_surface);
}

holo_surface = -1;


// ====================================================
// RESTORE NORMAL TILE-LAYER RENDERING
// ====================================================

if (
    variable_instance_exists(
        id,
        "holo_layer_id"
    ) &&
    holo_layer_id != -1
)
{
    layer_set_visible(
        holo_layer_id,
        true
    );
}


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);