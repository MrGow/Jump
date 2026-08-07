/// oLaserGunMultiDirection — Room Start

patrol_start_x = x;
patrol_start_y = y;

patrol_end_x = x;
patrol_end_y = y;

patrol_t = 0;
patrol_direction = 1;

find_patrol_point();


// ----------------------------------------------------
// Reattach/create solid helper if needed
// ----------------------------------------------------
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
        solid_inst.owner_gun = id;

        solid_inst.enabled =
            enabled;

        solid_inst.active =
            true;

        solid_inst.debug_draw =
            debug_draw;
    }
}