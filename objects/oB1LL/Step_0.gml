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
// PAUSE MENU FREEZE
//
// B1LL-E should completely stop updating while the
// pause menu is open. Dialogue itself cannot be paused,
// so this only affects his normal idle / malfunction /
// stretch behaviour.
//
// Step timers are frozen by exiting here, while
// image_speed is explicitly set to 0 so GameMaker does
// not continue advancing the current sprite animation.
// ====================================================

if (!variable_instance_exists(id, "b1ll_pause_was_active"))
{
    b1ll_pause_was_active =
        false;
}

if (!variable_instance_exists(id, "b1ll_pause_saved_image_speed"))
{
    b1ll_pause_saved_image_speed =
        image_speed;
}


var b1ll_game_paused =
    variable_global_exists(
        "game_phase"
    )
    &&
    global.game_phase ==
        "paused";


if (b1ll_game_paused)
{
    if (!b1ll_pause_was_active)
    {
        b1ll_pause_was_active =
            true;

        b1ll_pause_saved_image_speed =
            image_speed;
    }


    image_speed =
        0;


    exit;
}


// ----------------------------------------------------
// Restore exactly the animation speed B1LL-E had when
// the pause menu opened.
// ----------------------------------------------------

if (b1ll_pause_was_active)
{
    b1ll_pause_was_active =
        false;

    image_speed =
        b1ll_pause_saved_image_speed;
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
            bob_step *
            dialogue_bob_speed;


        while (
            b1ll_bob_phase >=
            bob_frame_count
        )
        {
            b1ll_bob_phase -=
                bob_frame_count;
        }


        while (
            b1ll_bob_phase < 0
        )
        {
            b1ll_bob_phase +=
                bob_frame_count;
        }
    }


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
// FLOAT LOOP DISTANCE VOLUME
//
// Very quiet nearby mechanical presence.
// ====================================================

if (
    b1ll_float_voice != noone &&
    audio_is_playing(
        b1ll_float_voice
    )
)
{
    var target_float_gain =
        0;


    if (p != noone)
    {
        var float_dist =
            point_distance(
                x,
                y,
                p.x,
                p.y
            );


        var float_range =
            max(
                1,
                float_far_dist -
                float_near_dist
            );


        var float_t =
            1 -
            clamp(
                (
                    float_dist -
                    float_near_dist
                )
                /
                float_range,
                0,
                1
            );


        // Squaring makes the sound fall away more
        // strongly at medium/far range.
        float_t *=
            float_t;


        target_float_gain =
            float_gain_max *
            float_t;
    }


    // Short gain ramp avoids audible volume stepping.
    audio_sound_gain(
        b1ll_float_voice,
        target_float_gain,
        80
    );
}


// ====================================================
// STRETCH SOUND DISTANCE VOLUME
//
// B1LL-E's stretch carries much farther than his
// normal floating ambience.
//
// Full volume nearby.
// Smooth falloff after stretch_near_dist.
// Silent at stretch_far_dist.
// ====================================================

if (b1ll_stretch_voice != noone)
{
    if (
        audio_is_playing(
            b1ll_stretch_voice
        )
    )
    {
        var target_stretch_gain =
            0;


        if (p != noone)
        {
            var stretch_dist =
                point_distance(
                    x,
                    y,
                    p.x,
                    p.y
                );


            var stretch_range =
                max(
                    1,
                    stretch_far_dist -
                    stretch_near_dist
                );


            var stretch_t =
                1 -
                clamp(
                    (
                        stretch_dist -
                        stretch_near_dist
                    )
                    /
                    stretch_range,
                    0,
                    1
                );


            // Stronger falloff through the middle and
            // far portions of the audible range.
            stretch_t *=
                stretch_t;


            target_stretch_gain =
                stretch_gain_max *
                stretch_t;
        }


        audio_sound_gain(
            b1ll_stretch_voice,
            target_stretch_gain,
            80
        );
    }
    else
    {
        b1ll_stretch_voice =
            noone;
    }
}


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
            0;


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
            0;
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
        if (sprite_index == spr_idle)
        {
            b1ll_bob_phase =
                image_index;
        }


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
    // TALK AUDIO
    // ====================================================

    if (!text_line_complete)
    {
        var talk_playing =
            b1ll_talk_voice != noone &&
            audio_is_playing(
                b1ll_talk_voice
            );


        if (
            !talk_playing &&
            text_pause_timer <= 0
        )
        {
            b1ll_talk_voice =
                noone;


            reset_talk_switch_window();


            play_random_talk_sound();
        }
    }
    else
    {
        if (
            b1ll_talk_voice != noone &&
            audio_is_playing(
                b1ll_talk_voice
            )
        )
        {
            stop_talk_audio();
        }
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
                // CURRENT CHARACTER
                // =====================================

                var current_char =
                    string_char_at(
                        full_line,
                        text_visible_chars
                    );


                if (
                    current_char != " " &&
                    current_char != "\t" &&
                    current_char != "\n" &&
                    current_char != "\r"
                )
                {
                    talk_chars_since_switch++;


                    if (
                        talk_chars_since_switch >=
                        talk_next_switch_chars
                    )
                    {
                        talk_switch_pending =
                            true;
                    }
                }


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
    // CHARACTER-DRIVEN TALK SOUND SWITCH
    // ====================================================

    if (
        !text_line_complete &&
        talk_switch_pending &&
        text_pause_timer <= 0
    )
    {
        reset_talk_switch_window();


        play_random_talk_sound();
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
    b1ll_state != "waiting_for_land"
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
// IDLE MALFUNCTION
// ====================================================

if (
    b1ll_state == "idle" &&
    !dialogue_active
)
{
    malfunction_timer--;


    if (malfunction_timer <= 0)
    {
        if (snd_b1ll_malfunction != -1)
        {
            if (
                b1ll_malfunction_voice == noone ||
                !audio_is_playing(
                    b1ll_malfunction_voice
                )
            )
            {
                b1ll_malfunction_voice =
                    audio_play_sound(
                        snd_b1ll_malfunction,
                        4,
                        false
                    );


                if (
                    b1ll_malfunction_voice != noone
                )
                {
                    audio_sound_gain(
                        b1ll_malfunction_voice,
                        malfunction_gain,
                        0
                    );
                }
            }
        }


        reset_malfunction_timer();
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


            // =========================================
            // STRETCH SOUND
            //
            // Calculate the correct volume BEFORE the
            // one-shot starts so there is no full-volume
            // frame when B1LL-E is far away.
            // =========================================

            if (snd_b1ll_stretch != -1)
            {
                var initial_stretch_gain =
                    0;


                if (p != noone)
                {
                    var initial_stretch_dist =
                        point_distance(
                            x,
                            y,
                            p.x,
                            p.y
                        );


                    var initial_stretch_range =
                        max(
                            1,
                            stretch_far_dist -
                            stretch_near_dist
                        );


                    var initial_stretch_t =
                        1 -
                        clamp(
                            (
                                initial_stretch_dist -
                                stretch_near_dist
                            )
                            /
                            initial_stretch_range,
                            0,
                            1
                        );


                    initial_stretch_t *=
                        initial_stretch_t;


                    initial_stretch_gain =
                        stretch_gain_max *
                        initial_stretch_t;
                }


                b1ll_stretch_voice =
                    audio_play_sound(
                        snd_b1ll_stretch,
                        4,
                        false
                    );


                if (b1ll_stretch_voice != noone)
                {
                    audio_sound_gain(
                        b1ll_stretch_voice,
                        initial_stretch_gain,
                        0
                    );
                }
            }
        }
        else
        {
            reset_stretch_timer();
        }
    }
}