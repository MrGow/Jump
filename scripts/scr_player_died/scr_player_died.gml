/// @func scr_player_died([_lock_feet_y], [_fall_death], [_shake_strength], [_shake_frames])
/// @desc Handle player death and allow spriteBotDeath to play before the death menu.

function scr_player_died(
    _lock_feet_y,
    _fall_death,
    _shake_strength_override,
    _shake_frames_override
)
{
    // Prevent repeated death calls
    if (state == "dead")
    {
        return;
    }

    // ----------------------------------------------------
    // Death counter
    // ----------------------------------------------------
    if (!variable_global_exists("deaths_total"))
    {
        global.deaths_total = 0;
    }

    global.deaths_total++;

    // ----------------------------------------------------
    // Death achievements
    // ----------------------------------------------------
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

    // ----------------------------------------------------
    // Death type
    // ----------------------------------------------------
    if (is_undefined(_fall_death))
    {
        _fall_death = false;
    }

    death_fall = _fall_death;

    // ----------------------------------------------------
    // Camera lock for fall deaths
    // ----------------------------------------------------
    if (death_fall)
    {
        death_cam_lock_x = x;
        death_cam_lock_y = y;

        if (instance_exists(oCamera))
        {
            var _cam_inst = instance_find(oCamera, 0);

            if (_cam_inst != noone)
            {
                if (variable_instance_exists(_cam_inst, "cam"))
                {
                    death_cam_lock_x =
                        camera_get_view_x(_cam_inst.cam);

                    death_cam_lock_y =
                        camera_get_view_y(_cam_inst.cam);
                }

                if (variable_instance_exists(_cam_inst, "fade_state"))
                {
                    _cam_inst.fade_state = 0;
                }

                if (variable_instance_exists(_cam_inst, "fade_alpha"))
                {
                    _cam_inst.fade_alpha = 0;
                }

                if (variable_instance_exists(_cam_inst, "pending_zone"))
                {
                    _cam_inst.pending_zone = noone;
                }

                if (variable_instance_exists(_cam_inst, "fade_hold_timer"))
                {
                    _cam_inst.fade_hold_timer = 0;
                }
            }
        }
    }

    // ----------------------------------------------------
    // Lock player feet to requested contact point
    // ----------------------------------------------------
    if (!is_undefined(_lock_feet_y))
    {
        var dy = _lock_feet_y - bbox_bottom;
        y += dy;
    }

    state = "dead";

    // ----------------------------------------------------
    // Camera shake
    // ----------------------------------------------------
    var _shake_strength =
        variable_global_exists("death_shake_strength")
        ? global.death_shake_strength
        : 10;

    var _shake_frames =
        variable_global_exists("death_shake_frames")
        ? global.death_shake_frames
        : 14;

    if (!is_undefined(_shake_strength_override))
    {
        _shake_strength = _shake_strength_override;
    }

    if (!is_undefined(_shake_frames_override))
    {
        _shake_frames = _shake_frames_override;
    }

    global.shake_mag =
        max(0, round(_shake_strength));

    global.shake_time =
        max(0, round(_shake_frames));

    // ----------------------------------------------------
    // Stop normal movement
    // ----------------------------------------------------
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

    standing_platform = noone;

    // ----------------------------------------------------
    // Death animation
    // ----------------------------------------------------
    var death_sprite = asset_get_index("spriteBotDeath");

    if (death_sprite != -1)
    {
        sprite_index = death_sprite;
        image_index  = 0;
        image_speed  = 0.60;
        image_xscale = facing;
    }

    // ----------------------------------------------------
    // Begin death-animation delay
    // ----------------------------------------------------
    global.game_phase = "death_delay";

    if (instance_exists(oRunController))
    {
        var rc = instance_find(oRunController, 0);

        if (rc != noone)
        {
            var anim_frames = 1;

            if (death_sprite != -1)
            {
                anim_frames = sprite_get_number(death_sprite);
            }

            var anim_duration =
                ceil(anim_frames / max(0.01, image_speed));

            rc.death_delay_timer =
                max(
                    rc.death_delay_frames,
                    anim_duration
                );
        }
    }
    else
    {
        // Emergency fallback
        global.game_phase = "death_menu";

        if (!instance_exists(oDeathMenu))
        {
            var layer_name =
                layer_exists("GUI")
                ? "GUI"
                : "Instances";

            instance_create_layer(
                0,
                0,
                layer_name,
                oDeathMenu
            );
        }
    }
}