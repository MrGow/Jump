/// oPlayer - Create (for current Step)

event_inherited();

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

ground_stick_max  = 4;
ground_stick      = 0;

ground_min_frames = 3;
ground_frames     = 0;

support_stable_frames = 0;
support_stable_needed = 2;

support_grace_max = 4;
support_grace     = 0;

edge_charge_fail_max = 2;
edge_charge_fail     = 0;

facing = 1;
state  = "idle";
death_fall = false;

bounce_enabled      = true;
bounce_threshold    = 2.0;
bounce_mult         = 0.55;
bounce_min          = 2.0;
bounce_max          = 6.0;
bounce_pause_frames = 1;
bounce_h_damp       = 0.65;
bounce_pending      = false;
bounce_timer        = 0;
bounce_v            = 0;

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
edge_perch_v_max          = 0.08;
edge_perch_support_needed = 2;

ledge_support_v_max       = 0.20;
ledge_support_grace_max   = 5;
ledge_support_grace       = 0;

standing_platform      = noone;
standing_platform_xoff = 0;
platform_stick_timer   = 0;

mask_index = spriteBotMask;

if (asset_get_index("spriteBotIdle") != -1) {
    sprite_index = spriteBotIdle;
    image_speed = 1;
}