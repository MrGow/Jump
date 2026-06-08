/// oConveyorRight — Create

sprite_index = spriteArea2ConveyorRight;
image_speed  = 1;

belt_speed     = 1.0;
surface_offset = 0;

is_conveyor = true;

surface_inset_left  = 0;
surface_inset_right = 0;
surface_y           = bbox_top + surface_offset;

dx = belt_speed;
dy = 0;

enabled = true;
active  = true;

// Important: conveyor is handled as a floor-surface, not a blocking hazard body
solid_body = false;