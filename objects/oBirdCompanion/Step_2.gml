/// oBirdCompanion — End Step (anchor to OWNER VISUAL SPRITE, not bbox)

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
var sprIdle     = __spr("spriteBirdIdle");
var sprCharge   = __spr("spriteBirdJumpCharge");
var sprJumping  = __spr("spriteBirdJumping");
var sprGlide    = __spr("spriteBirdGliding");
var sprLanding  = __spr("spriteBirdLanding");
var sprWallHit  = __spr("spriteBirdWallHit");

// Fallback
var sprFallback = (sprWallHit != -1) ? sprWallHit : sprite_index;

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
if (!variable_instance_exists(id, "bird_idle_anim_speed")) bird_idle_anim_speed = 1;

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
    image_speed = 0;
    image_index = 0;
}
else {
    if (sprite_index == sprIdle) {
        image_speed = bird_idle_anim_speed;
    }
}

// Face same way
image_xscale = dir;

// Hot reload safety for perch
if (!variable_instance_exists(id, "perch_x")) perch_x = 0;
if (!variable_instance_exists(id, "perch_y")) perch_y = -6;

// --------------------------------------------
// NEW: anchor to OWNER VISUAL SPRITE POSITION
// --------------------------------------------

// Owner draw inset
var owner_draw_floor_inset = 0;
if (variable_instance_exists(owner, "draw_floor_inset")) {
    owner_draw_floor_inset = owner.draw_floor_inset;
}

// Owner visible draw position
var owner_draw_x = owner.x;
var owner_draw_y = owner.y + owner_draw_floor_inset;

// Owner sprite visual top / center
var ospr = owner.sprite_index;
var oyoff = sprite_get_yoffset(ospr);
var obtop = sprite_get_bbox_top(ospr);
var obleft = sprite_get_bbox_left(ospr);
var obright = sprite_get_bbox_right(ospr);

// World Y of owner's visible sprite top edge
var owner_visual_top_y = owner_draw_y - oyoff + obtop;

// World X of owner's visible sprite center
var owner_visual_center_x = owner_draw_x - sprite_get_xoffset(ospr) + ((obleft + obright) * 0.5);

// Perch anchor
var ax = owner_visual_center_x + (perch_x * dir);
var ay = owner_visual_top_y + perch_y;

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