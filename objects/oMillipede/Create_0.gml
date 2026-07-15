/// oMillipede — Create

depth = -15000;

sprite_index = -1;

enabled    = true;
debug_draw = false;

// ----------------------------------------------------
// Editor variables
// ----------------------------------------------------
if (!variable_instance_exists(id, "move_direction"))
{
    move_direction = 0;
}

if (!variable_instance_exists(id, "middle_count"))
{
    middle_count = 2;
}

if (!variable_instance_exists(id, "move_speed"))
{
    move_speed = 0.6;
}

if (!variable_instance_exists(id, "patrol_distance"))
{
    patrol_distance = 128;
}

// ----------------------------------------------------
// Sprites
// ----------------------------------------------------
spr_head_left  = asset_get_index("spriteMillipedeLeft");
spr_middle     = asset_get_index("spriteMillipedeMiddle");
spr_head_right = asset_get_index("spriteMillipedeRight");

// ----------------------------------------------------
// Starting position
// ----------------------------------------------------
start_x = x;
start_y = y;

travelled = 0;

// 1 = original direction
// -1 = reversed direction
patrol_sign = 1;

// ----------------------------------------------------
// Animation
// ----------------------------------------------------
anim_position = 0;
anim_speed    = 0.35;

// ----------------------------------------------------
// Cached dimensions
// ----------------------------------------------------
left_w  = (spr_head_left  != -1) ? sprite_get_width(spr_head_left)  : 0;
left_h  = (spr_head_left  != -1) ? sprite_get_height(spr_head_left) : 0;

mid_w   = (spr_middle     != -1) ? sprite_get_width(spr_middle)     : 0;
mid_h   = (spr_middle     != -1) ? sprite_get_height(spr_middle)    : 0;

right_w = (spr_head_right != -1) ? sprite_get_width(spr_head_right)  : 0;
right_h = (spr_head_right != -1) ? sprite_get_height(spr_head_right) : 0;

// Full unrotated body dimensions
body_length =
    left_w +
    (mid_w * max(1, middle_count)) +
    right_w;

body_thickness =
    max(left_h, max(mid_h, right_h));

// Collision inset lets the visible extremities overlap
// the player slightly before becoming lethal.
collision_inset_length = 3;
collision_inset_side   = 2;