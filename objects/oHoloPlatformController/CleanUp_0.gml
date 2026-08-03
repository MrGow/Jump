/// oHoloPlatformController — Clean Up

// ----------------------------------------------------
// Free cached surface
// ----------------------------------------------------

if (surface_exists(holo_surface))
{
    surface_free(holo_surface);
}

holo_surface = -1;


// ----------------------------------------------------
// Restore normal tile-layer rendering if the controller
// is removed while the room is still active.
// ----------------------------------------------------

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

draw_set_alpha(1);
draw_set_color(c_white);