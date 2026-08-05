
/// @func scr_player_died(
///     [_lock_feet_y],
///     [_fall_death],
///     [_shake_strength],
///     [_shake_frames],
///     [_death_type]
/// )
///
/// @desc Central player-death handler.

function scr_player_died(
    _lock_feet_y,
    _fall_death,
    _shake_strength_override,
    _shake_frames_override,
    _death_type
)
{
    // ====================================================
    // PREVENT REPEATED DEATH CALLS
    // ====================================================

    if (
        variable_instance_exists(id, "state") &&
        state == "dead"
    )
    {
        return;
    }


    // ====================================================
    // RESPAWN INVULNERABILITY
    //
    // Every hazard ultimately calls this script, so this
    // single check protects the player from ALL deaths
    // during the post-respawn safety window.
    // ====================================================

    if (
        variable_instance_exists(id, "invincible") &&
        invincible
    )
    {
        return;
    }


    // ====================================================
    // DEFAULT ARGUMENTS
    // ====================================================

    if (is_undefined(_fall_death))
    {
        _fall_death = false;
    }

    if (is_undefined(_death_type))
    {
        _death_type = "explode";
    }

    death_fall =
        bool(_fall_death);

    death_type =
        string_lower(
            string(_death_type)
        );


    // ====================================================
    // BACKWARD-COMPATIBLE FALL HANDLING
    // ====================================================

    if (
        death_fall &&
        (
            death_type == "" ||
            death_type == "explode" ||
            death_type == "explosion" ||
            death_type == "default"
        )
    )
    {
        death_type = "fall";
    }


    // ====================================================
    // NORMALIZE DEATH-TYPE ALIASES
    // ====================================================

    switch (death_type)
    {
        case "electric":
        case "electricity":
        case "electrocuted":
        case "electrocution":
        case "electrocute":
        {
            death_type = "electrocute";
        }
        break;

        case "crushed":
        case "crushed_above":
        case "smashed":
        case "smasher":
        case "overhead_smasher":
        case "crush":
        {
            death_type = "crush";
        }
        break;

        case "rip":
        case "ripped":
        case "rippedapart":
        case "shred":
        case "shredded":
        case "shredder":
        case "shredded_below":
        case "ripped_apart":
        {
            death_type = "ripped_apart";
        }
        break;

        case "offscreen":
        case "offscreen_fall":
        case "pit":
        case "void":
        case "bottomless_pit":
        case "fall":
        {
            death_type = "fall";
            death_fall = true;
        }
        break;

        case "turn_off":
        case "turned_off":
        case "power_off":
        case "old":
        case "shutdown":
        {
            death_type = "shutdown";
        }
        break;

        case "explosion":
        case "default":
        case "explode":
        {
            death_type = "explode";
        }
        break;
    }


    // ====================================================
    // VALIDATE DEATH TYPE
    // ====================================================

    var valid_death_type =
        death_type == "explode" ||
        death_type == "electrocute" ||
        death_type == "crush" ||
        death_type == "ripped_apart" ||
        death_type == "fall" ||
        death_type == "shutdown";

    if (!valid_death_type)
    {
        death_type = "explode";
        death_fall = false;
    }


    // ====================================================
    // DEATH COUNTER
    // ====================================================

    if (!variable_global_exists("deaths_total"))
    {
        global.deaths_total = 0;
    }

    global.deaths_total++;


    // ====================================================
    // DEATH ACHIEVEMENTS
    // ====================================================

    scr_achievement_unlock("ACH_DEATH_1");

    if (global.deaths_total >= 10)
    {
        scr_achievement_unlock("ACH_DEATH_2");
    }

    if (global.deaths_total >= 50)
    {
        scr_achievement_unlock("ACH_DEATH_3");
    }

    if (global.deaths_total >= 100)
    {
        scr_achievement_unlock("ACH_DEATH_4");
    }


    // ====================================================
    // ASSET LOOKUPS
    // ====================================================

    var sprite_death_electrocute =
        asset_get_index("spriteBotDeathElectrocute");

    var sprite_death_crush =
        asset_get_index("spriteBotDeathCrush");

    var sprite_death_ripped_apart =
        asset_get_index("spriteBotDeathRippedApart");

    var sprite_death_shutdown =
        asset_get_index("spriteBotDeath");

    var sound_death_explosion =
        asset_get_index("ExplosionDeath1");

    var sound_death_electrocute =
        asset_get_index("ElectrocuteDeath1");

    var sound_death_crush =
        asset_get_index("CrushDeath1");

    var sound_death_ripped_apart =
        asset_get_index("RippedApartDeath1");

    var sound_death_fall =
        asset_get_index("OffscreenFallDeath1");

    var sound_bird_death =
        asset_get_index("BirdDeath1");


    // ====================================================
    // DEATH PROFILE DEFAULTS
    // ====================================================

    var presentation_sprite = -1;
    var presentation_object = noone;
    var presentation_speed  = 1;

    var death_sound = -1;
    var death_sound_gain = 1.0;

    var uses_player_sprite = true;

    var profile_animation_speed = 1.0;
    var profile_hitstop_frames  = 0;

    var profile_jitter_strength = 0;

    var profile_flicker_enabled = false;
    var profile_flicker_rate = 2;
    var profile_flicker_colour_a = c_white;
    var profile_flicker_colour_b = c_white;

    var profile_sink_enabled = false;
    var profile_sink_delay = 0;
    var profile_sink_velocity = 0;
    var profile_sink_acceleration = 0;
    var profile_sink_max = 0;

    var profile_flash_colour = c_white;
    var profile_flash_alpha = 0;
    var profile_flash_fade_speed = 0.12;

    var profile_rumble_low = 0.85;
    var profile_rumble_high = 0.65;
    var profile_rumble_frames = 18;

    var profile_shake_strength =
        variable_global_exists("death_shake_strength")
        ? global.death_shake_strength
        : 10;

    var profile_shake_frames =
        variable_global_exists("death_shake_frames")
        ? global.death_shake_frames
        : 14;


    // ====================================================
    // SELECT DEATH PROFILE
    // ====================================================

    switch (death_type)
    {
        case "electrocute":
        {
            presentation_sprite = sprite_death_electrocute;
            death_sound = sound_death_electrocute;
            death_sound_gain = 1.0;

            profile_animation_speed = 0.75;
            profile_hitstop_frames = 2;
            profile_jitter_strength = 2;

            profile_flicker_enabled = true;
            profile_flicker_rate = 2;
            profile_flicker_colour_a = c_white;
            profile_flicker_colour_b =
                make_colour_rgb(110, 205, 255);

            profile_flash_colour =
                make_colour_rgb(180, 230, 255);

            profile_flash_alpha = 0.38;
            profile_flash_fade_speed = 0.075;

            profile_rumble_low = 0.35;
            profile_rumble_high = 0.90;
            profile_rumble_frames = 16;

            profile_shake_strength = 14;
            profile_shake_frames = 12;

            uses_player_sprite = true;
            death_fall = false;
        }
        break;


        case "crush":
        {
            presentation_sprite = sprite_death_crush;
            death_sound = sound_death_crush;
            death_sound_gain = 1.0;

            profile_animation_speed = 0.50;
            profile_hitstop_frames = 4;

            profile_flash_colour = c_white;
            profile_flash_alpha = 0.20;
            profile_flash_fade_speed = 0.10;

            profile_rumble_low = 0.95;
            profile_rumble_high = 0.35;
            profile_rumble_frames = 18;

            profile_shake_strength = 24;
            profile_shake_frames = 17;

            uses_player_sprite = true;
            death_fall = false;
        }
        break;


        case "ripped_apart":
        {
            presentation_sprite =
                sprite_death_ripped_apart;

            death_sound =
                sound_death_ripped_apart;

            death_sound_gain = 1.0;

            profile_animation_speed = 0.70;
            profile_hitstop_frames = 4;

            profile_sink_enabled = true;
            profile_sink_delay = 0;
            profile_sink_velocity = 0.25;
            profile_sink_acceleration = 0.055;
            profile_sink_max = 40;

            profile_flash_colour =
                make_colour_rgb(255, 95, 55);

            profile_flash_alpha = 0.34;
            profile_flash_fade_speed = 0.085;

            profile_rumble_low = 0.85;
            profile_rumble_high = 0.65;
            profile_rumble_frames = 18;

            profile_shake_strength = 26;
            profile_shake_frames = 18;

            uses_player_sprite = true;
            death_fall = false;
        }
        break;


        case "fall":
        {
            presentation_sprite = sprite_death_shutdown;

            death_sound = sound_death_fall;
            death_sound_gain = 1.0;

            profile_animation_speed = 0.35;

            profile_flash_colour = c_black;
            profile_flash_alpha = 0;
            profile_flash_fade_speed = 0.12;

            profile_rumble_low = 0.18;
            profile_rumble_high = 0.08;
            profile_rumble_frames = 8;

            profile_shake_strength = 0;
            profile_shake_frames = 0;

            uses_player_sprite = true;
            death_fall = true;
        }
        break;


        case "shutdown":
        {
            presentation_sprite = sprite_death_shutdown;

            death_sound = -1;

            profile_animation_speed = 0.35;

            profile_flash_colour = c_white;
            profile_flash_alpha = 0.10;
            profile_flash_fade_speed = 0.12;

            profile_rumble_low = 0.12;
            profile_rumble_high = 0.04;
            profile_rumble_frames = 8;

            profile_shake_strength = 5;
            profile_shake_frames = 8;

            uses_player_sprite = true;
            death_fall = false;
        }
        break;


        case "explode":
        default:
        {
            death_type = "explode";

            presentation_sprite = -1;

            death_sound =
                sound_death_explosion;

            death_sound_gain = 1.0;

            profile_animation_speed = 0;

            profile_flash_colour = c_white;
            profile_flash_alpha = 0.58;
            profile_flash_fade_speed = 0.095;

            profile_shake_strength =
                variable_global_exists(
                    "death_shake_strength"
                )
                ? global.death_shake_strength
                : 26;

            profile_shake_frames =
                variable_global_exists(
                    "death_shake_frames"
                )
                ? global.death_shake_frames
                : 18;

            profile_rumble_low = 0.85;
            profile_rumble_high = 0.65;
            profile_rumble_frames = 18;

            uses_player_sprite = false;
            death_fall = false;
        }
        break;
    }


    // ====================================================
    // MISSING SPECIAL SPRITE FALLBACK
    // ====================================================

    if (
        uses_player_sprite &&
        presentation_sprite == -1 &&
        death_type != "fall"
    )
    {
        death_type = "explode";
        death_fall = false;

        presentation_sprite = -1;
        uses_player_sprite = false;

        death_sound = sound_death_explosion;
        death_sound_gain = 1.0;

        profile_animation_speed = 0;
        profile_hitstop_frames = 0;

        profile_jitter_strength = 0;

        profile_flicker_enabled = false;
        profile_flicker_rate = 2;
        profile_flicker_colour_a = c_white;
        profile_flicker_colour_b = c_white;

        profile_sink_enabled = false;
        profile_sink_delay = 0;
        profile_sink_velocity = 0;
        profile_sink_acceleration = 0;
        profile_sink_max = 0;

        profile_flash_colour = c_white;
        profile_flash_alpha = 0.58;
        profile_flash_fade_speed = 0.095;

        profile_shake_strength =
            variable_global_exists(
                "death_shake_strength"
            )
            ? global.death_shake_strength
            : 26;

        profile_shake_frames =
            variable_global_exists(
                "death_shake_frames"
            )
            ? global.death_shake_frames
            : 18;

        profile_rumble_low = 0.85;
        profile_rumble_high = 0.65;
        profile_rumble_frames = 18;
    }


    death_uses_player_sprite =
        uses_player_sprite;


    // ====================================================
    // APPLY SPECIAL PRESENTATION PROFILE
    // ====================================================

    death_animation_speed =
        profile_animation_speed;

    death_hitstop_timer =
        max(0, round(profile_hitstop_frames));

    death_effect_timer = 0;

    death_draw_offset_x = 0;
    death_draw_offset_y = 0;

    death_jitter_strength =
        max(0, profile_jitter_strength);

    death_flicker_enabled =
        profile_flicker_enabled;

    death_flicker_rate =
        max(1, round(profile_flicker_rate));

    death_flicker_colour_a =
        profile_flicker_colour_a;

    death_flicker_colour_b =
        profile_flicker_colour_b;

    death_sink_enabled =
        profile_sink_enabled;

    death_sink_delay =
        max(0, round(profile_sink_delay));

    death_sink_offset = 0;

    death_sink_velocity =
        profile_sink_velocity;

    death_sink_acceleration =
        profile_sink_acceleration;

    death_sink_max =
        max(0, profile_sink_max);


    // ====================================================
    // SCREEN FLASH
    // ====================================================

    global.death_flash_colour =
        profile_flash_colour;

    global.death_flash_alpha =
        clamp(profile_flash_alpha, 0, 1);

    global.death_flash_fade_speed =
        max(0.001, profile_flash_fade_speed);


    // ====================================================
    // CAMERA LOCK FOR FALL DEATHS
    // ====================================================

    if (death_fall)
    {
        death_cam_lock_x = x;
        death_cam_lock_y = y;

        if (instance_exists(oCamera))
        {
            var camera_instance =
                instance_find(oCamera, 0);

            if (camera_instance != noone)
            {
                if (
                    variable_instance_exists(
                        camera_instance,
                        "cam"
                    )
                )
                {
                    death_cam_lock_x =
                        camera_get_view_x(
                            camera_instance.cam
                        );

                    death_cam_lock_y =
                        camera_get_view_y(
                            camera_instance.cam
                        );
                }

                if (
                    variable_instance_exists(
                        camera_instance,
                        "fade_state"
                    )
                )
                {
                    camera_instance.fade_state = 0;
                }

                if (
                    variable_instance_exists(
                        camera_instance,
                        "fade_alpha"
                    )
                )
                {
                    camera_instance.fade_alpha = 0;
                }

                if (
                    variable_instance_exists(
                        camera_instance,
                        "pending_zone"
                    )
                )
                {
                    camera_instance.pending_zone = noone;
                }

                if (
                    variable_instance_exists(
                        camera_instance,
                        "fade_hold_timer"
                    )
                )
                {
                    camera_instance.fade_hold_timer = 0;
                }
            }
        }
    }


    // ====================================================
    // LOCK FEET
    // ====================================================

    if (!is_undefined(_lock_feet_y))
    {
        var feet_difference =
            _lock_feet_y -
            bbox_bottom;

        y += feet_difference;
    }


    // ====================================================
    // SAVE DEATH POSITION
    // ====================================================

    var death_x =
        (bbox_left + bbox_right) * 0.5;

    var death_y =
        (bbox_top + bbox_bottom) * 0.5;

    var death_facing =
        sign(facing);

    if (death_facing == 0)
    {
        death_facing = 1;
    }


    // ====================================================
    // ENTER DEAD STATE
    // ====================================================

    state = "dead";


    // ====================================================
    // DEATH RUMBLE
    // ====================================================

    scr_rumble_play(
        profile_rumble_low,
        profile_rumble_high,
        profile_rumble_frames
    );


    // ====================================================
    // DEATH SOUND
    // ====================================================

    if (death_sound != -1)
    {
        scr_play_sfx(
            death_sound,
            death_sound_gain,
            random_range(0.98, 1.02)
        );
    }


    // ====================================================
    // BIRD DEATH
    // ====================================================

    if (
        variable_instance_exists(id, "bird") &&
        instance_exists(bird)
    )
    {
        if (sound_bird_death != -1)
        {
            scr_play_sfx(
                sound_bird_death,
                1.0,
                random_range(0.98, 1.02)
            );
        }

        if (
            variable_instance_exists(
                bird,
                "bird_die"
            ) &&
            is_callable(
                bird.bird_die
            )
        )
        {
            bird.bird_die();
        }
        else
        {
            bird.bird_state = "dead";

            bird.bird_death_x = bird.x;
            bird.bird_death_y = bird.y;

            bird.bird_death_facing =
                sign(bird.image_xscale);

            if (bird.bird_death_facing == 0)
            {
                bird.bird_death_facing = 1;
            }

            var bird_death_sprite =
                asset_get_index("spriteBirdDeath");

            if (bird_death_sprite != -1)
            {
                bird.sprite_index =
                    bird_death_sprite;

                bird.image_index = 0;
                bird.image_speed = 0.35;

                bird.image_xscale =
                    bird.bird_death_facing;

                bird.image_yscale = 1;
                bird.image_angle = 0;
                bird.image_alpha = 1;
                bird.image_blend = c_white;
            }
            else
            {
                bird.image_speed = 0;
                bird.image_alpha = 0;
            }
        }
    }


    // ====================================================
    // CAMERA SHAKE
    // ====================================================

    var shake_strength =
        profile_shake_strength;

    var shake_frames =
        profile_shake_frames;

    if (!is_undefined(_shake_strength_override))
    {
        shake_strength =
            _shake_strength_override;
    }

    if (!is_undefined(_shake_frames_override))
    {
        shake_frames =
            _shake_frames_override;
    }

    global.shake_mag =
        max(0, round(shake_strength));

    global.shake_time =
        max(0, round(shake_frames));


    // ====================================================
    // STOP NORMAL MOVEMENT
    // ====================================================

    hsp = 0;

    if (!death_fall)
    {
        vsp = 0;
    }

    jump_charging = false;
    jump_charge = 0;
    jump_charge_level = 0;

    charge_grace = 0;
    support_grace = 0;
    charge_start_lock = 0;

    if (variable_instance_exists(id, "ground_stick"))
    {
        ground_stick = 0;
    }

    if (variable_instance_exists(id, "ground_frames"))
    {
        ground_frames = 0;
    }

    bounce_pending = false;
    bounce_timer = 0;

    standing_platform = noone;


    // ====================================================
    // CREATE DEATH PRESENTATION
    // ====================================================

    if (uses_player_sprite)
    {
        if (
            death_type == "fall" &&
            presentation_sprite == -1
        )
        {
            image_alpha = 1;
            image_speed = 0;
        }
        else
        {
            sprite_index =
                presentation_sprite;

            image_index = 0;

            image_speed =
                death_animation_speed;

            image_xscale =
                death_facing;

            image_yscale = 1;
            image_angle = 0;
            image_alpha = 1;
            image_blend = c_white;
        }
    }
    else
    {
        image_speed = 0;
        image_alpha = 0;

        var explosion_object =
            asset_get_index("oDeathExplosion");

        if (explosion_object != -1)
        {
            var effect_layer =
                layer_exists("Effects")
                ? "Effects"
                : "Instances";

            presentation_object =
                instance_create_layer(
                    death_x,
                    death_y + 18,
                    effect_layer,
                    explosion_object
                );

            if (presentation_object != noone)
            {
                presentation_object.image_xscale =
                    death_facing;

                presentation_object.image_yscale =
                    1;

                if (
                    variable_instance_exists(
                        presentation_object,
                        "spawn_all_parts"
                    ) &&
                    is_callable(
                        presentation_object.spawn_all_parts
                    )
                )
                {
                    presentation_object.spawn_all_parts();
                }
            }
        }
    }


    // ====================================================
    // BEGIN DEATH DELAY
    // ====================================================

    global.game_phase =
        "death_delay";


    // ====================================================
    // CALCULATE PRESENTATION DURATION
    // ====================================================

    var presentation_duration =
        round(room_speed * 0.9);


    if (
        uses_player_sprite &&
        presentation_sprite != -1
    )
    {
        var player_death_frames =
            sprite_get_number(
                presentation_sprite
            );

        var player_death_duration =
            ceil(
                player_death_frames /
                max(
                    0.01,
                    death_animation_speed
                )
            );

        presentation_duration =
            max(
                presentation_duration,
                player_death_duration
            );
    }


    if (presentation_object != noone)
    {
        var object_sprite =
            presentation_object.sprite_index;

        var object_speed =
            abs(
                presentation_object.image_speed
            );

        if (
            object_sprite != -1 &&
            object_speed > 0
        )
        {
            var object_frames =
                sprite_get_number(
                    object_sprite
                );

            var object_duration =
                ceil(
                    object_frames /
                    max(
                        0.01,
                        object_speed
                    )
                );

            presentation_duration =
                max(
                    presentation_duration,
                    object_duration
                );
        }
    }


    var bird_sprite =
        asset_get_index("spriteBirdDeath");

    if (bird_sprite != -1)
    {
        var bird_duration =
            ceil(
                sprite_get_number(
                    bird_sprite
                )
                /
                0.35
            );

        presentation_duration =
            max(
                presentation_duration,
                bird_duration
            );
    }


    // ====================================================
    // SEND DELAY TO RUN CONTROLLER
    // ====================================================

    if (instance_exists(oRunController))
    {
        var run_controller =
            instance_find(
                oRunController,
                0
            );

        if (run_controller != noone)
        {
            var minimum_delay =
                room_speed * 0.6;

            if (
                variable_instance_exists(
                    run_controller,
                    "death_delay_frames"
                )
            )
            {
                minimum_delay =
                    run_controller.death_delay_frames;
            }

            run_controller.death_delay_timer =
                max(
                    minimum_delay,
                    presentation_duration
                );
        }
    }
    else
    {
        global.game_phase =
            "death_menu";

        if (!instance_exists(oDeathMenu))
        {
            var menu_layer =
                layer_exists("GUI")
                ? "GUI"
                : "Instances";

            instance_create_layer(
                0,
                0,
                menu_layer,
                oDeathMenu
            );
        }
    }
}