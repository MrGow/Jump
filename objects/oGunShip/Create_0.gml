/// oGunShip — Create

// ====================================================
// BASIC SETUP
// ====================================================

sprite_index = spriteGunShip;
image_speed = 0;
image_index = 0;

depth = -1000;

enabled = true;


// ====================================================
// CONTROL
// ====================================================

ai_enabled = true;
scripted_override = false;


// ====================================================
// PLAYER
// ====================================================

target_player = noone;


// ====================================================
// CAMERA-SPACE HOVERING
//
// spriteGunShip origin:
// Middle Centre
//
// The ship should live in the upper part of the view,
// regardless of the player's vertical position.
// ====================================================

hover_target_x = x;
hover_target_y = y;

hover_hspeed = 0;
hover_vspeed = 0;

hover_follow_strength = 0.045;
hover_move_lerp = 0.08;

hover_max_speed = 4.5;


// Centre of gunship will normally sit this many pixels
// below the top edge of the camera.
//
// 82 on a 360px-high camera keeps it firmly within the
// upper third while leaving enough room for the sprite.
hover_screen_y = 82;


// Horizontal position relative to player.
reposition_side = choose(-1, 1);

reposition_distance_min = 90;
reposition_distance_max = 165;

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


// ====================================================
// AIRBORNE MOTION
// ====================================================

// Slow hovering drift.
hover_wave_t = random(1000);
hover_wave_speed = 0.035;

hover_wave_x = 9;
hover_wave_y = 4;


// Tiny VISUAL-only vibration.
jitter_amount = 1;

draw_jitter_x = 0;
draw_jitter_y = 0;


// ====================================================
// FACING
//
// Gunship artwork faces RIGHT at xscale 1.
// ====================================================

facing = 1;


// ====================================================
// MAIN STATE
// ====================================================

state = "hover";

state_timer = 0;


// ====================================================
// AUTONOMOUS ATTACK DELAYS
// ====================================================

attack_min_delay =
    round(room_speed * 1.4);

attack_max_delay =
    round(room_speed * 2.6);

attack_cooldown =
    round(room_speed * 2.0);


// ====================================================
// ATTACK CONSTANTS
// ====================================================

ATTACK_GUN   = 0;
ATTACK_MINE  = 1;
ATTACK_LASER = 2;

last_attack = -1;


// ====================================================
// ATTACHED GUN
//
// spriteGunShipGun custom origin:
// X = 13
// Y = 11
//
// That origin is the physical rotation joint.
// ====================================================

gun_sprite = spriteGunShipGun;


// ----------------------------------------------------
// Gun attachment point relative to gunship centre.
//
// These values put the pivot into the underside rather
// than floating below the ship.
//
// Fine tuning should only require changing these two.
// ----------------------------------------------------

gun_mount_offset_x = -2;
gun_mount_offset_y = 30;

gun_x = x;
gun_y = y;


// ----------------------------------------------------
// Rotation
//
// spriteGunShipGun visually points DOWN at angle 0.
//
// GameMaker world direction:
// 270 = downward
// ----------------------------------------------------

gun_angle = 270;
gun_draw_angle = 0;


// Gun is physically attached underneath the ship,
// therefore it may only rotate through the lower
// hemisphere.
//
// 0 = perfectly down.
// +/- 78 allows broad aiming without flipping upward.
gun_max_side_angle = 78;


gun_track_strength = 0.12;


// Pixel-art rotation stepping.
gun_visual_angle_step = 3;


// ====================================================
// SMALL GUN STATE
// ====================================================

gun_state = "idle";

// idle
// aiming
// locked
// firing
// cooldown

gun_target = noone;


gun_aim_frames =
    round(room_speed * 0.55);

gun_lock_frames =
    round(room_speed * 0.28);

gun_fire_frames =
    round(room_speed * 0.18);

gun_cooldown_frames =
    round(room_speed * 0.75);

gun_timer = 0;


// ====================================================
// SMALL GUN BEAM
// ====================================================

gun_beam_visible = false;
gun_beam_lethal = false;

gun_beam_length = 900;

gun_ray_step = 3;
gun_hit_pad = 4;

gun_laser_start_dist = 22;

gun_laser_start_x = x;
gun_laser_start_y = y;

gun_laser_end_x = x;
gun_laser_end_y = y;

gun_laser_len = 0;

gun_ray_sprite = spriteLaserGunRepeatingRay;
gun_end_sprite = spriteLaserGunShootEnd;

gun_laser_fx_frame = 0;

gun_laser_scroll = 0;
gun_laser_scroll_speed = 0.55;


// ====================================================
// GUN RECOIL
// ====================================================

gun_recoil = 0;
gun_recoil_max = 4;
gun_recoil_return = 0.4;


// ====================================================
// SMALL GUN AUDIO
// ====================================================

snd_gun_shoot = GunHazardShoot1;


// ====================================================
// MINES
//
// Disabled until oGunShipMine is created.
// ====================================================

mine_object = oGunShipMine;

mine_drop_count = 0;
mine_drop_total = 3;

mine_drop_delay =
    round(room_speed * 0.28);

mine_drop_timer = 0;


// Drop point underneath ship.
mine_mount_offset_x = 8;
mine_mount_offset_y = 34;

snd_drop_mine = GunShipDroppingMine;


// ====================================================
// HUGE LASER
// ====================================================

big_laser_sprite_start  = spriteGunShipLaserStart;
big_laser_sprite_middle = spriteGunShipLaserMiddle;
big_laser_sprite_end    = spriteGunShipLaserEnd;


// ----------------------------------------------------
// HUGE LASER MUZZLE
//
// spriteGunShip is 224x128 per frame with Middle Centre
// origin:
//
// centre = 112,64
//
// The large orange aperture is approximately:
//
// 155,73
//
// therefore:
//
// X offset = +43
// Y offset = +9
// ----------------------------------------------------

big_laser_offset_x = 43;
big_laser_offset_y = 20;


// Slight overlap between beam pieces prevents tiny
// transparent seams.
big_laser_tile_overlap = 2;


big_laser_start_x = x;
big_laser_start_y = y;

big_laser_end_x = x;
big_laser_end_y = y;

big_laser_len = 0;


big_laser_max_length = 1100;

big_laser_ray_step = 4;
big_laser_hit_pad = 7;


big_laser_visible = false;
big_laser_lethal = false;


// ====================================================
// HUGE LASER TIMING
// ====================================================

big_laser_reposition_frames =
    round(room_speed * 0.75);

big_laser_charge_frames =
    round(room_speed * 1.15);

big_laser_fire_frames =
    round(room_speed * 0.65);

big_laser_cooldown_frames =
    round(room_speed * 1.2);

big_laser_timer = 0;

big_laser_fx_frame = 0;


// ====================================================
// HUGE LASER SHAKE
// ====================================================

big_laser_shake_strength = 6;
big_laser_shake_frames = 7;

snd_big_laser = GunShipLaserShoot;


// ====================================================
// FLYING LOOP
// ====================================================

snd_flying_loop = GunShipFlyingLoop;

flying_loop_instance = noone;
flying_loop_paused = false;

flying_inner_dist = 160;
flying_outer_dist = 750;

flying_loop_gain = 0.90;


// ====================================================
// DISTANCE-BASED ONE-SHOT SFX
// ====================================================

play_gunship_sfx = function(_sound, _gain, _pitch)
{
    if (_sound == -1)
    {
        return;
    }

    var p =
        instance_find(
            oPlayer,
            0
        );

    if (p == noone)
    {
        return;
    }

    var dist =
        point_distance(
            x,
            y,
            p.x,
            p.y
        );

    if (dist >= flying_outer_dist)
    {
        return;
    }

    var dist_gain = 1;

    if (dist > flying_inner_dist)
    {
        var amount =
            (
                dist -
                flying_inner_dist
            )
            /
            max(
                1,
                flying_outer_dist -
                flying_inner_dist
            );

        dist_gain =
            1 -
            clamp(
                amount,
                0,
                1
            );
    }

    scr_play_sfx(
        _sound,
        _gain * dist_gain,
        _pitch
    );
};


// ====================================================
// CLAMP GUN TO UNDERSIDE
// ====================================================

clamp_gun_angle = function(_desired_angle)
{
    // Convert angle into a signed offset around DOWN.
    //
    // Down = 270
    //
    // Result becomes approximately -180...180.
    var relative =
        (
            (
                _desired_angle -
                270 +
                540
            )
            mod
            360
        )
        -
        180;


    relative =
        clamp(
            relative,
            -gun_max_side_angle,
            gun_max_side_angle
        );


    var result =
        270 +
        relative;


    if (result < 0)
    {
        result += 360;
    }

    if (result >= 360)
    {
        result -= 360;
    }


    return result;
};


// ====================================================
// SMOOTH ANGLE APPROACH
// ====================================================

approach_gun_angle = function(_current, _target, _amount)
{
    var difference =
        (
            (
                _target -
                _current +
                540
            )
            mod
            360
        )
        -
        180;


    var result =
        _current +
        difference *
        _amount;


    if (result < 0)
    {
        result += 360;
    }

    if (result >= 360)
    {
        result -= 360;
    }


    return result;
};


// ====================================================
// LASER SOLID TEST
// ====================================================

gunship_point_hits_solid = function(_x, _y)
{
    // ------------------------------------------------
    // Main solid tilemap
    // ------------------------------------------------

    if (layer_exists("Solids"))
    {
        var layer_id =
            layer_get_id(
                "Solids"
            );

        if (layer_id != -1)
        {
            var tilemap_id =
                layer_tilemap_get_id(
                    layer_id
                );

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


    // ------------------------------------------------
    // Dynamic solids
    // ------------------------------------------------

    var dyn_obj =
        asset_get_index(
            "oSolidDyn"
        );

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


    return false;
};


// ====================================================
// UPDATE SMALL GUN LASER
// ====================================================

update_gun_beam = function(_can_kill)
{
    gun_laser_start_x =
        gun_x +
        lengthdir_x(
            gun_laser_start_dist,
            gun_angle
        );

    gun_laser_start_y =
        gun_y +
        lengthdir_y(
            gun_laser_start_dist,
            gun_angle
        );


    var dir_x =
        lengthdir_x(
            1,
            gun_angle
        );

    var dir_y =
        lengthdir_y(
            1,
            gun_angle
        );


    gun_laser_len =
        gun_beam_length;


    gun_laser_end_x =
        gun_laser_start_x +
        dir_x *
        gun_laser_len;

    gun_laser_end_y =
        gun_laser_start_y +
        dir_y *
        gun_laser_len;


    var p =
        instance_find(
            oPlayer,
            0
        );


    for (
        var dist = 0;
        dist <= gun_beam_length;
        dist += gun_ray_step
    )
    {
        var test_x =
            gun_laser_start_x +
            dir_x *
            dist;

        var test_y =
            gun_laser_start_y +
            dir_y *
            dist;


        if (
            gunship_point_hits_solid(
                test_x,
                test_y
            )
        )
        {
            gun_laser_len = dist;

            gun_laser_end_x = test_x;
            gun_laser_end_y = test_y;

            break;
        }


        if (
            _can_kill &&
            p != noone &&
            !(
                variable_instance_exists(
                    p,
                    "state"
                )
                &&
                p.state == "dead"
            )
        )
        {
            var hit =
                (
                    test_x +
                    gun_hit_pad >
                    p.bbox_left
                )
                &&
                (
                    test_x -
                    gun_hit_pad <
                    p.bbox_right
                )
                &&
                (
                    test_y +
                    gun_hit_pad >
                    p.bbox_top
                )
                &&
                (
                    test_y -
                    gun_hit_pad <
                    p.bbox_bottom
                );


            if (hit)
            {
                with (p)
                {
                    scr_player_died();
                }

                gun_laser_len = dist;

                gun_laser_end_x = test_x;
                gun_laser_end_y = test_y;

                break;
            }
        }
    }
};


// ====================================================
// UPDATE HUGE LASER
//
// Unlike the small swivel-gun beam, the gunship's
// enormous main laser is NOT stopped by normal solid
// tiles.
//
// It visually passes over/in front of the train scenery
// and only tests against the player.
//
// This makes it behave like the boss-scale attack it is
// rather than like a normal environmental laser.
// ====================================================

update_big_laser = function(_can_kill)
{
    // ------------------------------------------------
    // Muzzle position
    // ------------------------------------------------
    big_laser_start_x =
        x +
        big_laser_offset_x *
        facing;

    big_laser_start_y =
        y +
        big_laser_offset_y;


    // ------------------------------------------------
    // Full beam length
    // ------------------------------------------------
    big_laser_len =
        big_laser_max_length;


    big_laser_end_x =
        big_laser_start_x +
        big_laser_len *
        facing;

    big_laser_end_y =
        big_laser_start_y;


    // ------------------------------------------------
    // Player
    // ------------------------------------------------
    var p =
        instance_find(
            oPlayer,
            0
        );


    if (
        !_can_kill ||
        p == noone
    )
    {
        return;
    }


    if (
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead"
    )
    {
        return;
    }


    // ------------------------------------------------
    // Test along beam against PLAYER ONLY
    //
    // The floor/train/environment does not shorten the
    // huge laser.
    // ------------------------------------------------
    for (
        var dist = 0;
        dist <= big_laser_max_length;
        dist += big_laser_ray_step
    )
    {
        var test_x =
            big_laser_start_x +
            dist *
            facing;

        var test_y =
            big_laser_start_y;


        var hit =
            (
                test_x +
                big_laser_hit_pad >
                p.bbox_left
            )
            &&
            (
                test_x -
                big_laser_hit_pad <
                p.bbox_right
            )
            &&
            (
                test_y +
                big_laser_hit_pad >
                p.bbox_top
            )
            &&
            (
                test_y -
                big_laser_hit_pad <
                p.bbox_bottom
            );


        if (hit)
        {
            with (p)
            {
                scr_player_died();
            }

            break;
        }
    }
};


// ====================================================
// ATTACK HELPERS
// ====================================================

start_gun_attack = function()
{
    state = "gun_attack";

    gun_state = "aiming";

    gun_timer =
        gun_aim_frames;

    gun_target =
        instance_find(
            oPlayer,
            0
        );

    gun_beam_visible = false;
    gun_beam_lethal = false;

    last_attack = ATTACK_GUN;
};


start_mine_attack = function()
{
    if (mine_object == -1)
    {
        state = "hover";

        attack_cooldown =
            irandom_range(
                attack_min_delay,
                attack_max_delay
            );

        return;
    }


    state = "mine_attack";

    mine_drop_count = 0;
    mine_drop_timer = 1;

    last_attack = ATTACK_MINE;
};


start_big_laser_attack = function()
{
    state =
        "big_laser_reposition";

    big_laser_timer =
        big_laser_reposition_frames;

    big_laser_visible = false;
    big_laser_lethal = false;

    last_attack = ATTACK_LASER;
};


// ====================================================
// RESPAWN RESET
// ====================================================

reset_gunship = function()
{
    state = "hover";

    state_timer = 0;


    attack_cooldown =
        round(
            room_speed *
            1.5
        );


    gun_state = "idle";
    gun_timer = 0;

    gun_angle = 270;
    gun_draw_angle = 0;

    gun_beam_visible = false;
    gun_beam_lethal = false;

    gun_recoil = 0;


    big_laser_visible = false;
    big_laser_lethal = false;
    big_laser_len = 0;


    mine_drop_count = 0;
    mine_drop_timer = 0;
};


// ====================================================
// BOSS ENCOUNTER
// ====================================================

boss_controller = noone;
boss_trigger = noone;
boss_exposed_frames = round(room_speed * 10);
boss_exposed_timer = 0;
boss_recovery_speed = 4;
boss_fall_speed = 0;
boss_crash_floor_y = y;
boss_weak_anim_speed = 0.25;
boss_weak_hold_frame = 9; // GameMaker image_index, zero-based
boss_weak_last_frame = min(15, sprite_get_number(spriteGunShipWeakened) - 1);
boss_defeated_pending = false;
boss_hit_flash_timer = 0;

// Frame 9's bright orb occupies approximately X=80..112,
// Y=11..43 on the 224x128 canvas. Origin is (112,64).
// facing mirrors the X offset in the Step event.
boss_weak_offset_x = -16;
boss_weak_offset_y = -37;
boss_weak_half_w = 17;
boss_weak_half_h = 17;

boss_clear_attacks = function()
{
    ai_enabled = false;
    gun_state = "idle";
    gun_timer = 0;
    gun_beam_visible = false;
    gun_beam_lethal = false;
    gun_laser_len = 0;
    big_laser_visible = false;
    big_laser_lethal = false;
    big_laser_len = 0;
    mine_drop_timer = 0;
    mine_drop_count = 0;
};

boss_begin_recovery = function()
{
    boss_exposed_timer = 0;
    state = "boss_recovering";
    boss_clear_attacks();
    sprite_index = spriteGunShip;
    image_index = 0;
    image_speed = 0;
};

boss_begin_retraction = function()
{
    boss_exposed_timer = 0;
    state = "boss_retracting";
    // Image index remains at the raised, held frame 9.
    image_index = boss_weak_hold_frame;
    image_speed = 0;
};

boss_on_missile_hit = function()
{
    if (!instance_exists(boss_controller)) return;
    if (state == "boss_crashing" ||
        state == "boss_exposed" ||
        state == "boss_retracting" ||
        state == "boss_recovering") return;

    boss_clear_attacks();
    with (oGunShipMine) instance_destroy();

    sprite_index = spriteGunShipWeakened;
    image_index = 0;
    image_speed = 0;

    gun_angle = 270;
    gun_draw_angle = 0;
    gun_recoil = 0;
    boss_fall_speed = 0;
    boss_defeated_pending = false;

    // Sprite origins should both be Middle Centre. The bbox value
    // gives the visible body's bottom relative to that origin.
    var body_bottom_offset =
        sprite_get_bbox_bottom(spriteGunShipWeakened) -
        sprite_get_yoffset(spriteGunShipWeakened);

    // Downward-only fallback if the Solids tilemap is absent.
    boss_crash_floor_y = max(y, boss_controller.y);

    if (layer_exists("Solids"))
    {
        var solid_layer = layer_get_id("Solids");
        var solid_map = layer_tilemap_get_id(solid_layer);

        if (solid_map != -1)
        {
            var first_y = max(0, ceil(y + body_bottom_offset));
            for (var probe_y = first_y; probe_y < room_height; probe_y++)
            {
                var tile_data = tilemap_get_at_pixel(
                    solid_map, boss_controller.x, probe_y);

                if (tile_data != 0 && tile_data != -1)
                {
                    boss_crash_floor_y = max(
                        y, probe_y - body_bottom_offset);
                    break;
                }
            }
        }
    }

    state = "boss_crashing";
};

boss_on_weakpoint_hit = function()
{
    if (state != "boss_exposed" ||
        !instance_exists(boss_controller)) return;

    // Leave exposure at once: only one hit per missile.
    boss_controller.hp = max(0, boss_controller.hp - 1);
    boss_defeated_pending = (boss_controller.hp <= 0);
    boss_hit_flash_timer = max(1, round(room_speed * 0.16));

    if (!variable_global_exists("shake_mag")) global.shake_mag = 0;
    if (!variable_global_exists("shake_time")) global.shake_time = 0;
    global.shake_mag = max(global.shake_mag, 6);
    global.shake_time = max(global.shake_time, 9);

    boss_begin_retraction();
};
