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
//
// Idle is whatever sprite is assigned directly to
// oB1LL in the Object Editor.
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
// "ending_talk_pose"
// ====================================================

b1ll_state =
    "idle";


// ====================================================
// TALKING TRANSITION FRAMES
//
// Because the idle animation contains a tiny vertical
// bob, B1LL only changes from idle -> talking when his
// idle animation reaches a neutral pose.
//
// Change these if another frame aligns better.
//
// These are zero-based GameMaker frame numbers.
// ====================================================

if (!variable_instance_exists(id, "talk_start_idle_frame"))
{
    talk_start_idle_frame = 0;
}


// When the whole conversation ends, allow the talking
// animation to reach this neutral frame before changing
// back to idle.
//
// Frame 0 is the best starting point to test.
if (!variable_instance_exists(id, "talk_end_talking_frame"))
{
    talk_end_talking_frame = 0;
}


// ====================================================
// TALKING ANIMATION MEMORY
//
// Between dialogue lines we freeze the talking sprite
// itself rather than swapping back to idle.
//
// The next line resumes from exactly this position.
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


    // IMPORTANT:
    //
    // Stay on spriteBillETalking.
    // We only stop its animation.
    //
    // This completely avoids the idle <-> talking
    // sprite swap between individual dialogue lines.

    b1ll_state =
        "talking";

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


        // Resume exactly where the previous line stopped.
        image_index =
            talking_resume_frame;

        image_speed =
            1;
    }
};


// ====================================================
// COMPLETE CURRENT LINE IMMEDIATELY
//
// Pressing Space/A while text is typing reveals the
// whole line and freezes B1LL on his exact talking pose.
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


stretch_timer = 0;


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


letterbox_current = 0;


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
// PREPARE B1LL FOR FIRST TALKING FRAME
//
// We deliberately do NOT immediately change sprites.
//
// B1LL continues his idle bob until he reaches the
// neutral idle frame.
// ====================================================

prepare_talking = function()
{
    if (!instance_exists(sequence_player))
    {
        return;
    }


    global.npc_dialogue_active =
        true;


    // Player has landed at this point, so lock them
    // fully while B1LL reaches his neutral pose.
    sequence_player.dialogue_locked =
        true;

    sequence_player.hsp =
        0;

    sequence_player.vsp =
        0;


    // ------------------------------------------------
    // Make sure B1LL is using idle animation
    // ------------------------------------------------

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
//
// Called only once B1LL's idle animation has reached
// its neutral transition frame.
// ====================================================

start_talking = function()
{
    if (!instance_exists(sequence_player))
    {
        return;
    }


    // =================================================
    // FORCE PLAYER INTO CLEAN IDLE PRESENTATION
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


    // ------------------------------------------------
    // A new conversation begins from talking frame 0.
    //
    // Between individual lines we preserve the frame.
    // ------------------------------------------------

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
        b1ll_state == "waiting_for_talk_pose" ||
        b1ll_state == "ending_talk_pose"
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


    // ------------------------------------------------
    // Suppress player input but allow gravity until
    // they actually reach the floor.
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


        // Cancel stretch if dialogue caught B1LL during it.
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
    // Remember current talking frame before beginning
    // the final settle animation.
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
    // UNLOCK PLAYER IMMEDIATELY
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
    // SETTLE B1LL BACK INTO IDLE
    //
    // Do not instantly swap sprite.
    //
    // Let the talking animation continue until its
    // neutral transition frame.
    // ====================================================

    if (
        spr_talking != -1 &&
        sprite_index == spr_talking
    )
    {
        b1ll_state =
            "ending_talk_pose";


        image_speed =
            1;
    }
    else
    {
        b1ll_state =
            "idle";


        sprite_index =
            spr_idle;


        image_index =
            talk_start_idle_frame;


        image_speed =
            1;
    }
};