/// oConveyorLargeLeft — Create

event_inherited();

sprite_index = spriteArea2ConveyorLargeLeft;
image_speed  = 1;

// Refresh surface after sprite swap
surface_y = bbox_top + surface_offset;
dx = belt_speed;
dy = 0;