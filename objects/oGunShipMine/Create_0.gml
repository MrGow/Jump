/// oGunShipMine — Create

sprite_index = spriteGunShipMine;

image_speed = 0.20;
image_index = 0;


// ----------------------------------------------------
// Draw above train/floor tiles
// ----------------------------------------------------
depth = -100;


// ----------------------------------------------------
// Motion
// ----------------------------------------------------
gravity_amount = 0.24;

hspeed = 0;
vspeed = 0;


// ----------------------------------------------------
// Mine state
// ----------------------------------------------------
state = "falling";

// falling
// armed
// exploding


// ----------------------------------------------------
// Ground detection
// ----------------------------------------------------
ground_check_distance = 4;


// ----------------------------------------------------
// Armed behaviour
// ----------------------------------------------------
armed = false;

arm_delay =
    round(
        room_speed * 0.15
    );

arm_timer = arm_delay;


// ----------------------------------------------------
// Flash/beep
// ----------------------------------------------------
beep_timer = 0;

beep_interval =
    round(
        room_speed * 0.65
    );

beep_min_interval =
    round(
        room_speed * 0.18
    );


// ----------------------------------------------------
// Audio
// ----------------------------------------------------
snd_beep =
    MineBeepingLoop;

snd_explode =
    MineExplosion;


// Mine beep instance.
beep_instance = noone;
beep_paused = false;


// ----------------------------------------------------
// Collision
// ----------------------------------------------------
hit_padding = 2;


// ----------------------------------------------------
// Tiny visual bob after landing
// ----------------------------------------------------
bob_t = random(1000);
bob_speed = 0.08;
bob_amount = 1;

draw_offset_y = 0;


// ----------------------------------------------------
// Explosion placeholder
//
// We don't have the explosion sprite yet.
// ----------------------------------------------------
explosion_time =
    round(
        room_speed * 0.12
    );

explosion_timer = 0;


// ====================================================
// CHECK SOLID POINT
// ====================================================

point_hits_ground = function(_x, _y)
{
    // ------------------------------------------------
    // Tilemap
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