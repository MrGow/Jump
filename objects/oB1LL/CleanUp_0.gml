/// oB1LL — Clean Up


// ====================================================
// STOP B1LL-E AUDIO
// ====================================================

if (
    b1ll_talk_voice != noone &&
    audio_is_playing(
        b1ll_talk_voice
    )
)
{
    audio_stop_sound(
        b1ll_talk_voice
    );
}


if (
    b1ll_float_voice != noone &&
    audio_is_playing(
        b1ll_float_voice
    )
)
{
    audio_stop_sound(
        b1ll_float_voice
    );
}


if (
    b1ll_malfunction_voice != noone &&
    audio_is_playing(
        b1ll_malfunction_voice
    )
)
{
    audio_stop_sound(
        b1ll_malfunction_voice
    );
}


b1ll_talk_voice =
    noone;

b1ll_float_voice =
    noone;

b1ll_malfunction_voice =
    noone;


// ====================================================
// DIALOGUE CLEANUP
// ====================================================

if (dialogue_active)
{
    if (
        variable_global_exists(
            "npc_dialogue_active"
        )
    )
    {
        global.npc_dialogue_active =
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


    if (instance_exists(sequence_player))
    {
        if (
            variable_instance_exists(
                sequence_player,
                "dialogue_locked"
            )
        )
        {
            sequence_player.dialogue_locked =
                false;
        }


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
    }
}