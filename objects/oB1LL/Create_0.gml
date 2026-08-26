/// oB1LL — Create

depth = 0;
visible = true;


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "dialogue_id"))
{
    dialogue_id = 1;
}

if (!variable_instance_exists(id, "dialogue_range"))
{
    dialogue_range = 95;
}

if (!variable_instance_exists(id, "dialogue_once"))
{
    dialogue_once = true;
}

if (!variable_instance_exists(id, "dialogue_key"))
{
    dialogue_key = "";
}

if (dialogue_key == "")
{
    dialogue_key =
        room_get_name(room) +
        "_b1ll_" +
        string(round(x)) +
        "_" +
        string(round(y));
}


// ====================================================
// SPRITES
// ====================================================

spr_idle =
    sprite_index;

spr_talking =
    asset_get_index(
        "spriteBillETalking"
    );

spr_stretching =
    asset_get_index(
        "spriteBillEStretch"
    );


// ====================================================
// BASE ANIMATION
// ====================================================

sprite_index =
    spr_idle;

image_index =
    0;

image_speed =
    1;


// ====================================================
// STATE
//
// "idle"
// "stretching"
// "waiting_for_land"
// "waiting_for_talk_pose"
// "talking"
// ====================================================

b1ll_state =
    "idle";


// ====================================================
// CONTINUOUS IDLE BOB
// ====================================================

b1ll_bob_phase =
    0;


if (!variable_instance_exists(id, "dialogue_bob_height"))
{
    dialogue_bob_height = 2;
}


if (!variable_instance_exists(id, "dialogue_bob_phase_offset"))
{
    dialogue_bob_phase_offset = 0;
}


b1ll_bob_draw_y =
    0;


// ====================================================
// TALKING TRANSITION FRAME
// ====================================================

if (!variable_instance_exists(id, "talk_start_idle_frame"))
{
    talk_start_idle_frame = 0;
}


// ====================================================
// TALKING ANIMATION MEMORY
// ====================================================

talking_resume_frame =
    0;


// ====================================================
// DIALOGUE STATE
// ====================================================

dialogue_active =
    false;

dialogue_lines =
    [];

dialogue_line =
    0;

dialogue_alpha =
    0;

dialogue_min_line_frames =
    10;

dialogue_line_timer =
    0;


// ====================================================
// TYPEWRITER TEXT
// ====================================================

if (!variable_instance_exists(id, "text_chars_per_second"))
{
    text_chars_per_second = 32;
}

if (!variable_instance_exists(id, "text_comma_pause"))
{
    text_comma_pause = 0.07;
}

if (!variable_instance_exists(id, "text_sentence_pause"))
{
    text_sentence_pause = 0.14;
}


text_visible_chars =
    0;

text_char_accumulator =
    0;

text_pause_timer =
    0;

text_line_complete =
    false;


// ====================================================
// FREEZE CURRENT TALKING POSE
// ====================================================

freeze_talking_pose = function()
{
    if (
        spr_talking != -1 &&
        sprite_index == spr_talking
    )
    {
        talking_resume_frame =
            image_index;
    }


    b1ll_state =
        "talking";


    // Freeze talking animation only.
    //
    // External bob continues independently.
    image_speed =
        0;
};


// ====================================================
// START CURRENT TYPEWRITER LINE
// ====================================================

reset_typewriter_line = function()
{
    text_visible_chars =
        0;

    text_char_accumulator =
        0;

    text_pause_timer =
        0;

    text_line_complete =
        false;


    b1ll_state =
        "talking";


    if (spr_talking != -1)
    {
        sprite_index =
            spr_talking;


        var talking_frames =
            sprite_get_number(
                spr_talking
            );


        if (talking_frames > 0)
        {
            talking_resume_frame =
                clamp(
                    talking_resume_frame,
                    0,
                    talking_frames - 1
                );
        }
        else
        {
            talking_resume_frame =
                0;
        }


        image_index =
            talking_resume_frame;

        image_speed =
            1;
    }
};


// ====================================================
// COMPLETE CURRENT LINE IMMEDIATELY
// ====================================================

complete_typewriter_line = function()
{
    if (
        dialogue_line < 0 ||
        dialogue_line >=
            array_length(
                dialogue_lines
            )
    )
    {
        return;
    }


    var full_line =
        string(
            dialogue_lines[
                dialogue_line
            ]
        );


    text_visible_chars =
        string_length(
            full_line
        );


    text_char_accumulator =
        0;


    text_pause_timer =
        0;


    text_line_complete =
        true;


    freeze_talking_pose();
};


// ====================================================
// INPUT STATE
// ====================================================

dialogue_input_armed =
    false;

dialogue_wait_release =
    true;


// ====================================================
// PLAYER
// ====================================================

sequence_player =
    noone;


// ====================================================
// DIALOGUE SEEN TRACKING
// ====================================================

if (!variable_global_exists("dialogue_seen"))
{
    global.dialogue_seen =
        ds_map_create();
}


dialogue_completed =
    ds_map_exists(
        global.dialogue_seen,
        dialogue_key
    );


// ====================================================
// GLOBAL DIALOGUE SAFETY
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
// STRETCHING
// ====================================================

if (!variable_instance_exists(id, "stretch_min_seconds"))
{
    stretch_min_seconds = 13;
}

if (!variable_instance_exists(id, "stretch_max_seconds"))
{
    stretch_max_seconds = 17;
}


stretch_timer =
    0;


reset_stretch_timer = function()
{
    stretch_timer =
        irandom_range(
            round(
                room_speed *
                stretch_min_seconds
            ),
            round(
                room_speed *
                stretch_max_seconds
            )
        );
};


reset_stretch_timer();


// ====================================================
// DIALOGUE PRESENTATION
// ====================================================

if (!variable_instance_exists(id, "dialogue_offset_y"))
{
    dialogue_offset_y = -120;
}

if (!variable_instance_exists(id, "dialogue_width"))
{
    dialogue_width = 310;
}


// ====================================================
// LETTERBOX
// ====================================================

if (!variable_instance_exists(id, "letterbox_height"))
{
    letterbox_height = 32;
}


letterbox_current =
    0;


if (!variable_instance_exists(id, "letterbox_lerp"))
{
    letterbox_lerp = 0.25;
}

if (!variable_instance_exists(id, "dialogue_dim_alpha"))
{
    dialogue_dim_alpha = 0.12;
}


// ====================================================
// GROUND SHADOW
// ====================================================

if (!variable_instance_exists(id, "shadow_enabled"))
{
    shadow_enabled = true;
}

if (!variable_instance_exists(id, "shadow_w"))
{
    shadow_w = 34;
}

if (!variable_instance_exists(id, "shadow_h"))
{
    shadow_h = 7;
}

if (!variable_instance_exists(id, "shadow_alpha"))
{
    shadow_alpha = 0.22;
}

if (!variable_instance_exists(id, "shadow_y_nudge"))
{
    shadow_y_nudge = -13;
}

if (!variable_instance_exists(id, "shadow_x_nudge"))
{
    shadow_x_nudge = 0;
}


// ====================================================
// PREPARE TALKING
// ====================================================

prepare_talking = function()
{
    if (!instance_exists(sequence_player))
    {
        return;
    }


    global.npc_dialogue_active =
        true;


    sequence_player.dialogue_locked =
        true;


    sequence_player.hsp =
        0;


    sequence_player.vsp =
        0;


    if (sprite_index != spr_idle)
    {
        sprite_index =
            spr_idle;


        image_index =
            talk_start_idle_frame;
    }


    image_speed =
        1;


    b1ll_state =
        "waiting_for_talk_pose";
};


// ====================================================
// BEGIN ACTUAL TALKING
// ====================================================

start_talking = function()
{
    if (!instance_exists(sequence_player))
    {
        return;
    }


    // =================================================
    // FORCE PLAYER INTO CLEAN IDLE
    // ====================================================

    var player_idle_sprite =
        asset_get_index(
            "spriteBotIdle"
        );


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
            "bounce_pending"
        )
    )
    {
        sequence_player.bounce_pending =
            false;
    }

    if (
        variable_instance_exists(
            sequence_player,
            "bounce_timer"
        )
    )
    {
        sequence_player.bounce_timer =
            0;
    }

    if (
        variable_instance_exists(
            sequence_player,
            "jump_pose_timer"
        )
    )
    {
        sequence_player.jump_pose_timer =
            0;
    }

    if (
        variable_instance_exists(
            sequence_player,
            "state"
        )
    )
    {
        sequence_player.state =
            "idle";
    }


    if (player_idle_sprite != -1)
    {
        sequence_player.sprite_index =
            player_idle_sprite;


        sequence_player.image_index =
            0;


        sequence_player.image_speed =
            1;
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


    // =================================================
    // LOAD DIALOGUE
    // ====================================================

    dialogue_lines =
        scr_npc_dialogue(
            dialogue_id
        );


    dialogue_line =
        0;


    dialogue_active =
        true;


    dialogue_alpha =
        0;


    dialogue_line_timer =
        dialogue_min_line_frames;


    dialogue_input_armed =
        false;


    dialogue_wait_release =
        true;


    global.npc_dialogue_active =
        true;


    sequence_player.dialogue_locked =
        true;


    talking_resume_frame =
        0;


    reset_typewriter_line();
};


// ====================================================
// BEGIN DIALOGUE SEQUENCE
// ====================================================

begin_dialogue = function(_player)
{
    if (
        dialogue_active ||
        b1ll_state == "waiting_for_land" ||
        b1ll_state == "waiting_for_talk_pose"
    )
    {
        return;
    }


    if (!instance_exists(_player))
    {
        return;
    }


    sequence_player =
        _player;


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


    // ------------------------------------------------
    // Already grounded?
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
        prepare_talking();
    }
    else
    {
        b1ll_state =
            "waiting_for_land";


        if (sprite_index != spr_idle)
        {
            sprite_index =
                spr_idle;


            image_index =
                talk_start_idle_frame;
        }


        image_speed =
            1;
    }
};


// ====================================================
// END DIALOGUE
//
// Immediately return to the real idle animation.
//
// No extra talking frames are played.
//
// We start idle at the frame represented by the
// continuous bob clock, so the visual vertical motion
// remains continuous.
// ====================================================

end_dialogue = function()
{
    dialogue_active =
        false;


    dialogue_alpha =
        0;


    text_visible_chars =
        0;


    text_char_accumulator =
        0;


    text_pause_timer =
        0;


    text_line_complete =
        false;


    // ------------------------------------------------
    // Remember final talking frame
    // ------------------------------------------------

    if (
        spr_talking != -1 &&
        sprite_index == spr_talking
    )
    {
        talking_resume_frame =
            image_index;
    }


    // =================================================
    // MARK COMPLETE
    // ====================================================

    if (dialogue_once)
    {
        dialogue_completed =
            true;


        if (
            !ds_map_exists(
                global.dialogue_seen,
                dialogue_key
            )
        )
        {
            ds_map_add(
                global.dialogue_seen,
                dialogue_key,
                true
            );
        }
    }


    // =================================================
    // UNLOCK PLAYER
    // ====================================================

    if (instance_exists(sequence_player))
    {
        sequence_player.dialogue_locked =
            false;


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
    }


    global.inp_jump_block_until_release =
        true;


    global.npc_dialogue_active =
        false;


    sequence_player =
        noone;


    reset_stretch_timer();


    // =================================================
    // IMMEDIATE IDLE RETURN
    // ====================================================

    b1ll_state =
        "idle";


    if (spr_idle != -1)
    {
        var idle_frames =
            max(
                1,
                sprite_get_number(
                    spr_idle
                )
            );


        sprite_index =
            spr_idle;


        image_index =
            clamp(
                b1ll_bob_phase,
                0,
                idle_frames - 0.001
            );


        image_speed =
            1;
    }


    // Idle artwork now supplies the bob itself.
    b1ll_bob_draw_y =
        0;
};