/// oCodecTrigger — Create


// ====================================================
// EDITOR VARIABLE SAFETY
// ====================================================

if (!variable_instance_exists(id, "codec_id"))
{
    codec_id = 1;
}


if (!variable_instance_exists(id, "one_shot"))
{
    one_shot = true;
}


if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// STATE
// ====================================================

activated = false;


// ====================================================
// VISIBILITY
//
// Trigger artwork/mask remains available for bbox,
// but isn't drawn during gameplay.
// ====================================================

visible = false;