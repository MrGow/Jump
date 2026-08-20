/// oB1LL — Create

depth = 0;
visible = true;


// ====================================================
// EDITOR VARIABLES
// ====================================================

// Which dialogue set this instance uses.
if (!variable_instance_exists(id, "dialogue_id"))
{
    dialogue_id = 1;
}

// Trigger distance.
if (!variable_instance_exists(id, "dialogue_range"))
{
    dialogue_range = 95;
}

// One-shot by default.
if (!variable_instance_exists(id, "dialogue_once"))
{
    dialogue_once = true;
}

// Unique persistence key.
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
    asset_get_index(
        "spriteB1LLIdle"
    );

spr_talking =
    asset_get_index(
        "spriteB1LLTalking"
    );

spr_stretching =
    asset_get_index(
        "spriteB1LLStretching"
    );


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
// ====================================================

b1ll_state = "idle";


// ====================================================
// DIALOGUE STATE
// ====================================================

dialogue_active = false;
dialogue_lines  = [];
dialogue_line   = 0;

dialogue_alpha = 0;

dialogue_min_line_frames = 10;
dialogue_line_timer      = 0;

dialogue_triggered_this_visit = false;


// ====================================================
// INPUT RELEASE GUARD
// ====================================================

dialogue_input_armed = false;
dialogue_wait_release = true;


// ====================================================
// PLAYER LOCK
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
// STRETCHING
// ====================================================

stretch_min_seconds = 13;
stretch_max_seconds = 17;

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
// DIALOGUE TEXT POSITION
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

// Height of bars at full extension.
if (!variable_instance_exists(id, "letterbox_height"))
{
    letterbox_height = 32;
}

// Current animated bar height.
letterbox_current = 0;

// How quickly bars slide in/out.
if (!variable_instance_exists(id, "letterbox_speed"))
{
    letterbox_speed = 4;
}

// Optional slight darkening behind dialogue.
if (!variable_instance_exists(id, "dialogue_dim_alpha"))
{
    dialogue_dim_alpha = 0.12;
}


// ====================================================
// BEGIN DIALOGUE
// ====================================================

begin_dialogue = function(_player)
{
    if (dialogue_active)
    {
        return;
    }

    sequence_player =
        _player;

    dialogue_lines =
        scr_Dialogue(
            dialogue_id
        );

    dialogue_line = 0;

    dialogue_active = true;

    dialogue_line_timer =
        dialogue_min_line_frames;

    dialogue_input_armed =
        false;

    dialogue_wait_release =
        true;

    dialogue_alpha = 0;

    b1ll_state =
        "talking";

    if (spr_talking != -1)
    {
        sprite_index =
            spr_talking;

        image_index = 0;
        image_speed = 1;
    }

    // ------------------------------------------------
    // Lock ONLY the player.
    // Do not freeze the entire game.
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

    dialogue_triggered_this_visit =
        true;

    b1ll_state =
        "idle";

    if (spr_idle != -1)
    {
        sprite_index =
            spr_idle;

        image_index = 0;
        image_speed = 1;
    }

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
    // Brief input protection after final line.
    // ------------------------------------------------
    if (instance_exists(sequence_player))
    {
        if (
            variable_instance_exists(
                sequence_player,
                "respawn_input_lock"
            )
        )
        {
            sequence_player.respawn_input_lock =
                max(
                    sequence_player.respawn_input_lock,
                    10
                );
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

    sequence_player =
        noone;

    reset_stretch_timer();
};