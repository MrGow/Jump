/// oConveyorRight - Create

// Visual
sprite_index = spriteArea2ConveyorRight;
image_speed  = 0.25;

// Conveyor tuning
belt_speed     = 1.0;   // rightward carry speed (px/step)
surface_offset = 0;     // tweak if sprite top doesn't match collision top
top_band_px    = 6;     // vertical band considered "standing on top"

// Optional weak drag when overlapping but not standing on top
use_air_drag   = false;
air_drag_speed = 0.15;