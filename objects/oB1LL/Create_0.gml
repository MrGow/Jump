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
    asset_get_index("spriteB1LLIdle");

spr_talking =
    asset_get_index("spriteB1LLTalking");

spr_stretching =
    asset_get_index("spriteB1LLStretching");


// ====================================================
// BASE ANIMATION
// ====================================================

if (spr_idle != -1)
{
    sprite_index = spr_idle;
}

image_index = 0;
image_speed = 1;


// ====================================================
// STATE
//
// "idle"
// "stretching"
// "waiting_for_land"
// "talking"
// ====================================================

b1ll_state = "idle";


// ====================================================
// DIALOGUE STATE
// ====================================================

dialogue_active = false;

dialogue_lines = [];
dialogue_line  = 0;

dialogue_alpha = 0;

dialogue_min_line_frames = 10;
dialogue_line_timer      = 0;


// ====================================================
// TYPEWRITER TEXT
// ====================================================

// Roughly 32 characters per second feels quick enough
// for a platformer while still reading like speech.
if (!variable_instance_exists(id, "text_chars_per_second"))
{
    text_chars_per_second = 32;
}

// Extra delay after commas / semicolons.
if (!variable_instance_exists(id, "text_comma_pause"))
{
    text_comma_pause = 0.07;
}

// Extra delay after sentence-ending punctuation.
if (!variable_instance_exists(id, "text_sentence_pause"))
{
    text_sentence_pause = 0.14;
}


// Number of characters currently visible.
text_visible_chars = 0;

// Fractional character accumulator.
text_char_accumulator = 0;

// Punctuation delay.
text_pause_timer = 0;

// True once the whole current line has appeared.
text_line_complete = false;


// ----------------------------------------------------
// Start typewriter presentation for current line
// ----------------------------------------------------

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


    // B1LL starts talking again when a new line begins.
    b1ll_state =
        "talking";

    if (spr_talking != -1)
    {
        sprite_index =
            spr_talking;

        image_index =
            0;

        image_speed =
            1;
    }
};


// ----------------------------------------------------
// Instantly reveal the rest of current line
// ----------------------------------------------------

complete_typewriter_line = function()
{
    if (
        dialogue_line < 0 ||
        dialogue_line >= array_length(dialogue_lines)
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
        string_length(full_line);

    text_char_accumulator =
        0;

    text_pause_timer =
        0;

    text_line_complete =
        true;


    // B1LL stops talking and idles while waiting for
    // the player to advance.
    if (spr_idle != -1)
    {
        sprite_index =
            spr_idle;

        image_index =
            0;

        image_speed =
            1;
    }
};


// ====================================================
// INPUT STATE
// ====================================================

dialogue_input_armed = false;
dialogue_wait_release = true;


// ====================================================
// PLAYER
// ====================================================

sequence_player = noone;


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
    global.npc_dialogue_active = false;
}

if (!variable_global_exists("inp_jump_block_until_release"))
{
    global.inp_jump_block_until_release = false;
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
            round(room_speed * stretch_min_seconds),
            round(room_speed * stretch_max_seconds)
        );
};

reset_stretch_timer();


// ====================================================
// DIALOGUE PRESENTATION
// ====================================================

if (!variable_instance_exists(id, "dialogue_offset_y"))
{
    dialogue_offset_y = -58;
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
// BEGIN ACTUAL TALKING
// ====================================================

start_talking = function()
{
    if (!instance_exists(sequence_player))
    {
        return;
    }


    // =================================================
    // FORCE PLAYER INTO CLEAN IDLE PRESENTATION
    // =================================================

    var player_idle_sprite =
        asset_get_index(
            "spriteBotIdle"
        );

    sequence_player.hsp = 0;
    sequence_player.vsp = 0;


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


    // ------------------------------------------------
    // Force idle sprite immediately
    // ------------------------------------------------

    if (player_idle_sprite != -1)
    {
        sequence_player.sprite_index =
            player_idle_sprite;

        sequence_player.image_index =
            0;

        sequence_player.image_speed =
            1;
    }


    // ------------------------------------------------
    // Treat current confirm as already held
    // ------------------------------------------------

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
    // =================================================

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


    // Start first line at zero characters.
    reset_typewriter_line();


    // =================================================
    // INPUT OWNERSHIP
    // =================================================

    global.npc_dialogue_active =
        true;

    sequence_player.dialogue_locked =
        true;


    // =================================================
    // B1LL TALKING
    // =================================================

    b1ll_state =
        "talking";
};


// ====================================================
// BEGIN DIALOGUE SEQUENCE
// ====================================================

begin_dialogue = function(_player)
{
    if (
        dialogue_active ||
        b1ll_state == "waiting_for_land"
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
    // Suppress player controls while allowing gravity.
    // ------------------------------------------------

    global.npc_dialogue_active =
        true;

    sequence_player.dialogue_locked =
        false;

    sequence_player.hsp =
        0;


    // Cancel charge.
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


    if (grounded_now)
    {
        start_talking();
    }
    else
    {
        b1ll_state =
            "waiting_for_land";

        // B1LL remains idle while JumpBot drops.
        if (spr_idle != -1)
        {
            sprite_index =
                spr_idle;

            image_index =
                0;

            image_speed =
                1;
        }
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
    // Mark completed
    // ------------------------------------------------

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


    // ------------------------------------------------
    // B1LL idle
    // ------------------------------------------------

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


    // ------------------------------------------------
    // Unlock player
    // ------------------------------------------------

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


    // Final dialogue press cannot become a jump.
    global.inp_jump_block_until_release =
        true;

    global.npc_dialogue_active =
        false;

    sequence_player =
        noone;

    reset_stretch_timer();
};