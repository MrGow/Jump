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

call_duration =
    round(
        room_speed * 1.15
    );

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


portrait_close_speed = 0.050;

portrait_close_hold =
    round(
        room_speed * 0.65
    );

portrait_close_hold_timer = 0;


// 0 = close portraits
// 1 = hold closed
// 2 = fade interface
codec_close_state = 0;


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


// Codec handles its own physical press/release state.
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


// Kept for compatibility.
jumpbot_portrait_timer = 0;

jumpbot_portrait_speed = 6;


jumpbot_portrait_padding_x = 12;
jumpbot_portrait_padding_y = 10;


// ====================================================
// B1LL-E PORTRAIT
// ====================================================

bille_portrait_frame = 0;

bille_portrait_timer = 0;


bille_idle_portrait_speed = 6;

bille_talking_portrait_speed = 6;


bille_portrait_mode = "idle";


bille_talking_resume_frame = 0;


bille_portrait_padding_x = 12;
bille_portrait_padding_y = 10;


// ====================================================
// B1LL-E PORTRAIT HELPERS
// ====================================================

bille_start_talking = function()
{
    bille_portrait_mode =
        "talking";


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


        bille_portrait_frame =
            bille_talking_resume_frame;
    }
    else
    {
        bille_active_sprite =
            bille_idle_sprite;

        bille_portrait_frame =
            0;
    }


    bille_feed_timer = 0;
};


bille_stop_talking = function()
{
    if (
        bille_portrait_mode == "talking" &&
        bille_talking_sprite != -1
    )
    {
        bille_talking_resume_frame =
            bille_portrait_frame;
    }


    bille_portrait_mode =
        "idle";


    bille_active_sprite =
        bille_idle_sprite;


    bille_portrait_frame =
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
// AUDIO
// ====================================================

snd_codec_call =
    asset_get_index(
        "CodecCall1"
    );


codec_call_voice =
    noone;


if (
    snd_codec_call != -1 &&
    audio_group_is_loaded(
        audiogroupui
    )
)
{
    codec_call_voice =
        audio_play_sound(
            snd_codec_call,
            100,
            false
        );


    if (codec_call_voice != noone)
    {
        audio_sound_gain(
            codec_call_voice,
            1,
            0
        );
    }
}


// ====================================================
// LOAD CURRENT LINE
// ====================================================

load_current_line = function()
{
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


    if (
        current_speaker ==
        "B1LL-E"
    )
    {
        bille_start_talking();
    }
    else
    {
        bille_stop_talking();
    }
};


// ====================================================
// BEGIN DIALOGUE
// ====================================================

begin_dialogue = function()
{
    dialogue_index = 0;

    load_current_line();
};


// ====================================================
// FINISH CODEC
// ====================================================

finish_codec = function()
{
    codec_state =
        3;


    codec_close_state =
        0;


    portrait_close_hold_timer =
        0;


    bille_stop_talking();


    jumpbot_zoom_state =
        3;


    bille_zoom_state =
        3;
};


// ====================================================
// INITIALIZATION COMPLETE
// ====================================================

codec_initialized = true;