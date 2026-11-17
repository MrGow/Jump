/// oDarkSectionController — Clean Up

if (surface_exists(dark_surface))
{
    surface_free(dark_surface);
    dark_surface = -1;
}