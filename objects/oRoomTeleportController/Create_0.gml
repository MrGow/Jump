/// oRoomTeleportController — Create

if (!variable_instance_exists(id, "target_room"))  target_room  = noone;
if (!variable_instance_exists(id, "target_spawn")) target_spawn = "";

if (!variable_instance_exists(id, "area_name")) area_name = "";
if (!variable_instance_exists(id, "show_area_name")) show_area_name = false;

overlay_surface = -1;

title_sound_played = false;

fade_alpha = 0;

fade_speed_out = 0.035;
fade_speed_in  = 0.018;

black_hold_frames    = round(room_speed * 0.35);
title_fade_in_frames = round(room_speed * 0.75);
title_hold_frames    = round(room_speed * 2.5);

title_timer = 0;
title_alpha = 0;

hold_frames =
    black_hold_frames +
    title_fade_in_frames +
    title_hold_frames;

state = "fade_out";

persistent = true;
visible = true;
depth = -1000;

global.room_teleport_active = true;
global.room_teleport_spawn_id = "";