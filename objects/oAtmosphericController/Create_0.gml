/// oAtmosphereController — Create

// ====================================================
// SINGLE PERSISTENT CONTROLLER
// ====================================================

persistent = true;

// Keep the existing controller when changing rooms.
// This prevents the playing loop from restarting.
if (instance_number(oAtmosphericController) > 1)
{
    instance_destroy();
    exit;
}


// ====================================================
// ATMOSPHERE STATE
// ====================================================

atmo_sound = -1;
atmo_pitch = 1.0;
atmo_gain = 1.0;

atmo_instance = noone;
atmo_started = false;

atmo_area = "";


// ====================================================
// INTRO CINEMATIC FLAG
// ====================================================

// Initialise only if the flag doesn't exist.
// The intro controller is responsible for setting
// this to true when the cinematic begins.

if (!variable_global_exists("intro_cinematic_started"))
{
    global.intro_cinematic_started = false;
}


// ====================================================
// AUDIO SETTINGS
// ====================================================

scr_settings_init();

if (!audio_group_is_loaded(audiogroupatmosphere))
{
    audio_group_load(audiogroupatmosphere);
}