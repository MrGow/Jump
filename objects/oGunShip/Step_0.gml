/// oGunShip — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    if (
        flying_loop_instance != noone &&
        !flying_loop_paused
    )
    {
        audio_pause_sound(flying_loop_instance);
        flying_loop_paused = true;
    }

    exit;
}

if (boss_hit_flash_timer > 0)
{
    boss_hit_flash_timer--;
}


// ====================================================
// RESUME AUDIO
// ====================================================

if (
    flying_loop_instance != noone &&
    flying_loop_paused
)
{
    audio_resume_sound(flying_loop_instance);
    flying_loop_paused = false;
}

if (!enabled)
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

target_player = instance_find(oPlayer, 0);

if (target_player == noone)
{
    exit;
}


// ====================================================
// FLYING SOUND
// ====================================================

var fly_dist = point_distance(
    x,
    y,
    target_player.x,
    target_player.y
);

var fly_gain = 0;

if (fly_dist < flying_outer_dist)
{
    if (fly_dist <= flying_inner_dist)
    {
        fly_gain = flying_loop_gain;
    }
    else
    {
        var fly_amount =
            (fly_dist - flying_inner_dist)
            /
            max(
                1,
                flying_outer_dist - flying_inner_dist
            );

        fly_gain =
            flying_loop_gain
            *
            (1 - clamp(fly_amount, 0, 1));
    }
}

if (
    state == "boss_crashing" ||
    state == "boss_exposed" ||
    state == "boss_retracting"
)
{
    fly_gain = 0;
}

if (
    fly_gain > 0 &&
    snd_flying_loop != -1 &&
    audio_group_is_loaded(audiogroupsfx)
)
{
    if (flying_loop_instance == noone)
    {
        flying_loop_instance = audio_play_sound(
            snd_flying_loop,
            -60,
            true
        );

        audio_sound_gain(
            flying_loop_instance,
            0,
            0
        );
    }

    audio_sound_gain(
        flying_loop_instance,
        fly_gain,
        120
    );
}
else if (flying_loop_instance != noone)
{
    audio_stop_sound(flying_loop_instance);
    flying_loop_instance = noone;
}


// ====================================================
// VISUAL AIR MOTION
// ====================================================

hover_wave_t += hover_wave_speed;

draw_jitter_x = irandom_range(
    -jitter_amount,
    jitter_amount
);

draw_jitter_y = irandom_range(
    -jitter_amount,
    jitter_amount
);

gun_recoil = max(
    0,
    gun_recoil - gun_recoil_return
);

gun_laser_fx_frame += 0.45;
gun_laser_scroll += gun_laser_scroll_speed;
big_laser_fx_frame += 0.4;


// ====================================================
// CAMERA
// ====================================================

var cam_id = view_camera[0];

var cam_left = 0;
var cam_top = 0;
var cam_width = 640;
var cam_height = 360;

if (cam_id != -1)
{
    cam_left = camera_get_view_x(cam_id);
    cam_top = camera_get_view_y(cam_id);
    cam_width = camera_get_view_width(cam_id);
    cam_height = camera_get_view_height(cam_id);
}


// ====================================================
// BOSS: CRASH TOWARD THE FLOOR
// ====================================================

if (state == "boss_crashing")
{
    if (!instance_exists(boss_controller))
    {
        instance_destroy();
        exit;
    }

    x += clamp(
        boss_controller.x - x,
        -3,
        3
    );

    boss_fall_speed = min(
        8,
        boss_fall_speed + 0.32
    );

    y = min(
        y + boss_fall_speed,
        boss_crash_floor_y
    );

    image_index = min(
        boss_weak_hold_frame,
        image_index + boss_weak_anim_speed
    );

    draw_jitter_x = 0;
    draw_jitter_y = 0;

    if (
        y >= boss_crash_floor_y &&
        image_index >= boss_weak_hold_frame &&
        abs(x - boss_controller.x) <= 1
    )
    {
        x = boss_controller.x;
        y = boss_crash_floor_y;

        state = "boss_exposed";
        boss_exposed_timer = boss_exposed_frames;
    }

    exit;
}


// ====================================================
// BOSS: EXPOSED WEAK SPOT
// ====================================================

if (state == "boss_exposed")
{
    draw_jitter_x = 0;
    draw_jitter_y = 0;

    image_index = boss_weak_hold_frame;
    boss_exposed_timer--;

    var victim = instance_find(oPlayer, 0);

    if (
        instance_exists(victim) &&
        victim.state != "dead" &&
        victim.vsp < -0.2
    )
    {
        var weak_x =
            x + boss_weak_offset_x * facing;

        var weak_y =
            y + boss_weak_offset_y;

        var weak_hit =
            victim.bbox_right >
                weak_x - boss_weak_half_w
            &&
            victim.bbox_left <
                weak_x + boss_weak_half_w
            &&
            victim.bbox_bottom >
                weak_y - boss_weak_half_h
            &&
            victim.bbox_top <
                weak_y + boss_weak_half_h + 50;

        if (weak_hit)
        {
            var push_side = 1;

            if (victim.x < weak_x)
            {
                push_side = -1;
            }

            victim.jump_charging = false;
            victim.jump_charge = 0;
            victim.vsp = -4.5;
            victim.hsp = push_side * 3.0;
            victim.state = "jumping";

            boss_on_weakpoint_hit();
            exit;
        }
    }

    if (boss_exposed_timer <= 0)
    {
        boss_begin_retraction();
    }

    exit;
}


// ====================================================
// BOSS: RETRACT WEAK SPOT
// ====================================================

if (state == "boss_retracting")
{
    draw_jitter_x = 0;
    draw_jitter_y = 0;

    image_index = min(
        boss_weak_last_frame,
        image_index + boss_weak_anim_speed
    );

    if (image_index >= boss_weak_last_frame)
    {
        if (boss_defeated_pending)
        {
            if (instance_exists(boss_controller))
            {
                boss_controller.active = false;
                boss_controller.ship = noone;
            }

            if (instance_exists(boss_trigger))
            {
                boss_trigger.completed = true;
                boss_trigger.encounter_active = false;
            }

            with (oGunShipMine)
            {
                instance_destroy();
            }

            instance_destroy();
            exit;
        }

        boss_begin_recovery();
    }

    exit;
}


// ====================================================
// BOSS: RETURN TO FLIGHT
// ====================================================

if (state == "boss_recovering")
{
    if (!instance_exists(boss_controller))
    {
        instance_destroy();
        exit;
    }

    var return_y =
        cam_top + hover_screen_y;

    x += clamp(
        boss_controller.x - x,
        -boss_recovery_speed,
        boss_recovery_speed
    );

    y += clamp(
        return_y - y,
        -boss_recovery_speed,
        boss_recovery_speed
    );

    draw_jitter_x = 0;
    draw_jitter_y = 0;

    if (
        abs(x - boss_controller.x) <= 1 &&
        abs(y - return_y) <= 1
    )
    {
        x = boss_controller.x;
        y = return_y;

        sprite_index = spriteGunShip;
        image_index = 0;
        image_speed = 0;

        state = "hover";
        ai_enabled = true;

        hover_hspeed = 0;
        hover_vspeed = 0;

        attack_cooldown =
            round(room_speed * 1.25);
    }

    exit;
}


// ====================================================
// ARENA: CONTINUOUS GUN SWEEPS
//
// Right -> left -> pause -> left -> right -> pause.
// The ship stays above the arena's missile silo.
// ====================================================

if (arena_phase_active && state == "hover")
{
    var intro_frames =
        round(room_speed * 1.0);

    var warn_frames =
        round(room_speed * 0.65);

    var sweep_frames =
        round(room_speed * 2.6);

    var pause_frames =
        round(room_speed * 5.0);

    var right_angle = 305;
    var left_angle = 235;

    var cycle_frames =
        warn_frames
        + sweep_frames
        + pause_frames
        + sweep_frames
        + pause_frames;

    hover_target_x = arena_target_x;
    hover_target_y = arena_target_y;

    x += clamp(
        hover_target_x - x,
        -7,
        7
    );

    y += clamp(
        hover_target_y - y,
        -5,
        5
    );

    hover_hspeed = 0;
    hover_vspeed = 0;
    facing = 1;

    gun_x =
        x + gun_mount_offset_x * facing;

    gun_y =
        y + gun_mount_offset_y;

    big_laser_visible = false;
    big_laser_lethal = false;

    var cycle_time = -1;

    if (arena_phase_frame >= intro_frames)
    {
        cycle_time =
            (arena_phase_frame - intro_frames)
            mod cycle_frames;
    }

    // Intro: aim at the right endpoint.
    if (cycle_time < 0)
    {
        gun_angle = right_angle;

        gun_beam_visible = false;
        gun_beam_lethal = false;
        gun_laser_len = 0;
    }

    // Warning before the right-to-left sweep.
    else if (cycle_time < warn_frames)
    {
        gun_angle = right_angle;

        gun_beam_visible = false;
        gun_beam_lethal = false;

        update_gun_beam(false);
    }

    // Fire right to left.
    else if (
        cycle_time <
        warn_frames + sweep_frames
    )
    {
        var forward_time =
            cycle_time - warn_frames;

        var forward_t =
            forward_time
            /
            max(1, sweep_frames - 1);

        gun_angle = lerp(
            right_angle,
            left_angle,
            forward_t
        );

        gun_beam_visible = true;
        gun_beam_lethal = true;

        update_gun_beam(true);
    }

    // Pause at the left endpoint.
    else if (
        cycle_time <
        warn_frames
        + sweep_frames
        + pause_frames
    )
    {
        gun_angle = left_angle;

        gun_beam_visible = false;
        gun_beam_lethal = false;
        gun_laser_len = 0;

        var left_pause_end =
            warn_frames
            + sweep_frames
            + pause_frames;

        // Warning during the end of this pause.
        if (
            cycle_time >=
            left_pause_end - warn_frames
        )
        {
            update_gun_beam(false);
        }
    }

    // Fire left to right from the left endpoint.
    else if (
        cycle_time <
        warn_frames
        + sweep_frames
        + pause_frames
        + sweep_frames
    )
    {
        var reverse_time =
            cycle_time
            - warn_frames
            - sweep_frames
            - pause_frames;

        var reverse_t =
            reverse_time
            /
            max(1, sweep_frames - 1);

        gun_angle = lerp(
            left_angle,
            right_angle,
            reverse_t
        );

        gun_beam_visible = true;
        gun_beam_lethal = true;

        update_gun_beam(true);
    }

    // Pause at the right endpoint, then repeat.
    else
    {
        gun_angle = right_angle;

        gun_beam_visible = false;
        gun_beam_lethal = false;
        gun_laser_len = 0;
    }

    gun_draw_angle =
        round(
            (gun_angle - 270)
            /
            max(1, gun_visual_angle_step)
        )
        *
        max(1, gun_visual_angle_step);

    arena_phase_frame++;
    exit;
}


// ====================================================
// NORMAL HOVER TARGET
// ====================================================

if (
    ai_enabled &&
    !scripted_override &&
    state != "big_laser_reposition" &&
    state != "big_laser_charge" &&
    state != "big_laser_fire"
)
{
    reposition_timer--;

    if (reposition_timer <= 0)
    {
        reposition_side = choose(-1, 1);

        reposition_distance = random_range(
            reposition_distance_min,
            reposition_distance_max
        );

        reposition_timer = irandom_range(
            room_speed * 2,
            room_speed * 4
        );
    }

    hover_target_x =
        target_player.x
        +
        reposition_distance * reposition_side;

    hover_target_x +=
        sin(hover_wave_t) * hover_wave_x;

    hover_target_y =
        cam_top + hover_screen_y;

    hover_target_y +=
        sin(hover_wave_t * 1.37)
        *
        hover_wave_y;

    hover_target_y = clamp(
        hover_target_y,
        cam_top + 68,
        cam_top + cam_height * 0.30
    );

    hover_target_x = clamp(
        hover_target_x,
        cam_left + 70,
        cam_left + cam_width - 70
    );
}


// ====================================================
// HUGE LASER REPOSITIONING
// ====================================================

if (
    state == "big_laser_reposition" ||
    state == "big_laser_charge" ||
    state == "big_laser_fire"
)
{
    hover_target_y =
        target_player.y;

    if (reposition_side < 0)
    {
        facing = 1;

        hover_target_x =
            target_player.x - 250;
    }
    else
    {
        facing = -1;

        hover_target_x =
            target_player.x + 250;
    }
}


// ====================================================
// MOVE SHIP
// ====================================================

var desired_hspeed = clamp(
    (hover_target_x - x) * hover_follow_strength,
    -hover_max_speed,
    hover_max_speed
);

var desired_vspeed = clamp(
    (hover_target_y - y) * hover_follow_strength,
    -hover_max_speed,
    hover_max_speed
);

hover_hspeed = lerp(
    hover_hspeed,
    desired_hspeed,
    hover_move_lerp
);

hover_vspeed = lerp(
    hover_vspeed,
    desired_vspeed,
    hover_move_lerp
);

x += hover_hspeed;
y += hover_vspeed;


// ====================================================
// ATTACHED GUN POSITION
// ====================================================

gun_x =
    x + gun_mount_offset_x * facing;

gun_y =
    y + gun_mount_offset_y;


// ====================================================
// HUGE LASER MUZZLE POSITION
// ====================================================

big_laser_start_x =
    x + big_laser_offset_x * facing;

big_laser_start_y =
    y + big_laser_offset_y;


// ====================================================
// AUTONOMOUS ATTACK SELECTION
// ====================================================

if (
    ai_enabled &&
    !scripted_override &&
    state == "hover"
)
{
    attack_cooldown--;

    if (attack_cooldown <= 0)
    {
        var attack_choice;

        if (mine_object == -1)
        {
            attack_choice = choose(
                ATTACK_GUN,
                ATTACK_LASER
            );
        }
        else
        {
            attack_choice = choose(
                ATTACK_GUN,
                ATTACK_MINE,
                ATTACK_LASER
            );
        }

        if (attack_choice == last_attack)
        {
            if (mine_object == -1)
            {
                if (attack_choice == ATTACK_GUN)
                {
                    attack_choice = ATTACK_LASER;
                }
                else
                {
                    attack_choice = ATTACK_GUN;
                }
            }
        }

        switch (attack_choice)
        {
            case ATTACK_GUN:
                start_gun_attack();
            break;

            case ATTACK_MINE:
                start_mine_attack();
            break;

            case ATTACK_LASER:
                start_big_laser_attack();
            break;
        }
    }
}


// ====================================================
// ATTACHED GUN STATE MACHINE
// ====================================================

switch (gun_state)
{
    case "idle":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;

        gun_angle = approach_gun_angle(
            gun_angle,
            270,
            0.08
        );
    }
    break;

    case "aiming":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;

        if (instance_exists(gun_target))
        {
            var desired_angle = point_direction(
                gun_x,
                gun_y,
                gun_target.x,
                gun_target.y
            );

            desired_angle =
                clamp_gun_angle(desired_angle);

            gun_angle = approach_gun_angle(
                gun_angle,
                desired_angle,
                gun_track_strength
            );
        }

        gun_timer--;

        if (gun_timer <= 0)
        {
            gun_state = "locked";
            gun_timer = gun_lock_frames;
        }
    }
    break;

    case "locked":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;

        gun_timer--;

        if (gun_timer <= 0)
        {
            gun_state = "firing";
            gun_timer = gun_fire_frames;

            gun_beam_visible = true;
            gun_beam_lethal = true;

            gun_recoil = gun_recoil_max;

            update_gun_beam(true);

            play_gunship_sfx(
                snd_gun_shoot,
                0.90,
                random_range(0.97, 1.03)
            );

            if (!variable_global_exists("shake_mag"))
            {
                global.shake_mag = 0;
            }

            if (!variable_global_exists("shake_time"))
            {
                global.shake_time = 0;
            }

            global.shake_mag =
                max(global.shake_mag, 3);

            global.shake_time =
                max(global.shake_time, 5);
        }
    }
    break;

    case "firing":
    {
        gun_beam_visible = true;
        gun_beam_lethal = true;

        update_gun_beam(true);

        gun_timer--;

        if (gun_timer <= 0)
        {
            gun_state = "cooldown";
            gun_timer = gun_cooldown_frames;

            gun_beam_visible = false;
            gun_beam_lethal = false;
        }
    }
    break;

    case "cooldown":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;

        gun_timer--;

        if (gun_timer <= 0)
        {
            gun_state = "idle";

            if (state == "gun_attack")
            {
                state = "hover";

                attack_cooldown = irandom_range(
                    attack_min_delay,
                    attack_max_delay
                );
            }
        }
    }
    break;
}


// ====================================================
// MINE ATTACK
// ====================================================

if (state == "mine_attack")
{
    mine_drop_timer--;

    if (mine_drop_timer <= 0)
    {
        if (mine_object != -1)
        {
            var mine_x =
                x + mine_mount_offset_x * facing;

            var mine_y =
                y + mine_mount_offset_y;

            var mine = instance_create_depth(
                mine_x,
                mine_y,
                depth + 1,
                mine_object
            );

            if (mine != noone)
            {
                mine.hspeed =
                    facing
                    *
                    random_range(0.6, 1.4);

                mine.vspeed =
                    random_range(0.5, 1.3);
            }

            play_gunship_sfx(
                snd_drop_mine,
                0.85,
                random_range(0.97, 1.03)
            );
        }

        mine_drop_count++;

        if (mine_drop_count >= mine_drop_total)
        {
            state = "hover";

            attack_cooldown = irandom_range(
                attack_min_delay,
                attack_max_delay
            );
        }
        else
        {
            mine_drop_timer = mine_drop_delay;
        }
    }
}


// ====================================================
// HUGE LASER STATE MACHINE
// ====================================================

switch (state)
{
    case "big_laser_reposition":
    {
        big_laser_timer--;

        if (big_laser_timer <= 0)
        {
            state = "big_laser_charge";

            big_laser_timer =
                big_laser_charge_frames;
        }
    }
    break;

    case "big_laser_charge":
    {
        big_laser_visible = false;
        big_laser_lethal = false;

        big_laser_timer--;

        if (big_laser_timer <= 0)
        {
            state = "big_laser_fire";
            big_laser_timer = big_laser_fire_frames;

            big_laser_visible = true;
            big_laser_lethal = true;

            update_big_laser(true);

            play_gunship_sfx(
                snd_big_laser,
                1,
                1
            );

            if (!variable_global_exists("shake_mag"))
            {
                global.shake_mag = 0;
            }

            if (!variable_global_exists("shake_time"))
            {
                global.shake_time = 0;
            }

            global.shake_mag = max(
                global.shake_mag,
                big_laser_shake_strength
            );

            global.shake_time = max(
                global.shake_time,
                big_laser_shake_frames
            );
        }
    }
    break;

    case "big_laser_fire":
    {
        big_laser_visible = true;
        big_laser_lethal = true;

        update_big_laser(true);

        global.shake_mag =
            max(global.shake_mag, 1);

        global.shake_time =
            max(global.shake_time, 2);

        big_laser_timer--;

        if (big_laser_timer <= 0)
        {
            state = "big_laser_cooldown";

            big_laser_timer =
                big_laser_cooldown_frames;

            big_laser_visible = false;
            big_laser_lethal = false;
        }
    }
    break;

    case "big_laser_cooldown":
    {
        big_laser_timer--;

        if (big_laser_timer <= 0)
        {
            state = "hover";
            facing = 1;

            attack_cooldown = irandom_range(
                attack_min_delay,
                attack_max_delay
            );
        }
    }
    break;
}


// ====================================================
// PIXEL-ART GUN DRAW ANGLE
// ====================================================

var gun_target_draw_angle =
    gun_angle - 270;

var visual_step =
    max(1, gun_visual_angle_step);

gun_draw_angle =
    round(gun_target_draw_angle / visual_step)
    *
    visual_step;