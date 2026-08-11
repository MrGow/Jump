/// oCodec — Step


// ====================================================
// INPUT
// ====================================================

if (input_lock_frames > 0)
{
    input_lock_frames--;
}


var confirm_pressed =
    keyboard_check_pressed(vk_space) ||
    keyboard_check_pressed(vk_enter);


if (
    variable_global_exists("inp_jump_press") &&
    global.inp_jump_press
)
{
    confirm_pressed = true;
}


if (input_lock_frames > 0)
{
    confirm_pressed = false;
}


// ====================================================
// JUMPBOT PORTRAIT ANIMATION
// ====================================================

if (jumpbot_sprite != -1)
{
    jumpbot_portrait_timer++;

    if (
        jumpbot_portrait_timer >=
        jumpbot_portrait_speed
    )
    {
        jumpbot_portrait_timer = 0;

        jumpbot_portrait_frame++;


        var frame_count =
            sprite_get_number(
                jumpbot_sprite
            );


        if (frame_count > 0)
        {
            jumpbot_portrait_frame =
                jumpbot_portrait_frame
                mod frame_count;
        }
    }
}


// ====================================================
// BIRD PORTRAIT ANIMATION
// ====================================================

if (bird_portrait_sprite != -1)
{
    bird_portrait_timer++;

    if (
        bird_portrait_timer >=
        bird_portrait_speed
    )
    {
        bird_portrait_timer = 0;

        bird_portrait_frame++;


        var bird_frame_count =
            sprite_get_number(
                bird_portrait_sprite
            );


        if (bird_frame_count > 0)
        {
            bird_portrait_frame =
                bird_portrait_frame
                mod bird_frame_count;
        }
    }
}


// ====================================================
// VOICE METER
// ====================================================

if (codec_state == 2)
{
    var speaker_is_bille =
        current_speaker ==
        "B1LL-E";


    if (speaker_is_bille)
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
        call_timer >= call_duration ||
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
    // ------------------------------------------------
    // Main interface fades in first.
    // ------------------------------------------------

    ui_alpha =
        min(
            1,
            ui_alpha +
            ui_fade_speed
        );


    // ------------------------------------------------
    // Short delay before portrait shutters open.
    // ------------------------------------------------

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


    // ------------------------------------------------
    // Don't begin dialogue until codec is fully open.
    // ------------------------------------------------

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
    }


    exit;
}


// ====================================================
// STATE 2 — DIALOGUE
// ====================================================

if (codec_state == 2)
{
    // ------------------------------------------------
    // TYPEWRITER
    // ------------------------------------------------

    if (!line_finished)
    {
        type_timer++;


        if (
            type_timer >=
            type_delay
        )
        {
            type_timer = 0;

            char_index++;


            var text_length =
                string_length(
                    current_text
                );


            if (
                char_index >=
                text_length
            )
            {
                char_index =
                    text_length;

                line_finished =
                    true;
            }


            display_text =
                string_copy(
                    current_text,
                    1,
                    char_index
                );
        }
    }


    // ------------------------------------------------
    // CONFIRM
    // ------------------------------------------------

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
    // =================================================
    // CLOSE STATE 0
    // PORTRAITS CLOSE
    // =================================================

    if (codec_close_state == 0)
    {
        portrait_open =
            lerp(
                portrait_open,
                0,
                portrait_close_speed
            );


        // Snap when essentially closed.
        if (portrait_open <= 0.005)
        {
            portrait_open = 0;

            codec_close_state = 1;

            portrait_close_hold_timer =
                portrait_close_hold;
        }


        exit;
    }


    // =================================================
    // CLOSE STATE 1
    // HOLD CLOSED
    // =================================================

    if (codec_close_state == 1)
    {
        portrait_open = 0;


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


    // =================================================
    // CLOSE STATE 2
    // FADE ENTIRE CODEC OUT
    // =================================================

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


            // =========================================
            // PLAYER INPUT GUARD
            // =========================================

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


            // =========================================
            // GLOBAL INPUT RESET
            // =========================================

            if (
                variable_global_exists(
                    "inp_jump_press"
                )
            )
            {
                global.inp_jump_press =
                    false;
            }


            if (
                variable_global_exists(
                    "inp_jump_held"
                )
            )
            {
                global.inp_jump_held =
                    false;
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


            // =========================================
            // RETURN TO GAMEPLAY
            // =========================================

            global.game_phase =
                "playing";


            instance_destroy();
        }


        exit;
    }
}