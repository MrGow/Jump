/// oConveyorLeft - Step

// Keep standable surface aligned with the visual top
surface_y = bbox_top + surface_offset;

// Expose conveyor motion every frame
dx = belt_speed;
dy = 0;