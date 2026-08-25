/// oB1LL — Step


// ====================================================
// GLOBAL SAFETY
// ====================================================

if (!variable_global_exists("npc_dialogue_active"))
{
    global.npc_dialogue_active =
        false;
}

if (!variable_global_exists("inp_jump_block_until_release"))
{
    global.inp_jump_block_until_release =
        false;
}


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
        letterbox_lerp
    );


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
// WAITING FOR PLAYER TO LAND
// ====================================================

if (
    b1ll_state ==
    "waiting_for_land"
)
{
    if (!instance_exists(sequence_player))
    {
        b1ll_state =
            "idle";

        sprite_index =
            spr_idle;

        image_index =
            0;

        image_speed =
            1;

        global.npc_dialogue_active =
            false;

        reset_stretch_timer();

        exit;
    }


    // ------------------------------------------------
    // No player control, but physics continues.
    // ------------------------------------------------

    global.npc_dialogue_active =
        true;

    sequence_player.dialogue_locked =
        false;

    sequence_player.hsp =
        0;


    if (
        variable_instance_exists(
            sequence_player,
            "jump_charging"
        )
    )
    {
        sequence_player.jump_charging =
            false;
    }

    if (
        variable_instance_exists(
            sequence_player,
            "jump_charge"
        )
    )
    {
        sequence_player.jump_charge =
            0;
    }

    if (
        variable_instance_exists(
            sequence_player,
            "jump_charge_level"
        )
    )
    {
        sequence_player.jump_charge_level =
            0;
    }


    // ------------------------------------------------
    // B1LL waits in idle animation.
    // ------------------------------------------------

    if (sprite_index != spr_idle)
    {
        sprite_index =
            spr_idle;

        image_index =
            0;
    }

    image_speed =
        1;


    // ------------------------------------------------
    // Has JumpBot landed?
    // ------------------------------------------------

    var grounded_now =
        variable_instance_exists(
            sequence_player,
            "prev_on_ground"
        )
        &&
        sequence_player.prev_on_ground;


    if (
        !grounded_now &&
        variable_instance_exists(
            sequence_player,
            "standing_platform"
        ) &&
        instance_exists(
            sequence_player.standing_platform
        )
    )
    {
        grounded_now =
            true;
    }


    if (grounded_now)
    {
        start_talking();
    }


    exit;
}


// ====================================================
// DIALOGUE ACTIVE
// ====================================================

if (dialogue_active)
{
    global.npc_dialogue_active =
        true;


    // ------------------------------------------------
    // Keep player locked.
    // ------------------------------------------------

    if (instance_exists(sequence_player))
    {
        sequence_player.dialogue_locked =
            true;

        sequence_player.hsp =
            0;

        sequence_player.vsp =
            0;


        if (
            variable_instance_exists(
                sequence_player,
                "jump_charging"
            )
        )
        {
            sequence_player.jump_charging =
                false;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "jump_charge"
            )
        )
        {
            sequence_player.jump_charge =
                0;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "jump_charge_level"
            )
        )
        {
            sequence_player.jump_charge_level =
                0;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "jump_charge_sfx_last"
            )
        )
        {
            sequence_player.jump_charge_sfx_last =
                0;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "prev_jump_h"
            )
        )
        {
            sequence_player.prev_jump_h =
                true;
        }

        if (
            variable_instance_exists(
                sequence_player,
                "state"
            ) &&
            sequence_player.state ==
                "jump_charge"
        )
        {
            sequence_player.state =
                "idle";
        }
    }


    // ------------------------------------------------
    // Dialogue fade
    // ------------------------------------------------

    dialogue_alpha =
        min(
            1,
            dialogue_alpha +
            0.12
        );


    if (dialogue_line_timer > 0)
    {
        dialogue_line_timer--;
    }


    // =================================================
    // TYPEWRITER UPDATE
    // =================================================

    if (
        dialogue_line >= 0 &&
        dialogue_line <
            array_length(
                dialogue_lines
            )
    )
    {
        var full_line =
            string(
                dialogue_lines[
                    dialogue_line
                ]
            );

        var full_length =
            string_length(
                full_line
            );


        // ---------------------------------------------
        // Punctuation pause
        // ---------------------------------------------

        if (text_pause_timer > 0)
        {
            text_pause_timer--;
        }


        // ---------------------------------------------
        // Reveal characters
        // ---------------------------------------------

        else if (!text_line_complete)
        {
            text_char_accumulator +=
                max(
                    1,
                    text_chars_per_second
                )
                /
                max(
                    1,
                    room_speed
                );


            while (
                text_char_accumulator >= 1 &&
                !text_line_complete &&
                text_pause_timer <= 0
            )
            {
                text_char_accumulator -=
                    1;

                text_visible_chars++;


                // =====================================
                // CURRENT LINE FINISHED
                // =====================================

                if (
                    text_visible_chars >=
                    full_length
                )
                {
                    text_visible_chars =
                        full_length;

                    text_line_complete =
                        true;

                    text_char_accumulator =
                        0;

                    text_pause_timer =
                        0;


                    // ---------------------------------
                    // B1LL has finished speaking.
                    //
                    // Return to idle until the player
                    // asks for the next line.
                    // ---------------------------------

                    b1ll_state =
                        "idle";

                    if (spr_idle != -1)
                    {
                        sprite_index =
                            spr_idle;

                        image_index =
                            0;

                        image_speed =
                            1;
                    }


                    break;
                }


                // =====================================
                // PUNCTUATION PAUSES
                // =====================================

                var current_char =
                    string_char_at(
                        full_line,
                        text_visible_chars
                    );


                if (
                    current_char == "," ||
                    current_char == ";" ||
                    current_char == ":"
                )
                {
                    text_pause_timer =
                        max(
                            1,
                            round(
                                room_speed *
                                text_comma_pause
                            )
                        );

                    break;
                }


                if (
                    current_char == "." ||
                    current_char == "!" ||
                    current_char == "?"
                )
                {
                    text_pause_timer =
                        max(
                            1,
                            round(
                                room_speed *
                                text_sentence_pause
                            )
                        );

                    break;
                }
            }
        }
    }


    // =================================================
    // DIALOGUE INPUT
    // =================================================

    var confirm_pressed =
        variable_global_exists(
            "inp_menu_confirm_press"
        )
        &&
        global.inp_menu_confirm_press;


    var confirm_held =
        keyboard_check(vk_space) ||
        keyboard_check(vk_enter);


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
    }


    // ------------------------------------------------
    // Require release
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


    // =================================================
    // CONFIRM
    // =================================================

    if (
        dialogue_input_armed &&
        dialogue_line_timer <= 0 &&
        confirm_pressed
    )
    {
        // ---------------------------------------------
        // TEXT STILL TYPING
        //
        // First confirm completes current line.
        // ---------------------------------------------

        if (!text_line_complete)
        {
            complete_typewriter_line();


            dialogue_input_armed =
                false;

            dialogue_wait_release =
                true;
        }


        // ---------------------------------------------
        // CURRENT LINE ALREADY COMPLETE
        //
        // Advance to next line.
        // ---------------------------------------------

        else
        {
            dialogue_line++;


            dialogue_input_armed =
                false;

            dialogue_wait_release =
                true;

            dialogue_line_timer =
                dialogue_min_line_frames;


            // -----------------------------------------
            // Dialogue finished
            // -----------------------------------------

            if (
                dialogue_line >=
                array_length(
                    dialogue_lines
                )
            )
            {
                end_dialogue();
            }


            // -----------------------------------------
            // Next line begins.
            //
            // This switches B1LL back into talking
            // animation automatically.
            // -----------------------------------------

            else
            {
                reset_typewriter_line();
            }
        }
    }


    exit;
}


// ====================================================
// NOT TALKING
// ====================================================

if (
    global.npc_dialogue_active &&
    !dialogue_active &&
    b1ll_state !=
        "waiting_for_land"
)
{
    global.npc_dialogue_active =
        false;
}


// ====================================================
// DIALOGUE PROXIMITY
// ====================================================

if (
    !(dialogue_once && dialogue_completed) &&
    p != noone
)
{
    var player_alive =
        !variable_instance_exists(
            p,
            "state"
        )
        ||
        p.state !=
            "dead";


    if (player_alive)
    {
        var dist =
            point_distance(
                x,
                y,
                p.x,
                p.y
            );


        if (dist <= dialogue_range)
        {
            begin_dialogue(p);

            exit;
        }
    }
}


// ====================================================
// IDLE STRETCH
//
// Stretching is ONLY allowed outside dialogue.
// ====================================================

if (
    b1ll_state == "idle" &&
    !dialogue_active
)
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

            image_index =
                0;

            image_speed =
                1;
        }
        else
        {
            reset_stretch_timer();
        }
    }
}