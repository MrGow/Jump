/// oCodec — Create


// ====================================================
// SINGLE INSTANCE SAFETY
// ====================================================

if (instance_number(oCodec) > 1)
{
    instance_destroy();
    exit;
}


// ====================================================
// INITIALIZATION
// ====================================================

codec_initialized = false;


// ====================================================
// CODEC ID
// ====================================================

if (!variable_instance_exists(id, "codec_id"))
{
    codec_id = 1;
}


// ====================================================
// GAME STATE
// ====================================================

previous_game_phase =
    variable_global_exists("game_phase")
    ? global.game_phase
    : "playing";

global.game_phase =
    "codec";


// ====================================================
// CODEC STATE
//
// 0 = incoming call
// 1 = opening
// 2 = dialogue
// 3 = closing
// ====================================================

codec_state = 0;


// ====================================================
// CALL INTRO
// ====================================================

call_timer = 0;

call_flash_timer = 0;

call_flash_speed = 10;

call_visible = true;


// ====================================================
// UI TRANSITION
// ====================================================

ui_alpha = 0;

ui_fade_speed = 0.10;


// ====================================================
// PORTRAIT OPEN / CLOSE
// ====================================================

portrait_open = 0;

portrait_open_speed = 0.055;


portrait_open_delay =
    room_speed;

portrait_open_delay_timer = 0;


portrait_close_speed = 0.070;


portrait_close_hold =
    round(
        room_speed * 0.65
    );

portrait_close_hold_timer = 0;


// ====================================================
// PANEL MATERIALISATION
//
// OPEN:
//
// 0 = horizontal signal line expands
// 1 = panel expands vertically
// 2 = tiny settle
// 3 = fully open
//
// CLOSE is handled through codec_close_state after the
// portraits have shut.
// ====================================================

codec_panel_state =
    0;


// Horizontal expansion:
// approximately 9 frames at 60 FPS.
if (!variable_instance_exists(id, "codec_panel_horizontal_speed"))
{
    codec_panel_horizontal_speed =
        1 / 9;
}


// Vertical expansion:
// approximately 12 frames.
if (!variable_instance_exists(id, "codec_panel_vertical_speed"))
{
    codec_panel_vertical_speed =
        1 / 12;
}


// Short electronic "settle" before portrait shutters.
if (!variable_instance_exists(id, "codec_panel_settle_frames"))
{
    codec_panel_settle_frames =
        4;
}


codec_panel_settle_timer =
    0;


// 0 = invisible centre point
// 1 = full panel width
codec_panel_horizontal =
    0;


// 0 = thin signal line
// 1 = full panel height
codec_panel_vertical =
    0;


// ----------------------------------------------------
// Closing speeds
//
// Slightly faster than opening.
// ----------------------------------------------------

if (!variable_instance_exists(id, "codec_panel_close_vertical_speed"))
{
    codec_panel_close_vertical_speed =
        1 / 10;
}


if (!variable_instance_exists(id, "codec_panel_close_horizontal_speed"))
{
    codec_panel_close_horizontal_speed =
        1 / 7;
}


// ====================================================
// CLOSING SUB-STATE
//
// 0 = portraits closing
// 1 = hold portraits closed
// 2 = panel collapses vertically
// 3 = signal line collapses horizontally
// 4 = remaining interface fades
// ====================================================

codec_close_state =
    0;


// ====================================================
// LOAD DIALOGUE
// ====================================================

dialogue =
    scr_codec_get_dialogue(
        codec_id
    );


// ====================================================
// CURRENT LINE
// ====================================================

dialogue_index = 0;

current_speaker = "";

current_text = "";

display_text = "";


// ====================================================
// TYPEWRITER
// ====================================================

char_index = 0;

line_finished = false;


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


text_char_accumulator = 0;

text_pause_timer = 0;


// ====================================================
// INPUT GUARD
// ====================================================

input_lock_frames = 8;

codec_confirm_was_held = false;


// ====================================================
// PORTRAITS
// ====================================================

jumpbot_sprite =
    asset_get_index(
        "spriteBotIdle"
    );


bille_idle_sprite =
    object_get_sprite(
        oB1LL
    );


bille_talking_sprite =
    asset_get_index(
        "spriteBillETalking"
    );


bille_active_sprite =
    bille_idle_sprite;


// ====================================================
// JUMPBOT PORTRAIT
// ====================================================

jumpbot_portrait_frame = 0;

jumpbot_portrait_timer = 0;

jumpbot_portrait_speed = 6;


jumpbot_portrait_padding_x = 12;

jumpbot_portrait_padding_y = 12;


// ====================================================
// B1LL-E PORTRAIT
//
// Modes:
//
// "idle"
//     Idle sprite is running.
//
// "talking"
//     Talking sprite advances while B1LL-E's text types.
//
// "frozen"
//     Talking sprite remains frozen on the exact frame
//     reached when the line completed.
//
// Bobbing continues during talking AND frozen.
// ====================================================

bille_portrait_frame = 0;

bille_portrait_timer = 0;


bille_idle_portrait_speed = 6;

bille_talking_portrait_speed = 6;


bille_portrait_mode =
    "idle";


bille_talking_resume_frame =
    0;


bille_has_talked =
    false;


bille_portrait_padding_x = 12;

bille_portrait_padding_y = 18;


// ====================================================
// B1LL-E CONTINUOUS BOB
//
// Same idea as regular oB1LL.
//
// Idle:
//     sprite contains its own baked bob.
//
// Talking / frozen:
//     we reproduce that bob externally.
//
// The phase is kept synchronized with the idle
// animation so transitions do not jolt.
// ====================================================

bille_bob_phase =
    0;


if (!variable_instance_exists(id, "bille_codec_bob_height"))
{
    bille_codec_bob_height = 2;
}


if (!variable_instance_exists(id, "bille_codec_bob_speed"))
{
    bille_codec_bob_speed = 1.12;
}


if (!variable_instance_exists(id, "bille_codec_bob_phase_offset"))
{
    bille_codec_bob_phase_offset = 0;
}


bille_bob_draw_y =
    0;


// ====================================================
// B1LL-E — START / RESUME TALKING
// ====================================================

bille_start_talking = function()
{
    bille_portrait_mode =
        "talking";


    bille_has_talked =
        true;


    if (bille_talking_sprite != -1)
    {
        bille_active_sprite =
            bille_talking_sprite;


        var frame_count =
            sprite_get_number(
                bille_talking_sprite
            );


        if (frame_count > 0)
        {
            bille_talking_resume_frame =
                clamp(
                    bille_talking_resume_frame,
                    0,
                    frame_count - 1
                );
        }
        else
        {
            bille_talking_resume_frame =
                0;
        }


        // Resume the exact frame remembered from the
        // previous completed B1LL-E line.
        bille_portrait_frame =
            bille_talking_resume_frame;
    }
    else
    {
        bille_active_sprite =
            bille_idle_sprite;


        bille_portrait_mode =
            "idle";


        bille_portrait_frame =
            0;
    }


    bille_feed_timer =
        0;
};


// ====================================================
// B1LL-E — FREEZE TALKING POSE
// ====================================================

bille_freeze_talking = function()
{
    if (
        bille_talking_sprite != -1 &&
        bille_active_sprite ==
            bille_talking_sprite
    )
    {
        bille_talking_resume_frame =
            bille_portrait_frame;


        bille_portrait_mode =
            "frozen";


        // Keep the talking sprite and exact frame.
        bille_active_sprite =
            bille_talking_sprite;
    }


    bille_feed_timer =
        0;


    stop_bille_codec_voice();
};


// ====================================================
// B1LL-E — RETURN TO IDLE
//
// ONLY used when the whole codec is ending.
// ====================================================

bille_return_idle = function()
{
    if (
        bille_talking_sprite != -1 &&
        bille_active_sprite ==
            bille_talking_sprite
    )
    {
        bille_talking_resume_frame =
            bille_portrait_frame;
    }


    bille_portrait_mode =
        "idle";


    bille_active_sprite =
        bille_idle_sprite;


    if (bille_idle_sprite != -1)
    {
        var idle_frames =
            max(
                1,
                sprite_get_number(
                    bille_idle_sprite
                )
            );


        // Return to idle at the bob phase currently
        // being simulated externally.
        bille_portrait_frame =
            clamp(
                bille_bob_phase,
                0,
                idle_frames - 0.001
            );
    }
    else
    {
        bille_portrait_frame =
            0;
    }


    bille_bob_draw_y =
        0;


    bille_feed_timer =
        0;
};


// ====================================================
// BIRD
// ====================================================

bird_portrait_sprite =
    asset_get_index(
        "spriteBirdIdle"
    );

bird_portrait_frame = 0;

bird_portrait_timer = 0;

bird_portrait_speed = 16;

bird_codec_perch_x = 2;

bird_codec_perch_y = 2;


// ====================================================
// SHARED PORTRAIT ZOOM OWNER
//
// 0 = nobody
// 1 = JumpBot
// 2 = B1LL-E
// ====================================================

portrait_zoom_owner = 0;


// ====================================================
// JUMPBOT ZOOM
// ====================================================

jumpbot_zoom_state = 0;

jumpbot_zoom_amount = 0;

jumpbot_zoom_max = 1.35;

jumpbot_zoom_speed = 0.028;


jumpbot_zoom_hold_frames =
    round(
        room_speed * 0.45
    );

jumpbot_zoom_hold_timer = 0;


jumpbot_zoom_wait_min =
    round(
        room_speed * 2.5
    );

jumpbot_zoom_wait_max =
    round(
        room_speed * 5.0
    );


jumpbot_zoom_wait_timer =
    irandom_range(
        jumpbot_zoom_wait_min,
        jumpbot_zoom_wait_max
    );


jumpbot_zoom_face_y = 0.28;

jumpbot_zoom_screen_y = 0.47;


// ====================================================
// B1LL-E ZOOM
// ====================================================

bille_zoom_state = 0;

bille_zoom_amount = 0;

bille_zoom_max = 1.35;

bille_zoom_speed = 0.028;


bille_zoom_hold_frames =
    round(
        room_speed * 0.45
    );

bille_zoom_hold_timer = 0;


bille_zoom_wait_min =
    round(
        room_speed * 2.8
    );

bille_zoom_wait_max =
    round(
        room_speed * 5.4
    );


bille_zoom_wait_timer =
    irandom_range(
        bille_zoom_wait_min,
        bille_zoom_wait_max
    );


bille_zoom_face_y = 0.22;

bille_zoom_screen_y = 0.46;


// ====================================================
// VIDEO FEED — JUMPBOT
// ====================================================

jumpbot_feed_frame_interval = 7;

jumpbot_feed_timer = 0;

jumpbot_feed_skip_chance = 0.10;

jumpbot_feed_hold_timer = 0;


jumpbot_feed_hold_wait_min =
    round(
        room_speed * 3.0
    );

jumpbot_feed_hold_wait_max =
    round(
        room_speed * 6.0
    );


jumpbot_feed_hold_wait_timer =
    irandom_range(
        jumpbot_feed_hold_wait_min,
        jumpbot_feed_hold_wait_max
    );


jumpbot_feed_hold_min = 2;

jumpbot_feed_hold_max = 4;


// ====================================================
// VIDEO FEED — B1LL-E
// ====================================================

bille_feed_frame_interval_talking = 5;

bille_feed_frame_interval_idle = 7;

bille_feed_timer = 0;


bille_feed_skip_chance = 0.16;


bille_feed_hold_timer = 0;


bille_feed_hold_wait_min =
    round(
        room_speed * 2.3
    );

bille_feed_hold_wait_max =
    round(
        room_speed * 5.0
    );


bille_feed_hold_wait_timer =
    irandom_range(
        bille_feed_hold_wait_min,
        bille_feed_hold_wait_max
    );


bille_feed_hold_min = 2;

bille_feed_hold_max = 5;


// ====================================================
// HORIZONTAL TEAR — JUMPBOT
// ====================================================

jumpbot_tear_active = false;

jumpbot_tear_timer = 0;

jumpbot_tear_y = 0;

jumpbot_tear_h = 4;

jumpbot_tear_xoff = 0;


jumpbot_tear_wait_min =
    round(
        room_speed * 3.5
    );

jumpbot_tear_wait_max =
    round(
        room_speed * 7.0
    );


jumpbot_tear_wait_timer =
    irandom_range(
        jumpbot_tear_wait_min,
        jumpbot_tear_wait_max
    );


// ====================================================
// HORIZONTAL TEAR — B1LL-E
// ====================================================

bille_tear_active = false;

bille_tear_timer = 0;

bille_tear_y = 0;

bille_tear_h = 4;

bille_tear_xoff = 0;


bille_tear_wait_min =
    round(
        room_speed * 2.8
    );

bille_tear_wait_max =
    round(
        room_speed * 6.0
    );


bille_tear_wait_timer =
    irandom_range(
        bille_tear_wait_min,
        bille_tear_wait_max
    );


// ====================================================
// FONTS
// ====================================================

codec_font =
    asset_get_index(
        "PIXELOPERATORBOLD14"
    );


codec_font_small =
    asset_get_index(
        "PIXELOPERATORREGULAR10"
    );


codec_frequency_font =
    asset_get_index(
        "fontCodecFrequency"
    );


if (codec_frequency_font == -1)
{
    codec_frequency_font =
        asset_get_index(
            "PIXELOPERATORBOLD18"
        );
}


// ====================================================
// FREQUENCY
// ====================================================

codec_frequency =
    "140.85";


// ====================================================
// COLOURS
// ====================================================

codec_colour =
    make_color_rgb(
        95,
        220,
        190
    );


codec_colour_bright =
    make_color_rgb(
        155,
        255,
        220
    );


codec_colour_dim =
    make_color_rgb(
        35,
        85,
        75
    );


codec_colour_dark =
    make_color_rgb(
        14,
        36,
        32
    );


codec_bg =
    make_color_rgb(
        4,
        10,
        10
    );


call_colour =
    make_color_rgb(
        240,
        45,
        40
    );


// ====================================================
// SCANLINES
// ====================================================

scanline_alpha = 0.08;

scanline_spacing = 4;


// ====================================================
// VOICE METER
// ====================================================

voice_meter_level = 1;

voice_meter_timer = 0;

voice_meter_speed = 10;

voice_meter_index = 0;


voice_meter_pattern =
[
    2,
    5,
    3,
    6,
    4,
    7,
    3,
    5,
    2,
    4,
    6,
    3,
    7,
    5,
    2,
    6,
    4,
    3
];


// ====================================================
// CODEC AUDIO ASSETS
// ====================================================

snd_codec_ring =
    asset_get_index(
        "CodecRing"
    );


snd_codec_open =
    asset_get_index(
        "CodecOpen"
    );


snd_codec_close =
    asset_get_index(
        "CodecClose"
    );


snd_bille_codec_talk =
[
    asset_get_index("B1LLTalkCodec1"),
    asset_get_index("B1LLTalkCodec2"),
    asset_get_index("B1LLTalkCodec3"),
    asset_get_index("B1LLTalkCodec4"),
    asset_get_index("B1LLTalkCodec5"),
    asset_get_index("B1LLTalkCodec6")
];


// ====================================================
// CODEC AUDIO SETTINGS
// ====================================================

if (!variable_instance_exists(id, "codec_ring_gain"))
{
    codec_ring_gain = 1.0;
}


if (!variable_instance_exists(id, "codec_open_gain"))
{
    codec_open_gain = 1.0;
}


if (!variable_instance_exists(id, "codec_close_gain"))
{
    codec_close_gain = 1.0;
}


if (!variable_instance_exists(id, "codec_talk_gain"))
{
    codec_talk_gain = 0.90;
}


if (!variable_instance_exists(id, "codec_talk_fade_ms"))
{
    codec_talk_fade_ms = 70;
}


// ====================================================
// RING AUDIO
// ====================================================

codec_call_voice =
    noone;


codec_ring_count =
    0;


codec_ring_target =
    2;


if (!variable_instance_exists(id, "codec_ring_overlap_frames"))
{
    codec_ring_overlap_frames = 45;
}


// ----------------------------------------------------
// Determine actual ring length
// ----------------------------------------------------

codec_ring_duration_frames =
    round(
        room_speed * 1.15
    );


if (snd_codec_ring != -1)
{
    var ring_length_seconds =
        audio_sound_length(
            snd_codec_ring
        );


    if (ring_length_seconds > 0)
    {
        codec_ring_duration_frames =
            max(
                1,
                round(
                    ring_length_seconds *
                    room_speed
                )
            );
    }
}


codec_ring_timer =
    0;


// ====================================================
// OPEN / CLOSE AUDIO
// ====================================================

codec_open_voice =
    noone;


codec_close_voice =
    noone;


codec_open_played =
    false;


codec_close_played =
    false;


// ====================================================
// B1LL-E CODEC TALK AUDIO
// ====================================================

bille_codec_voice =
    noone;


bille_codec_last_talk_index =
    -1;


// ====================================================
// STOP B1LL-E CODEC SPEECH
// ====================================================

stop_bille_codec_voice = function()
{
    if (
        bille_codec_voice != noone &&
        audio_is_playing(
            bille_codec_voice
        )
    )
    {
        audio_sound_gain(
            bille_codec_voice,
            0,
            codec_talk_fade_ms
        );
    }


    bille_codec_voice =
        noone;
};


// ====================================================
// PLAY RANDOM B1LL-E CODEC SPEECH
// ====================================================

play_bille_codec_voice = function()
{
    var count =
        array_length(
            snd_bille_codec_talk
        );


    if (count <= 0)
    {
        return;
    }


    var chosen =
        0;


    if (count == 1)
    {
        chosen = 0;
    }
    else
    {
        chosen =
            irandom(
                count - 1
            );


        while (
            chosen ==
            bille_codec_last_talk_index
        )
        {
            chosen =
                irandom(
                    count - 1
                );
        }
    }


    var snd =
        snd_bille_codec_talk[
            chosen
        ];


    if (snd == -1)
    {
        return;
    }


    bille_codec_last_talk_index =
        chosen;


    bille_codec_voice =
        audio_play_sound(
            snd,
            25,
            false
        );


    if (bille_codec_voice != noone)
    {
        audio_sound_gain(
            bille_codec_voice,
            codec_talk_gain,
            0
        );
    }
};


// ====================================================
// PLAY CODEC RING
// ====================================================

play_codec_ring = function()
{
    if (
        snd_codec_ring == -1 ||
        codec_ring_count >=
            codec_ring_target
    )
    {
        return;
    }


    codec_call_voice =
        audio_play_sound(
            snd_codec_ring,
            100,
            false
        );


    if (codec_call_voice != noone)
    {
        audio_sound_gain(
            codec_call_voice,
            codec_ring_gain,
            0
        );


        codec_ring_count++;


        codec_ring_timer =
            codec_ring_duration_frames;
    }
};


// Start ring 1 immediately.
play_codec_ring();


// ====================================================
// LOAD CURRENT LINE
// ====================================================

load_current_line = function()
{
    stop_bille_codec_voice();


    if (
        dialogue_index < 0 ||
        dialogue_index >=
            array_length(
                dialogue
            )
    )
    {
        return;
    }


    current_speaker =
        dialogue[
            dialogue_index
        ].speaker;


    current_text =
        dialogue[
            dialogue_index
        ].text;


    display_text =
        "";


    char_index =
        0;


    line_finished =
        false;


    text_char_accumulator =
        0;


    text_pause_timer =
        0;


    voice_meter_timer =
        0;


    voice_meter_index =
        0;


    voice_meter_level =
        1;


    // =================================================
    // B1LL-E SPEAKING
    //
    // Resume exactly where his previous talking
    // animation froze.
    // =================================================

    if (
        current_speaker ==
        "B1LL-E"
    )
    {
        bille_start_talking();


        play_bille_codec_voice();
    }


    // =================================================
    // JUMPBOT SPEAKING
    //
    // IMPORTANT:
    //
    // Do NOT send B1LL-E back to idle.
    //
    // If B1LL-E has already spoken during this codec,
    // leave him frozen on his last talking frame while
    // he listens.
    // =================================================

    else
    {
        if (
            bille_has_talked &&
            bille_talking_sprite != -1
        )
        {
            bille_active_sprite =
                bille_talking_sprite;


            bille_portrait_frame =
                bille_talking_resume_frame;


            bille_portrait_mode =
                "frozen";
        }
        else
        {
            bille_portrait_mode =
                "idle";


            bille_active_sprite =
                bille_idle_sprite;
        }
    }
};


// ====================================================
// BEGIN DIALOGUE
// ====================================================

begin_dialogue = function()
{
    dialogue_index =
        0;


    bille_has_talked =
        false;


    bille_talking_resume_frame =
        0;


    load_current_line();
};


// ====================================================
// FINISH CODEC
// ====================================================

finish_codec = function()
{
    stop_bille_codec_voice();


    codec_state =
        3;


    codec_close_state =
        0;


    portrait_close_hold_timer =
        0;


    // Whole conversation is complete, so NOW B1LL-E
    // may return to idle.
    bille_return_idle();


    jumpbot_zoom_state =
        3;


    bille_zoom_state =
        3;


    // ------------------------------------------------
    // CLOSE SOUND
    // ------------------------------------------------

    if (
        !codec_close_played &&
        snd_codec_close != -1
    )
    {
        codec_close_voice =
            audio_play_sound(
                snd_codec_close,
                100,
                false
            );


        if (codec_close_voice != noone)
        {
            audio_sound_gain(
                codec_close_voice,
                codec_close_gain,
                0
            );
        }


        codec_close_played =
            true;
    }
};


// ====================================================
// INITIALIZATION COMPLETE
// ====================================================

codec_initialized =
    true;