/// oConveyor - Create
enabled = true;

// Belt push
if (!variable_instance_exists(id, "belt_dir"))   belt_dir   = 1;     // 1 right, -1 left
if (!variable_instance_exists(id, "belt_speed")) belt_speed = 0.35;  // tune

// Optional: make the platform itself move (factory mover)
if (!variable_instance_exists(id, "do_move"))    do_move    = false;
if (!variable_instance_exists(id, "move_axis"))  move_axis  = 0;     // 0 horizontal, 1 vertical
if (!variable_instance_exists(id, "move_range")) move_range = 64;
if (!variable_instance_exists(id, "move_speed")) move_speed = 1.0;

// Runtime for carrying riders
x0 = x;
y0 = y;
t  = irandom(999999);

prev_x = x;
prev_y = y;
dx = 0;
dy = 0;

if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;
