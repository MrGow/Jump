/// oGunShipMine — Create

sprite_index = spriteGunShipMine;

image_speed = 0.20;
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
// ====================================================

state = "falling";

// falling
// armed
// exploding

armed = false;


// ====================================================
// LANDING
// ====================================================

ground_check_distance = 4;


// ----------------------------------------------------
// Oblique-floor visual inset.
//
// Keep the actual collision position on the floor.
// Only draw the landed mine 16px lower so it visually
// sits inside the oblique train tiles like the player.
// ----------------------------------------------------

ground_draw_inset = 16;

draw_ground_offset = 0;


// Brief safety delay after landing.
arm_delay =
    round(
        room_speed * 0.15
    );

arm_timer = arm_delay;


// ====================================================
// SUBTLE LANDED MOVEMENT
// ====================================================

bob_t = random(1000);

bob_speed = 0.08;

// Keep this very small because the mine should look
// attached to the train once it lands.
bob_amount = 1;

bob_offset = 0;


// ====================================================
// AUDIO
// ====================================================

snd_beep = MineBeepingLoop;
snd_explode = MineExplosion;


// Current looping beep instance.
beep_instance = noone;

beep_paused = false;


// Maximum number of simultaneously audible mine loops.
beep_max_voices = 2;


// Distance attenuation.
beep_inner_dist = 100;
beep_outer_dist = 460;

beep_max_gain = 0.42;


// Slight per-mine variation avoids perfect phase/pitch
// stacking when two mines are audible.
beep_pitch =
    random_range(
        0.97,
        1.03
    );


// ====================================================
// EXPLOSION
// ====================================================

// Placeholder until an explosion animation is added.
explosion_time =
    round(
        room_speed * 0.12
    );

explosion_timer = 0;


// ====================================================
// GROUND TEST
// ====================================================

point_hits_ground = function(_x, _y)
{
    // ------------------------------------------------
    // Solid tilemap
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