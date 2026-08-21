/// oB1LL — Clean Up

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