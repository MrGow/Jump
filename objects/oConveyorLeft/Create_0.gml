/// oConveyorLeft - Create

// Visual
sprite_index = spriteArea2ConveyorLeft;
image_speed  = 1;

// Conveyor tuning
belt_speed     = -1.0;  // leftward carry speed (px/step)
surface_offset = 0;     // tweak if sprite top doesn't match collision top

// Floor-surface compatibility
surface_inset_left  = 0;
surface_inset_right = 0;
surface_y           = bbox_top + surface_offset;

// Expose motion for player carry logic
dx = belt_speed;
dy = 0;

// Optional flags for compatibility/debug
enabled = true;
solid_body = false;