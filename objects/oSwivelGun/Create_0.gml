/// oSwivelGun — Create

event_inherited();

enabled = true;
active  = true;

solid_body = false;
solid_only_when_active = false;

depth = -100;

// ----------------------------------------------------
// Sprites
//
// Draw order:
// 1. rear mounting base
// 2. beam
// 3. rotating gun
// 4. front mounting cover
// ----------------------------------------------------
gun_base_sprite = asset_get_index("spriteGunBase");
gun_sprite      = asset_get_index("spriteGun");
gun_top_sprite  = asset_get_index("spriteGunTop");

ray_sprite = asset_get_index("spriteLaserGunRepeatingRay");
end_sprite = asset_get_index("spriteLaserGunShootEnd");

// Everything is drawn manually.
sprite_index = gun_sprite;
mask_index   = -1;

image_speed = 0;
image_index = 0;

// ----------------------------------------------------
// Mount direction
//
// Editor variable:
// "ceiling"
// "floor"
// "left"
// "right"
// ----------------------------------------------------
if (!variable_instance_exists(id, "mount_direction"))
{
    mount_direction = "ceiling";
}

// GameMaker world directions:
// 0   = right
// 90  = up
// 180 = left
// 270 = down
//
// spriteGun faces downward at draw angle 0.
beam_center_angle = 270;
base_draw_angle   = 0;

switch (string_lower(string(mount_direction)))
{
    case "floor":
        beam_center_angle = 90;
        base_draw_angle   = 180;
    break;

    case "left":
        beam_center_angle = 0;
        base_draw_angle   = 270;
    break;

    case "right":
        beam_center_angle = 180;
        base_draw_angle   = 90;
    break;

    case "ceiling":
    default:
        beam_center_angle = 270;
        base_draw_angle   = 0;
    break;
}

// ----------------------------------------------------
// Patrol
// ----------------------------------------------------
if (!variable_instance_exists(id, "patrol_arc"))
{
    patrol_arc = 180;
}

if (!variable_instance_exists(id, "patrol_speed"))
{
    patrol_speed = 1.0;
}

if (!variable_instance_exists(id, "patrol_start_offset"))
{
    patrol_start_offset = 0;
}

patrol_half_arc = clamp(
    patrol_arc * 0.5,
    1,
    90
);

patrol_offset = clamp(
    patrol_start_offset,
    -patrol_half_arc,
    patrol_half_arc
);

patrol_direction = 1;

beam_angle =
    beam_center_angle +
    patrol_offset;

// ----------------------------------------------------
// Pixel-art visual rotation
//
// Beam stays smooth.
// Gun sprite rotates in stepped angles.
// ----------------------------------------------------
if (!variable_instance_exists(id, "gun_visual_angle_step"))
{
    gun_visual_angle_step = 3;
}

gun_target_draw_angle =
    beam_angle - 270;

var initial_visual_step =
    max(1, gun_visual_angle_step);

gun_draw_angle =
    round(
        gun_target_draw_angle /
        initial_visual_step
    ) * initial_visual_step;

// ----------------------------------------------------
// State machine
// ----------------------------------------------------
state = "patrol";
// patrol, alert, firing, cooldown

if (!variable_instance_exists(id, "alert_time_s"))
{
    alert_time_s = 0.45;
}

if (!variable_instance_exists(id, "cooldown_time_s"))
{
    cooldown_time_s = 0.65;
}

alert_frames = max(
    1,
    round(room_speed * alert_time_s)
);

cooldown_frames = max(
    1,
    round(room_speed * cooldown_time_s)
);

state_timer = 0;

// Store the player detected by the scan beam.
alert_target = noone;

// The exact angle where detection happened.
alert_start_angle = beam_angle;

// ----------------------------------------------------
// Alert aiming polish
// ----------------------------------------------------
if (!variable_instance_exists(id, "alert_track_strength"))
{
    alert_track_strength = 0.18;
}

// Maximum amount the gun may adjust toward the player.
if (!variable_instance_exists(id, "alert_max_adjust"))
{
    alert_max_adjust = 12;
}

// Small mechanical overshoot before settling.
if (!variable_instance_exists(id, "alert_overshoot_degrees"))
{
    alert_overshoot_degrees = 3;
}

if (!variable_instance_exists(id, "alert_overshoot_time"))
{
    alert_overshoot_time = 0.30;
}

alert_elapsed = 0;

// ----------------------------------------------------
// Shooting animation
// ----------------------------------------------------
if (!variable_instance_exists(id, "shoot_anim_speed"))
{
    shoot_anim_speed = 0.35;
}

if (!variable_instance_exists(id, "shoot_active_from"))
{
    shoot_active_from = 5;
}

if (!variable_instance_exists(id, "shoot_active_to"))
{
    shoot_active_to = 8;
}

// ----------------------------------------------------
// Recoil
// ----------------------------------------------------
if (!variable_instance_exists(id, "gun_recoil_max"))
{
    gun_recoil_max = 4;
}

if (!variable_instance_exists(id, "gun_recoil_return"))
{
    gun_recoil_return = 0.35;
}

gun_recoil = 0;
recoil_triggered = false;

// ----------------------------------------------------
// Screen shake
// ----------------------------------------------------
if (!variable_instance_exists(id, "shoot_shake_strength"))
{
    shoot_shake_strength = 3;
}

if (!variable_instance_exists(id, "shoot_shake_frames"))
{
    shoot_shake_frames = 5;
}

// ----------------------------------------------------
// Beam
// ----------------------------------------------------
if (!variable_instance_exists(id, "max_laser_length"))
{
    max_laser_length = 700;
}

if (!variable_instance_exists(id, "laser_start_dist"))
{
    laser_start_dist = 38;
}

if (!variable_instance_exists(id, "ray_step"))
{
    ray_step = 3;
}

if (!variable_instance_exists(id, "scan_hit_pad"))
{
    scan_hit_pad = 2;
}

if (!variable_instance_exists(id, "fire_hit_pad"))
{
    fire_hit_pad = 4;
}

laser_start_x = x;
laser_start_y = y;

laser_end_x = x;
laser_end_y = y;

laser_len = 0;

beam_visible = true;
beam_lethal  = false;

beam_hit_player = noone;

// ----------------------------------------------------
// Beam animation and pulse
// ----------------------------------------------------
laser_fx_frame = 0;
laser_scroll   = 0;
scan_pulse_t   = random(1000);

if (!variable_instance_exists(id, "laser_scroll_speed"))
{
    laser_scroll_speed = 0.35;
}

if (!variable_instance_exists(id, "scan_pulse_speed"))
{
    scan_pulse_speed = 0.10;
}

if (!variable_instance_exists(id, "scan_alpha_min"))
{
    scan_alpha_min = 0.55;
}

if (!variable_instance_exists(id, "scan_alpha_max"))
{
    scan_alpha_max = 0.82;
}

// ----------------------------------------------------
// Beam glow
// ----------------------------------------------------
if (!variable_instance_exists(id, "scan_glow_alpha"))
{
    scan_glow_alpha = 0.12;
}

if (!variable_instance_exists(id, "fire_glow_alpha"))
{
    fire_glow_alpha = 0.26;
}

if (!variable_instance_exists(id, "scan_glow_width"))
{
    scan_glow_width = 4;
}

if (!variable_instance_exists(id, "fire_glow_width"))
{
    fire_glow_width = 7;
}

// ----------------------------------------------------
// Beam colours
// ----------------------------------------------------
scan_beam_colour =
    make_color_rgb(80, 255, 110);

fire_beam_colour =
    make_color_rgb(255, 55, 45);

// ----------------------------------------------------
// Existing SFX
// ----------------------------------------------------
snd_patrol_loop =
    asset_get_index("GunHazardMovingLoop1");

snd_alert =
    asset_get_index("GunHazardAlert1");

snd_shoot =
    asset_get_index("GunHazardShoot1");

patrol_loop_instance = noone;
patrol_loop_paused   = false;

if (!variable_instance_exists(id, "patrol_loop_gain"))
{
    patrol_loop_gain = 0.20;
}

if (!variable_instance_exists(id, "alert_gain"))
{
    alert_gain = 0.65;
}

if (!variable_instance_exists(id, "shoot_gain"))
{
    shoot_gain = 0.80;
}

if (!variable_instance_exists(id, "sfx_inner_dist"))
{
    sfx_inner_dist = 120;
}

if (!variable_instance_exists(id, "sfx_outer_dist"))
{
    sfx_outer_dist = 480;
}

if (!variable_instance_exists(id, "patrol_loop_max_voices"))
{
    patrol_loop_max_voices = 2;
}

// ----------------------------------------------------
// Respawn safety
// ----------------------------------------------------
if (!variable_instance_exists(id, "respawn_safe_time_s"))
{
    respawn_safe_time_s = 1.0;
}

respawn_safe_frames = max(
    1,
    round(room_speed * respawn_safe_time_s)
);

respawn_safe_timer = 0;

// ----------------------------------------------------
// Distance-based one-shot sound helper
// ----------------------------------------------------
play_dist_sfx = function(_sound, _gain, _pitch)
{
    if (_sound == -1) return;

    var p = instance_find(oPlayer, 0);
    if (p == noone) return;

    var dist = point_distance(
        x,
        y,
        p.x,
        p.y
    );

    if (dist >= sfx_outer_dist) return;

    var dist_gain = 1;

    if (dist > sfx_inner_dist)
    {
        var amount =
            (dist - sfx_inner_dist) /
            max(
                1,
                sfx_outer_dist -
                sfx_inner_dist
            );

        dist_gain =
            1 - clamp(amount, 0, 1);
    }

    scr_play_sfx(
        _sound,
        _gain * dist_gain,
        _pitch
    );
};

// ----------------------------------------------------
// Point-based beam obstruction
// ----------------------------------------------------
beam_point_hits_solid = function(_x, _y)
{
    // Solid tilemap
    if (layer_exists("Solids"))
    {
        var layer_id =
            layer_get_id("Solids");

        if (layer_id != -1)
        {
            var tilemap_id =
                layer_tilemap_get_id(layer_id);

            if (tilemap_id != -1)
            {
                if (
                    tilemap_get_at_pixel(
                        tilemap_id,
                        _x,
                        _y
                    ) != 0
                )
                {
                    return true;
                }
            }
        }
    }

    // Dynamic solids
    var dyn_obj =
        asset_get_index("oSolidDyn");

    if (dyn_obj != -1)
    {
        if (
            instance_position(
                _x,
                _y,
                dyn_obj
            ) != noone
        )
        {
            return true;
        }
    }

    // Solid hazards
    var hazard_obj =
        asset_get_index("oHazard");

    if (hazard_obj != -1)
    {
        var hz =
            instance_position(
                _x,
                _y,
                hazard_obj
            );

        if (hz != noone && hz != id)
        {
            var hz_enabled =
                !variable_instance_exists(
                    hz,
                    "enabled"
                ) ||
                hz.enabled;

            var hz_solid =
                variable_instance_exists(
                    hz,
                    "solid_body"
                ) &&
                hz.solid_body;

            var hz_active = true;

            if (
                variable_instance_exists(
                    hz,
                    "solid_only_when_active"
                ) &&
                hz.solid_only_when_active
            )
            {
                hz_active =
                    variable_instance_exists(
                        hz,
                        "active"
                    ) &&
                    hz.active;
            }

            if (
                hz_enabled &&
                hz_solid &&
                hz_active
            )
            {
                return true;
            }
        }
    }

    return false;
};

// ----------------------------------------------------
// Recalculate beam and optionally detect player
// ----------------------------------------------------
update_beam = function(_test_player, _hit_padding)
{
    var dir_x =
        lengthdir_x(1, beam_angle);

    var dir_y =
        lengthdir_y(1, beam_angle);

    laser_start_x =
        x +
        lengthdir_x(
            laser_start_dist,
            beam_angle
        );

    laser_start_y =
        y +
        lengthdir_y(
            laser_start_dist,
            beam_angle
        );

    laser_end_x =
        laser_start_x +
        dir_x * max_laser_length;

    laser_end_y =
        laser_start_y +
        dir_y * max_laser_length;

    laser_len = max_laser_length;
    beam_hit_player = noone;

    var p = instance_find(oPlayer, 0);

    var player_valid =
        _test_player &&
        p != noone &&
        !(
            variable_instance_exists(
                p,
                "state"
            ) &&
            p.state == "dead"
        );

    for (
        var dist = 0;
        dist <= max_laser_length;
        dist += ray_step
    )
    {
        var test_x =
            laser_start_x +
            dir_x * dist;

        var test_y =
            laser_start_y +
            dir_y * dist;

        if (
            beam_point_hits_solid(
                test_x,
                test_y
            )
        )
        {
            laser_len   = dist;
            laser_end_x = test_x;
            laser_end_y = test_y;
            break;
        }

        if (player_valid)
        {
            var pad = _hit_padding;

            var player_hit =
                (test_x + pad > p.bbox_left) &&
                (test_x - pad < p.bbox_right) &&
                (test_y + pad > p.bbox_top) &&
                (test_y - pad < p.bbox_bottom);

            if (player_hit)
            {
                beam_hit_player = p;

                laser_len   = dist;
                laser_end_x = test_x;
                laser_end_y = test_y;

                break;
            }
        }
    }
};

// ----------------------------------------------------
// Reset after respawn
// ----------------------------------------------------
reset_gun = function()
{
    state = "patrol";
    state_timer = 0;

    image_speed = 0;
    image_index = 0;

    beam_visible = true;
    beam_lethal  = false;

    beam_hit_player = noone;
    alert_target    = noone;

    laser_len      = 0;
    laser_fx_frame = 0;
    laser_scroll   = 0;

    gun_recoil = 0;
    recoil_triggered = false;

    alert_elapsed = 0;

    patrol_offset = clamp(
        patrol_start_offset,
        -patrol_half_arc,
        patrol_half_arc
    );

    patrol_direction = 1;

    beam_angle =
        beam_center_angle +
        patrol_offset;

    alert_start_angle = beam_angle;

    gun_target_draw_angle =
        beam_angle - 270;

    var visual_step =
        max(1, gun_visual_angle_step);

    gun_draw_angle =
        round(
            gun_target_draw_angle /
            visual_step
        ) * visual_step;

    respawn_safe_timer =
        respawn_safe_frames;

    if (patrol_loop_instance != noone)
    {
        audio_stop_sound(
            patrol_loop_instance
        );

        patrol_loop_instance = noone;
    }

    patrol_loop_paused = false;
};

debug_draw = false;