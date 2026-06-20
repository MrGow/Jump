/// oAtmosphereController - Create

if (!variable_instance_exists(id, "atmo_sound")) atmo_sound = -1;
if (!variable_instance_exists(id, "atmo_pitch")) atmo_pitch = 1.0;
if (!variable_instance_exists(id, "atmo_gain"))  atmo_gain  = 1.0;

atmo_instance = noone;
atmo_started  = false;

switch (room)
{
    case Scrapyard1:
        atmo_sound = asset_get_index("ScrapyardAtmosphericLoop1");
    break;

    case Factory1:
        atmo_sound = asset_get_index("FactoryAtmosphericLoop1");
    break;

    case CableHell1:
        atmo_sound = asset_get_index("CableHellAtmosphericLoop1");
    break;

    case AdministrativeLayer1:
        atmo_sound = asset_get_index("AdministrativeLayerAtmosphericLoop1");
    break;

    case Train1:
        atmo_sound = asset_get_index("TrainInteriorAtmosphericLoop1");
    break;

    default:
        atmo_sound = -1;
    break;
}

scr_settings_init();

if (!audio_group_is_loaded(audiogroupatmosphere)) {
    audio_group_load(audiogroupatmosphere);
}

show_debug_message("ATMOS ROOM = " + room_get_name(room));
show_debug_message("ATMOS SOUND INDEX = " + string(atmo_sound));