/// oAtmosphereController — Step

// ====================================================
// IDENTIFY CURRENT AREA
// ====================================================

var room_name = room_get_name(room);
var next_area = "";


// ====================================================
// INTRO ROOM
//
// The terminal must remain silent.
// The Scrapyard atmosphere starts only when the
// cinematic flag becomes true.
// ====================================================

if (room == IntroCutsceneRoom)
{
    if (
        variable_global_exists(
            "intro_cinematic_started"
        ) &&
        global.intro_cinematic_started
    )
    {
        next_area = "Scrapyard";
    }
    else
    {
        next_area = "";
    }
}


// ====================================================
// GAMEPLAY ROOMS
// ====================================================

else
{
    if (string_pos("Scrapyard", room_name) == 1)
    {
        next_area = "Scrapyard";
    }
    else if (string_pos("Factory", room_name) == 1)
    {
        next_area = "Factory";
    }
    else if (string_pos("CableHell", room_name) == 1)
    {
        next_area = "CableHell";
    }
    else if (
        string_pos("AdministrativeLayer", room_name) == 1
    )
    {
        next_area = "AdministrativeLayer";
    }
    else if (
        string_pos("TrainExterior", room_name) == 1
    )
    {
        next_area = "TrainExterior";
    }
    else if (string_pos("Train", room_name) == 1)
    {
        next_area = "TrainInterior";
    }
}


// ====================================================
// UNRECOGNISED ROOMS
//
// Preserve the existing atmosphere across transition
// rooms, but never during the intro terminal.
// ====================================================

if (
    next_area == "" &&
    room != IntroCutsceneRoom
)
{
    next_area = atmo_area;
}


// ====================================================
// AREA CHANGE
// ====================================================

if (next_area != atmo_area)
{
    // Stop the old loop only when the area changes.
    if (
        atmo_instance != noone &&
        audio_is_playing(atmo_instance)
    )
    {
        audio_stop_sound(atmo_instance);
    }

    atmo_instance = noone;
    atmo_started = false;

    atmo_area = next_area;

    atmo_sound = -1;
    atmo_gain = 1.0;
    atmo_pitch = 1.0;


    // ------------------------------------------------
    // SELECT AREA ATMOSPHERE
    // ------------------------------------------------

    switch (atmo_area)
    {
        case "Scrapyard":

            atmo_sound =
                asset_get_index(
                    "ScrapyardAtmosphericLoop1"
                );

            atmo_gain = 0.55;

        break;


        case "Factory":

            atmo_sound =
                asset_get_index(
                    "FactoryAtmosphericLoop1"
                );

            atmo_gain = 0.60;

        break;


        case "CableHell":

            atmo_sound =
                asset_get_index(
                    "CableHellAtmosphericLoop1"
                );

            atmo_gain = 0.50;

        break;


        case "AdministrativeLayer":

            atmo_sound =
                asset_get_index(
                    "AdministrativeLayerAtmosphericLoop1"
                );

            atmo_gain = 0.65;

        break;


        case "TrainInterior":

            atmo_sound =
                asset_get_index(
                    "TrainInteriorAtmosphericLoop1"
                );

            atmo_gain = 0.55;

        break;


        case "TrainExterior":

            atmo_sound =
                asset_get_index(
                    "TrainExteriorAtmosphericLoop1"
                );

            atmo_gain = 0.55;

        break;
    }

    show_debug_message(
        "ATMOS AREA = " + atmo_area
    );
}


// ====================================================
// WAIT FOR AUDIO GROUP
// ====================================================

if (!audio_group_is_loaded(audiogroupatmosphere))
{
    exit;
}


// ====================================================
// KEEP EXISTING LOOP RUNNING
//
// Do not restart the sound when moving between
// rooms belonging to the same area.
// ====================================================

if (
    atmo_instance != noone &&
    audio_is_playing(atmo_instance)
)
{
    exit;
}


// ====================================================
// DO NOT PLAY DURING INTRO TERMINAL
// ====================================================

if (
    room == IntroCutsceneRoom &&
    next_area == ""
)
{
    exit;
}


// ====================================================
// NO ATMOSPHERE SELECTED
// ====================================================

if (atmo_sound == -1)
{
    exit;
}


// ====================================================
// START ATMOSPHERE
// ====================================================

scr_settings_apply_audio_gains();

atmo_instance = audio_play_sound(
    atmo_sound,
    -100,
    true
);

audio_sound_gain(
    atmo_instance,
    atmo_gain,
    0
);

audio_sound_pitch(
    atmo_instance,
    atmo_pitch
);

atmo_started = true;

show_debug_message(
    "ATMOS STARTED = " + atmo_area
);