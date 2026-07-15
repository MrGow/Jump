/// oDirectionalJumper — Step

// ----------------------------------------------------
// Freeze during pause/death
// ----------------------------------------------------
if (scr_game_frozen())
{
    exit;
}

if (!enabled)
{
    used_this_contact = false;
    exit;
}

// Keep direction, strength and sprite rotation valid.
update_rotation();


// ----------------------------------------------------
// Find living player
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);

if (p == noone)
{
    used_this_contact = false;
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    used_this_contact = false;
    exit;
}


// ----------------------------------------------------
// Check overlap
// ----------------------------------------------------
var touching =
    p.bbox_right  > bbox_left  &&
    p.bbox_left   < bbox_right &&
    p.bbox_bottom > bbox_top   &&
    p.bbox_top    < bbox_bottom;

if (!touching)
{
    used_this_contact = false;
}


// ----------------------------------------------------
// Jump input
// ----------------------------------------------------
var jump_held =
    keyboard_check(vk_space) ||
    keyboard_check(vk_up);

if (variable_global_exists("inp_jump_held"))
{
    jump_held = global.inp_jump_held;
}

var jump_pressed =
    jump_held &&
    !was_jump_held;


// ----------------------------------------------------
// Activate directional launch
// ----------------------------------------------------
if (
    touching &&
    jump_pressed &&
    !used_this_contact
)
{
    jump_direction =
        ((round(jump_direction) mod 8) + 8) mod 8;

    jump_strength =
        clamp(round(jump_strength), 1, 10);

    var launch_angle =
        jump_direction * 45;

    var launch_speed =
        minimum_launch_speed +
        ((jump_strength - 1) * speed_per_level);

    var launch_x =
        lengthdir_x(
            launch_speed,
            launch_angle
        );

    var launch_y =
        lengthdir_y(
            launch_speed,
            launch_angle
        );

    // Replace incoming momentum with a clean launch.
    p.hsp = launch_x;
    p.vsp = launch_y;

    // ------------------------------------------------
    // Reset normal jump state
    // ------------------------------------------------
    if (variable_instance_exists(p, "state"))
    {
        p.state = "jumping";
    }

    if (variable_instance_exists(p, "jump_charging"))
    {
        p.jump_charging = false;
    }

    if (variable_instance_exists(p, "jump_charge"))
    {
        p.jump_charge = 0;
    }

    if (variable_instance_exists(p, "jump_charge_level"))
    {
        p.jump_charge_level = 0;
    }

    if (variable_instance_exists(p, "jump_charge_sfx_last"))
    {
        p.jump_charge_sfx_last = 0;
    }

    if (variable_instance_exists(p, "standing_platform"))
    {
        p.standing_platform = noone;
    }

    if (variable_instance_exists(p, "coyote_timer"))
    {
        p.coyote_timer = 0;
    }

    if (variable_instance_exists(p, "bounce_pending"))
    {
        p.bounce_pending = false;
    }

    if (variable_instance_exists(p, "bounce_timer"))
    {
        p.bounce_timer = 0;
    }

    if (variable_instance_exists(p, "jump_pose_timer"))
    {
        if (variable_instance_exists(p, "jump_pose_min_frames"))
        {
            p.jump_pose_timer =
                p.jump_pose_min_frames;
        }
        else
        {
            p.jump_pose_timer = 20;
        }
    }

    // ------------------------------------------------
    // Jump sprite
    // ------------------------------------------------
    var jump_sprite =
        asset_get_index("spriteBotJumping");

    if (jump_sprite != -1)
    {
        p.sprite_index = jump_sprite;
        p.image_index  = 0;

        if (variable_instance_exists(p, "jump_anim_speed"))
        {
            p.image_speed =
                p.jump_anim_speed;
        }
        else
        {
            p.image_speed = 0.35;
        }
    }

    // Face towards horizontal launch direction.
    if (
        variable_instance_exists(p, "facing") &&
        abs(launch_x) > 0.01
    )
    {
        p.facing = sign(launch_x);
        p.image_xscale = p.facing;
    }

    used_this_contact = true;
}

was_jump_held = jump_held;