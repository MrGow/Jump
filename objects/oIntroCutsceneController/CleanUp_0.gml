/// oIntroCutsceneController — Clean Up


// ====================================================
// SIGNAL-LOSS STATIC
// ====================================================

if (signal_static_voice != -1)
{
    audio_stop_sound(
        signal_static_voice
    );

    signal_static_voice = -1;
}


// ====================================================
// BRAND SURFACES
// ====================================================

if (surface_exists(father_brand_surface))
{
    surface_free(
        father_brand_surface
    );
}

father_brand_surface =
    -1;


if (surface_exists(mother_brand_surface))
{
    surface_free(
        mother_brand_surface
    );
}

mother_brand_surface =
    -1;
