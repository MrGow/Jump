/// @func scr_player_died(
///     [_lock_feet_y],
///     [_fall_death],
///     [_shake_strength],
///     [_shake_frames],
///     [_death_type]
/// )
///
/// @desc Handles all player deaths.
///
/// Death types:
///     "explode"          = default explosion and body parts
///     "electrocution"    = spriteBotDeathElectrocution
///     "crushed_above"    = spriteBotDeathCrushedFromAbove
///     "shredded_below"   = spriteBotDeathShreddedFromBelow
///     "shutdown"         = spriteBotDeath
///
/// Existing calls such as scr_player_died() still use
/// the default explosion death.

function scr_player_died(
    _lock_feet_y,
    _fall_death,
    _shake_strength_override,
    _shake_frames_override,
    _death_type
)
{
    // Prevent repeated death calls.
    if (state == "dead")
    {
        return;
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
        _fall_death;

    death_type =
        string_lower(
            string(_death_type)
        );


    // ====================================================
    // ACCEPT SOME SHORTER ALIASES
    // ====================================================

    switch (death_type)
    {
        case "electric":
        case "electricity":
        case "electrocuted":
        {
            death_type =
                "electrocution";
        }
        break;


        case "crush":
        case "crushed":
        case "smashed":
        case "smasher":
        {
            death_type =
                "crushed_above";
        }
        break;


        case "shred":
        case "shredded":
        case "shredder":
        {
            death_type =
                "shredded_below";
        }
        break;


        case "turn_off":
        case "turned_off":
        case "power_off":
        case "old":
        {
            death_type =
                "shutdown";
        }
        break;


        case "explosion":
        case "default":
        {
            death_type =
                "explode";
        }
        break;
    }


    // ====================================================
    // VALIDATE DEATH TYPE
    // ====================================================

    var _valid_death_type =
        death_type == "explode" ||
        death_type == "electrocution" ||
        death_type == "crushed_above" ||
        death_type == "shredded_below" ||
        death_type == "shutdown";

    if (!_valid_death_type)
    {
        death_type =
            "explode";
    }


    // ====================================================
    // CAMERA LOCK FOR FALL DEATHS
    // ====================================================

    if (death_fall)
    {
        death_cam_lock_x = x;
        death_cam_lock_y = y;

        if (instance_exists(oCamera))
        {
            var _camera_instance =
                instance_find(
                    oCamera,
                    0
                );

            if (_camera_instance != noone)
            {
                if (
                    variable_instance_exists(
                        _camera_instance,
                        "cam"
                    )
                )
                {
                    death_cam_lock_x =
                        camera_get_view_x(
                            _camera_instance.cam
                        );

                    death_cam_lock_y =
                        camera_get_view_y(
                            _camera_instance.cam
                        );
                }

                if (
                    variable_instance_exists(
                        _camera_instance,
                        "fade_state"
                    )
                )
                {
                    _camera_instance.fade_state = 0;
                }

                if (
                    variable_instance_exists(
                        _camera_instance,
                        "fade_alpha"
                    )
                )
                {
                    _camera_instance.fade_alpha = 0;
                }

                if (
                    variable_instance_exists(
                        _camera_instance,
                        "pending_zone"
                    )
                )
                {
                    _camera_instance.pending_zone = noone;
                }

                if (
                    variable_instance_exists(
                        _camera_instance,
                        "fade_hold_timer"
                    )
                )
                {
                    _camera_instance.fade_hold_timer = 0;
                }
            }
        }
    }


    // ====================================================
    // LOCK FEET TO HAZARD CONTACT POINT
    // ====================================================

    if (!is_undefined(_lock_feet_y))
    {
        var _feet_difference =
            _lock_feet_y -
            bbox_bottom;

        y += _feet_difference;
    }


    // ====================================================
    // SAVE DEATH POSITION
    // ====================================================

    var _death_x =
        (
            bbox_left +
            bbox_right
        )
        *
        0.5;

    var _death_y =
        (
            bbox_top +
            bbox_bottom
        )
        *
        0.5;

    var _death_facing =
        sign(facing);

    if (_death_facing == 0)
    {
        _death_facing = 1;
    }


    // ====================================================
    // CHOOSE WHETHER PLAYER SPRITE DRAWS
    //
    // Explosion hides the player.
    // Alternative deaths animate the player sprite.
    // ====================================================

    death_uses_player_sprite =
        death_type != "explode";


    // ====================================================
    // ENTER DEAD STATE
    // ====================================================

    state =
        "dead";


    // ====================================================
    // BIRD DEATH
    //
    // Bird always uses spriteBirdDeath.
    // ====================================================

    if (
        variable_instance_exists(id, "bird") &&
        instance_exists(bird)
    )
    {
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
            bird.bird_state =
                "dead";

            bird.bird_death_x =
                bird.x;

            bird.bird_death_y =
                bird.y;

            bird.bird_death_facing =
                sign(
                    bird.image_xscale
                );

            if (bird.bird_death_facing == 0)
            {
                bird.bird_death_facing = 1;
            }

            var _bird_death_sprite =
                asset_get_index(
                    "spriteBirdDeath"
                );

            if (_bird_death_sprite != -1)
            {
                bird.sprite_index =
                    _bird_death_sprite;

                bird.image_index = 0;
                bird.image_speed = 0.35;

                bird.image_xscale =
                    bird.bird_death_facing;

                bird.image_yscale = 1;
                bird.image_angle  = 0;
                bird.image_alpha  = 1;
                bird.image_blend  = c_white;
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

    var _shake_strength =
        variable_global_exists(
            "death_shake_strength"
        )
        ? global.death_shake_strength
        : 10;

    var _shake_frames =
        variable_global_exists(
            "death_shake_frames"
        )
        ? global.death_shake_frames
        : 14;

    if (!is_undefined(_shake_strength_override))
    {
        _shake_strength =
            _shake_strength_override;
    }

    if (!is_undefined(_shake_frames_override))
    {
        _shake_frames =
            _shake_frames_override;
    }

    global.shake_mag =
        max(
            0,
            round(_shake_strength)
        );

    global.shake_time =
        max(
            0,
            round(_shake_frames)
        );


    // ====================================================
    // STOP NORMAL PLAYER MOVEMENT
    // ====================================================

    hsp = 0;

    if (!death_fall)
    {
        vsp = 0;
    }

    jump_charging     = false;
    jump_charge       = 0;
    jump_charge_level = 0;

    charge_grace      = 0;
    support_grace     = 0;
    charge_start_lock = 0;

    ground_stick  = 0;
    ground_frames = 0;

    bounce_pending = false;
    bounce_timer   = 0;

    standing_platform =
        noone;


    // ====================================================
    // DEATH PRESENTATION
    // ====================================================

    var _presentation_object =
        noone;

    var _presentation_sprite =
        -1;

    var _presentation_speed =
        0.25;


    switch (death_type)
    {
        // ------------------------------------------------
        // ELECTROCUTION
        // ------------------------------------------------
        case "electrocution":
        {
            _presentation_sprite =
                asset_get_index(
                    "spriteBotDeathElectrocution"
                );
        }
        break;


        // ------------------------------------------------
        // CRUSHED FROM ABOVE
        // ------------------------------------------------
        case "crushed_above":
        {
            _presentation_sprite =
                asset_get_index(
                    "spriteBotDeathCrushedFromAbove"
                );
        }
        break;


        // ------------------------------------------------
        // SHREDDED FROM BELOW
        // ------------------------------------------------
        case "shredded_below":
        {
            _presentation_sprite =
                asset_get_index(
                    "spriteBotDeathShreddedFromBelow"
                );
        }
        break;


        // ------------------------------------------------
        // OLD POWER-OFF DEATH
        // ------------------------------------------------
        case "shutdown":
        {
            _presentation_sprite =
                asset_get_index(
                    "spriteBotDeath"
                );
        }
        break;


        // ------------------------------------------------
        // DEFAULT EXPLOSION
        // ------------------------------------------------
        case "explode":
        default:
        {
            death_type =
                "explode";

            death_uses_player_sprite =
                false;

            image_speed = 0;
            image_alpha = 0;

            var _explosion_object =
                asset_get_index(
                    "oDeathExplosion"
                );

            if (_explosion_object != -1)
            {
                var _effect_layer =
                    layer_exists("Effects")
                    ? "Effects"
                    : "Instances";

                _presentation_object =
                    instance_create_layer(
                        _death_x,
                        _death_y,
                        _effect_layer,
                        _explosion_object
                    );

                if (_presentation_object != noone)
                {
                    _presentation_object.image_xscale =
                        _death_facing;

                    _presentation_object.image_yscale =
                        1;

                    if (
                        variable_instance_exists(
                            _presentation_object,
                            "spawn_all_parts"
                        ) &&
                        is_callable(
                            _presentation_object.spawn_all_parts
                        )
                    )
                    {
                        _presentation_object.spawn_all_parts();
                    }
                }
            }
        }
        break;
    }


    // ====================================================
    // APPLY ALTERNATIVE PLAYER-SPRITE DEATH
    // ====================================================

    if (death_uses_player_sprite)
    {
        // Missing special sprite falls back to explosion.
        if (_presentation_sprite == -1)
        {
            death_type =
                "explode";

            death_uses_player_sprite =
                false;

            image_speed = 0;
            image_alpha = 0;

            var _fallback_explosion_object =
                asset_get_index(
                    "oDeathExplosion"
                );

            if (_fallback_explosion_object != -1)
            {
                var _fallback_layer =
                    layer_exists("Effects")
                    ? "Effects"
                    : "Instances";

                _presentation_object =
                    instance_create_layer(
                        _death_x,
                        _death_y,
                        _fallback_layer,
                        _fallback_explosion_object
                    );

                if (_presentation_object != noone)
                {
                    _presentation_object.image_xscale =
                        _death_facing;

                    _presentation_object.image_yscale =
                        1;

                    if (
                        variable_instance_exists(
                            _presentation_object,
                            "spawn_all_parts"
                        ) &&
                        is_callable(
                            _presentation_object.spawn_all_parts
                        )
                    )
                    {
                        _presentation_object.spawn_all_parts();
                    }
                }
            }
        }
        else
        {
            sprite_index =
                _presentation_sprite;

            image_index =
                0;

            image_speed =
                _presentation_speed;

            image_xscale =
                _death_facing;

            image_yscale =
                1;

            image_angle =
                0;

            image_alpha =
                1;

            image_blend =
                c_white;
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

    var _presentation_duration =
        round(
            room_speed *
            0.9
        );


    // ----------------------------------------------------
    // Player-sprite death duration
    // ----------------------------------------------------

    if (
        death_uses_player_sprite &&
        _presentation_sprite != -1
    )
    {
        var _player_death_frames =
            sprite_get_number(
                _presentation_sprite
            );

        var _player_death_duration =
            ceil(
                _player_death_frames /
                max(
                    0.01,
                    _presentation_speed
                )
            );

        _presentation_duration =
            max(
                _presentation_duration,
                _player_death_duration
            );
    }


    // ----------------------------------------------------
    // Explosion duration
    // ----------------------------------------------------

    if (_presentation_object != noone)
    {
        var _object_sprite =
            _presentation_object.sprite_index;

        var _object_speed =
            abs(
                _presentation_object.image_speed
            );

        if (
            _object_sprite != -1 &&
            _object_speed > 0
        )
        {
            var _object_frames =
                sprite_get_number(
                    _object_sprite
                );

            var _object_duration =
                ceil(
                    _object_frames /
                    max(
                        0.01,
                        _object_speed
                    )
                );

            _presentation_duration =
                max(
                    _presentation_duration,
                    _object_duration
                );
        }
    }


    // ----------------------------------------------------
    // Bird death duration
    // ----------------------------------------------------

    var _bird_sprite =
        asset_get_index(
            "spriteBirdDeath"
        );

    if (_bird_sprite != -1)
    {
        var _bird_duration =
            ceil(
                sprite_get_number(
                    _bird_sprite
                )
                /
                0.35
            );

        _presentation_duration =
            max(
                _presentation_duration,
                _bird_duration
            );
    }


    // ====================================================
    // SEND DELAY TO RUN CONTROLLER
    // ====================================================

    if (instance_exists(oRunController))
    {
        var _run_controller =
            instance_find(
                oRunController,
                0
            );

        if (_run_controller != noone)
        {
            var _minimum_delay =
                room_speed *
                0.6;

            if (
                variable_instance_exists(
                    _run_controller,
                    "death_delay_frames"
                )
            )
            {
                _minimum_delay =
                    _run_controller.death_delay_frames;
            }

            _run_controller.death_delay_timer =
                max(
                    _minimum_delay,
                    _presentation_duration
                );
        }
    }
    else
    {
        global.game_phase =
            "death_menu";

        if (!instance_exists(oDeathMenu))
        {
            var _menu_layer =
                layer_exists("GUI")
                ? "GUI"
                : "Instances";

            instance_create_layer(
                0,
                0,
                _menu_layer,
                oDeathMenu
            );
        }
    }
}