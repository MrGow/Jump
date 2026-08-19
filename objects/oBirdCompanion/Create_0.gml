/// oBirdCompanion — Create

owner = noone;
depth = -10001;


// ====================================================
// PERCH TUNING
// ====================================================

perch_x = 2;
perch_y = -6;

// Extra drop while bot is charging jump.
charge_perch_drop_per_level = 1.0;
charge_perch_drop_max       = 3;


// ====================================================
// ANIMATION
// ====================================================

bird_idle_anim_speed = 1;

var _starting_sprite =
    asset_get_index("spriteBirdWallHit");

if (_starting_sprite == -1)
{
    _starting_sprite =
        asset_get_index("spriteBirdIdle");
}

if (_starting_sprite != -1)
{
    sprite_index = _starting_sprite;
}

image_index  = 0;
image_speed  = 0.2;
image_xscale = 1;
image_yscale = 1;
image_angle  = 0;
image_alpha  = 1;
image_blend  = c_white;

last_owner_state = "";


// ====================================================
// BIRD DEATH STATE
// ====================================================

bird_state = "alive";

bird_death_x = x;
bird_death_y = y;

bird_death_facing = 1;

// Fall deaths keep the bird's death animation alongside
// the falling player instead of leaving it suspended at
// the point where the death zone was touched.
bird_death_follow_owner = false;
bird_death_owner_offset_x = 0;
bird_death_owner_offset_y = 0;


// ====================================================
// BIRD DEATH FUNCTION
//
// The owner remains assigned. This allows the same bird
// instance to return when the player respawns.
// ====================================================

bird_die = function()
{
    if (bird_state == "dead")
    {
        return;
    }

    bird_state = "dead";

    bird_death_x = x;
    bird_death_y = y;

    bird_death_follow_owner =
        instance_exists(owner) &&
        variable_instance_exists(owner, "death_fall") &&
        owner.death_fall;

    if (bird_death_follow_owner)
    {
        bird_death_owner_offset_x = x - owner.x;
        bird_death_owner_offset_y = y - owner.y;
    }

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
        image_speed = 1;

        image_xscale =
            bird_death_facing;

        image_yscale = 1;
        image_angle  = 0;
        image_alpha  = 1;
        image_blend  = c_white;
    }
    else
    {
        // No death sprite exists, so simply hide the bird
        // until the player respawns.
        image_speed = 0;
        image_alpha = 0;
    }

    last_owner_state = "dead";
};