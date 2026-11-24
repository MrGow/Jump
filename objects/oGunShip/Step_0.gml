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
// ARENA LASER SPARKS — UPDATE EXISTING PARTICLES
//
// Runs before boss-state early exits so sparks can
// finish their short lifetimes after firing stops.
// Frozen game has already exited above.
// ====================================================

var surviving_sparks = [];

for (var spark_i = 0; spark_i < array_length(arena_sparks); spark_i++)
{
    var spark = arena_sparks[spark_i];

    spark.x += spark.vx;
    spark.y += spark.vy;

    spark.vx *= arena_sparks_friction;
    spark.vy += arena_sparks_gravity;

    // One tiny bounce along the train roof.
    if (spark.y >= spark.ground_y)
    {
        spark.y = spark.ground_y;

        if (spark.bounces_left > 0 && spark.vy > 0)
        {
            spark.vy = -spark.vy * arena_sparks_bounce_strength;
            spark.bounces_left--;
        }
        else
        {
            spark.vy = 0;
        }
    }

    spark.life--;

    if (spark.life > 0)
    {
        array_push(surviving_sparks, spark);
    }
}

arena_sparks = surviving_sparks;


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

// Arena ownership takes priority even if a laser request
// was queued immediately before the arena started.
if (arena_phase_active &&
    (instance_exists(laser_trigger_request) ||
     instance_exists(laser_trigger_active)))
{
    laser_trigger_cancel();

    if (state == "big_laser_reposition" ||
        state == "big_laser_charge" ||
        state == "big_laser_fire" ||
        state == "big_laser_cooldown")
    {
        state = "hover";
    }
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
                weak_y + boss_weak_half_h + 100;

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
// Opening sweep -> left stop -> 1 second crossing gap
// -> long sweep to the arena's right edge -> reset.
//
// During the return sweep, the aimed point travels at
// a steady speed across the floor.
// ====================================================

if (arena_phase_active && state == "hover")
{
    // ------------------------------------------------
    // TUNING
    // ------------------------------------------------

    var intro_frames =
        max(1, round(room_speed * 1.0));

    var warn_frames =
        max(1, round(room_speed * 0.65));

    var opening_sweep_frames =
        max(1, round(room_speed * 2.6));

    var crossing_pause_frames =
        max(1, round(room_speed * 1.0));

    // Increase this for more time to reach the plate.
    // Decrease it to make the return sweep faster.
    var return_sweep_frames =
        max(1, round(room_speed * 6.0));

    var reset_pause_frames =
        max(1, round(room_speed * 1.0));

    // Warning is included WITHIN the one-second gap.
    var reverse_warn_frames =
        min(
            crossing_pause_frames,
            max(1, round(room_speed * 0.35))
        );

    // Preserve the working opening sweep.
    var opening_right_angle = 305;
    var left_angle = 235;

    var right_edge_inset = 12;

    var cycle_frames =
        warn_frames
        + opening_sweep_frames
        + crossing_pause_frames
        + return_sweep_frames
        + reset_pause_frames;


    // ------------------------------------------------
    // MOVE ABOVE THE SILO
    // ------------------------------------------------

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

    arena_warning_visible = false;


    // ------------------------------------------------
    // ESTABLISH THIS ARENA'S RETURN SWEEP ENDPOINTS
    //
    // Calculated once per arena. Use the unshaken
    // camera lock and the floor below the silo.
    // ------------------------------------------------

    if (
        arena_phase_frame == 0 ||
        !variable_instance_exists(
            id,
            "arena_sweep_floor_y"
        )
    )
    {
        var arena_view_left = cam_left;

        var arena_view_top =
            arena_target_y - hover_screen_y;

        var arena_camera =
            instance_find(oCamera, 0);

        if (instance_exists(arena_camera))
        {
            if (
                variable_instance_exists(
                    arena_camera,
                    "arena_lock_active"
                )
                &&
                arena_camera.arena_lock_active
            )
            {
                arena_view_left =
                    arena_camera.arena_lock_x;

                arena_view_top =
                    arena_camera.arena_lock_y;
            }
        }

        var intended_gun_x =
            arena_target_x + gun_mount_offset_x;

        var intended_gun_y =
            arena_target_y + gun_mount_offset_y;

        // Fallback if no floor tile is found.
        arena_sweep_floor_y = max(
            intended_gun_y + 1,
            arena_view_top + cam_height - 40
        );

        if (layer_exists("Solids"))
        {
            var arena_solid_layer =
                layer_get_id("Solids");

            var arena_solid_map =
                layer_tilemap_get_id(
                    arena_solid_layer
                );

            if (arena_solid_map != -1)
            {
                for (
                    var floor_probe_y =
                        max(0, ceil(intended_gun_y));
                    floor_probe_y < room_height;
                    floor_probe_y++
                )
                {
                    var arena_tile =
                        tilemap_get_at_pixel(
                            arena_solid_map,
                            intended_gun_x,
                            floor_probe_y
                        );

                    if (
                        arena_tile != 0 &&
                        arena_tile != -1
                    )
                    {
                        arena_sweep_floor_y =
                            floor_probe_y;

                        break;
                    }
                }
            }
        }

        var floor_distance_y = max(
            1,
            arena_sweep_floor_y - intended_gun_y
        );

        var left_ray_distance =
            floor_distance_y
            /
            max(
                0.001,
                lengthdir_y(1, left_angle)
            );

        // This is where the existing 235-degree
        // left endpoint intersects the floor.
        arena_sweep_left_x =
            intended_gun_x
            +
            lengthdir_x(
                left_ray_distance,
                left_angle
            );

        arena_sweep_right_x =
            arena_view_left
            + cam_width
            - right_edge_inset;

        arena_sweep_right_angle =
            point_direction(
                intended_gun_x,
                intended_gun_y,
                arena_sweep_right_x,
                arena_sweep_floor_y
            );
    }


    // ------------------------------------------------
    // CYCLE TIMING
    // ------------------------------------------------

    var cycle_time = -1;

    if (arena_phase_frame >= intro_frames)
    {
        cycle_time =
            (arena_phase_frame - intro_frames)
            mod cycle_frames;
    }

    var opening_end =
        warn_frames + opening_sweep_frames;

    var crossing_end =
        opening_end + crossing_pause_frames;

    var return_end =
        crossing_end + return_sweep_frames;


    // ------------------------------------------------
    // INTRO
    // ------------------------------------------------

    if (cycle_time < 0)
    {
        gun_angle = opening_right_angle;

        gun_beam_visible = false;
        gun_beam_lethal = false;
        gun_laser_len = 0;
    }


    // ------------------------------------------------
    // OPENING WARNING
    // ------------------------------------------------

    else if (cycle_time < warn_frames)
    {
        gun_angle = opening_right_angle;

        gun_beam_visible = false;
        gun_beam_lethal = false;

        arena_warning_visible = true;
        update_gun_beam(false);
    }


    // ------------------------------------------------
    // OPENING SWEEP: RIGHT TO LEFT
    // ------------------------------------------------

    else if (cycle_time < opening_end)
    {
        var opening_t =
            (cycle_time - warn_frames)
            /
            max(1, opening_sweep_frames - 1);

        gun_angle = lerp(
            opening_right_angle,
            left_angle,
            opening_t
        );

        gun_beam_visible = true;
        gun_beam_lethal = true;

        update_gun_beam(true);
    }


    // ------------------------------------------------
    // ONE-SECOND CROSSING GAP AT THE LEFT ENDPOINT
    // ------------------------------------------------

    else if (cycle_time < crossing_end)
    {
        gun_angle = left_angle;

        gun_beam_visible = false;
        gun_beam_lethal = false;
        gun_laser_len = 0;

        if (
            cycle_time >=
            crossing_end - reverse_warn_frames
        )
        {
            arena_warning_visible = true;
            update_gun_beam(false);
        }
    }


    // ------------------------------------------------
    // RETURN SWEEP: LEFT TO ARENA RIGHT EDGE
    //
    // Start from the same left endpoint, then move the
    // aimed floor point steadily toward the right.
    // ------------------------------------------------

    else if (cycle_time < return_end)
    {
        var return_t =
            (cycle_time - crossing_end)
            /
            max(1, return_sweep_frames - 1);

        var return_floor_x = lerp(
            arena_sweep_left_x,
            arena_sweep_right_x,
            return_t
        );

        gun_angle = point_direction(
            gun_x,
            gun_y,
            return_floor_x,
            arena_sweep_floor_y
        );

        gun_beam_visible = true;
        gun_beam_lethal = true;

        update_gun_beam(true);
    }


    // ------------------------------------------------
    // RESET GAP
    //
    // Turn the gun back to the opening angle while
    // it is not firing, then repeat the pattern.
    // ------------------------------------------------

    else
    {
        var reset_t =
            (cycle_time - return_end)
            /
            max(1, reset_pause_frames - 1);

        gun_angle = lerp(
            arena_sweep_right_angle,
            opening_right_angle,
            reset_t
        );

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

    // ================================================
    // ARENA LASER: FLOOR-SPARK EMISSION
    //
    // Only the real, firing continuous beam emits.
    // No sparks during warning rays or gaps.
    // The impact must be touching solid train roof.
    // ================================================

    var spark_impact_valid =
        gun_beam_visible &&
        gun_laser_len > 0 &&
        gunship_point_hits_solid(
            gun_laser_end_x,
            gun_laser_end_y + 2
        );

    if (spark_impact_valid)
    {
        var sweep_dx = 0;

        if (arena_sparks_last_active)
        {
            sweep_dx =
                gun_laser_end_x - arena_sparks_last_x;
        }

        // Sparks scatter backwards from horizontal sweep.
        // When nearly stationary, scatter to either side.
        var spray_direction = -sign(sweep_dx);

        if (spray_direction == 0)
        {
            spray_direction = choose(-1, 1);
        }

        var spark_count = 1;

        if (abs(sweep_dx) > 0.4)
        {
            spark_count = irandom_range(
                arena_sparks_moving_min,
                arena_sparks_moving_max
            );
        }
        else if (irandom(2) != 0)
        {
            spark_count = 0;
        }

        for (var spark_n = 0; spark_n < spark_count; spark_n++)
        {
            if (array_length(arena_sparks) >= arena_sparks_max)
            {
                break;
            }

            var spark_roll = random(1);
            var spark_colour;
            var spark_size;

            if (spark_roll < 0.65)
            {
                spark_colour = arena_laser_inner_colour;
                spark_size = irandom_range(2, 3);
            }
            else if (spark_roll < 0.9)
            {
                spark_colour = arena_laser_colour;
                spark_size = irandom_range(1, 2);
            }
            else
            {
                spark_colour = arena_laser_core_colour;
                spark_size = irandom_range(1, 2);
            }

            var spark_life = irandom_range(7, 14);
            var spark_ground = gun_laser_end_y - 2;

            array_push(arena_sparks,
            {
                x: gun_laser_end_x + random_range(-2, 2),
                y: spark_ground - random_range(0, 2),
                ground_y: spark_ground,
                vx: spray_direction * random_range(0.9, 2.5),
                vy: random_range(-1.7, -0.5),
                colour: spark_colour,
                size: spark_size,
                life: spark_life,
                max_life: spark_life,
                bounces_left: 1
            });
        }

        arena_sparks_last_x = gun_laser_end_x;
        arena_sparks_last_active = true;
    }
    else
    {
        arena_sparks_last_active = false;
    }

    arena_phase_frame++;
    exit;
}


// ====================================================
// SCRIPTED HUGE LASER: ACCEPT TRIGGER WHEN SAFE
// ====================================================

// A pending request waits until the current gun or mine attack
// has completely finished. Arena and weak-spot states win.
if (instance_exists(laser_trigger_request) &&
    !instance_exists(laser_trigger_active))
{
    var pending_laser = laser_trigger_request;

    if (
        state == "hover" &&
        ai_enabled &&
        !scripted_override &&
        !arena_phase_active &&
        !boss_defeated_pending &&
        target_player.state != "dead"
    )
    {
        laser_trigger_active = pending_laser;
        laser_target_x = pending_laser.request_target_x;
        laser_target_y = pending_laser.request_target_y;
        laser_fire_direction = (pending_laser.request_direction < 0) ? -1 : 1;
        laser_move_speed = max(0.1, pending_laser.request_move_speed);
        laser_arrival_tolerance = max(0.1, pending_laser.request_arrival_tolerance);
        laser_charge_duration_frames = max(1, pending_laser.request_charge_frames);
        laser_fire_duration_frames = max(1, pending_laser.request_fire_frames);
        laser_recovery_duration_frames = max(1, pending_laser.request_recovery_frames);

        pending_laser.accepted = true;
        facing = laser_fire_direction;
        hover_hspeed = 0;
        hover_vspeed = 0;
        gun_state = "idle";
        gun_beam_visible = false;
        gun_beam_lethal = false;
        gun_timer = 0;
        big_laser_visible = false;
        big_laser_lethal = false;

        // The repositioning state now waits for actual arrival.
        state = "big_laser_reposition";
        big_laser_timer = 0;
        last_attack = ATTACK_LASER;
    }
}

// Death or an arena takeover cancels any scripted laser.
if (
    (instance_exists(laser_trigger_active) ||
     instance_exists(laser_trigger_request)) &&
    (target_player.state == "dead" || arena_phase_active || !ai_enabled)
)
{
    laser_trigger_cancel();

    if (
        state == "big_laser_reposition" ||
        state == "big_laser_charge" ||
        state == "big_laser_fire" ||
        state == "big_laser_cooldown"
    )
    {
        state = "hover";
        attack_cooldown = irandom_range(attack_min_delay, attack_max_delay);
    }
}

// Trigger destroyed while the ship was executing it.
if (
    (state == "big_laser_reposition" ||
     state == "big_laser_charge" ||
     state == "big_laser_fire" ||
     state == "big_laser_cooldown") &&
    !instance_exists(laser_trigger_active)
)
{
    laser_trigger_cancel();
    state = "hover";
    attack_cooldown = irandom_range(attack_min_delay, attack_max_delay);
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

    // While dropping mines, favour the forward/right side
    // of the camera instead of a random position behind
    // JumpBot. Movement still uses the existing hover code.
    if (state == "mine_attack")
    {
        hover_target_x = clamp(
            cam_left + cam_width * 0.75,
            cam_left + 70,
            cam_left + cam_width - 70
        );
    }
}


// ====================================================
// HUGE LASER REPOSITIONING
// ====================================================

if (
    instance_exists(laser_trigger_active) &&
    (state == "big_laser_reposition" ||
     state == "big_laser_charge" ||
     state == "big_laser_fire" ||
     state == "big_laser_cooldown")
)
{
    facing = laser_fire_direction;
    hover_target_x = laser_target_x;
    hover_target_y = laser_target_y;
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

// Scripted attack: travel at configured speed, then stay
// exactly on the specified firing coordinates.
if (instance_exists(laser_trigger_active) &&
    (state == "big_laser_reposition" ||
     state == "big_laser_charge" ||
     state == "big_laser_fire" ||
     state == "big_laser_cooldown"))
{
    if (state == "big_laser_reposition")
    {
        x += clamp(laser_target_x - x, -laser_move_speed, laser_move_speed);
        y += clamp(laser_target_y - y, -laser_move_speed, laser_move_speed);
    }
    else
    {
        x = laser_target_x;
        y = laser_target_y;
    }

    hover_hspeed = 0;
    hover_vspeed = 0;
}
else
{
    x += hover_hspeed;
    y += hover_vspeed;
}


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
//
// Huge horizontal laser is SCRIPTED ONLY; normal AI
// selects between the cannon and mines.
// ====================================================

if (
    ai_enabled &&
    !scripted_override &&
    state == "hover" &&
    !instance_exists(laser_trigger_request) &&
    !instance_exists(laser_trigger_active)
)
{
    attack_cooldown--;

    if (attack_cooldown <= 0)
    {
        var attack_choice = ATTACK_GUN;

        if (mine_object != -1)
        {
            // Alternate when possible, to avoid repeats.
            attack_choice = choose(ATTACK_GUN, ATTACK_MINE);

            if (attack_choice == last_attack)
            {
                attack_choice = (attack_choice == ATTACK_GUN)
                    ? ATTACK_MINE
                    : ATTACK_GUN;
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
    // Wait until the actual mine release point is in the
    // right half of the current camera view. This prevents
    // drops behind the player while the Gunship travels.
    var mine_release_x = x + mine_mount_offset_x * facing;
    var mine_release_min_x = cam_left + cam_width * 0.55;

    if (mine_release_x >= mine_release_min_x)
    {
        mine_drop_timer--;
    }

    if (mine_drop_timer <= 0 &&
        mine_release_x >= mine_release_min_x)
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
        // Do not start charging until the Gunship actually
        // reaches the destination chosen in the room editor.
        if (
            instance_exists(laser_trigger_active) &&
            abs(x - laser_target_x) <= laser_arrival_tolerance &&
            abs(y - laser_target_y) <= laser_arrival_tolerance
        )
        {
            x = laser_target_x;
            y = laser_target_y;
            state = "big_laser_charge";
            big_laser_timer = laser_charge_duration_frames;
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
            big_laser_timer = laser_fire_duration_frames;

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
                laser_recovery_duration_frames;

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
            laser_trigger_finish();
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