/// oIntroCutsceneController — Clean Up


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
