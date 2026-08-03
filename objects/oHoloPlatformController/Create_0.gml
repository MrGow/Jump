/// oHoloPlatformController — Create

// Must be visible so Draw runs.
visible = true;


// ====================================================
// EDITOR SETTINGS
// ====================================================

if (!variable_instance_exists(id, "holo_layer_name"))
{
    holo_layer_name = "HoloTiles";
}

// Time at full visibility after activation.
if (!variable_instance_exists(id, "study_time_s"))
{
    study_time_s = 3.5;
}

// Time taken to fade from alpha 1 to hidden_alpha.
if (!variable_instance_exists(id, "fade_time_s"))
{
    fade_time_s = 1.25;
}

// 0 = completely invisible.
if (!variable_instance_exists(id, "hidden_alpha"))
{
    hidden_alpha = 0;
}

if (!variable_instance_exists(id, "reset_on_death"))
{
    reset_on_death = true;
}

if (!variable_instance_exists(id, "start_immediately"))
{
    start_immediately = false;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


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

    // Disable GameMaker's normal full-opacity drawing.
    layer_set_visible(
        holo_layer_id,
        false
    );

    // Draw the controller at the tile layer's depth.
    depth =
        layer_get_depth(
            holo_layer_id
        );
}


// ====================================================
// SURFACE CACHE
// ====================================================

// The tilemap is rendered to this surface once.
// The surface itself is then faded.
holo_surface = -1;

holo_surface_needs_redraw = true;


// ====================================================
// TIMERS AND STATE
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
// SET ALPHA
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

    apply_holo_alpha(1);

    if (study_frames > 0)
    {
        state = "studying";
    }
    else
    {
        state = "fading";
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

    apply_holo_alpha(1);
};


// ====================================================
// INITIAL STATE
// ====================================================

if (start_immediately)
{
    start_holo_sequence();
}