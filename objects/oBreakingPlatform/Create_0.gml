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

// Breaking timing
break_triggered = false;
break_gone      = false;

break_frame = 20; // frame where platform stops being solid
gone_hold_frames = room_speed * 2; // waits 2 seconds while disappeared
gone_timer = 0;

// Animation speed
break_anim_speed = 1;
rebuild_anim_speed = 1;

state = "idle"; // idle, breaking, gone, rebuilding

debug_draw = false;