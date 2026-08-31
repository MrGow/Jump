/// oAdminLayerCannon — Create

event_inherited();

enabled = true;

solid_body = false;
solid_only_when_active = false;


// ====================================================
// SPRITES
// ====================================================

idle_sprite =
    spriteAdminLayerCannonPatrol;

shoot_sprite =
    spriteAdminLayerCannonShoot;

sprite_index =
    idle_sprite;

image_speed = 0;
image_index = 0;


// ====================================================
// SOUNDS
// ====================================================

snd_shoot =
[
    asset_get_index(
        "BouncingBallGunShoot1"
    ),

    asset_get_index(
        "BouncingBallGunShoot2"
    )
];


if (!variable_instance_exists(id, "shoot_sound_gain"))
{
    shoot_sound_gain = 1.0;
}


// ====================================================
// PLAY SHOOT SOUND
// ====================================================

play_shoot_sound = function()
{
    var valid_sounds = [];


    for (
        var i = 0;
        i < array_length(snd_shoot);
        i++
    )
    {
        if (snd_shoot[i] != -1)
        {
            array_push(
                valid_sounds,
                snd_shoot[i]
            );
        }
    }


    if (array_length(valid_sounds) <= 0)
    {
        return;
    }


    var snd =
        valid_sounds[
            irandom(
                array_length(valid_sounds) - 1
            )
        ];


    var voice =
        audio_play_sound(
            snd,
            100,
            false
        );


    if (voice != noone)
    {
        audio_sound_gain(
            voice,
            shoot_sound_gain,
            0
        );
    }
};


// ====================================================
// EDITOR VARIABLES
// ====================================================

// ----------------------------------------------------
// Direction
//
// 0 = west
// 1 = south-west
// 2 = south
// 3 = south-east
// 4 = east
// ----------------------------------------------------

if (!variable_instance_exists(id, "cannon_direction"))
{
    cannon_direction = 2;
}


// ----------------------------------------------------
// Time between shots
// ----------------------------------------------------

if (!variable_instance_exists(id, "shot_interval_s"))
{
    shot_interval_s = 2.0;
}


// ----------------------------------------------------
// Initial firing offset
// ----------------------------------------------------

if (!variable_instance_exists(id, "initial_delay_s"))
{
    initial_delay_s = 0;
}


// ----------------------------------------------------
// Shooting animation speed
// ----------------------------------------------------

if (!variable_instance_exists(id, "shoot_anim_speed"))
{
    shoot_anim_speed = 0.10;
}


// ----------------------------------------------------
// Projectile speed
// ----------------------------------------------------

if (!variable_instance_exists(id, "projectile_speed"))
{
    projectile_speed = 5.0;
}


// ----------------------------------------------------
// Projectile lifetime
// ----------------------------------------------------

if (!variable_instance_exists(id, "projectile_life_s"))
{
    projectile_life_s = 8.0;
}


// ----------------------------------------------------
// Bounce retention
// ----------------------------------------------------

if (!variable_instance_exists(id, "bounce_retention"))
{
    bounce_retention = 1.0;
}


// ----------------------------------------------------
// Projectile sprite frame
// ----------------------------------------------------

if (!variable_instance_exists(id, "projectile_frame"))
{
    projectile_frame = 0;
}


// ----------------------------------------------------
// Local release frame within each three-frame
// shooting sequence.
//
// 0 = first
// 1 = second
// 2 = third
// ----------------------------------------------------

if (!variable_instance_exists(id, "release_local_frame"))
{
    release_local_frame = 1;
}


// ----------------------------------------------------
// Final whole-cannon muzzle adjustment.
// ----------------------------------------------------

if (!variable_instance_exists(id, "muzzle_nudge_x"))
{
    muzzle_nudge_x = 4;
}


if (!variable_instance_exists(id, "muzzle_nudge_y"))
{
    muzzle_nudge_y = -4;
}


// ----------------------------------------------------
// Debug
// ----------------------------------------------------

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// VALIDATE SETTINGS
// ====================================================

bounce_retention =
    clamp(
        bounce_retention,
        0,
        1
    );


release_local_frame =
    clamp(
        round(release_local_frame),
        0,
        2
    );


// ====================================================
// EXACT MUZZLE OFFSETS
//
// Both cannon sprites use a Middle Centre origin.
//
// 0 = west
// 1 = south-west
// 2 = south
// 3 = south-east
// 4 = east
// ====================================================

muzzle_offset_x =
[
    -20,
    -14,
      0,
     14,
     20
];


muzzle_offset_y =
[
     0,
     7,
     9,
     7,
     0
];


// ====================================================
// DIRECTION REFRESH
// ====================================================

refresh_direction = function()
{
    cannon_direction =
        clamp(
            round(cannon_direction),
            0,
            4
        );


    switch (cannon_direction)
    {
        case 0:
            shot_angle = 180;
        break;

        case 1:
            shot_angle = 225;
        break;

        case 2:
            shot_angle = 270;
        break;

        case 3:
            shot_angle = 315;
        break;

        case 4:
            shot_angle = 0;
        break;
    }


    idle_frame =
        cannon_direction;


    shoot_start_frame =
        cannon_direction * 3;


    shoot_end_frame =
        shoot_start_frame + 2;


    shoot_release_frame =
        shoot_start_frame +
        release_local_frame;


    muzzle_x_offset =
        muzzle_offset_x[
            cannon_direction
        ];


    muzzle_y_offset =
        muzzle_offset_y[
            cannon_direction
        ];
};


refresh_direction();


// ====================================================
// TIMING
// ====================================================

shot_interval_frames =
    max(
        1,
        round(
            shot_interval_s *
            room_speed
        )
    );


initial_delay_frames =
    max(
        0,
        round(
            initial_delay_s *
            room_speed
        )
    );


shot_timer =
    shot_interval_frames +
    initial_delay_frames;


// ====================================================
// STATE
// ====================================================

state =
    "waiting";


projectile_released =
    false;


// ====================================================
// INITIAL VISUAL
// ====================================================

sprite_index =
    idle_sprite;


image_index =
    idle_frame;


image_speed =
    0;


// ====================================================
// SPAWN PHYSICAL SOLID HELPER
// ====================================================

solid_inst =
    instance_create_layer(
        x,
        y,
        "Instances",
        oAdminLayerCannonSolid
    );


if (solid_inst != noone)
{
    solid_inst.owner_cannon =
        id;


    solid_inst.x =
        x;


    solid_inst.y =
        y;


    solid_inst.enabled =
        enabled;


    solid_inst.active =
        enabled;


    solid_inst.debug_draw =
        debug_draw;
}