// ============================================================================
// oFloorSaw — Room Start
// ============================================================================

/// oFloorSaw — Room Start

patrol_start_x = x;
patrol_start_y = y;
patrol_end_x   = x;
patrol_end_y   = y;
patrol_point   = noone;
hold_timer     = 0;

find_patrol_point();
apply_facing();

if (
    patrol_enabled
    && instance_exists(patrol_point)
)
{
    if (hold_start_frames > 0)
    {
        patrol_state = "hold_start";
        hold_timer = hold_start_frames;
    }
    else
    {
        patrol_state = "to_end";
    }
}
else
{
    patrol_state = "stationary";
}

stop_saw_audio();