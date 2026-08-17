/// oPlayer — Create
// Surface-ground edition
// Includes unique death-presentation setup

event_inherited();

depth = -1000;

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

//I-FRAMES AFTER DEATH

// Respawn invulnerability
invincible = false;
invincible_timer = 0;
invincible_frames = room_speed; // 1 second

// ====================================================
// JUMP LAUNCH POSE HOLD
// ====================================================

jump_pose_min_frames = 25;
jump_pose_timer      = 0;
jump_anim_speed      = 0.35;

prev_on_ground = false;

support_stable_frames = 0;
support_stable_needed = 1;

support_grace_max = 2;
support_grace     = 0;

edge_charge_fail_max = 2;
edge_charge_fail     = 0;


// ====================================================
// GENERAL PLAYER STATE
// ====================================================

facing = 1;
state  = "idle";

death_fall = false;


// ====================================================
// DEATH PRESENTATION STATE
//
// These variables are configured by scr_player_died().
// The real player position remains separate from the
// visual offsets used by special death animations.
// ====================================================

death_type = "";

death_uses_player_sprite = false;

death_animation_speed = 0;
death_hitstop_timer   = 0;
death_effect_timer    = 0;


// ----------------------------------------------------
// Draw-only death offsets
// ----------------------------------------------------

death_draw_offset_x = 0;
death_draw_offset_y = 0;


// ----------------------------------------------------
// Electrocution jitter
// ----------------------------------------------------

death_jitter_strength = 0;


// ----------------------------------------------------
// Electrocution flicker
// ----------------------------------------------------

death_flicker_enabled = false;
death_flicker_rate    = 2;

death_flicker_colour_a = c_white;
death_flicker_colour_b = c_white;


// ----------------------------------------------------
// Ripped-apart downward sink
// ----------------------------------------------------

death_sink_enabled = false;

death_sink_delay = 0;
death_sink_offset = 0;

death_sink_velocity     = 0;
death_sink_acceleration = 0;
death_sink_max          = 0;


// ----------------------------------------------------
// Fall-death camera lock
// ----------------------------------------------------

death_cam_lock_x = x;
death_cam_lock_y = y;


// ----------------------------------------------------
// Global death screen-flash defaults
// ----------------------------------------------------

if (!variable_global_exists("death_flash_alpha"))
{
    global.death_flash_alpha = 0;
}

if (!variable_global_exists("death_flash_colour"))
{
    global.death_flash_colour = c_white;
}

if (!variable_global_exists("death_flash_fade_speed"))
{
    global.death_flash_fade_speed = 0.12;
}


// ====================================================
// BOUNCE SETTINGS
// ====================================================

bounce_enabled      = true;
bounce_threshold    = 2.0;
bounce_mult         = 0.950;
bounce_min          = 2.6;
bounce_max          = 7.0;
bounce_pause_frames = 1;
bounce_h_damp       = 0.65;

bounce_pending = false;
bounce_timer   = 0;
bounce_v       = 0;


// ====================================================
// GRAVITY ZONE STATE
// ====================================================

in_low_gravity_zone  = false;
in_high_gravity_zone = false;

snd_low_gravity_jump =
    asset_get_index(
        "GravityZoneJump1"
    );

low_gravity_jump_gain = 1;

snd_high_gravity_jump =
    asset_get_index(
        "GravityZoneRedJump1"
    );

high_gravity_jump_gain = 1;

low_grav_mult_zone  = 1.0;
low_fall_mult_zone  = 1.0;

high_grav_mult_zone = 1.0;
high_fall_mult_zone = 1.0;


// ====================================================
// WALL-HIT OVERLAY
// ====================================================

wallhit_overlay_sprite =
    asset_get_index(
        "spriteBotWallHit"
    );

wallhit_overlay_alpha = 1;


// ====================================================
// CONVEYOR BOUNCE INFLUENCE
// ====================================================

conveyor_grip_timer  = 0;
conveyor_grip_max    = 10;
conveyor_grip_speed  = 0;

conveyor_grip        = 0.18;
conveyor_ground_grip = 0.35;

// Grabber currently holding the player.
grabbed_by = noone;

// ====================================================
// WALL-HIT SETTINGS
// ====================================================

wallhit_enabled         = true;
wallhit_threshold       = 3.5;
wallhit_cooldown_frames = 10;
wallhit_cd              = 0;
wallhit_hold_seconds    = 0.40;
wallhit_timer           = 0;

jump_hold_gravity_enabled = false;


// ====================================================
// WALL-BOUNCE SETTINGS
// ====================================================

wallbounce_enabled   = true;
wallbounce_threshold = 2.8;
wallbounce_mult      = 0.60;
wallbounce_min_h     = 1.5;
wallbounce_upkick    = 0.15;

wallbounce_cd_frames = 3;
wallbounce_cd        = 0;


// ====================================================
// COLLISION PROBE SETTINGS
// ====================================================

ground_probe_inset       = 10;
vertical_probe_inset     = 3;

side_probe_top_margin    = 10;
side_probe_bottom_margin = 6;


// ====================================================
// SOFT LANDING BOUNCE
// ====================================================

soft_landing_bounce_enabled = true;
soft_landing_bounce_v       = -1.5;
soft_landing_min_air_frames = 6;

airborne_frames = 0;


// ====================================================
// LANDING SFX
// ====================================================

snd_land_soft =
    asset_get_index(
        "SoftLanding1"
    );

snd_land_medium =
    asset_get_index(
        "MediumLanding1"
    );

snd_land_hard =
    asset_get_index(
        "HardLanding1"
    );


// ====================================================
// JUMP CHARGE SFX
// ====================================================

jump_charge_sfx =
[
    asset_get_index("JumpCharge1"),
    asset_get_index("JumpCharge2"),
    asset_get_index("JumpCharge3"),
    asset_get_index("JumpCharge4")
];


// ====================================================
// JUMP RELEASE SFX
// ====================================================

jump_release_sfx =
[
    asset_get_index("JumpRelease1"),
    asset_get_index("JumpRelease2"),
    asset_get_index("JumpRelease3"),
    asset_get_index("JumpRelease4")
];


// ====================================================
// WALL-HIT SFX
// ====================================================

snd_wallhit =
    asset_get_index(
        "WallHit1"
    );

wallhit_sfx_gain = 0.55;


// ====================================================
// PLAYER SFX GAINS
// ====================================================

jump_release_sfx_gain = 0.65;

jump_charge_sfx_last = 0;
jump_charge_sfx_gain = 0.42;

land_soft_max_impact   = 2.75;
land_medium_max_impact = 5.25;

land_sfx_gain_soft   = 0.40;
land_sfx_gain_medium = 0.55;
land_sfx_gain_hard   = 0.75;


// ====================================================
// STANDING PLATFORM STATE
// ====================================================

standing_platform      = noone;
standing_platform_xoff = 0;
platform_stick_timer   = 0;


// ====================================================
// GROUND ATTACHMENT SETTINGS
// ====================================================

ground_snap_max    = 6;
ground_min_overlap = 6;
ground_attach_max  = 2;

coyote_max   = 5;
coyote_timer = 0;

respawn_input_lock = 0;


// ====================================================
// COLLISION MASK AND DRAW POSITION
// ====================================================

mask_index = spriteBotMask;

draw_floor_inset = 9;

debug_draw = true;


// ====================================================
// JUMP TRAIL
// ====================================================

jump_trail_enabled    = true;
jump_trail_max_points = 7;
jump_trail_spacing    = 1;
jump_trail_timer      = 0;

jump_trail_points =
    array_create(
        jump_trail_max_points
    );

jump_trail_alpha      = 0.32;
jump_trail_size_start = 1.00;
jump_trail_size_end   = 0.45;
jump_trail_y_lift     = -12;

jump_trail_sprite =
    asset_get_index(
        "spriteJumpArc"
    );


// ====================================================
// PLAYER SHADOW
// ====================================================

shadow_enabled     = true;
shadow_max_dist    = 56;
shadow_ground_dist = -1;

shadow_max_w = 26;
shadow_min_w = 10;

shadow_max_h = 8;
shadow_min_h = 3;

shadow_alpha_near = 0.22;
shadow_alpha_far  = 0.00;

shadow_y_nudge = 0;

shadow_support_ratio = 1;
shadow_support_cx    = x;
shadow_support_left  = x - 8;
shadow_support_right = x + 8;


// ====================================================
// INITIAL SPRITE
// ====================================================

var idle_sprite =
    asset_get_index(
        "spriteBotIdle"
    );

if (idle_sprite != -1)
{
    sprite_index = idle_sprite;

    image_speed = 1;
    image_index = 0;
}


// ====================================================
// BIRD COMPANION
// ====================================================

bird = noone;

var bird_object =
    asset_get_index(
        "oBirdCompanion"
    );

if (bird_object != -1)
{
    bird =
        instance_create_layer(
            x,
            y,
            "Instances",
            bird_object
        );

    if (instance_exists(bird))
    {
        bird.owner = id;
    }
}