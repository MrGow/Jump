/// oPlayer — Create

// --------- Movement config ---------
move_speed  = 2.5;
jump_speed  = -5.0;
gravity_amt = 0.25;  // <- Step uses gravity_amt
max_fall    = 8.0;   // <- Step uses max_fall

// Physics state
hsp = 0;
vsp = 0;

// Facing / state
facing = 1;
state  = "idle";

// Basic HP
max_hp = 1;
hp     = max_hp;

// Ground tracking
on_ground      = false;
prev_on_ground = false;

// Visual
sprite_index = spriteBotIdle;
image_speed  = 0.2;
image_xscale = 1;

// --------- Spawn bird companion ---------
bird = instance_create_layer(x, y, "Instances", oBirdCompanion);
if (instance_exists(bird)) {
    bird.owner = id;
}

