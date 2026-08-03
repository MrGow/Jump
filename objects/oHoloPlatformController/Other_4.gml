/// oHoloPlatformController — Room Start

holo_layer_id =
    layer_get_id(
        holo_layer_name
    );

holo_tilemap_id = -1;

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
}


// ----------------------------------------------------
// Discard old cached surface
// ----------------------------------------------------

if (surface_exists(holo_surface))
{
    surface_free(holo_surface);
}

holo_surface = -1;

holo_surface_needs_redraw = true;


// ----------------------------------------------------
// Reset sequence
// ----------------------------------------------------

reset_holo_sequence();

if (start_immediately)
{
    start_holo_sequence();
}