/// oPlayer - Create (surface-ground edition, fixed)

event_inherited();
depth = -10000;
hsp = 0;
vsp = 0;

gravity_amt = 0.25;
max_fall    = 8.0;

jump_v_base = -4.0;
jump_h_base =  4.0;

low_jump_multiplier = 1.7;
fall_multiplier     = 1.4;

jump_charge_frame_steps = 6;
jump_charge       = 0;
jump_charge_level = 0;
jump_charging     = false;
prev_jump_h       = false;

charge_support_min    = 1;
charge_grace_max      = 5;
charge_grace          = 0;
charge_start_lock_max = 2;
charge_start_lock     = 0;

prev_on_ground    = false;

support_stable_frames = 0;
support_stable_needed = 1;

support_grace_max = 2;
support_grace     = 0;

edge_charge_fail_max = 2;
edge_charge_fail     = 0;

facing = 1;
state  = "idle";
death_fall = false;

bounce_enabled      = true;
bounce_threshold    = 2.0;
bounce_mult = 0.950;
bounce_min  = 2.6;
bounce_max  = 7.0;
bounce_pause_frames = 1;
bounce_h_damp       = 0.65;
bounce_pending      = false;
bounce_timer        = 0;
bounce_v            = 0;

// Wall hit overlay
wallhit_overlay_sprite = asset_get_index("spriteBotWallHit");
wallhit_overlay_alpha  = 1;

// Conveyor bounce influence
conveyor_grip_timer  = 0;
conveyor_grip_max    = 10;
conveyor_grip_speed  = 0;
conveyor_grip        = 0.18;
conveyor_ground_grip = 0.35;

wallhit_enabled         = true;
wallhit_threshold       = 3.5;
wallhit_cooldown_frames = 10;
wallhit_cd              = 0;
wallhit_hold_seconds    = 0.40;
wallhit_timer           = 0;

wallbounce_enabled    = true;
wallbounce_threshold  = 2.8;
wallbounce_mult       = 0.60;
wallbounce_min_h      = 1.5;
wallbounce_upkick     = 0.15;
wallbounce_cd_frames  = 3;
wallbounce_cd         = 0;

ground_probe_inset        = 10;
vertical_probe_inset      = 3;
side_probe_top_margin     = 10;
side_probe_bottom_margin  = 6;

standing_platform      = noone;
standing_platform_xoff = 0;
platform_stick_timer   = 0;

ground_snap_max         = 6;
ground_min_overlap      = 6;
ground_attach_max       = 2;
coyote_max              = 5;
coyote_timer            = 0;

respawn_input_lock = 0;

mask_index = spriteBotMask;
draw_floor_inset = 9;
debug_draw = true;

jump_trail_enabled     = true;
jump_trail_max_points  = 7;
jump_trail_spacing     = 1;
jump_trail_timer       = 0;
jump_trail_points      = array_create(jump_trail_max_points);
jump_trail_alpha       = 0.32;
jump_trail_size_start  = 1.00;
jump_trail_size_end    = 0.45;
jump_trail_y_lift      = -12;
jump_trail_sprite      = asset_get_index("spriteJumpArc");

shadow_enabled       = true;
shadow_max_dist      = 56;
shadow_ground_dist   = -1;

shadow_max_w         = 26;
shadow_min_w         = 10;
shadow_max_h         = 8;
shadow_min_h         = 3;

shadow_alpha_near    = 0.22;
shadow_alpha_far     = 0.00;

shadow_y_nudge       = 0;

shadow_support_ratio = 1;
shadow_support_cx    = x;
shadow_support_left  = x - 8;
shadow_support_right = x + 8;

if (asset_get_index("spriteBotIdle") != -1) {
    sprite_index = spriteBotIdle;
    image_speed  = 1;
    image_index  = 0;
}

bird = noone;
if (asset_get_index("oBirdCompanion") != -1) {
    bird = instance_create_layer(x, y, "Instances", oBirdCompanion);
    if (instance_exists(bird)) bird.owner = id;
}