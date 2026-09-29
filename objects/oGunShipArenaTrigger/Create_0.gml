/// oGunShipArenaTrigger — Create

// Keep the sprite assigned in the object editor.
// visible must remain true so Draw GUI can show the GO arrow.
visible = true;

// Hide the trigger rectangle during normal play.
image_alpha = 0;

depth = -10000;

active = false;
completed = false;

arena_ship = noone;
arena_launcher = noone;

hp_at_start = 0;

arena_camera_x = x;
arena_camera_y = y;

// Player's approximate screen position when the arena locks.
entry_screen_x = 96;

scan_width = 640;
go_flash = 0;