/// oCodec — Step


// ====================================================
// INITIALIZATION SAFETY
// ====================================================

if (
    !variable_instance_exists(
        id,
        "codec_initialized"
    ) ||
    !codec_initialized
)
{
    instance_destroy();
    exit;
}


// ====================================================
// INPUT
// ====================================================

if (input_lock_frames > 0)
{
    input_lock_frames--;
}


var confirm_held =
    keyboard_check(vk_space) ||
    keyboard_check(vk_enter);


// ----------------------------------------------------
// GAMEPAD A
// ----------------------------------------------------

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


    if (
        gamepad_button_check(
            pad,
            gp_face1
        )
    )
    {
        confirm_held = true;

        break;
    }
}


// Fresh press only.
var confirm_pressed =
    confirm_held &&
    !codec_confirm_was_held;


codec_confirm_was_held =
    confirm_held;


if (input_lock_frames > 0)
{
    confirm_pressed = false;
}


// ====================================================
// JUMPBOT VIDEO FEED ANIMATION
// ====================================================

if (jumpbot_sprite != -1)
{
    if (jumpbot_feed_hold_timer > 0)
    {
        jumpbot_feed_hold_timer--;
    }
    else
    {
        if (codec_state == 2)
        {
            if (jumpbot_feed_hold_wait_timer > 0)
            {
                jumpbot_feed_hold_wait_timer--;
            }
            else
            {
                jumpbot_feed_hold_timer =
                    irandom_range(
                        jumpbot_feed_hold_min,
                        jumpbot_feed_hold_max
                    );


                jumpbot_feed_hold_wait_timer =
                    irandom_range(
                        jumpbot_feed_hold_wait_min,
                        jumpbot_feed_hold_wait_max
                    );
            }
        }


        jumpbot_feed_timer++;


        if (
            jumpbot_feed_timer >=
            jumpbot_feed_frame_interval
        )
        {
            jumpbot_feed_timer = 0;


            var frame_count =
                sprite_get_number(
                    jumpbot_sprite
                );


            if (frame_count > 0)
            {
                var frame_advance = 1;


                if (
                    codec_state == 2 &&
                    random(1) <
                        jumpbot_feed_skip_chance
                )
                {
                    frame_advance = 2;
                }


                jumpbot_portrait_frame =
                    (
                        jumpbot_portrait_frame +
                        frame_advance
                    )
                    mod
                    frame_count;
            }
        }
    }
}


// ====================================================
// B1LL-E VIDEO FEED ANIMATION
// ====================================================

if (bille_active_sprite != -1)
{
    if (bille_feed_hold_timer > 0)
    {
        bille_feed_hold_timer--;
    }
    else
    {
        if (codec_state == 2)
        {
            if (bille_feed_hold_wait_timer > 0)
            {
                bille_feed_hold_wait_timer--;
            }
            else
            {
                bille_feed_hold_timer =
                    irandom_range(
                        bille_feed_hold_min,
                        bille_feed_hold_max
                    );


                bille_feed_hold_wait_timer =
                    irandom_range(
                        bille_feed_hold_wait_min,
                        bille_feed_hold_wait_max
                    );
            }
        }


        var bille_feed_interval =
            bille_portrait_mode == "talking"
            ? bille_feed_frame_interval_talking
            : bille_feed_frame_interval_idle;


        bille_feed_timer++;


        if (
            bille_feed_timer >=
            bille_feed_interval
        )
        {
            bille_feed_timer = 0;


            var bille_frame_count =
                sprite_get_number(
                    bille_active_sprite
                );


            if (bille_frame_count > 0)
            {
                var bille_frame_advance = 1;


                if (
                    codec_state == 2 &&
                    random(1) <
                        bille_feed_skip_chance
                )
                {
                    bille_frame_advance = 2;
                }


                bille_portrait_frame =
                    (
                        bille_portrait_frame +
                        bille_frame_advance
                    )
                    mod
                    bille_frame_count;


                if (
                    bille_portrait_mode ==
                    "talking"
                )
                {
                    bille_talking_resume_frame =
                        bille_portrait_frame;
                }
            }
        }
    }
}


// ====================================================
// BIRD VIDEO FEED
// ====================================================

if (bird_portrait_sprite != -1)
{
    if (jumpbot_feed_hold_timer <= 0)
    {
        bird_portrait_timer++;


        if (
            bird_portrait_timer >=
            jumpbot_feed_frame_interval
        )
        {
            bird_portrait_timer = 0;


            var bird_frame_count =
                sprite_get_number(
                    bird_portrait_sprite
                );


            if (bird_frame_count > 0)
            {
                var bird_advance = 1;


                if (
                    codec_state == 2 &&
                    random(1) <
                        jumpbot_feed_skip_chance
                )
                {
                    bird_advance = 2;
                }


                bird_portrait_frame =
                    (
                        bird_portrait_frame +
                        bird_advance
                    )
                    mod
                    bird_frame_count;
            }
        }
    }
}


// ====================================================
// JUMPBOT TRANSMISSION TEAR
// ====================================================

if (
    codec_state == 2 &&
    portrait_open >= 1
)
{
    if (jumpbot_tear_active)
    {
        jumpbot_tear_timer--;


        if (jumpbot_tear_timer <= 0)
        {
            jumpbot_tear_active =
                false;


            jumpbot_tear_wait_timer =
                irandom_range(
                    jumpbot_tear_wait_min,
                    jumpbot_tear_wait_max
                );
        }
    }
    else
    {
        if (jumpbot_tear_wait_timer > 0)
        {
            jumpbot_tear_wait_timer--;
        }
        else
        {
            jumpbot_tear_active =
                true;


            jumpbot_tear_timer =
                irandom_range(
                    1,
                    2
                );


            jumpbot_tear_y =
                irandom_range(
                    12,
                    110
                );


            jumpbot_tear_h =
                irandom_range(
                    3,
                    7
                );


            jumpbot_tear_xoff =
                choose(
                    -3,
                    -2,
                    2,
                    3
                );
        }
    }
}
else
{
    jumpbot_tear_active =
        false;
}


// ====================================================
// B1LL-E TRANSMISSION TEAR
// ====================================================

if (
    codec_state == 2 &&
    portrait_open >= 1
)
{
    if (bille_tear_active)
    {
        bille_tear_timer--;


        if (bille_tear_timer <= 0)
        {
            bille_tear_active =
                false;


            bille_tear_wait_timer =
                irandom_range(
                    bille_tear_wait_min,
                    bille_tear_wait_max
                );
        }
    }
    else
    {
        if (bille_tear_wait_timer > 0)
        {
            bille_tear_wait_timer--;
        }
        else
        {
            bille_tear_active =
                true;


            bille_tear_timer =
                irandom_range(
                    1,
                    2
                );


            bille_tear_y =
                irandom_range(
                    10,
                    112
                );


            bille_tear_h =
                irandom_range(
                    3,
                    8
                );


            bille_tear_xoff =
                choose(
                    -4,
                    -3,
                    -2,
                    2,
                    3,
                    4
                );
        }
    }
}
else
{
    bille_tear_active =
        false;
}


// ====================================================
// JUMPBOT OCCASIONAL FACE ZOOM
// ====================================================

if (codec_state == 2)
{
    if (jumpbot_zoom_state == 0)
    {
        jumpbot_zoom_amount = 0;


        if (portrait_zoom_owner == 0)
        {
            if (jumpbot_zoom_wait_timer > 0)
            {
                jumpbot_zoom_wait_timer--;
            }
            else
            {
                portrait_zoom_owner = 1;

                jumpbot_zoom_state = 1;
            }
        }
    }
    else if (jumpbot_zoom_state == 1)
    {
        jumpbot_zoom_amount =
            min(
                1,
                jumpbot_zoom_amount +
                    jumpbot_zoom_speed
            );


        if (jumpbot_zoom_amount >= 1)
        {
            jumpbot_zoom_amount = 1;

            jumpbot_zoom_state = 2;

            jumpbot_zoom_hold_timer =
                jumpbot_zoom_hold_frames;
        }
    }
    else if (jumpbot_zoom_state == 2)
    {
        jumpbot_zoom_amount = 1;


        if (jumpbot_zoom_hold_timer > 0)
        {
            jumpbot_zoom_hold_timer--;
        }
        else
        {
            jumpbot_zoom_state = 3;
        }
    }
    else if (jumpbot_zoom_state == 3)
    {
        jumpbot_zoom_amount =
            max(
                0,
                jumpbot_zoom_amount -
                    jumpbot_zoom_speed
            );


        if (jumpbot_zoom_amount <= 0)
        {
            jumpbot_zoom_amount = 0;

            jumpbot_zoom_state = 0;


            jumpbot_zoom_wait_timer =
                irandom_range(
                    jumpbot_zoom_wait_min,
                    jumpbot_zoom_wait_max
                );


            if (portrait_zoom_owner == 1)
            {
                portrait_zoom_owner = 0;
            }
        }
    }
}
else
{
    jumpbot_zoom_amount =
        max(
            0,
            jumpbot_zoom_amount -
                jumpbot_zoom_speed
        );


    if (
        jumpbot_zoom_amount <= 0 &&
        portrait_zoom_owner == 1
    )
    {
        jumpbot_zoom_amount = 0;

        jumpbot_zoom_state = 0;

        portrait_zoom_owner = 0;
    }
}


// ====================================================
// B1LL-E OCCASIONAL FACE ZOOM
// ====================================================

if (codec_state == 2)
{
    if (bille_zoom_state == 0)
    {
        bille_zoom_amount = 0;


        if (portrait_zoom_owner == 0)
        {
            if (bille_zoom_wait_timer > 0)
            {
                bille_zoom_wait_timer--;
            }
            else
            {
                portrait_zoom_owner = 2;

                bille_zoom_state = 1;
            }
        }
    }
    else if (bille_zoom_state == 1)
    {
        bille_zoom_amount =
            min(
                1,
                bille_zoom_amount +
                    bille_zoom_speed
            );


        if (bille_zoom_amount >= 1)
        {
            bille_zoom_amount = 1;

            bille_zoom_state = 2;

            bille_zoom_hold_timer =
                bille_zoom_hold_frames;
        }
    }
    else if (bille_zoom_state == 2)
    {
        bille_zoom_amount = 1;


        if (bille_zoom_hold_timer > 0)
        {
            bille_zoom_hold_timer--;
        }
        else
        {
            bille_zoom_state = 3;
        }
    }
    else if (bille_zoom_state == 3)
    {
        bille_zoom_amount =
            max(
                0,
                bille_zoom_amount -
                    bille_zoom_speed
            );


        if (bille_zoom_amount <= 0)
        {
            bille_zoom_amount = 0;

            bille_zoom_state = 0;


            bille_zoom_wait_timer =
                irandom_range(
                    bille_zoom_wait_min,
                    bille_zoom_wait_max
                );


            if (portrait_zoom_owner == 2)
            {
                portrait_zoom_owner = 0;
            }
        }
    }
}
else
{
    bille_zoom_amount =
        max(
            0,
            bille_zoom_amount -
                bille_zoom_speed
        );


    if (
        bille_zoom_amount <= 0 &&
        portrait_zoom_owner == 2
    )
    {
        bille_zoom_amount = 0;

        bille_zoom_state = 0;

        portrait_zoom_owner = 0;
    }
}


// ====================================================
// VOICE METER
// ====================================================

if (codec_state == 2)
{
    var bille_actually_speaking =
        current_speaker == "B1LL-E" &&
        !line_finished;


    if (bille_actually_speaking)
    {
        voice_meter_timer++;


        if (
            voice_meter_timer >=
            voice_meter_speed
        )
        {
            voice_meter_timer = 0;


            voice_meter_level =
                voice_meter_pattern[
                    voice_meter_index
                ];


            voice_meter_index++;


            if (
                voice_meter_index >=
                    array_length(
                        voice_meter_pattern
                    )
            )
            {
                voice_meter_index = 0;
            }
        }
    }
    else
    {
        voice_meter_timer = 0;

        voice_meter_index = 0;

        voice_meter_level = 1;
    }
}
else
{
    voice_meter_timer = 0;

    voice_meter_index = 0;

    voice_meter_level = 1;
}


// ====================================================
// STATE 0 — INCOMING CALL
// ====================================================

if (codec_state == 0)
{
    call_timer++;

    call_flash_timer++;


    if (
        call_flash_timer >=
        call_flash_speed
    )
    {
        call_flash_timer = 0;

        call_visible =
            !call_visible;
    }


    if (
        call_timer >=
            call_duration ||
        confirm_pressed
    )
    {
        codec_state = 1;

        input_lock_frames = 6;

        portrait_open = 0;

        portrait_open_delay_timer = 0;
    }


    exit;
}


// ====================================================
// STATE 1 — OPEN
// ====================================================

if (codec_state == 1)
{
    ui_alpha =
        min(
            1,
            ui_alpha +
                ui_fade_speed
        );


    if (
        portrait_open_delay_timer <
        portrait_open_delay
    )
    {
        portrait_open_delay_timer++;
    }
    else
    {
        portrait_open =
            lerp(
                portrait_open,
                1,
                portrait_open_speed
            );


        if (portrait_open >= 0.995)
        {
            portrait_open = 1;
        }
    }


    if (
        ui_alpha >= 1 &&
        portrait_open >= 1
    )
    {
        ui_alpha = 1;

        portrait_open = 1;

        codec_state = 2;


        begin_dialogue();


        input_lock_frames = 5;


        portrait_zoom_owner = 0;


        jumpbot_zoom_state = 0;

        jumpbot_zoom_amount = 0;


        jumpbot_zoom_wait_timer =
            irandom_range(
                jumpbot_zoom_wait_min,
                jumpbot_zoom_wait_max
            );


        bille_zoom_state = 0;

        bille_zoom_amount = 0;


        bille_zoom_wait_timer =
            irandom_range(
                bille_zoom_wait_min,
                bille_zoom_wait_max
            );
    }


    exit;
}


// ====================================================
// STATE 2 — DIALOGUE
// ====================================================

if (codec_state == 2)
{
    // =================================================
    // TYPEWRITER
    // ====================================================

    if (!line_finished)
    {
        var text_length =
            string_length(
                current_text
            );


        if (text_length <= 0)
        {
            char_index = 0;

            display_text = "";

            line_finished = true;


            if (
                current_speaker ==
                "B1LL-E"
            )
            {
                bille_stop_talking();
            }
        }
        else if (text_pause_timer > 0)
        {
            text_pause_timer--;
        }
        else
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
                !line_finished &&
                text_pause_timer <= 0
            )
            {
                text_char_accumulator -= 1;

                char_index++;


                if (
                    char_index >=
                    text_length
                )
                {
                    char_index =
                        text_length;


                    display_text =
                        current_text;


                    line_finished =
                        true;


                    text_char_accumulator =
                        0;


                    text_pause_timer =
                        0;


                    if (
                        current_speaker ==
                        "B1LL-E"
                    )
                    {
                        bille_stop_talking();
                    }


                    break;
                }


                display_text =
                    string_copy(
                        current_text,
                        1,
                        char_index
                    );


                var current_char =
                    string_char_at(
                        current_text,
                        char_index
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
    // CONFIRM
    // ====================================================

    if (confirm_pressed)
    {
        if (!line_finished)
        {
            char_index =
                string_length(
                    current_text
                );


            display_text =
                current_text;


            line_finished =
                true;


            text_char_accumulator =
                0;


            text_pause_timer =
                0;


            if (
                current_speaker ==
                "B1LL-E"
            )
            {
                bille_stop_talking();
            }
        }
        else
        {
            dialogue_index++;


            if (
                dialogue_index >=
                    array_length(
                        dialogue
                    )
            )
            {
                finish_codec();
            }
            else
            {
                load_current_line();
            }
        }
    }


    exit;
}


// ====================================================
// STATE 3 — CLOSE
// ====================================================

if (codec_state == 3)
{
    if (codec_close_state == 0)
    {
        jumpbot_zoom_amount =
            max(
                0,
                jumpbot_zoom_amount -
                    jumpbot_zoom_speed
            );


        bille_zoom_amount =
            max(
                0,
                bille_zoom_amount -
                    bille_zoom_speed
            );


        portrait_open =
            lerp(
                portrait_open,
                0,
                portrait_close_speed
            );


        if (portrait_open <= 0.005)
        {
            portrait_open = 0;


            jumpbot_zoom_amount = 0;

            bille_zoom_amount = 0;


            portrait_zoom_owner = 0;


            codec_close_state = 1;


            portrait_close_hold_timer =
                portrait_close_hold;
        }


        exit;
    }


    if (codec_close_state == 1)
    {
        portrait_open = 0;

        jumpbot_zoom_amount = 0;

        bille_zoom_amount = 0;

        portrait_zoom_owner = 0;


        if (portrait_close_hold_timer > 0)
        {
            portrait_close_hold_timer--;
        }
        else
        {
            codec_close_state = 2;
        }


        exit;
    }


    if (codec_close_state == 2)
    {
        ui_alpha =
            max(
                0,
                ui_alpha -
                    ui_fade_speed
            );


        if (ui_alpha <= 0)
        {
            ui_alpha = 0;


            var p =
                instance_find(
                    oPlayer,
                    0
                );


            if (p != noone)
            {
                if (
                    variable_instance_exists(
                        p,
                        "respawn_input_lock"
                    )
                )
                {
                    p.respawn_input_lock =
                        max(
                            p.respawn_input_lock,
                            6
                        );
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
                        "prev_jump_h"
                    )
                )
                {
                    p.prev_jump_h = true;
                }
            }


            if (
                variable_global_exists(
                    "inp_jump_press"
                )
            )
            {
                global.inp_jump_press = false;
            }


            if (
                variable_global_exists(
                    "inp_jump_held"
                )
            )
            {
                global.inp_jump_held = false;
            }


            if (
                variable_global_exists(
                    "inp_jump_block_until_release"
                )
            )
            {
                global.inp_jump_block_until_release =
                    true;
            }


            global.game_phase =
                "playing";


            instance_destroy();
        }


        exit;
    }
}