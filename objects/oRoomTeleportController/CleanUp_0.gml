/// oRoomTeleportController — Clean Up

if (surface_exists(overlay_surface)) {
    surface_free(overlay_surface);
}