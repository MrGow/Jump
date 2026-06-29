/// oFlames — Create

// How far inside the flames the player must be before death triggers
kill_inset_x = 2;
kill_inset_top = 6;
kill_inset_bottom = 0;

// Animation
flame_anim_speed = image_speed;
if (flame_anim_speed <= 0) flame_anim_speed = 0.35;

// Loop SFX
snd_flame_loop = asset_get_index("FlameLoop1");
flame_loop_instance = noone;

flame_loop_gain = 0.16;
flame_loop_pitch = 1.0;

flame_loop_inner_dist = 90;
flame_loop_outer_dist = 300;