/// oGravityBubble — Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// VISUAL CLOCK
// ====================================================

visual_time++;


// ====================================================
// PLAYER SAFETY
// ====================================================

if (
    captured_player != noone &&
    !instance_exists(captured_player)
)
{
    captured_player = noone;

    bubble_state = 0;

    sprite_index =
        spriteBubbleIdle;

    image_index = 0;
    image_speed = 0;
}


// ====================================================
// IDLE
// ====================================================

if (bubble_state == 0)
{
    // ------------------------------------------------
    // SPRITE
    // ------------------------------------------------

    if (sprite_index != spriteBubbleIdle)
    {
        sprite_index =
            spriteBubbleIdle;

        image_index = 0;
        image_speed = 0;
    }


    // ------------------------------------------------
    // GENTLE FLOAT
    // ------------------------------------------------

    visual_offset_y =
        sin(
            visual_time *
            idle_bob_speed
        )
        *
        idle_bob_amount;


    // ------------------------------------------------
    // GENTLE BREATHING / SQUASH
    // ------------------------------------------------

    var _pulse =
        sin(
            visual_time *
            idle_pulse_speed
        )
        *
        idle_pulse_amount;

    visual_scale_x =
        1 + _pulse;

    visual_scale_y =
        1 - (_pulse * 0.65);

    visual_alpha = 1;


    // ------------------------------------------------
    // FIND PLAYER
    // ------------------------------------------------

    var _player =
        instance_find(
            oPlayer,
            0
        );

    if (!instance_exists(_player))
    {
        exit;
    }

    if (
        variable_instance_exists(
            _player,
            "state"
        )
        &&
        _player.state == "dead"
    )
    {
        exit;
    }


    // ------------------------------------------------
    // CAPTURE RANGE
    // ------------------------------------------------

    var _px =
        (_player.bbox_left + _player.bbox_right)
        * 0.5;

    var _py =
        (_player.bbox_top + _player.bbox_bottom)
        * 0.5;

    var _distance =
        point_distance(
            x,
            y,
            _px,
            _py
        );


    // ------------------------------------------------
    // BEGIN CAPTURE
    // ------------------------------------------------

    if (_distance <= capture_radius)
    {
        captured_player =
            _player;

        bubble_state =
            1;

        jump_released =
            false;

        capture_visual_timer =
            0;


        // Reset pointer every time the bubble catches
        // the player.
        spinner_angle =
            spinner_start_angle;


        with (captured_player)
        {
            state =
                "gravity_bubble";

            hsp = 0;
            vsp = 0;

            jump_charging = false;
            jump_charge = 0;
            jump_charge_level = 0;

            charge_grace = 0;
            support_grace = 0;
            charge_start_lock = 0;

            bounce_pending = false;
            bounce_timer = 0;

            standing_platform =
                noone;
        }
    }

    exit;
}


// ====================================================
// PULL PLAYER TO CENTRE
// ====================================================

if (bubble_state == 1)
{
    if (!instance_exists(captured_player))
    {
        bubble_state = 0;
        exit;
    }


    // ------------------------------------------------
    // CAPTURE VISUAL
    // ------------------------------------------------

    capture_visual_timer++;

    var _capture_progress =
        clamp(
            capture_visual_timer /
            capture_visual_frames,
            0,
            1
        );


    // Compress first, then settle back toward normal.

    var _capture_pulse =
        sin(
            _capture_progress *
            pi
        )
        *
        0.08;

    visual_scale_x =
        1 - _capture_pulse;

    visual_scale_y =
        1 + (_capture_pulse * 0.5);

    visual_offset_y = 0;
    visual_alpha = 1;


    // ------------------------------------------------
    // PLAYER CENTRE
    // ------------------------------------------------

    var _player_centre_x =
        (
            captured_player.bbox_left +
            captured_player.bbox_right
        )
        * 0.5;

    var _player_centre_y =
        (
            captured_player.bbox_top +
            captured_player.bbox_bottom
        )
        * 0.5;


    // ------------------------------------------------
    // DISTANCE TO BUBBLE CENTRE
    // ------------------------------------------------

    var _dx =
        x -
        _player_centre_x;

    var _dy =
        y -
        _player_centre_y;

    var _distance =
        point_distance(
            0,
            0,
            _dx,
            _dy
        );


    // ------------------------------------------------
    // ARRIVED
    // ------------------------------------------------

    if (_distance <= capture_pull_speed)
    {
        captured_player.x +=
            _dx;

        captured_player.y +=
            _dy;

        captured_player.hsp = 0;
        captured_player.vsp = 0;


        bubble_state =
            2;

        sprite_index =
            spriteBubbleActive;

        image_index = 0;
        image_speed = 0;

        visual_scale_x = 1;
        visual_scale_y = 1;

        visual_offset_y = 0;

        exit;
    }


    // ------------------------------------------------
    // MAGNETIC PULL
    // ------------------------------------------------

    var _pull_direction =
        point_direction(
            _player_centre_x,
            _player_centre_y,
            x,
            y
        );

    captured_player.x +=
        lengthdir_x(
            capture_pull_speed,
            _pull_direction
        );

    captured_player.y +=
        lengthdir_y(
            capture_pull_speed,
            _pull_direction
        );

    captured_player.hsp = 0;
    captured_player.vsp = 0;

    exit;
}


// ====================================================
// ACTIVE / AIMING
// ====================================================

if (bubble_state == 2)
{
    if (!instance_exists(captured_player))
    {
        bubble_state = 0;
        exit;
    }


    // ------------------------------------------------
    // ACTIVE SPRITE
    // ------------------------------------------------

    if (sprite_index != spriteBubbleActive)
    {
        sprite_index =
            spriteBubbleActive;

        image_index = 0;
        image_speed = 0;
    }


    // ------------------------------------------------
    // KEEP PLAYER EXACTLY CENTRED
    // ------------------------------------------------

    var _player_centre_x =
        (
            captured_player.bbox_left +
            captured_player.bbox_right
        )
        * 0.5;

    var _player_centre_y =
        (
            captured_player.bbox_top +
            captured_player.bbox_bottom
        )
        * 0.5;

    captured_player.x +=
        x -
        _player_centre_x;

    captured_player.y +=
        y -
        _player_centre_y;

    captured_player.hsp = 0;
    captured_player.vsp = 0;


    // ------------------------------------------------
    // SUBTLE ACTIVE PULSE
    // ------------------------------------------------

    var _active_pulse =
        sin(
            visual_time *
            active_pulse_speed
        )
        *
        active_pulse_amount;

    visual_scale_x =
        1 + _active_pulse;

    visual_scale_y =
        1 + _active_pulse;

    visual_offset_y = 0;
    visual_alpha = 1;


    // ------------------------------------------------
    // ROTATE POINTER
    // ------------------------------------------------

    spinner_angle +=
        spinner_speed *
        spinner_direction;

    spinner_angle =
        spinner_angle mod 360;


    // ------------------------------------------------
    // JUMP INPUT
    //
    // Uses the same global remappable input system as
    // the player.
    // ------------------------------------------------

    var _jump_held =
        false;

    var _jump_pressed =
        false;

    if (variable_global_exists("inp_jump_held"))
    {
        _jump_held =
            global.inp_jump_held;
    }

    if (variable_global_exists("inp_jump_press"))
    {
        _jump_pressed =
            global.inp_jump_press;
    }


    // ------------------------------------------------
    // REQUIRE RELEASE FIRST
    // ------------------------------------------------

    if (!_jump_held)
    {
        jump_released =
            true;
    }


    // ------------------------------------------------
    // LAUNCH
    // ------------------------------------------------

    if (
        jump_released &&
        _jump_pressed
    )
    {
        var _launch_hsp =
            lengthdir_x(
                launch_speed,
                spinner_angle
            );

        var _launch_vsp =
            lengthdir_y(
                launch_speed,
                spinner_angle
            );


        // ============================================
        // RELEASE PLAYER
        // ============================================

        with (captured_player)
        {
            state = "glide";

            hsp =
                _launch_hsp;

            vsp =
                _launch_vsp;

            jump_charging = false;
            jump_charge = 0;
            jump_charge_level = 0;

            charge_grace = 0;
            support_grace = 0;
            charge_start_lock = 0;

            bounce_pending = false;
            bounce_timer = 0;

            standing_platform =
                noone;
        }


        captured_player =
            noone;


        // ============================================
        // PLAY USE ANIMATION
        // ============================================

        bubble_state =
            3;

        sprite_index =
            spriteBubbleUse;

        image_index = 0;
        image_speed = 1;

        visual_scale_x = 1;
        visual_scale_y = 1;

        visual_offset_y = 0;
        visual_alpha = 1;

        exit;
    }

    exit;
}


// ====================================================
// USE ANIMATION
// ====================================================

if (bubble_state == 3)
{
    visual_scale_x = 1;
    visual_scale_y = 1;

    visual_offset_y = 0;
    visual_alpha = 1;


    // ------------------------------------------------
    // WAIT FOR FINAL FRAME
    // ------------------------------------------------

    var _last_frame =
        sprite_get_number(
            spriteBubbleUse
        )
        - 1;


    if (image_index >= _last_frame)
    {
        image_index =
            _last_frame;

        image_speed = 0;

        bubble_state =
            4;

        cooldown_timer =
            round(
                respawn_time_s *
                room_speed
            );

        visible = false;
    }

    exit;
}


// ====================================================
// COOLDOWN
// ====================================================

if (bubble_state == 4)
{
    cooldown_timer--;

    if (cooldown_timer > 0)
    {
        exit;
    }


    // ------------------------------------------------
    // BEGIN RESPAWN
    // ------------------------------------------------

    bubble_state =
        5;

    sprite_index =
        spriteBubbleIdle;

    image_index = 0;
    image_speed = 0;

    visible = true;

    respawn_timer = 0;

    visual_scale_x = 0;
    visual_scale_y = 0;

    visual_offset_y = 0;
    visual_alpha = 0;

    exit;
}


// ====================================================
// RESPAWN
// ====================================================

if (bubble_state == 5)
{
    respawn_timer++;


    var _t =
        clamp(
            respawn_timer /
            respawn_frames,
            0,
            1
        );


    // ------------------------------------------------
    // FADE IN
    // ------------------------------------------------

    visual_alpha =
        _t;


    // ------------------------------------------------
    // GROW IN
    //
    // Starts at nothing, grows slightly beyond normal,
    // then settles to 1.0.
    // ------------------------------------------------

    var _scale;

    if (_t < 0.75)
    {
        _scale =
            lerp(
                0,
                1.10,
                _t / 0.75
            );
    }
    else
    {
        _scale =
            lerp(
                1.10,
                1.0,
                (_t - 0.75) / 0.25
            );
    }


    visual_scale_x =
        _scale;

    visual_scale_y =
        _scale;

    visual_offset_y = 0;


    // ------------------------------------------------
    // FINISHED
    // ------------------------------------------------

    if (_t >= 1)
    {
        visual_scale_x = 1;
        visual_scale_y = 1;

        visual_alpha = 1;

        bubble_state = 0;
    }

    exit;
}