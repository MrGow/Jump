/// oBirdCompanion — End Step


// ====================================================
// OWNER SAFETY
// ====================================================

if (!instance_exists(owner))
{
    instance_destroy();
    exit;
}


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "bird_state"))
{
    bird_state = "alive";
}

if (!variable_instance_exists(id, "bird_death_x"))
{
    bird_death_x = x;
}

if (!variable_instance_exists(id, "bird_death_y"))
{
    bird_death_y = y;
}

if (!variable_instance_exists(id, "bird_death_facing"))
{
    bird_death_facing = 1;
}

if (!variable_instance_exists(id, "last_owner_state"))
{
    last_owner_state = "";
}

if (!variable_instance_exists(id, "bird_idle_anim_speed"))
{
    bird_idle_anim_speed = 1;
}

if (!variable_instance_exists(id, "perch_x"))
{
    perch_x = 2;
}

if (!variable_instance_exists(id, "perch_y"))
{
    perch_y = -6;
}

if (!variable_instance_exists(id, "charge_perch_drop_per_level"))
{
    charge_perch_drop_per_level = 1.0;
}

if (!variable_instance_exists(id, "charge_perch_drop_max"))
{
    charge_perch_drop_max = 3;
}


// ====================================================
// HOT-RELOAD DEATH FUNCTION
// ====================================================

if (
    !variable_instance_exists(id, "bird_die") ||
    !is_callable(bird_die)
)
{
    bird_die = function()
    {
        if (bird_state == "dead")
        {
            return;
        }

        bird_state = "dead";

        bird_death_x = x;
        bird_death_y = y;

        bird_death_facing =
            sign(image_xscale);

        if (bird_death_facing == 0)
        {
            bird_death_facing = 1;
        }

        var _death_sprite =
            asset_get_index("spriteBirdDeath");

        if (_death_sprite != -1)
        {
            sprite_index = _death_sprite;

            image_index = 0;
            image_speed = 0.35;

            image_xscale =
                bird_death_facing;

            image_yscale = 1;
            image_angle  = 0;
            image_alpha  = 1;
            image_blend  = c_white;
        }
        else
        {
            image_speed = 0;
            image_alpha = 0;
        }

        last_owner_state = "dead";
    };
}


// ====================================================
// READ OWNER STATE
// ====================================================

var owner_state = "";

if (variable_instance_exists(owner, "state"))
{
    owner_state = owner.state;
}


// ====================================================
// AUTOMATIC DEATH SAFETY
// ====================================================

if (
    owner_state == "dead" &&
    bird_state != "dead"
)
{
    bird_die();
}


// ====================================================
// PLAYER RESPAWNED
//
// This must happen before the dead-state exit.
// ====================================================

if (
    owner_state != "dead" &&
    bird_state == "dead"
)
{
    bird_state = "alive";

    image_alpha  = 1;
    image_blend  = c_white;
    image_angle  = 0;
    image_yscale = 1;

    last_owner_state = "";
}


// ====================================================
// DEAD BIRD
// ====================================================

if (bird_state == "dead")
{
    x = bird_death_x;
    y = bird_death_y;

    image_xscale =
        bird_death_facing;

    exit;
}


// ====================================================
// SPRITE HELPER
// ====================================================

function __bird_sprite(_name)
{
    var _sprite =
        asset_get_index(_name);

    return
        (_sprite != -1)
        ? _sprite
        : -1;
}


// ====================================================
// OWNER FACING
// ====================================================

var dir = 1;

if (variable_instance_exists(owner, "facing"))
{
    dir = owner.facing;
}
else if (variable_instance_exists(owner, "image_xscale"))
{
    dir =
        (owner.image_xscale >= 0)
        ? 1
        : -1;
}

if (dir == 0)
{
    dir = 1;
}


// ====================================================
// BIRD SPRITES
// ====================================================

var sprIdle =
    __bird_sprite("spriteBirdIdle");

var sprCharge =
    __bird_sprite("spriteBirdJumpCharge");

var sprJumping =
    __bird_sprite("spriteBirdJumping");

var sprGlide =
    __bird_sprite("spriteBirdGliding");

var sprLanding =
    __bird_sprite("spriteBirdLanding");

var sprWallHit =
    __bird_sprite("spriteBirdWallHit");

var sprFallback =
    (sprWallHit != -1)
    ? sprWallHit
    : sprite_index;


// ====================================================
// CHOOSE BIRD STATE
// ====================================================

var st = owner_state;

if (
    variable_instance_exists(owner, "wallhit_timer") &&
    owner.wallhit_timer > 0
)
{
    st = "wallhit";
}

var target =
    sprFallback;

if (st == "jump_charge")
{
    target =
        (sprCharge != -1)
        ? sprCharge
        : sprFallback;
}
else if (st == "jumping")
{
    target =
        (sprJumping != -1)
        ? sprJumping
        : sprFallback;
}
else if (st == "glide")
{
    target =
        (sprGlide != -1)
        ? sprGlide
        : sprFallback;
}
else if (st == "landing")
{
    target =
        (sprLanding != -1)
        ? sprLanding
        : sprFallback;
}
else if (st == "wallhit")
{
    target =
        (sprWallHit != -1)
        ? sprWallHit
        : sprFallback;
}
else
{
    target =
        (sprIdle != -1)
        ? sprIdle
        : sprFallback;
}


// ====================================================
// CHANGE SPRITE
// ====================================================

if (
    target != -1 &&
    (
        st != last_owner_state ||
        sprite_index != target
    )
)
{
    sprite_index = target;

    image_index = 0;
    image_speed = 0.2;

    image_alpha = 1;

    last_owner_state = st;
}


// ====================================================
// SYNCHRONISE ANIMATION
// ====================================================

if (st == "jump_charge")
{
    image_speed = 0;

    if (variable_instance_exists(owner, "image_index"))
    {
        image_index =
            owner.image_index;
    }
}
else if (
    st == "jumping" ||
    st == "landing"
)
{
    if (variable_instance_exists(owner, "image_speed"))
    {
        image_speed =
            owner.image_speed;
    }

    if (variable_instance_exists(owner, "image_index"))
    {
        image_index =
            owner.image_index;
    }
}
else if (st == "wallhit")
{
    image_speed = 0;
    image_index = 0;
}
else
{
    if (sprite_index == sprIdle)
    {
        image_speed =
            bird_idle_anim_speed;
    }
}


image_xscale = dir;
image_yscale = 1;
image_angle  = 0;
image_alpha  = 1;
image_blend  = c_white;


// ====================================================
// OWNER DRAW POSITION
// ====================================================

var owner_draw_floor_inset = 0;

if (variable_instance_exists(owner, "draw_floor_inset"))
{
    owner_draw_floor_inset =
        owner.draw_floor_inset;
}

var owner_draw_x =
    owner.x;

var owner_draw_y =
    owner.y +
    owner_draw_floor_inset;


// ====================================================
// VALID OWNER SPRITE SAFETY
// ====================================================

var owner_sprite =
    owner.sprite_index;

if (owner_sprite == -1)
{
    owner_sprite =
        asset_get_index("spriteBotIdle");
}

if (owner_sprite == -1)
{
    exit;
}


// ====================================================
// CALCULATE OWNER VISUAL BOUNDS
// ====================================================

var owner_yoffset =
    sprite_get_yoffset(owner_sprite);

var owner_bbox_top =
    sprite_get_bbox_top(owner_sprite);

var owner_bbox_left =
    sprite_get_bbox_left(owner_sprite);

var owner_bbox_right =
    sprite_get_bbox_right(owner_sprite);

var owner_visual_top_y =
    owner_draw_y -
    owner_yoffset +
    owner_bbox_top;

var owner_visual_center_x =
    owner_draw_x -
    sprite_get_xoffset(owner_sprite) +
    (
        (
            owner_bbox_left +
            owner_bbox_right
        )
        *
        0.5
    );


// ====================================================
// EXTRA CHARGE DROP
// ====================================================

var charge_drop = 0;

if (st == "jump_charge")
{
    var level =
        variable_instance_exists(
            owner,
            "jump_charge_level"
        )
        ? owner.jump_charge_level
        : 0;

    charge_drop =
        min(
            charge_perch_drop_max,
            level *
            charge_perch_drop_per_level
        );
}


// ====================================================
// PERCH ANCHOR
// ====================================================

var anchor_x =
    owner_visual_center_x +
    (perch_x * dir);

var anchor_y =
    owner_visual_top_y +
    perch_y +
    charge_drop;


// ====================================================
// SNAP BIRD FEET TO ANCHOR
// ====================================================

if (sprite_index != -1)
{
    var bird_yoffset =
        sprite_get_yoffset(sprite_index);

    var bird_bbox_bottom =
        sprite_get_bbox_bottom(sprite_index);

    y =
        anchor_y -
        (
            bird_bbox_bottom -
            bird_yoffset
        );


    var bird_xoffset =
        sprite_get_xoffset(sprite_index);

    var bird_bbox_left =
        sprite_get_bbox_left(sprite_index);

    var bird_bbox_right =
        sprite_get_bbox_right(sprite_index);

    var bird_bbox_center =
        (
            bird_bbox_left +
            bird_bbox_right
        )
        *
        0.5;

    x =
        anchor_x -
        (
            bird_bbox_center -
            bird_xoffset
        );
}