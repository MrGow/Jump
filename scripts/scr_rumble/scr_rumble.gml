/// scr_rumble

/// @func scr_rumble_play(_low, _high, _frames, [_replace])
/// @desc Starts controller vibration through oInput.
///       Low motor = heavy rumble.
///       High motor = sharper buzz.
/// @param _low       Low-frequency motor strength, 0–1.
/// @param _high      High-frequency motor strength, 0–1.
/// @param _frames    Duration in game frames.
/// @param _replace   Optional. True replaces current rumble.
///                   False keeps whichever rumble is stronger/longer.

function scr_rumble_play(
    _low,
    _high,
    _frames,
    _replace
)
{
    if (is_undefined(_replace))
    {
        _replace = true;
    }

    if (!variable_global_exists("controller_vibration"))
    {
        global.controller_vibration = 2;
    }

    // Disabled in settings.
    if (global.controller_vibration <= 0)
    {
        return false;
    }

    var input_inst =
        instance_find(
            oInput,
            0
        );

    if (!instance_exists(input_inst))
    {
        return false;
    }

    if (
        !variable_instance_exists(
            input_inst,
            "gamepad_index"
        )
    )
    {
        return false;
    }

    var slot =
        input_inst.gamepad_index;

    if (
        slot < 0 ||
        !gamepad_is_connected(slot)
    )
    {
        return false;
    }

    // Settings strength.
    var strength_mult = 1;

    // Low mode.
    if (global.controller_vibration == 1)
    {
        strength_mult = 0.5;
    }

    var low =
        clamp(
            _low * strength_mult,
            0,
            1
        );

    var high =
        clamp(
            _high * strength_mult,
            0,
            1
        );

    var frames =
        max(
            1,
            round(_frames)
        );

    if (_replace)
    {
        input_inst.rumble_low_motor  = low;
        input_inst.rumble_high_motor = high;
        input_inst.rumble_timer      = frames;
    }
    else
    {
        input_inst.rumble_low_motor =
            max(
                input_inst.rumble_low_motor,
                low
            );

        input_inst.rumble_high_motor =
            max(
                input_inst.rumble_high_motor,
                high
            );

        input_inst.rumble_timer =
            max(
                input_inst.rumble_timer,
                frames
            );
    }

    gamepad_set_vibration(
        slot,
        input_inst.rumble_low_motor,
        input_inst.rumble_high_motor
    );

    return true;
}


/// @func scr_rumble_stop()
/// @desc Immediately stops controller vibration.

function scr_rumble_stop()
{
    var input_inst =
        instance_find(
            oInput,
            0
        );

    if (!instance_exists(input_inst))
    {
        return;
    }

    input_inst.rumble_timer      = 0;
    input_inst.rumble_low_motor  = 0;
    input_inst.rumble_high_motor = 0;

    if (
        variable_instance_exists(
            input_inst,
            "gamepad_index"
        )
    )
    {
        var slot =
            input_inst.gamepad_index;

        if (
            slot >= 0 &&
            gamepad_is_connected(slot)
        )
        {
            gamepad_set_vibration(
                slot,
                0,
                0
            );
        }
    }
}