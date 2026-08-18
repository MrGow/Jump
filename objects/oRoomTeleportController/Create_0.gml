/// oRoomTeleportController — Create

// ====================================================
// DESTINATION
// ====================================================

if (!variable_instance_exists(id, "target_room"))
{
    target_room = noone;
}

if (!variable_instance_exists(id, "target_spawn"))
{
    target_spawn = "";
}


// ====================================================
// AREA TITLE
// ====================================================

if (!variable_instance_exists(id, "area_name"))
{
    area_name = "";
}

if (!variable_instance_exists(id, "show_area_name"))
{
    show_area_name = false;
}


// ====================================================
// REMEMBER ENTRY DIRECTION
// ====================================================

entry_facing = 1;

var entry_player =
    instance_find(
        oPlayer,
        0
    );

if (
    instance_exists(entry_player) &&
    variable_instance_exists(
        entry_player,
        "facing"
    ) &&
    entry_player.facing != 0
)
{
    entry_facing =
        sign(entry_player.facing);
}
else if (instance_exists(entry_player))
{
    entry_facing =
        sign(entry_player.image_xscale);

    if (entry_facing == 0)
    {
        entry_facing = 1;
    }
}


// ====================================================
// OVERLAY
// ====================================================

overlay_surface = -1;

title_sound_played = false;

fade_alpha = 0;
title_timer = 0;
title_alpha = 0;


// ====================================================
// TIMING MODES
//
// FAST timing matches the regular oCamera zone fade.
//
// TITLE timing retains the longer area-introduction
// presentation.
// ====================================================

// Normal cam-zone-style transition
fast_fade_speed_out = 0.12;
fast_fade_speed_in = 0.06;
fast_hold_frames = 14;


// Area-title transition
title_fade_speed_out = 0.035;
title_fade_speed_out_overlay = 0.018;

title_black_hold_frames =
    round(
        room_speed * 0.35
    );

title_fade_in_frames_setting =
    round(
        room_speed * 0.75
    );

title_hold_frames_setting =
    round(
        room_speed * 2.5
    );


// These are configured at the beginning of the first
// Step, after the trigger has assigned show_area_name.
fade_speed_out = fast_fade_speed_out;
fade_speed_in = fast_fade_speed_in;

black_hold_frames =
    fast_hold_frames;

title_fade_in_frames = 0;
title_hold_frames = 0;

hold_frames =
    fast_hold_frames;

timing_configured = false;


// ====================================================
// STATE
// ====================================================

state = "fade_out";

persistent = true;
visible = true;

depth = -1000;


// ====================================================
// GLOBAL TRANSITION STATE
// ====================================================

global.room_teleport_active = true;
global.room_teleport_spawn_id = "";