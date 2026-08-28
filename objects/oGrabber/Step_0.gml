/// oGrabber — Step

dx = 0;
dy = 0;

// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "route_id")) route_id = 0;
if (!variable_instance_exists(id, "move_speed")) move_speed = 2.0;
if (!variable_instance_exists(id, "close_animation_speed")) close_animation_speed = 0.25;
if (!variable_instance_exists(id, "open_animation_speed")) open_animation_speed = 0.25;
if (!variable_instance_exists(id, "destination")) destination = noone;
if (!variable_instance_exists(id, "grabbed_player")) grabbed_player = noone;
if (!variable_instance_exists(id, "grab_state")) grab_state = "idle";
if (!variable_instance_exists(id, "release_armed")) release_armed = false;
if (!variable_instance_exists(id, "claw_opening")) claw_opening = false;
if (!variable_instance_exists(id, "start_x")) start_x = x;
if (!variable_instance_exists(id, "start_y")) start_y = y;
if (!variable_instance_exists(id, "last_dx")) last_dx = 0;
if (!variable_instance_exists(id, "release_momentum")) release_momentum = 1.0;
if (!variable_instance_exists(id, "release_vsp")) release_vsp = 0;
if (!variable_instance_exists(id, "release_input_lock_frames")) release_input_lock_frames = 6;
if (!variable_instance_exists(id, "release_input_lock")) release_input_lock = 0;
if (!variable_instance_exists(id, "capture_half_width")) capture_half_width = 16;
if (!variable_instance_exists(id, "capture_top_offset")) capture_top_offset = 0;
if (!variable_instance_exists(id, "capture_bottom_offset")) capture_bottom_offset = 28;
if (!variable_instance_exists(id, "player_hold_top_offset")) player_hold_top_offset = 10;

if (!variable_instance_exists(id, "sway_length")) sway_length = 24;
if (!variable_instance_exists(id, "sway_move_lean")) sway_move_lean = 5.0;
if (!variable_instance_exists(id, "sway_idle_amount")) sway_idle_amount = 1.1;
if (!variable_instance_exists(id, "sway_idle_speed")) sway_idle_speed = 0.075;
if (!variable_instance_exists(id, "sway_spring")) sway_spring = 0.075;
if (!variable_instance_exists(id, "sway_damping")) sway_damping = 0.88;
if (!variable_instance_exists(id, "sway_stop_kick")) sway_stop_kick = 1.6;
if (!variable_instance_exists(id, "sway_release_kick")) sway_release_kick = 0.22;
if (!variable_instance_exists(id, "catch_jerk_pixels")) catch_jerk_pixels = 2.0;
if (!variable_instance_exists(id, "machine_vibration_amount")) machine_vibration_amount = 0.65;
if (!variable_instance_exists(id, "sway_angle")) sway_angle = 0;
if (!variable_instance_exists(id, "sway_velocity")) sway_velocity = 0;
if (!variable_instance_exists(id, "sway_phase")) sway_phase = 0;
if (!variable_instance_exists(id, "catch_jerk")) catch_jerk = 0;
if (!variable_instance_exists(id, "player_visual_offset_x")) player_visual_offset_x = 0;
if (!variable_instance_exists(id, "player_visual_offset_y")) player_visual_offset_y = 0;
if (!variable_instance_exists(id, "player_visual_angle")) player_visual_angle = 0;
if (!variable_instance_exists(id, "machine_visual_y")) machine_visual_y = 0;

// ====================================================
// AUDIO HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "snd_grabber_grab"))
    snd_grabber_grab = asset_get_index("GrabberGrab");

if (!variable_instance_exists(id, "snd_grabber_move_loop"))
    snd_grabber_move_loop = asset_get_index("GrabberMovementLoop");

if (!variable_instance_exists(id, "snd_grabber_release"))
    snd_grabber_release = asset_get_index("GrabberRelease");

if (!variable_instance_exists(id, "grabber_move_loop_instance"))
    grabber_move_loop_instance = -1;

if (!variable_instance_exists(id, "grabber_move_current_gain"))
    grabber_move_current_gain = 0;

if (!variable_instance_exists(id, "grabber_move_audio_allowed"))
    grabber_move_audio_allowed = false;

// ====================================================
// PAUSE / MENU FREEZE
// ====================================================

var freeze_grabber = false;
if (variable_global_exists("game_phase"))
{
    freeze_grabber =
        global.game_phase == "paused" ||
        global.game_phase == "menu" ||
        global.game_phase == "death_menu" ||
        global.game_phase == "codec";
}

if (freeze_grabber)
{
    image_speed = 0;
    grabber_stop_move_loop();
    exit;
}

// ====================================================
// FIND DESTINATION AND PLAYER
// ====================================================

if (!instance_exists(destination))
{
    destination = noone;
    var destination_count = instance_number(oGrabberTarget);

    for (var destination_index = 0; destination_index < destination_count; destination_index++)
    {
        var candidate = instance_find(oGrabberTarget, destination_index);
        if (
            instance_exists(candidate) &&
            variable_instance_exists(candidate, "target_id") &&
            candidate.target_id == route_id
        )
        {
            destination = candidate;
            break;
        }
    }
}

var player = noone;
if (instance_exists(oPlayer)) player = instance_find(oPlayer, 0);

// ====================================================
// PLAYER DEATH RESET
// ====================================================

var player_dead =
    instance_exists(player) &&
    variable_instance_exists(player, "state") &&
    player.state == "dead";

if (player_dead)
{
    if (instance_exists(grabbed_player) && variable_instance_exists(grabbed_player, "grabbed_by"))
        grabbed_player.grabbed_by = noone;

    grabbed_player = noone;
    release_armed = false;
    release_input_lock = 0;
    claw_opening = false;
    x = start_x;
    y = start_y;
    dx = 0;
    dy = 0;
    last_dx = 0;
    grab_state = "idle";
    sway_angle = 0;
    sway_velocity = 0;
    catch_jerk = 0;
    player_visual_offset_x = 0;
    player_visual_offset_y = 0;
    player_visual_angle = 0;
    machine_visual_y = 0;
    image_speed = 0;
    image_index = max(0, image_number - 1);
    grabber_stop_move_loop();
    exit;
}

// ====================================================
// LOST PLAYER SAFETY
// ====================================================

if (grabbed_player != noone && !instance_exists(grabbed_player))
{
    grabbed_player = noone;
    release_armed = false;
    release_input_lock = 0;
    claw_opening = true;
    if (grab_state == "closing") grab_state = "moving";
}

// ====================================================
// VISUAL PENDULUM UPDATE
// ====================================================

sway_phase += sway_idle_speed;

if (instance_exists(grabbed_player))
{
    var travel_sign = sign(last_dx);
    var target_sway = sin(sway_phase) * sway_idle_amount;

    if (grab_state == "moving" && travel_sign != 0)
        target_sway -= travel_sign * sway_move_lean;

    sway_velocity += (target_sway - sway_angle) * sway_spring;
    sway_velocity *= sway_damping;
    sway_angle += sway_velocity;

    catch_jerk = lerp(catch_jerk, 0, 0.20);

    var sway_radians = degtorad(sway_angle);
    player_visual_offset_x = sin(sway_radians) * sway_length;
    player_visual_offset_y =
        (1 - cos(sway_radians)) * sway_length +
        catch_jerk;
    player_visual_angle = sway_angle * 0;

    if (grab_state == "moving")
        machine_visual_y = sin(sway_phase * 2.7) * machine_vibration_amount;
    else
        machine_visual_y = lerp(machine_visual_y, 0, 0.3);
}
else
{
    sway_angle = lerp(sway_angle, 0, 0.22);
    sway_velocity *= 0.75;
    catch_jerk = lerp(catch_jerk, 0, 0.25);
    player_visual_offset_x = 0;
    player_visual_offset_y = 0;
    player_visual_angle = 0;

    if (grab_state == "moving")
        machine_visual_y = sin(sway_phase * 2.7) * machine_vibration_amount;
    else
        machine_visual_y = lerp(machine_visual_y, 0, 0.3);
}

// ====================================================
// IDLE — CAPTURE PLAYER
// ====================================================

if (grab_state == "idle")
{
    image_speed = 0;
    image_index = max(0, image_number - 1);
    claw_opening = false;
    last_dx = 0;

    if (!instance_exists(player)) exit;

    var can_capture = true;
    if (variable_instance_exists(player, "state") && player.state == "dead") can_capture = false;
    if (variable_instance_exists(player, "grabbed_by") && instance_exists(player.grabbed_by)) can_capture = false;

    var captured_instance = collision_rectangle(
        x - capture_half_width,
        y + capture_top_offset,
        x + capture_half_width,
        y + capture_bottom_offset,
        oPlayer,
        false,
        true
    );

    if (can_capture && captured_instance == player)
    {
        grabbed_player = player;
        grabbed_player.grabbed_by = id;
        grabbed_player.hsp = 0;
        grabbed_player.vsp = 0;
        grabbed_player.standing_platform = noone;
        grabbed_player.standing_platform_xoff = 0;
        grabbed_player.jump_charging = false;
        grabbed_player.jump_charge = 0;
        grabbed_player.jump_charge_level = 0;
        grabbed_player.charge_grace = 0;
        grabbed_player.support_grace = 0;
        grabbed_player.charge_start_lock = 0;
        grabbed_player.edge_charge_fail = 0;
        grabbed_player.bounce_pending = false;
        grabbed_player.bounce_timer = 0;
        grabbed_player.coyote_timer = 0;
        grabbed_player.state = "grabbed";

        // Remove every stored jump-trail point immediately.
        if (variable_instance_exists(grabbed_player, "jump_trail_points"))
        {
            var clear_count = array_length(grabbed_player.jump_trail_points);
            for (var clear_index = 0; clear_index < clear_count; clear_index++)
                grabbed_player.jump_trail_points[clear_index] = undefined;
        }
        if (variable_instance_exists(grabbed_player, "jump_trail_timer"))
            grabbed_player.jump_trail_timer = 0;

        image_index = max(0, image_number - 1);
        image_speed = 0;
        claw_opening = false;
        grab_state = "closing";
        release_armed = false;
        release_input_lock = max(0, round(release_input_lock_frames));
        sway_angle = 0;
        sway_velocity = 0;
        catch_jerk = 0;
        player_visual_offset_x = 0;
        player_visual_offset_y = 0;
        player_visual_angle = 0;

        grabber_play_one_shot(
            snd_grabber_grab,
            grabber_grab_gain
        );
    }

    exit;
}

// ====================================================
// HOLD AND RELEASE PLAYER
// ====================================================

if (instance_exists(grabbed_player))
{
    var desired_player_top = y + player_hold_top_offset;
    grabbed_player.x = x;
    grabbed_player.y += desired_player_top - grabbed_player.bbox_top;
    grabbed_player.hsp = 0;
    grabbed_player.vsp = 0;
    grabbed_player.standing_platform = noone;
    grabbed_player.standing_platform_xoff = 0;
    grabbed_player.jump_charging = false;
    grabbed_player.jump_charge = 0;
    grabbed_player.jump_charge_level = 0;
    grabbed_player.state = "grabbed";

    // ------------------------------------------------
    // RELEASE INPUT
    //
    // The old version armed release by waiting for
    // inp_jump_held to become false. That can become
    // unreliable while the player is in the grabbed
    // state.
    //
    // Instead, ignore jump for a few frames immediately
    // after capture, then allow the NEXT jump press to
    // release.
    // ------------------------------------------------

    if (release_input_lock > 0)
    {
        release_input_lock--;
    }
    else
    {
        release_armed = true;
    }

    var jump_pressed =
        variable_global_exists("inp_jump_press")
        ? global.inp_jump_press
        : keyboard_check_pressed(vk_space);

    if (release_armed && jump_pressed)
    {
        var released_player = grabbed_player;
        var release_visual_x = player_visual_offset_x;
        var release_visual_y = player_visual_offset_y;
        var release_sway_velocity = sway_velocity;

        grabbed_player = noone;
        release_armed = false;
        release_input_lock = 0;
        claw_opening = true;
        image_speed = 0;
        if (grab_state == "closing") grab_state = "moving";

        released_player.grabbed_by = noone;

        // Preserve visual continuity at release and add a tiny swing kick.
        released_player.x += round(release_visual_x);
        released_player.y += round(release_visual_y);
        released_player.hsp =
            last_dx * release_momentum +
            release_sway_velocity * sway_release_kick;
        released_player.vsp = release_vsp;
        released_player.standing_platform = noone;
        released_player.standing_platform_xoff = 0;
        released_player.jump_charging = false;
        released_player.jump_charge = 0;
        released_player.jump_charge_level = 0;
        released_player.charge_grace = 0;
        released_player.support_grace = 0;
        released_player.charge_start_lock = 0;
        released_player.edge_charge_fail = 0;
        released_player.bounce_pending = false;
        released_player.bounce_timer = 0;
        released_player.state = "glide";
        released_player.prev_jump_h = true;

        player_visual_offset_x = 0;
        player_visual_offset_y = 0;
        player_visual_angle = 0;

        grabber_play_one_shot(
            snd_grabber_release,
            grabber_release_gain
        );
    }
}

// ====================================================
// OPENING / CLOSING ANIMATION
// ====================================================

if (claw_opening)
{
    image_speed = 0;
    image_index = min(image_number - 1, image_index + open_animation_speed);
    if (image_index >= image_number - 1)
    {
        image_index = image_number - 1;
        claw_opening = false;
    }
}

if (grab_state == "closing")
{
    image_speed = 0;
    claw_opening = false;
    image_index = max(0, image_index - close_animation_speed);

    if (image_index <= 0)
    {
        image_index = 0;
        grab_state = "moving";

        // Small upward catch jerk when the claw locks shut.
        catch_jerk = -abs(catch_jerk_pixels);
    }

    exit;
}

// ====================================================
// MOVE HORIZONTALLY
// ====================================================

if (grab_state == "moving")
{
    image_speed = 0;
    if (instance_exists(grabbed_player))
    {
        image_index = 0;
        claw_opening = false;
    }
    else if (!claw_opening)
    {
        image_index = image_number - 1;
    }

    if (!instance_exists(destination))
    {
        last_dx = 0;
        exit;
    }

    var old_x = x;
    var remaining_x = destination.x - x;
    if (abs(remaining_x) <= move_speed) x = destination.x;
    else x += sign(remaining_x) * move_speed;

    y = start_y;
    dx = x - old_x;
    last_dx = dx;

    // =================================================
    // MOVEMENT LOOP AUDIO — CLOSEST THREE ONLY
    // =================================================

    var move_audio_player = instance_find(oPlayer, 0);

    grabber_move_audio_allowed =
        grabber_is_move_audio_candidate(
            move_audio_player
        );

    if (
        move_audio_player == noone
        ||
        !grabber_move_audio_allowed
        ||
        snd_grabber_move_loop == -1
        ||
        abs(dx) <= 0.001
    )
    {
        grabber_stop_move_loop();
    }
    else
    {
        var move_dist_gain =
            grabber_distance_gain(
                move_audio_player
            );

        var move_target_gain =
            grabber_move_gain *
            move_dist_gain;

        grabber_move_current_gain =
            lerp(
                grabber_move_current_gain,
                move_target_gain,
                grabber_move_gain_lerp
            );

        grabber_update_audio_position(
            move_audio_player
        );

        if (
            grabber_move_loop_instance == -1
            ||
            !audio_is_playing(
                grabber_move_loop_instance
            )
        )
        {
            if (audio_group_is_loaded(audiogroupsfx))
            {
                grabber_move_loop_instance =
                    audio_play_sound_on(
                        grabber_audio_emitter,
                        snd_grabber_move_loop,
                        true,
                        0
                    );

                if (grabber_move_loop_instance != -1)
                {
                    audio_sound_gain(
                        grabber_move_loop_instance,
                        0,
                        0
                    );
                }
            }
        }

        if (grabber_move_loop_instance != -1)
        {
            audio_sound_gain(
                grabber_move_loop_instance,
                grabber_move_current_gain,
                100
            );
        }
    }

    if (instance_exists(grabbed_player))
    {
        var moved_player_top = y + player_hold_top_offset;
        grabbed_player.x = x;
        grabbed_player.y += moved_player_top - grabbed_player.bbox_top;
        grabbed_player.hsp = 0;
        grabbed_player.vsp = 0;
        grabbed_player.state = "grabbed";
    }

    if (abs(x - destination.x) <= 0.01)
    {
        x = destination.x;
        grab_state = "parked";
        grabber_stop_move_loop();

        // Momentum carries the hanging body briefly forward.
        if (instance_exists(grabbed_player))
            sway_velocity += sign(last_dx) * sway_stop_kick;
    }

    exit;
}

// ====================================================
// PARKED
// ====================================================

if (grab_state == "parked")
{
    image_speed = 0;
    dx = 0;
    grabber_stop_move_loop();
    dy = 0;
    last_dx = 0;

    if (instance_exists(grabbed_player))
    {
        image_index = 0;
        claw_opening = false;
        var parked_player_top = y + player_hold_top_offset;
        grabbed_player.x = x;
        grabbed_player.y += parked_player_top - grabbed_player.bbox_top;
        grabbed_player.hsp = 0;
        grabbed_player.vsp = 0;
        grabbed_player.state = "grabbed";
    }
    else if (!claw_opening)
    {
        image_index = image_number - 1;
    }
}