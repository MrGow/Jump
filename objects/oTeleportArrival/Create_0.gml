/// oTeleportArrival — Create


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "arrival_id"))
{
    arrival_id = "A";
}


if (!variable_instance_exists(id, "arrival_offset_x"))
{
    arrival_offset_x = 0;
}

if (!variable_instance_exists(id, "arrival_offset_y"))
{
    arrival_offset_y = 0;
}


if (!variable_instance_exists(id, "arrival_facing"))
{
    arrival_facing = 1;
}


if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// ARRIVAL AUDIO
// ====================================================

if (!variable_instance_exists(id, "arrival_sound_gain"))
{
    arrival_sound_gain = 0.95;
}


snd_teleporter_other_end_appear =
    asset_get_index(
        "TeleporterOtherEndAppear"
    );


// Invisible during gameplay unless debugging.
visible =
    debug_draw;