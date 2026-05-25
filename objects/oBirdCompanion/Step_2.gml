/// oBirdCompanion — End Step

if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

var dir = 1;
if (variable_instance_exists(owner, "facing")) dir = owner.facing;
else if (variable_instance_exists(owner, "image_xscale")) dir = (owner.image_xscale >= 0) ? 1 : -1;

function __spr(_name) {
    var s = asset_get_index(_name);
    return (s != -1) ? s : -1;
}

var sprIdle     = __spr("spriteBirdIdle");
var sprCharge   = __spr("spriteBirdJumpCharge");
var sprJumping  = __spr("spriteBirdJumping");
var sprGlide    = __spr("spriteBirdGliding");
var sprLanding  = __spr("spriteBirdLanding");
var sprWallHit  = __spr("spriteBirdWallHit");

var sprFallback = (sprWallHit != -1) ? sprWallHit : sprite_index;

var st = (variable_instance_exists(owner, "state")) ? owner.state : "";

if (variable_instance_exists(owner, "wallhit_timer") && owner.wallhit_timer > 0) {
    st = "wallhit";
}

var target = sprFallback;

if (st == "jump_charge") target = (sprCharge  != -1) ? sprCharge  : sprFallback;
else if (st == "jumping") target = (sprJumping != -1) ? sprJumping : sprFallback;
else if (st == "glide")   target = (sprGlide   != -1) ? sprGlide   : sprFallback;
else if (st == "landing") target = (sprLanding != -1) ? sprLanding : sprFallback;
else if (st == "wallhit") target = (sprWallHit != -1) ? sprWallHit : sprFallback;
else                      target = (sprIdle    != -1) ? sprIdle    : sprFallback;

if (st != last_owner_state || sprite_index != target) {
    sprite_index = target;
    image_index  = 0;
    image_speed  = 0.2;
    last_owner_state = st;
}

if (!variable_instance_exists(id, "bird_idle_anim_speed")) bird_idle_anim_speed = 1;
if (!variable_instance_exists(id, "perch_x")) perch_x = 2;
if (!variable_instance_exists(id, "perch_y")) perch_y = -6;
if (!variable_instance_exists(id, "charge_perch_drop_per_level")) charge_perch_drop_per_level = 2.5;
if (!variable_instance_exists(id, "charge_perch_drop_max"))       charge_perch_drop_max = 9;

// Sync animation
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
    if (sprite_index == sprIdle) image_speed = bird_idle_anim_speed;
}

image_xscale = dir;

// Owner draw inset
var owner_draw_floor_inset = 0;
if (variable_instance_exists(owner, "draw_floor_inset")) {
    owner_draw_floor_inset = owner.draw_floor_inset;
}

var owner_draw_x = owner.x;
var owner_draw_y = owner.y + owner_draw_floor_inset;

var ospr = owner.sprite_index;
var oyoff = sprite_get_yoffset(ospr);
var obtop = sprite_get_bbox_top(ospr);
var obleft = sprite_get_bbox_left(ospr);
var obright = sprite_get_bbox_right(ospr);

var owner_visual_top_y = owner_draw_y - oyoff + obtop;
var owner_visual_center_x = owner_draw_x - sprite_get_xoffset(ospr) + ((obleft + obright) * 0.5);

// Extra downward offset during charge
var charge_drop = 0;

if (st == "jump_charge") {
    var lvl = variable_instance_exists(owner, "jump_charge_level") ? owner.jump_charge_level : 0;
    charge_drop = min(charge_perch_drop_max, lvl * charge_perch_drop_per_level);
}

var ax = owner_visual_center_x + (perch_x * dir);
var ay = owner_visual_top_y + perch_y + charge_drop;

// Snap bird feet to anchor
var byoff = sprite_get_yoffset(sprite_index);
var bbot  = sprite_get_bbox_bottom(sprite_index);
y = ay - (bbot - byoff);

// Center X align
var bxoff = sprite_get_xoffset(sprite_index);
var bcl   = sprite_get_bbox_left(sprite_index);
var bcr   = sprite_get_bbox_right(sprite_index);
var bcx   = (bcl + bcr) * 0.5;
x = ax - (bcx - bxoff);