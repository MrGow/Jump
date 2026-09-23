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
    capture_arrived = false;

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
    // GENTLE BREATHING
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
    // PLAYER CENTRE
    // ------------------------------------------------

    var _px =
        (
            _player.bbox_left +
            _player.bbox_right
        )
        * 0.5;

    var _py =
        (
            _player.bbox_top +
            _player.bbox_bottom
        )
        * 0.5;


    // ------------------------------------------------
    // CAPTURE RANGE
    // ------------------------------------------------

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

        capture_arrived =
            false;

        jump_released =
            false;

        spinner_angle =
            spinner_start_angle;


        // ============================================
        // START AT CURRENT NORMAL SIZE
        // ============================================

        captured_player.gravity_bubble_visual_scale =
            1.0;

        captured_player.gravity_bubble_scale_recover =
            false;

        captured_player.gravity_bubble_pressure_scale =
            1.0;


        // ============================================
        // TAKE CONTROL
        // ============================================

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
// PULL + COMPRESS PLAYER
// ====================================================

if (bubble_state == 1)
{
    if (!instance_exists(captured_player))
    {
        bubble_state = 0;
        capture_arrived = false;
        exit;
    }


    // ------------------------------------------------
    // SMOOTH GRAVITY COMPRESSION
    //
    // This is intentionally independent of how quickly
    // the player physically reaches the bubble centre.
    // ------------------------------------------------

    captured_player.gravity_bubble_visual_scale =
        lerp(
            captured_player.gravity_bubble_visual_scale,
            captured_player_scale,
            capture_scale_lerp
        );


    // ------------------------------------------------
    // BUBBLE BULGES SLIGHTLY AS THE PLAYER COMPRESSES
    // ------------------------------------------------

    var _compression_range =
        max(
            0.001,
            1.0 -
            captured_player_scale
        );

    var _compression_amount =
        clamp(
            (
                1.0 -
                captured_player.gravity_bubble_visual_scale
            )
            /
            _compression_range,
            0,
            1
        );

    var _bubble_bulge =
        _compression_amount *
        0.035;

    visual_scale_x =
        1 + _bubble_bulge;

    visual_scale_y =
        1 + _bubble_bulge;

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
    // DISTANCE TO CENTRE
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
    // MAGNETIC PULL
    // ------------------------------------------------

    if (!capture_arrived)
    {
        if (_distance <= capture_pull_speed)
        {
            captured_player.x +=
                _dx;

            captured_player.y +=
                _dy;

            capture_arrived =
                true;
        }
        else
        {
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
        }
    }


    // ------------------------------------------------
    // KEEP PLAYER CENTRED ONCE ARRIVED
    // ------------------------------------------------

    if (capture_arrived)
    {
        _player_centre_x =
            (
                captured_player.bbox_left +
                captured_player.bbox_right
            )
            * 0.5;

        _player_centre_y =
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
    }


    captured_player.hsp = 0;
    captured_player.vsp = 0;


    // ------------------------------------------------
    // WAIT FOR COMPRESSION TO FINISH
    //
    // Reaching the centre does NOT instantly snap the
    // player to the final size.
    // ------------------------------------------------

    var _scale_ready =
        abs(
            captured_player.gravity_bubble_visual_scale -
            captured_player_scale
        )
        <= 0.008;


    if (
        capture_arrived &&
        _scale_ready
    )
    {
        captured_player.gravity_bubble_visual_scale =
            captured_player_scale;

        captured_player.gravity_bubble_pressure_scale =
            1.0;

        bubble_state =
            2;

        sprite_index =
            spriteBubbleActive;

        image_index = 0;
        image_speed = 0;

        visual_scale_x = 1;
        visual_scale_y = 1;

        visual_offset_y = 0;
    }

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
    // BASE COMPRESSION
    // ------------------------------------------------

    captured_player.gravity_bubble_visual_scale =
        captured_player_scale;

    captured_player.gravity_bubble_scale_recover =
        false;


    // ------------------------------------------------
    // GRAVITY PRESSURE
    //
    // Tiny extra compression/expansion while held.
    // This makes the bot/bird feel like the field is
    // actively squeezing them.
    // ------------------------------------------------

    var _pressure =
        sin(
            visual_time *
            captured_pressure_speed
        )
        *
        captured_pressure_amount;

    captured_player.gravity_bubble_pressure_scale =
        1.0 -
        _pressure;


    // ------------------------------------------------
    // BUBBLE REACTS INVERSELY
    // ------------------------------------------------

    var _active_pulse =
        sin(
            visual_time *
            active_pulse_speed
        )
        *
        active_pulse_amount;

    visual_scale_x =
        1 +
        _active_pulse +
        (_pressure * 0.5);

    visual_scale_y =
        1 +
        _active_pulse +
        (_pressure * 0.5);

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
            state =
                "glide";

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


            // ========================================
            // LAUNCH EXPANSION
            //
            // Remain compressed for the first three
            // frames, then expand smoothly while
            // travelling.
            // ========================================

            gravity_bubble_pressure_scale =
                1.0;

            gravity_bubble_scale_recover =
                true;

            gravity_bubble_scale_recover_delay =
                3;

            gravity_bubble_scale_recover_lerp =
                0.20;
        }


        captured_player =
            noone;


        // ============================================
        // USE ANIMATION
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
    // GROW FROM NOTHING
    //
    // Slight overshoot before settling to normal size.
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