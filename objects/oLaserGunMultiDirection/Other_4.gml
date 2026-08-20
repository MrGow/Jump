// ============================================================================
// ROOM START
// ============================================================================

/// oLaserGunMultiDirection — Room Start


// ====================================================
// RESET PATROL
// ====================================================

patrol_start_x =
    x;

patrol_start_y =
    y;

patrol_end_x =
    x;

patrol_end_y =
    y;

patrol_t =
    0;

patrol_direction =
    1;


find_patrol_point();


// ====================================================
// RESET FIRING STATE
// ====================================================

active =
    false;

state =
    "waiting";

timer =
    wait_frames;

fire_timer =
    0;

laser_fx_frame =
    0;

laser_shot_sfx_played =
    false;

image_index =
    0;

image_speed =
    0;


for (
    var i = 0;
    i < laser_count;
    i++
)
{
    laser_len[i] =
        0;

    laser_start_x[i] =
        x;

    laser_start_y[i] =
        y;

    laser_end_x[i] =
        x;

    laser_end_y[i] =
        y;
}


// ====================================================
// REATTACH / CREATE SOLID HELPER
// ====================================================

if (
    !variable_instance_exists(
        id,
        "solid_inst"
    )
    ||
    !instance_exists(
        solid_inst
    )
)
{
    solid_inst =
        instance_create_layer(
            x,
            y,
            "Instances",
            oLaserGunMultiDirectionSolid
        );


    if (solid_inst != noone)
    {
        solid_inst.owner_gun =
            id;

        solid_inst.enabled =
            enabled;

        solid_inst.active =
            true;

        solid_inst.debug_draw =
            debug_draw;
    }
}


if (instance_exists(solid_inst))
{
    solid_inst.x =
        x;

    solid_inst.y =
        y;
}
