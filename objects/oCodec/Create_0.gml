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
// 0 = incoming CALL
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
// PORTRAIT OPEN / CLOSE TRANSITION
// ====================================================

portrait_open = 0;

// Opening speed.
portrait_open_speed = 0.055;

// Hold closed before opening.
portrait_open_delay =
    room_speed;

portrait_open_delay_timer = 0;


// ----------------------------------------------------
// Closing
// ----------------------------------------------------

// Slightly slower than opening feels nice.
portrait_close_speed = 0.050;

// Hold after portraits have fully closed before the
// whole codec fades away.
portrait_close_hold =
    round(
        room_speed * 0.25
    );

portrait_close_hold_timer = 0;

// Closing sub-state:
//
// 0 = closing portraits
// 1 = closed hold
// 2 = fade whole codec out
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

type_timer = 0;

type_delay = 2;

line_finished = false;


// ====================================================
// INPUT GUARD
// ====================================================

input_lock_frames = 8;


// ====================================================
// PORTRAITS
// ====================================================

jumpbot_sprite =
    asset_get_index(
        "spriteBotIdle"
    );

bille_sprite = -1;


// ====================================================
// JUMPBOT PORTRAIT ANIMATION
// ====================================================

jumpbot_portrait_frame = 0;
jumpbot_portrait_timer = 0;

jumpbot_portrait_speed = 6;


// ====================================================
// JUMPBOT CODEC PORTRAIT
// ====================================================

jumpbot_portrait_padding_x = 12;
jumpbot_portrait_padding_y = 10;


// ====================================================
// BIRD CODEC PORTRAIT
// ====================================================

bird_portrait_sprite =
    asset_get_index(
        "spriteBirdIdle"
    );

bird_portrait_frame = 0;
bird_portrait_timer = 0;

bird_portrait_speed = 10;

bird_codec_perch_x = 2;
bird_codec_perch_y = -6;


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

// Slower than before.
// Was 7.
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
    audio_group_is_loaded(audiogroupui)
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
        dialogue_index >= array_length(dialogue)
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


    display_text = "";

    char_index = 0;

    type_timer = 0;

    line_finished = false;


    voice_meter_timer = 0;
    voice_meter_index = 0;
    voice_meter_level = 1;
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
    codec_state = 3;
};