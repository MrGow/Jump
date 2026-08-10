/// oDirectionalJumper — Step


// ====================================================
// FREEZE DURING PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    // Pause the current use animation without losing
    // which frame it had reached.
    image_speed = 0;

    exit;
}


// ====================================================
// RESUME ACTIVE USE ANIMATION AFTER UNFREEZE
// ====================================================

if (use_anim_playing)
{
    image_speed =
        use_anim_speed;
}
else
{
    image_speed = 0;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    used_this_contact = false;

    image_speed = 0;

    exit;
}


// ====================================================
// KEEP EDITOR SETTINGS VALID
// ====================================================

update_rotation();


// ====================================================
// FIND LIVING PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    used_this_contact = false;

    exit;
}


if (
    variable_instance_exists(
        p,
        "state"
    )
    &&
    p.state == "dead"
)
{
    used_this_contact = false;

    exit;
}


// ====================================================
// PLAYER OVERLAP
// ====================================================

var touching =
    p.bbox_right  > bbox_left  &&
    p.bbox_left   < bbox_right &&
    p.bbox_bottom > bbox_top   &&
    p.bbox_top    < bbox_bottom;


if (!touching)
{
    used_this_contact = false;
}


// ====================================================
// JUMP INPUT
// ====================================================

var jump_held =
    keyboard_check(vk_space) ||
    keyboard_check(vk_up);


if (
    variable_global_exists(
        "inp_jump_held"
    )
)
{
    jump_held =
        global.inp_jump_held;
}


var jump_pressed =
    jump_held &&
    !was_jump_held;


// ====================================================
// ACTIVATE DIRECTIONAL LAUNCH
// ====================================================

if (
    touching &&
    jump_pressed &&
    !used_this_contact
)
{
    // ------------------------------------------------
    // Validate settings
    // ------------------------------------------------
    jump_direction =
        ((round(jump_direction) mod 8) + 8) mod 8;

    jump_strength =
        clamp(
            round(jump_strength),
            1,
            10
        );


    // ------------------------------------------------
    // Calculate launch
    // ------------------------------------------------
    var launch_angle =
        jump_direction * 45;


    var launch_speed =
        minimum_launch_speed +
        (
            (jump_strength - 1)
            *
            speed_per_level
        );


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


    // ------------------------------------------------
    // Replace incoming momentum
    // ------------------------------------------------
    p.hsp = launch_x;
    p.vsp = launch_y;


    // =================================================
    // PLAY JUMPER USE ANIMATION
    // =================================================

    use_anim_playing = true;

    image_index = 0;

    image_speed =
        use_anim_speed;


    // =================================================
    // RESET PLAYER'S NORMAL JUMP STATE
    // =================================================

    if (
        variable_instance_exists(
            p,
            "state"
        )
    )
    {
        p.state = "jumping";
    }


    if (
        variable_instance_exists(
            p,
            "jump_charging"
        )
    )
    {
        p.jump_charging = false;
    }


    if (
        variable_instance_exists(
            p,
            "jump_charge"
        )
    )
    {
        p.jump_charge = 0;
    }


    if (
        variable_instance_exists(
            p,
            "jump_charge_level"
        )
    )
    {
        p.jump_charge_level = 0;
    }


    if (
        variable_instance_exists(
            p,
            "jump_charge_sfx_last"
        )
    )
    {
        p.jump_charge_sfx_last = 0;
    }


    if (
        variable_instance_exists(
            p,
            "standing_platform"
        )
    )
    {
        p.standing_platform =
            noone;
    }


    if (
        variable_instance_exists(
            p,
            "coyote_timer"
        )
    )
    {
        p.coyote_timer = 0;
    }


    if (
        variable_instance_exists(
            p,
            "bounce_pending"
        )
    )
    {
        p.bounce_pending = false;
    }


    if (
        variable_instance_exists(
            p,
            "bounce_timer"
        )
    )
    {
        p.bounce_timer = 0;
    }


    if (
        variable_instance_exists(
            p,
            "jump_pose_timer"
        )
    )
    {
        if (
            variable_instance_exists(
                p,
                "jump_pose_min_frames"
            )
        )
        {
            p.jump_pose_timer =
                p.jump_pose_min_frames;
        }
        else
        {
            p.jump_pose_timer = 20;
        }
    }


    // =================================================
    // PLAYER JUMP SPRITE
    // =================================================

    var jump_sprite =
        asset_get_index(
            "spriteBotJumping"
        );


    if (jump_sprite != -1)
    {
        p.sprite_index =
            jump_sprite;

        p.image_index = 0;


        if (
            variable_instance_exists(
                p,
                "jump_anim_speed"
            )
        )
        {
            p.image_speed =
                p.jump_anim_speed;
        }
        else
        {
            p.image_speed = 0.35;
        }
    }


    // =================================================
    // FACE PLAYER TOWARD HORIZONTAL LAUNCH
    // =================================================

    if (
        variable_instance_exists(
            p,
            "facing"
        )
        &&
        abs(launch_x) > 0.01
    )
    {
        p.facing =
            sign(launch_x);

        p.image_xscale =
            p.facing;
    }


    // Prevent repeated activation while still
    // overlapping this same jumper.
    used_this_contact = true;
}


// ====================================================
// STORE INPUT FOR NEXT STEP
// ====================================================

was_jump_held =
    jump_held;