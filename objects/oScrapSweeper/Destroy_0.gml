/// oScrapSweeper — Destroy


// ====================================================
// REMOVE PHYSICAL SOLID
// ====================================================

if (instance_exists(solid_inst))
{
    with (solid_inst)
    {
        instance_destroy();
    }
}