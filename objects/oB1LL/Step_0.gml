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
// CONTINUOUS IDLE-BOB CLOCK
// ====================================================

if (spr_idle != -1)
{
    var bob_frame_count =
        max(
            1,
            sprite_get_number(
                spr_idle
            )
        );


    if (sprite_index == spr_idle)
    {
        // Real idle sprite is authoritative.
        b1ll_bob_phase =
            image_index;
    }
    else
    {
        var bob_sprite_speed =
            sprite_get_speed(
                spr_idle
            );


        var bob_speed_type =
            sprite_get_speed_type(
                spr_idle
            );


        var bob_step =
            0;


        if (
            bob_speed_type ==
            spritespeed_framespersecond
        )
        {
            bob_step =
                bob_sprite_speed /
                max(
                    1,
                    room_speed
                );
        }
        else
        {
            bob_step =
                bob_sprite_speed;
        }


        b1ll_bob_phase +=
            bob_step;


        while (
            b1ll_bob_phase >=
            bob_frame_count
        )
        {
            b1ll_bob_phase -=
                bob_frame_count;
        }


        while (b1ll_bob_phase < 0)
        {
            b1ll_bob_phase +=
                bob_frame_count;
        }
    }


    // ------------------------------------------------
    // Dialogue-only external bob
    // ------------------------------------------------

    var bob_cycle =
        (
            b1ll_bob_phase /
            bob_frame_count
        )
        *
        pi *
        2;


    bob_cycle +=
        dialogue_bob_phase_offset;


    b1ll_bob_draw_y =
        round(
            -sin(
                bob_cycle
            )
            *
            dialogue_bob_height
        );
}
else
{
    b1ll_bob_phase =
        0;


    b1ll_bob_draw_y =
        0;
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
// LETTERBOX
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

if (b1ll_state == "waiting_for_land")
{
    if (!instance_exists(sequence_player))
    {
        b1ll_state =
            "idle";


        sprite_index =
            spr_idle;


        image_index =
            talk_start_idle_frame;


        image_speed =
            1;


        global.npc_dialogue_active =
            false;


        reset_stretch_timer();


        exit;
    }


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


    if (sprite_index != spr_idle)
    {
        sprite_index =
            spr_idle;


        image_index =
            talk_start_idle_frame;
    }


    image_speed =
        1;


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
        prepare_talking();
    }


    exit;
}


// ====================================================
// WAIT FOR NEUTRAL IDLE TALK POSE
// ====================================================

if (b1ll_state == "waiting_for_talk_pose")
{
    if (!instance_exists(sequence_player))
    {
        b1ll_state =
            "idle";


        global.npc_dialogue_active =
            false;


        exit;
    }


    global.npc_dialogue_active =
        true;


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


    if (sprite_index != spr_idle)
    {
        sprite_index =
            spr_idle;


        image_index =
            talk_start_idle_frame;
    }


    image_speed =
        1;


    var idle_frames =
        max(
            1,
            sprite_get_number(
                spr_idle
            )
        );


    var neutral_idle_frame =
        clamp(
            talk_start_idle_frame,
            0,
            idle_frames - 1
        );


    if (
        floor(image_index) ==
        neutral_idle_frame
    )
    {
        // Preserve exact bob phase before switching.
        b1ll_bob_phase =
            image_index;


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


    // =================================================
    // LOCK PLAYER
    // ====================================================

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


    // =================================================
    // DIALOGUE FADE
    // ====================================================

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
    // TYPEWRITER
    // ====================================================

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


        if (text_pause_timer > 0)
        {
            text_pause_timer--;
        }
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
                // LINE FINISHED
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


                    freeze_talking_pose();


                    break;
                }


                // =====================================
                // PUNCTUATION
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
    // INPUT
    // ====================================================

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
    // ====================================================

    if (
        dialogue_input_armed &&
        dialogue_line_timer <= 0 &&
        confirm_pressed
    )
    {
        if (!text_line_complete)
        {
            complete_typewriter_line();


            dialogue_input_armed =
                false;


            dialogue_wait_release =
                true;
        }
        else
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
            else
            {
                reset_typewriter_line();
            }
        }
    }


    exit;
}


// ====================================================
// GLOBAL DIALOGUE CLEANUP
// ====================================================

if (
    global.npc_dialogue_active &&
    !dialogue_active &&
    b1ll_state != "waiting_for_land" &&
    b1ll_state != "waiting_for_talk_pose"
)
{
    global.npc_dialogue_active =
        false;
}


// ====================================================
// DIALOGUE PROXIMITY
// ====================================================

if (
    b1ll_state == "idle" &&
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