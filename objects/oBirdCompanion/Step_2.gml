/// oBirdCompanion — End Step (snap feet + PERFECT sync incl wallhit)

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

// Facing direction
var dir = 1;
if (variable_instance_exists(owner, "facing")) dir = owner.facing;
else if (variable_instance_exists(owner, "image_xscale")) dir = (owner.image_xscale >= 0) ? 1 : -1;

// Sprite lookup
function __spr(_name) {
    var s = asset_get_index(_name);
    return (s != -1) ? s : -1;
}

// Bird sprites
var sprIdle     = __spr("spriteBirdIdle");        // optional
var sprCharge   = __spr("spriteBirdJumpCharge");
var sprJumping  = __spr("spriteBirdJumping");
var sprGlide    = __spr("spriteBirdGliding");     // optional
var sprLanding  = __spr("spriteBirdLanding");     // optional
var sprWallHit  = __spr("spriteBirdWallHit");

// Fallback
var sprFallback = (sprWallHit != -1) ? sprWallHit : __spr("spriteBirdWallHit");

// Owner state
var st = (variable_instance_exists(owner, "state")) ? owner.state : "";

// Choose sprite by owner state
var target = sprFallback;

if (st == "jump_charge") target = (sprCharge  != -1) ? sprCharge  : sprFallback;
else if (st == "jumping") target = (sprJumping != -1) ? sprJumping : sprFallback;
else if (st == "glide")   target = (sprGlide   != -1) ? sprGlide   : sprFallback;
else if (st == "landing") target = (sprLanding != -1) ? sprLanding : sprFallback;
else if (st == "wallhit") target = (sprWallHit != -1) ? sprWallHit : sprFallback;
else                      target = (sprIdle    != -1) ? sprIdle    : sprFallback;

// Reset anim when state/sprite changes
if (st != last_owner_state || sprite_index != target) {
    sprite_index = target;
    image_index  = 0;
    image_speed  = 0.2;
    last_owner_state = st;
}

// Hot reload safety
if (!variable_instance_exists(id, "bird_idle_anim_speed")) bird_idle_anim_speed = 0.75;

// Sync timing EXACTLY
if (st == "jump_charge") {
    image_speed = 0;
    if (variable_instance_exists(owner, "image_index")) image_index = owner.image_index;
}
else if (st == "jumping" || st == "landing") {
    if (variable_instance_exists(owner, "image_speed")) image_speed = owner.image_speed;
    if (variable_instance_exists(owner, "image_index")) image_index = owner.image_index;
}
else if (st == "wallhit") {
    // Timed wallhit hold uses frame 0
    image_speed = 0;
    image_index = 0;
}
else {
    // IDLE / default: run bird idle faster
    if (sprite_index == sprIdle) {
        image_speed = bird_idle_anim_speed;
    }
}

// Face same way
image_xscale = dir;

// Hot reload safety for perch
if (!variable_instance_exists(id, "perch_x")) perch_x = 0;
if (!variable_instance_exists(id, "perch_y")) perch_y = 2;

// Anchor point = top of owner's collision bbox
var ax = (owner.bbox_left + owner.bbox_right) * 0.5 + (perch_x * dir);
var ay = owner.bbox_top + perch_y;

// Snap bird FEET to ay
var byoff = sprite_get_yoffset(sprite_index);
var bbot  = sprite_get_bbox_bottom(sprite_index);
y = ay - (bbot - byoff);

// Center X align
var bxoff = sprite_get_xoffset(sprite_index);
var bcl   = sprite_get_bbox_left(sprite_index);
var bcr   = sprite_get_bbox_right(sprite_index);
var bcx   = (bcl + bcr) * 0.5;
x = ax - (bcx - bxoff);
