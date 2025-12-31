/// oBirdCompanion — Create

owner = noone;

// Perch tuning
perch_x = 5;  // horizontal offset from bot center, affected by facing
perch_y = 6;  // vertical offset from owner's bbox_top (increase to sit lower)

// Idle speed control (FASTER)
bird_idle_anim_speed = 1; // try 0.8 - 1.0 if you want even faster

sprite_index = spriteBirdWallHit;
image_speed  = 0.2;
image_xscale = 1;

last_owner_state = "";
