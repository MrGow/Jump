/// oB1LL — Step

// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


// ====================================================
// LETTERBOX ANIMATION
// ====================================================

var letterbox_target =
    dialogue_active
    ? letterbox_height
    : 0;

letterbox_current =
    lerp(
        letterbox_current,
        letterbox_target,
        0.25
    );

// Snap when very close.
if (
    abs(
        letterbox_current -
        letterbox_target
    )
    < 0.5
)
{
    letterbox_current =
        letterbox_target;
}


// ====================================================
// DIALOGUE ACTIVE
// ====================================================

if (dialogue_active)
{
    // ------------------------------------------------
    // Lock ONLY the player
    // ------------------------------------------------
    if (instance_exists(sequence_player))
    {
        if (
            variable_instance_exists(
                sequence_player,
                "hsp"
            )
        )
        {
            sequence_player.hsp = 0;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "vsp"
            )
        )
        {
            sequence_player.vsp = 0;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "jump_charging"
            )
        )
        {
            sequence_player.jump_charging = false;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "jump_charge"
            )
        )
        {
            sequence_player.jump_charge = 0;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "jump_charge_level"
            )
        )
        {
            sequence_player.jump_charge_level = 0;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "standing_platform"
            )
        )
        {
            sequence_player.standing_platform =
                noone;
        }
    }


    // ------------------------------------------------
    // Dialogue alpha
    // ------------------------------------------------
    dialogue_alpha =
        min(
            1,
            dialogue_alpha + 0.12
        );


    // ------------------------------------------------
    // Minimum line timer
    // ------------------------------------------------
    if (dialogue_line_timer > 0)
    {
        dialogue_line_timer--;
    }


    // =================================================
    // CONFIRM INPUT
    // =================================================

    var confirm_held =
        keyboard_check(vk_space);

    var confirm_pressed =
        keyboard_check_pressed(vk_space) ||
        keyboard_check_pressed(vk_enter);

    for (
        var pad = 0;
        pad < 4;
        pad++
    )
    {
        if (!gamepad_is_connected(pad))
        {
            continue;
        }

        confirm_held =
            confirm_held ||
            gamepad_button_check(
                pad,
                gp_face1
            );

        confirm_pressed =
            confirm_pressed ||
            gamepad_button_check_pressed(
                pad,
                gp_face1
            );
    }

    if (
        variable_global_exists(
            "inp_jump_held"
        )
    )
    {
        confirm_held =
            confirm_held ||
            global.inp_jump_held;
    }

    if (
        variable_global_exists(
            "inp_jump_press"
        )
    )
    {
        confirm_pressed =
            confirm_pressed ||
            global.inp_jump_press;
    }


    // ------------------------------------------------
    // Require release first
    // ------------------------------------------------
    if (dialogue_wait_release)
    {
        if (!confirm_held)
        {
            dialogue_wait_release =
                false;

            dialogue_input_armed =
                true;
        }

        confirm_pressed =
            false;
    }


    // ------------------------------------------------
    // Advance dialogue
    // ------------------------------------------------
    if (
        dialogue_input_armed &&
        dialogue_line_timer <= 0 &&
        confirm_pressed
    )
    {
        dialogue_line++;

        dialogue_input_armed =
            false;

        dialogue_wait_release =
            true;

        dialogue_line_timer =
            dialogue_min_line_frames;

        if (
            dialogue_line >=
            array_length(
                dialogue_lines
            )
        )
        {
            end_dialogue();
        }
    }

    exit;
}


// ====================================================
// NOT TALKING
// ====================================================

if (
    dialogue_once &&
    dialogue_completed
)
{
    // Still allow stretching.
}
else if (
    p != noone &&
    !dialogue_triggered_this_visit
)
{
    var dist =
        point_distance(
            x,
            y,
            p.x,
            p.y
        );

    if (
        dist <= dialogue_range &&
        (
            !variable_instance_exists(
                p,
                "state"
            )
            ||
            p.state != "dead"
        )
    )
    {
        begin_dialogue(p);
        exit;
    }
}


// ====================================================
// IDLE STRETCHING
// ====================================================

if (b1ll_state == "idle")
{
    stretch_timer--;

    if (stretch_timer <= 0)
    {
        if (spr_stretching != -1)
        {
            b1ll_state =
                "stretching";

            sprite_index =
                spr_stretching;

            image_index = 0;
            image_speed = 1;
        }
        else
        {
            reset_stretch_timer();
        }
    }
}