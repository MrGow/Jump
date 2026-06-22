/// oBreakingPlatform — Create

sprite_index = spriteBreakablePlatform;
image_speed  = 0;
image_index  = 0;

enabled = true;
active  = true;

// Floor-surface compatibility
surface_inset_left  = 0;
surface_inset_right = 0;
surface_y           = bbox_top;
dx = 0;
dy = 0;

// This object handles top surface only.
// Separate solid object handles sides/bottom.
solid_body = false;
solid_only_when_active = false;

// SFX
snd_breaking_platform = asset_get_index("BreakingPlatform1");
breaking_platform_sfx_gain = 0.65;
breaking_platform_sfx_played = false;

// Editor variables
if (!variable_instance_exists(id, "wait_before_break_s")) wait_before_break_s = 3.0;
if (!variable_instance_exists(id, "respawn_delay_s"))     respawn_delay_s     = 4.5;

wait_frames    = ceil(room_speed * wait_before_break_s);
respawn_frames = ceil(room_speed * respawn_delay_s);

// Animation/frame tuning
if (!variable_instance_exists(id, "shake_from"))  shake_from = 0;
if (!variable_instance_exists(id, "shake_to"))    shake_to   = 4;
if (!variable_instance_exists(id, "break_frame")) break_frame = 13;

break_anim_speed   = 1;
rebuild_anim_speed = 1;

timer = 0;
gone_timer = 0;

break_triggered = false;
break_gone      = false;

state = "idle"; // idle, countdown, breaking, gone, rebuilding, waiting_clear

debug_draw = false;

// Separate side/bottom collision
solid_inst = instance_create_layer(x, y, "Instances", oBreakingPlatformSolid);
solid_inst.image_angle = image_angle;
solid_inst.active = active;