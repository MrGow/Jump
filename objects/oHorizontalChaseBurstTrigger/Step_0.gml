/// oHorizontalChaseBurstTrigger — Step

// Freeze trigger during pause/death
if (scr_game_frozen())
{
    exit;
}

if (activated)
{
    exit;
}

var p = instance_find(oPlayer, 0);

if (p == noone)
{
    exit;
}


// ----------------------------------------------------
// Activate once player crosses this X position
// ----------------------------------------------------
if (p.x >= x)
{
    var saw_obj =
        asset_get_index("oArea2ChasingSaws");

    if (saw_obj != -1)
    {
        var saw = instance_find(saw_obj, 0);

        if (saw != noone)
        {
            saw.burst_target =
                saw.burst_offset +
                burst_distance;

            saw.burst_speed  = burst_speed;
            saw.burst_active = true;
        }
    }

    activated = true;

    show_debug_message("HORIZONTAL SAW BURST");
}