/// oRoomTeleportController — Create

target_room  = noone;
target_spawn = "";

fade_alpha = 0;
fade_speed_out = 0.08;
fade_speed_in  = 0.045;
hold_frames = 24;

state = "fade_out";

persistent = true;
visible = true;
depth = -10000000;

global.room_teleport_active = true;
global.room_teleport_spawn_id = "";