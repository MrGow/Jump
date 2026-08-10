/// oDoubleJumper — Step


// ====================================================
// FREEZE DURING PAUSE / DEATH
// ====================================================

if (scr_game_frozen())
{
    image_speed = 0;
    exit;
}


// ====================================================
// RESUME / HOLD ANIMATION
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
// OVERLAP
// ====================================================

var touching =
    p.bbox_right  > bbox_left  &&
    p.bbox_left   < bbox_right &&
    p.bbox_bottom > bbox_top   &&
    p.bbox_top    < bbox_bottom;


if (!touching)
{
    // Leaving the jumper rearms it.
    used_this_contact = false;
}


// ====================================================
// DETERMINE WHETHER PLAYER IS AIRBORNE
// ====================================================

var player_airborne = true;


// Prefer player's existing ground test state if present.
if (
    variable_instance_exists(
        p,
        "prev_on_ground"
    )
)
{
    player_airborne =
        !p.prev_on_ground;
}
else
{
    // Simple fallback.
    player_airborne =
        abs(p.vsp) > 0.01;
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
// ACTIVATE DOUBLE JUMP
// ====================================================

if (
    touching &&
    player_airborne &&
    jump_pressed &&
    !used_this_contact
)
{
    // ------------------------------------------------
    // Vertical boost
    //
    // Preserve horizontal momentum.
    // Replace only vertical momentum.
    // ------------------------------------------------
    p.vsp =
        -abs(double_jump_power);


    // =================================================
    // PLAYER STATE
    // ====================================================

    if (
        variable_instance_exists(
            p,
            "state"
        )
    )
    {
        p.state = "jumping";
    }


    // ------------------------------------------------
    // Cancel charge jump state
    // ------------------------------------------------
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


    // ------------------------------------------------
    // Remove platform/ground ownership
    // ------------------------------------------------
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
            "support_grace"
        )
    )
    {
        p.support_grace = 0;
    }


    if (
        variable_instance_exists(
            p,
            "support_stable_frames"
        )
    )
    {
        p.support_stable_frames = 0;
    }


    if (
        variable_instance_exists(
            p,
            "ground_frames"
        )
    )
    {
        p.ground_frames = 0;
    }


    // ------------------------------------------------
    // Cancel existing bounce state
    // ------------------------------------------------
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
            "bounce_v"
        )
    )
    {
        p.bounce_v = 0;
    }


    // ------------------------------------------------
    // Reinforce airborne state
    // ------------------------------------------------
    if (
        variable_instance_exists(
            p,
            "prev_on_ground"
        )
    )
    {
        p.prev_on_ground = false;
    }


    if (
        variable_instance_exists(
            p,
            "airborne_frames"
        )
    )
    {
        p.airborne_frames =
            max(
                1,
                p.airborne_frames
            );
    }


    // ------------------------------------------------
    // Keep jump pose visible
    // ------------------------------------------------
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
    // ====================================================

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
            p.image_speed = 1;
        }
    }


    // =================================================
    // PLAY DOUBLE-JUMPER USE ANIMATION
    // ====================================================

    use_anim_playing = true;

    image_index = 0;

    image_speed =
        use_anim_speed;


    // Prevent repeated activation while still touching.
    used_this_contact = true;
}


// ====================================================
// STORE INPUT
// ====================================================

was_jump_held =
    jump_held;