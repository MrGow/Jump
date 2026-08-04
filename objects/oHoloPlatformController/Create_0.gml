/// oHoloPlatformController — Create

// Must remain visible so its Draw event runs.
visible = true;


// ====================================================
// EDITOR SETTINGS
// ====================================================

// Exact room tile-layer name.
if (!variable_instance_exists(id, "holo_layer_name"))
{
    holo_layer_name = "HoloTiles";
}

// Time the tiles remain fully visible after activation.
if (!variable_instance_exists(id, "study_time_s"))
{
    study_time_s = 3.5;
}

// Time taken to fade from full alpha to hidden_alpha.
if (!variable_instance_exists(id, "fade_time_s"))
{
    fade_time_s = 1.25;
}

// Final visibility.
//
// 0.0 = completely invisible
// 0.05 = extremely faint
if (!variable_instance_exists(id, "hidden_alpha"))
{
    hidden_alpha = 0;
}

// Restore the challenge after a same-room respawn.
if (!variable_instance_exists(id, "reset_on_death"))
{
    reset_on_death = true;
}

// true  = start automatically when room begins
// false = wait for oHoloPlatformTrigger
if (!variable_instance_exists(id, "start_immediately"))
{
    start_immediately = false;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// DISAPPEAR SOUND
// ====================================================

snd_holo_disappear =
    asset_get_index("HoloTilesDisappear1");

if (!variable_instance_exists(id, "holo_disappear_gain"))
{
    holo_disappear_gain = 1.0;
}

if (!variable_instance_exists(id, "holo_disappear_pitch"))
{
    holo_disappear_pitch = 1.0;
}

// Prevent the room-wide sound from playing more than once
// during the same disappearance sequence.
holo_disappear_sfx_played = false;


// ====================================================
// TILE LAYER
// ====================================================

holo_layer_id =
    layer_get_id(holo_layer_name);

holo_tilemap_id = -1;

if (holo_layer_id != -1)
{
    holo_tilemap_id =
        layer_tilemap_get_id(
            holo_layer_id
        );

    // Disable GameMaker's normal full-opacity rendering.
    // The controller draws the tilemap manually.
    layer_set_visible(
        holo_layer_id,
        false
    );

    // Match the original tile-layer depth.
    depth =
        layer_get_depth(
            holo_layer_id
        );
}


// ====================================================
// SURFACE CACHE
// ====================================================

holo_surface = -1;

holo_surface_needs_redraw = true;


// ====================================================
// STATE AND TIMERS
// ====================================================

study_frames =
    max(
        0,
        round(
            study_time_s *
            room_speed
        )
    );

fade_frames =
    max(
        1,
        round(
            fade_time_s *
            room_speed
        )
    );

study_timer = study_frames;
fade_timer  = fade_frames;

state = "waiting";
// waiting
// studying
// fading
// hidden

triggered = false;

current_alpha = 1;


// ====================================================
// SET CURRENT ALPHA
// ====================================================

apply_holo_alpha = function(_alpha)
{
    current_alpha =
        clamp(
            _alpha,
            0,
            1
        );
};


// ====================================================
// PLAY ROOM-WIDE DISAPPEAR SOUND
// ====================================================

play_holo_disappear_sfx = function()
{
    if (holo_disappear_sfx_played)
    {
        return;
    }

    holo_disappear_sfx_played = true;

    if (snd_holo_disappear == -1)
    {
        return;
    }

    scr_play_sfx(
        snd_holo_disappear,
        holo_disappear_gain,
        holo_disappear_pitch
    );
};


// ====================================================
// BEGIN FADING
// ====================================================

begin_holo_fade = function()
{
    state = "fading";

    fade_timer = fade_frames;

    apply_holo_alpha(1);

    // One universal sound for the whole room.
    play_holo_disappear_sfx();
};


// ====================================================
// START CHALLENGE
// ====================================================

start_holo_sequence = function()
{
    if (triggered)
    {
        return;
    }

    triggered = true;

    study_timer = study_frames;
    fade_timer  = fade_frames;

    holo_disappear_sfx_played = false;

    apply_holo_alpha(1);

    if (study_frames > 0)
    {
        state = "studying";
    }
    else
    {
        begin_holo_fade();
    }
};


// ====================================================
// RESET CHALLENGE
// ====================================================

reset_holo_sequence = function()
{
    triggered = false;

    study_timer = study_frames;
    fade_timer  = fade_frames;

    state = "waiting";

    holo_disappear_sfx_played = false;

    apply_holo_alpha(1);
};


// ====================================================
// INITIAL STATE
// ====================================================

if (start_immediately)
{
    start_holo_sequence();
}