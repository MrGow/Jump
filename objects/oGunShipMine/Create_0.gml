/// oGunShipMine — Create


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    spriteGunShipMine;

image_speed = 0.50;
image_index = 0;

// Draw in front of train/environment.
depth = -50;


// ====================================================
// MOTION
// ====================================================

gravity_amount = 0.24;

hspeed = 0;
vspeed = 0;


// ====================================================
// STATE
//
// falling
// armed
// exploding
// ====================================================

state = "falling";

armed = false;


// ====================================================
// LANDING
// ====================================================

ground_check_distance = 4;


// ----------------------------------------------------
// Oblique-floor visual inset.
//
// Collision remains on the real floor.
// Mine artwork is drawn slightly lower so it visually
// sits properly inside the oblique train tiles.
// ----------------------------------------------------

ground_draw_inset = 13;

draw_ground_offset = 0;


// ----------------------------------------------------
// Brief safety delay after landing.
//
// Player cannot immediately trigger the mine on the
// exact frame it touches the floor.
// ----------------------------------------------------

arm_delay =
    round(
        room_speed *
        0.15
    );

arm_timer =
    arm_delay;


// ====================================================
// MINE LIFETIME
//
// Mine survives for this long after landing.
//
// 8 seconds total.
//
// Final 2.5 seconds use faster warning beeping.
// ====================================================

mine_lifetime =
    round(
        room_speed *
        6.0
    );


warning_time =
    round(
        room_speed *
        2.0
    );


life_timer =
    mine_lifetime;


warning_started =
    false;


// ====================================================
// SUBTLE LANDED MOVEMENT
// ====================================================

bob_t =
    random(
        1000
    );

bob_speed = 0.08;

// Keep tiny — mine should still look planted.
bob_amount = 1;

bob_offset = 0;


// ====================================================
// AUDIO
// ====================================================

snd_beep =
    MineBeepingLoop;

snd_explode =
    MineExplosion;


// ----------------------------------------------------
// Current looping beep instance
// ----------------------------------------------------

beep_instance =
    noone;

beep_paused =
    false;


// ----------------------------------------------------
// Maximum simultaneous audible mine loops.
//
// Prevents several mines stacking the same sound.
// ----------------------------------------------------

beep_max_voices = 2;


// ----------------------------------------------------
// Distance attenuation
// ----------------------------------------------------

beep_inner_dist = 100;

beep_outer_dist = 460;

beep_max_gain = 0.42;


// ----------------------------------------------------
// Normal beep pitch.
//
// Slight random variation prevents multiple mines from
// sounding perfectly phase-locked.
// ----------------------------------------------------

beep_pitch =
    random_range(
        0.97,
        1.03
    );


// ----------------------------------------------------
// Warning beep pitch.
//
// Higher pitch makes the looping beep cycle faster.
//
// If too frantic:
//     try 1.35 - 1.45
//
// If you want much more panic:
//     try 1.7 - 1.9
// ----------------------------------------------------

beep_warning_pitch = 1.60;


// ====================================================
// EXPLOSION
// ====================================================

explosion_sprite =
    spriteDeathExplosion;


// ----------------------------------------------------
// Explosion animation speed
// ----------------------------------------------------

explosion_image_speed = 1;


// ----------------------------------------------------
// Backup lifetime for explosion.
//
// The Step also destroys the mine when the explosion
// animation reaches its final frame.
//
// This exists as a safety fallback.
// ----------------------------------------------------

explosion_time =
    round(
        room_speed *
        1.0
    );

explosion_timer = 0;


// ====================================================
// EXPLOSION DRAW ANCHOR
//
// IMPORTANT:
//
// spriteGunShipMine:
//     Top Left origin
//
// spriteDeathExplosion:
//     Bottom Centre origin
//
// begin_explosion() stores the mine's visible
// bottom-centre here BEFORE swapping sprites.
//
// Draw then places the explosion's Bottom Centre origin
// at this point.
// ====================================================

explosion_draw_x = x;

explosion_draw_y = y;


// ====================================================
// GROUND TEST
// ====================================================

point_hits_ground =
function(_x, _y)
{
    // =================================================
    // SOLID TILEMAP
    // =================================================

    if (
        layer_exists(
            "Solids"
        )
    )
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
                    )
                    != 0
                )
                {
                    return true;
                }
            }
        }
    }


    // =================================================
    // DYNAMIC SOLIDS
    // =================================================

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
            )
            != noone
        )
        {
            return true;
        }
    }


    return false;
};