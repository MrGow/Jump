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
        audio_pause_sound(
            flying_loop_instance
        );

        flying_loop_paused = true;
    }

    exit;
}


// ====================================================
// RESUME AUDIO
// ====================================================

if (
    flying_loop_instance != noone &&
    flying_loop_paused
)
{
    audio_resume_sound(
        flying_loop_instance
    );

    flying_loop_paused = false;
}


if (!enabled)
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

target_player =
    instance_find(
        oPlayer,
        0
    );


if (target_player == noone)
{
    exit;
}


// ====================================================
// FLYING SOUND
// ====================================================

var fly_dist =
    point_distance(
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
        fly_gain =
            flying_loop_gain;
    }
    else
    {
        var fly_amount =
            (
                fly_dist -
                flying_inner_dist
            )
            /
            max(
                1,
                flying_outer_dist -
                flying_inner_dist
            );


        fly_gain =
            flying_loop_gain *
            (
                1 -
                clamp(
                    fly_amount,
                    0,
                    1
                )
            );
    }
}


if (
    fly_gain > 0 &&
    snd_flying_loop != -1 &&
    audio_group_is_loaded(
        audiogroupsfx
    )
)
{
    if (
        flying_loop_instance ==
        noone
    )
    {
        flying_loop_instance =
            audio_play_sound(
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
else if (
    flying_loop_instance != noone
)
{
    audio_stop_sound(
        flying_loop_instance
    );

    flying_loop_instance = noone;
}


// ====================================================
// VISUAL AIR MOTION
// ====================================================

hover_wave_t +=
    hover_wave_speed;


draw_jitter_x =
    irandom_range(
        -jitter_amount,
        jitter_amount
    );

draw_jitter_y =
    irandom_range(
        -jitter_amount,
        jitter_amount
    );


gun_recoil =
    max(
        0,
        gun_recoil -
        gun_recoil_return
    );


gun_laser_fx_frame += 0.45;

gun_laser_scroll +=
    gun_laser_scroll_speed;

big_laser_fx_frame += 0.4;


// ====================================================
// GET ACTIVE CAMERA POSITION
// ====================================================

var cam_id =
    view_camera[0];


var cam_left = 0;
var cam_top = 0;

var cam_width = 640;
var cam_height = 360;


if (cam_id != -1)
{
    cam_left =
        camera_get_view_x(
            cam_id
        );

    cam_top =
        camera_get_view_y(
            cam_id
        );

    cam_width =
        camera_get_view_width(
            cam_id
        );

    cam_height =
        camera_get_view_height(
            cam_id
        );
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
        reposition_side =
            choose(
                -1,
                1
            );


        reposition_distance =
            random_range(
                reposition_distance_min,
                reposition_distance_max
            );


        reposition_timer =
            irandom_range(
                room_speed * 2,
                room_speed * 4
            );
    }


    // ------------------------------------------------
    // Follow player horizontally.
    // ------------------------------------------------

    hover_target_x =
        target_player.x +
        reposition_distance *
        reposition_side;


    hover_target_x +=
        sin(
            hover_wave_t
        )
        *
        hover_wave_x;


    // ------------------------------------------------
    // CAMERA-BASED Y POSITION
    //
    // This is the important change.
    //
    // The player's Y position has absolutely no effect
    // on normal gunship altitude.
    // ------------------------------------------------

    hover_target_y =
        cam_top +
        hover_screen_y;


    hover_target_y +=
        sin(
            hover_wave_t *
            1.37
        )
        *
        hover_wave_y;


    // Keep its centre firmly in the upper third.
    hover_target_y =
        clamp(
            hover_target_y,
            cam_top + 68,
            cam_top +
            cam_height *
            0.30
        );


    // Keep some of ship on screen horizontally.
    hover_target_x =
        clamp(
            hover_target_x,
            cam_left + 70,
            cam_left +
            cam_width -
            70
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
    // ------------------------------------------------
    // The giant laser attack deliberately descends
    // roughly level with the player.
    // ------------------------------------------------

    hover_target_y =
        target_player.y;


    // Attack from left.
    if (reposition_side < 0)
    {
        facing = 1;

        hover_target_x =
            target_player.x -
            250;
    }
    else
    {
        // Attack from right.
        facing = -1;

        hover_target_x =
            target_player.x +
            250;
    }
}


// ====================================================
// MOVE SHIP
// ====================================================

var desired_hspeed =
    clamp(
        (
            hover_target_x -
            x
        )
        *
        hover_follow_strength,
        -hover_max_speed,
        hover_max_speed
    );


var desired_vspeed =
    clamp(
        (
            hover_target_y -
            y
        )
        *
        hover_follow_strength,
        -hover_max_speed,
        hover_max_speed
    );


hover_hspeed =
    lerp(
        hover_hspeed,
        desired_hspeed,
        hover_move_lerp
    );


hover_vspeed =
    lerp(
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
    x +
    gun_mount_offset_x *
    facing;

gun_y =
    y +
    gun_mount_offset_y;


// ====================================================
// HUGE LASER MUZZLE POSITION
//
// Updated every frame even while not firing.
// ====================================================

big_laser_start_x =
    x +
    big_laser_offset_x *
    facing;

big_laser_start_y =
    y +
    big_laser_offset_y;


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


        // Mines don't exist yet, so only select attacks
        // that can actually run.
        if (mine_object == -1)
        {
            attack_choice =
                choose(
                    ATTACK_GUN,
                    ATTACK_LASER
                );
        }
        else
        {
            attack_choice =
                choose(
                    ATTACK_GUN,
                    ATTACK_MINE,
                    ATTACK_LASER
                );
        }


        // Avoid immediate repeats where practical.
        if (
            attack_choice ==
            last_attack
        )
        {
            if (mine_object == -1)
            {
                attack_choice =
                    (
                        attack_choice ==
                        ATTACK_GUN
                    )
                    ?
                    ATTACK_LASER
                    :
                    ATTACK_GUN;
            }
        }


        switch (attack_choice)
        {
            case ATTACK_GUN:
            {
                start_gun_attack();
            }
            break;


            case ATTACK_MINE:
            {
                start_mine_attack();
            }
            break;


            case ATTACK_LASER:
            {
                start_big_laser_attack();
            }
            break;
        }
    }
}


// ====================================================
// ATTACHED GUN STATE MACHINE
// ====================================================

switch (gun_state)
{
    // =================================================
    // IDLE
    // =================================================

    case "idle":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;


        gun_angle =
            approach_gun_angle(
                gun_angle,
                270,
                0.08
            );
    }
    break;


    // =================================================
    // AIMING
    // =================================================

    case "aiming":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;


        if (
            instance_exists(
                gun_target
            )
        )
        {
            var desired_angle =
                point_direction(
                    gun_x,
                    gun_y,
                    gun_target.x,
                    gun_target.y
                );


            // ------------------------------------------------
            // CRITICAL:
            //
            // Force aim to remain beneath the ship.
            // It can no longer flip upward.
            // ------------------------------------------------

            desired_angle =
                clamp_gun_angle(
                    desired_angle
                );


            gun_angle =
                approach_gun_angle(
                    gun_angle,
                    desired_angle,
                    gun_track_strength
                );
        }


        gun_timer--;


        if (gun_timer <= 0)
        {
            gun_state = "locked";

            gun_timer =
                gun_lock_frames;
        }
    }
    break;


    // =================================================
    // LOCKED
    // =================================================

    case "locked":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;


        // Deliberately DO NOT track anymore.
        gun_timer--;


        if (gun_timer <= 0)
        {
            gun_state = "firing";

            gun_timer =
                gun_fire_frames;


            gun_beam_visible = true;
            gun_beam_lethal = true;


            gun_recoil =
                gun_recoil_max;


            // Calculate laser immediately so it appears
            // on the very first firing frame.
            update_gun_beam(
                true
            );


            play_gunship_sfx(
                snd_gun_shoot,
                0.90,
                random_range(
                    0.97,
                    1.03
                )
            );


            if (
                !variable_global_exists(
                    "shake_mag"
                )
            )
            {
                global.shake_mag = 0;
            }


            if (
                !variable_global_exists(
                    "shake_time"
                )
            )
            {
                global.shake_time = 0;
            }


            global.shake_mag =
                max(
                    global.shake_mag,
                    3
                );

            global.shake_time =
                max(
                    global.shake_time,
                    5
                );
        }
    }
    break;


    // =================================================
    // FIRING
    // =================================================

    case "firing":
    {
        gun_beam_visible = true;
        gun_beam_lethal = true;


        update_gun_beam(
            true
        );


        gun_timer--;


        if (gun_timer <= 0)
        {
            gun_state = "cooldown";

            gun_timer =
                gun_cooldown_frames;


            gun_beam_visible = false;
            gun_beam_lethal = false;
        }
    }
    break;


    // =================================================
    // COOLDOWN
    // =================================================

    case "cooldown":
    {
        gun_beam_visible = false;
        gun_beam_lethal = false;


        gun_timer--;


        if (gun_timer <= 0)
        {
            gun_state = "idle";


            if (
                state ==
                "gun_attack"
            )
            {
                state = "hover";


                attack_cooldown =
                    irandom_range(
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
                x +
                mine_mount_offset_x *
                facing;

            var mine_y =
                y +
                mine_mount_offset_y;


            var mine =
                instance_create_depth(
                    mine_x,
                    mine_y,
                    depth + 1,
                    mine_object
                );


            if (mine != noone)
            {
                mine.hspeed =
                    facing *
                    random_range(
                        0.6,
                        1.4
                    );

                mine.vspeed =
                    random_range(
                        0.5,
                        1.3
                    );
            }


            play_gunship_sfx(
                snd_drop_mine,
                0.85,
                random_range(
                    0.97,
                    1.03
                )
            );
        }


        mine_drop_count++;


        if (
            mine_drop_count >=
            mine_drop_total
        )
        {
            state = "hover";


            attack_cooldown =
                irandom_range(
                    attack_min_delay,
                    attack_max_delay
                );
        }
        else
        {
            mine_drop_timer =
                mine_drop_delay;
        }
    }
}


// ====================================================
// HUGE LASER STATE MACHINE
// ====================================================

switch (state)
{
    // =================================================
    // REPOSITION
    // =================================================

    case "big_laser_reposition":
    {
        big_laser_timer--;


        if (big_laser_timer <= 0)
        {
            state =
                "big_laser_charge";


            big_laser_timer =
                big_laser_charge_frames;
        }
    }
    break;


    // =================================================
    // CHARGE
    // =================================================

    case "big_laser_charge":
    {
        big_laser_visible = false;
        big_laser_lethal = false;


        big_laser_timer--;


        if (big_laser_timer <= 0)
        {
            state =
                "big_laser_fire";


            big_laser_timer =
                big_laser_fire_frames;


            big_laser_visible = true;
            big_laser_lethal = true;


            update_big_laser(
                true
            );


            play_gunship_sfx(
                snd_big_laser,
                1,
                1
            );


            if (
                !variable_global_exists(
                    "shake_mag"
                )
            )
            {
                global.shake_mag = 0;
            }


            if (
                !variable_global_exists(
                    "shake_time"
                )
            )
            {
                global.shake_time = 0;
            }


            global.shake_mag =
                max(
                    global.shake_mag,
                    big_laser_shake_strength
                );


            global.shake_time =
                max(
                    global.shake_time,
                    big_laser_shake_frames
                );
        }
    }
    break;


    // =================================================
    // FIRE
    // =================================================

    case "big_laser_fire":
    {
        big_laser_visible = true;
        big_laser_lethal = true;


        update_big_laser(
            true
        );


        global.shake_mag =
            max(
                global.shake_mag,
                1
            );

        global.shake_time =
            max(
                global.shake_time,
                2
            );


        big_laser_timer--;


        if (big_laser_timer <= 0)
        {
            state =
                "big_laser_cooldown";


            big_laser_timer =
                big_laser_cooldown_frames;


            big_laser_visible = false;
            big_laser_lethal = false;
        }
    }
    break;


    // =================================================
    // RECOVERY
    // =================================================

    case "big_laser_cooldown":
    {
        big_laser_timer--;


        if (big_laser_timer <= 0)
        {
            state = "hover";


            // Return to normal right-facing appearance.
            facing = 1;


            attack_cooldown =
                irandom_range(
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

// spriteGunShipGun points DOWN when its image angle = 0.
var gun_target_draw_angle =
    gun_angle -
    270;


var visual_step =
    max(
        1,
        gun_visual_angle_step
    );


gun_draw_angle =
    round(
        gun_target_draw_angle /
        visual_step
    )
    *
    visual_step;