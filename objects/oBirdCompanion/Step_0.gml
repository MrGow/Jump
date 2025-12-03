/// oBirdCompanion — Step
if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

var dir = owner.facing;

// Follow bot
x = owner.x + offset_x * dir;
y = owner.y + offset_y;

// Face same way
image_xscale = dir;

// Optional: match animation frame for cute sync
image_speed = owner.image_speed;
image_index = owner.image_index;
