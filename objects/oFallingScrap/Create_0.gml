/// oFallingScrap — Create

event_inherited();

enabled = true;
active  = true;

// Random sprite
var choice = irandom(3);

if (choice == 0) sprite_index = spriteFallingScrap1;
else if (choice == 1) sprite_index = spriteFallingScrap2;
else if (choice == 2) sprite_index = spriteFallingScrap3;
else sprite_index = spriteFallingScrap4;

normal_image_speed = random_range(0.25, 0.5);
image_speed = normal_image_speed;
image_index = irandom(max(0, image_number - 1));

fall_speed = 4.5;
hsp = 0;

life_timer = room_speed * 4;

// Optional spin
spin_speed = random_range(-2, 2);

// Collision tuning
kill_inset_x = 2;
kill_inset_y = 2;

depth = -100;

// SFX
snd_falling_scrap = asset_get_index("FallingScrap1");
snd_scrap_impact  = asset_get_index("FallingScrapImpact1");

falling_scrap_fall_gain   = 0.55;
falling_scrap_impact_gain = 1;

falling_scrap_inner_dist = 220;
falling_scrap_outer_dist = 640;

falling_scrap_sound_played = false;