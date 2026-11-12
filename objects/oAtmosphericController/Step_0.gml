/// oAtmosphericController — Step

// ====================================================
// IDENTIFY CURRENT AREA
// ====================================================

var room_name = room_get_name(room);
var next_area = "";

// ====================================================
// MAIN MENU — NO GAMEPLAY ATMOSPHERE
// ====================================================

if (room == MainMenuBackground)
{
    if (atmo_instance != noone)
    {
        if (audio_is_playing(atmo_instance))
        {
            audio_stop_sound(atmo_instance);
        }
    }

    atmo_instance = noone;
    atmo_started = false;
    atmo_area = "";
    atmo_sound = -1;

    exit;
}

// ====================================================
// MAIN MENU
//
// Never allow gameplay atmosphere to continue
// playing underneath the main menu music.
// ====================================================

if (room == MainMenu)
{
    if (
        atmo_instance != noone &&
        audio_is_playing(atmo_instance)
    )
    {
        audio_stop_sound(atmo_instance);
    }

    atmo_instance = noone;
    atmo_started = false;

    atmo_area = "";
    atmo_sound = -1;

    exit;
}


// ====================================================
// INTRO ROOM
//
// The terminal remains silent until the intro
// cinematic begins.
//
// Once started, the Scrapyard atmosphere plays
// continuously through the intro and Scrapyard.
// ====================================================

if (room == IntroCutsceneRoom)
{
    if (
        variable_global_exists("intro_cinematic_started") &&
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
//
// Identify the area from the room name.
//
// The original prefix checks are retained,
// but room names containing the area name
// elsewhere are now supported too.
// ====================================================

else
{
    if (string_pos("Scrapyard", room_name) > 0)
    {
        next_area = "Scrapyard";
    }
    else if (string_pos("Factory", room_name) > 0)
    {
        next_area = "Factory";
    }
    else if (string_pos("CableHell", room_name) > 0)
    {
        next_area = "CableHell";
    }
    else if (
        string_pos("AdministrativeLayer", room_name) > 0
    )
    {
        next_area = "AdministrativeLayer";
    }
    else if (
        string_pos("TrainExterior", room_name) > 0
    )
    {
        next_area = "TrainExterior";
    }
    else if (
        string_pos("TrainInterior", room_name) > 0
    )
    {
        next_area = "TrainInterior";
    }
    else if (string_pos("Train", room_name) > 0)
    {
        next_area = "TrainInterior";
    }
}


// ====================================================
// UNRECOGNISED ROOMS
//
// Preserve atmosphere across transition rooms.
//
// MainMenuRoom is handled separately above.
// The intro terminal must remain silent.
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
    // Stop the previous area's atmosphere.

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


    // =================================================
    // SELECT AREA ATMOSPHERE
    // =================================================

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
        "ATMOS AREA = " + atmo_area +
        " | ROOM = " + room_name +
        " | SOUND = " + string(atmo_sound)
    );
}


// ====================================================
// AUDIO GROUP RECOVERY
//
// If another system unloaded the atmosphere
// audio group, request it again.
// ====================================================

if (!audio_group_is_loaded(audiogroupatmosphere))
{
    audio_group_load(audiogroupatmosphere);
    exit;
}


// ====================================================
// KEEP EXISTING LOOP RUNNING
//
// Do not restart when travelling between rooms
// belonging to the same area.
// ====================================================

if (
    atmo_instance != noone &&
    audio_is_playing(atmo_instance)
)
{
    exit;
}


// ====================================================
// INTRO TERMINAL SILENCE
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
    atmo_priority,
    true
);

if (atmo_instance != noone)
{
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
}